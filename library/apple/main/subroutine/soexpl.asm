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

 INC T3                 \ Increment the period in T3

 LDX T3                 \ Loop around for T3 iterations, waiting for four cycles
 DEX                    \ in each iteration, so as the sound continues and T3
 NOP                    \ increases, the wait gets longer and the frequency of
 NOP                    \ the explosion tone lowers into a dissipated explosion
 BNE P%-3               \ noise

 JSR DORND              \ Set A and X to random numbers

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 2 * X
                        \ CPU cycles

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL4             \ Loop back to make another click and wait for a random
                        \ and (on average) increasing amount of time between
                        \ clicks, until we have made a sound consisting of Y
                        \ clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

