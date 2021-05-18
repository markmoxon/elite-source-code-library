\ ******************************************************************************
\
\       Name: STARS2
\       Type: Subroutine
\   Category: Stardust
\    Summary: Process the stardust for the left or right view
\  Deep dive: Stardust in the side views
\
\ ------------------------------------------------------------------------------
\
\ This moves the stardust sideways according to our speed and which side we are
\ looking out of, and applies our current pitch and roll to each particle of
\ dust, so the stardust moves correctly when we steer our ship.
\
\ Arguments:
\
\   X                   The view to process:
\
\                         * X = 1 for left view
\
\                         * X = 2 for right view
\
\ ******************************************************************************

.STARS2

 LDA #0                 \ Set A to 0 so we can use it to capture a sign bit

 CPX #2                 \ If X >= 2 then the C flag is set

 ROR A                  \ Roll the C flag into the sign bit of A and store in
 STA RAT                \ RAT, so:
                        \
                        \   * Left view, C is clear so RAT = 0 (positive)
                        \
                        \   * Right view, C is set so RAT = 128 (negative)
                        \
                        \ RAT represents the end of the x-axis where we want new
                        \ stardust particles to come from: positive for the left
                        \ view where new particles come in from the right,
                        \ negative for the right view where new particles come
                        \ in from the left

 EOR #%10000000         \ Set RAT2 to the opposite sign, so:
 STA RAT2               \
                        \   * Left view, RAT2 = 128 (negative)
                        \
                        \   * Right view, RAT2 = 0 (positive)
                        \
                        \ RAT2 represents the direction in which stardust
                        \ particles should move along the x-axis: negative for
                        \ the left view where particles go from right to left,
                        \ positive for the right view where particles go from
                        \ left to right

 JSR ST2                \ Call ST2 to flip the signs of the following if this is
                        \ the right view: ALPHA, ALP2, ALP2+1, BET2 and BET2+1

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: The Electron version has no witchspace, so the number of stardust particles shown is always the same, so the value is hard-coded rather than needing to use a location (which the other versions need so they can vary the number of particles when in witchspace)

 LDY NOSTM              \ Set Y to the current number of stardust particles, so
                        \ we can use it as a counter through all the stardust

ELIF _ELECTRON_VERSION

 LDY #NOST              \ Set Y to the number of stardust particles, so we can
                        \ use it as a counter through all the stardust

ENDIF

.STL2

 LDA SZ,Y               \ Set A = ZZ = z_hi

 STA ZZ                 \ We also set ZZ to the original value of z_hi, which we
                        \ use below to remove the existing particle

 LSR A                  \ Set A = z_hi / 8
 LSR A
 LSR A

 JSR DV41               \ Call DV41 to set the following:
                        \
                        \   (P R) = 256 * DELTA / A
                        \         = 256 * speed / (z_hi / 8)
                        \         = 8 * 256 * speed / z_hi
                        \
                        \ This represents the distance we should move this
                        \ particle along the x-axis, let's call it delta_x

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Master: Group A: The side-view stardust routine in the Master version was recoded to cope with arbitrary screen widths, code that was presumably inherited from the non-BBC versions of the game

 LDA P                  \ Set S = P but with the sign from RAT2, so we now have
 EOR RAT2               \ the distance delta_x with the correct sign in (S R):
 STA S                  \
                        \   (S R) = delta_x
                        \         = 8 * 256 * speed / z_hi
                        \
                        \ So (S R) is the delta, signed to match the direction
                        \ the stardust should move in, which is result 1 above

ELIF _MASTER_VERSION

 LDA P                  \ Store the high byte of delta_x in deltX
 STA deltX

 EOR RAT2               \ Set S = P but with the sign from RAT2, so we now have
 STA S                  \ the distance delta_x with the correct sign in (S R):
                        \
                        \   (S R) = delta_x
                        \         = 8 * 256 * speed / z_hi
                        \
                        \ So (S R) is the delta, signed to match the direction
                        \ the stardust should move in, which is result 1 above
