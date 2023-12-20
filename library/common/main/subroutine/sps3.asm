\ ******************************************************************************
\
\       Name: SPS3
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Copy a space coordinate from the K% block into K3
\
\ ------------------------------------------------------------------------------
\
IF NOT(_ELITE_A_VERSION)
\ Copy one of the planet's coordinates into the corresponding location in the
\ temporary variable K3. The high byte and absolute value of the sign byte are
\ copied into the first two K3 bytes, and the sign of the sign byte is copied
\ into the highest K3 byte.
ELIF _ELITE_A_VERSION
\ Copy one of the space coordinates of the planet, sun or space station into the
\ corresponding location in the temporary variable K3. The high byte and
\ absolute value of the sign byte are copied into the first two K3 bytes, and
\ the sign of the sign byte is copied into the highest K3 byte.
ENDIF
\
\ The comments below are written for copying the planet's x-coordinate into
\ K3(2 1 0).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF NOT(_ELITE_A_VERSION)
\   X                   Determines which coordinate to copy, and to where:
\
\                         * X = 0 copies (x_sign, x_hi) into K3(2 1 0)
\
\                         * X = 3 copies (y_sign, y_hi) into K3(5 4 3)
\
\                         * X = 6 copies (z_sign, z_hi) into K3(8 7 6)
ELIF _ELITE_A_VERSION
\   X                   Determines where to copy the coordinate to:
\
\                         * X = 0 copies the coordinate into K3(2 1 0)
\
\                         * X = 3 copies the coordinate into K3(5 4 3)
\
\                         * X = 6 copies the coordinate into K3(8 7 6)
\
\   Y                   Determines which coordinate to copy:
\
\                         * Y = 0 copies (x_sign, x_hi) of planet
\
\                         * Y = 3 copies (y_sign, y_hi) of planet
\
\                         * Y = 6 copies (z_sign, z_hi) of planet
\
\                         * Y = NI% + 0 copies (x_sign, x_hi) of sun/station
\
\                         * Y = NI% + 3 copies (y_sign, y_hi) of sun/station
\
\                         * Y = NI% + 6 copies (z_sign, z_hi) of sun/station
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is incremented by 3 to point to the next coordinate
\
\   Y                   Y is incremented by 3 to point to the next coordinate
ENDIF
\
\ ******************************************************************************

.SPS3

IF NOT(_ELITE_A_VERSION)

 LDA K%+1,X             \ Copy x_hi into K3+X
 STA K3,X

 LDA K%+2,X             \ Set A = Y = x_sign
 TAY

ELIF _ELITE_A_VERSION

 LDA K%+1,Y             \ Copy x_hi into K3+X
 STA K3,X

 LDA K%+2,Y             \ Set A = x_sign and store it on the stack
 PHA

ENDIF

 AND #%01111111         \ Set K3+1 = |x_sign|
 STA K3+1,X

IF NOT(_ELITE_A_VERSION)

 TYA                    \ Set K3+2 = the sign of x_sign
 AND #%10000000
 STA K3+2,X

ELIF _ELITE_A_VERSION

 PLA                    \ Set K3+2 = the sign of x_sign
 AND #%10000000
 STA K3+2,X

ENDIF

IF _ELITE_A_VERSION

 INY                    \ Increment the value of Y by 3 so the next call to SPS3
 INY                    \ will copy the next coordinate (i.e. x then y then z)
 INY

 INX                    \ Increment the value of X by 3 so the next call to SPS3
 INX                    \ will store the coordinate in the next 24-bit K3 number
 INX

ENDIF

 RTS                    \ Return from the subroutine

