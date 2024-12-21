\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\       Name: CPIX2
ELIF _MASTER_VERSION
\       Name: CPIXK
ENDIF
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single-height dash on the dashboard
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\  Deep dive: Drawing colour pixels on the BBC Micro
ELIF _ELECTRON_VERSION
\  Deep dive: Drawing pixels in the Electron version
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Draw a single-height mode 5 dash (1 pixel high, 2 pixels wide).
ELIF _ELECTRON_VERSION
\ Draw a single-height mode 4 dash (1 pixel high, 4 pixels wide).
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ Draw a single-height mode 2 dash (1 pixel high, 2 pixels wide).
ELIF _C64_VERSION
\ Draw a single-height multicolour bitmap mode dash (1 pixel high, 2 pixels
\ wide).
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen pixel x-coordinate of the dash
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\   Y1                  The screen pixel y-coordinate of the dash
\
ELIF _MASTER_VERSION
\   A                   The screen pixel y-coordinate of the dash
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   COL                 The colour of the dash as a mode 5 character row byte
\
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   COL                 The colour of the dash as a mode 2 character row byte
\
ELIF _C64_VERSION
\   COL                 The colour of the dash as a multicolour bitmap mode
\                       character row byte
\
ENDIF
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   R                   The dash's right pixel byte
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

.CPIX2

ELIF _MASTER_VERSION

.CPIXK

ENDIF

IF _ELECTRON_VERSION \ Screen

 LDY #128               \ Set SC = 128 for use in the calculation below
 STY SC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA Y1                 \ Fetch the y-coordinate into A

ELIF _MASTER_VERSION

 STA Y1                 \ Store the y-coordinate in Y1

ELIF _C64_VERSION

 LDY Y1                 \ Fetch the y-coordinate into Y

ENDIF

IF _CASSETTE_VERSION \ Comment

\.CPIX                  \ This label is commented out in the original source. It
                        \ would provide a new entry point with A specifying the
                        \ y-coordinate instead of Y1, but it isn't used anywhere

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 TAY                    \ Store the y-coordinate in Y

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LSR A                  \ Set A = A / 8, so A now contains the character row we
 LSR A                  \ need to draw in (as each character row contains 8
 LSR A                  \ pixel rows)

 ORA #&60               \ Each character row in Elite's screen mode takes up one
                        \ page in memory (256 bytes), so we now OR with &60 to
                        \ get the page containing the dash (see the comments in
                        \ routine TT26 for more discussion about calculating
                        \ screen memory addresses)

 STA SCH                \ Store the screen page in the high byte of SC(1 0)

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 STA SC                 \ Store the address of the character block in the low
                        \ byte of SC(1 0), so now SC(1 0) points to the
                        \ character block we need to draw into

ELIF _ELECTRON_VERSION

                        \ We now calculate the address of the character block
                        \ containing the pixel (x, y) and put it in SC(1 0), as
                        \ follows:
                        \
                        \   SC = &5800 + (y div 8 * 256) + (y div 8 * 64) + 32

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \       = character row number

                        \ Also, as SC = 128, we have:
                        \
                        \   (A SC) = (A 128)
                        \          = (A * 256) + 128
                        \          = 4 * ((A * 64) + 32)
                        \          = 4 * ((char row * 64) + 32)

 STA SC+1               \ Set SC+1 = A, so (SC+1 0) = A * 256
                        \                           = char row * 256

 LSR A                  \ Set (A SC) = (A SC) / 4
 ROR SC                 \            = (4 * ((char row * 64) + 32)) / 4
 LSR A                  \            = char row * 64 + 32
 ROR SC

 ADC SC+1               \ Set SC(1 0) = (A SC) + (SC+1 0) + &5800
 ADC #&58               \             = (char row * 64 + 32)
 STA SC+1               \               + char row * 256
                        \               + &5800
                        \
                        \ which is what we want, so SC(1 0) contains the address
                        \ of the first visible pixel on the character row
                        \ containing the point (x, y)

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 ADC SC                 \ And add the result to SC(1 0) to get the character
 STA SC                 \ block on the row we want

 BCC P%+4               \ If the addition of the low bytes overflowed, increment
 INC SC+1               \ the high byte

                        \ So SC(1 0) now contains the address of the first pixel
                        \ in the character block containing the (x, y), taking
                        \ the screen borders into consideration

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111100         \ the address of the first byte in the character block
 ASL A                  \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-1 and shift left to double
                        \ it (as each character row contains two pages of bytes,
                        \ or 512 bytes, which cover 256 pixels). This also
                        \ shifts bit 7 of X1 into the C flag

 STA SC                 \ Store the address of the character block in the low
                        \ byte of SC(1 0), so now SC(1 0) points to the
                        \ character block we need to draw into

 BCC P%+5               \ If the C flag is clear then skip the next two
                        \ instructions

 INC SC+1               \ The C flag is set, which means bit 7 of X1 was set
                        \ before the ASL above, so the x-coordinate is in the
                        \ right half of the screen (i.e. in the range 128-255).
                        \ Each row takes up two pages in memory, so the right
                        \ half is in the second page but SC+1 contains the value
                        \ we looked up from ylookup, which is the page number of
                        \ the first memory page for the row... so we need to
                        \ increment SC+1 to point to the correct page

 CLC                    \ Clear the C flag