ENDIF

 LDA SXL,Y              \ Set (A P) = (x_hi x_lo)
 STA P                  \           = x
 LDA SX,Y

 STA X1                 \ Set X1 = A, so X1 contains the original value of x_hi,
                        \ which we use below to remove the existing particle

 JSR ADD                \ Call ADD to calculate:
                        \
                        \   (A X) = (A P) + (S R)
                        \         = x + delta_x

 STA S                  \ Set (S R) = (A X)
 STX R                  \           = x + delta_x

 LDA SY,Y               \ Set A = y_hi

 STA Y1                 \ Set Y1 = A, so Y1 contains the original value of y_hi,
                        \ which we use below to remove the existing particle

 EOR BET2               \ Give A the correct sign of A * beta, i.e. y_hi * beta

 LDX BET1               \ Fetch |beta| from BET1, the pitch angle

 JSR MULTS-2            \ Call MULTS-2 to calculate:
                        \
                        \   (A P) = X * A
                        \         = beta * y_hi

 JSR ADD                \ Call ADD to calculate:
                        \
                        \   (A X) = (A P) + (S R)
                        \         = beta * y + x + delta_x

 STX XX                 \ Set XX(1 0) = (A X), which gives us results 2 and 3
 STA XX+1               \ above, done at the same time:
                        \
                        \   x = x + delta_x + beta * y

 LDX SYL,Y              \ Set (S R) = (y_hi y_lo)
 STX R                  \           = y
 LDX Y1
 STX S

 LDX BET1               \ Fetch |beta| from BET1, the pitch angle

 EOR BET2+1             \ Give A the opposite sign to x * beta

 JSR MULTS-2            \ Call MULTS-2 to calculate:
                        \
                        \   (A P) = X * A
                        \         = -beta * x

 JSR ADD                \ Call ADD to calculate:
                        \
                        \   (A X) = (A P) + (S R)
                        \         = -beta * x + y

 STX YY                 \ Set YY(1 0) = (A X), which gives us result 4 above:
 STA YY+1               \
                        \   y = y - beta * x

 LDX ALP1               \ Set X = |alpha| from ALP2, the roll angle

 EOR ALP2               \ Give A the correct sign of A * alpha, i.e. y_hi *
                        \ alpha

 JSR MULTS-2            \ Call MULTS-2 to calculate:
                        \
                        \   (A P) = X * A
                        \         = alpha * y

 STA Q                  \ Set Q = high byte of alpha * y

 LDA XX                 \ Set (S R) = XX(1 0)
 STA R                  \           = x
 LDA XX+1               \
 STA S                  \ and set A = y_hi at the same time

 EOR #%10000000         \ Flip the sign of A = -x_hi

 JSR MAD                \ Call MAD to calculate:
                        \
                        \   (A X) = Q * A + (S R)
                        \         = alpha * y * -x + x

 STA XX+1               \ Store the high byte A in XX+1

 TXA
 STA SXL,Y              \ Store the low byte X in x_lo

                        \ So (XX+1 x_lo) now contains result 5 above:
                        \
                        \   x = x - alpha * x * y

 LDA YY                 \ Set (S R) = YY(1 0)
 STA R                  \           = y
 LDA YY+1               \
 STA S                  \ and set A = y_hi at the same time

 JSR MAD                \ Call MAD to calculate:
                        \
                        \   (A X) = Q * A + (S R)
                        \         = alpha * y * y_hi + y

 STA S                  \ Set (S R) = (A X)
 STX R                  \           = y + alpha * y * y

 LDA #0                 \ Set P = 0
 STA P

 LDA ALPHA              \ Set A = alpha, so:
                        \
                        \   (A P) = (alpha 0)
                        \         = alpha / 256

 JSR PIX1               \ Call PIX1 to calculate the following:
                        \
                        \   (YY+1 y_lo) = (A P) + (S R)
                        \               = alpha * 256 + y + alpha * y * y
                        \
                        \ i.e. y = y + alpha / 256 + alpha * y^2, which is
                        \ result 6 above
                        \
                        \ PIX1 also draws a particle at (X1, Y1) with distance
                        \ ZZ, which will remove the old stardust particle, as we
                        \ set X1, Y1 and ZZ to the original values for this
                        \ particle during the calculations above

                        \ We now have our newly moved stardust particle at
                        \ x-coordinate (XX+1 x_lo) and y-coordinate (YY+1 y_lo)
                        \ and distance z_hi, so we draw it if it's still on
                        \ screen, otherwise we recycle it as a new bit of
                        \ stardust and draw that

 LDA XX+1               \ Set X1 and x_hi to the high byte of XX in XX+1, so
 STA SX,Y               \ the new x-coordinate is in (x_hi x_lo) and the high
 STA X1                 \ byte is in X1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Master: See group A

 AND #%01111111         \ If |x_hi| >= 116 then jump to KILL2 to recycle this
 CMP #116               \ particle, as it's gone off the side of the screen,
 BCS KILL2              \ and re-join at STC2 with the new particle

