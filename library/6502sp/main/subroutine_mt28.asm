\ ******************************************************************************
\
\       Name: MT28
\       Type: Subroutine
\   Category: Text
\    Summary: Print extended token 220-227 depending on the galaxy number
\
\ ******************************************************************************

.MT28

 LDA #220               \ Set A = galaxy number in GCNT + 220
 CLC
 ADC GCNT

 BNE DETOK              \ Jump to DETOK to print extended token 220-227,
                        \ returning from the subroutine using a tail call (this
                        \ BNE is effectively a JMP as A is never zero)

