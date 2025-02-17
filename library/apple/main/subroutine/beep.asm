\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SOBEEP              Make a beep as follows:
\
\                         * X = the period of the beep (a bigger value means a
\                               lower pitch)
\
\                         * Y = the length of the beep
\
\   SOUR                Contains an RTS
\
\ ******************************************************************************

.BEEP

 LDY #30                \ Set the length of the loop below to 30 clicks, so we
                        \ make a total of 31 clicks in the following

 LDX #110               \ Set the period of the sound at 110 for a high beep

.SOBEEP

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 STX T3                 \ Store the period in T3

.BEEPL1

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 LDX T3                 \ Set X to the period length in T3 iterations, so the
                        \ higher the period in X, the longer the pause in the
                        \ following loop

 DEX                    \ Decrement the period counter in X

 BNE P%-1               \ If X is non-zero then loop back to repeat the DEX
                        \ instruction, so this waits for a total of 5 * X
                        \ CPU cycles (as the DEX takes two cycles, a successful
                        \ BNE takes three cycles, and we repeat these five
                        \ cycles X times)

 DEY                    \ Decrement the sound length in Y

 BNE BEEPL1             \ Loop back to make another click until we have made a
                        \ sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

.SOUR

 RTS                    \ Return from the subroutine

