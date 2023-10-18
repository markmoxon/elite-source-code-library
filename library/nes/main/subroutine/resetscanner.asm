\ ******************************************************************************
\
\       Name: ResetScanner
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Reset the sprites used for drawing ships on the scanner
\
\ ******************************************************************************

.ResetScanner

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We start by clearing tile rows 29 to 31 in namespace
                        \ buffer 0, which are the three rows just below the
                        \ dashboard

 LDY #3*32              \ Set Y as a tile counter for three rows of 32 tiles

 LDA #0                 \ We are going to set the tiles to the background
                        \ pattern, so set A = 0 to use as the tile number

.rscn1

 STA nameBuffer0+29*32-1,Y      \ Clear the Y-th tile from the start of row 29
                                \ in namespace buffer 0

 DEY                    \ Decrement the tile counter in Y

 BNE rscn1              \ Loop back until we have cleared all three rows

 LDA #203               \ Set the tile pattern number for sprites 11 and 12 (the
 STA tileSprite11       \ pitch and roll indicators) to 203, which is the I-bar
 STA tileSprite12       \ pattern

 LDA #%00000011         \ Set the attributes for sprites 11 and 12 (the pitch
 STA attrSprite11       \ and roll indicators) as follows:
 STA attrSprite12       \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%00000000         \ Set the attributes for sprite 13 (the compass dot) as
 STA attrSprite13       \ follows:
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

                        \ We now reset the 24 sprites from sprite 14 to 37,
                        \ which are the sprites used to show ships on the
                        \ scanner

 LDX #24                \ Set a sprite counter in X so we reset 24 sprites

 LDY #56                \ Set Y = 56 so we start setting the attributes and tile
                        \ for sprite 56 / 4 = 14 onwards

.rscn2

 LDA #218               \ Set the tile pattern number for sprite Y / 4 to 218,
 STA tileSprite0,Y      \ which is the vertical bar used for drawing a ship's
                        \ stick on the scanner

 LDA #%00000000         \ Set the attributes for sprite Y / 4 as follows:
 STA attrSprite0,Y      \
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the sprite counter in X

 BNE rscn2              \ Loop back until we have reset all 24 sprites

 RTS                    \ Return from the subroutine

