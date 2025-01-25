\ ******************************************************************************
\
\       Name: CLICK
\       Type: Subroutine
\   Category: Sound
\    Summary: Toggle the state of the speaker (i.e. move it in or out) to make a
\             single click
\
\ ******************************************************************************

.CLICK

 BIT DNOIZ              \ If bit 7 of DNOIZ is non-zero, then sound is disabled,
 BMI SOUR2              \ so jump to SOUR2 to return from the subroutine

 LDA &C030              \ Toggle the state of the speaker (i.e. move it in or
                        \ out) by reading the SPEAKER soft switch

.SOUR2

 RTS                    \ Return from the subroutine

