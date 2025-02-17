\ ******************************************************************************
\
\       Name: SOBLIP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of the hyperspace drive being engaged, or the sound
\             of the E.C.M.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The period of the sound (a bigger value means a lower
\                       pitch)
\
\   Y                   The type of sound (i.e. the length of the sound):
\
\                         * 20 = the sound of the E.C.M going off (part 16 of
\                                the main flight loop)
\
\                         * 90 = the sound of the hyperspace drive being engaged
\                                (LL164)
\
\ ******************************************************************************

.SOBLIP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL2

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 DEC T3                 \ Decrement the period in T3

 LDX T3                 \ Set X to the period length in T3 iterations, so the
                        \ higher the period in X, the longer the pause in the
                        \ following loop, so the pause gets shorter and the
                        \ frequency of the sound rises as it progresses

 DEX                    \ Decrement the period counter in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX
                        \ instruction, so this waits for a total of 7 * X
                        \ CPU cycles (as the DEX takes two cycles, the NOP takes
                        \ another two cycles, a successful BNE takes three
                        \ cycles, and we repeat these seven cycles X times)

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL2             \ Loop back to make another click and wait for a
                        \ decreasing amount of time between clicks, until we
                        \ have made a sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

