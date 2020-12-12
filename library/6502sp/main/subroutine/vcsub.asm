\ ******************************************************************************
\
\       Name: VCSUB
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate vector K3(8 0) = [x y z] - coordinates in (A V)
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   K3(2 1 0) = (x_sign x_hi x_lo) - x-coordinate in (A V)
\
\   K3(5 4 3) = (y_sign y_hi z_lo) - y-coordinate in (A V)
\
\   K3(8 7 6) = (z_sign z_hi z_lo) - z-coordinate in (A V)
\
\ where the first coordinate is from the ship data block in INWK, and the second
\ coordinate is from the ship data block pointed to by (A V).
\
\ ******************************************************************************

.VCSUB

 STA V+1                \ Set the low byte of V(1 0) to A, so now V(1 0) = (A V)

 LDY #2                 \ K3(2 1 0) = (x_sign x_hi x_lo) - x-coordinate in data
 JSR TAS1               \ block at V(1 0)

 LDY #5                 \ K3(5 4 3) = (y_sign y_hi z_lo) - y-coordinate of data
 JSR TAS1               \ block at V(1 0)

 LDY #8                 \ Fall through into TAS1 to calculate the final result:
                        \
                        \ K3(8 7 6) = (z_sign z_hi z_lo) - z-coordinate of data
                        \ block at V(1 0)

