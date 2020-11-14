\ ******************************************************************************
\
\       Name: NLIN2
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a screen-wide horizontal line at the pixel row in A
\
\ ------------------------------------------------------------------------------
\
\ This draws a line from (2, A) to (254, A), which is almost screen-wide and
\ fits in nicely between the white borders without clashing with it.
\
\ Arguments:
\
\   A                   The pixel row on which to draw the horizontal line
\
\ ******************************************************************************

.NLIN2

IF _CASSETTE_VERSION

 STA Y1                 \ Set (X1, Y1) = (2, A)
 LDX #2
 STX X1

ELIF _6502SP_VERSION

 STA Y1
 STA Y2
 LDA #YELLOW
 JSR DOCOL

 LDX #2                 \ Set X1 = 2, so (X1, Y1) = (2, A)
 STX X1

ENDIF

 LDX #254               \ Set X2 = 254
 STX X2

IF _CASSETTE_VERSION

 BNE HLOIN              \ Call HLOIN to draw a horizontal line from (2, A) to
                        \ (254, A) and return from the subroutine (this BNE is
                        \ effectively a JMP as A will never be zero)

ELIF _6502SP_VERSION

 JSR LL30
 LDA #CYAN
 JMP DOCOL

ENDIF

