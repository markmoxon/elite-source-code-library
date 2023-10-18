
\ ******************************************************************************
\
\       Name: SUN (Part 2 of 2)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Starting from the bottom of the sun, draw the new
\             sun line by line
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases the old sun, starting at the bottom of the screen and working
\ upwards until we reach the bottom of the new sun.
\
\ ******************************************************************************

 LDA K3                 \ Set YY(1 0) to the pixel x-coordinate of the centre
 STA YY                 \ of the new sun, from K3(1 0)
 LDA K3+1
 STA YY+1

 LDY TGT                \ Set Y to the maximum y-coordinate of the sun on the
                        \ screen (i.e. the bottom of the sun), which we set up
                        \ in part 1

 LDA #0                 \ Set the sub width variables to zero, so we can use
 STA sunWidth1          \ them below to store the widths of the sun on each
 STA sunWidth2          \ pixel row within each tile row
 STA sunWidth3
 STA sunWidth4
 STA sunWidth5
 STA sunWidth6
 STA sunWidth7

 TYA                    \ Set A to the maximum y-coordinate of the sun, so we
                        \ can apply the first AND below

 TAX                    \ Set X to the maximum y-coordinate of the sun, so we
                        \ can apply the second AND below

 AND #%11111000         \ Each tile row contains 8 pixel rows, so to get the
 TAY                    \ y-coordinate of the first row of pixels in the tile
                        \ row, we clear bits 0-2, so Y now contains the pixel
                        \ y-coordinate of the top pixel row in the tile row
                        \ containing the bottom of the sun

 LDA V+1                \ If V+1 is non-zero then we are doing the top half of
 BNE dsun11             \ the new sun, so jump down to dsun11 to work our way
                        \ upwards from the centre towards the top of the sun

                        \ If we get here then we are drawing the bottom half of
                        \ of the sun, so we work our way up from the bottom by
                        \ decrementing V for each pixel line, as V contains the
                        \ vertical distance between the line we're drawing and
                        \ the centre of the new sun, and it starts out pointing
                        \ to the bottom of the sun

 TXA                    \ Set A = X mod 8, which is the pixel row within the
 AND #7                 \ tile row of the bottom of the sun

 BEQ dsun8              \ If A = 0 then the bottom of the sun is only in the top
                        \ pixel row of the tile row, so jump to dsun8 to
                        \ calculate the sun's width on one pixel row

 CMP #2                 \ If A = 1, jump to dsun7 to calculate the sun's width
 BCC dsun7              \ on two pixel rows

 BEQ dsun6              \ If A = 2, jump to dsun6 to calculate the sun's width
                        \ on three pixel rows

 CMP #4                 \ If A = 3, jump to dsun5 to calculate the sun's width
 BCC dsun5              \ on four pixel rows

 BEQ dsun4              \ If A = 4, jump to dsun4 to calculate the sun's width
                        \ on five pixel rows

 CMP #6                 \ If A = 5, jump to dsun3 to calculate the sun's width
 BCC dsun3              \ on six pixel rows

 BEQ dsun2              \ If A = 6, jump to dsun2 to calculate the sun's width
                        \ on seven pixel rows

                        \ If we get here then A = 7, so keep going to calculate
                        \ the sun's width on all eight pixel rows, starting from
                        \ row 7 at the bottom of the tile row, all the way up to
                        \ pixel row 0 at the top of the tile row

.dsun1

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth7          \ Store the half-width of pixel row 7 in sunWidth7

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun12             \ If V is zero then we have reached the centre, so jump
                        \ to dsun12 to start working our way up from the centre,
                        \ incrementing V instead

