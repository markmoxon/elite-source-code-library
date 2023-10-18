\ ******************************************************************************
\
\       Name: FadeColours
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Fade the screen colours towards black
\
\ ******************************************************************************

.FadeColours

                        \ We are about to go through 31 entries in the colour
                        \ palette at XX3, fading each colour in turn (and
                        \ ignoring the first entry, which is already black)

 LDX #31                \ Set an index counter in X

.fade1

 LDY XX3,X              \ Set Y to the X-th colour from the palette

 LDA fadeColours,Y      \ Fetch a faded version of colour Y from the fadeColours
 STA XX3,X              \ table and store it back in the same location in XX3

 DEX                    \ Decrement the counter in X

 BNE fade1              \ Loop back until we have faded all 31 colours

                        \ Fall through into SetPaletteColours to set the view's
                        \ palette to the now-faded colours from the XX3 table

