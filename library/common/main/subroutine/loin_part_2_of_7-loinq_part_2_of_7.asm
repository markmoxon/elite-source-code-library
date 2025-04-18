\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
\       Name: LOIN (Part 2 of 7)
ELIF _MASTER_VERSION
\       Name: LOINQ (Part 2 of 7)
ENDIF
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Line has a shallow gradient, step right along x-axis
\  Deep dive: Bresenham's line algorithm
IF _NES_VERSION
\             Drawing lines in the NES version
ELIF _APPLE_VERSION
\             Drawing pixels in the Apple II version
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * |delta_y| < |delta_x|
\
\   * The line is closer to being horizontal than vertical
\
\   * We are going to step right along the x-axis
\
\   * We potentially swap coordinates to make sure X1 < X2
\
\ ******************************************************************************

.STPX

 LDX X1                 \ Set X = X1

 CPX X2                 \ If X1 < X2, jump down to LI3, as the coordinates are
 BCC LI3                \ already in the order that we want

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
 LDY Y1
 STA Y1
 STY Y2

.LI3

                        \ By this point we know the line is horizontal-ish and
                        \ X1 < X2, so we're going from left to right as we go
                        \ from X1 to X2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA Y1                 \ Set A to the y-coordinate in Y1

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \
                        \ So A now contains the number of the character row
                        \ that will contain the start of the line

 ORA #&60               \ As A < 32, this effectively adds &60 to A, which gives
                        \ us the screen address of the character row (as each
                        \ character row takes up 256 bytes, and the first
                        \ character row is at screen address &6000, or page &60)

 STA SCH                \ Store the page number of the character row in SCH, so
                        \ the high byte of SC is set correctly for drawing the
                        \ start of our line

ELIF _ELECTRON_VERSION

                        \ We now calculate the address of the character block
                        \ containing the pixel (X1, Y1) and put it in SC(1 0),
                        \ as follows:
                        \
                        \   SC = &5800 + (Y1 div 8 * 256) + (Y1 div 8 * 64) + 32

 LDA Y1                 \ Set A to the y-coordinate in Y1

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \
                        \ So A now contains the number of the character row
                        \ that will contain the start of the line

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

 LDY Y1                 \ Look up the page number of the character row that
 LDA ylookup,Y          \ contains the pixel with the y-coordinate in Y1, and
 STA SC+1               \ store it in SC+1, so the high byte of SC is set
                        \ correctly for drawing our line

ELIF _APPLE_VERSION

 LDA Y1                 \ Set A to the y-coordinate in Y1

 LSR A                  \ Set T1 = A >> 3
 LSR A                  \        = y div 8
 LSR A                  \
 STA T1                 \ So T1 now contains the number of the character row
                        \ that will contain the pixel we want to draw
                        \
                        \ We will refer to T1 throughout the rest of the routine

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA Y1                 \ Set T2 = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our pixel (as
 STA T2                 \ each character block has 8 rows)
                        \
                        \ We will refer to T2 throughout the rest of the routine

 ASL A                  \ Set the high byte of SC(1 0) as follows:
 ASL A                  \
 ADC SCTBH,Y            \   SC+1 = SCBTH for row Y + pixel row * 4
 STA SC+1               \
                        \ Because this is the high byte, and because we already
                        \ set the low byte in SC to the Y-th entry from SCTBL,
                        \ this is the same as the following:
                        \
                        \   SC(1 0) = (SCBTH SCTBL) for row Y + pixel row * &400
                        \
                        \ So SC(1 0) contains the address in screen memory of
                        \ the pixel row containing the pixel we want to draw, as
                        \ (SCBTH SCTBL) gives us the address of the start of the
                        \ character row, and each pixel row within the character
                        \ row is offset by &400 bytes

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION)

 LDA Y1                 \ Set Y = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 TXA                    \ Set A = bits 3-7 of X1
 AND #%11111000