.dsun2

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth6          \ Store the half-width of pixel row 6 in sunWidth6

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun13             \ If V is zero then we have reached the centre, so jump
                        \ to dsun13 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun3

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth5          \ Store the half-width of pixel row 5 in sunWidth5

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun14             \ If V is zero then we have reached the centre, so jump
                        \ to dsun14 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun4

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth4          \ Store the half-width of pixel row 4 in sunWidth4

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun15             \ If V is zero then we have reached the centre, so jump
                        \ to dsun15 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun5

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth3          \ Store the half-width of pixel row 3 in sunWidth3

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun16             \ If V is zero then we have reached the centre, so jump
                        \ to dsun16 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun6

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth2          \ Store the half-width of pixel row 2 in sunWidth2

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun17             \ If V is zero then we have reached the centre, so jump
                        \ to dsun17 to start working our way up from the centre,
                        \ incrementing V for the rest of this tile row

.dsun7

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth1          \ Store the half-width of pixel row 1 in sunWidth1

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun10             \ If V is zero then we have reached the centre, so jump
                        \ to dsun18 via dsun10 to start working our way up from
                        \ the centre, incrementing V for the rest of this tile
                        \ row

.dsun8

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth0          \ Store the half-width of pixel row 0 in sunWidth0

 DEC V                  \ Decrement V, the height of the sun that we use to work
                        \ out the width, so this makes the line get wider, as we
                        \ move up towards the sun's centre

 BEQ dsun9              \ If V is zero then we have reached the centre, so jump
                        \ to dsun19 via dsun9 to start working our way up from
                        \ the centre, incrementing V for the rest of this tile
                        \ row

 JSR dsun28             \ Call dsun28 to draw all eight lines for this tile row

 TYA                    \ Set Y = Y - 8 to move up a tile row
 SEC
 SBC #8
 TAY

 BCS dsun1              \ If the subtraction didn't underflow, then Y is still
                        \ positive and is therefore still on-screen, so loop
                        \ back to dsun1 to keep drawing pixel rows

 RTS                    \ Otherwise we have reached the top of the screen, so
                        \ return from the subroutine as we are done drawing

.dsun9

 BEQ dsun19             \ Jump down to dsun19 (this is only used to enable us to
                        \ use a BEQ dsun9 above)

.dsun10

 BEQ dsun18             \ Jump down to dsun18 (this is only used to enable us to
                        \ use a BEQ dsun10 above)

.dsun11

                        \ If we get here then we are drawing the top half of the
                        \ sun, so we increment V for each pixel line as we move
                        \ up the screen

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth7          \ Store the half-width of pixel row 7 in sunWidth7

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun21             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun21 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun12

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth6          \ Store the half-width of pixel row 6 in sunWidth6

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun22             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun22 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun13

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth5          \ Store the half-width of pixel row 5 in sunWidth5

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun23             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun23 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun14

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth4          \ Store the half-width of pixel row 4 in sunWidth4

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun24             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun24 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun15

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth3          \ Store the half-width of pixel row 3 in sunWidth3

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun25             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun25 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun16

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth2          \ Store the half-width of pixel row 2 in sunWidth2

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun26             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun26 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun17

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth1          \ Store the half-width of pixel row 1 in sunWidth1

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun27             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun27 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun18

 JSR PLFL               \ Call PLFL to set A to the half-width of the new sun on
                        \ the sun line given in V

 STA sunWidth0          \ Store the half-width of pixel row 0 in sunWidth0

 LDX V                  \ Increment V, the height of the sun that we use to work
 INX                    \ out the width, so this makes the line get less wide,
 STX V                  \ as we move up and away from the sun's centre

 CPX K                  \ If V >= K then we have reached the top of the sun (as
 BCS dsun28             \ K is the sun's radius, so there are K pixel lines in
                        \ each half of the sun), so jump to dsun28 to draw the
                        \ lines that we have calculated so far for this tile row

.dsun19

 JSR dsun28             \ Call dsun28 to draw all eight lines for this tile row

 TYA                    \ Set Y = Y - 8 to move up a tile row
 SEC
 SBC #8
 TAY

 BCC dsun20             \ If the subtraction underflowed, then Y is negative
                        \ and is therefore off the top of the screen, so jump to
                        \ dsun20 to return from the subroutine

 JMP dsun11             \ Otherwise we still have work to do, so jump up to
                        \ dsun11 to keep working our way up the top half of the
                        \ sun

