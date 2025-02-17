\ ******************************************************************************
\
\       Name: SOEXPL
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The type of sound (i.e. the length of the explosion):
\
\                         * 15 = the sound of a laser strike on another ship
\                                (EXNO)
\
\                         * 40 = the sound of a collision, or an exploding cargo
\                                canister or missile (EXNO3)
\
\                         * 55 = the sound of a ship exploding (EXNO2)
\
\                         * 210 = the sound of us dying (DEATH)
\
\ ******************************************************************************

.SOEXPL

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 LDX #50                \ Set T3 = 50 to use as the starting period for this
 STX T3                 \ sound (which increases as the sound continues, which
                        \ spaces out the clicks and makes the sound of the
                        \ explosion dissipate

.BEEPL4

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 INC T3                 \ Increment the period in T3, so the tone of the sound
                        \ falls slowly

 LDX T3                 \ Set X to the period length in T3 iterations, so the
                        \ higher the period in X, the longer the pause in the
                        \ following loop, so the pause gets longer and the
                        \ frequency of the explosion tone lowers into a
                        \ dissipated explosion noise

 DEX                    \ Decrement the period counter in X

 NOP                    \ Wait for four CPU cycles
 NOP

 BNE P%-3               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 9 * X
                        \ CPU cycles (as the DEX takes two cycles, the NOPs take
                        \ another two cycles each, a successful BNE takes three
                        \ cycles, and we repeat these nine cycles X times)

 JSR DORND              \ Set A and X to random numbers

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 7 * X
                        \ CPU cycles (as the DEX takes two cycles, the NOP takes
                        \ another two cycles, a successful BNE takes three
                        \ cycles, and we repeat these seven cycles X times)

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL4             \ Loop back to make another click and wait for a random
                        \ and (on average) increasing amount of time between
                        \ clicks, until we have made a sound consisting of Y
                        \ clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

