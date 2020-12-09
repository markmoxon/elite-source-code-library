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

 LDX #254               \ Set X2 = 254
 STX X2

 BNE HLOIN              \ Call HLOIN to draw a horizontal line from (2, A) to
                        \ (254, A) and return from the subroutine (this BNE is
                        \ effectively a JMP as A will never be zero)

ELIF _6502SP_VERSION

 STA Y1                 \ Set Y1 = A

 STA Y2                 \ Set Y2 = A

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow

 LDX #2                 \ Set X1 = 2, so (X1, Y1) = (2, A)
 STX X1

 LDX #254               \ Set X2 = 254, so (X2, Y2) = (254, A)
 STX X2

 JSR LL30               \ Call LL30 to draw a line from (2, A) to (254, A)

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JMP DOCOL              \ switch to colour 3, which is cyan or white

ENDIF

