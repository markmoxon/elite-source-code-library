\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Implement the OSWORD 241 command (draw space view pixels)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends an OSWORD 241 command with
\ parameters in the block at OSSC(1 0). It draws a dot (or collection of dots)
\ in the space view.
\
\ It can draw two types of dot, depending on bits 0-2 of the dot's distance:
\
\   * Draw the dot using the dot's distance to determine both the dot's colour
\     and size. This draws a a 1-pixel dot, 2-pixel dash or 4-pixel square in
\     a colour that's determined by the distance (as per the colour table in
\     PXCL). These kinds of dot are sent by the PIXEL3 routine in the parasite.
\
\   * Draw the dot using the dot's distance to determine the dot's size, either
\     a 2-pixel dash or 4-pixel square. The dot is always drawn in white (which
\     is actually a cyan/red stripe). These kinds of dot are sent by the PIXEL
\     routine in the parasite.
\
\ The parameters match those put into the PBUF/pixbl block in the parasite.
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #0 = The size of the pixel buffer being sent
\
\                         * Byte #2 = The distance of the first dot
\
\                           * Bits 0-2 clear = Draw a 2-pixel dash or 4-pixel
\                             square, as determined by the distance, in white
\                             (cyan/red)
\
\                           * Any of bits 0-2 set = Draw a 1-pixel dot, 2-pixel
\                             dash or 4-pixel square in the correct colour, as
\                             determined by the distance
\
\                         * Byte #3 = The x-coordinate of the first dot
\
\                         * Byte #4 = The y-coordinate of the first dot
\
\                         * Byte #5 = The distance of the second dot
\
\                         * Byte #6 = The x-coordinate of the second dot
\
\                         * Byte #7 = The y-coordinate of the second dot
\
\                       and so on
\
\ ******************************************************************************

.PIXEL

 LDY #0                 \ Set Q to byte #0 from the block pointed to by OSSC,
 LDA (OSSC),Y           \ which contains the size of the pixel buffer
 STA Q

 INY                    \ Increment Y to 2, so y now points at the data for the
 INY                    \ first pixel in the command block

.PXLO

 LDA (OSSC),Y           \ Set P to byte #2 from the Y-th pixel block in OSSC,
 STA P                  \ which contains the point's distance value (ZZ)

 AND #%00000111         \ If ZZ is a multiple of 8 (which will be the case for
 BEQ PX5                \ pixels sent by the parasite's PIXEL routine), jump to
                        \ PX5

                        \ Otherwise this pixel was sent by the parasite's PIXEL3
                        \ routine and will have an odd value of ZZ, and we use
                        \ the distance value to determine the dot's colour and
                        \ size

 TAX                    \ Set S to the ZZ-th value from the PXCL table, to get
 LDA PXCL,X             \ the correct colour byte for this pixel, depending on
 STA S                  \ the distance

 INY                    \ Increment Y to 3

 LDA (OSSC),Y           \ Set X to byte #3 from the Y-th pixel block in OSSC,
 TAX                    \ contains the pixel's x-coordinate

 INY                    \ Increment Y to 4

 LDA (OSSC),Y           \ Set Y to byte #4 from the Y-th pixel block in OSSC,
 STY T1                 \ which contains the pixel's y-coordinate, and store Y,
 TAY                    \ the index of this pixel's y-coordinate, in T1

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TXA                    \ Each character block contains 8 pixel rows, so to get
 AND #%11111100         \ the address of the first byte in the character block
 ASL A                  \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-1 and shift left to double
                        \ it (as each character row contains two pages of bytes,
                        \ or 512 bytes, which cover 256 pixels). This also
                        \ shifts bit 7 of the x-coordinate into the C flag

 STA SC                 \ Store the address of the character block in the low
                        \ byte of SC(1 0), so now SC(1 0) points to the
                        \ character block we need to draw into

 BCC P%+4               \ If the C flag is clear then skip the next instruction

 INC SC+1               \ The C flag is set, which means bit 7 of X1 was set
                        \ before the ASL above, so the x-coordinate is in the
                        \ right half of the screen (i.e. in the range 128-255).
                        \ Each row takes up two pages in memory, so the right
                        \ half is in the second page but SC+1 contains the value
                        \ we looked up from ylookup, which is the page number of
                        \ the first memory page for the row... so we need to
                        \ increment SC+1 to point to the correct page

 TYA                    \ Set Y to just bits 0-2 of the y-coordinate, which will
 AND #%00000111         \ be the number of the pixel row we need to draw into
 TAY                    \ within the character block

 TXA                    \ Copy bits 0-1 of the x-coordinate to bits 0-1 of X,
 AND #%00000011         \ which will now be in the range 0-3, and will contain
 TAX                    \ the two pixels to show in the character row

 LDA P                  \ If the pixel's ZZ distance, which we stored in P, is
 BMI PX3                \ greater than 127, jump to PX3 to plot a 1-pixel dot

 CMP #80                \ If the pixel's ZZ distance is < 80, then the dot is
 BCC PX2                \ pretty close, so jump to PX2 to to draw a four-pixel
                        \ square

 LDA TWOS2,X            \ Fetch a mode 1 2-pixel byte with the pixels set as in
 AND S                  \ X, and AND with the colour byte we fetched into S
                        \ so that pixel takes on the colour we want to draw
                        \ (i.e. A is acting as a mask on the colour byte)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 LDY T1                 \ Set Y to the index of this pixel's y-coordinate byte
                        \ in the command block, which we stored in T1 above

 INY                    \ Increment Y, so it now points to the first byte of
                        \ the next pixel in the command block

 CPY Q                  \ If the index hasn't reached the value in Q (which
 BNE PXLO               \ contains the size of the pixel buffer), loop back to
                        \ PXLO to draw the next pixel in the buffer

 RTS                    \ Return from the subroutine

