\ ******************************************************************************
\
\       Name: LOIN (Part 5 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Line has a steep gradient, step up along y-axis
\  Deep dive: Bresenham's line algorithm
IF _NES_VERSION
\             Drawing lines in the NES version
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * |delta_y| >= |delta_x|
\
\   * The line is closer to being vertical than horizontal
\
\   * We are going to step up along the y-axis
\
\   * We potentially swap coordinates to make sure Y1 >= Y2
\
\ ******************************************************************************

.STPY

 LDY Y1                 \ Set A = Y = Y1
 TYA

 LDX X1                 \ Set X = X1

IF NOT(_NES_VERSION)

 CPY Y2                 \ If Y1 >= Y2, jump down to LI15, as the coordinates are
 BCS LI15               \ already in the order that we want

ELIF _NES_VERSION

 CPY Y2                 \ If Y1 = Y2, jump up to loin18 to return from the
 BEQ loin18             \ subroutine as there is no line to draw

 BCS LI15               \ If Y1 > Y2, jump down to LI15, as the coordinates are
                        \ already in the order that we want

ENDIF

IF NOT(_NES_VERSION)

 DEC SWAP               \ Otherwise decrement SWAP from 0 to &FF, to denote that
                        \ we are swapping the coordinates around

ELIF _NES_VERSION

 DEC SWAP               \ Otherwise decrement SWAP from 0 to &FF, to denote that
                        \ we are swapping the coordinates around (though note
                        \ that we don't use this value anywhere, as in the
                        \ original versions of Elite it is used to omit the
                        \ first pixel of each line, which we don't have to do
                        \ in the NES version as it doesn't use EOR plotting)

ENDIF

 LDA X2                 \ Swap the values of X1 and X2
 STA X1
 STX X2

 TAX                    \ Set X = X1

 LDA Y2                 \ Swap the values of Y1 and Y2
 STA Y1
 STY Y2

 TAY                    \ Set Y = A = Y1

.LI15

                        \ By this point we know the line is vertical-ish and
                        \ Y1 >= Y2, so we're going from top to bottom as we go
                        \ from Y1 to Y2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LSR A                  \ Set A = Y1 / 8, so A now contains the character row
 LSR A                  \ that will contain our horizontal line
 LSR A

 ORA #&60               \ As A < 32, this effectively adds &60 to A, which gives
                        \ us the screen address of the character row (as each
                        \ character row takes up 256 bytes, and the first
                        \ character row is at screen address &6000, or page &60)

 STA SCH                \ Store the page number of the character row in SCH, so
                        \ the high byte of SC is set correctly for drawing the
                        \ start of our line

 TXA                    \ Set A = bits 3-7 of X1
 AND #%11111000

ELIF _ELECTRON_VERSION

                        \ We now calculate the address of the character block
                        \ containing the pixel (X1, Y1) and put it in SC(1 0),
                        \ as follows:
                        \
                        \   SC = &5800 + (Y1 div 8 * 256) + (Y1 div 8 * 64) + 32
                        \
                        \ See the deep dive on "Drawing pixels in the Electron
                        \ version" for details

 LSR A                  \ Set A = Y1 / 8, so A now contains the character row
 LSR A                  \ that will contain our horizontal line
 LSR A

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
                        \ containing the point (X1, Y1)

 TXA                    \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 ADC SC                 \ And add the result to SC(1 0) to get the character
 STA SC                 \ block on the row we want

 BCC P%+4               \ If the addition of the low bytes overflowed, increment
 INC SC+1               \ the high byte

                        \ So SC(1 0) now contains the address of the first pixel
                        \ in the character block containing the (X1, Y1), taking
                        \ the screen borders into consideration

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y1, and
                        \ store it in the high byte of SC(1 0) at SC+1, so the
                        \ high byte of SC is set correctly for drawing our line

 TXA                    \ Set A = 2 * bits 2-6 of X1
 AND #%11111100         \
 ASL A                  \ and shift bit 7 of X1 into the C flag

ELIF _C64_VERSION

 TXA                    \ Set A = bits 3-7 of X1
 AND #%11111000

 CLC                    \ The ylookup table lets us look up the 16-bit address
 ADC ylookupl,Y         \ of the start of a character row containing a specific
 STA SC                 \ pixel, so this fetches the address for the start of
 LDA ylookuph,Y         \ the character row containing the y-coordinate in Y,
 ADC #0                 \ and adds it to the row offset we just calculated in A
 STA SC+1

 TYA                    \ Set Y = Y mod 8
 AND #7                 \
 TAY                    \ So Y is the pixel row within the character block where
                        \ we want to start drawing

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 STA SC                 \ Store this value in SC, so SC(1 0) now contains the
                        \ screen address of the far left end (x-coordinate = 0)
                        \ of the horizontal pixel row that we want to draw the
                        \ start of our line on

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 BCC P%+4               \ If bit 7 of X1 was set, so X1 > 127, increment the
 INC SC+1               \ high byte of SC(1 0) to point to the second page on
                        \ this screen row, as this page contains the right half
                        \ of the row

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 TXA                    \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TXA                    \ Set X = X1 mod 4, which is the horizontal pixel number
 AND #3                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 4 pixels
                        \ wide)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set,
 STA R                  \ and store it in R

ELIF _C64_VERSION

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set,
 STA R2                 \ and store it in R2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Part 5 of the LOIN routine in the advanced versions uses logarithms to speed up the multiplication

 LDA Y1                 \ Set Y = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

ENDIF

IF _ELECTRON_VERSION \ Screen

 TXA                    \ Set X = X1 mod 8, which is the pixel column within the
 AND #7                 \ character block at which we want to draw the start of
 TAX                    \ our line (as each character block has 8 rows)

 LDA TWOS,X             \ Fetch a mode 4 1-pixel byte with the pixel position
 STA R                  \ at X and store it in R to act as a mask

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Part 5 of the LOIN routine in the advanced versions uses logarithms to speed up the multiplication

                        \ The following calculates:
                        \
                        \   P = P / Q
                        \     = |delta_x| / |delta_y|
                        \
                        \ using the same shift-and-subtract algorithm
                        \ documented in TIS2

 LDA P                  \ Set A = |delta_x|

 LDX #1                 \ Set Q to have bits 1-7 clear, so we can rotate through
 STX P                  \ 7 loop iterations, getting a 1 each time, and then
                        \ getting a 1 on the 8th iteration... and we can also
                        \ use P to catch our result bits into bit 0 each time

.LIL4

 ASL A                  \ Shift A to the left

 BCS LI13               \ If bit 7 of A was set, then jump straight to the
                        \ subtraction

 CMP Q                  \ If A < Q, skip the following subtraction
 BCC LI14

.LI13

 SBC Q                  \ A >= Q, so set A = A - Q

 SEC                    \ Set the C flag to rotate into the result in Q

.LI14

 ROL P                  \ Rotate the counter in P to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCC LIL4               \ If we still have set bits in P, loop back to TIL2 to
                        \ do the next iteration of 7

                        \ We now have:
                        \
                        \   P = A / Q
                        \     = |delta_x| / |delta_y|
                        \
                        \ and the C flag is set

 LDX Q                  \ Set X = Q + 1
 INX                    \       = |delta_y| + 1
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 LDA X2                 \ Set A = X2 - X1 (the C flag is set as we didn't take
 SBC X1                 \ the above BCC)

 BCC LFT                \ If X2 < X1 then jump to LFT, as we need to draw the
                        \ line to the left and down

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

                        \ The following section calculates:
                        \
                        \   P = P / Q
                        \     = |delta_x| / |delta_y|
                        \
                        \ using the log tables at logL and log to calculate:
                        \
                        \   A = log(P) - log(Q)
                        \     = log(|delta_x|) - log(|delta_y|)
                        \
                        \ by first subtracting the low bytes of the logarithms
                        \ from the table at LogL, and then subtracting the high
                        \ bytes from the table at log, before applying the
                        \ antilog to get the result of the division and putting
                        \ it in P

 LDX P                  \ Set X = |delta_x|

 BEQ LIfudge            \ If |delta_x| = 0, jump to LIfudge to return 0 as the
                        \ result of the division

 LDA logL,X             \ Set A = log(P) - log(Q)
 LDX Q                  \       = log(|delta_x|) - log(|delta_y|)
 SEC                    \
 SBC logL,X             \ by first subtracting the low bytes of log(P) - log(Q)

ELIF _C64_VERSION

                        \ The following section calculates:
                        \
                        \   P2 = P2 / Q2
                        \      = |delta_x| / |delta_y|
                        \
                        \ using the log tables at logL and log to calculate:
                        \
                        \   A = log(P2) - log(Q2)
                        \     = log(|delta_x|) - log(|delta_y|)
                        \
                        \ by first subtracting the low bytes of the logarithms
                        \ from the table at LogL, and then subtracting the high
                        \ bytes from the table at log, before applying the
                        \ antilog to get the result of the division and putting
                        \ it in P2

 LDX P2                 \ Set X = |delta_x|

 BEQ LIfudge            \ If |delta_x| = 0, jump to LIfudge to return 0 as the
                        \ result of the division

 LDA logL,X             \ Set A = log(P2) - log(Q2)
 LDX Q2                 \       = log(|delta_x|) - log(|delta_y|)
 SEC                    \
 SBC logL,X             \ by first subtracting the low bytes of
                        \ log(P2) - log(Q2)

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: Group A: The Master version omits half of the logarithm algorithm when compared to the 6502SP version

 BMI LIloG              \ If A > 127, jump to LIloG

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Other: See group A

 LDX P                  \ And then subtracting the high bytes of log(P) - log(Q)
 LDA log,X              \ so now A contains the high byte of log(P) - log(Q)
 LDX Q
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P) - log(Q) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA antilog,X          \ table so the result of the division is now in A

 JMP LIlog2             \ Jump to LIlog2 to return the result

