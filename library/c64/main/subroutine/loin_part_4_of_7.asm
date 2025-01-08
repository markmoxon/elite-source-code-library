\ ******************************************************************************
\
\       Name: LOIN (Part 4 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a shallow line going right and down or left and up
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going right and down (no swap) or left and up (swap)
\
\   * X1 < X2 and Y1 <= Y2
\
\   * Draw from (X1, Y1) at top left to (X2, Y2) at bottom right, omitting the
\     first pixel
\
\ This routine looks complex, but that's because the loop that's used in the
\ BBC Micro cassette and disc versions has been unrolled to speed it up. The
\ algorithm is unchanged, it's just a lot longer.
\
\ ******************************************************************************

.DOWN

 LDA ylookuph,Y         \ Set the top byte of SC(1 0) to the address of the
 STA SC+1               \ start of the character row to draw in, from the
                        \ ylookup table

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2 of the x-coordinate in
                        \ X1

 ADC ylookupl,Y         \ The ylookup table lets us look up the 16-bit address
 STA SC                 \ of the start of a character row containing a specific
 BCC P%+5               \ pixel, so this fetches the address for the start of
 INC SC+1               \ the character row containing the y-coordinate in Y,
                        \ and adds it to the row offset we just calculated in A

 CLC                    \ Calculate SC(1 0) = SC(1 0) - 248
 SBC #247               \
 STA SC                 \ This enables us to decrement Y towards zero to work
 BCS P%+4               \ through the character block - see the next comment for
 DEC SC+1               \ details

 TYA                    \ Set bits 3-7 of Y, which contains the pixel row within
 AND #%00000111         \ the character, and is therefore in the range 0-7, so
 EOR #%11111000         \ this does Y = 248 + Y
 TAY                    \
                        \ We therefore have the following:
                        \
                        \   SC(1 0) + Y = SC(1 0) - 248 + 248 + Y
                        \               = SC(1 0) + Y
                        \
                        \ so the screen location we poke hasn't changed, but Y
                        \ is now a larger number and SC is smaller. This means
                        \ we can increment Y to move down a line, as per usual,
                        \ but we can test for when it reaches the bottom of the
                        \ character block with a simple BEQ rather than checking
                        \ whether it's reached 8, so this appears to be a code
                        \ optimisation
                        \
                        \ If it helps, you can think of Y as being a negative
                        \ number that we are incrementing towards zero as we
                        \ move along the line - we just need to alter the value
                        \ of SC so that SC(1 0) + Y points to the right address

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 BIT SWAP               \ If SWAP is &FF then we swapped the coordinates above,
 BMI LI90               \ so jump to LI90 to use the correct addresses

 LDA LIJT5,X            \ Modify the JMP instruction at LI91 to jump to the X-th
 STA LI91+1             \ unrolled code block below (LI21 through LI28)
 LDA LIJT6,X            \
 STA LI91+2             \ This ensures that we start drawing at pixel column X
                        \ within the character block

 LDX P2                 \ Set X = P2
                        \       = |delta_x|
                        \
                        \ So we can now use X as the pixel counter

 BEQ LIE0               \ If we have already reached the right end of the line,
                        \ jump to LIE0 to return from the subroutine

.LI91

 JMP &8888              \ Jump down to the X-th unrolled code block below
                        \ (i.e. LI21 through LI28)
                        \
                        \ This instruction is modified by the code above

.LI90

 LDA LIJT7,X            \ Modify the JMP instruction at LI92 to jump to the X-th
 STA LI92+1             \ unrolled code block below (LI21+6 through LI28+6),
 LDA LIJT8,X            \ skipping the first three instructions so we don't draw
 STA LI92+2             \ the first pixel
                        \
                        \ This ensures that we start drawing at pixel column X
                        \ within the character block

 LDX P2                 \ Set X = P2 + 1
 INX                    \       = |delta_x| + 1
                        \
                        \ so we can now use X as the pixel counter
                        \
                        \ We add 1 so we can skip the first pixel plot if the
                        \ line is being drawn with swapped coordinates

 BEQ LIE0               \ If we have just reached the right end of the line,
                        \ jump to LIE0 to return from the subroutine

.LI92

 JMP &8888              \ Jump down to the X-th unrolled code block below
                        \ (i.e. LI21+6 through LI28+6)
                        \
                        \ This instruction is modified by the code above

.LIE3

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.LI21

 LDA #%10000000         \ Set a mask in A to the first pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE3               \ If we have just reached the right end of the line,
                        \ jump to LIE3 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI22               \ If the addition didn't overflow, jump to LI22 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI22-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI22-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI22

 LDA #%01000000         \ Set a mask in A to the second pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE3               \ If we have just reached the right end of the line,
                        \ jump to LIE3 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI23               \ If the addition didn't overflow, jump to LI23 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI23-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI23-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI23

 LDA #%00100000         \ Set a mask in A to the third pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE3               \ If we have just reached the right end of the line,
                        \ jump to LIE3 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI24               \ If the addition didn't overflow, jump to LI24 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI24-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI24-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each row in the
 LDA SC+1               \ screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI24

 LDA #%00010000         \ Set a mask in A to the fourth pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE2S              \ If we have just reached the right end of the line,
                        \ jump to LIE2 via LIE2S to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI25               \ If the addition didn't overflow, jump to LI25 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI25-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI25-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each row in the
 LDA SC+1               \ screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI25

 LDA #%00001000         \ Set a mask in A to the fifth pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE2S              \ If we have just reached the right end of the line,
                        \ jump to LIE2 via LIE2S to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI26               \ If the addition didn't overflow, jump to LI26 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI26-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI26-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI26

 LDA #%00000100         \ Set a mask in A to the sixth pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE2               \ If we have just reached the right end of the line,
                        \ jump to LIE2 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI27               \ If the addition didn't overflow, jump to LI27 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI27-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI27-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI27

 LDA #%00000010         \ Set a mask in A to the seventh pixel in the
                        \ eight-pixel

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

.LIE2S

 BEQ LIE2               \ If we have just reached the right end of the line,
                        \ jump to LIE2 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI28               \ If the addition didn't overflow, jump to LI28 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI28-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI28-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI28

 LDA #%00000001         \ Set a mask in A to the eighth pixel in the eight-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE2               \ If we have just reached the right end of the line,
                        \ jump to LIE2 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI29               \ If the addition didn't overflow, jump to LI29 to move
                        \ on to the next pixel to draw

 INY                    \ Otherwise we just overflowed, so increment Y to move
                        \ to the pixel line below

 BNE LI29-1             \ If Y < 0 then we are still within the same character
                        \ block, so skip to LI29-1 to clear the C flag and move
                        \ on to the next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 ADC #&3F               \ below, so add 320 (&140) to SC(1 0) to move down one
 STA SC                 \ pixel line, as there are 320 bytes in each character
 LDA SC+1               \ row in the screen bitmap
 ADC #1                 \
 STA SC+1               \ We know the C flag is set as we just passed through a
                        \ BCC, so we only need to add &13F to get the result

 LDY #248               \ Set the pixel line in Y to the first line in that
                        \ character block (as we subtracted 248 from SC above)

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI29

 LDA SC                 \ Add 8 to SC(1 0), starting with the low byte, so SC
 ADC #8                 \ now points to the next character along to the right
 STA SC

 BCC P%+4               \ If the addition didn't overflow, skip the following
                        \ instruction

 INC SC+1               \ Increment the high byte of SC(1 0), so SC now points
                        \ to the next character along to the right

 JMP LI21               \ Loop back to draw the next character along to the
                        \ right

.LIE2

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

