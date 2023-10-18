\ ******************************************************************************
\
\       Name: DrawImageNames
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the nametable buffer entries for the specified image
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   The number of columns in the image (i.e. the number of
\                       tiles in each row of the image)
\
\   K+1                 The number of tile rows in the image
\
\   K+2                 The pattern number of the start of the image pattern
\                       data in the pattern table
\
\   V(1 0)              The address of the nametable entry table for the image
\
\   XC                  The text column of the top-left corner of the image
\
\   YC                  The text row of the top-left corner of the image
\
\ ******************************************************************************

.DrawImageNames

 LDA #32                \ Set ZZ = 32 - K
 SEC                    \
 SBC K                  \ As there are 32 nametable entries on each screen row,
 STA ZZ                 \ this gives us a number we can add to the address of
                        \ the nametable entry for the last tile on a row, to
                        \ give us the address of the nametable entry for the
                        \ first tile on the next row of the image

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDA SC                 \ Set SC(1 0) = SC(1 0) + XC
 CLC                    \
 ADC XC                 \ So SC(1 0) contains the address in nametable buffer 0
 STA SC                 \ of the text character at column XC on row YC, which is
                        \ where we want to draw the image

                        \ We now loop through the nametable entry table, copying
                        \ tile numbers from the table to the nametable buffers,
                        \ row by row

 LDY #0                 \ Set a tile counter in Y to increment as we draw each
                        \ tile, starting with Y = 0 for the first tile at the
                        \ start of the first row

.dimg1

 LDX K                  \ Set X to the number of tiles in each row of the image,
                        \ so we can use it as a column counter as we move along
                        \ each row

.dimg2

 LDA (V),Y              \ Fetch the Y-th byte from the nametable entry table for
                        \ the image we want to draw
                        \
                        \ This contains the pattern number for this tile, as an
                        \ offset from the start of the pattern data for this
                        \ image, which we already stored in the pattern buffer
                        \ at pattern number K+2
                        \
                        \ So the pattern number for this tile within the pattern
                        \ buffer will be A + K+2

 BEQ dimg3              \ If it is zero, then this is a background tile, so skip
                        \ the following two instructions to keep A as zero

 CLC                    \ Set A = A + K+2
 ADC K+2                \
                        \ So A contains the pattern number in the pattern
                        \ buffer, which is what we want to store in the
                        \ nametable buffer

.dimg3

 STA (SC),Y             \ Store the pattern number in the Y-th entry in the
                        \ nametable buffer

 INY                    \ Increment the tile number to move to the next tile

 BNE dimg4              \ If Y increments from 255 to zero, increment the high
 INC V+1                \ bytes of V(1 0) and SC(1 0) to point to the next page
 INC SC+1               \ in memory

.dimg4

 DEX                    \ Decrement the column counter for this row

 BNE dimg2              \ Loop back to dimg2 to draw the next tile, until we
                        \ have drawn all the tiles in this row

                        \ At this point SC(1 0) + Y is the address of the last
                        \ tile on the row we just drew, so adding ZZ to this
                        \ address (which we set to 32 - K above) updates
                        \ SC(1 0) + Y to the address of the first tile on the
                        \ next row in the image

 LDA SC                 \ Set SC(1 0) = SC(1 0) + ZZ
 CLC                    \
 ADC ZZ                 \ Starting with the low bytes
 STA SC

 BCC dimg5              \ And then the high bytes
 INC SC+1

.dimg5

 DEC K+1                \ Decrement the number of rows in K+1

 BNE dimg1              \ Loop back to dimg1 until we have drawn all the rows in
                        \ the image

 RTS                    \ Return from the subroutine

