\ ******************************************************************************
\
\       Name: LASNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of our laser firing or the sound of us being hit by
\             lasers
\  Deep dive: Sound effects in Apple II Elite
\
\ ******************************************************************************

.LASNOISE

 LDY #11                \ Set the length of the loop below to 11 clicks, so we
                        \ make a total of 12 clicks in the following

 LDX #150               \ Set the period of the sound at 150, which increases
                        \ as the sound progresses

.SOBLOP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL3

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 INC T3                 \ Increment the period in T3 twice, so the tone of the
 INC T3                 \ sound falls rapidly

 LDX T3                 \ Set X to the period length in T3 iterations, so the
                        \ higher the period in X, the longer the pause in the
                        \ following loop, so the pause gets longer and the
                        \ frequency of the laser tone lowers into a dissipated
                        \ explosion noise

 DEX                    \ Decrement the period counter in X

 BNE P%-1               \ If X is non-zero then loop back to repeat the DEX
                        \ instruction, so this waits for a total of 5 * X
                        \ CPU cycles (as the DEX takes two cycles, a successful
                        \ BNE takes three cycles, and we repeat these five
                        \ cycles X times)

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL3             \ Loop back to make another click and wait for a rapidly
                        \ increasing amount of time between clicks, until we
                        \ have made a sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

