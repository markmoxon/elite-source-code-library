\ ******************************************************************************
\
\       Name: SOLAR
\       Type: Subroutine
\   Category: Universe
\    Summary: Set up various aspects of arriving in a new system
\  Deep dive: A sense of scale
IF _NES_VERSION OR _C64_VERSION
\             The Trumbles mission
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\ Halve our legal status, update the missile indicators, and set up data blocks
\ and slots for the planet and sun.
ELIF _ELECTRON_VERSION
\ Halve our legal status, update the missile indicators, and set up the data
\ block and slot for the planet.
ENDIF
\
\ ******************************************************************************

.SOLAR

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: The Master version runs an extra bit of code when arriving in a new system that is responsible for breeding any Trumbles in the hold, though as there are no Trumbles in the BBC versions of the game, this never actually breeds anything

 LDA TRIBBLE            \ If we have no Trumbles in the hold, skip to nobirths
 BEQ nobirths

                        \ If we get here then we have Trumbles in the hold, so
                        \ this is where they breed (though we never get here in
                        \ the Master version as the number of Trumbles is always
                        \ zero)

 LDA #0                 \ Trumbles eat food and narcotics during the hyperspace
 STA QQ20               \ journey, so zero the amount of food and narcotics in
 STA QQ20+6             \ the hold

 JSR DORND              \ Take the number of Trumbles from TRIBBLE(1 0), add a
 AND #15                \ random number between 4 and 15, and double the result,
 ADC TRIBBLE            \ storing the resulting number in TRIBBLE(1 0)
 ORA #4                 \
 ROL A                  \ We start with the low byte
 STA TRIBBLE

 ROL TRIBBLE+1          \ And then do the high byte

 BPL P%+5               \ If bit 7 of the high byte is set, then rotate the high
 ROR TRIBBLE+1          \ byte back to the right, so the number of Trumbles is
                        \ always positive

.nobirths

ELIF _NES_VERSION

 LDA TRIBBLE            \ If we have no Trumbles in the hold, skip to nobirths
 BEQ nobirths

                        \ If we get here then we have Trumbles in the hold, so
                        \ this is where they breed

 LDA #0                 \ Trumbles eat food during the hyperspace journey, so
 STA QQ20               \ zero the amount of food in the hold

 JSR DORND              \ Take the number of Trumbles from TRIBBLE(1 0), add a
 AND #15                \ random number between 4 and 15, and double the result,
 ADC TRIBBLE            \ storing the resulting number in TRIBBLE(1 0)
 ORA #4                 \
 ROL A                  \ We start with the low byte
 STA TRIBBLE

 ROL TRIBBLE+1          \ And then do the high byte

 BPL P%+5               \ If bit 7 of the high byte is set, then rotate the high
 ROR TRIBBLE+1          \ byte back to the right, so the number of Trumbles is
                        \ always positive

.nobirths

ENDIF

IF NOT(_ELITE_A_VERSION)

 LSR FIST               \ Halve our legal status in FIST, making us less bad,
                        \ and moving bit 0 into the C flag (so every time we
                        \ arrive in a new system, our legal status improves a
                        \ bit)

ELIF _ELITE_A_VERSION

                        \ We now want to extract bits 3-10 of QQ8(1 0) into A,
                        \ so we can subtract this value from our legal status in
                        \ FIST (so the further we travel, the quicker our legal
                        \ status drops back down to clean, as we put more
                        \ distance between us and our crimes - specifically, we
                        \ drop 1.2 FIST points for each light year, as we
                        \ subtract (QQ8 / 8) from FIST, and QQ8 contains the
                        \ distance in light years * 10)

 LDA QQ8                \ Set A to the low byte of the distance to the selected
                        \ system in QQ8(1 0), so (QQ8+1 A) contains the distance

 LDY #3                 \ We're going to extract bits 3-10 by shifting QQ8(1 0)
                        \ right by 3 places, so we start by setting a loop
                        \ counter in Y

.legal_div

 LSR QQ8+1              \ Shift (QQ8+1 A) to the right by one place
 ROR A

 DEY                    \ Decrement the loop counter

 BNE legal_div          \ Loop back until we have shifted right by 3 places, by
                        \ which point A will contain bits 3-10 of QQ8(1 0)

                        \ We now subtract A from FIST, and subtract 1 more,
                        \ making sure we don't reduce FIST beyond 0, which we do
                        \ by doing the subtraction in reverse and then negating
                        \ the result with one's complement

 SEC                    \ Set A = A - FIST (which we will negate later)
 SBC FIST

 BCC legal_over         \ If the subtraction underflowed, i.e. A < FIST, skip
                        \ the following instruction

 LDA #&FF               \ A > FIST, so we set A = &FF so the EOR flips this to
                        \ 0, so FIST gets set to 0 when we travel far enough to
                        \ clear our name

