\ ******************************************************************************
\
\       Name: MakeMusicOnSQ1
\       Type: Subroutine
\   Category: Sound
\    Summary: Play the current music on the SQ1 channel
\  Deep dive: Music in NES Elite
\
\ ******************************************************************************

.MakeMusicOnSQ1

 DEC pauseCountSQ1      \ Decrement the sound counter for SQ1

 BEQ muso1              \ If the counter has reached zero, jump to muso1 to make
                        \ music on the SQ1 channel

 RTS                    \ Otherwise return from the subroutine

.muso1

 LDA sectionDataSQ1     \ Set soundAddr(1 0) = sectionDataSQ1(1 0)
 STA soundAddr          \
 LDA sectionDataSQ1+1   \ So soundAddr(1 0) points to the note data for this
 STA soundAddr+1        \ part of the tune

 LDA #0                 \ Set sq1Sweep = 0
 STA sq1Sweep

 STA applyVolumeSQ1     \ Set applyVolumeSQ1 = 0 so we don't apply the volume
                        \ envelope by default (this gets changed if we process
                        \ note data below, as opposed to a command)

.muso2

 LDY #0                 \ Set Y to the next entry from the note data
 LDA (soundAddr),Y
 TAY

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso3              \ in the note data
 INC soundAddr+1

.muso3

 TYA                    \ Set A to the next entry that we just fetched from the
                        \ note data

 BMI muso8              \ If bit 7 of A is set then this is a command byte, so
                        \ jump to muso8 to process it

 CMP #&60               \ If the note data in A is less than &60, jump to muso4
 BCC muso4

 ADC #&A0               \ The note data in A is between &60 and &7F, so set the
 STA startPauseSQ1      \ following:
                        \
                        \    startPauseSQ1 = A - &5F
                        \
                        \ We know the C flag is set as we just passed through a
                        \ BCC, so the ADC actually adds &A1, which is the same
                        \ as subtracting &5F
                        \
                        \ So this sets startPauseSQ1 to a value between 1 and
                        \ 32, corresponding to note data values between &60 and
                        \ &7F

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso4

                        \ If we get here then the note data in A is less than
                        \ &60, which denotes a sound to send to the APU, so we
                        \ now convert the data to a frequency and send it to the
                        \ APU to make a sound on channel SQ1

 CLC                    \ Set Y = (A + tuningAll + tuningSQ1) * 2
 ADC tuningAll
 CLC
 ADC tuningSQ1
 ASL A
 TAY

 LDA noteFrequency,Y    \ Set (sq1Hi sq1Lo) the frequency for note Y
 STA sq1LoCopy          \
 STA sq1Lo              \ Also save a copy of the low byte in sq1LoCopy
 LDA noteFrequency+1,Y
 STA sq1Hi

 LDX effectOnSQ1        \ If effectOnSQ1 is non-zero then a sound effect is
 BNE muso5              \ being made on channel SQ1, so jump to muso5 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 LDX sq1Sweep           \ Send sq1Sweep to the APU via SQ1_SWEEP
 STX SQ1_SWEEP

 LDX sq1Lo              \ Send (sq1Hi sq1Lo) to the APU via SQ1_HI and SQ1_LO
 STX SQ1_LO
 STA SQ1_HI

.muso5

 LDA #1                 \ Set volumeIndexSQ1 = 1
 STA volumeIndexSQ1

 LDA volumeRepeatSQ1    \ Set volumeCounterSQ1 = volumeRepeatSQ1
 STA volumeCounterSQ1

.muso6

 LDA #&FF               \ Set applyVolumeSQ1 = &FF so we apply the volume
 STA applyVolumeSQ1     \ envelope in the next iteration

.muso7

 LDA soundAddr          \ Set sectionDataSQ1(1 0) = soundAddr(1 0)
 STA sectionDataSQ1     \
 LDA soundAddr+1        \ This updates the pointer to the note data for the
 STA sectionDataSQ1+1   \ channel, so the next time we can pick up where we left
                        \ off

 LDA startPauseSQ1      \ Set pauseCountSQ1 = startPauseSQ1
 STA pauseCountSQ1      \
                        \ So if startPauseSQ1 is non-zero (as set by note data
                        \ the range &60 to &7F), the next startPauseSQ1
                        \ iterations of MakeMusicOnSQ1 will do nothing

 RTS                    \ Return from the subroutine