ELIF _C64_VERSION

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 CLC                    \ The ylookup table lets us look up the 16-bit address
 ADC ylookupl,Y         \ of the start of a character row containing a specific
 STA SC                 \ pixel, so this fetches the address for the start of
 LDA ylookuph,Y         \ the character row containing the y-coordinate in Y,
 ADC #0                 \ and adds it to the row offset we just calculated in A
 STA SC+1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 TYA                    \ Set Y to the y-coordinate mod 8, which will be the
 AND #7                 \ number of the pixel row we need to draw within the
 TAY                    \ character block

ELIF _ELECTRON_VERSION OR _ELITE_A_6502SP_IO

 LDA Y1                 \ Set Y to the y-coordinate mod 8, which will be the
 AND #7                 \ number of the pixel row we need to draw within the
 TAY                    \ character block

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA X1                 \ Copy bits 0-1 of X1 to bits 1-2 of X, and clear the C
 AND #%00000110         \ flag in the process (using the LSR). X will now be
 LSR A                  \ a value between 0 and 3, and will be the pixel number
 TAX                    \ in the character row for the left pixel in the dash.
                        \ This is because each character row is one byte that
                        \ contains 4 pixels, but covers 8 screen coordinates, so
                        \ this effectively does the division by 2 that we need

 LDA CTWOS,X            \ Fetch a mode 5 1-pixel byte with the pixel position
 AND COL                \ at X, and AND with the colour byte so that pixel takes
                        \ on the colour we want to draw (i.e. A is acting as a
                        \ mask on the colour byte)

ELIF _ELECTRON_VERSION

 LDA X1                 \ Set X to X1 mod 8, which will be the pixel number
 AND #7                 \ within the character row we need to draw
 TAX

 LDA TWOS,X             \ Fetch a mode 4 1-pixel byte with the pixel position
                        \ at X

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA X1                 \ Copy bit 1 of X1 to bit 1 of X. X will now be either
 AND #%00000010         \ 0 or 2, and will be double the pixel number in the
 TAX                    \ character row for the left pixel in the dash (so 0
                        \ means the left pixel in the 2-pixel character row,
                        \ while 2 means the right pixel)

 LDA CTWOS,X            \ Fetch a mode 2 1-pixel byte with the pixel position
 AND COL                \ at X/2, and AND with the colour byte so that pixel
                        \ takes on the colour we want to draw (i.e. A is acting
                        \ as a mask on the colour byte)

