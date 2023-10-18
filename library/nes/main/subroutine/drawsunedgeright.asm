\ ******************************************************************************
\
\       Name: DrawSunEdgeRight
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw a sun line in the tile on the right end of a sun row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The half-width of the sun line
\
\   Y                   The number of the pixel row of the sun line within the
\                       tile row (0-7)
\
\   X1                  The pixel x-coordinate of the rightmost tile on the sun
\                       line
\
\   YY(1 0)             The centre x-coordinate of the sun
\
\ ******************************************************************************

.DrawSunEdgeRight

 CLC                    \ Set X1 = YY(1 0) + A
 ADC YY                 \
 STA X2                 \ So X2 contains the x-coordinate of the right end of
 LDA YY+1               \ the sun line
 ADC #0

                        \ X1 is already set to the x-coordinate of the rightmost
                        \ tile, so the line we need to draw is from (X1, Y) to
                        \ (X2, Y)

 BEQ DrawSunEdge        \ If the high byte of the result is zero, then the right
                        \ end of the line is on-screen, so jump to DrawSunEdge
                        \ to draw the sun line from (X1, Y) to (X2, Y)

 BMI RTS7               \ If the high byte of the result is negative, then the
                        \ right end of the line is off the left edge of the
                        \ screen, so the line is not on-screen and we jump to
                        \ RTS7 to return from the subroutine (as RTS7 contains
                        \ an RTS)

                        \ If we get here then the right end of the line is past
                        \ the right edge of the screen, so we need to clip the
                        \ right end of the line to fit on-screen

 LDA #253               \ Set X2 = 253 so the line is clipped to the right edge
 STA X2                 \ of the screen

 CMP X1                 \ If X2 <= X1 then the right end of the line is to the
 BEQ RTS7               \ left of the left end of the line, so these are not
 BCC RTS7               \ valid line coordinates and we jump to RTS7 to return
                        \ from the subroutine without drawing anything

 JMP HLOIN              \ Otherwise draw the sun line from (X1, Y) to (X2, Y)
                        \ and return from the subroutine using a tail call

