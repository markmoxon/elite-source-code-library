\ ******************************************************************************
\
\       Name: PLANET
\       Type: Subroutine
\   Category: Drawing planets
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Draw the planet or sun
ELIF _ELECTRON_VERSION
\    Summary: Draw the planet
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   INWK                The planet or sun's ship data block
ELIF _ELECTRON_VERSION
\   INWK                The planet's ship data block
ENDIF
\
\ ******************************************************************************

IF _NES_VERSION

.PL2

 RTS                    \ Return from the subroutine

ENDIF

.PLANET

IF _ELECTRON_VERSION \ Electron: In the Electron version, the PLANET routine only draws planets and will terminate if asked to draw a sun

 LDA TYPE               \ If bit 0 of the ship type is set, then this is 129,
 LSR A                  \ which is the placeholder used to denote there is no
 BCS PL2-1              \ space station, so return from the subroutine (as PL2-1
                        \ contains an RTS)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #GREEN             \ Send a #SETCOL GREEN command to the I/O processor to
 JSR DOCOL              \ switch to stripe 3-1-3-1, which is cyan/yellow in the
                        \ space view

ELIF _MASTER_VERSION


 LDA #GREEN             \ Switch to stripe 3-1-3-1, which is cyan/yellow in the
 STA COL                \ space view

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 LDA INWK+8             \ Set A = z_sign (the highest byte in the planet/sun's
                        \ coordinates)

ELIF _ELECTRON_VERSION

 LDA INWK+8             \ Set A = z_sign (the highest byte in the planet's
                        \ coordinates)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Other: In the cassette version, in part 14 of the main flight loop, we didn't remove the planet/sun if it was behind us, so we do it here instead

 BMI PL2                \ If A is negative then the planet/sun is behind us, so
                        \ jump to PL2 to remove it from the screen, returning
                        \ from the subroutine using a tail call

ELIF _ELECTRON_VERSION

 BMI PL2                \ If A is negative then the planet is behind us, so
                        \ jump to PL2 to remove it from the screen, returning
                        \ from the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

\BMI PL2                \ This instruction is commented out in the original
                        \ source. It would remove the planet from the screen
                        \ when it's behind us

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 CMP #48                \ If A >= 48 then the planet/sun is too far away to be
 BCS PL2                \ seen, so jump to PL2 to remove it from the screen,
                        \ returning from the subroutine using a tail call

 ORA INWK+7             \ Set A to 0 if both z_sign and z_hi are 0

 BEQ PL2                \ If both z_sign and z_hi are 0, then the planet/sun is
                        \ too close to be shown, so jump to PL2 to remove it
                        \ from the screen, returning from the subroutine using a
                        \ tail call

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

ELIF _ELECTRON_VERSION

 CMP #48                \ If A >= 48 then the planet is too far away to be
 BCS PL2                \ seen, so jump to PL2 to remove it from the screen,
                        \ returning from the subroutine using a tail call

 ORA INWK+7             \ Set A to 0 if both z_sign and z_hi are 0

 BEQ PL2                \ If both z_sign and z_hi are 0, then the planet/sun is
                        \ too close to be shown, so jump to PL2 to remove it
                        \ from the screen, returning from the subroutine using a
                        \ tail call

 JSR PROJ               \ Project the planet onto the screen, returning the
                        \ centre's coordinates in K3(1 0) and K4(1 0)

 BCS PL2                \ If the C flag is set by PROJ then the planet is
                        \ not visible on-screen, so jump to PL2 to remove it
                        \ from the screen, returning from the subroutine using
                        \ a tail call

 LDA #96                \ Set (A P+1 P) = (0 96 0) = 24576
 STA P+1                \
 LDA #0                 \ This represents the planet's radius at a distance
 STA P                  \ of z = 1

 JSR DVID3B2            \ Call DVID3B2 to calculate:
                        \
                        \   K(3 2 1 0) = (A P+1 P) / (z_sign z_hi z_lo)
                        \              = (0 96 0) / z
                        \              = 24576 / z
                        \
                        \ so K now contains the planet's radius, reduced by
                        \ the actual distance to the planet. We know that
                        \ K+3 and K+2 will be 0, as the number we are dividing,
                        \ (0 96 0), fits into the two bottom bytes, so the
                        \ result is actually in K(1 0)

ENDIF

 LDA K+1                \ If the high byte of the reduced radius is zero, jump
 BEQ PL82               \ to PL82, as K contains the radius on its own

 LDA #248               \ Otherwise set K = 248, to round up the radius in
 STA K                  \ K(1 0) to the nearest integer (if we consider the low
                        \ byte to be the fractional part)

.PL82

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: Planets in the Electron version are simple circles, so the code to draw meridians and craters is omitted, and the simple CIRCLE routine is used instead

 LDA TYPE               \ If the planet/sun's type has bit 0 clear, then it's
 LSR A                  \ either 128 or 130, which is a planet (the sun has type
 BCC PL9                \ 129, which has bit 0 set). So jump to PL9 to draw the
                        \ planet with radius K, returning from the subroutine
                        \ using a tail call

 JMP SUN                \ Otherwise jump to SUN to draw the sun with radius K,
                        \ returning from the subroutine using a tail call

ELIF _ELECTRON_VERSION

 JSR WPLS2              \ Call WPLS2 to remove the planet from the screen

 JMP CIRCLE             \ Jump to CIRCLE to draw the planet (which is just a
                        \ simple circle) and return from the subroutine using
                        \ a tail call

ENDIF

