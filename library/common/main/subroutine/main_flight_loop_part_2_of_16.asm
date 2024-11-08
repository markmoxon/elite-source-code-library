\ ******************************************************************************
\
\       Name: Main flight loop (Part 2 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Calculate the alpha and beta angles from the current pitch and
\             roll of our ship
\  Deep dive: Program flow of the main game loop
\             Pitching and rolling
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Calculate the alpha and beta angles from the current pitch and roll
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\ Here we take the current rate of pitch and roll, as set by the joystick or
\ keyboard, and convert them into alpha and beta angles that we can use in the
ELIF _NES_VERSION
\ Here we take the current rate of pitch and roll, as set by the controller,
\ and convert them into alpha and beta angles that we can use in the
ELIF _ELECTRON_VERSION
\ Here we take the current rate of pitch and roll, as set by the keyboard,
\ and convert them into alpha and beta angles that we can use in the
ENDIF
\ matrix functions to rotate space around our ship. The alpha angle covers
\ roll, while the beta angle covers pitch (there is no yaw in this version of
\ Elite). The angles are in radians, which allows us to use the small angle
\ approximation when moving objects in the sky (see the MVEIT routine for more
\ on this). Also, the signs of the two angles are stored separately, in both
\ the sign and the flipped sign, as this makes calculations easier.
\
\ ******************************************************************************

IF _NES_VERSION

                        \ We now check to see if we are allowed to make an
                        \ in-system jump, and set the allowInSystemJump flag
                        \ accordingly

 LDA auto               \ If auto is zero, then the docking computer is not
 BEQ main2              \ activated, so jump to main2 to move on to the next
                        \ check

 CLC                    \ The docking computer is activated, so clear the C flag
                        \ to put into bit 7 of allowInSystemJump, so the
                        \ Fast-forward button is enabled (so we can use it to
                        \ speed up docking)

 BCC main5              \ Jump to main5 to update allowInSystemJump (this BCC is
                        \ effectively a JMP as we know the C flag is clear)

.main2

 LDA MJ                 \ If MJ is zero then we are not in witchspace, so jump
 BEQ main3              \ to main3 to move on to the next check

 SEC                    \ We are in witchspace, so set the C flag to put into
                        \ bit 7 of allowInSystemJump, so in-system jumps are not
                        \ allowed

 BCS main5              \ Jump to main5 to update allowInSystemJump (this BCS is
                        \ effectively a JMP as we know the C flag is set)

.main3

                        \ If we get here then the docking computer is not
                        \ activated and we are not in witchspace

 LDA allowInSystemJump  \ If bit 7 of allowInSystemJump is clear then jump to
 BPL main4              \ to main4 to check whether we are too close to the
                        \ planet or sun to make an in-system jump

 LDA #176               \ Set A = 176 to use as the distance to check in the
                        \ following call to CheckJumpSafety
                        \
                        \ The default distance checks use A = 128, so this makes
                        \ the distance checks more stringent, as bit 7 of
                        \ allowInSystemJump is set, so we are need to be further
                        \ away from the danger to make a safe jump

 JSR CheckJumpSafety+2  \ Check whether we are far enough away from the planet
                        \ and sun to be able to do an in-system (fast-forward)
                        \ jump, returning the result in the C flag (clear means
                        \ we can jump, set means we can't), using the distance
                        \ in A

 JMP main5              \ Jump to main5 to update allowInSystemJump with the
                        \ result of the distance check

.main4

 JSR CheckJumpSafety    \ Check whether we are far enough away from the planet
                        \ and sun to be able to do an in-system (fast-forward)
                        \ jump, returning the result in the C flag (clear means
                        \ we can jump, set means we can't)

.main5

 ROR allowInSystemJump  \ Rotate the C flag into bit 7 of allowInSystemJump, so
                        \ in-system jumps are enabled or disabled accordingly

ENDIF

 LDX JSTX               \ Set X to the current rate of roll in JSTX

IF _ELITE_A_VERSION

 CPX new_max            \ If X < new_max (where new_max is our current ship's
 BCC n_highx            \ maximum roll rate), then jump to n_highx to skip the
                        \ following instruction

 LDX new_max            \ X is at least new_max, so set X to new_max so it is
                        \ never higher than our current ship's maximum roll rate

.n_highx

 CPX new_min            \ If X >= new_min (where new_min is our current ship's
 BCS n_lowx             \ minimum roll rate), then jump to n_lowx to skip the
                        \ following instruction

 LDX new_min            \ X is less than new_min, so set X to new_min so it is
                        \ never lower than our current ship's minimum roll rate

.n_lowx

ENDIF

IF NOT(_NES_VERSION)

 JSR cntr               \ Apply keyboard damping twice (if enabled) so the roll
 JSR cntr               \ rate in X creeps towards the centre by 2

                        \ The roll rate in JSTX increases if we press ">" (and
                        \ the RL indicator on the dashboard goes to the right)
                        \
                        \ This rolls our ship to the right (clockwise), but we
                        \ actually implement this by rolling everything else
                        \ to the left (anti-clockwise), so a positive roll rate
                        \ in JSTX translates to a negative roll angle alpha

ELIF _NES_VERSION

 LDY numberOfPilots     \ Set Y to the configured number of pilots, so the
                        \ following checks controller 1 when only one pilot
                        \ is playing, or controller 2 when two pilots are
                        \ playing

 LDA controller1Left,Y  \ If any of the left or right buttons are being pressed
 ORA controller1Right,Y \ on the controller that's responsible for steering,
 ORA KY3                \ jump to main6 to skip the following code so we do not
 ORA KY4                \ apply roll damping
 BMI main6

 LDA #16                \ Apply damping to the roll rate (if enabled), so the
 JSR cntr               \ roll rate in X creeps towards the centre by 16

.main6

                        \ The roll rate in JSTX increases if we press the right
                        \ button (and the RL indicator on the dashboard goes to
                        \ the right)
                        \
                        \ This rolls our ship to the right (clockwise), but we
                        \ actually implement this by rolling everything else
                        \ to the left (anti-clockwise), so a positive roll rate
                        \ in JSTX translates to a negative roll angle alpha

ENDIF

 TXA                    \ Set A and Y to the roll rate but with the sign bit
 EOR #%10000000         \ flipped (i.e. set them to the sign we want for alpha)
 TAY

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Minor

 AND #%10000000         \ Extract the flipped sign of the roll rate and store
 STA ALP2               \ in ALP2 (so ALP2 contains the sign of the roll angle
                        \ alpha)

ELIF _ELECTRON_VERSION

 AND #%10000000         \ Extract the flipped sign of the roll rate

 JMP P%+11              \ This skips over the following block of bytes, which
                        \ appear to be unused; it isn't clear what they do

 EQUB &A1, &BB          \ These bytes appear to be unused
 EQUB &80, &00
 EQUB &90, &01
 EQUB &D6, &F1

 STA ALP2               \ Store the flipped sign of the roll rate in ALP2 (so
                        \ ALP2 contains the sign of the roll angle alpha)

ENDIF

 STX JSTX               \ Update JSTX with the damped value that's still in X

 EOR #%10000000         \ Extract the correct sign of the roll rate and store
 STA ALP2+1             \ in ALP2+1 (so ALP2+1 contains the flipped sign of the
                        \ roll angle alpha)

 TYA                    \ Set A to the roll rate but with the sign bit flipped

 BPL P%+7               \ If the value of A is positive, skip the following
                        \ three instructions

 EOR #%11111111         \ A is negative, so change the sign of A using two's
 CLC                    \ complement so that A is now positive and contains
 ADC #1                 \ the absolute value of the roll rate, i.e. |JSTX|

 LSR A                  \ Divide the (positive) roll rate in A by 4
 LSR A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Other: The cassette has an extra CLC that isn't needed and could be culled

 CMP #8                 \ If A >= 8, skip the following two instructions
 BCS P%+4

 LSR A                  \ A < 8, so halve A again

 CLC                    \ This instruction has no effect, as we only get here
                        \ if the C flag is clear (if it is set, we skip this
                        \ instruction)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 CMP #8                 \ If A >= 8, skip the following instruction
 BCS P%+3

 LSR A                  \ A < 8, so halve A again

ENDIF

 STA ALP1               \ Store A in ALP1, so we now have:
                        \
                        \   ALP1 = |JSTX| / 8    if |JSTX| < 32
                        \
                        \   ALP1 = |JSTX| / 4    if |JSTX| >= 32
                        \
                        \ This means that at lower roll rates, the roll angle is
                        \ reduced closer to zero than at higher roll rates,
                        \ which gives us finer control over the ship's roll at
                        \ lower roll rates
                        \
                        \ Because JSTX is in the range -127 to +127, ALP1 is
                        \ in the range 0 to 31

 ORA ALP2               \ Store A in ALPHA, but with the sign set to ALP2 (so
 STA ALPHA              \ ALPHA has a different sign to the actual roll rate)

 LDX JSTY               \ Set X to the current rate of pitch in JSTY

IF _ELITE_A_VERSION

 CPX new_max            \ If X < new_max (where new_max is our current ship's
 BCC n_highy            \ maximum pitch rate), then jump to n_highy to skip the
                        \ following instruction

 LDX new_max            \ X is at least new_max, so set X to new_max so it is
                        \ never higher than our current ship's maximum pitch
                        \ rate

.n_highy

 CPX new_min            \ If X >= new_min (where new_min is our current ship's
 BCS n_lowy             \ minimum pitch rate), then jump to n_lowy to skip the
                        \ following instruction

 LDX new_min            \ X is less than new_min, so set X to new_min so it is
                        \ never lower than our current ship's minimum pitch rate

.n_lowy

ENDIF

IF NOT(_NES_VERSION)

 JSR cntr               \ Apply keyboard damping so the pitch rate in X creeps
                        \ towards the centre by 1

ELIF _NES_VERSION

 LDY numberOfPilots     \ Set Y to the configured number of pilots, so the
                        \ following checks controller 1 when only one pilot
                        \ is playing, or controller 2 when two pilots are
                        \ playing

 LDA controller1Up,Y    \ If any of the up or down buttons are being pressed
 ORA controller1Down,Y  \ on the controller that's responsible for steering,
 ORA KY5                \ jump to main6 to skip the following code so we do
 ORA KY6                \ not apply pitch damping
 BMI main7

 LDA #12                \ Apply damping to the pitch rate (if enabled), so the
 JSR cntr               \ pitch rate in X creeps towards the centre by 12

.main7

ENDIF

 TXA                    \ Set A and Y to the pitch rate but with the sign bit
 EOR #%10000000         \ flipped
 TAY

 AND #%10000000         \ Extract the flipped sign of the pitch rate into A

 STX JSTY               \ Update JSTY with the damped value that's still in X

 STA BET2+1             \ Store the flipped sign of the pitch rate in BET2+1

 EOR #%10000000         \ Extract the correct sign of the pitch rate and store
 STA BET2               \ it in BET2

 TYA                    \ Set A to the pitch rate but with the sign bit flipped

 BPL P%+4               \ If the value of A is positive, skip the following
                        \ instruction

 EOR #%11111111         \ A is negative, so flip the bits

IF NOT(_NES_VERSION)

 ADC #4                 \ Add 4 to the (positive) pitch rate, so the maximum
                        \ value is now up to 131 (rather than 127)

 LSR A                  \ Divide the (positive) pitch rate in A by 16
 LSR A
 LSR A
 LSR A

 CMP #3                 \ If A >= 3, skip the following instruction
 BCS P%+3

 LSR A                  \ A < 3, so halve A again

ELIF _NES_VERSION

 ADC #1                 \ Add 1 to the (positive) pitch rate, so the maximum
                        \ value is now up to 128 (rather than 127)

 LSR A                  \ Divide the (positive) pitch rate in A by 8
 LSR A
 LSR A

ENDIF

 STA BET1               \ Store A in BET1, so we now have:
                        \
                        \   BET1 = |JSTY| / 32    if |JSTY| < 48
                        \
                        \   BET1 = |JSTY| / 16    if |JSTY| >= 48
                        \
                        \ This means that at lower pitch rates, the pitch angle
                        \ is reduced closer to zero than at higher pitch rates,
                        \ which gives us finer control over the ship's pitch at
                        \ lower pitch rates
                        \
                        \ Because JSTY is in the range -131 to +131, BET1 is in
                        \ the range 0 to 8

 ORA BET2               \ Store A in BETA, but with the sign set to BET2 (so
 STA BETA               \ BETA has the same sign as the actual pitch rate)

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: To use a Bitsik with the enhanced versions, you need to configure it using the "B" option when paused, otherwise it will act like a normal joystick

 LDA BSTK               \ If BSTK = 0 then the Bitstik is not configured, so
 BEQ BS2                \ jump to BS2 to skip the following

ENDIF

IF _DISC_FLIGHT \ Platform

 LDX #3                 \ Call OSBYTE with A = 128 to fetch the 16-bit value
 LDA #128               \ from ADC channel 3 (the Bitstik rotation value),
 JSR OSBYTE             \ returning the value in (Y X)

 TYA                    \ Copy Y to A, so the result is now in (A X)

ELIF _6502SP_VERSION

 LDA KTRAN+10           \ Fetch the Bitstik rotation value (high byte) from the
                        \ key logger buffer

ELIF _MASTER_VERSION

 LDA JOPOS+2            \ Fetch the Bitstik rotation value (high byte) from
                        \ JOPOS+2, which is constantly updated with the high
                        \ byte of ADC channel 3 by the interrupt handler IRQ1

ENDIF

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: If you configure the enhanced versions to use a Bitstik, then you can change the ship's speed up and down by twisting the stick

 LSR A                  \ Divide A by 4
 LSR A

 CMP #40                \ If A < 40, skip the following instruction
 BCC P%+4

 LDA #40                \ Set A = 40, which ensures a maximum speed of 40

 STA DELTA              \ Update our speed in DELTA

 BNE MA4                \ If the speed we just set is non-zero, then jump to MA4
                        \ to skip the following, as we don't need to check the
                        \ keyboard for speed keys, otherwise do check the
                        \ keyboard (so Bitstik users can still use the keyboard
                        \ for speed adjustments if they twist the stick to zero)

ENDIF

