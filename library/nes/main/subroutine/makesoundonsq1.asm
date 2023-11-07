\ ******************************************************************************
\
\       Name: MakeSoundOnSQ1
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the current sound effect on the SQ1 channel
\  Deep dive: Sound effects in NES Elite
\
\ ******************************************************************************

.MakeSoundOnSQ1

 LDA effectOnSQ1        \ If effectOnSQ1 is non-zero then a sound effect is
 BNE mscz1              \ being made on channel SQ1, so jump to mscz1 to keep
                        \ making it

 RTS                    \ Otherwise return from the subroutine

.mscz1

 LDA soundByteSQ1+0     \ If the remaining number of iterations for this sound
 BNE mscz3              \ effect in sound byte #0 is non-zero, jump to mscz3 to
                        \ keep making the sound

 LDX soundByteSQ1+12    \ If byte #12 of the sound effect data is non-zero, then
 BNE mscz3              \ this sound effect keeps looping, so jump to mscz3 to
                        \ keep making the sound

 LDA enableSound        \ If enableSound = 0 then sound is disabled, so jump to
 BEQ mscz2              \ mscz2 to silence the SQ1 channel and return from the
                        \ subroutine

                        \ If we get here then we have finished making the sound
                        \ effect, so we now send the volume and pitch values for
                        \ the music to the APU, so if there is any music playing
                        \ it will pick up again, and we mark this sound channel
                        \ as clear of sound effects

 LDA sq1Volume          \ Send sq1Volume to the APU via SQ1_VOL, which is the
 STA SQ1_VOL            \ volume byte of any music that was playing when the
                        \ sound effect took precedence

 LDA sq1Lo              \ Send (sq1Hi sq1Lo) to the APU via (SQ1_HI SQ1_LO),
 STA SQ1_LO             \ which is the pitch of any music that was playing when
 LDA sq1Hi              \ the sound effect took precedence
 STA SQ1_HI

 STX effectOnSQ1        \ Set effectOnSQ1 = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.mscz2

                        \ If we get here then sound is disabled, so we need to
                        \ silence the SQ1 channel

 LDA #%00110000         \ Set the volume of the SQ1 channel to zero as follows:
 STA SQ1_VOL            \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 STX effectOnSQ1        \ Set effectOnSQ1 = 0 to mark the SQL channel as clear
                        \ of sound effects, so the channel can be used for music
                        \ and is ready for the next sound effect

 RTS                    \ Return from the subroutine

.mscz3

                        \ If we get here then we need to keep making the sound
                        \ effect on channel SQ1

 DEC soundByteSQ1+0     \ Decrement the remaining length of the sound in byte #0
                        \ as we are about to make the sound for another
                        \ iteration

 DEC soundVolCountSQ1   \ Decrement the volume envelope counter so we count down
                        \ towards the point where we apply the volume envelope

 BNE mscz5              \ If the volume envelope counter has not reached zero
                        \ then jump to mscz5, as we don't apply the next entry
                        \ from the volume envelope yet

                        \ If we get here then the counter in soundVolCountSQ1
                        \ just reached zero, so we apply the next entry from the
                        \ volume envelope

 LDA soundByteSQ1+11    \ Reset the volume envelope counter to byte #11 from the
 STA soundVolCountSQ1   \ sound effect's data, which controls how often we apply
                        \ the volume envelope to the sound effect

 LDY soundVolIndexSQ1   \ Set Y to the index of the current byte in the volume
                        \ envelope

 LDA soundVolumeSQ1     \ Set soundAddr(1 0) = soundVolumeSQ1(1 0)
 STA soundAddr          \
 LDA soundVolumeSQ1+1   \ So soundAddr(1 0) contains the address of the volume
 STA soundAddr+1        \ envelope for this sound effect

 LDA (soundAddr),Y      \ Set A to the data byte at the current index in the
                        \ volume envelope

 BPL mscz4              \ If bit 7 is clear then we just fetched a volume value
                        \ from the envelope, so jump to mscz4 to apply it

                        \ If we get here then A must be &80 or &FF, as those are
                        \ the only two valid entries in the volume envelope that
                        \ have bit 7 set
                        \
                        \ &80 means we loop back to the start of the envelope,
                        \ while &FF means the envelope ends here

 CMP #&80               \ If A is not &80 then we must have just fetched &FF
 BNE mscz5              \ from the envelope, so jump to mscz5 to exit the
                        \ envelope

                        \ If we get here then we just fetched a &80 from the
                        \ envelope data, so we now loop around to the start of
                        \ the envelope, so it keeps repeating

 LDY #0                 \ Set Y to zero so we fetch data from the start of the
                        \ envelope again

 LDA (soundAddr),Y      \ Set A to the byte of envelope data at index 0, so we
                        \ can fall through into mscz4 to process it

