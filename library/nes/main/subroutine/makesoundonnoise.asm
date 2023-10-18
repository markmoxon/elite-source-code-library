\ ******************************************************************************
\
\       Name: MakeSoundOnNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the current sound effect on the NOISE channel
\
\ ******************************************************************************

.MakeSoundOnNOISE

 LDA effectOnNOISE      \ If effectOnNOISE is non-zero then a sound effect is
 BNE msct1              \ being made on channel NOISE, so jump to msct1 to keep
                        \ making it

 RTS                    \ Otherwise return from the subroutine

.msct1

 LDA soundByteNOISE+0   \ If the remaining number of iterations for this sound
 BNE msct3              \ effect in sound byte #0 is non-zero, jump to msct3 to
                        \ keep making the sound

 LDX soundByteNOISE+12  \ If byte #12 of the sound effect data is non-zero, then
 BNE msct3              \ this sound effect keeps looping, so jump to msct3 to
                        \ keep making the sound

 LDA enableSound        \ If enableSound = 0 then sound is disabled, so jump to
 BEQ msct2              \ msct2 to silence the NOISE channel and return from the
                        \ subroutine

                        \ If we get here then we have finished making the sound
                        \ effect, so we now send the volume and pitch values for
                        \ the music to the APU, so if there is any music playing
                        \ it will pick up again, and we mark this sound channel
                        \ as clear of sound effects

 LDA noiseVolume        \ Send noiseVolume to the APU via NOISE_VOL, which is
 STA NOISE_VOL          \ the volume byte of any music that was playing when the
                        \ sound effect took precedence

 LDA noiseLo            \ Send (noiseHi noiseLo) to the APU via NOISE_LO, which
 STA NOISE_LO           \ is the pitch of any music that was playing when the
                        \ sound effect took precedence

 STX effectOnNOISE      \ Set effectOnNOISE = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.msct2

                        \ If we get here then sound is disabled, so we need to
                        \ silence the NOISE channel

 LDA #%00110000         \ Set the volume of the NOISE channel to zero as
 STA NOISE_VOL          \ follows:
                        \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 STX effectOnNOISE      \ Set effectOnNOISE = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.msct3

                        \ If we get here then we need to keep making the sound
                        \ effect on channel NOISE

 DEC soundByteNOISE+0   \ Decrement the remaining length of the sound in byte #0
                        \ as we are about to make the sound for another
                        \ iteration

 DEC soundVolCountNOISE \ Decrement the volume envelope counter so we count down
                        \ towards the point where we apply the volume envelope

 BNE msct5              \ If the volume envelope counter has not reached zero
                        \ then jump to msct5, as we don't apply the next entry
                        \ from the volume envelope yet

                        \ If we get here then the counter in soundVolCountNOISE
                        \ just reached zero, so we apply the next entry from the
                        \ volume envelope

 LDA soundByteNOISE+11  \ Reset the volume envelope counter to byte #11 from the
 STA soundVolCountNOISE \ sound effect's data, which controls how often we apply
                        \ the volume envelope to the sound effect

 LDY soundVolIndexNOISE \ Set Y to the index of the current byte in the volume
                        \ envelope

 LDA soundVolumeNOISE   \ Set soundAddr(1 0) = soundVolumeNOISE(1 0)
 STA soundAddr          \
 LDA soundVolumeNOISE+1 \ So soundAddr(1 0) contains the address of the volume
 STA soundAddr+1        \ envelope for this sound effect

 LDA (soundAddr),Y      \ Set A to the data byte at the current index in the
                        \ volume envelope

 BPL msct4              \ If bit 7 is clear then we just fetched a volume value
                        \ from the envelope, so jump to msct4 to apply it

                        \ If we get here then A must be &80 or &FF, as those are
                        \ the only two valid entries in the volume envelope that
                        \ have bit 7 set
                        \
                        \ &80 means we loop back to the start of the envelope,
                        \ while &FF means the envelope ends here

 CMP #&80               \ If A is not &80 then we must have just fetched &FF
 BNE msct5              \ from the envelope, so jump to msct5 to exit the
                        \ envelope

                        \ If we get here then we just fetched a &80 from the
                        \ envelope data, so we now loop around to the start of
                        \ the envelope, so it keeps repeating

 LDY #0                 \ Set Y to zero so we fetch data from the start of the
                        \ envelope again

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into msct4 to process it

.msct4

                        \ If we get here then A contains an entry from the
                        \ volume envelope for this sound effect, so now we send
                        \ it to the APU to change the volume

 ORA soundByteNOISE+6   \ OR the envelope byte with the sound effect's byte #6,
 STA NOISE_VOL          \ and send the result to the APU via NOISE_VOL
                        \
                        \ Data bytes in the volume envelope data only use the
                        \ low nibble (the high nibble is only used to mark the
                        \ end of the data), and the sound effect's byte #6 only
                        \ uses the high nibble, so this sets the low nibble of
                        \ the APU byte to the volume level from the data, and
                        \ the high nibble of the APU byte to the configuration
                        \ in byte #6 (which sets the duty pulse, looping and
                        \ constant flags for the volume)

 INY                    \ Increment the index of the current byte in the volume
 STY soundVolIndexNOISE \ envelope so on the next iteration we move on to the
                        \ next byte in the envelope

