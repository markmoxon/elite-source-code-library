\ ******************************************************************************
\
\       Name: CPIX2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single-height dot on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Draw a single-height mode 5 dash (1 pixel high, 2 pixels wide).
\
\ Arguments:
\
\   X1                  The screen pixel x-coordinate of the dash
\
\   Y1                  The screen pixel y-coordinate of the dash
\
\   COL                 The colour of the dash as a mode 5 character row byte
\
\ ******************************************************************************

.CPIX2

 LDA Y1                 \ Fetch the y-coordinate into A

\.CPIX                  \ This label is commented out in the original source. It
                        \ would provide a new entry point with A specifying the
                        \ y-coordinate instead of Y1, but it isn't used anywhere

 TAY                    \ Store the y-coordinate in Y

IF _CASSETTE_VERSION
 LSR A                  \ Set A = A / 8, so A now contains the character row we
 LSR A                  \ need to draw in (as each character row contains 8
 LSR A                  \ pixel rows)

 ORA #&60               \ Each character row in Elite's screen mode takes up one
                        \ page in memory (256 bytes), so we now OR with &60 to
                        \ get the page containing the dash (see the comments in
                        \ routine TT26 for more discussion about calculating
                        \ screen memory addresses

 STA SCH                \ Store the screen page in the high byte of SC(1 0)

 LDA X1                 \ Each character block covers 8 screen x-coordinates, so
 AND #%11111000         \ to get the address of the first byte in the character
                        \ block that we need to draw into, as an offset from the
                        \ start of the row we clear bits 0-2

 STA SC                 \ Store the address of the character block in the low
                        \ byte of SC(1 0), so now SC(1 0) points to the
                        \ character block we need to draw into

ELIF _6502SP_VERSION

 LDA ylookup,Y
 STA SC+1

 LDA X1
 AND #&FC
 ASL A
 STA SC
 BCC P%+5
 INC SC+1
 CLC

ENDIF

 TYA                    \ Set Y to just bits 0-2 of the y-coordinate, which will
 AND #%00000111         \ be the number of the pixel row we need to draw into
 TAY                    \ within the character block

IF _CASSETTE_VERSION

 LDA X1                 \ Copy bits 0-1 of X to bits 1-2 of X1, and clear the C
 AND #%00000110         \ flag in the process (using the LSR). X will now be
 LSR A                  \ a value between 0 and 3, and will be the pixel number
 TAX                    \ in the character row for the left pixel in the dash.
                        \ This is because each character row is one byte that
                        \ contains 4 pixels, but covers 8 screen coordinates, so
                        \ this effectively does the division by 2 that we need

ELIF _6502SP_VERSION

 LDA X1
 AND #2
 TAX

ENDIF

 LDA CTWOS,X            \ Fetch a mode 5 1-pixel byte with the pixel position
 AND COL                \ at X, and AND with the colour byte so that pixel takes
                        \ on the colour we want to draw (i.e. A is acting as a
                        \ mask on the colour byte)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

IF _CASSETTE_VERSION

 LDA CTWOS+1,X          \ Fetch a mode 5 1-pixel byte with the pixel position
                        \ at X+1, so we can draw the right pixel of the dash


ELIF _6502SP_VERSION

 LDA CTWOS+2,X

ENDIF

 BPL CP1                \ The CTWOS table has an extra row at the end of it that
                        \ repeats the first value, %10001000, so if we have not
                        \ fetched that value, then the right pixel of the dash
                        \ is in the same character block as the left pixel, so
                        \ jump to CP1 to draw it

 LDA SC                 \ Otherwise the left pixel we drew was at the last
 ADC #8                 \ position of four in this character block, so we add
 STA SC                 \ 8 to the screen address to move onto the next block
                        \ along (as there are 8 bytes in a character block).
                        \ The C flag was cleared above, so this ADC is correct

IF _CASSETTE_VERSION

 LDA CTWOS+1,X          \ Refetch the mode 5 1-pixel byte, as we just overwrote
                        \ A (the byte will still be the fifth byte from the
                        \ table, which is correct as we want to draw the
                        \ leftmost pixel in the next character along as the
                        \ dash's right pixel)

ELIF _6502SP_VERSION

 BCC P%+4
 INC SC+1
 LDA CTWOS+2,X

ENDIF

.CP1

 AND COL                \ Draw the dash's right pixel according to the mask in
 EOR (SC),Y             \ A, with the colour in COL, using EOR logic, just as
 STA (SC),Y             \ above

 RTS                    \ Return from the subroutine

