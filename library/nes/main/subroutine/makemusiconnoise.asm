\ ******************************************************************************
\
\       Name: MakeMusicOnNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Play the current music on the NOISE channel
\
\ ******************************************************************************

.MakeMusicOnNOISE

 DEC pauseCountNOISE    \ Decrement the sound counter for NOISE

 BEQ musf1              \ If the counter has reached zero, jump to musf1 to make
                        \ music on the NOISE channel

 RTS                    \ Otherwise return from the subroutine

.musf1

 LDA sectionDataNOISE   \ Set soundAddr(1 0) = sectionDataNOISE(1 0)
 STA soundAddr          \
 LDA sectionDataNOISE+1 \ So soundAddr(1 0) points to the note data for this
 STA soundAddr+1        \ part of the tune

 STA applyVolumeNOISE   \ Set applyVolumeNOISE = 0 so we don't apply the volume
                        \ envelope by default (this gets changed if we process
                        \ note data below, as opposed to a command)
                        \
                        \ I'm not entirely sure why A is zero here - in fact,
                        \ it's very unlikely to be zero - so it's possible that
                        \ there is an LDA #0 instruction missing here and that
                        \ this is a bug that applies the volume envelope of the
                        \ NOISE channel too early

.musf2

 LDY #0                 \ Set Y to the next entry from the note data
 LDA (soundAddr),Y
 TAY

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musf3              \ in the note data
 INC soundAddr+1

.musf3

 TYA                    \ Set A to the next entry that we just fetched from the
                        \ note data

 BMI musf7              \ If bit 7 of A is set then this is a command byte, so
                        \ jump to musf7 to process it

 CMP #&60               \ If the note data in A is less than &60, jump to musf4
 BCC musf4

 ADC #&A0               \ The note data in A is between &60 and &7F, so set the
 STA startPauseNOISE    \ following:
                        \
                        \    startPauseNOISE = A - &5F
                        \
                        \ We know the C flag is set as we just passed through a
                        \ BCC, so the ADC actually adds &A1, which is the same
                        \ as subtracting &5F
                        \
                        \ So this sets startPauseNOISE to a value between 1 and
                        \ 32, corresponding to note data values between &60 and
                        \ &7F

 JMP musf2              \ Jump back to musf2 to move on to the next entry from
                        \ the note data

.musf4

                        \ If we get here then the note data in A is less than
                        \ &60, which denotes a sound to send to the APU, so we
                        \ now convert the data to a noise frequency (which we do
                        \ by simply taking the low nibble of the note data, as
                        \ this is just noise that doesn't need a conversion
                        \ from note to frequency like the other channels) and
                        \ send it to the APU to make a sound on channel NOISE

 AND #&0F               \ Set (Y A) to the frequency for noise note Y
 STA noiseLoCopy        \
 STA noiseLo            \ Also save a copy of the low byte in noiseLoCopy
 LDY #0

 LDX effectOnNOISE      \ If effectOnNOISE is non-zero then a sound effect is
 BNE musf5              \ being made on channel NOISE, so jump to musf5 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 STA NOISE_LO           \ Send (Y A) to the APU via NOISE_HI and NOISE_LO
 STY NOISE_HI

.musf5

 LDA #1                 \ Set volumeIndexNOISE = 1
 STA volumeIndexNOISE

 LDA volumeRepeatNOISE  \ Set volumeCounterNOISE = volumeRepeatNOISE
 STA volumeCounterNOISE

.musf6

 LDA #&FF               \ Set applyVolumeNOISE = &FF so we apply the volume
 STA applyVolumeNOISE   \ envelope in the next iteration

 LDA soundAddr          \ Set sectionDataNOISE(1 0) = soundAddr(1 0)
 STA sectionDataNOISE   \
 LDA soundAddr+1        \ This updates the pointer to the note data for the
 STA sectionDataNOISE+1 \ channel, so the next time we can pick up where we left
                        \ off

 LDA startPauseNOISE    \ Set pauseCountNOISE = startPauseNOISE
 STA pauseCountNOISE    \
                        \ So if startPauseNOISE is non-zero (as set by note data
                        \ the range &60 to &7F), the next startPauseNOISE
                        \ iterations of MakeMusicOnNOISE will do nothing

 RTS                    \ Return from the subroutine

