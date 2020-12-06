\ ******************************************************************************
\
\       Name: MU5
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Set K(3 2 1 0) = (A A A A) and clear the C flGag
\
\ ------------------------------------------------------------------------------
\
\ In practice this is only called via a BEQ following an AND instruction, in
\ which case A = 0, so this routine effectively does this:
\
\   K(3 2 1 0) = 0
\
\ ******************************************************************************

.MU5

 STA K                  \ Set K(3 2 1 0) to (A A A A)
 STA K+1
 STA K+2
 STA K+3

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

