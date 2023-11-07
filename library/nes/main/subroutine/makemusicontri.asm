\ ******************************************************************************
\
\       Name: MakeMusicOnTRI
\       Type: Subroutine
\   Category: Sound
\    Summary: Play the current music on the TRI channel
\  Deep dive: Music in NES Elite
\
\ ******************************************************************************

.MakeMusicOnTRI

 DEC pauseCountTRI      \ Decrement the sound counter for TRI

 BEQ musr1              \ If the counter has reached zero, jump to musr1 to make
                        \ music on the TRI channel

 RTS                    \ Otherwise return from the subroutine

.musr1

 LDA sectionDataTRI     \ Set soundAddr(1 0) = sectionDataTRI(1 0)
 STA soundAddr          \
 LDA sectionDataTRI+1   \ So soundAddr(1 0) points to the note data for this
 STA soundAddr+1        \ part of the tune

.musr2

 LDY #0                 \ Set Y to the next entry from the note data
 LDA (soundAddr),Y
 TAY

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr3              \ in the note data
 INC soundAddr+1

.musr3

 TYA                    \ Set A to the next entry that we just fetched from the
                        \ note data

 BMI musr6              \ If bit 7 of A is set then this is a command byte, so
                        \ jump to musr6 to process it

 CMP #&60               \ If the note data in A is less than &60, jump to musr4
 BCC musr4

 ADC #&A0               \ The note data in A is between &60 and &7F, so set the
 STA startPauseTRI      \ following:
                        \
                        \    startPauseTRI = A - &5F
                        \
                        \ We know the C flag is set as we just passed through a
                        \ BCC, so the ADC actually adds &A1, which is the same
                        \ as subtracting &5F
                        \
                        \ So this sets startPauseTRI to a value between 1 and
                        \ 32, corresponding to note data values between &60 and
                        \ &7F

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr4

                        \ If we get here then the note data in A is less than
                        \ &60, which denotes a sound to send to the APU, so we
                        \ now convert the data to a frequency and send it to the
                        \ APU to make a sound on channel TRI

 CLC                    \ Set Y = (A + tuningAll + tuningTRI) * 2
 ADC tuningAll
 CLC
 ADC tuningTRI
 ASL A
 TAY

 LDA noteFrequency,Y    \ Set (A triLo) the frequency for note Y
 STA triLoCopy          \
 STA triLo              \ Also save a copy of the low byte in triLoCopy
 LDA noteFrequency+1,Y

 LDX triLo              \ Send (A triLo) to the APU via TRI_HI and TRI_LO
 STX TRI_LO
 STA TRI_HI

 STA triHi              \ Set (triHi triLo) = (A triLo), though this value is
                        \ never read again, so this has no effect

 LDA volumeEnvelopeTRI  \ Set the counter to the volume change to the value of
 STA volumeCounterTRI   \ volumeEnvelopeTRI, which gets set by the &F6 command

 LDA #%10000001         \ Configure the TRI channel as follows:
 STA TRI_LINEAR         \
                        \   * Bit 7 set = reload the linear counter
                        \
                        \   * Bits 0-6  = counter reload value of 1
                        \
                        \ So this enables a cycling triangle wave on the TRI
                        \ channel (so the channel is enabled)

.musr5

 LDA soundAddr          \ Set sectionDataTRI(1 0) = soundAddr(1 0)
 STA sectionDataTRI     \
 LDA soundAddr+1        \ This updates the pointer to the note data for the
 STA sectionDataTRI+1   \ channel, so the next time we can pick up where we left
                        \ off

 LDA startPauseTRI      \ Set pauseCountTRI = startPauseTRI
 STA pauseCountTRI      \
                        \ So if startPauseTRI is non-zero (as set by note data
                        \ the range &60 to &7F), the next startPauseTRI
                        \ iterations of MakeMusicOnTRI will do nothing

 RTS                    \ Return from the subroutine

