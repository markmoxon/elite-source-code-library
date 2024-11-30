\ ******************************************************************************
\
\       Name: LOIN (Part 3 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a shallow line going right and up or left and down
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going right and up (no swap) or left and down (swap)
\
\   * X1 < X2 and Y1 > Y2
\
\   * Draw from (X1, Y1) at bottom left to (X2, Y2) at top right, omitting the
\     first pixel
\
\ This routine looks complex, but that's because the loop that's used in the
\ cassette and disc versions has been unrolled to speed it up. The algorithm is
\ unchanged, it's just a lot longer.
\
\ ******************************************************************************

 LDA X1                 \ Each character block contains 8 pixel rows, so to get
 AND #%11111000         \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2 of the x-coordinate in
                        \ X1

 CLC                    \ The ylookup table lets us look up the 16-bit address
 ADC ylookupl,Y         \ of the start of a character row containing a specific
 STA SC                 \ pixel, so this fetches the address for the start of
 LDA ylookuph,Y         \ the character row containing the y-coordinate in Y,
 ADC #0                 \ and adds it to the row offset we just calculated in A
 STA SC+1

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)


 BIT SWAP               \ If SWAP is &FF then we swapped the coordinates above,
 BMI LI70               \ so jump to LI70 to use the correct addresses

 LDA LIJT1,X            \ Modify the JMP instruction at LI71 to jump to the X-th
 STA LI71+1             \ unrolled code block below (LI81 through LI88)
 LDA LIJT2,X            \
 STA LI71+2             \ This ensures that we start drawing at pixel column X
                        \ within the character block

 LDX P2                 \ Set X = P2
                        \       = |delta_x|
                        \
                        \ So we can now use X as the pixel counter

.LI71

 JMP &8888              \ Jump down to the X-th unrolled code block below
                        \ (i.e. LI81 through LI88)
                        \
                        \ This instruction is modified by the code above

.LI70

 LDA LIJT3,X            \ Modify the JMP instruction at LI72 to jump to the X-th
 STA LI72+1             \ unrolled code block below (LI81+6 through LI88+6),
 LDA LIJT4,X            \ skipping the first three instructions so we don't draw
 STA LI72+2             \ the first pixel
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

 BEQ LIE1               \ If we have just reached the right end of the line,
                        \ jump to LIE1 to return from the subroutine

.LI72

 JMP &8888              \ Jump down to the X-th unrolled code block below
                        \ (i.e. LI81+6 through LI88+6)
                        \
                        \ This instruction is modified by the code above

.LIE1

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.LI81

 LDA #%10000000         \ Set a mask in A to the first pixel in the 8-pixel byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE1               \ If we have just reached the right end of the line,
                        \ jump to LIE1 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI82               \ If the addition didn't overflow, jump to LI82 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI82-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI82-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI82

 LDA #%01000000         \ Set a mask in A to the second pixel in the 8-pixel byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE1               \ If we have just reached the right end of the line,
                        \ jump to LIE1 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI83               \ If the addition didn't overflow, jump to LI83 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI83-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI83-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI83

 LDA #%00100000         \ Set a mask in A to the third pixel in the 8-pixel byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE1               \ If we have just reached the right end of the line,
                        \ jump to LIE1 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI84               \ If the addition didn't overflow, jump to LI84 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI84-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI84-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI84

 LDA #%00010000         \ Set a mask in A to the fourth pixel in the 8-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE1               \ If we have just reached the right end of the line,
                        \ jump to LIE1 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI85               \ If the addition didn't overflow, jump to LI85 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI85-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI85-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI85

 LDA #%00001000         \ Set a mask in A to the fifth pixel in the 8-pixel byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE0S              \ If we have just reached the right end of the line,
                        \ jump to LIE0 via LIE0S to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI86               \ If the addition didn't overflow, jump to LI86 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI86-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI86-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI86

 LDA #%00000100         \ Set a mask in A to the sixth pixel in the 8-pixel byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE0               \ If we have just reached the right end of the line,
                        \ jump to LIE0 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI87               \ If the addition didn't overflow, jump to LI87 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI87-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI87-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI87

 LDA #%00000010         \ Set a mask in A to the seventh pixel in the 8-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

.LIE0S

 BEQ LIE0               \ If we have just reached the right end of the line,
                        \ jump to LIE0 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI88               \ If the addition didn't overflow, jump to LI88 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI88-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI88-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI88

 LDA #%00000001         \ Set a mask in A to the eighth pixel in the 8-pixel
                        \ byte

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIE0               \ If we have just reached the right end of the line,
                        \ jump to LIE0 to return from the subroutine

 LDA S2                 \ Set S2 = S2 + Q2 to update the slope error
 ADC Q2
 STA S2

 BCC LI89               \ If the addition didn't overflow, jump to LI89 to move
                        \ on to the next pixel to draw

 DEY                    \ Otherwise we just overflowed, so decrement Y to move
                        \ to the pixel line above

 BPL LI89-1             \ If Y is positive we are still within the same
                        \ character block, so skip to LI89-1 to move on to the
                        \ next pixel to draw

 LDA SC                 \ Otherwise we need to move up into the character block
 SBC #&40               \ above, so subtract 320 (&140) from SC(1 0) to move up
 STA SC                 \ one pixel line, as there are 320 bytes in each
 LDA SC+1               \ character row in the screen bitmap
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in the new
                        \ character block

 CLC                    \ Clear the C flag, ready for the addition in the next
                        \ part

.LI89

 LDA SC                 \ Add 8 to SC(1 0), starting with the low byte, so SC
 ADC #8                 \ now points to the next character along to the right
 STA SC

 BCS P%+5               \ If the addition just overflowed then skip the next
                        \ instruction as we need to increment the high byte

 JMP LI81               \ Loop back to draw the next character along to the
                        \ right

 INC SC+1               \ Increment the high byte of SC(1 0), so SC now points
                        \ to the next character along to the right

 JMP LI81               \ Loop back to draw the next character along to the
                        \ right

.LIE0

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

