\ ******************************************************************************
\
\       Name: SC48
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the #onescan command (draw a ship on the 3D scanner)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #onescan command with parameters
\ in the block at OSSC(1 0). It draws a ship on the 3D scanner. The parameters
\ match those put into the SCANpars block in the parasite.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The sign of the stick height (in bit 7)
\
\                         * Byte #3 = The stick height for this ship on the
\                                     scanner
\
\                         * Byte #4 = The colour of the ship on the scanner
\
\                         * Byte #5 = The screen x-coordinate of the dot on the
\                                     scanner
\
\                         * Byte #6 = The screen y-coordinate of the dot on the
\                                     scanner
\
\ ******************************************************************************

.SC48

 LDY #4                 \ Fetch byte #4 from the parameter block (the colour)
 LDA (OSSC),Y           \ and store it in COL
 STA COL

 INY                    \ Fetch byte #5 from the parameter block (the screen
 LDA (OSSC),Y           \ x-coordinate) and store it in X1
 STA X1

 INY                    \ Fetch byte #6 from the parameter block (the screen
 LDA (OSSC),Y           \ y-coordinate) and store it in Y1
 STA Y1

 JSR CPIX4              \ Draw a double-height mode 2 dot at (X1, Y1). This also
                        \ leaves the following variables set up for the dot's
                        \ top-right pixel, the last pixel to be drawn (as the
                        \ dot gets drawn from the bottom up):
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

 LDA CTWOS+2,X          \ Load the same mode 2 one-pixel byte that we just used
 AND COL                \ for the top-right pixel, and mask it with the same
 STA X1                 \ colour, storing the result in X1, so we can use it as
                        \ the character row byte for the stick

 STY Q                  \ Store Y in Q so we can retrieve it after fetching the
                        \ stick details

 LDY #2                 \ Fetch byte #2 from the parameter block (the sign of
 LDA (OSSC),Y           \ the stick height) and shift bit 7 into the C flag, so
 ASL A                  \ C now contains the sign of the stick height

 INY                    \ Set A to byte #3 from the parameter block (the stick
 LDA (OSSC),Y           \ height)

 BEQ RTS                \ If the stick height is zero, then there is no stick to
                        \ draw, so return from the subroutine (as RTS contains
                        \ an RTS)

 LDY Q                  \ Restore the value of Y from Q, so Y now contains the
                        \ character row containing the dot we drew above

 TAX                    \ Copy the stick height into X

 BCC RTS+1              \ If the C flag is clear then the stick height in A is
                        \ negative, so jump down to RTS+1

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

 DEC SC+1               \ Decrement the high byte of the screen address twice to
 DEC SC+1               \ move to the character block above (we do this twice as
                        \ there are two pages in memory per character row)

.VL1

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y

 DEX                    \ Decrement (positive) the stick height in X

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
 BNE VLL2               \ correctly points at the next line down, so jump to
                        \ VLL2 to skip the following

 LDY #0                 \ We just incremented Y down through the bottom of the
                        \ character block, so we need to move it to the first
                        \ row in the character below, so set Y to 0, the number
                        \ of the first row

 INC SC+1               \ Increment the high byte of the screen address twice to
 INC SC+1               \ move to the character block above (we do this twice as
                        \ there are two pages in memory per character row)

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

 INC SC+1               \ Increment the high byte of the screen address twice to
 INC SC+1               \ move to the character block above (we do this twice as
                        \ there are two pages in memory per character row)

.VL2

 LDA X1                 \ Set A to the character row byte for the stick, which
                        \ we stored in X1 above, and which has the same pixel
                        \ pattern as the bottom-right pixel of the dot (so the
                        \ stick comes out of the right side of the dot)

 EOR (SC),Y             \ Draw the stick on row Y of the character block using
 STA (SC),Y

 INX                    \ Decrement the (negative) stick height in X

 BNE VLL2               \ If we still have more stick to draw, jump up to VLL2
                        \ to draw the next pixel

 RTS                    \ Return from the subroutine

