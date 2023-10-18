\ ******************************************************************************
\
\       Name: FAROF2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with A
\
\ ------------------------------------------------------------------------------
\
\ Calculate the distance from the origin to the point (x, y, z) and compare it
\ with the argument A, clearing the C flag if the distance is < A, or setting
\ the C flag if the distance is >= A.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different and the
\ result is returned with the C flag the other way around.
\
\ The algorithm actually calculates the distance as 0.5 * |x y z|, using an
\ approximation that that estimates the length within 8% of the correct value,
\ and without having to do any multiplication or take any square roots. If h is
\ the longest component of x, y, z, and a and b are the other two sides, then
\ the algorithm is as follows:
\
\   0.5 * |(x y z)| ~= (5 * a + 5 * b + 16 * h) / 32
\
\ which we calculate like this:
\
\   5/32 * a + 5/32 * b + 1/2 * h
\
\ Calculating half the distance to the point (i.e. 0.5 * |x y z|) ensures that
\ the result fits into one byte. The distance to check against in A is not
\ halved, so the comparison ends up being between |(x y z)| and A * 2.
\
\ Arguments:
\
\   A                   The distance to check against (the distance is checked
\                       against A * 2)
\
\ Returns:
\
\   C flag              The result of comparing |x y z| with A:
\
\                         * Clear if the distance to (x, y, z) < A * 2
\
\                         * Set if the distance to (x, y, z) >= A * 2
\
\ ******************************************************************************

.FAROF2

 STA T                  \ Store the value that we want to compare x, y z with
                        \ in T

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+2             \ If any of x_sign, y_sign or z_sign are non-zero
 ORA INWK+5             \ (ignoring the sign in bit 7), then jump to farr3 to
 ORA INWK+8             \ return the C flag set, to indicate that A is smaller
 ASL A                  \ than x, y, z
 BNE farr3

 LDA INWK+7             \ Set K+2 = z_hi / 2
 LSR A
 STA K+2

 LDA INWK+1             \ Set K = x_hi / 2
 LSR A
 STA K

 LDA INWK+4             \ Set K+1 = y_hi / 2
 LSR A                  \
 STA K+1                \ This also sets A = K+1

                        \ From this point on we are only working with the high
                        \ bytes, so to make things easier to follow, let's just
                        \ refer to x_hi, y_hi and z_hi as x, y and z, so:
                        \
                        \   K   = x / 2
                        \   K+1 = y / 2
                        \   K+2 = z / 2

 CMP K                  \ If A >= K, jump to farr1 to skip the next instruction
 BCS farr1

 LDA K                  \ Set A = K, so A = max(K, K+1)

.farr1

 CMP K+2                \ If A >= K+2, jump to farr2 to skip the next
 BCS farr2              \ instruction

 LDA K+2                \ Set A = K+2, so A = max(A, K+2)
                        \                   = max(K, K+1, K+2)

.farr2

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

 RTS                    \ Return from the subroutine

.farr3

 SEC                    \ Set the C flag to indicate A < x and A < y and A < z

 RTS                    \ Return from the subroutine

