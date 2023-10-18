\ ******************************************************************************
\
\       Name: CheckJumpSafety
\       Type: Subroutine
\   Category: Flight
\    Summary: Check whether we are far enough away from the planet and sun to be
\             able to do an in-system (fast-forward) jump
\
\ ------------------------------------------------------------------------------
\
\ This routine checks how far away from the planet and sun we would be if we
\ were to do an in-system jump. If we are too close to either object after doing
\ a jump, then the C flag is set, otherwise it is clear.
\
\ The distance check is only done in the forward direction; if the planet or
\ sun is behind us, then it is deemed safe to do a jump.
\
\ By default, this routine checks distances against a value of 64 (which is the
\ distance of an in-system jump). Arbitrary distances can be checked via the
\ entry point at CheckJumpSafety+2.
\
\ The algorithm actually calculates the distance as 0.5 * |x y z|, using an
\ approximation that that estimates the length within 8% of the correct value,
\ and without having to do any multiplication or take any square roots. If h is
\ the longest of x, y, z, and a and b are the other two sides, then the
\ algorithm is as follows:
\
\   0.5 * |(x y z)| ~= (5 * a + 5 * b + 16 * h) / 32
\
\ which we calculate like this:
\
\   5/32 * a + 5/32 * b + 1/2 * h
\
\ Calculating half the distance to the point (i.e. 0.5 * |x y z|) ensures that
\ the result fits into one byte. The distance to compare with is also halved.
\
\ Returns:
\
\   C flag              Results of the safety check:
\
\                         * Clear if we are not close to the planet or sun and
\                           can do an in-system jump
\
\                         * Set if we are too close to the planet or sun to do
\                           an in-system jump
\
\ Other entry points:
\
\   CheckJumpSafety+2    Check the distances against the value of 0.5 * A
\
\ ******************************************************************************

.CheckJumpSafety

 LDA #128               \ Set A = 128, to use as the default distance to check
                        \ our proximity against

 LSR A                  \ Set T = A / 2
 STA T                  \
                        \ So the value of T is set as follows:
                        \
                        \   * T = 64 if we call the routine via CheckJumpSafety
                        \
                        \   * T = A / 2 if we call the routine via the entry
                        \     point at CheckJumpSafety+2
                        \
                        \ T is the value that we check the distances against
                        \ to determine whether we are too close to the planet
                        \ or sun

 LDY #0                 \ Set Y as the offset in K% to the first ship data
                        \ block, i.e. the planet

 JSR cdis1              \ Call cdis1 below to check our distance from the planet

 BCS cdis7              \ If the C flag is set then we are deemed close to the
                        \ planet, so there is no need to check the sun, so jump
                        \ to cdis7 to return from the subroutine with the C flag
                        \ set

 LDA SSPR               \ If SSPR is non-zero then we are inside the space
 BNE cdis7              \ station's safe zone, so we can't be too close to the
                        \ sun, so jump to cdis7 return from the subroutine with
                        \ the C flag clear (we know this is the case as we just
                        \ passed through a BCS)

                        \ If we get here then we have checked the distance to
                        \ the planet and we are not close to it, so now we check
                        \ our distance from the sun

 LDY #NIK%              \ Set Y as the offset in K% to the second ship data
                        \ block, i.e. the sun (this can't be the space station
                        \ as we know we aren't in the safe zone)

.cdis1

                        \ In the following, K%+Y points to the ship data block
                        \ for the object we are measuring the distance to (i.e.
                        \ the planet or sun)
                        \
                        \ To make things easier to follow, let's refer to this
                        \ object as the planet, with the planet's centre being
                        \ at (x, y, z), where each coordinate is of the form
                        \ (x_sign x_hi x_lo)

 LDA K%+2,Y             \ If either of x_sign or y_sign are non-zero (ignoring
 ORA K%+5,Y             \ the sign in bit 7), then jump to cdis5 to return with
 ASL A                  \ the C flag clear, as the planet is a long way away
 BNE cdis5              \ to the sides or above/below us

 LDA K%+8,Y             \ If z_sign is negative (i.e. bit 7 is set), or z_sign
 LSR A                  \ is positive and z_sign > 1, then jump to cdis5 to
 BNE cdis5              \ return with the C flag clear, as the planet is either
                        \ behind us, or it's a long way in front of us

                        \ The above sets the C flag to bit 0 of z_sign

 LDA K%+7,Y             \ Set A = (z_sign z_hi) / 2 - 32
 ROR A                  \
 SEC                    \ This result will fit into one byte because we know
 SBC #32                \ bits 1 to 7 of z_sign are clear
                        \
                        \ As we know the rest of z_sign is empty, let's just
                        \ simplify this to:
                        \
                        \   A = (z_hi / 2) - 32
                        \     = (z_hi - 64) / 2

 BCS cdis2              \ If the above subtraction didn't underflow, jump to
                        \ cdis2 to skip the following

 EOR #&FF               \ The subtraction underflowed so A is negative, so make
 ADC #1                 \ A positive using two's complement (which will work as
                        \ we know the C flag is clear as we just passed through
                        \ a BCS)
                        \
                        \ We therefore have A = |(z_hi - 64) / 2|

