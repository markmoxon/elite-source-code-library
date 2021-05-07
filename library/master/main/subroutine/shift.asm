\ ******************************************************************************
\
\       Name: SHIFT
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard to see if SHIFT is currently pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X = %10000000 if SHIFT is being pressed
\
\                       X = 0 if SHIFT is not being pressed
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.SHIFT

IF _COMPACT

 LDA #0                 \ Set A to the internal key number for SHIFT and fall
                        \ through to DSK4 to scan the keyboard

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &49, or BIT &49A9, which does nothing apart
                        \ from affect the flags

ENDIF

