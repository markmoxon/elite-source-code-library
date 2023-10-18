\ ******************************************************************************
\
\       Name: DrawLightning
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw a lightning effect for the launch tunnel and E.C.M. that
\             consists of two random lightning bolts, one above the other
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   Half the width of the rectangle containing the lightning
\
\   K+1                 Half the height of the rectangle containing the
\                       lightning
\
\   K+2                 The x-coordinate of the centre of the lightning
\
\   K+3                 The y-coordinate of the centre of the lightning
\
\ ******************************************************************************

.DrawLightning

                        \ The rectangle is split into a top half and a bottom
                        \ half, with a bolt in the top half and a bolt in the
                        \ bottom half, and we draw each bolt in turn

 LDA K+1                \ Set XX2+1 = K+1 / 2
 LSR A                  \
 STA XX2+1              \ So XX2+1 contains a quarter of the height of the
                        \ rectangle containing the lightning

 LDA K+3                \ Set K3 = K+3 - XX2+1 + 1
 SEC                    \
 SBC XX2+1              \ So K3 contains the y-coordinate of the centre of the
 CLC                    \ top lightning bolt (i.e. the invisible horizontal line
 ADC #1                 \ through the centre of the top bolt)
 STA K3

 JSR lite1              \ Call lite1 below to draw the top lightning bolt along
                        \ a centre line at y-coordinate K+3

 LDA K+3                \ Set K3 = K+3 + XX2+1
 CLC                    \
 ADC XX2+1              \ So K3 contains the y-coordinate of the centre of the
 STA K3                 \ bottom lightning bolt (i.e. the invisible horizontal
                        \ line through the centre of the bottom bolt)

                        \ Fall through into lite1 to draw the second lightning
                        \ bolt along a centre line at y-coordinate K+3

.lite1

                        \ We now draw a lightning bolt along an invisible centre
                        \ line at y-coordinate K+3

 LDA K                  \ Set STP = K / 4
 LSR A                  \
 LSR A                  \ As K is the half-width of the rectangle containing the
 STA STP                \ lightning, this means STP is 1/8 of the width of the
                        \ lightning rectangle
                        \
                        \ We use this value to step along the rectangle from
                        \ left to right, so we can draw the lightning bolt in
                        \ eight equal-width segments

 LDA K+2                \ Set X1 = K+2 - K
 SEC                    \
 SBC K                  \ So X1 contains the x-coordinate of the left edge of
 STA X1                 \ the rectangle containing the lightning bolt

 LDA K3                 \ Set Y1 = K3
 STA Y1                 \
                        \ So Y1 contains the y-coordinate of the centre of the
                        \ lightning bolt, and (X1, Y1) therefore contains the
                        \ pixel coordinate of the left end of the lightning bolt

 LDY #7                 \ We now draw eight segments of lightning, zig-zagging
                        \ above and below the invisible centre line at
                        \ y-coordinate K3

.lite2

 JSR DORND              \ Set Q to a random number in the range 0 to 255
 STA Q

 LDA K+1                \ Set A to K+1, which is half the height of the
                        \ rectangle containing the lightning, which is the same
                        \ as the full height of the rectangle containing the
                        \ lightning bolt we are drawing

 JSR FMLTU              \ Set A = A * Q / 256
                        \       = K+1 * rand / 256
                        \
                        \ So A is a random number in the range 0 to the maximum
                        \ height of the lightning bolt we are drawing

 CLC                    \ Set Y2 = K3 + A - XX2+1
 ADC K3                 \
 SEC                    \ In the above, K3 is the y-coordinate of the centre of
 SBC XX2+1              \ the lightning bolt, XX2+1 contains half the height of
 STA Y2                 \ the lightning bolt, and A is a random number between 0
                        \ and the height of the lightning bolt, so this sets Y2
                        \ to a y-coordinate that is centred on the centre line
                        \ of the lightning bolt, and is a random distance above
                        \ or below the line, and which fits within the height of
                        \ the lightning bolt
                        \
                        \ We can therefore use this as the y-coordinate of the
                        \ next point along the zig-zag of the lightning bolt

 LDA X1                 \ Set X2 = X1 + STP
 CLC                    \
 ADC STP                \ So X2 is the x-coordinate of the next point along the
 STA X2                 \ lightning bolt, and (X2, Y2) is therefore the next
                        \ point along the lightning bolt

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2) to draw the next
                        \ segment of the bolt

 LDA SWAP               \ If SWAP is non-zero then we already swapped the line
 BNE lite3              \ coordinates around during the drawing process, so we
                        \ can jump to lite3 to skip the following coordinate
                        \ swap

 LDA X2                 \ Set (X1, Y1) to (X2, Y2), so (X1, Y1) contains the new
 STA X1                 \ end coordinates of the lightning bolt, now that we
 LDA Y2                 \ just drawn another segment of the bolt
 STA Y1

.lite3

 DEY                    \ Decrement the segment counter in Y

 BNE lite2              \ Loop back to draw the next segment until we have drawn
                        \ seven of them

                        \ We finish off by drawing the final segment, which we
                        \ draw from the current end of the zig-zag to the right
                        \ end of the invisible horizontal line through the
                        \ centre of the bolt, so the bolt starts and ends at
                        \ this height

 LDA K+2                \ Set X2 = K+2 + K
 CLC                    \
 ADC K                  \ So X2 contains the x-coordinate of the right edge of
 STA X2                 \ the rectangle containing the lightning

 LDA K3                 \ Set Y2 = K3
 STA Y2                 \
                        \ So Y2 contains the y-coordinate of the centre of the
                        \ lightning bolt, and (X2, Y2) therefore contains the
                        \ pixel coordinate of the right end of the lightning
                        \ bolt

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2) to draw the
                        \ final segment of the bolt

 RTS                    \ Return from the subroutine

