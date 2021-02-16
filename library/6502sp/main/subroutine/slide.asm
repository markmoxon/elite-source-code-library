\ ******************************************************************************
\
\       Name: SLIDE
\       Type: Subroutine
\   Category: Demo
\    Summary: Display a Star Wars scroll text
\
\ ------------------------------------------------------------------------------
\
\ The first step is to write the scroll text onto a 2D canvas, laid out like
\ this, starting with the first words in the top-left, as you would expect when
\ writing on a piece of paper:
\
\   (0, 254)              (256, 254)
\           +------------+
\           |            |      ^
\           | On-screen  |      |
\           |            |      |  scroll direction
\           |............|      |
\    ^      :            :
\    |      :            :
\   BALI    : Off-screen :
\    |      :            :
\    V      :            :
\           +------------+
\     (0, 0)              (256, 0)
\
\ Note that the y-axis is in the same direction as in the 3D space view, so the
\ (0, 0) origin is in the bottom left, and y-coordinates get larger as you move
\ up the canvas (and x increases towards the right, as you would expect).
\
\ BALI is a counter that goes from 254 to 2, and can be thought of as the
\ y-coordinate of our eyes as we read through the scroll text from top to
\ bottom, or, alternatively, how much of the canvas has yet to appear on-screen
\ as the canvas scrolls into view.
\
\ Now take a point (X1, Y1) in the 2D scroll text canvas, like this:
\
\             X1
\           <--->
\
\           +------------+
\           |            |
\           |    x       |
\           |            |      ^       ^
\           |            |      |       |
\           |            |      |       | Y1 - BALI
\           |            |      |       |
\           |............|      |       v
\    ^      :            :      |
\    |      :            :      | Y1
\   BALI    : Off-screen :      |
\    |      :            :      |
\    |      :            :      |
\    v      +------------+      v
\
\ If Y1 < BALI, the point is off the bottom of the screen, so let's assume that
\ Y1 >= BALI. This means that the value of Y1 - BALI is 0 for points at the
\ bottom of the visible section, and higher for points near the top.
\
\ We can project the point (X1, Y1) onto the Star Wars perspective scroll text
\ to get a 3D space coordinate (x, y, z) like this:
\
\   x = (x_sign x_hi x_lo) = X1 - 128
\
\   y = (y_sign y_hi y_lo) = (Y1 - BALI) - 128
\
\   z = (z_sign z_hi z_lo) = ((Y1 - BALI) * 4 div 256) + #D
\
\ The x calculation moves the point (X1, Y1) to the left so the scroll text is
\ in the centre, right in front of the camera (i.e. it shifts the x-coordinate
\ range from 0-255 to -128 to +127).
\
\ The y calculation moves the point (X1, Y1) down so that points at the bottom
\ of the visible part of the canvas (those just appearing) will be at a space
\ y-coordinate of -128, so the scroll text appears to come in from just below
\ the bottom of the screen.
\
\ The z calculation tips the top of the 2D canvas away from the viewer by giving
\ points higher up the canvas (i.e. those with higher y-coordinates) a higher
\ z-coordinate, so the top of the canvas is further away (as the z-coordinate is
\ into the screen). The #D configuration variable is the z-distance of the
\ bottom of the visible part of the canvas as it scrolls into view. The scroll
\ text appears as a disappearing flat canvas because the z-coordinate is in a
\ linear relationship with the y-coordinate (i.e. z = ky + d where k and d are
\ constants).
\
\ We then project this space coordinate onto the screen for drawing, using the
\ same process as when we draw ships. Couple this with a couple of tables for
\ storing the projected lines so they can be erased again, then we can scroll
\ the text in a Star Wars style by simply counting BALI from 254 down to 2,
\ reprojecting the canvas and redrawing the scroll text with each new value.
\
\ Arguments:
\
\   (Y X)               The contents of the scroll text to display
\
\ ******************************************************************************

