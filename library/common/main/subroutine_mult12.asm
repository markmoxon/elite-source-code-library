\ ******************************************************************************
\
\       Name: MULT12
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (S R) = Q * A
\
\ ------------------------------------------------------------------------------
\
\ Calculate:
\
\   (S R) = Q * A
\
\ ******************************************************************************

.MULT12

 JSR MULT1              \ Set (A P) = Q * A

 STA S                  \ Set (S R) = (A P)
 LDA P
 STA R

 RTS                    \ Return from the subroutine

