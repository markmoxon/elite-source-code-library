\ ******************************************************************************
\
\       Name: ResetScreen
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the screen by clearing down the PPU, setting all colours to
\             black, and resetting the screen-related variables
\
\ ******************************************************************************

.ResetScreen

 JSR WaitFor3xVBlank    \ Wait for three VBlanks to pass

 LDA #HI(20*32)         \ Set iconBarRow(1 0) = 20*32
 STA iconBarRow+1       \
 LDA #LO(20*32)         \ So the icon bar is on row 20
 STA iconBarRow

                        \ We now want to set all the colours in all the palettes
                        \ to black, to hide anything that's on-screen

 LDA #&3F               \ Set PPU_ADDR = &3F00, so it points to the background
 STA PPU_ADDR           \ colour palette entry in the PPU
 LDA #&00
 STA PPU_ADDR

 LDA #&0F               \ Set A to &0F, which is the HSV value for black

 LDX #31                \ There are 32 bytes in the background and sprite
                        \ palettes in the PPU, so set a loop counter in X to
                        \ count through them all

.rscr1

 STA PPU_DATA           \ Send A to the PPU to set palette entry X to black

 DEX                    \ Decrement the loop counter

 BPL rscr1              \ Loop back until we have set all the palette entries to
                        \ black

                        \ We now want to reset both PPU nametables to show blank
                        \ tiles (i.e. tile 0), so nothing is shown on-screen
                        \
                        \ The two nametables and associated attribute tables are
                        \ structured like this in the PPU:
                        \
                        \   * PPU_NAME_0 (&2000 to &23BF)
                        \   * PPU_ATTR_0 (&23C0 to &23FF)
                        \   * PPU_NAME_1 (&2400 to &27BF)
                        \   * PPU_ATTR_1 (&27C0 to &27FF)
                        \
                        \ Each nametable/attribute table consists of 1024 bytes
                        \ (i.e. four pages of 256 bytes), and because the tables
                        \ are consecutive in PPU memory, we can zero the whole
                        \ lot by sending eight pages of zeroes to the PPU,
                        \ tarting at the start of nametable 0 at PPU_NAME_0

 LDA #HI(PPU_NAME_0)    \ Set PPU_ADDR to PPU_NAME_0, so it points to nametable
 STA PPU_ADDR           \ 0 in the PPU
 LDA #LO(PPU_NAME_0)
 STA PPU_ADDR

 LDA #0                 \ Set A = 0 so we can send it to the PPU to fill both
                        \ PPU nametables with blank tiles

 LDX #8                 \ We want to zero 8 pages of 256 bytes, so set a page
                        \ counter in X

 LDY #0                 \ Set Y as a byte counter to count through each of the
                        \ 256 bytes in a page of memory

.rscr2

 STA PPU_DATA           \ Zero the next entry in the nametable

 DEY                    \ Decrement the byte counter

 BNE rscr2              \ Loop back until we have zeroed a whole page

 JSR WaitFor3xVBlank    \ Wait for three VBlanks to pass

 LDA #0                 \ Set A = 0 again, as it gets changed by WaitFor3xVBlank

 DEX                    \ Decrement the page counter

 BNE rscr2              \ Loop back until we have zeroed 8 pages of nametable in
                        \ the PPU

 LDA #245               \ Set screenReset = 245, though this is not used
 STA screenReset        \ anywhere, so this has no effect on anything

 STA imageSentToPPU     \ Set imageSentToPPU = 245 to denote that we have sent
                        \ the inventory icon image to the PPU

                        \ We now send patterns 0 to 4 to the PPU, to set up the
                        \ blank tile (pattern 0), the three box edges (patterns
                        \ 1 to 3) and the top-left corner of the icon bar
                        \ (pattern 4)
                        \
                        \ We do this for both pattern tables

 LDA #HI(PPU_PATT_0)    \ Set PPU_ADDR to PPU_PATT_0, so it points to pattern
 STA PPU_ADDR           \ table 0 in the PPU
 LDA #LO(PPU_PATT_0)
 STA PPU_ADDR

 LDY #0                 \ Set Y to use as an index counter as we work through
                        \ the boxEdgeImages table and send its data to the PPU

 LDX #80                \ The boxEdgeImages table contains five patterns with 16
                        \ bytes per pattern, so that's a total of 80 bytes to
                        \ send to the PPU, so set X as a byte counter