.legal_over

 EOR #&FF               \ Flip all the bits in A to negate the result, so if the
                        \ subtraction underflowed, i.e. A < FIST, we now have
                        \ A = FIST - A - 1

 STA FIST               \ Update the value of FIST to the new value in A

ENDIF

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace, which
                        \ doesn't affect the C flag

 LDA QQ15+1             \ Fetch s0_hi

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: When generating system data in the cassette and Electron versions, the initial position of the planet is calculated using bits 0-2 of the system's s0_hi seed, but in the other versions only bits 0-1 of s0_hi are used

 AND #%00000111         \ Extract bits 0-2 (which also happen to determine the
                        \ economy), which will be between 0 and 7

 ADC #6                 \ Add 6 + C, and divide by 2, to get a result between 3
 LSR A                  \ and 7, at the same time shifting bit 0 of the result
                        \ of the addition into the C flag

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 AND #%00000011         \ Extract bits 0-1 (which also help to determine the
                        \ economy), which will be between 0 and 3

 ADC #3                 \ Add 3 + C, to get a result between 3 and 7, clearing
                        \ the C flag in the process

ENDIF

 STA INWK+8             \ Store the result in z_sign in byte #6

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette and Electron versions, the initial position of the planet can be to the upper right or lower left, but in the other versions it's always to the upper right

 ROR A                  \ Halve A, rotating in the C flag, which was previously
 STA INWK+2             \ bit 0 of s0_hi + 6 + C, so when this is stored in both
 STA INWK+5             \ x_sign and y_sign, it moves the planet to the upper
                        \ right or lower left

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 ROR A                  \ Halve A, rotating in the C flag (which is clear) and
 STA INWK+2             \ store in both x_sign and y_sign, moving the planet to
 STA INWK+5             \ the upper right

ELIF _NES_VERSION

 LDX QQ15+2             \ Set the C flag if s1_lo >= 128, otherwise clear it
 CPX #128

 ROR A                  \ Halve A and set the sign bit to the C flag, and set
 STA INWK+2             \ x_sign to the result, so this moves the planet to the
                        \ right or left of centre

 ROL A                  \ Set A to x_sign << 1, ready for us to roll in the
                        \ sign bit again for y_sign

 LDX QQ15+3             \ Set the C flag if s1_hi >= 128, otherwise clear it
 CPX #128

 ROR A                  \ Set the sign bit to the C flag and set y_sign to the
 STA INWK+5             \ result, so this moves the planet up or down from the
                        \ centre

ENDIF

 JSR SOS1               \ Call SOS1 to set up the planet's data block and add it
                        \ to FRIN, where it will get put in the first slot as
                        \ it's the first one to be added to our local bubble of
                        \ this new system's universe

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: As there is no sun in the Electron version, there is no need to set up its position and distance on arrival in a new system

 LDA QQ15+3             \ Fetch s1_hi, extract bits 0-2, set bits 0 and 7 and
 AND #%00000111         \ store in z_sign, so the sun is behind us at a distance
 ORA #%10000001         \ of 1 to 7
 STA INWK+8

 LDA QQ15+5             \ Fetch s2_hi, extract bits 0-1 and store in x_sign and
 AND #%00000011         \ y_sign, so the sun is either dead centre in our rear
 STA INWK+2             \ laser crosshairs, or off to the top left by a distance
 STA INWK+1             \ of 1 or 2 when we look out the back

 LDA #0                 \ Set the pitch and roll counters to 0 (no rotation)
 STA INWK+29
 STA INWK+30

ENDIF

IF _NES_VERSION

 STA FRIN+1             \ Set the second slot in the FRIN table to 0, which
                        \ sets this slot to empty, so when we call NWSHP below
                        \ the new sun that gets created will go into FRIN+1

 STA SSPR               \ Set the "space station present" flag to 0, as we are
                        \ no longer in the space station's safe zone

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 LDA #129               \ Set A = 129, the ship type for the sun

 JSR NWSHP              \ Call NWSHP to set up the sun's data block and add it
                        \ to FRIN, where it will get put in the second slot as
                        \ it's the second one to be added to our local bubble
                        \ of this new system's universe

ELIF _ELECTRON_VERSION

 LDA #129               \ Set A = 129, the ship type for the placeholder, so
                        \ there isn't a space station, but there is a non-zero
                        \ ship type to indicate this

 JSR NWSHP              \ Call NWSHP to set up the new data block and add it
                        \ to FRIN, where it will get put in the second slot as
                        \ we just cleared out the second slot, and the first
                        \ slot is already taken by the planet

ENDIF

