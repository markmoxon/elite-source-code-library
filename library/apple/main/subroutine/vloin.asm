\ ******************************************************************************
\
\       Name: VLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a vertical line from (X1, Y1) to (X1, Y2)
\  Deep dive: Drawing pixels in the Apple II version
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   R                   The line colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.VLOIN

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDA Y1                 \ Set A to the y-coordinate of the start of the line

 CMP Y2                 \ If Y1 >= Y2 then jump to VLO1 as the coordinates are
 BCS VLO1               \ already the correct way around

 LDY Y2                 \ Otherwise swap Y1 and Y2 around so that Y1 >= Y2
 STA Y2                 \ (with Y1 in A)
 TYA

.VLO1

                        \ We now want to draw a line from (X1, A) to (X1, Y2),
                        \ which goes up the screen from bottom to top

 LDX X1                 \ Draw a single pixel at screen coordinate (X1, A), at
 JSR CPIX               \ the start of the line
                        \
                        \ This also sets the following:
                        \
                        \   * T2 = the number of the pixel row within the
                        \          character block that contains the pixel,
                        \          which we use in the loop below to draw the
                        \          line
                        \
                        \   * R = the pixel byte for drawing the pixel
                        \
                        \   * Y = the byte offset within the pixel row of the
                        \         byte that contains the pixel

 LDA Y1                 \ Set A = Y1 - Y2
 SEC                    \
 SBC Y2                 \ So A contains the height of the vertical line in
                        \ pixels

 BEQ VLO5               \ If the start and end points are at the same height,
                        \ jump to VLO5 to return from the subroutine, as we
                        \ already drew a one-pixel vertical line

 TAX                    \ Set X to the height of the line, plus 1, so we can use
 INX                    \ this as a pixel counter in the loop below (the extra 1
                        \ is to take account of the pixel we just drew)

 JMP VLO4               \ Jump into the following loop at VLO4 to draw the rest
                        \ of the line

.VLOL1

 LDA R                  \ Set A to the pixel byte that was returned by the CPIX
                        \ routine when we drew the first pixel in the vertical
                        \ line, which is the same pixel byte that we need for
                        \ every pixel in the line (as it is a vertical line)

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 LDA T3                 \ Set A to the pattern for the next byte along, which
                        \ was returned by the CPIX

 BEQ VLO4               \ If T3 is zero then there is no need to write to the
                        \ next byte along, so jump to VLO4 to move on to drawing
                        \ the rest of the line

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 DEY                    \ Decrement Y to move back to the previous pixel byte,
                        \ so we keep drawing our line in the correct position

.VLO4

                        \ This is where we join the loop from above, at which
                        \ point we have the following variables set:
                        \
                        \   * T2 = the pixel row of the start of the line
                        \
                        \   * X = the height of the line we want to draw + 1
                        \
                        \   * Y = the byte offset within the pixel row of the
                        \         line
                        \
                        \ The height in X has an extra one added to it because
                        \ we are about to decrement it (so that extra one is
                        \ effectively counting the single pixel we already drew
                        \ before jumping here)

 DEC T2                 \ Decrement the pixel row number in T2 to move to the
                        \ pixel row above

 BMI VLO2               \ If T2 is negative then the we are no longer within the
                        \ same character block, so jump to VLO2 to move to the
                        \ bottom pixel row in the character row above

                        \ We now need to move up into the pixel row above

 LDA SC+1               \ Subtract 4 from the high byte of SC(1 0), so this does
 SEC                    \ the following:
 SBC #4                 \
 STA SC+1               \   SC(1 0) = SC(1 0) - &400
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ above the one we just drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

.VLO3

 DEX                    \ Decrement the pixel counter in X

 BNE VLOL1              \ Loop back until we have drawn X - 1 pixels

.VLO5

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.VLO2

                        \ If we get here then we need to move up into the bottom
                        \ pixel row in the character block above

 LDA #7                 \ Set the pixel line number within the character row
 STA T2                 \ (which we store in T2) to 7, which is the bottom pixel
                        \ row of the character block above

 STX T                  \ Store the current character row number in T, so we can
                        \ restore it below

 LDX T1                 \ Decrement the number of the character row in T1, as we
 DEX                    \ are moving up a row
 STX T1

 LDA SCTBL,X            \ Set SC(1 0) to the X-th entry from (SCTBH2 SCTBL), so
 STA SC                 \ it contains the address of the start of the bottom
 LDA SCTBH2,X           \ pixel row in character row X in screen memory (so
                        \ that's the bottom pixel row in the character row we
                        \ just moved up into)
                        \
                        \ We set the high byte below (though there's no reason
                        \ why it isn't done here)

 LDX T                  \ Restore the value of X that we stored, so X contains
                        \ the previous character row number, from before we
                        \ moved up a row (we need to do this as the following
                        \ jump returns us to a point where the previous row
                        \ number is still in X)

 STA SC+1               \ Set the high byte of SC(1 0) as above

 JMP VLO3               \ Jump back to keep drawing the line

