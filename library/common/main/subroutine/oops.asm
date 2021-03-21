\ ******************************************************************************
\
\       Name: OOPS
\       Type: Subroutine
\   Category: Flight
\    Summary: Take some damage
\
\ ------------------------------------------------------------------------------
\
\ We just took some damage, so reduce the shields if we have any, or reduce the
\ energy levels and potentially take some damage to the cargo if we don't.
\
\ Arguments:
\
\   A                   The amount of damage to take
\
\   INF                 The address of the ship block for the ship that attacked
\                       us, or the ship that we just ran into
\
\ ******************************************************************************

.OOPS

 STA T                  \ Store the amount of damage in T

IF _CASSETTE_VERSION \ Minor

 LDY #8                 \ Fetch byte #8 (z_sign) for the ship attacking us, and
 LDX #0                 \ set X = 0
 LDA (INF),Y

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDX #0                 \ Fetch byte #8 (z_sign) for the ship attacking us, and
 LDY #8                 \ set X = 0
 LDA (INF),Y

ENDIF

 BMI OO1                \ If A is negative, then we got hit in the rear, so jump
                        \ to OO1 to process damage to the aft shield

 LDA FSH                \ Otherwise the forward shield was damaged, so fetch the
 SBC T                  \ shield strength from FSH and subtract the damage in T

 BCC OO2                \ If the C flag is clear then this amount of damage was
                        \ too much for the shields, so jump to OO2 to set the
                        \ shield level to 0 and start taking damage directly
                        \ from the energy banks

 STA FSH                \ Store the new value of the forward shield in FSH

 RTS                    \ Return from the subroutine

.OO2

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Minor

\LDX #0                 \ This instruction is commented out in the original
                        \ source, and isn't required as X is set to 0 above

 STX FSH                \ Set the forward shield to 0

ELIF _6502SP_VERSION

 STZ FSH                \ Set the forward shield to 0

ELIF _MASTER_VERSION

 LDX #0                \ Set the forward shield to 0
 STX FSH

ENDIF

 BCC OO3                \ Jump to OO3 to start taking damage directly from the
                        \ energy banks (this BCC is effectively a JMP as the C
                        \ flag is clear, as we jumped to OO2 with a BCC)

.OO1

 LDA ASH                \ The aft shield was damaged, so fetch the shield
 SBC T                  \ strength from ASH and subtract the damage in T

 BCC OO5                \ If the C flag is clear then this amount of damage was
                        \ too much for the shields, so jump to OO5 to set the
                        \ shield level to 0 and start taking damage directly
                        \ from the energy banks

 STA ASH                \ Store the new value of the aft shield in ASH

 RTS                    \ Return from the subroutine

.OO5

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Minor

\LDX #0                 \ This instruction is commented out in the original
                        \ source, and isn't required as X is set to 0 above

 STX ASH                \ Set the aft shield to 0

ELIF _6502SP_VERSION

 STZ ASH                \ Set the aft shield to 0

ELIF _MASTER_VERSION

 LDX #0                \ Set the forward shield to 0
 STX ASH

ENDIF

.OO3

 ADC ENERGY             \ A is negative and contains the amount by which the
 STA ENERGY             \ damage overwhelmed the shields, so this drains the
                        \ energy banks by that amount (and because the energy
                        \ banks are shown over four indicators rather than one,
                        \ but with the same value range of 0-255, energy will
                        \ appear to drain away four times faster than the
                        \ shields did)

 BEQ P%+4               \ If we have just run out of energy, skip the next
                        \ instruction to jump straight to our death

 BCS P%+5               \ If the C flag is set, then subtracting the damage from
                        \ the energy banks didn't underflow, so we had enough
                        \ energy to survive, and we can skip the next
                        \ instruction to make a sound and take some damage

 JMP DEATH              \ Otherwise our energy levels are either 0 or negative,
                        \ and in either case that means we jump to our DEATH,
                        \ returning from the subroutine using a tail call

 JSR EXNO3              \ We didn't die, so call EXNO3 to make the sound of a
                        \ collision

 JMP OUCH               \ And jump to OUCH to take damage and return from the
                        \ subroutine using a tail call