.PX2

                        \ If we get here, we need to plot a 4-pixel square in
                        \ in the correct colour for this pixel's distance

 LDA TWOS2,X            \ Fetch a mode 1 2-pixel byte with the pixels set as in
 AND S                  \ X, and AND with the colour byte we fetched into S
                        \ so that pixel takes on the colour we want to draw
                        \ (i.e. A is acting as a mask on the colour byte)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 DEY                    \ Reduce Y by 1 to point to the pixel row above the one
 BPL P%+4               \ we just plotted, and if it is still positive, skip the
                        \ next instruction

 LDY #1                 \ Reducing Y by 1 made it negative, which means Y was
                        \ 0 before we did the DEY above, so set Y to 1 to point
                        \ to the pixel row after the one we just plotted

                        \ We now draw our second dash

 LDA TWOS2,X            \ Fetch a mode 1 2-pixel byte with the pixels set as in
 AND S                  \ X, and AND with the colour byte we fetched into S
                        \ so that pixel takes on the colour we want to draw
                        \ (i.e. A is acting as a mask on the colour byte)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 LDY T1                 \ Set Y to the index of this pixel's y-coordinate byte
                        \ in the command block, which we stored in T1 above

 INY                    \ Increment Y, so it now points to the first byte of
                        \ the next pixel in the command block

 CPY Q                  \ If the index hasn't reached the value in Q (which
 BNE PXLO               \ contains the size of the pixel buffer), loop back to
                        \ PXLO to draw the next pixel in the buffer

 RTS                    \ Return from the subroutine

.PX3

                        \ If we get here, the dot is a long way away (at a
                        \ distance that is > 127), so we want to draw a 1-pixel
                        \ dot

 LDA TWOS,X             \ Fetch a mode 1 1-pixel byte with the pixel set as in
 AND S                  \ X, and AND with the colour byte we fetched into S
                        \ so that pixel takes on the colour we want to draw
                        \ (i.e. A is acting as a mask on the colour byte)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 LDY T1                 \ Set Y to the index of this pixel's y-coordinate byte
                        \ in the command block, which we stored in T1 above

 INY                    \ Increment Y, so it now points to the first byte of
                        \ the next pixel in the command block

 CPY Q                  \ If the index hasn't reached the value in Q (which
 BNE PXLO               \ contains the size of the pixel buffer), loop back to
                        \ PXLO to draw the next pixel in the buffer

 RTS                    \ Return from the subroutine

