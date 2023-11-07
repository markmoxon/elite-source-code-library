\ ******************************************************************************
\
\       Name: MakeMusicOnSQ2
\       Type: Subroutine
\   Category: Sound
\    Summary: Play the current music on the SQ2 channel
\  Deep dive: Music in NES Elite
\
\ ******************************************************************************

.MakeMusicOnSQ2

 DEC pauseCountSQ2      \ Decrement the sound counter for SQ2

 BEQ must1              \ If the counter has reached zero, jump to must1 to make
                        \ music on the SQ2 channel

 RTS                    \ Otherwise return from the subroutine

.must1

 LDA sectionDataSQ2     \ Set soundAddr(1 0) = sectionDataSQ2(1 0)
 STA soundAddr          \
 LDA sectionDataSQ2+1   \ So soundAddr(1 0) points to the note data for this
 STA soundAddr+1        \ part of the tune

 LDA #0                 \ Set sq2Sweep = 0
 STA sq2Sweep

 STA applyVolumeSQ2     \ Set applyVolumeSQ2 = 0 so we don't apply the volume
                        \ envelope by default (this gets changed if we process
                        \ note data below, as opposed to a command)

.must2

 LDY #0                 \ Set Y to the next entry from the note data
 LDA (soundAddr),Y
 TAY

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must3              \ in the note data
 INC soundAddr+1

.must3

 TYA                    \ Set A to the next entry that we just fetched from the
                        \ note data

 BMI must8              \ If bit 7 of A is set then this is a command byte, so
                        \ jump to must8 to process it

 CMP #&60               \ If the note data in A is less than &60, jump to must4
 BCC must4

 ADC #&A0               \ The note data in A is between &60 and &7F, so set the
 STA startPauseSQ2      \ following:
                        \
                        \    startPauseSQ2 = A - &5F
                        \
                        \ We know the C flag is set as we just passed through a
                        \ BCC, so the ADC actually adds &A1, which is the same
                        \ as subtracting &5F
                        \
                        \ So this sets startPauseSQ2 to a value between 1 and
                        \ 32, corresponding to note data values between &60 and
                        \ &7F

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must4

                        \ If we get here then the note data in A is less than
                        \ &60, which denotes a sound to send to the APU, so we
                        \ now convert the data to a frequency and send it to the
                        \ APU to make a sound on channel SQ2

 CLC                    \ Set Y = (A + tuningAll + tuningSQ2) * 2
 ADC tuningAll
 CLC
 ADC tuningSQ2
 ASL A
 TAY

 LDA noteFrequency,Y    \ Set (sq2Hi sq2Lo) the frequency for note Y
 STA sq2LoCopy          \
 STA sq2Lo              \ Also save a copy of the low byte in sq2LoCopy
 LDA noteFrequency+1,Y
 STA sq2Hi

 LDX effectOnSQ2        \ If effectOnSQ2 is non-zero then a sound effect is
 BNE must5              \ being made on channel SQ2, so jump to must5 to skip
                        \ writing the music data to the APU (so sound effects
                        \ take precedence over music)

 LDX sq2Sweep           \ Send sq2Sweep to the APU via SQ2_SWEEP
 STX SQ2_SWEEP

 LDX sq2Lo              \ Send (sq2Hi sq2Lo) to the APU via SQ2_HI and SQ2_LO
 STX SQ2_LO
 STA SQ2_HI

.must5

 LDA #1                 \ Set volumeIndexSQ2 = 1
 STA volumeIndexSQ2

 LDA volumeRepeatSQ2    \ Set volumeCounterSQ2 = volumeRepeatSQ2
 STA volumeCounterSQ2

.must6

 LDA #&FF               \ Set applyVolumeSQ2 = &FF so we apply the volume
 STA applyVolumeSQ2     \ envelope in the next iteration

.must7

 LDA soundAddr          \ Set sectionDataSQ2(1 0) = soundAddr(1 0)
 STA sectionDataSQ2     \
 LDA soundAddr+1        \ This updates the pointer to the note data for the
 STA sectionDataSQ2+1   \ channel, so the next time we can pick up where we left
                        \ off

 LDA startPauseSQ2      \ Set pauseCountSQ2 = startPauseSQ2
 STA pauseCountSQ2      \
                        \ So if startPauseSQ2 is non-zero (as set by note data
                        \ the range &60 to &7F), the next startPauseSQ2
                        \ iterations of MakeMusicOnSQ2 will do nothing

 RTS                    \ Return from the subroutine