.msct5

                        \ Now that we are done with the volume envelope, it's
                        \ time to move on to the pitch of the sound effect

 LDA soundPitCountNOISE \ If the byte #1 counter has not yet run down to zero,
 BNE msct8              \ jump to msct8 to skip the following, so we don't send
                        \ pitch data to the APU on this iteration

                        \ If we get here then the counter in soundPitCountNOISE
                        \ (which counts down from the value of byte #1) has run
                        \ down to zero, so we now send pitch data to the ALU if
                        \ if we haven't yet sent it all

 LDA soundByteNOISE+12  \ If byte #12 is non-zero then the sound effect loops
 BNE msct6              \ infinitely, so jump to msct6 to send pitch data to the
                        \ APU

 LDA soundByteNOISE+9   \ Otherwise, if the counter in byte #9 has not run down
 BNE msct6              \ then we haven't yet sent pitch data for enough
                        \ iterations, so jump to msct6 to send pitch data to the
                        \ APU

 RTS                    \ Return from the subroutine

.msct6

                        \ If we get here then we are sending pitch data to the
                        \ APU on this iteration, so now we do just that

 DEC soundByteNOISE+9   \ Decrement the counter in byte #9, which contains the
                        \ number of iterations for which we send pitch data to
                        \ the APU (as that's what we are doing)

 LDA soundByteNOISE+1   \ Reset the soundPitCountNOISE counter to the value of
 STA soundPitCountNOISE \ byte #1 so it can start counting down again to trigger
                        \ the next pitch change after this one

 LDA soundByteNOISE+2   \ Set A to the low byte of the sound effect's current
                        \ pitch, which is in byte #2 of the sound data

 LDX soundByteNOISE+7   \ If byte #7 is zero then vibrato is disabled, so jump
 BEQ msct7              \ to msct7 to skip the following instruction

 ADC soundVibrato       \ Byte #7 is non-zero, so add soundVibrato to the pitch
                        \ of the sound in A to apply vibrato (this also adds the
                        \ C flag, which is not in a fixed state, so this adds an
                        \ extra level of randomness to the vibrato effect)

 AND #%00001111         \ We extract the low nibble because the top nibble is
                        \ ignored in NOISE_LO, except for bit 7, which we want
                        \ to clear so the period of the random noise generation
                        \ is normal and not shortened

.msct7

 STA soundLoNOISE       \ Store the value of A (i.e. the low byte of the sound
                        \ effect's pitch, possibly with added vibrato) in
                        \ soundLoNOISE

 STA NOISE_LO           \ Send the value of soundLoNOISE to the APU via NOISE_LO

.msct8

 DEC soundPitCountNOISE \ Decrement the byte #1 counter, as we have now done one
                        \ more iteration of the sound effect

 LDA soundByteNOISE+13  \ If byte #13 of the sound data is zero then we apply
 BEQ msct9              \ pitch variation in every iteration (if enabled), so
                        \ jump to msct9 to skip the following and move straight
                        \ to the pitch variation checks

 DEC soundPitchEnvNOISE \ Otherwise decrement the byte #13 counter to count down
                        \ towards the point where we apply pitch variation

 BNE msct11             \ If the counter is not yet zero, jump to msct11 to
                        \ return from the subroutine without applying pitch
                        \ variation, as the counter has not yet reached that
                        \ point

                        \ If we get here then the byte #13 counter just ran down
                        \ to zero, so we need to apply pitch variation (if
                        \ enabled)

 STA soundPitchEnvNOISE \ Reset the soundPitchEnvNOISE counter to the value of
                        \ byte #13 so it can start counting down again, for the
                        \ next pitch variation after this one

.msct9

 LDA soundByteNOISE+8   \ Set A to byte #8 of the sound data, which determines
                        \ whether pitch variation is enabled

 BEQ msct11             \ If A is zero then pitch variation is not enabled, so
                        \ jump to msct11 to return from the subroutine without
                        \ applying pitch variation

                        \ If we get here then pitch variation is enabled, so now
                        \ we need to apply it

 BMI msct10             \ If A is negative then we need to add the value to the
                        \ pitch's period, so jump to msct10

                        \ If we get here then we need to subtract the 8-bit
                        \ value in byte #4 from the pitch's period in
                        \ soundLoNOISE
                        \
                        \ Reducing the pitch's period increases its frequency,
                        \ so this makes the note frequency higher

 LDA soundLoNOISE       \ Subtract the 8-bit value in byte #4 of the sound data
 SEC                    \ from soundLoNOISE, updating soundLoNOISE to the
 SBC soundByteNOISE+4   \ result, and sending it to the APU via NOISE_LO
 AND #&0F
 STA soundLoNOISE
 STA NOISE_LO

 RTS                    \ Return from the subroutine

.msct10

                        \ If we get here then we need to add the 8-bit value in
                        \ byte #4 to the pitch's period in soundLoNOISE
                        \
                        \ Increasing the pitch's period reduces its frequency,
                        \ so this makes the note frequency lower

 LDA soundLoNOISE       \ Add the 8-bit value in byte #4 of the sound data to
 CLC                    \ soundLoNOISE, updating soundLoNOISE to the result, and
 ADC soundByteNOISE+4   \ sending it to the APU via NOISE_LO
 AND #&0F
 STA soundLoNOISE
 STA NOISE_LO

.msct11

 RTS                    \ Return from the subroutine