.PX5

                        \ If we get here then the pixel's distance value (ZZ) is
                        \ a multiple of 8, as set by the parasite's PIXEL
                        \ routine

 INY                    \ Increment Y to 3

 LDA (OSSC),Y           \ Set X to byte #3 from the Y-th pixel block in OSSC,
 TAX                    \ contains the pixel's x-coordinate

 INY                    \ Increment Y to 4

 LDA (OSSC),Y           \ Set Y to byte #4 from the Y-th pixel block in OSSC,
 STY T1                 \ which contains the pixel's y-coordinate, and store Y,
 TAY                    \ the index of this pixel's y-coordinate, in T1

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TXA                    \ Each character block contains 8 pixel rows, so to get
 AND #%11111100         \ the address of the first byte in the character block
 ASL A                  \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-1 and shift left to double
                        \ it (as each character row contains two pages of bytes,
                        \ or 512 bytes, which cover 256 pixels). This also
                        \ shifts bit 7 of the x-coordinate into the C flag

 STA SC                 \ Store the address of the character block in the low
                        \ byte of SC(1 0), so now SC(1 0) points to the
                        \ character block we need to draw into

 BCC P%+4               \ If the C flag is clear then skip the next instruction

 INC SC+1               \ The C flag is set, which means bit 7 of X1 was set
                        \ before the ASL above, so the x-coordinate is in the
                        \ right half of the screen (i.e. in the range 128-255).
                        \ Each row takes up two pages in memory, so the right
                        \ half is in the second page but SC+1 contains the value
                        \ we looked up from ylookup, which is the page number of
                        \ the first memory page for the row... so we need to
                        \ increment SC+1 to point to the correct page

 TYA                    \ Set Y to just bits 0-2 of the y-coordinate, which will
 AND #%00000111         \ be the number of the pixel row we need to draw into
 TAY                    \ within the character block

 TXA                    \ Copy bits 0-1 of the x-coordinate to bits 0-1 of X,
 AND #%00000011         \ which will now be in the range 0-3, and will contain
 TAX                    \ the two pixels to show in the character row

 LDA P                  \ Fetch the pixel's distance into P

 CMP #80                \ If the pixel's ZZ distance is >= 80, then the dot is
 BCS PX6                \ a medium distance away, so jump to PX6 to to draw a
                        \ single pixel

 LDA TWOS2,X            \ Fetch a mode 1 2-pixel byte with the pixels set as in
 AND #WHITE             \ X, and AND with #WHITE to make it white (i.e. cyan/red)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 DEY                    \ Reduce Y by 1 to point to the pixel row above the one
 BPL P%+4               \ we just plotted, and if it is still positive, skip the
                        \ next instruction

 LDY #1                 \ Reducing Y by 1 made it negative, which means Y was
                        \ 0 before we did the DEY above, so set Y to 1 to point
                        \ to the pixel row after the one we just plotted

                        \ We now draw our second dash

.PX6

 LDA TWOS2,X            \ Fetch a mode 1 2-pixel byte with the pixels set as in
 AND #WHITE             \ X, and AND with #WHITE to make it white (i.e. cyan/red)

 EOR (SC),Y             \ Draw the pixel on-screen using EOR logic, so we can
 STA (SC),Y             \ remove it later without ruining the background that's
                        \ already on-screen

 LDY T1                 \ Set Y to the index of this pixel's y-coordinate byte
                        \ in the command block, which we stored in T1 above

 INY                    \ Increment Y, so it now points to the first byte of
                        \ the next pixel in the command block

 CPY Q                  \ If the index has reached the value in Q (which
 BEQ P%+5               \ contains the size of the pixel buffer), skip the next
                        \ instruction

 JMP PXLO               \ We haven't reached the end of the buffer, so loop back
                        \ to PXLO to draw the next pixel in the buffer

 RTS                    \ Return from the subroutine

