\ ******************************************************************************
\
\       Name: BOMBFX
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Erase the energy bomb zig-zag lightning bolt, make the sound of
\             the energy bomb going off, draw a new bolt and repeat four times
\
\ ******************************************************************************

.BOMBFX

 JSR P%+3               \ This pair of JSRs runs the following code four times
 JSR P%+3

 LDY #6                 \ Call the NOISE routine with Y = 6 to make the sound of
 JSR NOISE              \ an energy bomb going off

 JSR BOMBLINES          \ Our energy bomb is going off, so call BOMBLINES to
                        \ draw the current zig-zag lightning bolt, which will
                        \ erase it from the screen

                        \ Fall through into BOMBINIT to set up and display a new
                        \ zig-zag lightning bolt