ELIF _C64_VERSION

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the pixel lies (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA CTWOS2,X           \ Fetch a multicolour bitmap mode 1-pixel byte with the
 AND COL                \ pixel position at X, and AND with the colour byte so
                        \ that pixel takes on the colour we want to draw (i.e. A
                        \ is acting as a mask on the colour byte)
                        \
                        \ Note that the CTWOS2 table contains two identical
                        \ bitmap bytes for consecutive values of X, as each
                        \ pixel is double-width and straddles two x-coordinates

ENDIF

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA CTWOS+1,X          \ Fetch a mode 5 1-pixel byte with the pixel position
                        \ at X+1, so we can draw the right pixel of the dash

ELIF _ELECTRON_VERSION

 JSR P%+3               \ Run the following code twice, incrementing X each
                        \ time, so we draw a two-pixel dash

 INX                    \ Increment X to get the next pixel along

 LDA TWOS,X             \ Fetch a mode 4 1-pixel byte with the pixel position
                        \ at X

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA CTWOS+2,X          \ Fetch a mode 2 1-pixel byte with the pixel position
                        \ at (X+1)/2, so we can draw the right pixel of the dash

ELIF _C64_VERSION

\JSR P%+3               \ These instructions are commented out in the original
\INX                    \ source

 LDA CTWOS2+2,X         \ Fetch a multicolour bitmap mode 1-pixel byte with the
                        \ pixel position at X+1, so we can draw the right pixel
                        \ of the dash (we add 2 to CTWOS2 as there are two
                        \ repeated entries for X and X+1 in the table)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment

 BPL CP1                \ The CTWOS table has an extra row at the end of it that
                        \ repeats the first value, %10001000, so if we have not
                        \ fetched that value, then the right pixel of the dash
                        \ is in the same character block as the left pixel, so
                        \ jump to CP1 to draw it

ELIF _ELECTRON_VERSION

 BPL CP1                \ The CTWOS table is followed by the TWOS2 table, whose
                        \ first entry is %11000000, so if we have not just
                        \ fetched that value, then the right pixel of the dash
                        \ is in the same character block as the left pixel, so
                        \ jump to CP1 to draw it

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BPL CP1                \ The CTWOS table has 2 extra rows at the end of it that
                        \ repeat the first values, %10101010, so if we have not
                        \ fetched that value, then the right pixel of the dash
                        \ is in the same character block as the left pixel, so
                        \ jump to CP1 to draw it

ELIF _C64_VERSION

 BPL CP1                \ The CTWOS table has an extra two rows at the end of it
                        \ that repeat the first two value, %11000000, so if we
                        \ have not fetched that value, then the right pixel of
                        \ the dash is in the same character block as the left
                        \ pixel, so jump to CP1 to draw it

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA SC                 \ Otherwise the left pixel we drew was at the last
 ADC #8                 \ position of four in this character block, so we add
 STA SC                 \ 8 to the screen address to move onto the next block
                        \ along (as there are 8 bytes in a character block).
                        \ The C flag was cleared above, so this ADC is correct

ELIF _ELECTRON_VERSION OR _C64_VERSION

 LDA SC                 \ Otherwise the left pixel we drew was at the last
 CLC                    \ position of four in this character block, so we add
 ADC #8                 \ 8 to the screen address to move onto the next block
 STA SC                 \ along (as there are 8 bytes in a character block)

ENDIF

IF _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Screen

 BCC P%+4               \ If the addition we just did overflowed, then increment
 INC SC+1               \ the high byte of SC(1 0), as this means we just moved
                        \ into the right half of the screen row

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA CTWOS+1,X          \ Re-fetch the mode 5 1-pixel byte, as we just overwrote
                        \ A (the byte will still be the fifth byte from the
                        \ table, which is correct as we want to draw the
                        \ leftmost pixel in the next character along as the
                        \ dash's right pixel)

ELIF _ELECTRON_VERSION

 LDA TWOS,X             \ Re-fetch the mode 4 1-pixel byte from before, as we
                        \ just overwrote A

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA CTWOS+2,X          \ Re-fetch the mode 2 1-pixel byte, as we just overwrote
                        \ A (the byte will still be the fifth or sixth byte from
                        \ the table, which is correct as we want to draw the
                        \ leftmost pixel in the next character along as the
                        \ dash's right pixel)

ELIF _C64_VERSION

 LDA CTWOS2+2,X         \ Re-fetch the multicolour bitmap mode 1-pixel byte, as
                        \ we just overwrote A (the byte will still be the last
                        \ byte from the table, which is correct as we want to
                        \ draw the leftmost pixel in the next character along as
                        \ the dash's right pixel)

ENDIF

.CP1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 AND COL                \ Apply the colour mask to the pixel byte, as above

ENDIF

IF _MASTER_VERSION \ Platform

 STA R                  \ Store the dash's right pixel byte in R

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 EOR (SC),Y             \ Draw the dash's right pixel according to the mask in
 STA (SC),Y             \ A, with the colour in COL, using EOR logic, just as
                        \ above

ELIF _ELECTRON_VERSION

 EOR (SC),Y             \ Draw the dash's right pixel according to the mask in
 STA (SC),Y             \ A, using EOR logic, just as above

ENDIF

 RTS                    \ Return from the subroutine

