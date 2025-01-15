\ ******************************************************************************
\
\       Name: BOMBEFF2
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Erase the energy bomb zig-zag lightning bolt, make the sound of
\             the energy bomb going off, draw a new bolt and repeat four times
\
\ ******************************************************************************

.BOMBEFF2

 JSR P%+3               \ This pair of JSRs runs the following code four times
 JSR BOMBEFF

.BOMBEFF

IF _MASTER_VERSION \ Platform

 LDY #sobomb            \ Call the NOISE routine with Y = 6 to make the sound of
 JSR NOISE              \ an energy bomb going off

ELIF _APPLE_VERSION

 JSR SOBOMB             \ Make the sound of an energy bomb going off

ENDIF

 JSR BOMBOFF            \ Our energy bomb is going off, so call BOMBOFF to draw
                        \ the current zig-zag lightning bolt, which will erase
                        \ it from the screen

                        \ Fall through into BOMBON to set up and display a new
                        \ zig-zag lightning bolt

