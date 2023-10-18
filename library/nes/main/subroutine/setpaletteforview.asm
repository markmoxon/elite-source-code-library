\ ******************************************************************************
\
\       Name: SetPaletteForView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the correct background and sprite palettes for the current
\             view and (if this is the space view) the hidden bit plane
\
\ ******************************************************************************

.SetPaletteForView

 LDA QQ11a              \ Set A to the current view (or the old view that is
                        \ still being shown, if we are in the process of
                        \ changing view)

 BNE palv2              \ If this is not the space view, jump to palv2

                        \ If we get here then this is the space view

 LDY visibleColour      \ Set Y to the colour to use for visible pixels

 LDA hiddenBitplane     \ If hiddenBitplane is non-zero (i.e. 1), jump to palv1
 BNE palv1              \ to hide pixels in bitplane 1

                        \ If we get here then hiddenBitplane = 0, so now we hide
                        \ pixels in bitplane 0 and show pixels in bitplane 1

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA hiddenColour       \ Set A to the colour to use for hidden pixels

 STA PPU_DATA           \ Set palette 0 to the following:
 STY PPU_DATA           \
 STY PPU_DATA           \   * Colour 0 = background (black)
                        \
                        \   * Colour 1 = hidden colour (bitplane 0)
                        \
                        \   * Colour 2 = visible colour (bitplane 1)
                        \
                        \   * Colour 3 = visible colour
                        \
                        \ So pixels in bitplane 0 will be hidden, while
                        \ pixels in bitplane 1 will be visible
                        \
                        \ i.e. pixels in the hiddenBitplane will be hidden

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.palv1

                        \ If we get here then hiddenBitplane = 1, so now we hide
                        \ pixels in bitplane 1 and show pixels in bitplane 0

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA hiddenColour       \ Set A to the colour to use for hidden pixels

 STY PPU_DATA           \ Set palette 0 to the following:
 STA PPU_DATA           \
 STY PPU_DATA           \   * Colour 0 = background (black)
                        \
                        \   * Colour 1 = visible colour (bitplane 0)
                        \
                        \   * Colour 2 = hidden colour (bitplane 1)
                        \
                        \   * Colour 3 = visible colour
                        \
                        \ So pixels in bitplane 0 will be visible, while
                        \ pixels in bitplane 1 will be hidden
                        \
                        \ i.e. pixels in the hiddenBitplane will be hidden

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.palv2

                        \ If we get here then this is not the space view

 CMP #&98               \ If this is the Status Mode screen, jump to palv3
 BEQ palv3

                        \ If we get here then this is not the space view or the
                        \ Status Mode screen

 LDA #&3F               \ Set PPU_ADDR = &3F15, so it points to sprite palette 1
 STA PPU_ADDR           \ in the PPU
 LDA #&15
 STA PPU_ADDR

 LDA visibleColour      \ Set palette 0 to the following:
 STA PPU_DATA           \
 LDA paletteColour2     \   * Colour 0 = background (black)
 STA PPU_DATA           \
 LDA paletteColour3     \   * Colour 1 = visible colour
 STA PPU_DATA           \
                        \   * Colour 2 = paletteColour2
                        \
                        \   * Colour 3 = paletteColour3

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.palv3

                        \ If we get here then this is the Status Mode screen

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA visibleColour      \ Set palette 0 to the following:
 STA PPU_DATA           \
 LDA paletteColour2     \   * Colour 0 = background (black)
 STA PPU_DATA           \
 LDA paletteColour3     \   * Colour 1 = visible colour
 STA PPU_DATA           \
                        \   * Colour 2 = paletteColour2
                        \
                        \   * Colour 3 = paletteColour3

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

