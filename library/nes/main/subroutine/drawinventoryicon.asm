\ ******************************************************************************
\
\       Name: DrawInventoryIcon
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw the inventory icon on top of the second button in the icon
\             bar
\
\ ******************************************************************************

.DrawInventoryIcon

                        \ We draw the inventory icon image from sprites with
                        \ sequential patterns, so first we configure the
                        \ variables to pass to the DrawSpriteImage routine

 LDA #2                 \ Set K = 2, to pass as the number of columns in the
 STA K                  \ image to DrawSpriteImage below

 STA K+1                \ Set K+1 = 2, to pass as the number of rows in the
                        \ image to DrawSpriteImage below

 LDA #69                \ Set K+2 = 69, so we draw the inventory icon image
 STA K+2                \ using pattern 69 onwards

 LDA #8                 \ Set K+3 = 8, so we build the image from sprite 8
 STA K+3                \ onwards

 LDA #3                 \ Set XC = 3 so we draw the image with the top-left
 STA XC                 \ corner in tile column 3

 LDA #25                \ Set YC = 25 so we draw the image with the top-left
 STA YC                 \ corner on tile row 25

 LDX #7                 \ Set X = 7 so we draw the image seven pixels into the
                        \ (XC, YC) character block along the x-axis

 LDY #7                 \ Set Y = 7 so we draw the image seven pixels into the
                        \ (XC, YC) character block along the y-axis

 JMP DrawSpriteImage_b6 \ Draw the inventory icon from sprites, using pattern
                        \ #69 onwards, returning from the subroutine using a
                        \ tail call