.LIlog3

ELIF _MASTER_VERSION

 LDX P                  \ And then subtracting the high bytes of log(P) - log(Q)
 LDA log,X              \ so now A contains the high byte of log(P) - log(Q)
 LDX Q
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P) - log(Q) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA alogh,X            \ table so the result of the division is now in A

 JMP LIlog2             \ Jump to LIlog2 to return the result

.LIlog3

ELIF _C64_VERSION

 LDX P2                 \ And then subtracting the high bytes of
 LDA log,X              \ log(P2) - log(Q2) so now A contains the high byte of
 LDX Q2                 \ log(P2) - log(Q2)
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P2) - log(Q2) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA antilog,X          \ table so the result of the division is now in A

 JMP LIlog2             \ Jump to LIlog2 to return the result

.LIlog3

ENDIF

IF _6502SP_VERSION \ Other: See group A

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog2             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog2 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIloG

 LDX P                  \ Subtract the high bytes of log(P) - log(Q) so now A
 LDA log,X              \ contains the high byte of log(P) - log(Q)
 LDX Q
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P) - log(Q) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the
 LDA antilogODD,X       \ antilogODD so the result of the division is now in A

ELIF _C64_VERSION

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog2             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog2 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIloG

 LDX P2                 \ Subtract the high bytes of log(P2) - log(Q2) so now A
 LDA log,X              \ contains the high byte of log(P2) - log(Q2)
 LDX Q2
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P2) - log(Q2) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the
 LDA antilogODD,X       \ antilogODD so the result of the division is now in A

