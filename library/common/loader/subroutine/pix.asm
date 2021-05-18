\ ******************************************************************************
\
\       Name: PIX
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single pixel at a specific coordinate
IF _ELECTRON_VERSION \ Comment
\  Deep dive: Drawing pixels in the Electron version
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Draw a pixel at screen coordinate (X, -A). The sign bit of A gets flipped
\ before drawing, and then the routine uses the same approach as the PIXEL
\ routine in the main game code, except it plots a single pixel from TWOS
\ instead of a two pixel dash from TWOS2. This applies to the top part of the
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ screen (the monochrome mode 4 space view).
ELIF _ELECTRON_VERSION
\ screen (the space view).
ELIF _6502SP_VERSION OR _MASTER_VERSION
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
IF _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Other entry points:
\
\   out                 Contains an RTS
\
ELIF _ELECTRON_VERSION
\ Other entry points:
\
\   PIX-1               Contains an RTS
\
ENDIF
\ ******************************************************************************

.PIX

IF _ELECTRON_VERSION \ Screen

 LDY #128               \ Set ZP = 128 for use in the calculation below
 STY ZP

ENDIF

 TAY                    \ Copy A into Y, for use later

 EOR #%10000000         \ Flip the sign of A

IF _ELECTRON_VERSION \ Screen

 CMP #248               \ If the y-coordinate in A >= 248, then this is the
 BCS PIX-1              \ bottom row of the screen, which we want to leave blank
                        \ as it's below the bottom of the dashboard, so return
                        \ from the subroutine (as PIX-1 contains an RTS)

ENDIF

IF _CASSETTE_VERSION \ Screen

 LSR A                  \ Set ZP+1 = &60 + A >> 3
 LSR A
 LSR A
 ORA #&60
 STA ZP+1

 TXA                    \ Set ZP = (X >> 3) * 8
 EOR #%10000000
 AND #%11111000
 STA ZP

ELIF _ELECTRON_VERSION

                        \ We now calculate the address of the character block
                        \ containing the pixel (x, y) and put it in ZP(1 0), as
                        \ follows:
                        \
                        \   ZP = &5800 + (y div 8 * 256) + (y div 8 * 64) + 32
                        \
                        \ See the deep dive on "Drawing pixels in the Electron
                        \ version" for details

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \       = character row number

                        \ Also, as ZP = 128, we have:
                        \
                        \   (A ZP) = (A 128)
                        \          = (A * 256) + 128
                        \          = 4 * ((A * 64) + 32)
                        \          = 4 * ((char row * 64) + 32)

 STA ZP+1               \ Set ZP+1 = A, so (ZP+1 0) = A * 256
                        \                           = char row * 256

 LSR A                  \ Set (A ZP) = (A ZP) / 4
 ROR ZP                 \            = (4 * ((char row * 64) + 32)) / 4
 LSR A                  \            = char row * 64 + 32
 ROR ZP

 ADC ZP+1               \ Set ZP(1 0) = (A ZP) + (ZP+1 0) + &5800
 ADC #&58               \             = (char row * 64 + 32)
 STA ZP+1               \               + char row * 256
                        \               + &5800
                        \
                        \ which is what we want, so ZP(1 0) contains the address
                        \ of the first visible pixel on the character row
                        \ containing the point (x, y)

 TXA                    \ To get the address of the character block on this row
 EOR #%10000000         \ that contains (x, y):
 AND #%11111000         \
 ADC ZP                 \   ZP(1 0) = ZP(1 0) + (X >> 3) * 8
 STA ZP

 BCC P%+4               \ If the addition of the low bytes overflowed, increment
 INC ZP+1               \ the high byte

                        \ So ZP(1 0) now contains the address of the first pixel
                        \ in the character block containing the (x, y), taking
                        \ the screen borders into consideration

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 LSR A                  \ Set A = A >> 3
 LSR A
 LSR A

 LSR CHKSM+1            \ Rotate the high byte of CHKSM+1 to the right, as part
                        \ of the copy protection

 ORA #&60               \ Set ZP+1 = &60 + A >> 3
 STA ZP+1

 TXA                    \ Set ZP = (X >> 3) * 8
 EOR #%10000000
 AND #%11111000
 STA ZP

ELIF _6502SP_VERSION OR _MASTER_VERSION

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette version, the loading screen's Saturn has a much higher dot density than the other versions, as the drawing routine plots individual pixels into the screen using OR logic, so pixels within a character block can be next to each other. The other versions poke whole one-pixel bytes directly into screen memory without the OR logic, which overwrites any pixels already plotted in that byte and ensures a much greater pixel spacing (though pixels at the ends of neighbouring character blocks can still be next to each other)

 LDA TWOS,X             \ Fetch a pixel from TWOS and OR it into ZP+Y
 ORA (ZP),Y
 STA (ZP),Y

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA TWOS,X             \ Fetch a pixel from TWOS and poke it into ZP+Y
 STA (ZP),Y

ENDIF

IF _DISC_VERSION OR _ELITE_A_VERSION \ Label

.out

ENDIF

 RTS                    \ Return from the subroutine

