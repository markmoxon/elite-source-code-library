\ ******************************************************************************
\
\       Name: LASNOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of our laser firing or the sound of us being hit by
\             lasers
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

 LDX T3                 \ Loop around for T3 iterations, so as the sound
 DEX                    \ continues and T3 increases, the wait gets longer and
 BNE P%-1               \ the frequency of the laser tone lowers into a
                        \ dissipated explosion noise

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL3             \ Loop back to make another click and wait for a rapidly
                        \ increasing amount of time between clicks, until we
                        \ have made a sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