.SLIDE

 JSR GRIDSET            \ Call GRIDSET to populate the line coordinate tables at
                        \ X1TB, Y1TB, X2TB and Y2TB (the TB tables) with the
                        \ lines for the scroll text in (Y X)

                        \ The following section does the following:
                        \
                        \   * Clear the VB tables (X1VB, Y1VB, X2VB and Y2VB)
                        \
                        \   * Call GRID with values of BALI dropping by 2 each
                        \     time, from 254 to 252 to 250 ... to 6 to 4 to 2,
                        \     to display the scroll text moving up the screen
                        \     and into the distance
                        \
                        \   * Clear the VB tables
                        \
                        \   * Call GRID with BALI = 2 to erase the final set of
                        \     lines from the screen

 JSR ZEVB               \ Call ZEVB to zero-fill the Y1VB variable, which
                        \ effectively clears all the VB tables as we only check
                        \ the Y1VB table for zero values

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is yellow

 LDA #254               \ Set BALI = 254 to act as a counter from 254 to 2,
 STA BALI               \ decreasing by 2 each iteration, which represents the
                        \ scrolling of the Star Wars scroll text up the screen
                        \ and into the distance

.SLL2

 JSR GRID               \ Call GRID to draw the Star Wars scroll text at the
                        \ scroll position in BALI

 DEC BALI               \ Set BALI = BALI - 2 to move the scroll text up the
 DEC BALI               \ screen and into the distance

 BNE SLL2               \ Loop back to SLL2 until the loop counter is 0 (so GRID
                        \ was last called with BALI = 2)

.SL1

 JSR ZEVB               \ Call ZEVB to zero-fill the Y1VB variable, which
                        \ effectively clears all the VB tables as we only check
                        \ the Y1VB table for zero values

 LDA #2                 \ Set BALI = 2 and fall into GRID below to redraw the
 STA BALI               \ last set of scroll text, which erases it from the
                        \ screen

.GRID

                        \ The GRID routine draws the Star Wars scroll text, with
                        \ the value in BALI determining the scroll position of
                        \ the perspective view, starting from 254 (not yet
                        \ on-screen) and going down to 2 (the scroll has almost
                        \ faded into the distance)
                        \
                        \ The routine loops through the lines we just put in the
                        \ TB tables, projects them into a Star Wars-like
                        \ perspective scroll view in 3D space, then projects
                        \ them onto the 2D screen, saving the resulting screen
                        \ coordinates into the VB table. It then calls the
                        \ GRIDEX routine to erase the lines from the previous
                        \ call to GRID, and draw the new ones

 LDY #0                 \ Set Y = 0, to act as an index into the TB tables,
                        \ where we put the line coordinates above

 STY UPO                \ Set UPO = 0, to act as an index into the UB tables

 STY INWK+8             \ Set z_sign = 0

 STY INWK+1             \ Set x_hi = 0

 STY INWK+4             \ Set y_hi = 0

 DEY                    \ Decrement Y to 255, so the following loop starts with
                        \ Y pointing to the first byte from the TB tables