.cdis2

 STA K+2                \ Set K+2 = |(z_hi - 64) / 2|

 LDA K%+1,Y             \ Set K = x_hi / 2
 LSR A
 STA K

 LDA K%+4,Y             \ Set K+1 = y_hi / 2
 LSR A                  \
 STA K+1                \ This also sets A = K+1

                        \ From this point on we are only working with the high
                        \ bytes, so to make things easier to follow, let's just
                        \ refer to x_hi, y_hi and z_hi as x, y and z, so:
                        \
                        \   K   = x / 2
                        \   K+1 = y / 2
                        \   K+2 = (z - 64) / 2
                        \
                        \ The following algorithm is the same as the FAROF2
                        \ routine, so this measures the distance from our ship
                        \ to the point (x, y, z - 64), which is where (x, y, z)
                        \ will be if we jump forward by a distance of z_hi = 64
                        \
                        \ In other words, the following checks the distance from
                        \ our ship to the planet if we were to do an in-system
                        \ jump forwards
                        \
                        \ Note that it actually calculates half the distance to
                        \ the point (i.e. 0.5 * |x y z|) as this will ensure the
                        \ result fits into one byte

 CMP K                  \ If A >= K, jump to cdis3 to skip the next instruction
 BCS cdis3

 LDA K                  \ Set A = K, so A = max(K, K+1)

.cdis3

 CMP K+2                \ If A >= K+2, jump to cdis4 to skip the next
 BCS cdis4              \ instruction

 LDA K+2                \ Set A = K+2, so A = max(A, K+2)
                        \                   = max(K, K+1, K+2)

.cdis4

 STA SC                 \ Set SC = A
                        \        = max(K, K+1, K+2)
                        \        = max(x / 2, y / 2, z / 2)
                        \        = max(x, y, z) / 2

 LDA K                  \ Set SC+1 = (K + K+1 + K+2 - SC) / 4
 CLC                    \          = (x/2 + y/2 + z/2 - max(x, y, z) / 2) / 4
 ADC K+1                \          = (x + y + z - max(x, y, z)) / 8
 ADC K+2                \
 SEC                    \ There is a risk that the addition will overflow here,
 SBC SC                 \ but presumably this isn't an issue
 LSR A
 LSR A
 STA SC+1

 LSR A                  \ Set A = (SC+1 / 4) + SC+1 + SC
 LSR A                  \       = 5/4 * SC+1 + SC
 ADC SC+1               \       = 5 * (x + y + z - max(x, y, z)) / (8 * 4)
 ADC SC                 \          + max(x, y, z) / 2
                        \
                        \ If h is the longest of x, y, z, and a and b are the
                        \ other two sides, then we have:
                        \
                        \   max(x, y, z) = h
                        \
                        \   x + y + z - max(x, y, z) = a + b + h - h
                        \                            = a + b
                        \
                        \ So:
                        \
                        \   A = 5 * (a + b) / (8 * 4) + h / 2
                        \     = 5/32 * a + 5/32 * b + 1/2 * h
                        \
                        \ This estimates half the length of the (x, y, z)
                        \ vector, i.e. 0.5 * |x y z|, using an approximation
                        \ that estimates the length within 8% of the correct
                        \ value, and without having to do any multiplication
                        \ or take any square roots

 CMP T                  \ If A < T, C will be clear, otherwise C will be set
                        \
                        \ So the C flag is clear if |x y z| <  argument A
                        \                  set   if |x y z| >= argument A

 BCC cdis6              \ If the C flag is clear then |x y z| <  argument A,
                        \ which means we are close to the planet, so jump to
                        \ cdis6 to return with the C flag set to indicate this

                        \ Otherwise |x y z| >= argument A, which means we are
                        \ not close to the planet, so fall through into cdis5
                        \ to return with the C flag clear to indicate this

.cdis5

 CLC                    \ Set the C flag to indicate that we are not close to
                        \ the planet and can do an in-system jump

 RTS                    \ Return from the subroutine

.cdis6

 SEC                    \ Set the C flag to indicate that we are too close to
                        \ the planet to do an in-system jump

.cdis7

 RTS                    \ Return from the subroutine

