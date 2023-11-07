\ ******************************************************************************
\
\       Name: MakeSoundOnSQ2
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the current sound effect on the SQ2 channel
\  Deep dive: Sound effects in NES Elite
\
\ ******************************************************************************

.MakeSoundOnSQ2

 LDA effectOnSQ2        \ If effectOnSQ2 is non-zero then a sound effect is
 BNE msco1              \ being made on channel SQ2, so jump to msco1 to keep
                        \ making it

 RTS                    \ Otherwise return from the subroutine

.msco1

 LDA soundByteSQ2+0     \ If the remaining number of iterations for this sound
 BNE msco3              \ effect in sound byte #0 is non-zero, jump to msco3 to
                        \ keep making the sound

 LDX soundByteSQ2+12    \ If byte #12 of the sound effect data is non-zero, then
 BNE msco3              \ this sound effect keeps looping, so jump to msco3 to
                        \ keep making the sound

 LDA enableSound        \ If enableSound = 0 then sound is disabled, so jump to
 BEQ msco2              \ msco2 to silence the SQ2 channel and return from the
                        \ subroutine

                        \ If we get here then we have finished making the sound
                        \ effect, so we now send the volume and pitch values for
                        \ the music to the APU, so if there is any music playing
                        \ it will pick up again, and we mark this sound channel
                        \ as clear of sound effects

 LDA sq2Volume          \ Send sq2Volume to the APU via SQ2_VOL, which is the
 STA SQ2_VOL            \ volume byte of any music that was playing when the
                        \ sound effect took precedence

 LDA sq2Lo              \ Send (sq2Hi sq2Lo) to the APU via (SQ2_HI SQ2_LO),
 STA SQ2_LO             \ which is the pitch of any music that was playing when
 LDA sq2Hi              \ the sound effect took precedence
 STA SQ2_HI

 STX effectOnSQ2        \ Set effectOnSQ2 = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.msco2

                        \ If we get here then sound is disabled, so we need to
                        \ silence the SQ2 channel

 LDA #%00110000         \ Set the volume of the SQ2 channel to zero as follows:
 STA SQ2_VOL            \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 STX effectOnSQ2        \ Set effectOnSQ2 = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.msco3

                        \ If we get here then we need to keep making the sound
                        \ effect on channel SQ2

 DEC soundByteSQ2+0     \ Decrement the remaining length of the sound in byte #0
                        \ as we are about to make the sound for another
                        \ iteration

 DEC soundVolCountSQ2   \ Decrement the volume envelope counter so we count down
                        \ towards the point where we apply the volume envelope

 BNE msco5              \ If the volume envelope counter has not reached zero
                        \ then jump to msco5, as we don't apply the next entry
                        \ from the volume envelope yet

                        \ If we get here then the counter in soundVolCountSQ2
                        \ just reached zero, so we apply the next entry from the
                        \ volume envelope

 LDA soundByteSQ2+11    \ Reset the volume envelope counter to byte #11 from the
 STA soundVolCountSQ2   \ sound effect's data, which controls how often we apply
                        \ the volume envelope to the sound effect

 LDY soundVolIndexSQ2   \ Set Y to the index of the current byte in the volume
                        \ envelope

 LDA soundVolumeSQ2     \ Set soundAddr(1 0) = soundVolumeSQ2(1 0)
 STA soundAddr          \
 LDA soundVolumeSQ2+1   \ So soundAddr(1 0) contains the address of the volume
 STA soundAddr+1        \ envelope for this sound effect

 LDA (soundAddr),Y      \ Set A to the data byte at the current index in the
                        \ volume envelope

 BPL msco4              \ If bit 7 is clear then we just fetched a volume value
                        \ from the envelope, so jump to msco4 to apply it

                        \ If we get here then A must be &80 or &FF, as those are
                        \ the only two valid entries in the volume envelope that
                        \ have bit 7 set
                        \
                        \ &80 means we loop back to the start of the envelope,
                        \ while &FF means the envelope ends here

 CMP #&80               \ If A is not &80 then we must have just fetched &FF
 BNE msco5              \ from the envelope, so jump to msco5 to exit the
                        \ envelope

                        \ If we get here then we just fetched a &80 from the
                        \ envelope data, so we now loop around to the start of
                        \ the envelope, so it keeps repeating

 LDY #0                 \ Set Y to zero so we fetch data from the start of the
                        \ envelope again

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into msco4 to process it

.msco4

                        \ If we get here then A contains an entry from the
                        \ volume envelope for this sound effect, so now we send
                        \ it to the APU to change the volume

 ORA soundByteSQ2+6     \ OR the envelope byte with the sound effect's byte #6,
 STA SQ2_VOL            \ and send the result to the APU via SQ2_VOL
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
 STY soundVolIndexSQ2   \ envelope so on the next iteration we move on to the
                        \ next byte in the envelope