.GRIDL

 INY                    \ Increment Y to point to the next pair of line
                        \ coordinates in the TB tables

                        \ We now fetch the line's start point as 3D space
                        \ coordinates, project it onto the Star Wars perspective
                        \ scroll text, and project it again onto the 2D screen

 STZ INWK+7             \ Set z_hi = 0

 LDA Y1TB,Y             \ Set A to the y-coordinate of the line's start point,
                        \ let's call it Y1

 BNE P%+5               \ If A = 0, jump to GREX to draw the projected lines
 JMP GREX               \ as we have now processed all of them

 SEC                    \ Set A = A - BALI
 SBC BALI               \       = Y1 - BALI

 BCC GRIDL              \ If Y1 < BALI, jump back to GRIDL to process the next
                        \ line, as this one is not yet on-screen

 STA R                  \ Set R = Y1 - BALI

 ASL A                  \ Shift bits 6-7 of A into bits 0-1 of z_hi, so the C
 ROL INWK+7             \ flag is clear (as we set z_hi to 0 above) and z_hi is
 ASL A                  \ the high byte if A * 4 = (Y1 - BALI) * 4 is expressed
 ROL INWK+7             \ as a 16-bit value, i.e. ((Y1 - BALI) * 4) div 256

 ADC #D                 \ Set (z_hi z_lo) = (z_hi z_lo) + #D
 STA INWK+6             \
                        \ first adding the low bytes

 LDA INWK+7             \ And then adding the high bytes, so we now have:
 ADC #0                 \
 STA INWK+7             \   (z_hi z_lo) = ((Y1 - BALI) * 4 div 256) + #D
                        \
                        \ so because we set z_sign to 0 above, we have:
                        \
                        \   (z_sign z_hi z_lo) = ((Y1 - BALI) * 4 div 256) + #D

 STZ S                  \ Set S = 0

 LDA #%10000000         \ Set A to a negative sign byte

 STA P                  \ Set P = 128

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = -128 + (0 R)
                        \           = -128 + R
                        \           = -128 + (Y1 - BALI)
                        \           = Y1 - BALI - 128

 STA INWK+5             \ Set (y_sign y_lo) = (A X)
 STX INWK+3             \                   = Y1 - BALI - 128
                        \
                        \ so because we set y_hi to 0 above, we have:
                        \
                        \   (y_sign y_hi y_lo) = Y1 - BALI - 128

 LDA X1TB,Y             \ Set A to the x-coordinate of the line's start point,
                        \ let's call it X1. A is in the range 0 to 255, and we
                        \ now need to move the coordinate to the left so it's in
                        \ the range -128 to +128, but we need to put the result
                        \ into (x_sign x_hi x_lo) which is a sign-magnitude
                        \ number, so we can't just subtract 128, as that would
                        \ give us a two's complement number

 EOR #%10000000         \ Flip the sign bit of A

 BPL GR2                \ If bit 7 is now clear, meaning it was previously set,
                        \ then jump to GR2 as the original A was in the range
                        \ 128 to 255, and we now have the correct result for
                        \ A = A - 128, which is also |A - 128| as A was positive

                        \ Otherwise bit 7 was previously clear, so A was in the
                        \ range 0 to 127 and the EOR has shifted that up to 128
                        \ to 255, so we need to negate the number so that 128
                        \ becomes 0, 129 becomes 1 and so on

 EOR #%11111111         \ Negate the result in A by flipping all the bits and
 INA                    \ adding 1, i.e. using two's complement to negate it to
                        \ set A to the magnitude part of the sign-magnitude
                        \ number A - 128, i.e. |A - 128|

.GR2

 STA INWK               \ Set x_lo = |A - 128|
                        \          = |X1 - 128|

 LDA X1TB,Y             \ Set x_sign to the opposite of bit 7 in X1, so it will
 EOR #%10000000         \ be positive if X1 > 127 and negative if X1 <= 127, so
 AND #%10000000         \ x_sign has the correct sign for X1 - 128:
 STA INWK+2             \
                        \   (x_sign x_lo) = X1 - 128
                        \
                        \ and because we set x_hi to 0 above, we have:
                        \
                        \   (x_sign x_hi x_lo) = X1 - 128

 STY YS                 \ Store Y, the index into the TB tables, in YS

 JSR PROJ               \ Project the line's start coordinate onto the screen,
                        \ returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate

 LDY YS                 \ Retrieve the value of Y from YS, so it once again
                        \ contains the index into the TB tables

 LDA K3                 \ Set XX15(1 0) = K3(1 0)
 STA XX15
 LDA K3+1
 STA XX15+1

 LDA K4                 \ Set XX15(3 2) = K4(1 0)
 STA XX15+2
 LDA K4+1
 STA XX15+3

                        \ We now fetch the line's end point as 3D space
                        \ coordinates, project it onto the Star Wars perspective
                        \ scroll text, and project it again onto the 2D screen

 STZ INWK+7             \ Set x_hi = 0

 LDA Y2TB,Y             \ Set A to Y2, the end point's y-coordinate from Y1TB

 SEC
 SBC BALI
 BCC GR6

 STA R
 ASL A
 ROL INWK+7
 ASL A
 ROL INWK+7
 ADC #D
 STA INWK+6
 LDA INWK+7
 ADC #0
 STA INWK+7
 STZ S
 LDA #%10000000
 STA P

 JSR ADD                \ Set (A X) = (A P) + (S R)

 STA INWK+5
 STX INWK+3

 LDA X2TB,Y
 EOR #%10000000
 BPL GR3
 EOR #%11111111
 INA