.muso8

                        \ If we get here then bit 7 of the note data in A is
                        \ set, so this is a command byte

 LDY #0                 \ Set Y = 0, so we can use it in various commands below

 CMP #&FF               \ If A is not &FF, jump to muso10 to check for the next
 BNE muso10             \ command

                        \ If we get here then the command in A is &FF
                        \
                        \ <&FF> moves to the next section in the current tune

 LDA nextSectionSQ1     \ Set soundAddr(1 0) to the following:
 CLC                    \
 ADC sectionListSQ1     \   sectionListSQ1(1 0) + nextSectionSQ1(1 0)
 STA soundAddr          \
 LDA nextSectionSQ1+1   \ So soundAddr(1 0) points to the address of the next
 ADC sectionListSQ1+1   \ section in the current tune
 STA soundAddr+1        \
                        \ So if we are playing tune 2 and nextSectionSQ1(1 0)
                        \ points to the second section, then soundAddr(1 0)
                        \ will now point to the second address in tune2Data_SQ1,
                        \ which itself points to the note data for the second
                        \ section at tune2Data_SQ1_1

 LDA nextSectionSQ1     \ Set nextSectionSQ1(1 0) = nextSectionSQ1(1 0) + 2
 ADC #2                 \
 STA nextSectionSQ1     \ So nextSectionSQ1(1 0) now points to the next section,
 TYA                    \ as each section consists of two bytes in the table at
 ADC nextSectionSQ1+1   \ sectionListSQ1(1 0)
 STA nextSectionSQ1+1

 LDA (soundAddr),Y      \ If the address at soundAddr(1 0) is non-zero then it
 INY                    \ contains a valid address to the section's note data,
 ORA (soundAddr),Y      \ so jump to muso9 to skip the following
 BNE muso9              \
                        \ This also increments the index in Y to 1

                        \ If we get here then the command is trying to move to
                        \ the next section, but that section contains value of
                        \ &0000 in the tuneData table, so there is no next
                        \ section and we have reached the end of the tune, so
                        \ instead we jump back to the start of the tune

 LDA sectionListSQ1     \ Set soundAddr(1 0) = sectionListSQ1(1 0)
 STA soundAddr          \
 LDA sectionListSQ1+1   \ So we start again by pointing soundAddr(1 0) to the
 STA soundAddr+1        \ first entry in the section list for channel SQ1, which
                        \ contains the address of the first section's note data

 LDA #2                 \ Set nextSectionSQ1(1 0) = 2
 STA nextSectionSQ1     \
 LDA #0                 \ So the next section after we play the first section
 STA nextSectionSQ1+1   \ will be the second section

.muso9

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
                        \ and commands when we rejoin the muso2 loop

 JMP muso2              \ Jump back to muso2 to start processing data from the
                        \ new section

.muso10

 CMP #&F6               \ If A is not &F6, jump to muso12 to check for the next
 BNE muso12             \ command

                        \ If we get here then the command in A is &F6
                        \
                        \ <&F6 &xx> sets the volume envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso11             \ in the note data
 INC soundAddr+1

.muso11

 STA volumeEnvelopeSQ1  \ Set volumeEnvelopeSQ1 to the volume envelope number
                        \ that we just fetched

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso12

 CMP #&F7               \ If A is not &F7, jump to muso14 to check for the next
 BNE muso14             \ command

                        \ If we get here then the command in A is &F7
                        \
                        \ <&F7 &xx> sets the pitch envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso13             \ in the note data
 INC soundAddr+1

.muso13

 STA pitchEnvelopeSQ1   \ Set pitchEnvelopeSQ1 to the pitch envelope number that
                        \ we just fetched

 STY pitchIndexSQ1      \ Set pitchIndexSQ1 = 0 to point to the start of the
                        \ data for pitch envelope A

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso14

 CMP #&FA               \ If A is not &FA, jump to muso16 to check for the next
 BNE muso16             \ command

                        \ If we get here then the command in A is &FA
                        \
                        \ <&FA %ddlc0000> configures the SQ1 channel as follows:
                        \
                        \   * %dd      = duty pulse length
                        \
                        \   * %l set   = infinite play
                        \   * %l clear = one-shot play
                        \
                        \   * %c set   = constant volume
                        \   * %c clear = envelope volume

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 STA dutyLoopEnvSQ1     \ Store the entry we just fetched in dutyLoopEnvSQ1, to
                        \ configure SQ1 as follows:
                        \
                        \   * Bits 6-7    = duty pulse length
                        \
                        \   * Bit 5 set   = infinite play
                        \   * Bit 5 clear = one-shot play
                        \
                        \   * Bit 4 set   = constant volume
                        \   * Bit 4 clear = envelope volume

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso15             \ in the note data
 INC soundAddr+1

.muso15

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso16

 CMP #&F8               \ If A is not &F8, jump to muso17 to check for the next
 BNE muso17             \ command

                        \ If we get here then the command in A is &F8
                        \
                        \ <&F8> sets the volume of the SQ1 channel to zero

 LDA #%00110000         \ Set the volume of the SQ1 channel to zero as follows:
 STA sq1Volume          \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 JMP muso7              \ Jump to muso7 to return from the subroutine, so we
                        \ continue on from the next entry from the note data in
                        \ the next iteration

