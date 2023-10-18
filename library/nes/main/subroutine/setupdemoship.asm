\ ******************************************************************************
\
\       Name: SetupDemoShip
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Set up the ship workspace for a new ship in the combat demo
\
\ ******************************************************************************

.SetupDemoShip

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace and set up
                        \ the orientation vectors so the ship is pointing
                        \ towards us, out of the screen

 LDA #96                \ Set byte #14 = nosev_z_hi = 96 = 1
 STA INWK+14            \
                        \ So the ship is pointing into the screen

 ORA #%10000000         \ Flip the sign of A to represent a -1

 STA INWK+22            \ Set byte #22 = sidev_x_hi = -96 = -1
                        \
                        \ So the ship doesn't get reflected in the x-axis by the
                        \ flipping of the z-coordinate, but is instead rotated
                        \ around the y-axis to point into the screen

 LDA #%11111110         \ Set the ship's byte #32 (AI flag) to %11111110, so it
 STA INWK+32            \ has no E.C.M., is hostile, highly aggressive and has
                        \ AI enabled

 LDA #32                \ Set the ship's byte #27 (speed) to 32
 STA INWK+27

                        \ We now set the ship's coordinates to (-40, 40, 60) so
                        \ it is to our upper left and in front of us

 LDA #%10000000         \ Set (x_sign x_lo) = -40
 STA INWK+2
 LDA #40
 STA INWK

 LDA #40                \ Set y_lo = 40
 STA INWK+3

 LDA #60                \ Set z_lo = 60
 STA INWK+6

 RTS                    \ Return from the subroutine

