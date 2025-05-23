\ ******************************************************************************
\
\       Name: PIX1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (YY+1 SYL+Y) = (A P) + (S R) and draw stardust particle
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   (YY+1 SYL+Y) = (A P) + (S R)
\
\ and draw a stardust particle at (X1,Y1) with distance ZZ.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (A P)               A is the angle ALPHA or BETA, P is always 0
\
\   (S R)               YY(1 0) or YY(1 0) + Q * A
\
\   Y                   Stardust particle number
\
\   X1                  The x-coordinate offset
\
\   Y1                  The y-coordinate offset
\
\   ZZ                  The distance of the point, with bigger distances drawing
\                       smaller points:
\
IF NOT(_APPLE_VERSION)
\                         * ZZ < 80           Double-height four-pixel square
\
\                         * 80 <= ZZ <= 143   Single-height two-pixel dash
\
\                         * ZZ > 143          Single-height one-pixel dot
ELIF _APPLE_VERSION
\                         * ZZ < 80           Double-height three-pixel dash
\
\                         * 80 <= ZZ <= 127   Single-height three-pixel dash
\
\                         * ZZ > 127          Single-height two-pixel dash
ENDIF
\
\ ******************************************************************************

.PIX1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Label

 JSR ADD                \ Set (A X) = (A P) + (S R)

ELIF _MASTER_VERSION

 JSR ADDK               \ Set (A X) = (A P) + (S R)

ENDIF

 STA YY+1               \ Set YY+1 to A, the high byte of the result

 TXA                    \ Set SYL+Y to X, the low byte of the result
 STA SYL,Y

                        \ Fall through into PIXEL2 to draw the stardust particle
                        \ at (X1,Y1)

