\ ******************************************************************************
\
\       Name: LL51
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate the dot product of XX15 and XX16
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following dot products:
\
\   XX12(1 0) = XX15(5 0) . XX16(5 0)
\   XX12(3 2) = XX15(5 0) . XX16(11 6)
\   XX12(5 4) = XX15(5 0) . XX16(12 17)
\
\ storing the results as sign-magnitude numbers in XX12 through XX12+5.
\
\ When called from part 5 of LL9, XX12 contains the vector [x y z] to the ship
\ we're drawing, and XX16 contains the orientation vectors, so it returns:
\
\   [ x ]   [ sidev_x ]         [ x ]   [ roofv_x ]         [ x ]   [ nosev_x ]
\   [ y ] . [ sidev_y ]         [ y ] . [ roofv_y ]         [ y ] . [ nosev_y ]
\   [ z ]   [ sidev_z ]         [ z ]   [ roofv_z ]         [ z ]   [ nosev_z ]
\
\ When called from part 6 of LL9, XX12 contains the vector [x y z] of the vertex
\ we're analysing, and XX16 contains the transposed orientation vectors with
\ each of them containing the x, y and z elements of the original vectors, so it
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   [ x ]   [ sidev_x ]         [ x ]   [ sidev_y ]         [ x ]   [ sidev_z ]
\   [ y ] . [ roofv_x ]         [ y ] . [ roofv_y ]         [ y ] . [ roofv_z ]
\   [ z ]   [ nosev_x ]         [ z ]   [ nosev_y ]         [ z ]   [ nosev_z ]
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15(1 0)           The ship (or vertex)'s x-coordinate as (x_sign x_lo)
\
\   XX15(3 2)           The ship (or vertex)'s y-coordinate as (y_sign y_lo)
\
\   XX15(5 4)           The ship (or vertex)'s z-coordinate as (z_sign z_lo)
\
\   XX16 to XX16+5      The scaled sidev (or _x) vector, with:
\
\                         * x, y, z magnitudes in XX16, XX16+2, XX16+4
\
\                         * x, y, z signs in XX16+1, XX16+3, XX16+5
\
\   XX16+6 to XX16+11   The scaled roofv (or _y) vector, with:
\
\                         * x, y, z magnitudes in XX16+6, XX16+8, XX16+10
\
\                         * x, y, z signs in XX16+7, XX16+9, XX16+11
\
\   XX16+12 to XX16+17  The scaled nosev (or _z) vector, with:
\
\                         * x, y, z magnitudes in XX16+12, XX16+14, XX16+16
\
\                         * x, y, z signs in XX16+13, XX16+15, XX16+17
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX12(1 0)           The dot product of [x y z] vector with the sidev (or _x)
\                       vector, with the sign in XX12+1 and magnitude in XX12
\
\   XX12(3 2)           The dot product of [x y z] vector with the roofv (or _y)
\                       vector, with the sign in XX12+3 and magnitude in XX12+2
\
\   XX12(5 4)           The dot product of [x y z] vector with the nosev (or _z)
\                       vector, with the sign in XX12+5 and magnitude in XX12+4
\
\ ******************************************************************************

.LL51

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDX #0                 \ Set X = 0, which will contain the offset of the vector
                        \ to use in the calculation, increasing by 6 for each
                        \ new vector

 LDY #0                 \ Set Y = 0, which will contain the offset of the
                        \ result bytes in XX12, increasing by 2 for each new
                        \ result

.ll51

 LDA XX15               \ Set Q = x_lo
 STA Q

 LDA XX16,X             \ Set A = |sidev_x|

 JSR FMLTU              \ Set T = A * Q / 256
 STA T                  \       = |sidev_x| * x_lo / 256

 LDA XX15+1             \ Set S to the sign of x_sign * sidev_x
 EOR XX16+1,X
 STA S

 LDA XX15+2             \ Set Q = y_lo
 STA Q

 LDA XX16+2,X           \ Set A = |sidev_y|

 JSR FMLTU              \ Set Q = A * Q / 256
 STA Q                  \       = |sidev_y| * y_lo / 256

 LDA T                  \ Set R = T
 STA R                  \       = |sidev_x| * x_lo / 256

 LDA XX15+3             \ Set A to the sign of y_sign * sidev_y
 EOR XX16+3,X

 JSR LL38               \ Set (S T) = (S R) + (A Q)
 STA T                  \           = |sidev_x| * x_lo + |sidev_y| * y_lo

 LDA XX15+4             \ Set Q = z_lo
 STA Q

 LDA XX16+4,X           \ Set A = |sidev_z|

 JSR FMLTU              \ Set Q = A * Q / 256
 STA Q                  \       = |sidev_z| * z_lo / 256

 LDA T                  \ Set R = T
 STA R                  \       = |sidev_x| * x_lo + |sidev_y| * y_lo

 LDA XX15+5             \ Set A to the sign of z_sign * sidev_z
 EOR XX16+5,X

 JSR LL38               \ Set (S A) = (S R) + (A Q)
                        \           = |sidev_x| * x_lo + |sidev_y| * y_lo
                        \             + |sidev_z| * z_lo

IF NOT(_NES_VERSION)

 STA XX12,Y             \ Store the result in XX12+Y(1 0)
 LDA S
 STA XX12+1,Y

ELIF _NES_VERSION

 STA XX12,Y             \ Store the result in XX12+Y(1 0), starting with the low
                        \ byte

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA S                  \ And then the high byte
 STA XX12+1,Y

ENDIF

 INY                    \ Set Y = Y + 2
 INY

 TXA                    \ Set X = X + 6
 CLC
 ADC #6
 TAX

 CMP #17                \ If X < 17, loop back to ll51 for the next vector
 BCC ll51

 RTS                    \ Return from the subroutine

