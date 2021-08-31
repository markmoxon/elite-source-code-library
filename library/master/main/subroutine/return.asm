\ ******************************************************************************
\
\       Name: RETURN
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard to see if RETURN is currently pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X = %11001001 if RETURN is being pressed
\
\                       X = %01001001 if RETURN is not being pressed
\
\   A                   Contains the same as X
\
\ ******************************************************************************

IF _COMPACT

.RETURN

 LDA #&49               \ Set A to the internal key number for RETURN and fall
                        \ through to DKS4mc to scan the keyboard

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &01, or BIT &01A9, which does nothing apart
                        \ from affect the flags

ENDIF

