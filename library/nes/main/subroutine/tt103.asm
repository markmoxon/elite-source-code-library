\ ******************************************************************************
\
\       Name: TT103
\       Type: Subroutine
\   Category: Charts
\    Summary: Draw a small set of crosshairs on a chart
\
\ ------------------------------------------------------------------------------
\
\ Draw a small set of crosshairs on a galactic chart at the coordinates in
\ (QQ9, QQ10).
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.TT103

 LDA QQ11               \ Fetch the current view type into A

 CMP #&9C               \ If the view type in QQ11 is &9C (Short-range Chart),
 BEQ TT105              \ jump to TT105 to draw the correct crosshairs for that
                        \ chart

                        \ We now set the pixel coordinates of the crosshairs in
                        \ QQ9 and QQ9+1 so they fit into the chart, with a
                        \ 31-pixel margin on the left and a 32-pixel margin at
                        \ the top, for the chart title
                        \
                        \ The Long-range Chart is twice as wide as it is high,
                        \ so we need to scale the y-coordinate in QQ19+1 by an
                        \ extra division by 2 when compared to the x-coordinate

 LDA QQ9                \ Set QQ19 = 31 + QQ9 - (QQ9 / 4)
 LSR A                  \          = 31 + 0.75 * QQ9
 LSR A                  \
 STA T1                 \ So this scales the x-coordinate from a range of 0 to
 LDA QQ9                \ 255 into a range from 31 to 222, so it fits nicely
 SEC                    \ into the Long-range Chart
 SBC T1
 CLC
 ADC #31
 STA QQ19

 LDA QQ10               \ Set QQ19+1 = 32 + (QQ10 - (QQ10 / 4)) / 2
 LSR A                  \            = 32 + 0.375 * QQ10
 LSR A                  \
 STA T1                 \ So this scales the y-coordinate from a range of 0 to
 LDA QQ10               \ 255 into a range from 8 to 127, so it fits nicely
 SEC                    \ into the Long-range Chart
 SBC T1
 LSR A
 CLC
 ADC #32
 STA QQ19+1

 LDA #4                 \ Set QQ19+2 to 4 denote crosshairs of size 4 (though
 STA QQ19+2             \ this is ignored by DrawCrosshairs, which always draws
                        \ the crosshairs as a single-tile square reticle)

 JMP DrawCrosshairs     \ Jump to TT15 to draw a square reticle at the
                        \ crosshairs coordinates, returning from the
                        \ subroutine using a tail call