.muso17

 CMP #&F9               \ If A is not &F9, jump to muso18 to check for the next
 BNE muso18             \ command

                        \ If we get here then the command in A is &F9
                        \
                        \ <&F9> enables the volume envelope for the SQ1 channel

 JMP muso6              \ Jump to muso6 to return from the subroutine after
                        \ setting applyVolumeSQ1 to &FF, so we apply the volume
                        \ envelope, and then continue on from the next entry
                        \ from the note data in the next iteration

.muso18

 CMP #&FD               \ If A is not &FD, jump to muso20 to check for the next
 BNE muso20             \ command

                        \ If we get here then the command in A is &FD
                        \
                        \ <&F4 &xx> sets the SQ1 sweep to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso19             \ in the note data
 INC soundAddr+1

.muso19

 STA sq1Sweep           \ Store the entry we just fetched in sq1Sweep, which
                        \ gets sent to the APU via SQ1_SWEEP

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso20

 CMP #&FB               \ If A is not &FB, jump to muso22 to check for the next
 BNE muso22             \ command

                        \ If we get here then the command in A is &FB
                        \
                        \ <&FB &xx> sets the tuning for all channels to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso21             \ in the note data
 INC soundAddr+1

.muso21

 STA tuningAll          \ Store the entry we just fetched in tuningAll, which
                        \ sets the tuning for the SQ1, SQ2 and TRI channels (so
                        \ this value gets added to every note on those channels)

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso22

 CMP #&FC               \ If A is not &FC, jump to muso24 to check for the next
 BNE muso24             \ command

                        \ If we get here then the command in A is &FC
                        \
                        \ <&FC &xx> sets the tuning for the SQ1 channel to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso23             \ in the note data
 INC soundAddr+1

.muso23

 STA tuningSQ1          \ Store the entry we just fetched in tuningSQ1, which
                        \ sets the tuning for the SQ1 channel (so this value
                        \ gets added to every note on those channels)

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso24

 CMP #&F5               \ If A is not &F5, jump to muso25 to check for the next
 BNE muso25             \ command

                        \ If we get here then the command in A is &F5
                        \
                        \ <&F5 &xx &yy> changes tune to the tune data at &yyxx
                        \
                        \ It does this by setting sectionListSQ1(1 0) to &yyxx
                        \ and soundAddr(1 0) to the address stored in &yyxx
                        \
                        \ To see why this works, consider switching to tune 2,
                        \ for which we would use this command:
                        \
                        \   <&F5 LO(tune2Data_SQ1) LO(tune2Data_SQ1)>
                        \
                        \ This sets:
                        \
                        \   sectionListSQ1(1 0) = tune2Data_SQ1
                        \
                        \ so from now on we fetch the addresses for each section
                        \ of the tune from the table at tune2Data_SQ1
                        \
                        \ It also sets soundAddr(1 0) to the address in the
                        \ first two bytes of tune2Data_SQ1, to give:
                        \
                        \   soundAddr(1 0) = tune2Data_SQ1_0
                        \
                        \ So from this point on, note data is fetched from the
                        \ table at tune2Data_SQ1_0, which contains notes and
                        \ commands for the first section of tune 2

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 TAX                    \ Set sectionListSQ1(1 0) = &yyxx
 STA sectionListSQ1     \
 INY                    \ Also set soundAddr(1 0) to &yyxx and increment the
 LDA (soundAddr),Y      \ index in Y to 1, both of which we use below
 STX soundAddr
 STA soundAddr+1
 STA sectionListSQ1+1

 LDA #2                 \ Set nextSectionSQ1(1 0) = 2
 STA nextSectionSQ1     \
 DEY                    \ So the next section after we play the first section
 STY nextSectionSQ1+1   \ of the new tune will be the second section
                        \
                        \ Also decrement the index in Y back to 0

 LDA (soundAddr),Y      \ Set soundAddr(1 0) to the address stored at &yyxx
 TAX
 INY
 LDA (soundAddr),Y
 STA soundAddr+1
 STX soundAddr

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso25

 CMP #&F4               \ If A is not &F4, jump to muso27 to check for the next
 BNE muso27             \ command

                        \ If we get here then the command in A is &F4
                        \
                        \ <&F4 &xx> sets the playback speed to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A, which
                        \ contains the new speed

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE muso26             \ in the note data
 INC soundAddr+1

.muso26

 STA tuneSpeed          \ Set tuneSpeed and tuneSpeedCopy to A, to change the
 STA tuneSpeedCopy      \ speed of the current tune to the specified speed

 JMP muso2              \ Jump back to muso2 to move on to the next entry from
                        \ the note data

.muso27

 CMP #&FE               \ If A is not &FE, jump to muso28 to check for the next
 BNE muso28             \ command

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

.muso28

 BEQ muso28             \ If we get here then bit 7 of A was set but the value
                        \ didn't match any of the checks above, so this
                        \ instruction does nothing and we fall through into
                        \ ApplyEnvelopeSQ1, ignoring the data in A
                        \
                        \ I'm not sure why the instruction here is an infinite
                        \ loop, but luckily it isn't triggered as A is never
                        \ zero at this point

