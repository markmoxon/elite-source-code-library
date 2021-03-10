\ ******************************************************************************
\
\       Name: SOLAR
\       Type: Subroutine
\   Category: Universe
\    Summary: Set up various aspects of arriving in a new system
\
\ ------------------------------------------------------------------------------
\
\ Halve our legal status, update the missile indicators, and set up data blocks
\ and slots for the planet and sun.
\
\ ******************************************************************************

.SOLAR

 LSR FIST               \ Halve our legal status in FIST, making us less bad,
                        \ and moving bit 0 into the C flag (so every time we
                        \ arrive in a new system, our legal status improves a
                        \ bit)

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace, which
                        \ doesn't affect the C flag

 LDA QQ15+1             \ Fetch s0_hi

IF _CASSETTE_VERSION \ Standard: When generating system data in the cassette version, the initial position of the planet is calculated using bits 0-2 of the system's s0_hi seed, but in the other versions only bits 0-1 of s0_hi are used

 AND #%00000111         \ Extract bits 0-2 (which also happen to determine the
                        \ economy), which will be between 0 and 7

 ADC #6                 \ Add 6 + C, and divide by 2, to get a result between 3
 LSR A                  \ and 7, at the same time shifting bit 0 of the result
                        \ of the addition into the C flag

ELIF _6502SP_VERSION OR _DISC_VERSION

 AND #%00000011         \ Extract bits 0-1 (which also help to determine the
                        \ economy), which will be between 0 and 3

 ADC #3                 \ Add 3 + C, to get a result between 3 and 7, clearing
                        \ the C flag in the process

ENDIF

 STA INWK+8             \ Store the result in z_sign in byte #6

IF _CASSETTE_VERSION \ Standard: In the cassette version, the initial position of the planet can be to the upper right or lower left, but in the other versions it's always to the upper right

 ROR A                  \ Halve A, rotating in the C flag, which was previously
 STA INWK+2             \ bit 0 of s0_hi + 6 + C, so when this is stored in both
 STA INWK+5             \ x_sign and y_sign, it moves the planet to the upper
                        \ right or lower left

ELIF _6502SP_VERSION OR _DISC_VERSION

 ROR A                  \ Halve A, rotating in the C flag (which is clear) and
 STA INWK+2             \ store in both x_sign and y_sign, moving the planet to
 STA INWK+5             \ the upper right

ENDIF

 JSR SOS1               \ Call SOS1 to set up the planet's data block and add it
                        \ to FRIN, where it will get put in the first slot as
                        \ it's the first one to be added to our local bubble of
                        \ this new system's universe

 LDA QQ15+3             \ Fetch s1_hi, extract bits 0-2, set bits 0 and 7 and
 AND #%00000111         \ store in z_sign, so the sun is behind us at a distance
 ORA #%10000001         \ of 1 to 7
 STA INWK+8

 LDA QQ15+5             \ Fetch s2_hi, extract bits 0-1 and store in x_sign and
 AND #%00000011         \ y_sign, so the sun is either dead in our rear laser
 STA INWK+2             \ crosshairs, or off to the top left by a distance of 1
 STA INWK+1             \ or 2 when we look out the back

 LDA #0                 \ Set the pitch and roll counters to 0 (no rotation)
 STA INWK+29
 STA INWK+30

 LDA #129               \ Set A = 129, the "ship" type for the sun

 JSR NWSHP              \ Call NWSHP to set up the sun's data block and add it
                        \ to FRIN, where it will get put in the second slot as
                        \ it's the second one to be added to our local bubble
                        \ of this new system's universe