.rscr3

 LDA boxEdgeImages,Y    \ Send the Y-th entry from the boxEdgeImages table to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the index into the boxEdgeImages table to
                        \ point at the next byte

 DEX                    \ Decrement the byte counter

 BNE rscr3              \ Loop back until we have sent all 80 bytes to the PPU

 LDA #HI(PPU_PATT_1)    \ Set PPU_ADDR to PPU_PATT_1, so it points to pattern
 STA PPU_ADDR           \ table 1 in the PPU
 LDA #LO(PPU_PATT_1)
 STA PPU_ADDR

 LDY #0                 \ Set Y to use as an index counter as we work through
                        \ the boxEdgeImages table and send its data to the PPU

 LDX #80                \ The boxEdgeImages table contains five patterns with 16
                        \ bytes per pattern, so that's a total of 80 bytes to
                        \ send to the PPU, so set X as a byte counter

.rscr4

 LDA boxEdgeImages,Y    \ Send the Y-th entry from the boxEdgeImages table to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the index into the boxEdgeImages table to
                        \ point at the next byte

 DEX                    \ Decrement the byte counter

 BNE rscr4              \ Loop back until we have sent all 80 bytes to the PPU

                        \ We now reset the sprite buffer by setting all 64
                        \ sprites as follows:
                        \
                        \   * Set the coordinates to (0, 240), which is just
                        \     below the bottom of the screen, so the sprite is
                        \     hidden from view
                        \
                        \   * Set the pattern number to 254 (this value seems to
                        \     be arbitrary, but is possibly 254 so that sprite 0
                        \     keeps using pattern 254 throughout the reset)
                        \
                        \   * Set the attributes so the sprite uses palette 3,
                        \     is shown in front of the background, and is not
                        \     flipped in either direction

 LDY #0                 \ We are about to loop through the sprite buffer, so set
                        \ a byte index in Y

