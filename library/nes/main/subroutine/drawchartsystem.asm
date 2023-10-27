\ ******************************************************************************
\
\       Name: DrawChartSystem
\       Type: Subroutine
\   Category: Charts
\    Summary: Draw system blobs on short-range chart
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K(1 0)              Radius of star (2, 3 or 4)
\
\   K3(1 0)             Pixel x-coordinate of system
\
\   K4(1 0)             Pixel y-coordinate of system
\
\ ******************************************************************************

.DrawChartSystem

 LDY systemsOnChart     \ Set Y to the number of this system on the chart

 CPY #24                \ If systemsOnChart >= 24 then we have already drawn the
 BCS csys1              \ maximum number of systems on the chart, so jump to
                        \ csys1 to return from the subroutine

 INY                    \ Otherwise increment systemsOnChart as we are about to
 STY systemsOnChart     \ draw a system on the chart

 TYA                    \ Set Y = Y * 4
 ASL A
 ASL A
 TAY

 LDA K3                 \ Set the x-coordinate of sprite 38 + Y to K3 - 2
 SBC #3                 \
 STA xSprite38,Y        \ The SBC #3 subtracts 2 because we know the C flag is
                        \ clear at this point
                        \
                        \ Y is 1 for the first system on the chart, so this sets
                        \ the x-coordinate of sprite 39 onwards, and we subtract
                        \ 2 because the star sprites have a margin of at least
                        \ two pixels along the left edge, so this aligns the
                        \ star part of the sprite to the x-coordinate

 LDA K4                 \ Set the y-coordinate of sprite 38 + Y to K4 + 10
 CLC                    \
 ADC #10+YPAL           \ This sets the y-coordinate of sprite 39 onwards, and
 STA ySprite38,Y        \ the 10 pixels are added to push the star sprite below
                        \ the level of the text label, so the star appears to
                        \ the bottom-left of the text

 LDA #213               \ Set the pattern to 213 + K
 CLC                    \
 ADC K                  \ The patterns for the three star sizes on the chart are
 STA tileSprite38,Y     \ in patterns 215 to 217, going from small to large, so
                        \ this sets the sprite to the correct star size in K as
                        \ K is in the range 2 to 4

 LDA #%00000010         \ Set the attributes for this sprite as follows:
 STA attrSprite38,Y     \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

.csys1

 RTS                    \ Return from the subroutine

