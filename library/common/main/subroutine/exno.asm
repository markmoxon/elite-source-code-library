\ ******************************************************************************
\
\       Name: EXNO
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a laser strike or ship explosion
\
\ ------------------------------------------------------------------------------
\
\ Make the two-part explosion sound of us making a laser strike, or of another
\ ship exploding.
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ The volume of the first explosion is affected by the distance of the ship
\ being hit, with more distant ships being quieter. The value in X also affects
\ the volume of the first explosion, with a higher X giving a quieter sound
\ (so X can be used to differentiate a laser strike from an explosion).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The larger the value of X, the fainter the explosion.
\                       Allowed values are:
\
\                         * 7  = explosion is louder (i.e. the ship has just
\                                exploded)
\
\                         * 15 = explosion is quieter (i.e. this is just a laser
\                                strike)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   EXNO-2              Set X = 7 and fall through into EXNO to make the sound
\                       of a ship exploding
\
ENDIF
IF _ELITE_A_FLIGHT
\   n_sound10           Make the first part of the death sound, or the second
\                       part of the explosion sound
\
ELIF _ELITE_A_6502SP_PARA
\   sound_10            Make the first part of the death sound, or the second
\                       part of the explosion sound
\
ENDIF
\ ******************************************************************************

.EXNO

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 STX T                  \ Store the distance in T

 LDA #24                \ Set A = 24 to denote the sound of us making a hit or
 JSR NOS1               \ kill (part 1 of the explosion), and call NOS1 to set
                        \ up the sound block in XX16

ELIF _MASTER_VERSION

 LDY #sohit             \ Call the NOISE routine with Y = 6 to make the sound of
 JMP NOISE              \ us making a hit or kill and return from the subroutine
                        \ using a tail call

ELIF _NES_VERSION

 LDY #10                \ Call the NOISE routine with Y = 10 to make the sound
 JMP NOISE              \ of us making a hit or kill and return from the
                        \ subroutine using a tail call

ENDIF

IF _6502SP_VERSION \ Other: The 6502SP version contains a bug fix to make sure very distant ships (i.e. where z_sign is non-zero) explode silently

 LDA INWK+8             \ Fetch z_sign, the distance of the ship being hit in
 ASL A                  \ terms of the z-axis (in and out of the screen), and
                        \ shift it left by 1 to get rid of the sign bit

 BEQ P%+5               \ If the result is 0, skip the next two instructions
                        \ so that we load A with z_hi below

 LDA #0                 \ Set A = 0

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A5 &4C, or BIT &4CA5, which does nothing apart
                        \ from affect the flags

                        \ So, by this point, if any of bits 0-6 of z_sign are
                        \ non-zero, which means the ship is a long way away,
                        \ then A will be set to 0 rather than z_hi and the next
                        \ instruction gets skipped, so we end up with a volume
                        \ of 0. This fixes a bug in the other versions which
                        \ ignore the value of z_sign when calculating explosion
                        \ volume, which means very distant ships can still be
                        \ heard

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDA INWK+7             \ Fetch z_hi, the distance of the ship being hit in
 LSR A                  \ terms of the z-axis (in and out of the screen), and
 LSR A                  \ divide by 4. If z_hi has either bit 6 or 7 set then
                        \ that ship is too far away to be shown on the scanner
                        \ (as per the SCAN routine), so we know the maximum
                        \ z_hi at this point is %00111111, and shifting z_hi
                        \ to the right twice gives us a maximum value of
                        \ %00001111

 AND T                  \ This reduces A to a maximum of X; X can be either
                        \ 7 = %0111 or 15 = %1111, so AND'ing with 15 will
                        \ not affect A, while AND'ing with 7 will clear bit
                        \ 3, reducing the maximum value in A to 7

 ORA #%11110001         \ The SOUND statement's amplitude ranges from 0 (for no
                        \ sound) to -15 (full volume), so we can set bits 0 and
                        \ 4-7 in A, and keep bits 1-3 from the above to get
                        \ a value between -15 (%11110001) and -1 (%11111111),
                        \ with lower values of z_hi and argument X leading
                        \ to a more negative, or quieter number (so the closer
                        \ the ship, i.e. the smaller the value of X, the louder
                        \ the sound)

 STA XX16+2             \ The amplitude byte of the sound block in XX16 is in
                        \ byte #3 (where it's the low byte of the amplitude), so
                        \ this sets the amplitude to the value in A

 JSR NO3                \ Make the sound from our updated sound block in XX16

 LDA #16                \ Set A = 16 to denote we have made a hit or kill
                        \ (part 2 of the explosion), and fall through into NOISE
                        \ to make the sound

