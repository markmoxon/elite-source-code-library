\ ******************************************************************************
\
\       Name: pr2
\       Type: Subroutine
\   Category: Text
\    Summary: Print an 8-bit number, left-padded to 3 digits, and optional point
\
\ ------------------------------------------------------------------------------
\
\ Print the 8-bit number in X to 3 digits, left-padding with spaces for numbers
\ with fewer than 3 digits (so numbers < 100 are right-aligned). Optionally
\ include a decimal point.
\
\ Arguments:
\
\   X                   The number to print
\
\   C flag              If set, include a decimal point
\
\ Other entry points:
\
\   pr2+2               Print the 8-bit number in X to the number of digits in A
\
IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\   pr2-1               Print X without a decimal point
\
ENDIF
\ ******************************************************************************

IF _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 CLC                    \ Clear the C flag so the routine doesn't print a
                        \ decimal point if called via pr2-1

ENDIF

.pr2

 LDA #3                 \ Set A to the number of digits (3)

 LDY #0                 \ Zero the Y register, so we can fall through into TT11
                        \ to print the 16-bit number (Y X) to 3 digits, which
                        \ effectively prints X to 3 digits as the high byte is
                        \ zero