.must8

                        \ If we get here then bit 7 of the note data in A is
                        \ set, so this is a command byte

 LDY #0                 \ Set Y = 0, so we can use it in various commands below

 CMP #&FF               \ If A is not &FF, jump to must10 to check for the next
 BNE must10             \ command

                        \ If we get here then the command in A is &FF
                        \
                        \ <&FF> moves to the next section in the current tune

 LDA nextSectionSQ2     \ Set soundAddr(1 0) to the following:
 CLC                    \
 ADC sectionListSQ2     \   sectionListSQ2(1 0) + nextSectionSQ2(1 0)
 STA soundAddr          \
 LDA nextSectionSQ2+1   \ So soundAddr(1 0) points to the address of the next
 ADC sectionListSQ2+1   \ section in the current tune
 STA soundAddr+1        \
                        \ So if we are playing tune 2 and nextSectionSQ2(1 0)
                        \ points to the second section, then soundAddr(1 0)
                        \ will now point to the second address in tune2Data_SQ2,
                        \ which itself points to the note data for the second
                        \ section at tune2Data_SQ2_1

 LDA nextSectionSQ2     \ Set nextSectionSQ2(1 0) = nextSectionSQ2(1 0) + 2
 ADC #2                 \
 STA nextSectionSQ2     \ So nextSectionSQ2(1 0) now points to the next section,
 TYA                    \ as each section consists of two bytes in the table at
 ADC nextSectionSQ2+1   \ sectionListSQ2(1 0)
 STA nextSectionSQ2+1

 LDA (soundAddr),Y      \ If the address at soundAddr(1 0) is non-zero then it
 INY                    \ contains a valid address to the section's note data,
 ORA (soundAddr),Y      \ so jump to must9 to skip the following
 BNE must9              \
                        \ This also increments the index in Y to 1

                        \ If we get here then the command is trying to move to
                        \ the next section, but that section contains value of
                        \ &0000 in the tuneData table, so there is no next
                        \ section and we have reached the end of the tune, so
                        \ instead we jump back to the start of the tune

 LDA sectionListSQ2     \ Set soundAddr(1 0) = sectionListSQ2(1 0)
 STA soundAddr          \
 LDA sectionListSQ2+1   \ So we start again by pointing soundAddr(1 0) to the
 STA soundAddr+1        \ first entry in the section list for channel SQ2, which
                        \ contains the address of the first section's note data

 LDA #2                 \ Set nextSectionSQ2(1 0) = 2
 STA nextSectionSQ2     \
 LDA #0                 \ So the next section after we play the first section
 STA nextSectionSQ2+1   \ will be the second section

.must9

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
                        \ and commands when we rejoin the must2 loop

 JMP must2              \ Jump back to must2 to start processing data from the
                        \ new section

.must10

 CMP #&F6               \ If A is not &F6, jump to must12 to check for the next
 BNE must12             \ command

                        \ If we get here then the command in A is &F6
                        \
                        \ <&F6 &xx> sets the volume envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must11             \ in the note data
 INC soundAddr+1

.must11

 STA volumeEnvelopeSQ2  \ Set volumeEnvelopeSQ2 to the volume envelope number
                        \ that we just fetched

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must12

 CMP #&F7               \ If A is not &F7, jump to must14 to check for the next
 BNE must14             \ command

                        \ If we get here then the command in A is &F7
                        \
                        \ <&F7 &xx> sets the pitch envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must13             \ in the note data
 INC soundAddr+1

.must13

 STA pitchEnvelopeSQ2   \ Set pitchEnvelopeSQ2 to the pitch envelope number that
                        \ we just fetched

 STY pitchIndexSQ2      \ Set pitchIndexSQ2 = 0 to point to the start of the
                        \ data for pitch envelope A

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must14

 CMP #&FA               \ If A is not &FA, jump to must16 to check for the next
 BNE must16             \ command

                        \ If we get here then the command in A is &FA
                        \
                        \ <&FA %ddlc0000> configures the SQ2 channel as follows:
                        \
                        \   * %dd      = duty pulse length
                        \
                        \   * %l set   = infinite play
                        \   * %l clear = one-shot play
                        \
                        \   * %c set   = constant volume
                        \   * %c clear = envelope volume

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 STA dutyLoopEnvSQ2     \ Store the entry we just fetched in dutyLoopEnvSQ2, to
                        \ configure SQ2 as follows:
                        \
                        \   * Bits 6-7    = duty pulse length
                        \
                        \   * Bit 5 set   = infinite play
                        \   * Bit 5 clear = one-shot play
                        \
                        \   * Bit 4 set   = constant volume
                        \   * Bit 4 clear = envelope volume

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must15             \ in the note data
 INC soundAddr+1

.must15

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must16

 CMP #&F8               \ If A is not &F8, jump to must17 to check for the next
 BNE must17             \ command

                        \ If we get here then the command in A is &F8
                        \
                        \ <&F8> sets the volume of the SQ2 channel to zero

 LDA #%00110000         \ Set the volume of the SQ2 channel to zero as follows:
 STA sq2Volume          \
                        \   * Bits 6-7    = duty pulse length is 3
                        \   * Bit 5 set   = infinite play
                        \   * Bit 4 set   = constant volume
                        \   * Bits 0-3    = volume is 0

 JMP must7              \ Jump to must7 to return from the subroutine, so we
                        \ continue on from the next entry from the note data in
                        \ the next iteration