ELIF _ELITE_A_FLIGHT

 LDA INWK+7             \ Fetch z_hi, the distance of the ship being hit in
 LSR A                  \ terms of the z-axis (in and out of the screen), and
 LSR A                  \ divide by 4. If z_hi has either bit 6 or 7 set then
                        \ that ship is too far away to be shown on the scanner
                        \ (as per the SCAN routine), so we know the maximum
                        \ z_hi at this point is %00111111, and shifting z_hi
                        \ to the right twice gives us a maximum value of
                        \ %00001111

 AND T                  \ This reduces A to a maximum of X; X can be either
                        \ 7 = %0111 or 15 = %1111, so AND'ing with 15 will
                        \ not affect A, while AND'ing with 7 will clear bit
                        \ 3, reducing the maximum value in A to 7

 ORA #%11110001         \ The SOUND statement's amplitude ranges from 0 (for no
                        \ sound) to -15 (full volume), so we can set bits 0 and
                        \ 4-7 in A, and keep bits 1-3 from the above to get
                        \ a value between -15 (%11110001) and -1 (%11111111),
                        \ with lower values of z_hi and argument X leading
                        \ to a more negative, or quieter number (so the closer
                        \ the ship, i.e. the smaller the value of X, the louder
                        \ the sound)

 STA XX16+2             \ The amplitude byte of the sound block in XX16 is in
                        \ byte #3 (where it's the low byte of the amplitude), so
                        \ this sets the amplitude to the value in A

 JSR NO3                \ Make the sound from our updated sound block in XX16

.n_sound10

 LDA #16                \ Set A = 16 to denote we have made a hit or kill
                        \ (part 2 of the explosion), and fall through into NOISE
                        \ to make the sound

ELIF _ELITE_A_6502SP_PARA

 LDA INWK+7             \ Fetch z_hi, the distance of the ship being hit in
 LSR A                  \ terms of the z-axis (in and out of the screen), and
 LSR A                  \ divide by 4. If z_hi has either bit 6 or 7 set then
                        \ that ship is too far away to be shown on the scanner
                        \ (as per the SCAN routine), so we know the maximum
                        \ z_hi at this point is %00111111, and shifting z_hi
                        \ to the right twice gives us a maximum value of
                        \ %00001111

 AND T                  \ This reduces A to a maximum of X; X can be either
                        \ 7 = %0111 or 15 = %1111, so AND'ing with 15 will
                        \ not affect A, while AND'ing with 7 will clear bit
                        \ 3, reducing the maximum value in A to 7

 ORA #%11110001         \ The SOUND statement's amplitude ranges from 0 (for no
                        \ sound) to -15 (full volume), so we can set bits 0 and
                        \ 4-7 in A, and keep bits 1-3 from the above to get
                        \ a value between -15 (%11110001) and -1 (%11111111),
                        \ with lower values of z_hi and argument X leading
                        \ to a more negative, or quieter number (so the closer
                        \ the ship, i.e. the smaller the value of X, the louder
                        \ the sound)

 STA XX16+2             \ The amplitude byte of the sound block in XX16 is in
                        \ byte #3 (where it's the low byte of the amplitude), so
                        \ this sets the amplitude to the value in A

 JSR NO3                \ Make the sound from our updated sound block in XX16

.sound_10

 LDA #16                \ Set A = 16 to denote we have made a hit or kill
                        \ (part 2 of the explosion)

 JMP NOISE              \ Jump to NOISE to make the sound and return from the
                        \ subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &20, or BIT &20A9, which does nothing apart
                        \ from affect the flags

ENDIF