.musr6

                        \ If we get here then bit 7 of the note data in A is
                        \ set, so this is a command byte

 LDY #0                 \ Set Y = 0, so we can use it in various commands below

 CMP #&FF               \ If A is not &FF, jump to musr8 to check for the next
 BNE musr8              \ command

                        \ If we get here then the command in A is &FF
                        \
                        \ <&FF> moves to the next section in the current tune

 LDA nextSectionTRI     \ Set soundAddr(1 0) to the following:
 CLC                    \
 ADC sectionListTRI     \   sectionListTRI(1 0) + nextSectionTRI(1 0)
 STA soundAddr          \
 LDA nextSectionTRI+1   \ So soundAddr(1 0) points to the address of the next
 ADC sectionListTRI+1   \ section in the current tune
 STA soundAddr+1        \
                        \ So if we are playing tune 2 and nextSectionTRI(1 0)
                        \ points to the second section, then soundAddr(1 0)
                        \ will now point to the second address in tune2Data_TRI,
                        \ which itself points to the note data for the second
                        \ section at tune2Data_TRI_1

 LDA nextSectionTRI     \ Set nextSectionTRI(1 0) = nextSectionTRI(1 0) + 2
 ADC #2                 \
 STA nextSectionTRI     \ So nextSectionTRI(1 0) now points to the next section,
 TYA                    \ as each section consists of two bytes in the table at
 ADC nextSectionTRI+1   \ sectionListTRI(1 0)
 STA nextSectionTRI+1

 LDA (soundAddr),Y      \ If the address at soundAddr(1 0) is non-zero then it
 INY                    \ contains a valid address to the section's note data,
 ORA (soundAddr),Y      \ so jump to musr7 to skip the following
 BNE musr7              \
                        \ This also increments the index in Y to 1

                        \ If we get here then the command is trying to move to
                        \ the next section, but that section contains value of
                        \ &0000 in the tuneData table, so there is no next
                        \ section and we have reached the end of the tune, so
                        \ instead we jump back to the start of the tune

 LDA sectionListTRI     \ Set soundAddr(1 0) = sectionListTRI(1 0)
 STA soundAddr          \
 LDA sectionListTRI+1   \ So we start again by pointing soundAddr(1 0) to the
 STA soundAddr+1        \ first entry in the section list for channel TRI, which
                        \ contains the address of the first section's note data

 LDA #2                 \ Set nextSectionTRI(1 0) = 2
 STA nextSectionTRI     \
 LDA #0                 \ So the next section after we play the first section
 STA nextSectionTRI+1   \ will be the second section

.musr7

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
                        \ and commands when we rejoin the musr2 loop

 JMP musr2              \ Jump back to musr2 to start processing data from the
                        \ new section

.musr8

 CMP #&F6               \ If A is not &F6, jump to musr10 to check for the next
 BNE musr10             \ command

                        \ If we get here then the command in A is &F6
                        \
                        \ <&F6 &xx> sets the volume envelope counter to &xx
                        \
                        \ In the other channels, this command lets us choose a
                        \ volume envelope number
                        \
                        \ In the case of the TRI channel, there isn't a volume
                        \ envelope as such, because the channel is either off or
                        \ on and doesn't have a volume setting, so instead of
                        \ this command choosing a volume envelope number, it
                        \ sets a counter that determines the number of
                        \ iterations before the channel gets silenced
                        \
                        \ I've kept the variable names in the same format as the
                        \ other channels for consistency

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr9              \ in the note data
 INC soundAddr+1

.musr9

 STA volumeEnvelopeTRI  \ Set volumeEnvelopeTRI to the volume envelope number
                        \ that we just fetched

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr10

 CMP #&F7               \ If A is not &F7, jump to musr12 to check for the next
 BNE musr12             \ command

                        \ If we get here then the command in A is &F7
                        \
                        \ <&F7 &xx> sets the pitch envelope number to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr11             \ in the note data
 INC soundAddr+1

.musr11

 STA pitchEnvelopeTRI   \ Set pitchEnvelopeTRI to the pitch envelope number that
                        \ we just fetched

 STY pitchIndexTRI      \ Set pitchIndexTRI = 0 to point to the start of the
                        \ data for pitch envelope A

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr12

 CMP #&F8               \ If A is not &F8, jump to musr13 to check for the next
 BNE musr13             \ command

                        \ If we get here then the command in A is &F8
                        \
                        \ <&F8> sets the volume of the TRI channel to zero

 LDA #1                 \ Set the counter in volumeCounterTRI to 1, so when we
 STA volumeCounterTRI   \ return from the subroutine and call ApplyEnvelopeTRI,
                        \ the TRI channel gets silenced

 JMP musr5              \ Jump to musr5 to return from the subroutine, so we
                        \ continue on from the next entry from the note data in
                        \ the next iteration

.musr13

 CMP #&F9               \ If A is not &F9, jump to musr14 to check for the next
 BNE musr14             \ command

                        \ If we get here then the command in A is &F9
                        \
                        \ <&F9> enables the volume envelope for the TRI channel

 JMP musr5              \ Jump to musr5 to return from the subroutine, so we
                        \ continue on from the next entry from the note data in
                        \ the next iteration

