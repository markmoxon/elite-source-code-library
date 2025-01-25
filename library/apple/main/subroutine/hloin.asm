\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
\
\ ------------------------------------------------------------------------------
\
\ We do not draw a pixel at the right end of the line.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   COL                 The line colour, as an offset into the MASKT table
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.HLOIN

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

                        \ We are going to draw the line like this:
                        \
                        \   * Draw the byte containing the start of the line
                        \     (and if it also happens to contain the end of the
                        \     line, draw both ends in one byte and terminate)
                        \
                        \   * Draw any full bytes in the middle of the line
                        \
                        \   * Draw the byte containing the end of the line, plus
                        \     one more pixel (which may spill over into the next
                        \     pixel byte)
                        \
                        \ We draw the end cap with an extra pixel to ensure that
                        \ there is room for a full two-bit colour number in the
                        \ last byte (i.e. %00 for two black pixels, %11 for two
                        \ white pixels, %01 or %10 for two coloured pixels)
                        \
                        \ To facilitate this approach, we need to make sure the
                        \ start and end x-coordinates are both even, so the
                        \ two-bit colour numbers start on even pixel numbers

 LDA X1                 \ Round the x-coordinate in X1 down to the nearest even
 AND #%11111110         \ coordinate, so we can draw the line in two-pixel steps
 STA X1

 TAX                    \ Set X to the rounded x-coordinate in X1

 LDA X2                 \ Round the x-coordinate in X2 down to the nearest even
 AND #%11111110         \ coordinate, setting A to the rounded coordinate in X2
 STA X2                 \ in the process, so we can draw the line in two-pixel
                        \ steps

 CMP X1                 \ If X1 = X2 then the start and end points are the same,
 BEQ HL6                \ so return from the subroutine (as HL6 contains an RTS)

 BCS HL5                \ If X1 < X2, jump to HL5 to skip the following code, as
                        \ (X1, Y1) is already the left point

 STX X2                 \ Swap the values of X1 and X2 (in X and X2), so we know
 TAX                    \ that (X1, Y1) is on the left and (X2, Y1) is on the
                        \ right
                        \
                        \ This does not update X1, but we don't use it in the
                        \ following (we use X instead)

.HL5

 LDA Y1                 \ Set A to the y-coordinate in Y1

 LSR A                  \ Set A = A >> 3
 LSR A                  \       = y div 8
 LSR A                  \
                        \ So A now contains the number of the character row
                        \ that will contain our horizontal line

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA Y1                 \ Set A = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw our line (as
                        \ each character block has 8 rows)

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

 LDA MASKT,Y            \ Set T1 and T2 to the correct pixel bytes for drawing a
 STA T1                 \ continuous line in colour COL into the pixel byte that
 LDA MASKT+1,Y          \ contains the pixel we want to draw
 STA T2

                        \ So T1 contains the pattern for the byte at the start
                        \ of the line, and T2 contains the pattern for the next
                        \ byte along, and T1 contains the pattern for the byte
                        \ after that, and so on
                        \
                        \ In other words, we alternate between the patterns in
                        \ T1 and T2 as we work our way along the line, one byte
                        \ at a time

