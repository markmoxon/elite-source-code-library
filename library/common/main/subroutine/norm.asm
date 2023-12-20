\ ******************************************************************************
\
\       Name: NORM
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Normalise the three-coordinate vector in XX15
\  Deep dive: Tidying orthonormal vectors
\             Orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ We do this by dividing each of the three coordinates by the length of the
\ vector, which we can calculate using Pythagoras. Once normalised, 96 (&60) is
\ used to represent a value of 1, and 96 with bit 7 set (&E0) is used to
\ represent -1. This enables us to represent fractional values of less than 1
\ using integers.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XX15                The vector to normalise, with:
\
\                         * The x-coordinate in XX15
\
\                         * The y-coordinate in XX15+1
\
\                         * The z-coordinate in XX15+2
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   XX15                The normalised vector
\
\   Q                   The length of the original XX15 vector
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   NO1                 Contains an RTS
\
\ ******************************************************************************

.NORM

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA XX15               \ Fetch the x-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = x^2

 STA R                  \ Set (R Q) = (A P) = x^2
 LDA P
 STA Q

 LDA XX15+1             \ Fetch the y-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = y^2

IF NOT(_ELITE_A_FLIGHT)

 STA T                  \ Set (T P) = (A P) = y^2

 LDA P                  \ Set (R Q) = (R Q) + (T P) = x^2 + y^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 LDA T                  \ And then the high bytes, R = R + T
 ADC R
 STA R

ELIF _ELITE_A_FLIGHT

 TAY                    \ Set (Y P) = (A P) = y^2

 LDA P                  \ Set (R Q) = (R Q) + (Y P) = x^2 + y^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 TYA                    \ And then the high bytes, R = R + Y
 ADC R
 STA R

ENDIF

 LDA XX15+2             \ Fetch the z-coordinate into A

 JSR SQUA               \ Set (A P) = A * A = z^2

IF NOT(_ELITE_A_FLIGHT OR _NES_VERSION)

 STA T                  \ Set (T P) = (A P) = z^2

 LDA P                  \ Set (R Q) = (R Q) + (T P) = x^2 + y^2 + z^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 LDA T                  \ And then the high bytes, R = R + T
 ADC R
 STA R

ELIF _NES_VERSION

 STA T                  \ Set (T P) = (A P) = z^2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CLC                    \ Clear the C flag (though this isn't needed, as the
                        \ SETUP_PPU_FOR_ICON_BAR does this for us)

 LDA P                  \ Set (R Q) = (R Q) + (T P) = x^2 + y^2 + z^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 LDA T                  \ And then the high bytes, R = R + T
 ADC R                  \
 BCS norm2              \ Jumping to norm2 if the addition overflows
 STA R

ELIF _ELITE_A_FLIGHT

 TAY                    \ Set (Y P) = (A P) = z^2

 LDA P                  \ Set (R Q) = (R Q) + (Y P) = x^2 + y^2 + z^2
 ADC Q                  \
 STA Q                  \ First, doing the low bytes, Q = Q + P

 TYA                    \ And then the high bytes, R = R + Y
 ADC R
 STA R

ENDIF

 JSR LL5                \ We now have the following:
                        \
                        \ (R Q) = x^2 + y^2 + z^2
                        \
                        \ so we can call LL5 to use Pythagoras to get:
                        \
                        \ Q = SQRT(R Q)
                        \   = SQRT(x^2 + y^2 + z^2)
                        \
                        \ So Q now contains the length of the vector (x, y, z),
                        \ and we can normalise the vector by dividing each of
                        \ the coordinates by this value, which we do by calling
                        \ routine TIS2. TIS2 returns the divided figure, using
                        \ 96 to represent 1 and 96 with bit 7 set for -1

IF _NES_VERSION

.norm1

ENDIF

 LDA XX15               \ Call TIS2 to divide the x-coordinate in XX15 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA XX15+1             \ Call TIS2 to divide the y-coordinate in XX15+1 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15+1

 LDA XX15+2             \ Call TIS2 to divide the z-coordinate in XX15+2 by Q,
 JSR TIS2               \ with 1 being represented by 96
 STA XX15+2

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

.NO1

 RTS                    \ Return from the subroutine

IF _NES_VERSION

.norm2

                        \ If we get here then the addition overflowed during the
                        \ calculation of R = R + T above, so we need to scale
                        \ (A Q) down before we can call LL5, and then scale the
                        \ result up afterwards
                        \
                        \ As we are calculating a square root, we can do this by
                        \ scaling the argument in (R Q) down by a factor of 2*2,
                        \ and then scale the result in SQRT(R Q) up by a factor
                        \ of 2, thus side-stepping the overflow

 ROR A                  \ Set (A Q) = (A Q) / 4
 ROR Q
 LSR A
 ROR Q

 STA R                  \ Set (R Q) = (A Q)

 JSR LL5                \ We now have the following (scaled by a factor of 4):
                        \
                        \ (R Q) = x^2 + y^2 + z^2
                        \
                        \ so we can call LL5 to use Pythagoras to get:
                        \
                        \ Q = SQRT(R Q)
                        \   = SQRT(x^2 + y^2 + z^2)
                        \
                        \ So Q now contains the length of the vector (x, y, z),
                        \ and we can normalise the vector by dividing each of
                        \ the coordinates by this value, which we do by calling
                        \ routine TIS2. TIS2 returns the divided figure, using
                        \ 96 to represent 1 and 96 with bit 7 set for -1

 ASL Q                  \ Set Q = Q * 2, to scale the result back up

 JMP norm1              \ Jump back to norm1 to continue the calculation

ENDIF

