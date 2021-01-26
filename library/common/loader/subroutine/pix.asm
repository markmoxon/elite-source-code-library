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
IF _CASSETTE_VERSION OR _DISC_VERSION
\ screen (the monochrome mode 4 space view).
ELIF _6502SP_VERSION
\ screen (the four-colour mode 1 space view).
ENDIF
\
\ See the PIXEL routine in the main game code for more details.
\
\ Arguments:
\
\   X                   The screen x-coordinate of the pixel to draw
\
\   A                   The screen y-coordinate of the pixel to draw, negated
\
IF _DISC_VERSION
\ Other entry points:
\
\   out                 Contains an RTS
\
ENDIF
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

ELIF _DISC_VERSION

 LSR A                  \ Set A = A >> 3
 LSR A
 LSR A

 LSR BLPTR+1            \ ????

 ORA #&60               \ Set ZP+1 = &60 + A >> 3
 STA ZP+1

 TXA                    \ Set ZP = (X >> 3) * 8
 EOR #%10000000
 AND #%11111000
 STA ZP

ELIF _6502SP_VERSION

 LSR A                  \ Set ZP+1 = &40 + 2 * (A >> 3)
 LSR A
 LSR A
 ASL A
 ORA #&40
 STA ZP+1

 TXA                    \ Set (C ZP) = (X >> 2) * 8
 EOR #%10000000         \
 AND #%11111100         \ i.e. the C flag contains bit 8 of the calculation
 ASL A
 STA ZP

 BCC P%+4               \ If the C flag is set, i.e. bit 8 of the above
 INC ZP+1               \ calculation was a 1, increment ZP+1 so that ZP(1 0)
                        \ points to the second page in this character row (i.e.
                        \ the right half of the row)

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

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDA TWOS,X             \ Otherwise fetch a pixel from TWOS and poke it into
 STA (ZP),Y             \ ZP+Y

ENDIF

IF _DISC_VERSION

.out

ENDIF

 RTS                    \ Return from the subroutine

