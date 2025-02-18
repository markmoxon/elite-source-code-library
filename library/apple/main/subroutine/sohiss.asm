\ ******************************************************************************
\
\       Name: SOHISS
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a launch from the station, hyperspace or missile
\             launch
\  Deep dive: Sound effects in Apple II Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The type of sound (i.e. the length of the explosion):
\
\                         * 0 = start of a launch from a station (called twice
\                               in succession from LAUN, with the 0 indicating
\                               a sound length of 256)
\
\                         * 10 = launch or hyperspace tunnel (called each time
\                                we draw a tunnel ring in HFS2)
\
\                         * 50 = enemy missile launch (SFRMIS)
\
\                         * 120 = our missile launch (FRMIS)
\
\ ******************************************************************************

.SOHISS

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

.SOHISS2

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

                        \ We now make a hissing sound by making Y clicks on the
                        \ speaker, and pausing for a random amount of time
                        \ between each successive click

 JSR DORND              \ Set A and X to random numbers

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for four CPU cycles (as each NOP takes two CPU
 NOP                    \ cycles)

 BNE P%-3               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 9 * X
                        \ CPU cycles (as the DEX takes two cycles, the NOPs take
                        \ another two cycles each, a successful BNE takes three
                        \ cycles, and we repeat these nine cycles X times)

 DEY                    \ Decrement the sound length in Y

 BNE SOHISS2            \ Loop back to make another click and wait for a random
                        \ amount of time between clicks, until we have made a
                        \ sound consisting of Y clicks
                        \
                        \ An argument of Y = 0 will therefore make 256 clicks in
                        \ the above loop

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