.dsun20

 RTS                    \ Return from the subroutine

.dsun21

                        \ If we jump here then we have reached the top of the
                        \ sun and only need to draw pixel row 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth6

 LDA #0                 \ Zero sunWidth6
 STA sunWidth6

.dsun22

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 6 and 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth5

 LDA #0                 \ Zero sunWidth5
 STA sunWidth5

.dsun23

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 5 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth4

 LDA #0                 \ Zero sunWidth4
 STA sunWidth4

.dsun24

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 4 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth3

 LDA #0                 \ Zero sunWidth3
 STA sunWidth3

.dsun25

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 3 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth2

 LDA #0                 \ Zero sunWidth2
 STA sunWidth2

.dsun26

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 2 to 7 in the current
                        \ tile row, so we zero sunWidth0 through sunWidth1

 LDA #0                 \ Zero sunWidth1
 STA sunWidth1

.dsun27

                        \ If we jump here then we have reached the top of the
                        \ sun and need to draw pixel rows 1 to 7 in the current
                        \ tile row, so we zero sunWidth0

 LDA #0                 \ Zero sunWidth0
 STA sunWidth0

                        \ So by this point sunWidth0 through sunWidth7 are set
                        \ up with the correct widths that we need to draw on
                        \ each pixel row of the current tile row, with some of
                        \ them possibly set to zero

                        \ We now fall through into dsun28 to draw these eight
                        \ pixel rows and return from the subroutine

.dsun28

                        \ If we jump here with a branch instruction or fall
                        \ through from above, then we have reached the top of
                        \ the sun and need to draw pixel rows 0 to 7 in the
                        \ current tile row, and then we are done drawing
                        \
                        \ If we call this code as a subroutine using JSR dsun28
                        \ then we need to draw pixel rows 0 to 7 in the current
                        \ tile row, and when we return from the call we keep
                        \ drawing rows
                        \
                        \ In either case, we now need to draw all eight rows
                        \ before returning from the subroutine
                        \
                        \ We start by finding the smallest width out of
                        \ sunWidth0 through sunWidth7

 LDA sunWidth0          \ Set A to sunWidth0 as our starting point

 CMP sunWidth1          \ If A >= sunWidth1 then set A = sunWidth1, so this sets
 BCC dsun29             \ A = min(A, sunWidth1)
 LDA sunWidth1

.dsun29

 CMP sunWidth2          \ If A >= sunWidth2 then set A = sunWidth2, so this sets
 BCC dsun30             \ A = min(A, sunWidth2)
 LDA sunWidth2

.dsun30

 CMP sunWidth3          \ If A >= sunWidth3 then set A = sunWidth3, so this sets
 BCC dsun31             \ A = min(A, sunWidth3)
 LDA sunWidth2

.dsun31

 CMP sunWidth4          \ If A >= sunWidth4 then set A = sunWidth4, so this sets
 BCC dsun32             \ A = min(A, sunWidth4)
 LDA sunWidth4

.dsun32

 CMP sunWidth5          \ If A >= sunWidth5 then set A = sunWidth5, so this sets
 BCC dsun33             \ A = min(A, sunWidth5)
 LDA sunWidth5

.dsun33

 CMP sunWidth6          \ If A >= sunWidth6 then set A = sunWidth6, so this sets
 BCC dsun34             \ A = min(A, sunWidth6)
 LDA sunWidth6

.dsun34

 CMP sunWidth7          \ If A >= sunWidth7 then set A = sunWidth7, so this sets
 BCC dsun35             \ A = min(A, sunWidth7)
 LDA sunWidth7

                        \ So by this point A = min(sunWidth0 to sunWidth7), and
                        \ we can now check to see if we can save time by drawing
                        \ a portion of this tile row out of filled blocks

 BEQ dsun37             \ If A = 0 then at least one of the pixel rows needs to
                        \ be left blank, so we can't draw the row using filled
                        \ blocks, so jump to dsun37 to draw the tile row one
                        \ pixel row at a time