.musr14

 CMP #&FB               \ If A is not &FB, jump to musr16 to check for the next
 BNE musr16             \ command

                        \ If we get here then the command in A is &FB
                        \
                        \ <&FB &xx> sets the tuning for all channels to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr15             \ in the note data
 INC soundAddr+1

.musr15

 STA tuningAll          \ Store the entry we just fetched in tuningAll, which
                        \ sets the tuning for the TRI, TRI and TRI channels (so
                        \ this value gets added to every note on those channels)

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr16

 CMP #&FC               \ If A is not &FC, jump to musr18 to check for the next
 BNE musr18             \ command

                        \ If we get here then the command in A is &FC
                        \
                        \ <&FC &xx> sets the tuning for the TRI channel to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr17             \ in the note data
 INC soundAddr+1

.musr17

 STA tuningTRI          \ Store the entry we just fetched in tuningTRI, which
                        \ sets the tuning for the TRI channel (so this value
                        \ gets added to every note on those channels)

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr18

 CMP #&F5               \ If A is not &F5, jump to musr19 to check for the next
 BNE musr19             \ command

                        \ If we get here then the command in A is &F5
                        \
                        \ <&F5 &xx &yy> changes tune to the tune data at &yyxx
                        \
                        \ It does this by setting sectionListTRI(1 0) to &yyxx
                        \ and soundAddr(1 0) to the address stored in &yyxx
                        \
                        \ To see why this works, consider switching to tune 2,
                        \ for which we would use this command:
                        \
                        \   <&F5 LO(tune2Data_TRI) LO(tune2Data_TRI)>
                        \
                        \ This sets:
                        \
                        \   sectionListTRI(1 0) = tune2Data_TRI
                        \
                        \ so from now on we fetch the addresses for each section
                        \ of the tune from the table at tune2Data_TRI
                        \
                        \ It also sets soundAddr(1 0) to the address in the
                        \ first two bytes of tune2Data_TRI, to give:
                        \
                        \   soundAddr(1 0) = tune2Data_TRI_0
                        \
                        \ So from this point on, note data is fetched from the
                        \ table at tune2Data_TRI_0, which contains notes and
                        \ commands for the first section of tune 2

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A

 TAX                    \ Set sectionListTRI(1 0) = &yyxx
 STA sectionListTRI     \
 INY                    \ Also set soundAddr(1 0) to &yyxx and increment the
 LDA (soundAddr),Y      \ index in Y to 1, both of which we use below
 STX soundAddr
 STA soundAddr+1
 STA sectionListTRI+1

 LDA #2                 \ Set nextSectionTRI(1 0) = 2
 STA nextSectionTRI     \
 DEY                    \ So the next section after we play the first section
 STY nextSectionTRI+1   \ of the new tune will be the second section
                        \
                        \ Also decrement the index in Y back to 0

 LDA (soundAddr),Y      \ Set soundAddr(1 0) to the address stored at &yyxx
 TAX
 INY
 LDA (soundAddr),Y
 STA soundAddr+1
 STX soundAddr

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr19

 CMP #&F4               \ If A is not &F4, jump to musr21 to check for the next
 BNE musr21             \ command

                        \ If we get here then the command in A is &F4
                        \
                        \ <&F4 &xx> sets the playback speed to &xx

 LDA (soundAddr),Y      \ Fetch the next entry in the note data into A, which
                        \ contains the new speed

 INC soundAddr          \ Increment soundAddr(1 0) to point to the next entry
 BNE musr20             \ in the note data
 INC soundAddr+1

.musr20

 STA tuneSpeed          \ Set tuneSpeed and tuneSpeedCopy to A, to change the
 STA tuneSpeedCopy      \ speed of the current tune to the specified speed

 JMP musr2              \ Jump back to musr2 to move on to the next entry from
                        \ the note data

.musr21

 CMP #&FE               \ If A is not &FE, jump to musr22 to check for the next
 BNE musr22             \ command

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

.musr22

 BEQ musr22             \ If we get here then bit 7 of A was set but the value
                        \ didn't match any of the checks above, so this
                        \ instruction does nothing and we fall through into
                        \ ApplyEnvelopeTRI, ignoring the data in A
                        \
                        \ I'm not sure why the instruction here is an infinite
                        \ loop, but luckily it isn't triggered as A is never
                        \ zero at this point

