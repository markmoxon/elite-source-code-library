\ ******************************************************************************
\
\       Name: SendPaletteSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Send the current palette and sprite data to the PPU
\
\ ******************************************************************************

.SendPaletteSprites

 STA nmiStoreA          \ Store the values of A, X and Y so we can retrieve them
 STX nmiStoreX          \ at the end of the NMI handler
 STY nmiStoreY

 LDA PPU_STATUS         \ Read from PPU_STATUS to clear bit 7 of PPU_STATUS and
                        \ reset the VBlank start flag

 INC nmiCounter         \ Increment the NMI counter so it increments every
                        \ VBlank

 LDA #0                 \ Write 0 to OAM_ADDR so we can use OAM_DMA to send
 STA OAM_ADDR           \ sprite data to the PPU

 LDA #&02               \ Write &02 to OAM_DMA to upload 256 bytes of sprite
 STA OAM_DMA            \ data from the sprite buffer at &02xx into the PPU

 LDA #%00000000         \ Configure the PPU by setting PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (not monochrome)
                        \   * Bit 1 clear = hide leftmost 8 pixels of background
                        \   * Bit 2 clear = hide sprites in leftmost 8 pixels
                        \   * Bit 3 clear = hide background
                        \   * Bit 4 clear = hide sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

                        \ Fall through into SetPaletteForView to set the correct
                        \ palette for the current view

