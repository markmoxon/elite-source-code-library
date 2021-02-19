\ ******************************************************************************
\
\       Name: TAS6
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Negate the vector in XX15 so it points in the opposite direction
\
\ ******************************************************************************

.TAS6

 LDA XX15               \ Reverse the sign of the x-coordinate of the vector in
 EOR #%10000000         \ XX15
 STA XX15

 LDA XX15+1             \ Then reverse the sign of the y-coordinate
 EOR #%10000000
 STA XX15+1

 LDA XX15+2             \ And then the z-coordinate, so now the XX15 vector is
 EOR #%10000000         \ pointing in the opposite direction
 STA XX15+2

 RTS                    \ Return from the subroutine

