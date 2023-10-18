\ ******************************************************************************
\
\       Name: SetPaletteColours
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the view's palette from the entries in the XX3 palette table
\
\ ******************************************************************************

.SetPaletteColours

 LDA #&0F               \ Set hiddenColour to &0F, which is the HSV value for
 STA hiddenColour       \ black, so this hides any pixels that use the hidden
                        \ colour in palette 0

                        \ In the following we check the view type in QQ11a,
                        \ which contains the old view (if we are changing views)
                        \ or the current view (if we aren't changing views)
                        \
                        \ This ensures that we set the palette for the old view
                        \ so that it fades away correctly when changing views

 LDA QQ11a              \ If the old view type in QQ11a has bit 7 clear, then it
 BPL pale1              \ has a dashboard, so jump to pale1

 CMP #&C4               \ If the old view type in QQ11a is &C4 (Game Over
 BEQ pale1              \ screen), jump to pale1

 CMP #&98               \ If the old view type in QQ11a is &98 (Status Mode),
 BEQ pale2              \ jump to pale2

 LDA XX3+21             \ Set the palette to entries 21 to 23 from the XX3
 STA visibleColour      \ table, which contain the palette for the current
 LDA XX3+22             \ system (so this caters for the Data on System view)
 STA paletteColour2
 LDA XX3+23
 STA paletteColour3

 RTS                    \ Return from the subroutine

.pale1

                        \ If we get here then the view either has a dashboard or
                        \ it is the Game Over screen

 LDA XX3+3              \ Set the visible colour to entry 3 from the XX3 table,
 STA visibleColour      \ which is the visible colour for the space view and
                        \ Game Over screen

 RTS                    \ Return from the subroutine

.pale2

                        \ If we get here then the view is the Status Mode

 LDA XX3+1              \ Set the palette to entries 1 to 3 from the XX3 table,
 STA visibleColour      \ which contains the palette for the commander image (so
 LDA XX3+2              \ this caters for the Status Mode view)
 STA paletteColour2
 LDA XX3+3
 STA paletteColour3

 RTS                    \ Return from the subroutine

