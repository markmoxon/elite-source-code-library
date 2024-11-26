\ ******************************************************************************
\
\       Name: BOMBOFF
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Switch off the energy bomb effect
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 0
\
\ ******************************************************************************

.BOMBOFF

 LDA #%11000000         \ Clear bit 4 of moonflower so the screen returns to
 STA moonflower         \ standard bitmap mode, so the space view goes back to
                        \ its normal monochrome, small-pixel appearance

 LDA #0                 \ Set welcome to 0 to stop the background colour from
 STA welcome            \ flashing different colours (as 0 represents black, and
                        \ the energy bomb flashes between black and the colour
                        \ in welcome)

 RTS                    \ Return from the subroutine

