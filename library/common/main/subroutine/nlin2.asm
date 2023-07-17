\ ******************************************************************************
\
\       Name: NLIN2
\       Type: Subroutine
\   Category: Drawing lines
IF NOT(_NES_VERSION)
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
ELIF _NES_VERSION
\    Summary: Draw a horizontal line on tile row 2 to box in a title
ENDIF
\
\ ******************************************************************************

.NLIN2

IF NOT(_NES_VERSION)

 STA Y1                 \ Set Y1 = A

ENDIF

IF _6502SP_VERSION \ Tube

 STA Y2                 \ Set Y2 = A

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow

ELIF _MASTER_VERSION

 LDA #YELLOW            \ Switch to colour 1, which is yellow
 STA COL

ENDIF

IF NOT(_NES_VERSION)

 LDX #2                 \ Set X1 = 2, so (X1, Y1) = (2, A)
 STX X1

 LDX #254               \ Set X2 = 254, so (X2, Y2) = (254, A)
 STX X2

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 BNE HLOIN              \ Call HLOIN to draw a horizontal line from (2, A) to
                        \ (254, A) and return from the subroutine (this BNE is
                        \ effectively a JMP as A will never be zero)

ELIF _ELECTRON_VERSION

                        \ Fall through into HLOIN to draw a horizontal line from
                        \ (2, A) to (254, A) and return from the subroutine

ELIF _6502SP_VERSION

 JSR LL30               \ Call LL30 to draw a line from (2, A) to (254, A)

ELIF _MASTER_VERSION

 JSR HLOIN3             \ Call HLOIN3 to draw a line from (2, A) to (254, A)


ELIF _NES_VERSION

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #1                 \ We now draw a horizontal line into the nametable
                        \ buffer starting at column 1, so set Y as a counter for
                        \ the column number

 LDA #3                 \ Set A to tile 3 so we draw the line as a horizontal
                        \ line that's three pixels thick

.nlin1

 STA nameBuffer0+2*32,Y \ Set the Y-th tile on row 2 of nametable buffer 0 to
                        \ to tile 3

 INY                    \ Increment the column counter

 CPY #32                \ Keep drawing tile 3 along row 2 until we have drawn
 BNE nlin1              \ column 31

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JMP DOCOL              \ switch to colour 3, which is cyan or white

ELIF _MASTER_VERSION

 LDA #CYAN              \ Switch to colour 3, which is cyan or white
 STA COL

 RTS                    \ Return from the subroutine

ENDIF

