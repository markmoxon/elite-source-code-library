\ ******************************************************************************
\
\       Name: PLS4
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Calculate CNT2 = arctan(P / A) / 4
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   CNT2 = arctan(P / A) / 4
\
\ giving the result the opposite sign to nosev_z_hi. This is called with the
\ following arguments when calculating the equator and meridian for planets:
\
\   * A = roofv_z_hi, P = -nosev_z_hi
\
\   * A = sidev_z_hi, P = -nosev_z_hi
\
\ So it calculates the angle between the planet's orientation vectors, in the
\ z-axis.
\
\ ******************************************************************************

.PLS4

 STA Q                  \ Set Q = A

 JSR ARCTAN             \ Call ARCTAN to calculate:
                        \
                        \   A = arctan(P / Q)
                        \       arctan(P / A)

 LDX INWK+14            \ If nosev_z_hi is negative, skip the following
 BMI P%+4               \ instruction

 EOR #%10000000         \ nosev_z_hi is positive, so make the arctan negative

 LSR A                  \ Set CNT2 = A / 4
 LSR A
 STA CNT2

 RTS                    \ Return from the subroutine