.musf7

                        \ If we get here then bit 7 of the note data in A is
                        \ set, so this is a command byte

 LDY #0                 \ Set Y = 0, so we can use it in various commands below

 CMP #&FF               \ If A is not &FF, jump to musf9 to check for the next
 BNE musf9              \ command

                        \ If we get here then the command in A is &FF
                        \
                        \ <&FF> moves to the next section in the current tune

 LDA nextSectionNOISE   \ Set soundAddr(1 0) to the following:
 CLC                    \
 ADC sectionListNOISE   \   sectionListNOISE(1 0) + nextSectionNOISE(1 0)
 STA soundAddr          \
 LDA nextSectionNOISE+1 \ So soundAddr(1 0) points to the address of the next
 ADC sectionListNOISE+1 \ section in the current tune
 STA soundAddr+1        \
                        \ So if we are playing tune 2 and nextSectionNOISE(1 0)
                        \ points to the second section, then soundAddr(1 0)
                        \ will now point to the second address in
                        \ tune2Data_NOISE, which itself points to the note data
                        \ for the second section at tune2Data_NOISE_1

 LDA nextSectionNOISE   \ Set nextSectionNOISE(1 0) = nextSectionNOISE(1 0) + 2
 ADC #2                 \
 STA nextSectionNOISE   \ So nextSectionNOISE(1 0) now points to the next
 TYA                    \ section, as each section consists of two bytes in the
 ADC nextSectionNOISE+1 \ table at sectionListNOISE(1 0)
 STA nextSectionNOISE+1

 LDA (soundAddr),Y      \ If the address at soundAddr(1 0) is non-zero then it
 INY                    \ contains a valid address to the section's note data,
 ORA (soundAddr),Y      \ so jump to musf8 to skip the following
 BNE musf8              \
                        \ This also increments the index in Y to 1

                        \ If we get here then the command is trying to move to
                        \ the next section, but that section contains value of
                        \ &0000 in the tuneData table, so there is no next
                        \ section and we have reached the end of the tune, so
                        \ instead we jump back to the start of the tune

 LDA sectionListNOISE   \ Set soundAddr(1 0) = sectionListNOISE(1 0)
 STA soundAddr          \
 LDA sectionListNOISE+1 \ So we start again by pointing soundAddr(1 0) to the
 STA soundAddr+1        \ first entry in the section list for channel NOISE,
                        \ which contains the address of the first section's note
                        \ data

 LDA #2                 \ Set nextSectionNOISE(1 0) = 2
 STA nextSectionNOISE   \
 LDA #0                 \ So the next section after we play the first section
 STA nextSectionNOISE+1 \ will be the second section

.musf8

                        \ By this point, Y has been incremented to 1

 LDA (soundAddr),Y      \ Set soundAddr(1 0) to the address at soundAddr(1 0)
 TAX                    \
 DEY                    \ As we pointed soundAddr(1 0) to the address of the
 LDA (soundAddr),Y      \ new section above, this fetches the first address from
 STA soundAddr          \ the new section's address list, which points to the
 STX soundAddr+1        \ new section's note data
                        \
                        \ So soundAddr(1 0) now points to the note data for the
                        \ new section, so we're ready to start processing notes
                        \ and commands when we rejoin the musf2 loop

 JMP musf2              \ Jump back to musf2 to start processing data from the
                        \ new section

.musf9

 CMP #&F6               \ If A is not &F6, jump to musf11 to check for the next
 BNE musf11             \ command

                        \ If we get here then the command in A is &F6
                        \
                        \ <&F6 &xx> sets the volume envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musf10             \ in the note data
 INC soundAddr+1

.musf10

 STA volumeEnvelopeNOISE    \ Set volumeEnvelopeNOISE to the volume envelope
                            \ number that we just fetched

 JMP musf2              \ Jump back to musf2 to move on to the next entry from
                        \ the note data


.musf11

 CMP #&F7               \ If A is not &F7, jump to musf13 to check for the next
 BNE musf13             \ command

                        \ If we get here then the command in A is &F7
                        \
                        \ <&F7 &xx> sets the pitch envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musf12             \ in the note data
 INC soundAddr+1

.musf12

 STA pitchEnvelopeNOISE \ Set pitchEnvelopeNOISE to the pitch envelope number
                        \ that we just fetched

 STY pitchIndexNOISE    \ Set pitchIndexNOISE = 0 to point to the start of the
                        \ data for pitch envelope A

 JMP musf2              \ Jump back to musf2 to move on to the next entry from
                        \ the note data

.musf13

 CMP #&F8               \ If A is not &F8, jump to musf14 to check for the next
 BNE musf14             \ command

                        \ If we get here then the command in A is &F8
                        \
                        \ <&F8> sets the volume of the NOISE channel to zero

 LDA #%00110000         \ Set the volume of the NOISE channel to zero as
 STA noiseVolume        \ follows:
                        \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 JMP musf6              \ Jump to musf6 to return from the subroutine after
                        \ setting applyVolumeNOISE to &FF, so we apply the
                        \ volume envelope, and then continue on from the next
                        \ entry from the note data in the next iteration

