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

 LDA #%11000000         \ Clear bit 4 of moonflower so the screen no longer
 STA moonflower         \ flickers between multicolour and standard mode, but
                        \ instead stays in standard mode

 LDA #0                 \ Set welcome to 0 to stop the background colour from
 STA welcome            \ flashing different colours (as 0 represents black, and
                        \ the energy bomb flashes between black and the colour
                        \ in welcome)

 RTS                    \ Return from the subroutine

