\ ******************************************************************************
\
\       Name: SUN (Part 3 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Continue to move up the screen, drawing the new sun
\
\ ------------------------------------------------------------------------------
\
\ This part draws the new sun. By the time we get to this point, the following
\ variables should have been set up by parts 1 and 2:
\
\   V                   As we draw lines for the new sun, V contains the
\                       vertical distance between the line we're drawing and the
\                       centre of the new sun. As we draw lines and move up the
\                       screen, we either decrement (bottom half) or increment
\                       (top half) this value. See the deep dive on "Drawing the
\                       sun" to see a diagram that shows V in action
\
\   V+1                 This determines which half of the new sun we are drawing
\                       as we work our way up the screen, line by line:
\
\                         * 0 means we are drawing the bottom half, so the lines
\                           get wider as we work our way up towards the centre,
\                           at which point we will move into the top half, and
\                           V+1 will switch to &FF
\
\                         * &FF means we are drawing the top half, so the lines
\                           get smaller as we work our way up, away from the
\                           centre
\
\   TGT                 The maximum y-coordinate of the new sun on-screen (i.e.
\                       the screen y-coordinate of the bottom row of the new
\                       sun)
\
\   CNT                 The fringe size of the new sun
\
\   K2(1 0)             The new sun's radius squared, i.e. K^2
\
\   Y                   The y-coordinate of the bottom row of the new sun
\
\ ******************************************************************************

.PLFL

 LDA V                  \ Set (T P) = V * V
 JSR SQUA2              \           = V^2
 STA T

 LDA K2                 \ Set (R Q) = K^2 - V^2
 SEC                    \
 SBC P                  \ First calculating the low bytes
 STA Q

 LDA K2+1               \ And then doing the high bytes
 SBC T
 STA R

 STY Y1                 \ Store Y in Y1, so we can restore it after the call to
                        \ LL5

 JSR LL5                \ Set Q = SQRT(R Q)
                        \       = SQRT(K^2 - V^2)
                        \
                        \ So Q contains the half-width of the new sun's line at
                        \ height V from the sun's centre - in other words, it
                        \ contains the half-width of the sun's line on the
                        \ current pixel row Y

 LDY Y1                 \ Restore Y from Y1

 JSR DORND              \ Set A and X to random numbers

 AND CNT                \ Reduce A to a random number in the range 0 to CNT,
                        \ where CNT is the fringe size of the new sun

 CLC                    \ Set A = A + Q
 ADC Q                  \
                        \ So A now contains the half-width of the sun on row
                        \ V, plus a random variation based on the fringe size

 BCC PLF44              \ If the above addition did not overflow, skip the
                        \ following instruction

 LDA #255               \ The above overflowed, so set the value of A to 255

                        \ So A contains the half-width of the new sun on pixel
                        \ line Y, changed by a random amount within the size of
                        \ the sun's fringe

.PLF44

 LDX LSO,Y              \ Set X to the line heap value for the old sun's line
                        \ at row Y

 STA LSO,Y              \ Store the half-width of the new row Y line in the line
                        \ heap

 BEQ PLF11              \ If X = 0 then there was no sun line on pixel row Y, so
                        \ jump to PLF11

 LDA SUNX               \ Set YY(1 0) = SUNX(1 0), the x-coordinate of the
 STA YY                 \ vertical centre axis of the old sun that's currently
 LDA SUNX+1             \ on-screen
 STA YY+1

 TXA                    \ Transfer the line heap value for the old sun's line
                        \ from X into A

 JSR EDGES              \ Call EDGES to calculate X1 and X2 for the horizontal
                        \ line centred on YY(1 0) and with half-width A, i.e.
                        \ the line for the old sun

 LDA X1                 \ Store X1 and X2, the ends of the line for the old sun,
 STA XX                 \ in XX and XX+1
 LDA X2
 STA XX+1

 LDA K3                 \ Set YY(1 0) = K3(1 0), the x-coordinate of the centre
 STA YY                 \ of the new sun
 LDA K3+1
 STA YY+1

 LDA LSO,Y              \ Fetch the half-width of the new row Y line from the
                        \ line heap (which we stored above)

 JSR EDGES              \ Call EDGES to calculate X1 and X2 for the horizontal
                        \ line centred on YY(1 0) and with half-width A, i.e.
                        \ the line for the new sun

 BCS PLF23              \ If the C flag is set, the new line doesn't fit on the
                        \ screen, so jump to PLF23 to just draw the old line
                        \ without drawing the new one

                        \ At this point the old line is from XX to XX+1 and the
                        \ new line is from X1 to X2, and both fit on-screen. We
                        \ now want to remove the old line and draw the new one.
                        \ We could do this by simply drawing the old one then
                        \ drawing the new one, but instead Elite does this by
                        \ drawing first from X1 to XX and then from X2 to XX+1,
                        \ which you can see in action by looking at all the
                        \ permutations below of the four points on the line and
                        \ imagining what happens if you draw from X1 to XX and
                        \ X2 to XX+1 using EOR logic. The six possible
                        \ permutations are as follows, along with the result of
                        \ drawing X1 to XX and then X2 to XX+1:
                        \
                        \   X1    X2    XX____XX+1      ->      +__+  +  +
                        \
                        \   X1    XX____X2____XX+1      ->      +__+__+  +
                        \
                        \   X1    XX____XX+1  X2        ->      +__+__+__+
                        \
                        \   XX____X1____XX+1  X2        ->      +  +__+__+
                        \
                        \   XX____XX+1  X1    X2        ->      +  +  +__+
                        \
                        \   XX____X1____X2____XX+1      ->      +  +__+  +
                        \
                        \ They all end up with a line between X1 and Y1, which
                        \ is what we want. There's probably a mathematical proof
                        \ of why this works somewhere, but the above is probably
                        \ easier to follow.
                        \
                        \ We can draw from X1 to XX and X2 to XX+1 by swapping
                        \ XX and X2 and drawing from X1 to X2, and then drawing
                        \ from XX to XX+1, so let's do this now

 LDA X2                 \ Swap XX and X2
 LDX XX
 STX X2
 STA XX

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1)

