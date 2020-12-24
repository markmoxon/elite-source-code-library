\ ******************************************************************************
\
\       Name: LOIN (Part 5 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line: Line has a steep gradient, step up along y-axis
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

 CPY Y2                 \ If Y1 >= Y2, jump down to LI15, as the coordinates are
 BCS LI15               \ already in the order that we want

 DEC SWAP               \ Otherwise decrement SWAP from 0 to &FF, to denote that
                        \ we are swapping the coordinates around

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

 STA SC                 \ Store this value in SC, so SC(1 0) now contains the
                        \ screen address of the far left end (x-coordinate = 0)
                        \ of the horizontal pixel row that we want to draw the
                        \ start of our line on

 TXA                    \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set,
 STA R                  \ and store it in R

 LDA Y1                 \ Set Y = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 LDA P                  \ Set A = |delta_x|

                        \ The following calculates:
                        \
                        \   P = A / Q
                        \     = |delta_x| / |delta_y|
                        \
                        \ using the same shift-and-subtract algorithm
                        \ documented in TIS2

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

 LDA X2                 \ Set A = X2 - X1 - 1 (as the C flag is clear following
 SBC X1                 \ the above division)

 BCC LFT                \ If X2 < X1 - 1 then jump to LFT, as we need to draw
                        \ the line to the left and down

