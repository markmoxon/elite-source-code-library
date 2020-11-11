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
\ The volume of the first explosion is affected by the distance of the ship
\ being hit, with more distant ships being quieter. The value in X also affects
\ the volume of the first explosion, with a higher X giving a quieter sound
\ (so X can be used to differentiate a laser strike from an explosion).
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
\ ******************************************************************************

.EXNO

 STX T                  \ Store the distance in T

 LDA #24                \ Set A = 24 to denote the sound of us making a hit or
 JSR NOS1               \ kill (part 1 of the explosion), and call NOS1 to set
                        \ up the sound block in XX16

IF _6502SP_VERSION

 LDA INWK+8
 ASL A
 BEQ P%+5
 LDA #0
 EQUB &2C

ENDIF

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

 ORA #%11110001         \ The SOUND command's amplitude ranges from 0 (for no
                        \ sound) to -15 (full volume), so we can set bits 0 and
                        \ 4-7 in A, and keep bits 1-3 from the above to get
                        \ a value between -15 (%11110001) and -1 (%11111111),
                        \ with lower values of z_hi and argument X leading
                        \ to a more negative number (so the closer the ship or
                        \ the smaller the value of X, the louder the sound)

 STA XX16+2             \ The amplitude byte of the sound block in XX16 is in
                        \ byte #3 (where it's the low byte of the amplitude), so
                        \ this sets the amplitude to the value in A

 JSR NO3                \ Make the sound from our updated sound block in XX16

 LDA #16                \ Set A = 16 to denote we have made a hit or kill
                        \ (part 2 of the explosion), and fall through into NOISE
                        \ to make the sound

IF _CASSETTE_VERSION

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &20, or BIT &20A9, which does nothing bar
                        \ affecting the flags

ENDIF