ELIF _NES_VERSION

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog2             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog2 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIfudge

 LDA #0                 \ Set A = 0 and jump to LIlog2 to return 0 as the result
 BEQ LIlog2             \ (this BNE is effectively a JMP as A is always zero)

.LIloG

 LDX P                  \ Subtract the high bytes of log(P) - log(Q) so now A
 LDA log,X              \ contains the high byte of log(P) - log(Q)
 LDX Q
 SBC log,X

 BCS LIlog3             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(P) - log(Q) < 256, so we jump to
                        \ LIlog3 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the
 LDA antilogODD,X       \ antilogODD so the result of the division is now in A

ELIF _MASTER_VERSION

 LDA #255               \ The division is very close to 1, so set A to the
                        \ closest possible answer to 256, i.e. 255

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Other: See group A

.LIlog2

 STA P                  \ Store the result of the division in P, so we have:
                        \
                        \   P = |delta_x| / |delta_y|

.LIfudge

 LDX Q                  \ Set X = Q
                        \       = |delta_y|

 BEQ LIEX7              \ If |delta_y| = 0, jump down to LIEX7 to return from
                        \ the subroutine

 INX                    \ Set X = Q + 1
                        \       = |delta_y| + 1
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 LDA X2                 \ Set A = X2 - X1
 SEC
 SBC X1

 BCS P%+6               \ If X2 >= X1 then skip the following two instructions

 JMP LFT                \ If X2 < X1 then jump to LFT, as we need to draw the
                        \ line to the left and down

.LIEX7

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

.LIlog2

 STA P2                 \ Store the result of the division in P, so we have:
                        \
                        \   P2 = |delta_x| / |delta_y|

.LIfudge

 SEC                    \ Set the C flag for the subtraction below

 LDX Q2                 \ Set X = Q2 + 1
 INX                    \       = |delta_y| + 1
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 LDA X2                 \ Set A = X2 - X1
 SBC X1

 BCC LFT                \ If X2 < X1 then jump to LFT, as we need to draw the
                        \ line to the left and down

ELIF _NES_VERSION

.LIlog2

 STA P                  \ Store the result of the division in P, so we have:
                        \
                        \   P = |delta_x| / |delta_y|

 LDA X1                 \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + X1 / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and X1 / 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (X1, Y), i.e. the line we are drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 SEC                    \ Set A = X2 - X1
 LDA X2                 \
 SBC X1                 \ This sets the C flag when X1 <= X2

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set

 STA R                  \ Store the pixel byte in R

 LDX Q                  \ Set X = Q + 1
 INX                    \       = |delta_y| + 1
                        \
                        \ We will use Q as the y-axis counter, and we add 1 to
                        \ ensure we include the pixel at each end

 BCS loin24             \ If X1 <= X2 (which we calculated above) then jump to
                        \ loin24 to draw the line to the left and up

 JMP loin36             \ If we get here then X1 > X2, so jump to loin36, as we
                        \ need to draw the line to the left and down

ENDIF