.dsun35

 JSR EDGES              \ Call EDGES to calculate X1 and X2 for the horizontal
                        \ line centred on YY(1 0) and with half-width A, clipped
                        \ to fit on-screen if necessary, so this gives us the
                        \ coordinates of the smallest pixel row in the tile row
                        \ that we want to draw

 BCS dsun37             \ If the C flag is set, then the smallest pixel row
                        \ is off-screen, so jump to dsun37 to draw the tile row
                        \ one pixel row at a time, as there is at least one
                        \ pixel row in the tile row that doesn't need drawing

                        \ If we get here then every pixel row in the tile row
                        \ fits on-screen and contains some sun pixels, so we
                        \ can now work out how to draw this row using filled
                        \ tiles where possible
                        \
                        \ We do this by breaking the line up into a tile at the
                        \ left end of the row, a tile at the right end of the
                        \ row, and a set of filled tiles in the middle
                        \
                        \ We set P and P+1 to the pixel coordinates of the block
                        \ of filled tiles in the middle

 LDA X2                 \ Set P+1 to the x-coordinate of the right end of the
 AND #%11111000         \ smallest sun line by clearing bits 0-2 of X2, giving
 STA P+1                \ P+1 = (X2 div 8) * 8
                        \
                        \ This gives us what we want as each tile is 8 pixels
                        \ wide

 LDA X1                 \ Now to calculate the x-coordinate of the left end of
 ADC #7                 \ the filled tiles, so set A = X1 + 7 (we know the C
                        \ flag is clear for the addition as we just passed
                        \ through a BCS)

 BCS dsun37             \ If the addition overflowed, then this addition pushes
                        \ us past the right edge of the screen, so jump to
                        \ dsun37 to draw the tile row one pixel row at a time as
                        \ there isn't any room for filled tiles

 AND #%11111000         \ Clear bits 0-2 of A to give us the x-coordinate of the
                        \ left end of the set of filled tiles

 CMP P+1                \ If A >= P+1 then there is no room for any filled as
 BCS dsun37             \ the entire line fits into one tile, so jump to dsun37
                        \ to draw the tile row one pixel row at a time

 STA P                  \ Otherwise we now have valid values for the
                        \ x-coordinate range of the filled blocks in the
                        \ middle of the row, so store A in P so the coordinate
                        \ range is from P to P+1

 CMP #248               \ If A >= 248 then we only have room for one block on
 BCS dsun36             \ this row, and it's at the right edge of the screen,
                        \ so jump to dsun36 to skip the right and middle tiles
                        \ and just draw the tile at the left end of the row

 JSR dsun47             \ Call dsun47 to draw the tile at the right end of this
                        \ tile row

 JSR DrawSunRowOfBlocks \ Draw the tiles containing the horizontal line (P, Y)
                        \ to (P+1, Y) with filled blocks, silhouetting any
                        \ existing content against the sun

.dsun36

 JMP dsun46             \ Jump to dsun46 to draw the tile at the left end of
                        \ this tile row, returning from the subroutine using a
                        \ tail call as we have now drawn the middle of the row,
                        \ plus both ends

.dsun37

                        \ If we get here then we draw the current tile row one
                        \ pixel row at a time

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth7,
                        \ which is the pixel line for row 7 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES

 BCS dsun38             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 7 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun38

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth6,
                        \ which is the pixel line for row 6 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES

 BCS dsun39             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 6 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun39

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth5,
                        \ which is the pixel line for row 5 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun40             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 5 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun40

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth4,
                        \ which is the pixel line for row 4 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun41             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 4 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun41

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth3,
                        \ which is the pixel line for row 3 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun42             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 3 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun42

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth2          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth2,
                        \ which is the pixel line for row 2 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun43             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 2 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun43

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth1,
                        \ which is the pixel line for row 1 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun44             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and move on to the next pixel
                        \ row

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 1 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun

