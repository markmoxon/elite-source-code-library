\ ******************************************************************************
\
\       Name: DrawSunEdgeLeft
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw a sun line in the tile on the left end of a sun row
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
\   P                   The pixel x-coordinate of the start of the middle
\                       section of the sun line (i.e. the x-coordinate just to
\                       the right of the leftmost tile)
\
\   YY(1 0)             The centre x-coordinate of the sun
\
\ Other entry points:
\
\   RTS7                Contains an RTS
\
\   DrawSunEdge         Draw a sun line from (X1, Y) to (X2, Y)
\
\ ******************************************************************************

.DrawSunEdgeLeft

 LDX P                  \ Set X2 to P, which contains the x-coordinate just to
 STX X2                 \ the right of the leftmost tile
                        \
                        \ We can use this as the x-coordinate of the right end
                        \ of the line that we want to draw in the leftmost tile

 EOR #&FF               \ Use two's complement to set X1 = YY(1 0) - A
 SEC                    \
 ADC YY                 \ So X1 contains the x-coordinate of the left end of the
 STA X1                 \ sun line
 LDA YY+1
 ADC #&FF

 BEQ DrawSunEdge        \ If the high byte of the result is zero, then the left
                        \ end of the line is on-screen, so jump to DrawSunEdge
                        \ to draw the sun line from (X1, Y) to (X2, Y)

 BMI sunl1              \ If the high byte of the result is negative, then the
                        \ left end of the line is off the left edge of the
                        \ screen, so jump to sunl1 to draw a clipped sun line
                        \ from (0, Y) to (X2, Y)

                        \ Otherwise the line is off-screen, so return from the
                        \ subroutine without drawing anything

.RTS7

 RTS                    \ Return from the subroutine

.DrawSunEdge

 LDA X1                 \ If X1 >= X2 then the left end of the line is to the
 CMP X2                 \ right of the right end of the line, so these are not
 BCS RTS7               \ valid line coordinates and we jump to RTS7 to return
                        \ from the subroutine without drawing anything

 JMP HLOIN              \ Otherwise draw the sun line from (X1, Y) to (X2, Y)
                        \ and return from the subroutine using a tail call

.sunl1

                        \ If we get here then we need to clip the left end of
                        \ the line to fit on-screen

 LDA #0                 \ Draw a clipped the sun line from (0, Y) to (X2, Y)
 STA X1                 \ and return from the subroutine using a tail call
 JMP HLOIN