.msco5

                        \ Now that we are done with the volume envelope, it's
                        \ time to move on to the pitch of the sound effect

 LDA soundPitCountSQ2   \ If the byte #1 counter has not yet run down to zero,
 BNE msco8              \ jump to msco8 to skip the following, so we don't send
                        \ pitch data to the APU on this iteration

                        \ If we get here then the counter in soundPitCountSQ2
                        \ (which counts down from the value of byte #1) has run
                        \ down to zero, so we now send pitch data to the ALU if
                        \ if we haven't yet sent it all

 LDA soundByteSQ2+12    \ If byte #12 is non-zero then the sound effect loops
 BNE msco6              \ infinitely, so jump to msco6 to send pitch data to the
                        \ APU

 LDA soundByteSQ2+9     \ Otherwise, if the counter in byte #9 has not run down
 BNE msco6              \ then we haven't yet sent pitch data for enough
                        \ iterations, so jump to msco6 to send pitch data to the
                        \ APU

 RTS                    \ Return from the subroutine

.msco6

                        \ If we get here then we are sending pitch data to the
                        \ APU on this iteration, so now we do just that

 DEC soundByteSQ2+9     \ Decrement the counter in byte #9, which contains the
                        \ number of iterations for which we send pitch data to
                        \ the APU (as that's what we are doing)

 LDA soundByteSQ2+1     \ Reset the soundPitCountSQ2 counter to the value of
 STA soundPitCountSQ2   \ byte #1 so it can start counting down again to trigger
                        \ the next pitch change after this one

 LDA soundByteSQ2+2     \ Set A to the low byte of the sound effect's current
                        \ pitch, which is in byte #2 of the sound data

 LDX soundByteSQ2+7     \ If byte #7 is zero then vibrato is disabled, so jump
 BEQ msco7              \ to msco7 to skip the following instruction

 ADC soundVibrato       \ Byte #7 is non-zero, so add soundVibrato to the pitch
                        \ of the sound in A to apply vibrato (this also adds the
                        \ C flag, which is not in a fixed state, so this adds an
                        \ extra level of randomness to the vibrato effect)

.msco7

 STA soundLoSQ2         \ Store the value of A (i.e. the low byte of the sound
                        \ effect's pitch, possibly with added vibrato) in
                        \ soundLoSQ2

 STA SQ2_LO             \ Send the value of soundLoSQ2 to the APU via SQ2_LO

 LDA soundByteSQ2+3     \ Set A to the high byte of the sound effect's current
                        \ pitch, which is in byte #3 of the sound data

 STA soundHiSQ2         \ Store the value of A (i.e. the high byte of the sound
                        \ effect's pitch) in soundHiSQ2

 STA SQ2_HI             \ Send the value of soundHiSQ2 to the APU via SQ2_HI

.msco8

 DEC soundPitCountSQ2   \ Decrement the byte #1 counter, as we have now done one
                        \ more iteration of the sound effect

 LDA soundByteSQ2+13    \ If byte #13 of the sound data is zero then we apply
 BEQ msco9              \ pitch variation in every iteration (if enabled), so
                        \ jump to msco9 to skip the following and move straight
                        \ to the pitch variation checks

 DEC soundPitchEnvSQ2   \ Otherwise decrement the byte #13 counter to count down
                        \ towards the point where we apply pitch variation

 BNE msco11             \ If the counter is not yet zero, jump to msco11 to
                        \ return from the subroutine without applying pitch
                        \ variation, as the counter has not yet reached that
                        \ point

                        \ If we get here then the byte #13 counter just ran down
                        \ to zero, so we need to apply pitch variation (if
                        \ enabled)

 STA soundPitchEnvSQ2   \ Reset the soundPitchEnvSQ2 counter to the value of
                        \ byte #13 so it can start counting down again, for the
                        \ next pitch variation after this one

.msco9

 LDA soundByteSQ2+8     \ Set A to byte #8 of the sound data, which determines
                        \ whether pitch variation is enabled

 BEQ msco11             \ If A is zero then pitch variation is not enabled, so
                        \ jump to msco11 to return from the subroutine without
                        \ applying pitch variation

                        \ If we get here then pitch variation is enabled, so now
                        \ we need to apply it

 BMI msco10             \ If A is negative then we need to add the value to the
                        \ pitch's period, so jump to msco10

                        \ If we get here then we need to subtract the 16-bit
                        \ value in bytes #4 and #5 from the pitch's period in
                        \ (soundHiSQ2 soundLoSQ2)
                        \
                        \ Reducing the pitch's period increases its frequency,
                        \ so this makes the note frequency higher

 LDA soundLoSQ2         \ Subtract the 16-bit value in bytes #4 and #5 of the
 SEC                    \ sound data from (soundHiSQ2 soundLoSQ2), updating
 SBC soundByteSQ2+4     \ (soundHiSQ2 soundLoSQ2) to the result, and sending
 STA soundLoSQ2         \ it to the APU via (SQ2_HI SQ2_LO)
 STA SQ2_LO             \
 LDA soundHiSQ2         \ Note that bits 2 to 7 of the high byte are cleared so
 SBC soundByteSQ2+5     \ the length counter does not reload
 AND #%00000011
 STA soundHiSQ2
 STA SQ2_HI

 RTS                    \ Return from the subroutine

.msco10

                        \ If we get here then we need to add the 16-bit value
                        \ in bytes #4 and #5 to the pitch's period in
                        \ (soundHiSQ2 soundLoSQ2)
                        \
                        \ Increasing the pitch's period reduces its frequency,
                        \ so this makes the note frequency lower

 LDA soundLoSQ2         \ Add the 16-bit value in bytes #4 and #5 of the sound
 CLC                    \ data to (soundHiSQ2 soundLoSQ2), updating
 ADC soundByteSQ2+4     \ (soundHiSQ2 soundLoSQ2) to the result, and sending
 STA soundLoSQ2         \ it to the APU via (SQ2_HI SQ2_LO)
 STA SQ2_LO             \
 LDA soundHiSQ2         \ Note that bits 2 to 7 of the high byte are cleared so
 ADC soundByteSQ2+5     \ the length counter does not reload
 AND #%00000011
 STA soundHiSQ2
 STA SQ2_HI

.msco11

 RTS                    \ Return from the subroutine

