\ ******************************************************************************
\
\       Name: DrawLaunchBox
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw a box as part of the launch tunnel animation
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   Half the width of the box
\
\   K+1                 Half the height of the box
\
\   K+2                 The x-coordinate of the centre of the box
\
\   K+3                 The y-coordinate of the centre of the box
\
\ ******************************************************************************

.lbox1

 RTS                    \ Return from the subroutine

.DrawLaunchBox

 LDA K+2                \ Set A = K+2 + K
 CLC                    \
 ADC K                  \ So A contains the x-coordinate of the right edge of
                        \ the box (i.e. the centre plus half the width)

 BCS lbox1              \ If the addition overflowed, then the right edge of the
                        \ box is past the right edge of the screen, so jump to
                        \ lbox1 to return from the subroutine without drawing
                        \ any lines

 STA X2                 \ Set X2 to A, to the x-coordinate of the right edge of
                        \ the box

 STA X1                 \ Set X1 to A, to the x-coordinate of the right edge of
                        \ the box

 LDA K+3                \ Set A = K+3 - K+1
 SEC                    \
 SBC K+1                \ So A contains the y-coordinate of the top edge of the
                        \ box (i.e. the centre minus half the height)

 BCS lbox2              \ If the subtraction underflowed, then the top edge of
                        \ the box is above the top edge of the screen, so jump
                        \ to lbox2 to skip the following

 LDA #0                 \ Set A = 0 to clip the result to the top of the space
                        \ view

.lbox2

 STA Y1                 \ Set Y1 to A, so (X1, Y1) is the coordinate of the
                        \ top-right corner of the box

 LDA K+3                \ Set A = K+3 + K+1
 CLC                    \
 ADC K+1                \ So A contains the y-coordinate of the bottom edge of
                        \ the box (i.e. the centre plus half the height)

 BCS lbox3              \ If the addition overflowed, then the y-coordinate is
                        \ off the bottom of the screen, so jump to lbox3 to skip
                        \ the following check (though this is slightly odd, as
                        \ this leaves A set to the y-coordinate of the bottom
                        \ edge, wrapped around with a MOD 256, which is unlikely
                        \ to be what we want, so should this be a jump to lbox1
                        \ to return from the subroutine instead?)

 CMP Yx2M1              \ If A < Yx2M1 then the y-coordinate is within the
 BCC lbox3              \ space view (as Yx2M1 is the y-coordinate of the bottom
                        \ pixel row of the space view), so jump to lbox3 to skip
                        \ the following instruction

 LDA Yx2M1              \ Set A = Yx2M1 to clip the result to the bottom of the
                        \ space view

.lbox3

 STA Y2                 \ Set Y2 to A, so (X1, Y2) is the coordinate of the
                        \ bottom-right corner of the box

                        \ By the time we get here, (X1, Y1) is the coordinate
                        \ of the top-right corner of the box, and (X1, Y2) is
                        \ the coordinate of the bottom-right corner of the box

 JSR DrawVerticalLine   \ Draw a vertical line from (X1, Y1) to (X1, Y2), to
                        \ draw the right edge of the box

 LDA K+2                \ Set A = K+2 - K
 SEC                    \
 SBC K                  \ So A contains the x-coordinate of the left edge of
                        \ the box (i.e. the centre minus half the width)

 BCC lbox1              \ If the subtraction underflowed, then the left edge of
                        \ the box is past the left edge of the screen, so jump
                        \ to lbox1 to return from the subroutine without drawing
                        \ any more lines

 STA X1                 \ Set X1 to A, to the x-coordinate of the left edge of
                        \ the box

                        \ By the time we get here, (X1, Y1) is the coordinate
                        \ of the top-left corner of the box, and (X1, Y2) is
                        \ the coordinate of the bottom-left corner of the box

 JSR DrawVerticalLine   \ Draw a vertical line from (X1, Y1) to (X1, Y2), to
                        \ draw the left edge of the box

                        \ We now move on to drawing the top and bottom edges

 INC X1                 \ Increment the x-coordinate in X1 so the top box edge
                        \ starts with the pixel to the right of the left edge

 LDY Y1                 \ Set Y to the y-coordinate in Y1, which is the
                        \ y-coordinate of the top edge of the box

 BEQ lbox4              \ If Y = 0 then skip the following, so we don't draw
                        \ the top edge if it's on the very top pixel line of
                        \ the screen

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ the top edge of the box

 INC X2                 \ The HLOIN routine decrements X2, so increment it back
                        \ to its original value

.lbox4

 DEC X1                 \ Decrement the x-coordinate in X1 so the bottom edge
                        \ starts at the same x-coordinate as the left edge

 INC X2                 \ Increment the x-coordinate in X1 so the bottom edge
                        \ ends with the pixel to the left of the right edge

 LDY Y2                 \ Set Y to the y-coordinate in Y2, which is the
                        \ y-coordinate of the bottom edge of the box

 CPY Yx2M1              \ If Y >= Yx2M1 then the y-coordinate is below the
 BCS lbox1              \ bottom of the space view (as Yx2M1 is the y-coordinate
                        \ of the bottom pixel row of the space view), so jump to
                        \ lbox1 to return from the subroutine without drawing
                        \ the bottom edge

 JMP HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ the bottom edge of the box, returning from the
                        \ subroutine using a tail call