ELIF _MASTER_VERSION

 AND #%01111111         \ Set A = ~|x_hi|, which is the same as -(x_hi + 1)
 EOR #%01111111         \ using two's complement

 CMP deltX              \ If deltX <= -(x_hi + 1), then the particle has been
 BCC KILL2              \ moved off the side of the screen and has wrapped
 BEQ KILL2              \ round to the other side, jump to KILL2 to recycle this
                        \ particle and re-join at STC2 with the new particle
                        \
                        \ In the other BBC versions, this test simply checks
                        \ whether |x_hi| >= 116, but this version using deltX
                        \ doesn't hard-code the screen width, so this is
                        \ presumably a change that was introduced to support
                        \ the different screen sizes of the other platforms

ENDIF

 LDA YY+1               \ Set Y1 and y_hi to the high byte of YY in YY+1, so
 STA SY,Y               \ the new x-coordinate is in (y_hi y_lo) and the high
 STA Y1                 \ byte is in Y1

 AND #%01111111         \ If |y_hi| >= 116 then jump to ST5 to recycle this
 CMP #116               \ particle, as it's gone off the top or bottom of the
 BCS ST5                \ screen, and re-join at STC2 with the new particle

.STC2

 JSR PIXEL2             \ Draw a stardust particle at (X1,Y1) with distance ZZ,
                        \ i.e. draw the newly moved particle at (x_hi, y_hi)
                        \ with distance z_hi

 DEY                    \ Decrement the loop counter to point to the next
                        \ stardust particle

 BEQ ST2                \ If we have just done the last particle, skip the next
                        \ instruction to return from the subroutine

 JMP STL2               \ We have more stardust to process, so jump back up to
                        \ STL2 for the next particle

                        \ Fall through into ST2 to restore the signs of the
                        \ following if this is the right view: ALPHA, ALP2,
                        \ ALP2+1, BET2 and BET2+1

.ST2

 LDA ALPHA              \ If this is the right view, flip the sign of ALPHA
 EOR RAT
 STA ALPHA

 LDA ALP2               \ If this is the right view, flip the sign of ALP2
 EOR RAT
 STA ALP2

 EOR #%10000000         \ If this is the right view, flip the sign of ALP2+1
 STA ALP2+1

 LDA BET2               \ If this is the right view, flip the sign of BET2
 EOR RAT
 STA BET2

 EOR #%10000000         \ If this is the right view, flip the sign of BET2+1
 STA BET2+1

 RTS                    \ Return from the subroutine

.KILL2

 JSR DORND              \ Set A and X to random numbers

 STA Y1                 \ Set y_hi and Y1 to random numbers, so the particle
 STA SY,Y               \ starts anywhere along the y-axis

 LDA #115               \ Make sure A is at least 115 and has the sign in RAT
 ORA RAT

 STA X1                 \ Set x_hi and X1 to A, so this particle starts on the
 STA SX,Y               \ correct edge of the screen for new particles

 BNE STF1               \ Jump down to STF1 to set the z-coordinate (this BNE is
                        \ effectively a JMP as A will never be zero)

.ST5

 JSR DORND              \ Set A and X to random numbers

 STA X1                 \ Set x_hi and X1 to random numbers, so the particle
 STA SX,Y               \ starts anywhere along the x-axis

 LDA #110               \ Make sure A is at least 110 and has the sign in AL2+1,
 ORA ALP2+1             \ the flipped sign of the roll angle alpha

 STA Y1                 \ Set y_hi and Y1 to A, so the particle starts at the
 STA SY,Y               \ top or bottom edge, depending on the current roll
                        \ angle alpha

.STF1

 JSR DORND              \ Set A and X to random numbers

 ORA #8                 \ Make sure A is at least 8 and store it in z_hi and
 STA ZZ                 \ ZZ, so the new particle starts at any distance from
 STA SZ,Y               \ us, but not too close

 BNE STC2               \ Jump up to STC2 to draw this new particle (this BNE is
                        \ effectively a JMP as A will never be zero)

