\ ******************************************************************************
\
\       Name: DrawSmallLogo
\       Type: Subroutine
\   Category: Save and load
\    Summary: Set the sprite buffer entries for the small Elite logo on the Save
\             and Load screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   CNT                 Offset of the first free sprite block within the sprite
\                       buffer, which we can use for drawing the logo
\
\ ******************************************************************************

.DrawSmallLogo

 LDA #1                 \ Set XC = 1 so we draw the top-left corner of the logo
 STA XC                 \ at text column 1 (plus the pixel value in X that we
                        \ set below)

 ASL A                  \ Set YC = 1 so we draw the top-left corner of the logo
 STA YC                 \ on text row 2 (plus the pixel value in Y that we
                        \ set below)

 LDX #8                 \ Set K = 8 so we draw 8 tiles in each row
 STX K

 STX K+1                \ Set K+1 = 8 so we draw 8 rows in total

 LDX #6                 \ Set X = 6 so we draw the logo at a point 6 pixels
                        \ into text column 1 (i.e. on the sixth pixel along the
                        \ x-axis in the character block in column 1)

 LDY #6                 \ Set Y = 6 so we draw the logo at a point 6 pixels
                        \ into text row 2 (i.e. on the sixth pixel down the
                        \ y-axis in the character block in row 2)

 LDA #67                \ Set K+2 = 67 to use as the pattern number of the first
 STA K+2                \ pattern for the small logo

 LDA CNT                \ Set K+3 = CNT / 4, which we use below when rounding
 LSR A                  \ down the sprite buffer offset to a multiple of four
 LSR A
 STA K+3

 LDA #HI(smallLogoTile) \ Set V(1 0) = smallLogoTile so we draw the small
 STA V+1                \ Elite logo in the following
 LDA #LO(smallLogoTile)
 STA V

 LDA #%00000001         \ Set S to use as the attribute for each of the sprites
 STA S                  \ in the logo, so each sprite is set as follows:
                        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA XC                 \ Set SC = XC * 8 + X
 ASL A                  \        = XC * 8 + 6
 ASL A                  \
 ASL A                  \ So SC is the pixel x-coordinate of the top-left corner
 ADC #0                 \ of the logo we want to draw, as each text character in
 STA SC                 \ XC is 8 pixels wide and X contains the x-coordinate
 TXA                    \ within the character block
 ADC SC
 STA SC

 LDA YC                 \ Set SC+1 = YC * 8 + 6 + Y
 ASL A                  \          = YC * 8 + 6 + 6
 ASL A                  \
 ASL A                  \ So SC+1 is the pixel y-coordinate of the top-left
 ADC #6+YPAL            \ corner of the logo we want to draw, as each text row
 STA SC+1               \ in YC is 8 pixels high and Y contains the y-coordinate
 TYA                    \ within the character block
 ADC SC+1
 STA SC+1

 LDA K+3                \ Set X = K+3 * 4
 ASL A                  \       = CNT / 4 * 4
 ASL A                  \
 TAX                    \ So X contains the offset of the sprite's four-byte
                        \ block in the sprite buffer, as each sprite consists
                        \ of four bytes, so this is now the offset within the
                        \ sprite buffer of the first sprite we can use

 LDA K+1                \ Set T = K+1 to use as a counter for each row in the
 STA T                  \ logo

 LDY #0                 \ Set a tile counter in Y to increment as we draw each
                        \ tile, starting with Y = 0 for the first tile at the
                        \ start of the first row, and counting across and down

.drsm1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC                 \ Set SC2 to the pixel x-coordinate for the start of
 STA SC2                \ each row, so we can use it to move along the row as we
                        \ draw the logo

 LDA K                  \ Set ZZ to the number of tiles in each row of the logo
 STA ZZ                 \ (in K), so we can use it as a counter as we move along
                        \ the row

.drsm2

 LDA (V),Y              \ Fetch the tile pattern number for the Y-th tile in the
                        \ logo from the smallLogoTile table at V(1 0), which
                        \ gives us the pattern number for this tile from the
                        \ patterns in the smallLogoImage table, which is loaded
                        \ at the pattern number in K+2

 INY                    \ Increment the tile counter to point to the next tile

 BNE drsm3              \ If we just incremented Y past a page boundary and back
 INC V+1                \ to zero, increment the high byte of V(1 0) to point to
                        \ the next page

.drsm3

 CMP #0                 \ If the tile pattern number is zero, then this is the
 BEQ drsm4              \ background, so jump to drsm4 to move on to the next
                        \ tile in the logo

 ADC K+2                \ Set the tile pattern for sprite X to A + K+2, which is
 STA tileSprite0,X      \ the pattern number in the PPU's pattern table to use
                        \ for this part of the logo

 LDA S                  \ Set the attributes for sprite X to S, which we set
 STA attrSprite0,X      \ above as follows:
                        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA SC2                \ Set the x-coordinate for sprite X to SC2
 STA xSprite0,X

 LDA SC+1               \ Set the y-coordinate for sprite X to SC+1
 STA ySprite0,X

 TXA                    \ Add 4 to the sprite number in X, to move on to the
 CLC                    \ next sprite in the sprite buffer (as each sprite
 ADC #4                 \ consists of four bytes of data)

 BCS drsm5              \ If the addition overflowed, then we have reached the
                        \ end of the sprite buffer, so jump to drsm5 to return
                        \ from the subroutine, as we have run out of sprites

 TAX                    \ Otherwise set X to the offset of the next sprite in
                        \ the sprite buffer

.drsm4

 LDA SC2                \ Set SC2 = SC2 + 8
 CLC                    \
 ADC #8                 \ So SC2 contains the x-coordinate of the next tile
 STA SC2                \ along the row

 DEC ZZ                 \ Decrement the tile counter in ZZ as we have just drawn
                        \ a tile

 BNE drsm2              \ If ZZ is non-zero then we still have more tiles to
                        \ draw on the current row, so jump back to drsm2 to draw
                        \ the next one

 LDA SC+1               \ Otherwise we have reached the end of this row, so add
 ADC #8                 \ 8 to SC+1 to move the y-coordinate down to the next
 STA SC+1               \ tile row (as each tile row is 8 pixels high)

 DEC T                  \ Decrement the number of rows in T as we just finished
                        \ drawing a row

 BNE drsm1              \ Loop back to drsm1 until we have drawn all the rows in
                        \ the image

.drsm5

 RTS                    \ Return from the subroutine

