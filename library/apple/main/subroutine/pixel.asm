\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a two-pixel dash, three-pixel dash or double-height
\             three-pixel dash
\
\ ------------------------------------------------------------------------------
\
\ Draw a point at screen coordinate (X, A) with the point size determined by the
\ distance in ZZ. This applies to the top part of the screen (the space view).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The screen x-coordinate of the point to draw
\
\   A                   The screen y-coordinate of the point to draw
\
\   ZZ                  The distance of the point, with bigger distances drawing
\                       smaller points:
\
\                         * ZZ < 80           Double-height three-pixel dash
\
\                         * 80 <= ZZ <= 127   Single-height three-pixel dash
\
\                         * ZZ > 127          Single-height two-pixel dash
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PXR1                Contains an RTS
\
\ ******************************************************************************

.PIXEL

 STY T1                 \ Store Y in T1 so we can restore it at the end of the
                        \ subroutine

                        \ We start by calculating the address in scren memory of
                        \ the start of the pixel row containing the pixel we
                        \ want to draw (i.e. pixel row A)

 STA SC+1               \ Store the pixel y-coordinate in SC+1, so we can use it
                        \ later

 LSR A                  \ Set T3 = A >> 3
 LSR A                  \        = y div 8
 LSR A                  \        = character row number
 STA T3

 TAY                    \ Set the low byte of SC(1 0) to the Y-th entry from
 LDA SCTBL,Y            \ SCTBL, which contains the low byte of the address of
 STA SC                 \ the start of character row Y in screen memory

 LDA SC+1               \ Set A to the pixel y-coordinate, which we stored in
                        \ SC+1 above

 AND #%00000111         \ Set T2 to just bits 0-2 of the y-coordinate, which
 STA T2                 \ will be the number of the pixel row we need to draw
                        \ within the character row

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

                        \ We now need to work out which bits on this pixel row
                        \ contain the pixel we want to draw, and then draw them

 LDA SCTBX1,X           \ Using the lookup table at SCTBX1, set A to the bit
                        \ number within the pixel byte that corresponds to the
                        \ pixel at the x-coordinate in X (so A is in the range
                        \ 0 to 6, as bit 7 in the pixel byte is used to set the
                        \ pixel byte's colour palette)

 ASL A                  \ Double the value in A so we can use it as an index
                        \ into the TWOS3 table, as TWOS3 contains two bytes for
                        \ each of the seven different pixel positions (to cater
                        \ for potential overflow of the dash into the next pixel
                        \ byte)
                        \
                        \ At this stage A is an index into the first half of the
                        \ TWOS3 table, which contains two-pixel bytes (with two
                        \ bits set)
                        \
                        \ This also clears the C flag for the addition below, as
                        \ we know A was in the range 0 to 6 before we shifted
                        \ it, which means bit 7 was 0 before it was shifted into
                        \ the C flag

 LDY ZZ                 \ Set Y to the distance of the point we want to draw

 BMI P%+4               \ If the distance in ZZ < 127, add 14 to A (the addition
 ADC #14                \ works as we know the C flag is clear)
                        \
                        \ This means that A is now an index into the second half
                        \ of the TWOS3 table, which contains three-pixel bytes
                        \ (with three bits set), rather than the two-pixel bytes
                        \ in the first half
                        \
                        \ This means that points at smaller distances in ZZ are
                        \ drewn with longer dashes
                        \
                        \ We add 14 because the first half of TWOS3 consists of
                        \ seven two-byte entries, so adding 14 skips to the
                        \ second half

 CPY #80                \ If the distance in Y >= 80, set the C flag

 LDY SCTBX2,X           \ Using the lookup table at SCTBX2, set Y to the byte
                        \ number within the pixel row that contains the pixel we
                        \ want to draw

 TAX                    \ Copy the value of A into X, so X now contains the
                        \ index into TWOS3 for the 

 BCS PX4                \ If the C flag is set then the point distance in Y is
                        \ 80 or more, so jump to PX4 to skip the following and
                        \ draw a single-height dash
                        \
                        \ The above logic means we draw the following:
                        \
                        \   * ZZ < 80           Double-height three-pixel dash
                        \
                        \   * 80 <= ZZ <= 127   Single-height three-pixel dash
                        \
                        \   * ZZ > 127          Single-height two-pixel dash

                        \ Otherwise the point distance in Y is less than 80, so
                        \ we want to draw a double-height dash, starting with
                        \ the bottom pixel row of the dash

 LDA TWOS3,X            \ Otherwise fetch the first byte of the pixel dash in
 EOR (SC),Y             \ pixel position X from TWOS3, and EOR it into SC+Y
 STA (SC),Y

 LDA TWOS3+1,X          \ Fetch the second byte of the pixel dash from TWOS3 in
                        \ case the dash spills over into the next pixel byte

 BEQ PX3                \ If it zero then there is nothing to plot in the
                        \ second byte, so jump to PX3 to skip the following

 INY                    \ EOR the second byte into SC+Y+1, which is the next
 EOR (SC),Y             \ pixel byte along, leaving the value of Y unchanged
 STA (SC),Y
 DEY

.PX3

                        \ We now want to draw the same dash in the pixel row
                        \ above, to form a double-height dash

 LDA T2                 \ If the number of the pixel row we just drew is zero
 BEQ PX6                \ (which we stored in T2 above), then jump to PX6 to
                        \ calculate the address of the bottom pixel row in the
                        \ character row above

 LDA SC+1               \ Otherwise subtract 4 from the high byte of SC(1 0), so
 SBC #3                 \ this does the following:
 STA SC+1               \
                        \   SC(1 0) = SC(1 0) - &400
                        \
                        \ The SBC subtracts 4 rather than 3 because the C flag
                        \ is clear, as we passed through the BCS above
                        \
                        \ So this sets SC(1 0) to the address of the pixel row
                        \ above the one we jjust drew in, as each pixel row
                        \ within the character row is spaced out by &400 bytes
                        \ in screen memory

.PX4

                        \ If we get here then we are either drawing the top row
                        \ of a double-height dash (if we fell through from
                        \ above), or the only row of a single-height dash (if we
                        \ jumped to here from above)

 LDA TWOS3,X            \ Fetch the first byte of the pixel dash in pixel
 EOR (SC),Y             \ position X from TWOS3, and EOR it into SC+Y
 STA (SC),Y

 LDA TWOS3+1,X          \ Fetch the second byte of the pixel dash from TWOS3
                        \ in case the dash spills over into the next pixel byte

 BEQ PX5                \ If it zero then there is nothing to plot in the
                        \ second byte, so jump to PX5 to skip the following

 INY                    \ EOR the second byte into SC+Y+1, which is the next
 EOR (SC),Y             \ pixel byte along
 STA (SC),Y

.PX5

 LDY T1                 \ Restore Y from T1, so Y is preserved by the routine

.PXR1

 RTS                    \ Return from the subroutine

.PX6

                        \ If we get here then we just drew the top part of a
                        \ double-height dash in the top pixel row of the
                        \ character row, so we need to set SC(1 0) to the
                        \ address of the bottom pixel line in the character row
                        \ above

 STX T2                 \ Store the pixel position in X in T2 so we can retrieve
                        \ it below

 LDX T3                 \ Set X to the character row where we just drew our dash
                        \ in the top pixel row

 LDA SCTBL-1,X          \ Use the SCTBH2 lookup table to set SC(1 0) to the
 STA SC                 \ address of the bottom pixel row in character row X-1,
 LDA SCTBH2-1,X         \ which is the bottom pixel row in the character row
 STA SC+1               \ above the one we just drew in

 LDX T2                 \ Retrieve the pixel position in X that we stored in T2

 JMP PX4                \ Jump up to PX4 to draw the top line of the
                        \ double-height dash in the bottom row of the new
                        \ character row

