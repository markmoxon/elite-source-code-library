\ ******************************************************************************
\
\       Name: DrawSpriteImage
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Draw an image out of sprites using patterns in sequential tiles in
\             the pattern buffer
\  Deep dive: Sprite usage in NES Elite
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
\   K+3                 Number of the first free sprite in the sprite buffer,
\                       where we can build the sprites to make up the image
\
\   XC                  The text column of the top-left corner of the image
\
\   YC                  The text row of the top-left corner of the image
\
\   X                   The pixel x-coordinate of the top-left corner of the
\                       image within the text block at (XC, YC)
\
\   Y                   The pixel y-coordinate of the top-left corner of the
\                       image within the text block at (XC, YC)
\
\ Other entry points:
\
\   DrawSpriteImage+2   Set the attributes for the sprites in the image to A
\
\ ******************************************************************************

.DrawSpriteImage

 LDA #%00000001         \ Set S to use as the attribute for each of the sprites
 STA S                  \ in the image, so each sprite is set as follows:
                        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA XC                 \ Set SC = XC * 8 + X
 ASL A                  \        = XC * 8 + 6
 ASL A                  \
 ASL A                  \ So SC is the pixel x-coordinate of the top-left corner
 ADC #0                 \ of the image we want to draw, as each text character
 STA SC                 \ in XC is 8 pixels wide and X contains the x-coordinate
 TXA                    \ within the character block
 ADC SC
 STA SC

 LDA YC                 \ Set SC+1 = YC * 8 + 6 + Y
 ASL A                  \          = YC * 8 + 6 + 6
 ASL A                  \
 ASL A                  \ So SC+1 is the pixel y-coordinate of the top-left
 ADC #6+YPAL            \ corner of the image we want to draw, as each text row
 STA SC+1               \ in YC is 8 pixels high and Y contains the y-coordinate
 TYA                    \ within the character block
 ADC SC+1
 STA SC+1

 LDA K+3                \ Set Y = K+3 * 4
 ASL A                  \
 ASL A                  \ So Y contains the offset of the first free sprite's
 TAY                    \ four-byte block in the sprite buffer, as each sprite
                        \ consists of four bytes, so this is now the offset
                        \ within the sprite buffer of the first sprite we can
                        \ use to build the sprite image

 LDA K+2                \ Set A to the pattern number of the first tile in K+2

 LDX K+1                \ Set T = K+1 to use as a counter for each row in the
 STX T                  \ image

.drsi1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX SC                 \ Set SC2 to the pixel x-coordinate for the start of
 STX SC2                \ each row, so we can use it to move along the row as we
                        \ draw the sprite image

 LDX K                  \ Set X to the number of tiles in each row of the image
                        \ (in K), so we can use it as a counter as we move along
                        \ the row

.drsi2

 LDA K+2                \ Set the pattern for sprite Y to K+2, which is the
 STA pattSprite0,Y      \ pattern number in the PPU's pattern table to use for
                        \ this part of the image

 LDA S                  \ Set the attributes for sprite Y to S, which we set
 STA attrSprite0,Y      \ above as follows:
                        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA SC2                \ Set the x-coordinate for sprite Y to SC2
 STA xSprite0,Y

 CLC                    \ Set SC2 = SC2 + 8
 ADC #8                 \
 STA SC2                \ So SC2 contains the x-coordinate of the next tile
                        \ along the row

 LDA SC+1               \ Set the y-coordinate for sprite Y to SC+1
 STA ySprite0,Y

 TYA                    \ Add 4 to the sprite number in Y, to move on to the
 CLC                    \ next sprite in the sprite buffer (as each sprite
 ADC #4                 \ consists of four bytes of data)

 BCS drsi3              \ If the addition overflowed, then we have reached the
                        \ end of the sprite buffer, so jump to drsi3 to return
                        \ from the subroutine, as we have run out of sprites

 TAY                    \ Otherwise set Y to the offset of the next sprite in
                        \ the sprite buffer

 INC K+2                \ Increment the tile counter in K+2 to point to the next
                        \ pattern

 DEX                    \ Decrement the tile counter in X as we have just drawn
                        \ a tile

 BNE drsi2              \ If X is non-zero then we still have more tiles to
                        \ draw on the current row, so jump back to drsi2 to draw
                        \ the next one

 LDA SC+1               \ Otherwise we have reached the end of this row, so add
 ADC #8                 \ 8 to SC+1 to move the y-coordinate down to the next
 STA SC+1               \ tile row (as each tile row is 8 pixels high)

 DEC T                  \ Decrement the number of rows in T as we just finished
                        \ drawing a row

 BNE drsi1              \ Loop back to drsi1 until we have drawn all the rows in
                        \ the image

.drsi3

 RTS                    \ Return from the subroutine