ELIF _6502SP_VERSION OR _MASTER_VERSION

 TXA                    \ Set A = 2 * bits 2-6 of X1
 AND #%11111100         \
 ASL A                  \ and shift bit 7 of X1 into the C flag

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 STA SC                 \ Store this value in SC, so SC(1 0) now contains the
                        \ screen address of the far left end (x-coordinate = 0)
                        \ of the horizontal pixel row that we want to draw the
                        \ start of our line on

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 TXA                    \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWOS,X             \ Fetch a one-pixel byte from TWOS where pixel X is set,
 STA R                  \ and store it in R

ELIF _6502SP_VERSION OR _MASTER_VERSION

 BCC P%+4               \ If bit 7 of X1 was set, so X1 > 127, increment the
 INC SC+1               \ high byte of SC(1 0) to point to the second page on
                        \ this screen row, as this page contains the right half
                        \ of the row

 TXA                    \ Set R = X1 mod 4, which is the horizontal pixel number
 AND #3                 \ within the character block where the line starts (as
 STA R                  \ each pixel line in the character block is 4 pixels
                        \ wide)

ELIF _APPLE_VERSION

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at the x-coordinate in X, i.e. the start of the
                        \ line (so Y is in the range 0 to 6, as bit 7 in the
                        \ pixel byte is used to set the pixel byte's colour
                        \ palette)

 LDA TWOS,Y             \ Fetch a one-pixel byte from TWOS where pixel Y is set,
 STA R                  \ and store it in R

 LDY SCTBX2,X           \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the start of
                        \ the line

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: Part 2 of the LOIN routine in the advanced versions uses logarithms to speed up the multiplication

                        \ The following calculates:
                        \
                        \   Q = Q / P
                        \     = |delta_y| / |delta_x|
                        \
                        \ using the same shift-and-subtract algorithm that's
                        \ documented in TIS2

 LDA Q                  \ Set A = |delta_y|

 LDX #%11111110         \ Set Q to have bits 1-7 set, so we can rotate through 7
 STX Q                  \ loop iterations, getting a 1 each time, and then
                        \ getting a 0 on the 8th iteration... and we can also
                        \ use Q to catch our result bits into bit 0 each time

.LIL1

 ASL A                  \ Shift A to the left

 BCS LI4                \ If bit 7 of A was set, then jump straight to the
                        \ subtraction

 CMP P                  \ If A < P, skip the following subtraction
 BCC LI5

.LI4

 SBC P                  \ A >= P, so set A = A - P

 SEC                    \ Set the C flag to rotate into the result in Q

.LI5

 ROL Q                  \ Rotate the counter in Q to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS LIL1               \ If we still have set bits in Q, loop back to TIL2 to
                        \ do the next iteration of 7

                        \ We now have:
                        \
                        \   Q = A / P
                        \     = |delta_y| / |delta_x|
                        \
                        \ and the C flag is clear

 LDX P                  \ Set X = P + 1
 INX                    \       = |delta_x| + 1
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 LDA Y2                 \ Set A = Y2 - Y1 - 1 (as the C flag is clear following
 SBC Y1                 \ the above division)

 BCS DOWN               \ If Y2 >= Y1 - 1 then jump to DOWN, as we need to draw
                        \ the line to the right and down

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

                        \ The following section calculates:
                        \
                        \   Q = Q / P
                        \     = |delta_y| / |delta_x|
                        \
                        \ using the log tables at logL and log to calculate:
                        \
                        \   A = log(Q) - log(P)
                        \     = log(|delta_y|) - log(|delta_x|)
                        \
                        \ by first subtracting the low bytes of the logarithms
                        \ from the table at LogL, and then subtracting the high
                        \ bytes from the table at log, before applying the
                        \ antilog to get the result of the division and putting
                        \ it in Q

 LDX Q                  \ Set X = |delta_y|

 BEQ LIlog7             \ If |delta_y| = 0, jump to LIlog7 to return 0 as the
                        \ result of the division

 LDA logL,X             \ Set A = log(Q) - log(P)
 LDX P                  \       = log(|delta_y|) - log(|delta_x|)
 SEC                    \
 SBC logL,X             \ by first subtracting the low bytes of log(Q) - log(P)