.musf14

 CMP #&F9               \ If A is not &F9, jump to musf15 to check for the next
 BNE musf15             \ command

                        \ If we get here then the command in A is &F9
                        \
                        \ <&F9> enables the volume envelope for the NOISE
                        \ channel

 JMP musf6              \ Jump to musf6 to return from the subroutine after
                        \ setting applyVolumeNOISE to &FF, so we apply the
                        \ volume envelope, and then continue on from the next
                        \ entry from the note data in the next iteration

.musf15

 CMP #&F5               \ If A is not &F5, jump to musf16 to check for the next
 BNE musf16             \ command

                        \ If we get here then the command in A is &F5
                        \
                        \ <&F5 &xx &yy> changes tune to the tune data at &yyxx
                        \
                        \ It does this by setting sectionListNOISE(1 0) to &yyxx
                        \ and soundAddr(1 0) to the address stored in &yyxx
                        \
                        \ To see why this works, consider switching to tune 2,
                        \ for which we would use this command:
                        \
                        \   <&F5 LO(tune2Data_NOISE) LO(tune2Data_NOISE)>
                        \
                        \ This sets:
                        \
                        \   sectionListNOISE(1 0) = tune2Data_NOISE
                        \
                        \ so from now on we fetch the addresses for each section
                        \ of the tune from the table at tune2Data_NOISE
                        \
                        \ It also sets soundAddr(1 0) to the address in the
                        \ first two bytes of tune2Data_NOISE, to give:
                        \
                        \   soundAddr(1 0) = tune2Data_NOISE_0
                        \
                        \ So from this point on, note data is fetched from the
                        \ table at tune2Data_NOISE_0, which contains notes and
                        \ commands for the first section of tune 2

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 TAX                    \ Set sectionListNOISE(1 0) = &yyxx
 STA sectionListNOISE   \
 INY                    \ Also set soundAddr(1 0) to &yyxx and increment the
 LDA (soundAddr),Y      \ index in Y to 1, both of which we use below
 STX soundAddr
 STA soundAddr+1
 STA sectionListNOISE+1

 LDA #2                 \ Set nextSectionNOISE(1 0) = 2
 STA nextSectionNOISE   \
 DEY                    \ So the next section after we play the first section
 STY nextSectionNOISE+1 \ of the new tune will be the second section
                        \
                        \ Also decrement the index in Y back to 0

 LDA (soundAddr),Y      \ Set soundAddr(1 0) to the address stored at &yyxx
 TAX
 INY
 LDA (soundAddr),Y
 STA soundAddr+1
 STX soundAddr

 JMP musf2              \ Jump back to musf2 to move on to the next entry from
                        \ the note data

.musf16

 CMP #&F4               \ If A is not &F4, jump to musf18 to check for the next
 BNE musf18             \ command

                        \ If we get here then the command in A is &F4
                        \
                        \ <&F4 &xx> sets the playback speed to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A, which
                        \ contains the new speed

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musf17             \ in the note data
 INC soundAddr+1

.musf17

 STA tuneSpeed          \ Set tuneSpeed and tuneSpeedCopy to A, to change the
 STA tuneSpeedCopy      \ speed of the current tune to the specified speed

 JMP musf2              \ Jump back to musf2 to move on to the next entry from
                        \ the note data

.musf18

 CMP #&FE               \ If A is not &FE, jump to musf19 to check for the next
 BNE musf19             \ command

                        \ If we get here then the command in A is &FE
                        \
                        \ <&FE> stops the music and disables sound

 STY playMusic          \ Set playMusic = 0 to stop playing the current tune, so
                        \ only a new call to ChooseMusic will start the music
                        \ again

 PLA                    \ Pull the return address from the stack, so the RTS
 PLA                    \ instruction at the end of StopSounds actually returns
                        \ from the subroutine that called MakeMusic, so we stop
                        \ the music and return to the MakeSounds routine (which
                        \ is the only routine that calls MakeMusic)

 JMP StopSoundsS        \ Jump to StopSounds via StopSoundsS to stop the music
                        \ and return to the MakeSounds routine

.musf19

 BEQ musf19             \ If we get here then bit 7 of A was set but the value
                        \ didn't match any of the checks above, so this
                        \ instruction does nothing and we fall through into
                        \ ApplyEnvelopeNOISE, ignoring the data in A
                        \
                        \ I'm not sure why the instruction here is an infinite
                        \ loop, but luckily it isn't triggered as A is never
                        \ zero at this point

