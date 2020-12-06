\ ******************************************************************************
\
\       Name: MAS4
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate a cap on the maximum distance to a ship
\
\ ------------------------------------------------------------------------------
\
\ Logical OR the value in A with the high bytes of the ship's position (x_hi,
\ y_hi and z_hi).
\
\ Returns:
\
\   A                   A OR x_hi OR y_hi OR z_hi
\
\ ******************************************************************************

.MAS4

 ORA INWK+1             \ OR A with x_hi, y_hi and z_hi
 ORA INWK+4
 ORA INWK+7

 RTS                    \ Return from the subroutine

