\ ******************************************************************************
\
\       Name: MVEIT (Part 4 of 9)
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

 LDY #15                \ Fetch byte #15 from the ship's blueprint, which
                        \ contains the ship's maximum speed

 CMP (XX0),Y            \ If A < the ship's maximum speed, skip the following
 BCC P%+4               \ instruction

 LDA (XX0),Y            \ Set A to the ship's maximum speed

 STA INWK+27            \ We have now calculated the new ship's speed after
                        \ accelerating and keeping the speed within the ship's
                        \ limits, so store the updated speed in byte #27

 LDA #0                 \ We have added the ship's acceleration, so we now set
 STA INWK+28            \ it back to 0 in byte #28, as it's a one-off change

