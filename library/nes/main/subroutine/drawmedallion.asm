\ ******************************************************************************
\
\       Name: DrawMedallion
\       Type: Subroutine
\   Category: Status
\    Summary: Draw a medallion on the commander image
\
\ ******************************************************************************

.DrawMedallion

                        \ We draw the medallion image from sprites with
                        \ sequential patterns, so first we configure the
                        \ variables to pass to the DrawSpriteImage routine

 LDA #3                 \ Set K = 5, to pass as the number of columns in the
 STA K                  \ image to DrawSpriteImage below

 LDA #2                 \ Set K+1 = 2, to pass as the number of rows in the
 STA K+1                \ image to DrawSpriteImage below

 LDA #111               \ Set K+2 = 111, so we draw the medallion using pattern
 STA K+2                \ #111 onwards

 LDA #15                \ Set K+3 = 15, so we build the image from sprite 15
 STA K+3                \ onwards

 LDX #11                \ Set X = 11 so we draw the image 11 pixels into the
                        \ (XC, YC) character block along the x-axis

 LDY #49                \ Set Y = 49 so we draw the image 49 pixels into the
                        \ (XC, YC) character block along the y-axis

 LDA #%00000010         \ Set the attributes for the sprites we create in the
                        \ DrawSpriteImage routine as follows:
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 JMP DrawSpriteImage+2  \ Draw the medallion image from sprites, using pattern
                        \ #111 onwards and the sprite attributes in A

