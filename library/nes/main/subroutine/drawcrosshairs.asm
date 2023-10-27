\ ******************************************************************************
\
\       Name: DrawCrosshairs
\       Type: Subroutine
\   Category: Charts
\    Summary: Draw a set of moveable crosshairs as a square reticle
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   QQ19                The pixel x-coordinate of the centre of the crosshairs
\
\   QQ19+1              The pixel y-coordinate of the centre of the crosshairs
\
\ ******************************************************************************

.DrawCrosshairs

 LDA #248               \ Set the pattern number for sprite 15 to 248, which
 STA tileSprite15       \ contains a one-tile square outline that we can use as
                        \ a square reticle to implement crosshairs on the chart

 LDA #%00000001         \ Set the attributes for sprite 15 as follows:
 STA attrSprite15       \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA QQ19               \ Set SC2 to the pixel x-coordinate of the centre of the
 STA SC2                \ crosshairs

 LDY QQ19+1             \ Set Y to the pixel y-coordinate of the centre of the
                        \ crosshairs

 LDA #15                \ Set X = 15 * 4, so X is the index of sprite 15 within
 ASL A                  \ the sprite buffer, as each sprite takes up four bytes
 ASL A                  \ (in other words, xSprite0 + X and ySprite0 + X are the
 TAX                    \ addresses of the x- and y-coordinates of sprite 15 in
                        \ the sprite buffer)

 LDA SC2                \ Set the pixel x-coordinate of sprite 15 to SC2 - 4
 SEC                    \
 SBC #4                 \ So the centre of the square reticle in sprite 15 is at
 STA xSprite0,X         \ x-coordinate SC2, as the reticle is eight pixels wide

 TYA                    \ Set the pixel y-coordinate of sprite 15 to Y + 10
 CLC                    \
 ADC #10+YPAL           \ So the reticle is drawn 10 pixels below the coordinate
 STA ySprite0,X         \ in the QQ19+1 argument (this takes the 14-pixel high
                        \ chart title into consideration, and ensures that the
                        \ centre of the reticle is over the correct coordinates
                        \ as the sprite is eight pixels high)

 RTS                    \ Return from the subroutine

