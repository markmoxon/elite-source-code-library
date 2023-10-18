\ ******************************************************************************
\
\       Name: GetViewPalettes
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Get the palette for the view type in QQ11a and store it in a table
\             at XX3
\
\ ******************************************************************************

.GetViewPalettes

 LDA QQ11a              \ Set X to the old view type in the low nibble of
 AND #%00001111         \ QQ11a
 TAX

 LDA #0                 \ Set SC+1 = 0, though this is superfluous as we do the
 STA SC+1               \ the same thing just below

 LDA paletteForView,X   \ Set A to the palette number to load for view X

 LDY #0                 \ Set SC+1 = 0 for use as the high byte in the address
 STY SC+1               \ we are about to construct

 ASL A                  \ Set (SC+1 A) = A * 32
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1

 ADC #LO(viewPalettes)  \ Set SC(1 0) = (SC+1 A) + viewPalettes
 STA SC                 \             = viewPalettes + 32 * A
 LDA #HI(viewPalettes)  \
 ADC SC+1               \ As each of the palettes in the viewPalettes table
 STA SC+1               \ consists of 32 bytes, this sets SC(1 0) to the address
                        \ of the A-th palette in the table, which is the palette
                        \ that corresponds to the view type in QQ11a that we
                        \ fetched above

 LDY #32                \ We now want to copy the 32 bytes from the selected
                        \ palette into the palette table at XX3, so set an index
                        \ counter in Y

.gpal1

 LDA (SC),Y             \ Copy the Y-th byte from SC(1 0) to the Y-th byte of
 STA XX3,Y              \ the table at XX3

 DEY                    \ Decrement the index counter

 BPL gpal1              \ Loop back until we have copied all 32 bytes to XX3

 LDA QQ11a              \ If the old view type in QQ11a is &00 (Space view with
 BEQ gpal3              \ no fonts loaded), jump to gpal3 to set the visible and
                        \ hidden colours

 CMP #&98               \ If the old view type in QQ11a is &98 (Status Mode),
 BEQ SetPaletteColours  \ jump to SetPaletteColours to set the view's palette
                        \ from the entries in the XX3 palette table, returning
                        \ from the subroutine using a tail call

 CMP #&96               \ If the old view type in QQ11a is not &96 (Data on
 BNE gpal2              \ System), jump to SetPaletteColours via gpal2 to set
                        \ the view's palette from the entries in the XX3 palette
                        \ table, returning from the subroutine using a tail call

                        \ This is the Data on System view, so we set the palette
                        \ according to the system's seeds

 LDA QQ15               \ Set A to the EOR of the s0_lo, s2_hi and s1_lo seeds
 EOR QQ15+5             \ for the current system, shifted right by two places
 EOR QQ15+2             \ and with bits 2 and 3 flipped
 LSR A                  \
 LSR A                  \ This gives us a number that varies between each system
 EOR #%00001100         \ that we can use to choose one of the eight system
                        \ palettes

 AND #%00011100         \ Restrict the result in A to multiples of 4 between 0
 TAX                    \ and 28 and set X to the result
                        \
                        \ We can now use X as an index into the systemPalettes
                        \ table, as there are eight palettes in the table, each
                        \ of which takes up four bytes

 LDA systemPalettes,X   \ Set the four bytes at XX3+20 to the palette entry from
 STA XX3+20             \ the systemPalettes table that corresponds to the
 LDA systemPalettes+1,X \ current system
 STA XX3+21
 LDA systemPalettes+2,X
 STA XX3+22
 LDA systemPalettes+3,X
 STA XX3+23

.gpal2

 JMP SetPaletteColours  \ Jump to SetPaletteColours to set the view's palette
                        \ from the entries in the XX3 palette table, returning
                        \ from the subroutine using a tail call

.gpal3

                        \ If we get here then the old view type in QQ11a is &00
                        \ (Space view with no fonts loaded), so we now set the
                        \ hidden and visible colours

 LDA XX3                \ Set A to the background colour in the first palette
                        \ entry (which will be black)

 LDY XX3+3              \ Set Y to the foreground colour in the last palette
                        \ entry (which will be cyan)

 LDA hiddenBitplane     \ If the hidden bitplane is 1, jump to gpal4
 BNE gpal4

 STA XX3+1              \ The hidden bitplane is 0, so set the second colour to
 STY XX3+2              \ black and the third colour to cyan, so:
                        \
                        \   * Colour %01 (1) is the hidden colour (black)
                        \
                        \   * Colour %10 (2) is the visible colour (cyan)

 RTS                    \ Return from the subroutine

.gpal4

 STY XX3+1              \ The hidden bitplane is 1, so set the second colour to
 STA XX3+2              \ cyan and the third colour to black
                        \
                        \   * Colour %01 (1) is the visible colour (cyan)
                        \
                        \   * Colour %10 (2) is the hidden colour (black)

 RTS                    \ Return from the subroutine

