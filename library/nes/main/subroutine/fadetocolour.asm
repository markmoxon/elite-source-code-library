\ ******************************************************************************
\
\       Name: FadeToColour
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Reverse-fade the screen from black to full colour over the next
\             four VBlanks
\
\ ******************************************************************************

.FadeToColour

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 JSR FadeColoursTwice   \ Fade the screen colours two steps towards black

 JSR FadeColours        \ Fade the screen colours a third step towards black, so
                        \ the palette in XX3 is now one step brighter than full
                        \ black (as it takes four steps to fully black-out the
                        \ normal palette)

 DEC updatePaletteInNMI \ Decrement updatePaletteInNMI to a non-zero value so we
                        \ do send palette data from XX3 to the PPU during NMI,
                        \ which will ensure the screen updates with the colours
                        \ as we reverse the back to full colour

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 JSR FadeColoursTwice   \ Fade the screen colours two steps towards black, so
                        \ the palette in XX3 is now two steps brighter than full
                        \ black

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 JSR FadeColours        \ Fade the screen colours one step towards black, so the
                        \ palette in XX3 is now three steps brighter than full
                        \ black

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 JSR SetPaletteColours  \ Set the view's palette from the entries in the XX3
                        \ palette table, so the screen is now at full brightness
                        \ once again

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 INC updatePaletteInNMI \ Increment updatePaletteInNMI back to the value it had
                        \ before we decremented it above

 LSR screenFadedToBlack \ Clear bit 7 of screenFadedToBlack to indicate that the
                        \ screen has faded back up to full colour

 RTS                    \ Return from the subroutine