.mscz4

                        \ If we get here then A contains an entry from the
                        \ volume envelope for this sound effect, so now we send
                        \ it to the APU to change the volume

 ORA soundByteSQ1+6     \ OR the envelope byte with the sound effect's byte #6,
 STA SQ1_VOL            \ and send the result to the APU via SQ1_VOL
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
 STY soundVolIndexSQ1   \ envelope so on the next iteration we move on to the
                        \ next byte in the envelope

.mscz5

                        \ Now that we are done with the volume envelope, it's
                        \ time to move on to the pitch of the sound effect

 LDA soundPitCountSQ1   \ If the byte #1 counter has not yet run down to zero,
 BNE mscz8              \ jump to mscz8 to skip the following, so we don't send
                        \ pitch data to the APU on this iteration

                        \ If we get here then the counter in soundPitCountSQ1
                        \ (which counts down from the value of byte #1) has run
                        \ down to zero, so we now send pitch data to the ALU if
                        \ if we haven't yet sent it all

 LDA soundByteSQ1+12    \ If byte #12 is non-zero then the sound effect loops
 BNE mscz6              \ infinitely, so jump to mscz6 to send pitch data to the
                        \ APU

 LDA soundByteSQ1+9     \ Otherwise, if the counter in byte #9 has not run down
 BNE mscz6              \ then we haven't yet sent pitch data for enough
                        \ iterations, so jump to mscz6 to send pitch data to the
                        \ APU

 RTS                    \ Return from the subroutine

.mscz6

                        \ If we get here then we are sending pitch data to the
                        \ APU on this iteration, so now we do just that

 DEC soundByteSQ1+9     \ Decrement the counter in byte #9, which contains the
                        \ number of iterations for which we send pitch data to
                        \ the APU (as that's what we are doing)

 LDA soundByteSQ1+1     \ Reset the soundPitCountSQ1 counter to the value of
 STA soundPitCountSQ1   \ byte #1 so it can start counting down again to trigger
                        \ the next pitch change after this one

 LDA soundByteSQ1+2     \ Set A to the low byte of the sound effect's current
                        \ pitch, which is in byte #2 of the sound data

 LDX soundByteSQ1+7     \ If byte #7 is zero then vibrato is disabled, so jump
 BEQ mscz7              \ to mscz7 to skip the following instruction

 ADC soundVibrato       \ Byte #7 is non-zero, so add soundVibrato to the pitch
                        \ of the sound in A to apply vibrato (this also adds the
                        \ C flag, which is not in a fixed state, so this adds an
                        \ extra level of randomness to the vibrato effect)

.mscz7

 STA soundLoSQ1         \ Store the value of A (i.e. the low byte of the sound
                        \ effect's pitch, possibly with added vibrato) in
                        \ soundLoSQ1

 STA SQ1_LO             \ Send the value of soundLoSQ1 to the APU via SQ1_LO

 LDA soundByteSQ1+3     \ Set A to the high byte of the sound effect's current
                        \ pitch, which is in byte #3 of the sound data

 STA soundHiSQ1         \ Store the value of A (i.e. the high byte of the sound
                        \ effect's pitch) in soundHiSQ1

 STA SQ1_HI             \ Send the value of soundHiSQ1 to the APU via SQ1_HI

.mscz8

 DEC soundPitCountSQ1   \ Decrement the byte #1 counter, as we have now done one
                        \ more iteration of the sound effect

 LDA soundByteSQ1+13    \ If byte #13 of the sound data is zero then we apply
 BEQ mscz9              \ pitch variation in every iteration (if enabled), so
                        \ jump to mscz9 to skip the following and move straight
                        \ to the pitch variation checks

 DEC soundPitchEnvSQ1   \ Otherwise decrement the byte #13 counter to count down
                        \ towards the point where we apply pitch variation

 BNE mscz11             \ If the counter is not yet zero, jump to mscz11 to
                        \ return from the subroutine without applying pitch
                        \ variation, as the counter has not yet reached that
                        \ point

                        \ If we get here then the byte #13 counter just ran down
                        \ to zero, so we need to apply pitch variation (if
                        \ enabled)

 STA soundPitchEnvSQ1   \ Reset the soundPitchEnvSQ1 counter to the value of
                        \ byte #13 so it can start counting down again, for the
                        \ next pitch variation after this one

.mscz9

 LDA soundByteSQ1+8     \ Set A to byte #8 of the sound data, which determines
                        \ whether pitch variation is enabled

 BEQ mscz11             \ If A is zero then pitch variation is not enabled, so
                        \ jump to mscz11 to return from the subroutine without
                        \ applying pitch variation

                        \ If we get here then pitch variation is enabled, so now
                        \ we need to apply it

 BMI mscz10             \ If A is negative then we need to add the value to the
                        \ pitch's period, so jump to mscz10

                        \ If we get here then we need to subtract the 16-bit
                        \ value in bytes #4 and #5 from the pitch's period in
                        \ (soundHiSQ1 soundLoSQ1)
                        \
                        \ Reducing the pitch's period increases its frequency,
                        \ so this makes the note frequency higher

 LDA soundLoSQ1         \ Subtract the 16-bit value in bytes #4 and #5 of the
 SEC                    \ sound data from (soundHiSQ1 soundLoSQ1), updating
 SBC soundByteSQ1+4     \ (soundHiSQ1 soundLoSQ1) to the result, and sending
 STA soundLoSQ1         \ it to the APU via (SQ1_HI SQ1_LO)
 STA SQ1_LO             \
 LDA soundHiSQ1         \ Note that bits 2 to 7 of the high byte are cleared so
 SBC soundByteSQ1+5     \ the length counter does not reload
 AND #%00000011
 STA soundHiSQ1
 STA SQ1_HI

 RTS                    \ Return from the subroutine

.mscz10

                        \ If we get here then we need to add the 16-bit value
                        \ in bytes #4 and #5 to the pitch's period in
                        \ (soundHiSQ1 soundLoSQ1)
                        \
                        \ Increasing the pitch's period reduces its frequency,
                        \ so this makes the note frequency lower

 LDA soundLoSQ1         \ Add the 16-bit value in bytes #4 and #5 of the sound
 CLC                    \ data to (soundHiSQ1 soundLoSQ1), updating
 ADC soundByteSQ1+4     \ (soundHiSQ1 soundLoSQ1) to the result, and sending
 STA soundLoSQ1         \ it to the APU via (SQ1_HI SQ1_LO)
 STA SQ1_LO             \
 LDA soundHiSQ1         \ Note that bits 2 to 7 of the high byte are cleared so
 ADC soundByteSQ1+5     \ the length counter does not reload
 AND #%00000011
 STA soundHiSQ1
 STA SQ1_HI

.mscz11

 RTS                    \ Return from the subroutine

