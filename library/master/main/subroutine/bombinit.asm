\ ******************************************************************************
\
\       Name: BOMBINIT
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Randomise and draw the energy bomb's zig-zag lightning bolt lines
\
\ ******************************************************************************

.BOMBINIT

 LDY #0                 \ We first need to generate 10 random coordinates for a
                        \ zig-zag lightning bolt, with the x-coordinates in the
                        \ table at BOMBX and the y-coordinates in the table at
                        \ BOMBY, so set a counter in Y as an index to point at
                        \ each coordinate as we create them
                        \
                        \ Note that we generate the points from right to left,
                        \ so that's high x-coordinate to low x-coordinate

.BOMBSL1

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #127               \ random number in the range 0-127

 ADC #3                 \ Add 3 so A is now in the range 3-130, so the smallest
                        \ possible value gives a y-coordinate just below the top
                        \ border, and the highest possible value gives a
                        \ y-coordinate that's around two-thirds of the way down
                        \ the space view

 STA BOMBY,Y            \ Store A in the Y-th byte of BOMBY, as the y-coordinate
                        \ of the Y-th point in our lightning bolt

 TXA                    \ Fetch the random number from X into A and reduce it to
 AND #31                \ the range 0-31

 CLC                    \ Add the Y-th value from BOMBSTEP table, which contains
 ADC BOMBSTEP,Y         \ the smallest possible x-coordinate for the Y-th point
                        \ (so the coordinates in the bolt will step along the
                        \ screen from right to left, but with varying step
                        \ sizes)

 STA BOMBX,Y            \ Store A in the Y-th byte of BOMBX, as the x-coordinate
                        \ of the Y-th point in our lightning bolt

 INY                    \ Increment the loop index

 CPY #10                \ Loop back to generate the next coordinate until we
 BCC BOMBSL1            \ have generated all ten

 LDX #0                 \ Set BOMBX+9 = 0, so the lightning bolt starts at the
 STX BOMBX+9            \ left edge of the screen

 DEX                    \ Set BOMBX = 255, so the lightning bolt ends at the
 STX BOMBX              \ right edge of the screen

 BCS BOMBLINES          \ Call BOMBLINES to draw the newly generated zig-zag
                        \ lightning bolt and return from the subroutine using a
                        \ tail call (this BCS is effectively a JMP as we passed
                        \ through the BCC above)

