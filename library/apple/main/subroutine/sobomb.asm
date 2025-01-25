\ ******************************************************************************
\
\       Name: SOBOMB
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of an energy bomb going off
\
\ ******************************************************************************

.SOBOMB

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR               \ so return from the subroutine (as SOUR contains an
                        \ RTS)

 LDY #25                \ Set the length of the loop below to 25 clicks, so we
                        \ make a total of 26 clicks in the following

.SOHISS4

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 JSR DORND              \ Set A and X to random numbers

 AND #31                \ Reduce A to a random number in the range 0 to 31

 ORA #&E0               \ Increase A to a random number in the range 224 to 255

 TAX                    \ Set X to our random number in the range 224 to 255,
                        \ which we now use as the period for our sound (so this
                        \ is a low toned explosion sound with a random element
                        \ of white noise, like a dissipated explosion)

 DEX                    \ Decrement the random number in X

 NOP                    \ Wait for two CPU cycles

 BNE P%-2               \ If X is non-zero then loop back to repeat the DEX and
                        \ NOP instructions, so this waits for a total of 2 * X
                        \ CPU cycles

 DEY                    \ Decrement the sound length in Y

 BNE SOHISS4            \ Loop back to make another click and wait for a random
                        \ amount of time between clicks, until we have made a
                        \ sound consisting of Y clicks

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

 RTS                    \ Return from the subroutine