.GR3

 STA INWK
 LDA X2TB,Y
 EOR #%10000000
 AND #%10000000
 STA INWK+2

 JSR PROJ               \ Project the line's end coordinate onto the screen,
                        \ returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate

 LDA K3                 \ Set XX15(5 4) = K3(1 0)
 STA XX15+4
 LDA K3+1
 STA XX15+5

 LDA K4                 \ Set XX12(1 0) = K4(1 0)
 STA XX12
 LDA K4+1
 STA XX12+1

                        \ We now have our line, projected onto the Star Wars
                        \ perspective scroll text and then onto the screen, so
                        \ we can clip it and store it in the UB tables for
                        \ drawing later, once we have processed all the lines in
                        \ the scroll text in the same way

 JSR LL145              \ Call LL145 to see if the new line segment needs to be
                        \ clipped to fit on-screen, returning the clipped line's
                        \ end-points in (X1, Y1) and (X2, Y2)

 LDY YS                 \ Retrieve the value of Y from YS, so it once again
                        \ contains the index into the TB tables

 BCS GR6                \ If the C flag is set then the line is not visible on
                        \ screen, so loop back to GRIDL via GR6 to process the
                        \ next line to draw in the scroll text

 INC UPO                \ Increment the table pointer in UPO to point to the
                        \ next free slot in the UB tables

 LDX UPO                \ Load the UPO table pointer into X

 LDA X1                 \ Store the line coordinates (X1, Y1) and (X2, Y2) in
 STA X1UB,X             \ the next free slot in the UB tables
 LDA Y1
 STA Y1UB,X
 LDA X2
 STA X2UB,X
 LDA Y2
 STA Y2UB,X

.GR6

 JMP GRIDL              \ Loop back to GRIDL to process the next line to draw
                        \ in the scroll text

.GREX

                        \ If we get here then it's time to draw the lines we
                        \ just projected, and remove any lines that are already
                        \ on-screen
                        \
                        \ The VB table holds the new lines to draw, while UB
                        \ holds all their previous coordinates, i.e. the current
                        \ lines on-screen, so drawing the VB lines draws the
                        \ lines in their new positions, while drawing the UB
                        \ lines erases the old lines from the screen

 LDY UPO                \ Set Y to the the UPO table pointer, which contains the
                        \ number of coordinates in the X1UB, Y1UB, X2UB and Y2UB
                        \ tables (i.e. the number of lines we projected)

 BEQ GREX2              \ If UPO = 0 then there are no projected lines to draw,
                        \ so jump to GREX2 to return from the subroutine

                        \ We now loop through the projected lines, using Y as a
                        \ loop counter that doubles as an index into the line
                        \ coordinate tables
                        \
                        \ First we draw the Y-th line from the VB table, if
                        \ there is one, and then we draw the Y-th line from the
                        \ UB table, before copying the Y-th VB line coordinates
                        \ into the UB table (so the UB table contains the lines
                        \ that are now on-screen)

.GRL2

 LDA Y1VB,Y             \ If there is no Y-th line in the VB table, jump to GR4
 BEQ GR4

 STA Y1                 \ Otherwise copy the Y-th line's coordinates from the VB
 LDA X1VB,Y             \ table into (X1, Y1) and (X2, Y2)
 STA X1
 LDA X2VB,Y
 STA X2
 LDA Y2VB,Y
 STA Y2

 JSR LOIN               \ Draw the line from (X1, Y1) to (X2, Y2)

.GR4

 LDA X1UB,Y             \ Copy the Y-th line's coordinates from the UB table
 STA X1                 \ into both the VB table and into (X1, Y1) and (X2, Y2)
 STA X1VB,Y

 LDA Y1UB,Y
 STA Y1
 STA Y1VB,Y

 LDA X2UB,Y
 STA X2
 STA X2VB,Y

 LDA Y2UB,Y
 STA Y2
 STA Y2VB,Y

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 DEY
 BNE GRL2
 JSR LBFL

.GREX2

 RTS                    \ Return from the subroutine

