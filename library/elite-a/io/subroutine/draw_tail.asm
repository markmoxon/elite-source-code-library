\ ******************************************************************************
\
\       Name: draw_tail
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the draw_tail command (draw a ship on the 3D scanner)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a draw_tail command. It draws a
\ ship on the 3D scanner, as a dot and (if applicable) a tail, using the base
\ and alternating colours specified (so it can draw a striped tail for when an
\ I.F.F. system is fitted).
\
\ ******************************************************************************

.draw_tail

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA X1                 \
 JSR tube_get           \   draw_tail(x, y, base_colour, alt_colour, height)
 STA Y1                 \
 JSR tube_get           \ and store them as follows:
 STA COL                \
 JSR tube_get           \   * X1 = ship's screen x-coordinate on the scanner
 STA Y2                 \
 JSR tube_get           \   * Y1 = ship's screen y-coordinate on the scanner
 STA P                  \
                        \   * COL = base colour
                        \
                        \   * Y2 = alternating (EOR) colour
                        \
                        \   * P = stick height

.SC48

 JSR CPIX2              \ Call CPIX2 to draw a single-height dash at (X1, Y1)

 DEC Y1                 \ Decrement the y-coordinate in Y1 so the next call to
                        \ CPIX2 draws another dash on the line above, resulting
                        \ in a double-height dash

 JSR CPIX2              \ Call CPIX2 to draw a single-height dash at (X1, Y1)

                        \ These calls also leave the following variables set up
                        \ for the dot's top-right pixel, the last pixel to be
                        \ drawn by the second call to CPIX2:
                        \
                        \   SC(1 0) = screen address of the pixel's character
                        \             block
                        \
                        \   Y = number of the character row containing the pixel
                        \
                        \   X = the pixel's number (0-3) in that row
                        \
                        \ We can use there as the starting point for drawing the
                        \ stick, if there is one

 LDA CTWOS+1,X          \ Load the same mode 5 one-pixel byte that we just used
 AND COL                \ for the top-right pixel, mask it with the base colour
 STA COL                \ in COL, and store the result in COL, so we can use it
                        \ as the character row byte for the base colour stripes
                        \ in the stick

 LDA CTWOS+1,X          \ Load the same mode 5 one-pixel byte that we just used
 AND Y2                 \ for the top-right pixel, mask it with the EOR colour
 STA Y2                 \ in Y2, and store the result in Y2, so we can use it
                        \ as the character row byte for the alternate colour
                        \ stripes in the stick

 LDX P                  \ Fetch the stick height from P into X

 BEQ RTS                \ If the stick height is zero, then there is no stick to
                        \ draw, so return from the subroutine (as RTS contains
                        \ an RTS)

 BMI RTS+1              \ If the stick height in A is negative, jump down to
                        \ RTS+1

.VLL1

                        \ If we get here then the stick length is positive (so
                        \ the dot is below the ellipse and the stick is above
                        \ the dot, and we need to draw the stick upwards from
                        \ the dot)

 DEY                    \ We want to draw the stick upwards, so decrement the
                        \ pixel row in Y

 BPL VL1                \ If Y is still positive then it correctly points at the
                        \ line above, so jump to VL1 to skip the following

 LDY #7                 \ We just decremented Y up through the top of the
                        \ character block, so we need to move it to the last row
                        \ in the character above, so set Y to 7, the number of
                        \ the last row

 DEC SC+1               \ Decrement the high byte of the screen address to move
                        \ to the character block above

.VL1

 LDA COL                \ Set A to the character row byte for the stick, which
                        \ we stored in COL above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR Y2                 \ Apply the alternating colour in Y2 to the stick

 STA COL                \ Update the value in COL so the alternating colour is
                        \ applied every other row (as doing an EOR twice
                        \ reverses it)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 DEX                    \ Decrement the (positive) stick height in X

 BNE VLL1               \ If we still have more stick to draw, jump up to VLL1
                        \ to draw the next pixel

.RTS

 RTS                    \ Return from the subroutine

                        \ If we get here then the stick length is negative (so
                        \ the dot is above the ellipse and the stick is below
                        \ the dot, and we need to draw the stick downwards from
                        \ the dot)

 INY                    \ We want to draw the stick downwards, so we first
                        \ increment the row counter so that it's pointing to the
                        \ bottom-right pixel in the dot (as opposed to the top-
                        \ right pixel that the call to CPIX4 finished on)

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE P%+6               \ correctly points at the next line down, so jump to
                        \ VLL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VLL2

 INY                    \ We want to draw the stick itself, heading downwards,
                        \ so increment the pixel row in Y

 CPY #8                 \ If the row number in Y is less than 8, then it
 BNE VL2                \ correctly points at the next line down, so jump to
                        \ VL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address to move
                        \ to the character block above

.VL2

 LDA COL                \ Set A to the character row byte for the stick, which
                        \ we stored in COL above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR Y2                 \ Apply the alternating colour in Y2 to the stick

 STA COL                \ Update the value in COL so the alternating colour is
                        \ applied every other row (as doing an EOR twice
                        \ reverses it)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y             \ EOR logic

 INX                    \ Increment the (negative) stick height in X

 BNE VLL2               \ If we still have more stick to draw, jump up to VLL2
                        \ to draw the next pixel

 RTS                    \ Return from the subroutine

