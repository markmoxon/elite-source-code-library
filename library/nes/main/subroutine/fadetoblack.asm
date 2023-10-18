\ ******************************************************************************
\
\       Name: FadeToBlack
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Fade the screen to black over the next four VBlanks
\
\ ******************************************************************************

.FadeToBlack

 LDA QQ11a              \ If the old view type in QQ11a is &FF (Segue screen
 CMP #&FF               \ from Title screen to Demo) then jump to ftob1 to skip
 BEQ ftob1              \ the fading process, as the screen is already faded

 LDA screenFadedToBlack \ If bit 7 of screenFadedToBlack is set then we have
 BMI ftob1              \ already faded the screen to black, so jump to ftob1 to
                        \ skip the fading process

                        \ If we get here then we want to fade the screen to
                        \ black

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR GetViewPalettes    \ Get the palette for the view type in QQ11a and store
                        \ it in a table at XX3

 DEC updatePaletteInNMI \ Decrement updatePaletteInNMI to a non-zero value so we
                        \ do send palette data from XX3 to the PPU during NMI,
                        \ which will ensure the screen updates with the colours
                        \ as we fade to black

 JSR FadeColours        \ Fade the screen colours one step towards black

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR FadeColours        \ Fade the screen colours a second step towards black

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR FadeColours        \ Fade the screen colours a third step towards black

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 JSR FadeColours        \ Fade the screen colours a fourth and final step
                        \ towards black, which is guaranteed to fade the screen
                        \ all the way to black as each colour only has four
                        \ brightness levels (stored as the value part of the
                        \ colour in bits 4 and 5)

 JSR WaitFor2NMIs       \ Wait until two NMI interrupts have passed (i.e. the
                        \ next two VBlanks)

 INC updatePaletteInNMI \ Increment updatePaletteInNMI back to the value it had
                        \ before we decremented it above

.ftob1

 LDA #&FF               \ Set bit 7 of screenFadedToBlack to indicate that we
 STA screenFadedToBlack \ have faded the screen to black

 RTS                    \ Return from the subroutine