ELIF _C64_VERSION

                        \ The following section calculates:
                        \
                        \   Q2 = Q2 / P2
                        \      = |delta_y| / |delta_x|
                        \
                        \ using the log tables at logL and log to calculate:
                        \
                        \   A = log(Q2) - log(P2)
                        \     = log(|delta_y|) - log(|delta_x|)
                        \
                        \ by first subtracting the low bytes of the logarithms
                        \ from the table at LogL, and then subtracting the high
                        \ bytes from the table at log, before applying the
                        \ antilog to get the result of the division and putting
                        \ it in Q2

 LDX Q2                 \ Set X = |delta_y|

 BEQ LIlog7             \ If |delta_y| = 0, jump to LIlog7 to return 0 as the
                        \ result of the division

 LDA logL,X             \ Set A = log(Q2) - log(P2)
 LDX P2                 \       = log(|delta_y|) - log(|delta_x|)
 SEC                    \
 SBC logL,X             \ by first subtracting the low bytes of
                        \ log(Q2) - log(P2)

ELIF _APPLE_VERSION

 LDX Q                  \ Set X = |delta_y|

 BNE LIlog7             \ If |delta_y| is non-zero, jump to LIlog7 to skip the
                        \ following

 TXA                    \ If we get here then |delta_y| = 0, so set A = 0 and
 BEQ LIlog6             \ jump to LIlog6 to return 0 as the result of the
                        \ division

.LIlog7

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: Group A: The Master version omits half of the logarithm algorithm when compared to the 6502SP version

 BMI LIlog4             \ If A > 127, jump to LIlog4

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Other: See group A

 LDX Q                  \ And then subtracting the high bytes of log(Q) - log(P)
 LDA log,X              \ so now A contains the high byte of log(Q) - log(P)
 LDX P
 SBC log,X

 BCS LIlog5             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(Q) - log(P) < 256, so we jump to
                        \ LIlog5 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA antilog,X          \ table so the result of the division is now in A

 JMP LIlog6             \ Jump to LIlog6 to return the result

.LIlog5

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog6             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog6 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIlog7

ELIF _MASTER_VERSION

 LDX Q                  \ And then subtracting the high bytes of log(Q) - log(P)
 LDA log,X              \ so now A contains the high byte of log(Q) - log(P)
 LDX P
 SBC log,X

 BCS LIlog5             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(Q) - log(P) < 256, so we jump to
                        \ LIlog5 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA alogh,X            \ table so the result of the division is now in A

 JMP LIlog6             \ Jump to LIlog6 to return the result

.LIlog5

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog6             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog6 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIlog7

ELIF _C64_VERSION

 LDX Q2                 \ And then subtracting the high bytes of
 LDA log,X              \ log(Q2) - log(P2) so now A contains the high byte of
 LDX P2                 \ log(Q2) - log(P2)
 SBC log,X

 BCS LIlog5             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(Q2) - log(P2) < 256, so we jump to
                        \ LIlog5 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA antilog,X          \ table so the result of the division is now in A

 JMP LIlog6             \ Jump to LIlog6 to return the result

.LIlog5

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog6             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog6 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

.LIlog7

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Other: See group A

 LDA #0                 \ The numerator in the division is 0, so set A to 0 and
 BEQ LIlog6             \ jump to LIlog6 to return the result (this BEQ is
                        \ effectively a JMP as A is always zero)

.LIlog4

 LDX Q                  \ Subtract the high bytes of log(Q) - log(P) so now A
 LDA log,X              \ contains the high byte of log(Q) - log(P)
 LDX P
 SBC log,X

 BCS LIlog5             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(Q) - log(P) < 256, so we jump to
                        \ LIlog5 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the
 LDA antilogODD,X       \ antilogODD so the result of the division is now in A

ELIF _MASTER_VERSION

 LDA #0                 \ The numerator in the division is 0, so set A to 0

ELIF _C64_VERSION

 LDA #0                 \ The numerator in the division is 0, so set A to 0 and
 BEQ LIlog6             \ jump to LIlog6 to return the result (this BEQ is
                        \ effectively a JMP as A is always zero)

