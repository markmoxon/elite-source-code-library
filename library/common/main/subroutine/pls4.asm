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
                        \
                        \ The result in A will be in the range 0 to 128, which
                        \ represents an angle of 0 to 180 degrees (or 0 to PI
                        \ radians)

 LDX INWK+14            \ If nosev_z_hi is negative, skip the following
 BMI P%+4               \ instruction to leave the angle in A as a positive
                        \ integer in the range 0 to 128 (so when we calculate
                        \ CNT2 below, it will be in the right half of the
                        \ anti-clockwise that we describe when drawing circles,
                        \ i.e. from 6 o'clock, through 3 o'clock and on to 12
                        \ o'clock)

 EOR #%10000000         \ If we get here then nosev_z_hi is positive, so flip
                        \ bit 7 of the angle in A, which is the same as adding
                        \ 128 to give a result in the range 129 to 256 (i.e. 129
                        \ to 0), or 180 to 360 degrees (so when we calculate
                        \ CNT2 below, it will be in the left half of the
                        \ anti-clockwise that we describe when drawing circles,
                        \ i.e. from 12 o'clock, through 9 o'clock and on to 6
                        \ o'clock)

 LSR A                  \ Set CNT2 = A / 4
 LSR A
 STA CNT2

 RTS                    \ Return from the subroutine

