\ ******************************************************************************
\
\       Name: clearrow
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear a character row of screen memory, drawing blue borders along
\             the left and right edges as we do so
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The character row number
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.clearrow

 LDA #8                 \ Set T2 = 8 to act as a pixel row counter
 STA T2

 LDX SCTBL,Y            \ Set the low byte of SC(1 0) to the Y-th entry from
 STX SC                 \ SCTBL, which contains the low byte of the address of
                        \ the start of character row Y in screen memory

 LDX SCTBH,Y            \ Set X to the Y-th entry from SCTBH, which contains
                        \ the high byte of the address of the start of character
                        \ row Y in screen memory

 TYA                    \ Store the number of the character row we are clearing
 PHA                    \ on the stack, so we can retrieve it below

.cleargl2

 STX SC+1               \ Set the high byte of SC(1 0) to X, so it contains the
                        \ address of the start of the pixel row we want to clear

 LDA #%10100000         \ Set A to the pixel byte for the right end of the pixel
                        \ row, containing a blue border in the second-to-last
                        \ pixel (bit 7 is set to choose colour palette 1)

 LDY #37                \ We now clear the pixel row, starting from the right
                        \ end of the line, so set a pixel byte counter in Y to
                        \ count down from byte #37 to byte #1

.cleargl3

 STA (SC),Y             \ Set the Y-th pixel byte of the row to the pixel byte
                        \ in A

 LDA #0                 \ Set A = 0 so the last byte contains the border, but
                        \ the rest of them are blank

 DEY                    \ Decrement the byte counter

 BNE cleargl3           \ Loop back until we have drawn bytes #37 to #1, leaving
                        \ Y = 0

 LDA #%11000000         \ Set A to the pixel byte for the left end of the pixel
                        \ row, containing a blue border in the seventh pixel
                        \ (bit 7 is set to choose colour palette 1)

 STA (SC),Y             \ Draw the pixel byte for the left end of the pixel row
                        \ in the first byte of the row at SC(1 0)

 INY                    \ Increment Y to point to the second pixel byte in the
                        \ row

 ASL A                  \ Set A = %10000000, which is a pixel byte in colour
                        \ palette 1 with no pixels set

 STA (SC),Y             \ Draw this as the second pixel byte in the row to set
                        \ the colour palette for the second pixel to palette 1,
                        \ so the left edge is drawn correctly in blue

 INX                    \ Set X = X + 4, so the high byte of SC(1 0) gets
 INX                    \ increased by 4 when we loop back, which means we do
 INX                    \ the following:
 INX                    \
                        \   SC(1 0) = SC(1 0) + &400
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ below the one we just drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

 DEC T2                 \ Decrement the pixel row counter in T2

 BNE cleargl2           \ Loop back until we have cleared all eight pixel rows
                        \ in the character row

 PLA                    \ Restore the number of the character row into Y, so we
 TAY                    \ can return it unchanged

                        \ Fall through into SCAN to return from the subroutine,
                        \ as it starts with an RTS

