\ ******************************************************************************
\
\       Name: SPS3
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Copy a space coordinate from the K% block into K3
\
\ ------------------------------------------------------------------------------
\
\ Copy one of the planet's coordinates into the corresponding location in the
\ temporary variable K3. The high byte and absolute value of the sign byte are
\ copied into the first two K3 bytes, and the sign of the sign byte is copied
\ into the highest K3 byte.
\
\ The comments below are written for the x-coordinate.
\
\ Arguments:
\
\   X                   Determines which coordinate to copy, and to where:
\
\                         * X = 0 copies (x_sign, x_hi) into K3(2 1 0)
\
\                         * X = 3 copies (y_sign, y_hi) into K3(5 4 3)
\
\                         * X = 6 copies (z_sign, z_hi) into K3(8 7 6)
\
\ ******************************************************************************

.SPS3

 LDA K%+1,X             \ Copy x_hi into K3+X
 STA K3,X

 LDA K%+2,X             \ Set A = Y = x_sign
 TAY

 AND #%01111111         \ Set K3+1 = |x_sign|
 STA K3+1,X

 TYA                    \ Set K3+2 = the sign of x_sign
 AND #%10000000
 STA K3+2,X

 RTS                    \ Return from the subroutine

