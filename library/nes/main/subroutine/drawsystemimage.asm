\ ******************************************************************************
\
\       Name: DrawSystemImage
\       Type: Subroutine
\   Category: Universe
\    Summary: Draw the system image as a coloured foreground in front of a
\             greyscale background
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of columns in the image (i.e. the number of
\                       tiles in each row of the image)
\
\   Y                   The number of tile rows in the image
\
\ ******************************************************************************

.DrawSystemImage

                        \ The system image is made up of two layers:
                        \
                        \   * A greyscale background that's displayed using the
                        \     nametable tiles, whose patterns are extracted into
                        \     the pattern buffers by the GetSystemBack routine
                        \
                        \   * A colourful foreground that's displayed as a set
                        \     of sprites, whose patterns are sent to the PPU
                        \     by the GetSystemImage routine, from pattern 69
                        \     onwards
                        \
                        \ We start by drawing the background into the nametable
                        \ buffers

 STX K                  \ Set K = X, so we can pass the number of columns in the
                        \ image to DrawBackground and DrawSpriteImage below

 STY K+1                \ Set K+1 = Y, so we can pass the number of rows in the
                        \ image to DrawBackground and DrawSpriteImage below

 LDA firstFreePattern   \ Set picturePattern to the number of the next free
 STA picturePattern     \ pattern in firstFreePattern
                        \
                        \ We use this when setting K+2 below, so the call to
                        \ DrawBackground displays the patterns at
                        \ picturePattern, and it's also used to specify where
                        \ to load the system image data when we call
                        \ GetSystemImage from SendViewToPPU when showing the
                        \ Data on System screen

 CLC                    \ Add 56 to firstFreePattern, as we are going to use 56
 ADC #56                \ patterns for the system image (7 rows of 8 tiles)
 STA firstFreePattern

 LDA picturePattern     \ Set K+2 to the value we stored above, so K+2 is the
 STA K+2                \ number of the first pattern to use for the system
                        \ image's greyscale background

 JSR DrawBackground_b3  \ Draw the background by writing the nametable buffer
                        \ entries for the greyscale part of the system image
                        \ (this is the image that is extracted into the pattern
                        \ buffers by the GetSystemBack routine)

                        \ Now that the background is drawn, we move on to the
                        \ sprite-based foreground
                        \
                        \ We draw the foreground image from sprites with
                        \ sequential patterns, so now we configure the variables
                        \ to pass to the DrawSpriteImage routine

 LDA #69                \ Set K+2 = 69, so we draw the system image using
 STA K+2                \ pattern 69 onwards

 LDA #8                 \ Set K+3 = 8, so we build the image from sprite 8
 STA K+3                \ onwards

 LDX #0                 \ Set X and Y to zero, so we draw the system image at
 LDY #0                 \ (XC, YC), without any indents

 JSR DrawSpriteImage_b6 \ Draw the system image from sprites, using pattern 69
                        \ onwards

                        \ We now draw a frame around the system image we just
                        \ drew, so we set up the variables so the DrawImageFrame
                        \ can do just that

 DEC XC                 \ We just drew the image at (XC, YC), so decrement them
 DEC YC                 \ both so we can pass (XC, YC) to the DrawImageFrame
                        \ routine to draw a frame around the image, with the
                        \ top-left corner one block up and left from the image
                        \ corner

 INC K                  \ Increment the number of columns in K to pass to the
                        \ DrawImageFrame routine, so we draw a frame that's the
                        \ correct width (DrawImageFrame expects K to be the
                        \ frame width minus 1)

 INC K+1                \ Increment K+1 twice so the DrawImageFrame will draw a
 INC K+1                \ frame that is the height of the image, plus two rows
                        \ for the top and bottom of the frame

                        \ Fall through into DrawImageFrame to draw a frame
                        \ around the system image

