\ ******************************************************************************
\
\       Name: PIX
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single pixel at a specific coordinate
\
\ ------------------------------------------------------------------------------
\
\ Draw a pixel at screen coordinate (X, -A). The sign bit of A gets flipped
\ before drawing, and then the routine uses the same approach as the PIXEL
\ routine in the main game code, except it plots a single pixel from TWOS
\ instead of a two pixel dash from TWOS2. This applies to the top part of the
\ screen (the monochrome mode 4 portion). See the PIXEL routine in the main game
\ code for more details.
\
\ Arguments:
\
\   X                   The screen x-coordinate of the pixel to draw
\
\   A                   The screen y-coordinate of the pixel to draw, negated
\
\ ******************************************************************************

.PIX

 TAY                    \ Copy A into Y, for use later

 EOR #%10000000         \ Flip the sign of A

IF _CASSETTE_VERSION

 LSR A                  \ Set ZP+1 = &60 + A >> 3
 LSR A
 LSR A
 ORA #&60
 STA ZP+1

 TXA                    \ Set ZP = (X >> 3) * 8
 EOR #%10000000
 AND #%11111000
 STA ZP

ELIF _6502SP_VERSION

 LSR A
 LSR A
 LSR A
 ASL A
 ORA #&40
 STA ZP+1
 TXA 
 EOR #128
 AND #&FC
 ASL A
 STA ZP
 BCC P%+4
 INC ZP+1

ENDIF

 TYA                    \ Set Y = Y AND %111
 AND #%00000111
 TAY

 TXA                    \ Set X = X AND %111
 AND #%00000111
 TAX

IF _CASSETTE_VERSION

 LDA TWOS,X             \ Otherwise fetch a pixel from TWOS and OR it into ZP+Y
 ORA (ZP),Y
 STA (ZP),Y

ELIF _6502SP_VERSION

 LDA TWOS,X
 STA (ZP),Y

ENDIF

 RTS                    \ Return from the subroutine