.LIlog4

 LDX Q2                 \ Subtract the high bytes of log(Q2) - log(P2) so now A
 LDA log,X              \ contains the high byte of log(Q2) - log(P2)
 LDX P2
 SBC log,X

 BCS LIlog5             \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(Q2) - log(P2) < 256, so we jump to
                        \ LIlog5 to return a result of 255

 TAX                    \ Otherwise we set A to the A-th entry from the
 LDA antilogODD,X       \ antilogODD so the result of the division is now in A

ELIF _APPLE_VERSION

 LDA logL,X             \ Set A = log(Q) - log(P)
 LDX P                  \       = log(|delta_y|) - log(|delta_x|)
 SEC                    \
 SBC logL,X             \ by first subtracting the low bytes of log(Q) - log(P)

 LDX Q                  \ And then subtracting the high bytes of log(Q) - log(P)
 LDA log,X              \ so now A contains the high byte of log(Q) - log(P)
 LDX P
 SBC log,X

 BCC P%+6               \ If the subtraction underflowed then skip the next two
                        \ instructions as log(P) - log(Q) >= 256

                        \ Otherwise the subtraction fitted into one byte and
                        \ didn't underflow, so log(P) - log(Q) < 256, and we
                        \ now return a result of 255

 LDA #255               \ The division is very close to 1, so set A to the
 BNE LIlog6             \ closest possible answer to 256, i.e. 255, and jump to
                        \ LIlog6 to return the result (this BNE is effectively a
                        \ JMP as A is never zero)

 TAX                    \ Otherwise we set A to the A-th entry from the antilog
 LDA alogh,X            \ table so the result of the division is now in A

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Other: See group A

.LIlog6

 STA Q                  \ Store the result of the division in Q, so we have:
                        \
                        \   Q = |delta_y| / |delta_x|

 LDX P                  \ Set X = P
                        \       = |delta_x|

 BEQ LIEXS              \ If |delta_x| = 0, return from the subroutine, as LIEXS
                        \ contains a BEQ LIEX instruction, and LIEX contains an
                        \ RTS

 INX                    \ Set X = P + 1
                        \       = |delta_x| + 1
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 LDA Y2                 \ If Y2 < Y1 then skip the following instruction
 CMP Y1
 BCC P%+5

 JMP DOWN               \ Y2 >= Y1, so jump to DOWN, as we need to draw the line
                        \ to the right and down

ELIF _C64_VERSION

.LIlog6

 STA Q2                 \ Store the result of the division in Q2, so we have:
                        \
                        \   Q2 = |delta_y| / |delta_x|

 CLC                    \ This instruction has no effect as the value of the C
                        \ flag is overridden by the CPY in the following

 LDY Y1                 \ If Y2 < Y1 then skip the following instruction
 CPY Y2
 BCS P%+5

 JMP DOWN               \ Y2 >= Y1, so jump to DOWN, as we need to draw the line
                        \ to the right and down

ELIF _APPLE_VERSION

.LIlog6

 STA Q                  \ Store the result of the division in Q, so we have:
                        \
                        \   Q = |delta_y| / |delta_x|

 SEC                    \ Set the C flag for the subtraction below

 LDX P                  \ Set X = P + 1
 INX                    \       = |delta_x| + 1
                        \
                        \ We will use P as the x-axis counter, and we add 1 to
                        \ ensure we include the pixel at each end

 LDA Y2                 \ If Y1 <= Y2, jump to DOWN, as we need to draw the line
 SBC Y1                 \ to the right and down
 BCS DOWN

ELIF _NES_VERSION

.LIlog6

 STA Q                  \ Store the result of the division in Q, so we have:
                        \
                        \   Q = |delta_y| / |delta_x|

 LDA P                  \ Set P = P + 1
 CLC                    \      = |delta_x| + 1
 ADC #1                 \
 STA P                  \ We will use P as the x-axis counter, and we add 1 to
                        \ ensure we include the pixel at each end

 LDY Y1                 \ If Y1 >= Y2, skip the following instruction
 CPY Y2
 BCS P%+5

 JMP DOWN               \ Y1 < Y2, so jump to DOWN, as we need to draw the line
                        \ to the right and down

ENDIF
