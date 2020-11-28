\ ******************************************************************************
\
\       Name: MT28
\       Type: Subroutine
\   Category: Text
\    Summary: Print extended token 220-221 depending on the galaxy number (0-1)
\
\ ******************************************************************************

.MT28

 LDA #220               \ Set A = galaxy number in GCNT + 220, which is in the
 CLC                    \ range 220-221, as this is only called in galaxies 0
 ADC GCNT               \ and 1

 BNE DETOK              \ Jump to DETOK to print extended token 220-221,
                        \ returning from the subroutine using a tail call (this
                        \ BNE is effectively a JMP as A is never zero)

