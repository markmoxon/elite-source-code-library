\ ******************************************************************************
\
IF NOT(_ELITE_A_6502SP_PARA)
\       Name: MVEIT (Part 4 of 9)
ELIF _ELITE_A_6502SP_PARA
\       Name: MVEIT_FLIGHT (Part 4 of 6)
ENDIF
\       Type: Subroutine
\   Category: Moving
\    Summary: Move current ship: Apply acceleration to ship's speed as a one-off
\
\ ------------------------------------------------------------------------------
\
\ This routine has multiple stages. This stage does the following:
\
\   * Apply acceleration to the ship's speed (if acceleration is non-zero),
\     and then zero the acceleration as it's a one-off change
\
\ ******************************************************************************

 LDA INWK+27            \ Set A = the ship's speed in byte #24 + the ship's
 CLC                    \ acceleration in byte #28
 ADC INWK+28

 BPL P%+4               \ If the result is positive, skip the following
                        \ instruction

 LDA #0                 \ Set A to 0 to stop the speed from going negative

IF NOT(_NES_VERSION)

 LDY #15                \ We now fetch byte #15 from the ship's blueprint, which
                        \ contains the ship's maximum speed, so set Y = 15 to
                        \ use as an index

 CMP (XX0),Y            \ If A < the ship's maximum speed, skip the following
 BCC P%+4               \ instruction

 LDA (XX0),Y            \ Set A to the ship's maximum speed

 STA INWK+27            \ We have now calculated the new ship's speed after
                        \ accelerating and keeping the speed within the ship's
                        \ limits, so store the updated speed in byte #27

ELIF _NES_VERSION

 STA INWK+27            \ Store the updated speed in byte #27

 LDY #15                \ Set A to byte #15 from the current ship blueprint,
 JSR GetShipBlueprint   \ which contains the ship's maximum speed

 CMP INWK+27            \ If A >= the ship's current speed, skip the following
 BCS P%+4               \ instruction as the speed is already in the correct
                        \ range

 STA INWK+27            \ Otherwise store the maximum speed in byte #27

ENDIF

 LDA #0                 \ We have added the ship's acceleration, so we now set
 STA INWK+28            \ it back to 0 in byte #28, as it's a one-off change

