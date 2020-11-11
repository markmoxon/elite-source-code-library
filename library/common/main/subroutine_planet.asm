\ ******************************************************************************
\
\       Name: PLANET
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw the planet or sun
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INWK                The planet or sun's ship data block
\
\ ******************************************************************************

.PLANET

IF _6502SP_VERSION

 LDA #GREEN
 JSR DOCOL

ENDIF

 LDA INWK+8             \ Set A = z_sign (the highest byte in the planet/sun's
                        \ coordinates)

IF _CASSETTE_VERSION

 BMI PL2                \ If A is negative then the planet/sun is behind us, so
                        \ jump to PL2 to remove it from the screen, returning
                        \ from the subroutine using a tail call

ELIF _6502SP_VERSION

\BMI PL2

ENDIF

 CMP #48                \ If A >= 48 then the planet/sun is too far away to be
 BCS PL2                \ seen, so jump to PL2 to remove it from the screen,
                        \ returning from the subroutine using a tail call

 ORA INWK+7             \ Set A to z_sign OR z_hi to get the maximum of the two

 BEQ PL2                \ If the maximum is 0, then the planet/sun is too close
                        \ to be shown, so jump to PL2 to remove it from the
                        \ screen, returning from the subroutine using a tail
                        \ call

 JSR PROJ               \ Project the planet/sun onto the screen, returning the
                        \ centre's coordinates in K3(1 0) and K4(1 0)

 BCS PL2                \ If the C flag is set by PROJ then the planet/sun is
                        \ not visible on-screen, so jump to PL2 to remove it
                        \ from the screen, returning from the subroutine using
                        \ a tail call

 LDA #96                \ Set (A P+1 P) = (0 96 0) = 24576
 STA P+1                \
 LDA #0                 \ This represents the planet/sun's radius at a distance
 STA P                  \ of z = 1

 JSR DVID3B2            \ Call DVID3B2 to calculate:
                        \
                        \   K(3 2 1 0) = (A P+1 P) / (z_sign z_hi z_lo)
                        \              = (0 96 0) / z
                        \              = 24576 / z
                        \
                        \ so K now contains the planet/sun's radius, reduced by
                        \ the actual distance to the planet/sun. We know that
                        \ K+3 and K+2 will be 0, as the number we are dividing,
                        \ (0 96 0), fits into the two bottom bytes, so the
                        \ result is actually in K(1 0)

 LDA K+1                \ If the high byte of the reduced radius is zero, jump
 BEQ PL82               \ to PL82, as K contains the radius on its own

 LDA #248               \ Otherwise set K = 248, to use as our one-byte radius
 STA K

.PL82

 LDA TYPE               \ If the planet/sun's type has bit 0 clear, then it's
 LSR A                  \ either 128 or 130, which is a planet (the sun has type
 BCC PL9                \ 129, which has bit 0 set). So jump to PL9 to draw the
                        \ planet with radius K, returning from the subroutine
                        \ using a tail call

 JMP SUN                \ Otherwise jump to SUN to draw the sun with radius K,
                        \ returning from the subroutine using a tail call

