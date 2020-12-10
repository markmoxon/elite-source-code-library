\ ******************************************************************************
\
\       Name: BR1
\       Type: Subroutine
\   Category: Start and end
\    Summary: Restart the game
\
\ ******************************************************************************

.BR1

 JSR ZEKTRAN            \ Reset the key logger buffer that gets returned from
                        \ the I/O processor

 LDA #3                 \ Move the text cursor to column 3
 JSR DOXC
                        
 LDX #3                 \ Disable the ESCAPE key and clear memory if the BREAK
 JSR FX200              \ key is pressed (*FX 200, 3)

 LDX #CYL               \ Call the TITLE subroutine to show the rotating ship
 LDA #6                 \ and load prompt. The arguments sent to TITLE are:
 JSR TITLE              \
                        \   X = type of ship to show, #CYL is a Cobra Mk III
                        \
                        \   A = text token to show below the rotating ship, 6
                        \       is "LOAD NEW {single cap}COMMANDER {all caps}
                        \       (Y/N)?{sentence case}{cr}{cr}"
                        \
                        \ The TITLE subroutine returns with the internal number
                        \ of the key pressed in A (see p.142 of the Advanced
                        \ User Guide for a list of internal key number)

 CMP #&60               \ Did we press TAB? If not, skip the following
 BNE P%+5               \ instruction

.BRGO

 JMP DEMON              \ We pressed TAB, so jump to DEMON to show the demo

 CMP #&44               \ Did we press "Y"? If not, jump to QU5, otherwise
 BNE QU5                \ continue on to load a new commander

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

 JSR SVE                \ Call SVE to load a new commander into the last saved
                        \ commander data block

.QU5

 JSR DFAULT             \ Call DFAULT to reset the current commander data block
                        \ to the last saved commander

 JSR msblob             \ Reset the dashboard's missile indicators to all be
                        \ green

 LDA #7                 \ Call the TITLE subroutine to show the rotating ship
 LDX #ASP               \ and load prompt. The arguments sent to TITLE are:
 JSR TITLE              \
                        \   X = type of ship to show, #ASP is an Asp Mk II
                        \
                        \   A = text token to show below the rotating ship, 6
                        \       is "LOAD NEW {single cap}COMMANDER {all caps}
                        \       (Y/N)?{sentence case}{cr}{cr}"

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

                        \ The rest of this routine is almost identical to the
                        \ hyp routine in the cassette version

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)
                        
                        \ The label below is called likeTT112 because this code
                        \ is almost identical to the TT112 loop in the hyp
                        \ routine in the cassette version

.likeTT112

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ2,
 STA QQ2,X

 DEX                    \ Decrement the counter

 BPL likeTT112          \ Loop back to likeTT112 if we still have more bytes to
                        \ copy

 INX                    \ Set X = 0 (as we ended the above loop with X = &FF)

 STX EV                 \ Set EV, the extra vessels spawning counter, to 0, as
                        \ we are entering a new system with no extra vessels
                        \ spawned

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