.rscr5

 LDA #240               \ Set the y-coordinate for this sprite to 240, to move
 STA ySprite0,Y         \ it off the bottom of the screen

 INY                    \ Increment Y to point to the second byte for this
                        \ sprite, i.e. tileSprite0,Y

 LDA #254               \ Set the pattern number for this sprite to 254
 STA ySprite0,Y

 INY                    \ Increment Y to point to the third byte for this
                        \ sprite, i.e. attrSprite0,Y

 LDA #%00000011         \ Set the attributes for this sprite as follows:
 STA ySprite0,Y         \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 INY                    \ Increment Y to point to the fourth byte for this
                        \ sprite, i.e. xSprite0,Y

 LDA #0                 \ Set the x-coordinate for this sprite to 0
 STA ySprite0,Y

 INY                    \ Increment Y to point to the first byte for the next
                        \ sprite
 BNE rscr5

 JSR SendDashImageToPPU \ Unpack the dashboard image and send it to patterns 69
                        \ to 255 in pattern table 0 in the PPU

                        \ We now set up sprite 0, which is used to detect when
                        \ the PPU starts drawing the icon bar, so this places
                        \ the sprite at the right side of the screen, just
                        \ above the icon bar, so when the PPU gets to this part
                        \ of the screen, it will set the sprite 0 collision flag
                        \ which we can then detect

 LDA #157+YPAL          \ Set sprite 0 as follows:
 STA ySprite0           \
 LDA #254               \   * Set the coordinates to (248, 157)
 STA tileSprite0        \
 LDA #248               \   * Set the pattern number to 254
 STA xSprite0           \
 LDA #%00100011         \   * Set the attributes as follows:
 STA attrSprite0        \
                        \     * Bits 0-1    = sprite palette 3
                        \     * Bit 5 set   = show behind background
                        \     * Bit 6 clear = do not flip horizontally
                        \     * Bit 7 clear = do not flip vertically

                        \ We now set sprites 1 to 4 so they contain the four
                        \ corners of the icon bar pointer:
                        \
                        \   * Sprite 1 = top-left corner
                        \   * Sprite 2 = top-right corner
                        \   * Sprite 3 = bottom-left corner
                        \   * Sprite 4 = bottom-right corner

 LDA #251               \ Set sprites 1 and 2 to use pattern 251
 STA tileSprite1
 STA tileSprite2

 LDA #253               \ Set sprites 3 and 4 to use pattern 253
 STA tileSprite3
 STA tileSprite4

 LDA #%00000011         \ Set the attributes for sprite 1 as follows:
 STA attrSprite1        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%01000011         \ Set the attributes for sprite 2 as follows:
 STA attrSprite2        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%01000011         \ Set the attributes for sprite 3 as follows:
 STA attrSprite3        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 set   = flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #%00000011         \ Set the attributes for sprite 4 as follows:
 STA attrSprite4        \
                        \   * Bits 0-1    = sprite palette 3
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 JSR WaitFor3xVBlank    \ Wait for three VBlanks to pass

 LDA #0                 \ Write 0 to OAM_ADDR so we can use OAM_DMA to send
 STA OAM_ADDR           \ sprite data to the PPU

 LDA #&02               \ Write &02 to OAM_DMA to upload 256 bytes of sprite
 STA OAM_DMA            \ data from the sprite buffer at &02xx into the PPU

 LDA #0                 \ Reset all the bitplanes to 0
 STA nmiBitplane
 STA drawingBitplane
 STA hiddenBitplane

 LDA #HI(PPU_PATT_1)    \ Set ppuPatternTableHi to the high byte of PPU pattern
 STA ppuPatternTableHi  \ table 1, which is the table we use for drawing dynamic
                        \ tiles

 LDA #0                 \ Set nmiBitplane8 to 8 * nmiBitplane, which is 0
 STA nmiBitplane8

 LDA #HI(PPU_NAME_0)    \ Set ppuNametableAddr(1 0) to the address of pattern
 STA ppuNametableAddr+1 \ table 0 in the PPU
 LDA #LO(PPU_NAME_0)
 STA ppuNametableAddr

 LDA #%00101000         \ Set both bitplane flags as follows:
 STA bitplaneFlags      \
 STA bitplaneFlags+1    \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 set   = clear buffers after sending data
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 set   = we have already sent all the data
                        \   * Bit 6 clear = only send pattern data to the PPU
                        \   * Bit 7 clear = do not send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ The NMI handler will now start sending data to the PPU
                        \ according to the above configuration, splitting the
                        \ process across multiple VBlanks if necessary

 LDA #4                 \ Set the number of the first and last tiles to send
 STA clearingPattern    \ from the PPU to 4, which is the first tile after the
 STA clearingPattern+1  \ blank tile (tile 0) and the box edges (tiles 1 to 3),
 STA clearingNameTile   \ which are the only fixed tiles in both bitplanes
 STA clearingNameTile+1 \
 STA sendingPattern     \ This ensures that both buffers are almost entirely
 STA sendingPattern+1   \ cleared out by the NMI, as we set bit 3 in the
 STA sendingNameTile    \ bitplane flags above
 STA sendingNameTile+1

 LDA #&0F               \ Set the hidden and visible colours to &0F, which is
 STA hiddenColour       \ the HSV value for black, and do the same for the
 STA visibleColour      \ colours to use for palette entries 2 and 3 in the
 STA paletteColour2     \ non-space views
 STA paletteColour3

 LDA #0                 \ Configure the NMI handler not to send palette data to
 STA updatePaletteInNMI \ the PPU

 STA QQ11a              \ Set the old view type in QQ11a to &00 (Space view with
                        \ no fonts loaded)

 LDA #&FF               \ Set bit 7 of screenFadedToBlack to indicate that we
 STA screenFadedToBlack \ have faded the screen to black

 JSR WaitFor3xVBlank    \ Wait for three VBlanks to pass

 LDA #%10010000         \ Set A to use as the new value for PPU_CTRL below

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy so we
                        \ can check its value without having to access the PPU

 STA PPU_CTRL           \ Configure the PPU by setting PPU_CTRL as follows:
                        \
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 set   = enable VBlank NMI generation

 RTS                    \ Return from the subroutine

