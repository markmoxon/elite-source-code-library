\ ******************************************************************************
\
\       Name: ChooseMusic
\       Type: Subroutine
\   Category: Sound
\    Summary: Set the tune for the background music
\
\ ------------------------------------------------------------------------------
\
\ The tune numbers are as follows:
\
\   * 0 for the title music ("Elite Theme"), which is set in the TITLE routine
\       and as the default tune in the ResetMusic routine
\
\   * 1 for docking ("The Blue Danube"), which is set in the TT102 routine
\
\   * 2 for the combat demo music ("Game Theme"), though this is never set
\       directly, only via tune 4
\
\   * 3 for the scroll text music ("Assassin's Touch"), though this is never set
\       directly, only via tune 4
\
\   * 4 for the full combat demo suite ("Assassin's Touch" followed by "Game
\       Theme"), which is set in the DEATH2 routine
\
\ Arguments:
\
\   A                   The number of the tune to choose
\
\ ******************************************************************************

.ChooseMusic

 TAY                    \ Set Y to the tune number

 JSR StopSoundsS        \ Call StopSounds via StopSoundsS to stop all sounds
                        \ (both music and sound effects)
                        \
                        \ This also sets enableSound to 0

                        \ We now calculate the offset into the tuneData table
                        \ for this tune\s data, which will be Y * 9 as there are
                        \ nine bytes for each tune at the start of the table

 LDA #0                 \ Set A = 0 so we can build the results of the
                        \ calculation by adding 9 to A, Y times

 CLC                    \ Clear the C flag for the addition below

.cmus1

 DEY                    \ Decrement the tune number in Y

 BMI cmus2              \ If the result is negative then A contains the result
                        \ of Y * 9, so jump to cmus2

 ADC #9                 \ Set A = A * 9

 BNE cmus1              \ Loop back to cmus1 to add another 9 to A (this BNE is
                        \ effectively a JMP as A is never zero)

.cmus2

 TAX                    \ Copy the result into X, so X = tune number * 9, which
                        \ we can use as the offset into the tuneData table
                        \ below

                        \ We now reset the four 19-byte blocks of memory that
                        \ are used to store the channel-specific variables, as
                        \ follows:
                        \
                        \   sectionDataSQ1   to applyVolumeSQ1
                        \   sectionDataSQ2   to applyVolumeSQ2
                        \   sectionDataTRI   to volumeEnvelopeTRI+1
                        \   sectionDataNOISE to applyVolumeNOISE
                        \
                        \ There is no volumeEnvelopeTRI variable but the space
                        \ is still reserved, which is why the TRI channel clears
                        \ to volumeEnvelopeTRI+1

 LDA #0                 \ Set A = 0 to use when zeroing these locations

 LDY #18                \ Set a counter in Y for the 19 bytes in each block

.cmus3

 STA sectionDataSQ1,Y   \ Zero the Y-th byte of sectionDataSQ1

 STA sectionDataSQ2,Y   \ Zero the Y-th byte of sectionDataSQ2

 STA sectionDataTRI,Y   \ Zero the Y-th byte of sectionDataTRI

 STA sectionDataNOISE,Y \ Zero the Y-th byte of sectionDataNOISE

 DEY                    \ Decrement the loop counter in Y

 BPL cmus3              \ Loop back until we have zeroed bytes 0 to 18 in all
                        \ four blocks

 TAY                    \ Set Y = 0, to use as an index when fetching addresses
                        \ from the tuneData table

 LDA tuneData,X         \ Fetch the first byte from the tune's block at
 STA tuneSpeed          \ tuneData, which contains the tune's speed, and store
 STA tuneSpeedCopy      \ it in tuneSpeed and tuneSpeedCopy
                        \
                        \ For tune 0, this would be 47

 LDA tuneData+1,X       \ Set soundAddr(1 0) and sectionListSQ1(1 0) to the
 STA sectionListSQ1     \ first address from the tune's block at tuneData
 STA soundAddr          \
 LDA tuneData+2,X       \ For tune 0, this would set both variables to point to
 STA sectionListSQ1+1   \ the list of tune sections at tune0Data_SQ1
 STA soundAddr+1

 LDA (soundAddr),Y      \ Fetch the address that the first address points to
 STA sectionDataSQ1     \ and put it in sectionDataSQ1(1 0), incrementing the
 INY                    \ index in Y in the process
 LDA (soundAddr),Y      \
 STA sectionDataSQ1+1   \ For tune 0, this would set sectionDataSQ1(1 0) to the
                        \ address of tune0Data_SQ1_0

 LDA tuneData+3,X       \ Set soundAddr(1 0) and sectionListSQ2(1 0) to the
 STA sectionListSQ2     \ second address from the tune's block at tuneData
 STA soundAddr          \
 LDA tuneData+4,X       \ For tune 0, this would set both variables to point to
 STA sectionListSQ2+1   \ the list of tune sections at tune0Data_SQ2
 STA soundAddr+1

 DEY                    \ Decrement the index in Y, so it is zero once again

 LDA (soundAddr),Y      \ Fetch the address that the second address points to
 STA sectionDataSQ2     \ and put it in sectionDataSQ2(1 0), incrementing the
 INY                    \ index in Y in the process
 LDA (soundAddr),Y      \
 STA sectionDataSQ2+1   \ For tune 0, this would set sectionDataSQ2(1 0) to the
                        \ address of tune0Data_SQ2_0

 LDA tuneData+5,X       \ Set soundAddr(1 0) and sectionListTRI(1 0) to the
 STA sectionListTRI     \ third address from the tune's block at tuneData
 STA soundAddr          \
 LDA tuneData+6,X       \ For tune 0, this would set both variables to point to
 STA sectionListTRI+1   \ the list of tune sections at tune0Data_TRI
 STA soundAddr+1

 DEY                    \ Decrement the index in Y, so it is zero once again

 LDA (soundAddr),Y      \ Fetch the address that the third address points to
 STA sectionDataTRI     \ and put it in sectionDataTRI(1 0), incrementing the
 INY                    \ index in Y in the process
 LDA (soundAddr),Y      \
 STA sectionDataTRI+1   \ For tune 0, this would set sectionDataTRI(1 0) to the
                        \ address of tune0Data_TRI_0

 LDA tuneData+7,X       \ Set soundAddr(1 0) and sectionListNOISE(1 0) to the
 STA sectionListNOISE   \ fourth address from the tune's block at tuneData
 STA soundAddr          \
 LDA tuneData+8,X       \ For tune 0, this would set both variables to point to
 STA sectionListNOISE+1 \ the list of tune sections at tune0Data_NOISE
 STA soundAddr+1

 DEY                    \ Decrement the index in Y, so it is zero once again

 LDA (soundAddr),Y      \ Fetch the address that the fourth address points to
 STA sectionDataNOISE   \ and put it in sectionDataNOISE(1 0), incrementing the
 INY                    \ index in Y in the process
 LDA (soundAddr),Y      \
 STA sectionDataNOISE+1 \ For tune 0, this would set sectionDataNOISE(1 0) to
                        \ the address of tune0Data_NOISE_0

 STY pauseCountSQ1      \ Set pauseCountSQ1 = 1 so we start sending music to the
                        \ SQ1 channel straight away, without a pause

 STY pauseCountSQ2      \ Set pauseCountSQ2 = 1 so we start sending music to the
                        \ SQ2 channel straight away, without a pause

 STY pauseCountTRI      \ Set pauseCountTRI = 1 so we start sending music to the
                        \ TRI channel straight away, without a pause

 STY pauseCountNOISE    \ Set pauseCountNOISE = 1 so we start sending music to
                        \ the NOISE channel straight away, without a pause


 INY                    \ Increment Y to 2

 STY nextSectionSQ1     \ Set nextSectionSQ1(1 0) = 2 (the high byte was already
                        \ zeroed above), so the next section after the first on
                        \ the SQ1 channel is the second section

 STY nextSectionSQ2     \ Set nextSectionSQ2(1 0) = 2 (the high byte was already
                        \ zeroed above), so the next section after the first on
                        \ the SQ2 channel is the second section

 STY nextSectionTRI     \ Set nextSectionTRI(1 0) = 2 (the high byte was already
                        \ zeroed above), so the next section after the first on
                        \ the TRI channel is the second section

 STY nextSectionNOISE   \ Set nextSectionNOISE = 2 (the high byte was already
                        \ zeroed above), so the next section after the first on
                        \ the NOISE channel is the second section

 LDX #0                 \ Set tuningAll = 0 to set all channels to the default
 STX tuningAll          \ tuning

 DEX                    \ Decrement X to &FF

 STX tuneProgress       \ Set tuneProgress = &FF, so adding any non-zero speed
                        \ at the start of MakeMusic will overflow the progress
                        \ counter and start playing the music straight away

 STX playMusic          \ Set playMusic = &FF to enable the new tune to be
                        \ played

 INC enableSound        \ Increment enableSound to 1 to enable sound, now that
                        \ we have set up the music to play

 RTS                    \ Return from the subroutine