.dsun44

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Call EDGES-2 to calculate X1 and X2 for the horizontal
 JSR EDGES-2            \ line centred on YY(1 0) and with half-width sunWidth0,
                        \ which is the pixel line for row 0 in the tile row
                        \
                        \ Calling EDGES-2 will set the C flag if A = 0, which
                        \ isn't the case for a straight call to EDGES
 BCS dsun45             \ If the C flag is set then either A = 0 (in which case
                        \ there is no sun line on this pixel row), or the line
                        \ does not fit on-screen, so in either case skip the
                        \ following instruction and return from the subroutine
                        \ as we are done

 JMP HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y) to draw
                        \ pixel row 0 of the sun on this tile row, using EOR
                        \ logic so anything already on-screen appears as a
                        \ silhouette in front of the sun, and return from the
                        \ subroutine using a tail call as we have now drawn all
                        \ the lines in this row

.dsun45

 RTS                    \ Return from the subroutine

.dsun46

                        \ If we get here then we need to draw the tile at the
                        \ left end of the current tile row

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P                  \ Set X to P, the x-coordinate of the left end of the
                        \ middle part of the sun row (which is the same as the
                        \ x-coordinate just to the right of the leftmost tile)

 BEQ dsun45             \ If X = 0 then the leftmost tile is off the left of the
                        \ screen, so jump to dsun45 to return from the
                        \ subroutine

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 7

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 6

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 5

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 4

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 3

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth2          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 2

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the left edge of the sun at the
 JSR DrawSunEdgeLeft    \ left end of pixel row 1

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Draw a pixel byte for the left edge of the sun at the
 JMP DrawSunEdgeLeft    \ left end of pixel row 0 and return from the subroutine
                        \ using a tail call

.dsun47

                        \ If we get here then we need to draw the tile at the
                        \ right end of the current tile row

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX P+1                \ Set X1 to P+1, the x-coordinate of the right end of
 STX X1                 \ the middle part of the sun row (which is the same as
                        \ x-coordinate of the left end of the rightmost tile)

 TYA                    \ Set Y = Y + 7
 CLC                    \
 ADC #7                 \ We draw the lines from row 7 up the screen to row 0,
 TAY                    \ so this sets Y to the pixel y-coordinate of row 7

 LDA sunWidth7          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 7

 DEY                    \ Decrement the pixel y-coordinate in Y to row 6 in the
                        \ tile row

 LDA sunWidth6          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 6

 DEY                    \ Decrement the pixel y-coordinate in Y to row 5 in the
                        \ tile row

 LDA sunWidth5          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 5

 DEY                    \ Decrement the pixel y-coordinate in Y to row 4 in the
                        \ tile row

 LDA sunWidth4          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 4

 DEY                    \ Decrement the pixel y-coordinate in Y to row 3 in the
                        \ tile row

 LDA sunWidth3          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 3

 DEY                    \ Decrement the pixel y-coordinate in Y to row 2 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 2
                        \
                        \ This appears to be a bug (though one you would be
                        \ hard-pressed to detect from looking at the screen), as
                        \ we should probably be loading sunWidth2 here, not
                        \ sunWidth1
                        \
                        \ As it stands, on each tile row of the sun, the right
                        \ edge always has matching lines on pixel rows 1 and 2

 DEY                    \ Decrement the pixel y-coordinate in Y to row 1 in the
                        \ tile row

 LDA sunWidth1          \ Draw a pixel byte for the right edge of the sun at the
 JSR DrawSunEdgeRight   \ right end of pixel row 1

 DEY                    \ Decrement the pixel y-coordinate in Y to row 0 in the
                        \ tile row

 LDA sunWidth0          \ Draw a pixel byte for the right edge of the sun at the
 JMP DrawSunEdgeRight   \ right end of pixel row 0 and return from the
                        \ subroutine using a tail call