.HL1

 LDY X2                 \ Using the lookup table at SCTBX2, set A to the byte
 LDA SCTBX2-2,Y         \ number within the pixel row that contains the pixel
                        \ at X2 - 2, so we omit the last pixel (we subtract 2
                        \ as we draw the end of the line with an extra pixel)

 LDY SCTBX1,X           \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at the start of the line (as X contains the
                        \ x-coordinate of the start of the line)

 SEC                    \ SCTBX2,X is the byte number within the pixel row that
 SBC SCTBX2,X           \ contains the pixel at X, which is at the start of the
 STA R                  \ line, so this calculation:
                        \
                        \   R = A - SCTBX2,X
                        \
                        \ sets R to the number of pixel bytes between the start
                        \ and the end of the line

 LDA TWFR,Y             \ Fetch a ready-made byte with Y pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point Y and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

 AND T1                 \ Apply the pixel mask in A to the continuous block of
                        \ coloured pixels in T1, so we now know which bits to
                        \ set in screen memory to paint the relevant pixels in
                        \ the required colour for the pixel byte at the start
                        \ of the line

 LDY SCTBX2,X           \ Set Y to the byte number within the pixel row that
                        \ contains the pixel at X, which is at the start of the
                        \ line

 LDX R                  \ Set X = R, so X contains the number of pixel bytes
                        \ between the start and end of the line
                        \
                        \ We use X as a counter in the following to ensure we
                        \ draw the correct number of bytes for the line

 BEQ HL3                \ If X = 0 then there are no pixel bytes between the
                        \ start and end, which means the line starts and ends
                        \ within the same pixel byte, so jump to HL3 to draw
                        \ this single-byte line

                        \ Otherwise we need to draw the pixel byte containing
                        \ the left end of the line

 STA T4                 \ Store the pixel pattern for the left end of the line
                        \ in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte, so X now contains the number of
                        \ bytes left before we reach the pixel byte containing
                        \ the end of the line

 BEQ HL4                \ If X = 0 then there are no more pixel bytes before we
                        \ reach the end of the line, so jump to HL4 to skip
                        \ drawing any pixel bytes between the start and end
                        \ bytes (as there aren't any)

                        \ Otherwise we now loop through all the pixel bytes in
                        \ the line between the start byte and the end byte,
                        \ using the counter in X to draw the correct number of
                        \ bytes
                        \
                        \ We draw the bytes in the middle of the line two at a
                        \ time, using pattern T2 for the first byte, then T1
                        \ for the next, and then T2 again, and so on
                        \
                        \ If we reach the end of the middle section having just
                        \ drawn a T2 byte, we jump to HL8 to make sure we draw
                        \ the end of the line using pattern T1, otherwise we
                        \ fall through into HL4 to draw it using pattern T2

.HLL1

 LDA (SC),Y             \ Draw the pixel pattern in T2 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T2                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T2

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte

 BEQ HL8                \ If X = 0 then we have drawn all the bytes between the
                        \ start and end bytes, so jump to HL8 to draw the byte
                        \ at the end of line using pattern T1

 LDA (SC),Y             \ Draw the pixel pattern in T1 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T1                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T1

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right

 DEX                    \ Decrement the byte counter in X as we just drew the
                        \ first pixel byte

 BNE HLL1               \ Loop back until we have drawn all X bytes

                        \ We have finished drawing the middle of the line, so
                        \ fall through into HL4 to draw the end of the line
                        \ using the pattern in T2

.HL4

                        \ If we reach here then we only have one more pixel byte
                        \ to draw, the one for the end of the line

 LDA T2                 \ Set A to the pattern in T2, as we only get here if we
                        \ have just drawn a pixel byte with the pattern in T1

.HL2

 LDX X2                 \ Set X to the x-coordinate of the end of the line

 LDY SCTBX1-2,X         \ Using the lookup table at SCTBX1, set Y to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at x-coordinate X2 - 2, so we omit the last
                        \ pixel (we subtract 2 as we draw the end of the line
                        \ with an extra pixel)

 CPY #6                 \ If Y < 6 then clear the C flag, so we can use this to
                        \ check whether we need to spill into the next pixel
                        \ byte to draw the end of the line properly

 AND TWFL,Y             \ Apply the pixel pattern in A to a ready-made byte with
                        \ Y + 1 pixels filled in at the left end of the byte (so
                        \ the filled pixels start at the left edge and go up to
                        \ point Y + 1), which is the shape we want for the right
                        \ end of the line
                        \
                        \ Note that unlike TWFR, the minimum cap size is two
                        \ pixels, so it can take a full two-bit colour number
                        \ even if we only really need one pixel in the end cap

 LDY SCTBX2-2,X         \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the pixel
                        \ at X2 - 2, so we omit the last pixel (we subtract 2
                        \ as we draw the end of the line with an extra pixel)

 STA T4                 \ Store the pixel pattern for the right end of the line
                        \ in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

 BCC HL7                \ If the C flag is clear then the bit number for the
                        \ pixel at the end of the line is less than 6, so jump
                        \ to HL7 as the end of the line is not spilling into the
                        \ next pixel byte

                        \ If we get here then the last pixel in the line is at
                        \ bit number 6, so we need to spill over by one bit into
                        \ the next pixel byte, as the colour of a pixel is
                        \ defined by a two-bit sequence

 LDA #%10000001         \ We only want to draw one bit into the next pixel byte,
 AND T1                 \ and the bit we need to set is bit 0, as this is the
                        \ leftmost pixel in the pixel byte, so we take the pixel
                        \ pattern from T1 and extract just bits 0 (for the
                        \ overspill) and bit 7 (for the colour palette) to leave
                        \ the correct pixel byte for the overspill in A

 INY                    \ Increment Y to move to the next pixel byte to the
                        \ right, which is where we need to poke the overspill

 STA T4                 \ Store the pixel pattern for the overspill in T4

 LDA (SC),Y             \ Draw the pixel pattern in T4 into the Y-th pixel byte
 AND #%01111111         \ on the line's pixel row, using EOR logic to merge the
 EOR T4                 \ pattern with whatever is already on-screen, and using
 STA (SC),Y             \ AND to set the colour palette in bit 7 to that in T4

.HL7

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.HL8

                        \ If we get here then we just finished drawing the
                        \ middle section of the line using pattern T2, so we
                        \ need to draw the end of the line using pattern T1

 LDA T1                 \ Set A to the colour pattern in T1, to use for the
                        \ last pixel byte at the end of the line

.HL3

                        \ If we jump directly here from above, then the line
                        \ starts and ends within the same pixel byte, and A
                        \ contains the pixel pattern for the left end of the
                        \ line, so we keep that pattern in A before jumping to
                        \ HL2
                        \
                        \ This means that when we apply the pattern in A to the
                        \ end of the line, we end up with a single-byte pixel
                        \ pattern that contains both ends of the line

 LDX T2                 \ Set T1 = T2
 STX T1                 \
                        \ We do this because the routine at HL2 draws the pixel
                        \ byte for the end of the line using the pattern in A,
                        \ which will either be T1 (if we got here via HL8 above)
                        \ or the single-byte pixel pattern that's based on T1
                        \ (if we got here by jumping to HL3)
                        \
                        \ In both cases the pattern of the next byte along after
                        \ the end of the line should therefore be in pattern T2,
                        \ and the code at HL2 uses the pattern in T1 to draw any
                        \ overspill after the byte containing the end of the
                        \ line, so this ensures that any overspill uses the
                        \ pattern in T2, rather than T1

 JMP HL2                \ Jump to HL2 to draw the last pixel byte of the line
                        \ using the pixel pattern in A