.must17

 CMP #&F9               \ If A is not &F9, jump to must18 to check for the next
 BNE must18             \ command

                        \ If we get here then the command in A is &F9
                        \
                        \ <&F9> enables the volume envelope for the SQ2 channel

 JMP must6              \ Jump to must6 to return from the subroutine after
                        \ setting applyVolumeSQ2 to &FF, so we apply the volume
                        \ envelope, and then continue on from the next entry
                        \ from the note data in the next iteration

.must18

 CMP #&FD               \ If A is not &FD, jump to must20 to check for the next
 BNE must20             \ command

                        \ If we get here then the command in A is &FD
                        \
                        \ <&F4 &xx> sets the SQ2 sweep to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must19             \ in the note data
 INC soundAddr+1

.must19

 STA sq2Sweep           \ Store the entry we just fetched in sq2Sweep, which
                        \ gets sent to the APU via SQ2_SWEEP

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must20

 CMP #&FB               \ If A is not &FB, jump to must22 to check for the next
 BNE must22             \ command

                        \ If we get here then the command in A is &FB
                        \
                        \ <&FB &xx> sets the tuning for all channels to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must21             \ in the note data
 INC soundAddr+1

.must21

 STA tuningAll          \ Store the entry we just fetched in tuningAll, which
                        \ sets the tuning for the SQ2, SQ2 and TRI channels (so
                        \ this value gets added to every note on those channels)

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must22

 CMP #&FC               \ If A is not &FC, jump to must24 to check for the next
 BNE must24             \ command

                        \ If we get here then the command in A is &FC
                        \
                        \ <&FC &xx> sets the tuning for the SQ2 channel to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must23             \ in the note data
 INC soundAddr+1

.must23

 STA tuningSQ2          \ Store the entry we just fetched in tuningSQ2, which
                        \ sets the tuning for the SQ2 channel (so this value
                        \ gets added to every note on those channels)

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must24

 CMP #&F5               \ If A is not &F5, jump to must25 to check for the next
 BNE must25             \ command

                        \ If we get here then the command in A is &F5
                        \
                        \ <&F5 &xx &yy> changes tune to the tune data at &yyxx
                        \
                        \ It does this by setting sectionListSQ2(1 0) to &yyxx
                        \ and soundAddr(1 0) to the address stored in &yyxx
                        \
                        \ To see why this works, consider switching to tune 2,
                        \ for which we would use this command:
                        \
                        \   <&F5 LO(tune2Data_SQ2) HI(tune2Data_SQ2)>
                        \
                        \ This sets:
                        \
                        \   sectionListSQ2(1 0) = tune2Data_SQ2
                        \
                        \ so from now on we fetch the addresses for each section
                        \ of the tune from the table at tune2Data_SQ2
                        \
                        \ It also sets soundAddr(1 0) to the address in the
                        \ first two bytes of tune2Data_SQ2, to give:
                        \
                        \   soundAddr(1 0) = tune2Data_SQ2_0
                        \
                        \ So from this point on, note data is fetched from the
                        \ table at tune2Data_SQ2_0, which contains notes and
                        \ commands for the first section of tune 2

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 TAX                    \ Set sectionListSQ2(1 0) = &yyxx
 STA sectionListSQ2     \
 INY                    \ Also set soundAddr(1 0) to &yyxx and increment the
 LDA (soundAddr),Y      \ index in Y to 1, both of which we use below
 STX soundAddr
 STA soundAddr+1
 STA sectionListSQ2+1

 LDA #2                 \ Set nextSectionSQ2(1 0) = 2
 STA nextSectionSQ2     \
 DEY                    \ So the next section after we play the first section
 STY nextSectionSQ2+1   \ of the new tune will be the second section
                        \
                        \ Also decrement the index in Y back to 0

 LDA (soundAddr),Y      \ Set soundAddr(1 0) to the address stored at &yyxx
 TAX
 INY
 LDA (soundAddr),Y
 STA soundAddr+1
 STX soundAddr

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must25

 CMP #&F4               \ If A is not &F4, jump to must27 to check for the next
 BNE must27             \ command

                        \ If we get here then the command in A is &F4
                        \
                        \ <&F4 &xx> sets the playback speed to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A, which
                        \ contains the new speed

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE must26             \ in the note data
 INC soundAddr+1

.must26

 STA tuneSpeed          \ Set tuneSpeed and tuneSpeedCopy to A, to change the
 STA tuneSpeedCopy      \ speed of the current tune to the specified speed

 JMP must2              \ Jump back to must2 to move on to the next entry from
                        \ the note data

.must27

 CMP #&FE               \ If A is not &FE, jump to must28 to check for the next
 BNE must28             \ command

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

.must28

 BEQ must28             \ If we get here then bit 7 of A was set but the value
                        \ didn't match any of the checks above, so this
                        \ instruction does nothing and we fall through into
                        \ ApplyEnvelopeSQ2, ignoring the data in A
                        \
                        \ I'm not sure why the instruction here is an infinite
                        \ loop, but luckily it isn't triggered as A is never
                        \ zero at this point

