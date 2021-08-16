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
IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\ Other entry points:
\
\   n_store             Set K(3 2 1) = (A A A) and clear the C flag
\
ENDIF
\ ******************************************************************************

.MU5

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA)

 STA K                  \ Set K(3 2 1 0) to (A A A A)
 STA K+1
 STA K+2
 STA K+3

ELIF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 STA K                  \ Set K(3 2 1 0) to (A A A A), starting with the lowest
                        \ byte

.n_store

 STA K+1                \ And then the high bytes
 STA K+2
 STA K+3

ENDIF

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

