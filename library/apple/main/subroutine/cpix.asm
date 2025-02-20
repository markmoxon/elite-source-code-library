\ ******************************************************************************
\
\       Name: CPIX
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a colour pixel
\  Deep dive: Drawing pixels in the Apple II version
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The screen x-coordinate of the pixel
\
\   A                   The screen y-coordinate of the pixel
\
\   COL                 The pixel colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   The byte offset within the pixel row of the byte that
\                       contains the pixel
\
\   T2                  The number of the pixel row within the character block
\                       that contains the pixel
\
\   R                   The pixel byte for drawing the pixel
\
\ ******************************************************************************

.CPIX

 STA Y1                 \ Store the y-coordinate in Y1

 LSR A                  \ Set T1 = A >> 3
 LSR A                  \        = y div 8
 LSR A                  \
 STA T1                 \ So T1 now contains the number of the character row
                        \ that will contain the pixel we want to draw

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA Y1                 \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our pixel (as
                        \ each character block has 8 rows)

 STA T2                 \ Store the pixel row number in T2, so we can return it
                        \ from the subroutine

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

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel we want to draw (as X contains the x-coordinate
                        \ of the pixel)

 LDA #0                 \ Set A = 0 to use as the pixel mask for the next pixel
                        \ byte along, so by default we don't change anything in
                        \ the next pixel byte

 CPY #6                 \ If Y = 6 then then the bit number for the pixel is bit
 BNE P%+4               \ 6 and we will need to spill into the next pixel byte,
 LDA #%10000001         \ so set A = %10000001 to use as the pixel mask for the
                        \ next pixel byte along

 STA T3                 \ Store the pixel mask for the next pixel byte in T3

 LDA TWOS2,Y            \ Fetch a two-bit pixel byte with the pixels set at
 STA R                  \ position Y and store it in R so we can use it as a
                        \ mask for the bits we want to change in the pixel byte

 LDA SCTBX2,X           \ Using the lookup table at SCTBX2, set A to the byte
                        \ number within the pixel row that contains the pixel we
                        \ want to draw (as X contains the x-coordinate of the
                        \ start of the line)

 AND #1                 \ Set Y to the colour in COL, plus 1 if the byte number
 ORA COL                \ within the pixel row is odd
 TAY                    \
                        \ We can use this to fetch the correct pixel bytes from
                        \ MASKT that we can poke into screen memory to draw a
                        \ continuous line of the relevant colour
                        \
                        \ Bytes #0 and #1 of the relevant entry in MASKT contain
                        \ the bit pattern for when the first byte is placed in
                        \ an even-numbered pixel byte (counting along the pixel
                        \ row), while bytes #1 and #2 contain the bit pattern
                        \ for when the first byte is placed in an odd-numbered
                        \ pixel byte
                        \
                        \ So Y now points to the correct MASKT entry for the
                        \ start of the line, because it points to byte #0 in
                        \ offset COL if the byte number within the pixel row is
                        \ even, or byte #1 in offset COL if the byte number
                        \ within the pixel row is odd

 LDA MASKT+1,Y          \ Set T3 to the correct pixel byte for drawing our pixel
 AND T3                 \ in the next pixel byte along, by combining the colour
 STA T3                 \ mask from MASKT+1 with the pixel mask in T3

 LDA MASKT,Y            \ Set A to the correct pixel byte for drawing our pixel
 AND R                  \ in the first pixel byte, by combining the colour mask
                        \ from MASKT with the pixel mask in A

 STA R                  \ Store the pixel byte for drawing our pixel in R, so it
                        \ can be returned by the subroutine

                        \ So A contains the pattern for the byte at the pixel
                        \ coordinates, and T3 contains the pattern for the next
                        \ byte along

 LDY SCTBX2,X           \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the pixel
                        \ at X

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 LDA T3                 \ Set A to the pattern for the next byte along

 BEQ CPR1               \ If T3 is zero then there is no need to write to the
                        \ next byte along, so jump to CPR1 to return from the
                        \ subroutine

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 EOR (SC),Y             \ Draw the pixel pattern in A into the Y-th pixel byte
 STA (SC),Y             \ on the correct pixel row, using EOR logic to merge the
                        \ pattern with whatever is already on-screen

 DEY                    \ Decrement Y to move back to the previous pixel byte,
                        \ so we can return this value from the subroutine

.CPR1

 RTS                    \ Return from the subroutine

