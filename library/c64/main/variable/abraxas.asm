\ ******************************************************************************
\
\       Name: abraxas
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The value for VIC register &18 to set the screen RAM address for a
\             raster count of 1 in the interrupt routine (i.e. the dashboard)
\  Deep dive: The split-screen mode in Commodore 64 Elite
\
\ ******************************************************************************

.abraxas

 EQUB &81               \ Determines the address of screen RAM to use for colour
                        \ data the lower portion of the screen, where the
                        \ dashboard lives in the space view:
                        \
                        \   * When abraxas is &81, the colour of the lower part
                        \     of the screen is determined by screen RAM at &6000
                        \     (i.e. when the dashboard is not being shown)
                        \
                        \   * When abraxas is &91, the colour of the lower part
                        \     of the screen is determined by screen RAM at &6400
                        \     (i.e. when the dashboard is being shown)