.PLF23

                        \ If we jump here from the BCS above when there is no
                        \ new line this will just draw the old line

 LDA XX                 \ Set X1 = XX
 STA X1

 LDA XX+1               \ Set X2 = XX+1
 STA X2

.PLF16

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1)

.PLF6

 DEY                    \ Decrement the line number in Y to move to the line
                        \ above

 BEQ PLF8               \ If we have reached the top of the screen, jump to PLF8
                        \ as we are done drawing (the top line of the screen is
                        \ the border, so we don't draw there)

 LDA V+1                \ If V+1 is non-zero then we are doing the top half of
 BNE PLF10              \ the new sun, so jump down to PLF10 to increment V and
                        \ decrease the width of the line we draw

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BNE PLFL               \ If V is non-zero, jump back up to PLFL to do the next
                        \ screen line up

 DEC V+1                \ Otherwise V is 0 and we have reached the centre of the
                        \ sun, so decrement V+1 to -1 so we start incrementing V
                        \ each time, thus doing the top half of the new sun

.PLFLS

 JMP PLFL               \ Jump back up to PLFL to do the next screen line up

.PLF11

                        \ If we get here then there is no old sun line on this
                        \ line, so we can just draw the new sun's line. The new

 LDX K3                 \ Set YY(1 0) = K3(1 0), the x-coordinate of the centre
 STX YY                 \ of the new sun's line
 LDX K3+1
 STX YY+1

 JSR EDGES              \ Call EDGES to calculate X1 and X2 for the horizontal
                        \ line centred on YY(1 0) and with half-width A, i.e.
                        \ the line for the new sun

 BCC PLF16              \ If the line is on-screen, jump up to PLF16 to draw the
                        \ line and loop round for the next line up

 LDA #0                 \ The line is not on-screen, so set the line heap for
 STA LSO,Y              \ line Y to 0, which means there is no sun line here

 BEQ PLF6               \ Jump up to PLF6 to loop round for the next line up
                        \ (this BEQ is effectively a JMP as A is always zero)

.PLF10

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get narrower, as
 STX V                  \ we move up and away from the sun's centre

 CPX K                  \ If V <= the radius of the sun, we still have lines to
 BCC PLFLS              \ draw, so jump up to PLFL (via PLFLS) to do the next
 BEQ PLFLS              \ screen line up

