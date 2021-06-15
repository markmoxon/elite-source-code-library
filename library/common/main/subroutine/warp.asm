\ ******************************************************************************
\
\       Name: WARP
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform an in-system jump
\
\ ------------------------------------------------------------------------------
\
\ This is called when we press "J" during flight. The following checks are
\ performed:
\
\   * Make sure we don't have any ships or space stations in the vicinity
\
\   * Make sure we are not in witchspace
\
\   * If we are facing the planet, make sure we aren't too close
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\   * If we are facing the sun, make sure we aren't too close
\
\ If the above checks are passed, then we perform an in-system jump by moving
\ the sun and planet in the opposite direction to travel, so we appear to jump
\ in space. This means that any asteroids, cargo canisters or escape pods get
\ dragged along for the ride.
ELIF _ELECTRON_VERSION
\ If the above checks are passed, then we perform an in-system jump by moving
\ the planet in the opposite direction to travel, so we appear to jump in
\ space. This means that any asteroids, cargo canisters or escape pods get
\ dragged along for the ride.
ENDIF
\
IF _ELITE_A_VERSION \ Comment
\ Other entry points:
\
\   WA1                 Make a long, low beep
\
ENDIF
\ ******************************************************************************

.WARP

IF _CASSETTE_VERSION \ Platform

 LDA MANY+AST           \ Set X to the total number of asteroids, escape pods
 CLC                    \ and cargo canisters in the vicinity
 ADC MANY+ESC           \
 CLC                    \ The second CLC instruction appears in the BASIC
 ADC MANY+OIL           \ source file (ELITEC), but not in the text source file
 TAX                    \ (ELITEC.TXT). The second CLC has no effect, as there
                        \ is no way that adding the number of asteroids and the
                        \ number escape pods will cause a carry, so presumably
                        \ it got removed at some point

ELIF _ELECTRON_VERSION

 LDA MANY+AST           \ Set X to the total number of asteroids, escape pods
 CLC                    \ and cargo canisters in the vicinity
 ADC MANY+ESC
 CLC                    \ The second CLC instruction has no effect, as there is
 ADC MANY+OIL           \ is no way that adding the number of asteroids and the
 TAX                    \ number escape pods will cause a carry

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDX JUNK               \ Set X to the total number of junk items in the
                        \ vicinity (e.g. asteroids, escape pods, cargo
                        \ canisters, Shuttles, Transporters and so pn)

ENDIF

 LDA FRIN+2,X           \ If the slot at FRIN+2+X is non-zero, then we have
                        \ something else in the vicinity besides asteroids,
                        \ escape pods and cargo canisters, so to check whether
                        \ we can jump, we first grab the slot contents into A

IF _ELITE_A_VERSION

 ORA JUNK               \ no jump if any ship AJD

ENDIF

 ORA SSPR               \ If there is a space station nearby, then SSPR will
                        \ be non-zero, so OR'ing with SSPR will produce a
                        \ a non-zero result if either A or SSPR are non-zero

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: The Electron version doesn't have witchspace, so there's no need to disable in-system jumping there

 ORA MJ                 \ If we are in witchspace, then MJ will be non-zero, so
                        \ OR'ing with MJ will produce a non-zero result if
                        \ either A or SSPR or MJ are non-zero

 BNE WA1                \ A is non-zero if we have either a ship or a space
                        \ station in the vicinity, or we are in witchspace, in
                        \ which case jump to WA1 to make a low beep to show that
                        \ we can't do an in-system jump

ELIF _ELECTRON_VERSION

 BNE WA1                \ A is non-zero if we have either a ship or a space
                        \ station in the vicinity, in which case jump to WA1 to
                        \ make a low beep to show that we can't do an in-system
                        \ jump

ENDIF

 LDY K%+8               \ Otherwise we can do an in-system jump, so now we fetch
                        \ the byte at K%+8, which contains the z_sign for the
                        \ first ship slot, i.e. the distance of the planet

 BMI WA3                \ If the planet's z_sign is negative, then the planet
                        \ is behind us, so jump to WA3 to skip the following

 TAY                    \ Set A = Y = 0 (as we didn't BNE above) so the call
                        \ to MAS2 measures the distance to the planet

 JSR MAS2               \ Call MAS2 to set A to the largest distance to the
                        \ planet in any of the three axes (we could also call
                        \ routine m to do the same thing, as A = 0)

IF _CASSETTE_VERSION \ Comment

                        \ The following two instructions appear in the BASIC
                        \ source file (ELITEC), but in the text source file
                        \ (ELITEC.TXT) they are replaced by:
                        \
                        \   LSR A
                        \   BEQ WA1
                        \
                        \ which does the same thing, but saves one byte of
                        \ memory (as LSR A is a one-byte opcode, while CMP #2
                        \ takes up two bytes)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 CMP #2                 \ If A < 2 then jump to WA1 to abort the in-system jump
 BCC WA1                \ with a low beep, as we are facing the planet and are
                        \ too close to jump in that direction

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION

 LSR A                  \ If A < 2 then jump to WA1 to abort the in-system jump
 BEQ WA1                \ with a low beep, as we are facing the planet and are
                        \ too close to jump in that direction

ENDIF

.WA3

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDY K%+NI%+8           \ Fetch the z_sign (byte #8) of the second ship in the
                        \ ship data workspace at K%, which is reserved for the
                        \ sun or the space station (in this case it's the
                        \ former, as we already confirmed there isn't a space
                        \ station in the vicinity)

 BMI WA2                \ If the sun's z_sign is negative, then the sun is
                        \ behind us, so jump to WA2 to skip the following

 LDY #NI%               \ Set Y to point to the offset of the ship data block
                        \ for the sun, which is NI% (as each block is NI% bytes
                        \ long, and the sun is the second block)

 JSR m                  \ Call m to set A to the largest distance to the sun
                        \ in any of the three axes

ELIF _ELECTRON_VERSION

 LDY K%+NI%+8           \ Fetch the z_sign (byte #8) of the second ship in the
                        \ ship data workspace at K%, which is reserved for the
                        \ space station

 BMI WA2                \ If the station's z_sign is negative, then it is
                        \ behind us, so jump to WA2 to skip the following

 LDY #NI%               \ Set Y to point to the offset of the ship data block
                        \ for the station, which is NI% (as each block is NI%
                        \ bytes long, and the station is the second block)

 JSR m                  \ Call m to set A to the largest distance to the station
                        \ in any of the three axes

ENDIF

IF _CASSETTE_VERSION \ Comment

                        \ The following two instructions appear in the BASIC
                        \ source file (ELITEC), but in the text source file
                        \ (ELITEC.TXT) they are replaced by:
                        \
                        \   LSR A
                        \   BEQ WA1
                        \
                        \ which does the same thing, but saves one byte of
                        \ memory (as LSR A is a one-byte opcode, while CMP #2
                        \ takes up two bytes)

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 CMP #2                 \ If A < 2 then jump to WA1 to abort the in-system jump
 BCC WA1                \ with a low beep, as we are facing the sun and are too
                        \ close to jump in that direction

ELIF _ELECTRON_VERSION

 CMP #2                 \ If A < 2 then jump to WA1 to abort the in-system jump
 BCC WA1                \ with a low beep, as we are facing the station and are
                        \ too close to jump in that direction

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION

 LSR A                  \ If A < 2 then jump to WA1 to abort the in-system jump
 BEQ WA1                \ with a low beep, as we are facing the sun and are too
                        \ close to jump in that direction

ENDIF

.WA2

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

                        \ If we get here, then we can do an in-system jump, as
                        \ we don't have any ships or space stations in the
                        \ vicinity, we are not in witchspace, and if we are
                        \ facing the planet or the sun, we aren't too close to
                        \ jump towards it
                        \
                        \ We do an in-system jump by moving the sun and planet,
                        \ rather than moving our own local bubble (this is why
                        \ in-system jumps drag asteroids, cargo canisters and
                        \ escape pods along for the ride). Specifically, we move
                        \ them in the z-axis by a fixed amount in the opposite
                        \ direction to travel, thus performing a jump towards
                        \ our destination

ELIF _ELECTRON_VERSION

                        \ If we get here, then we can do an in-system jump, as
                        \ we don't have any ships or space stations in the
                        \ vicinity, we are not in witchspace, and if we are
                        \ facing the planet, we aren't too close to jump
                        \ towards it
                        \
                        \ We do an in-system jump by moving the planet, rather
                        \ than moving our own local bubble (this is why
                        \ in-system jumps drag asteroids, cargo canisters and
                        \ escape pods along for the ride). Specifically, we move
                        \ them in the z-axis by a fixed amount in the opposite
                        \ direction to travel, thus performing a jump towards
                        \ our destination

ENDIF

 LDA #&81               \ Set R = R = P = &81
 STA S
 STA R
 STA P

 LDA K%+8               \ Set A = z_sign for the planet

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = (z_sign &81) + &8181
                        \           = (z_sign &81) - &0181
                        \
                        \ This moves the planet against the direction of travel
                        \ by reducing z_sign by 1, as the above maths is:
                        \
                        \         z_sign 00000000
                        \   +   00000000 10000001
                        \   -   00000001 10000001
                        \
                        \ or:
                        \
                        \         z_sign 00000000
                        \   +   00000000 00000000
                        \   -   00000001 00000000
                        \
                        \ i.e. the high byte is z_sign - 1, making sure the sign
                        \ is preserved

 STA K%+8               \ Set the planet's z_sign to the high byte of the result

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA K%+NI%+8           \ Set A = z_sign for the sun

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = (z_sign &81) + &8181
                        \           = (z_sign &81) - &0181
                        \
                        \ which moves the sun against the direction of travel
                        \ by reducing z_sign by 1

ELIF _ELECTRON_VERSION

 LDA K%+NI%+8           \ Set A = z_sign for the station

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = (z_sign &81) + &8181
                        \           = (z_sign &81) - &0181
                        \
                        \ which moves the station against the direction of
                        \ travel by reducing z_sign by 1

ENDIF

 STA K%+NI%+8           \ Set the planet's z_sign to the high byte of the result

 LDA #1                 \ These instructions have no effect, as the call to
 STA QQ11               \ LOOK1 below starts by setting QQ11 to 0; instead they
                        \ just set the current view type in QQ11 to 1 for the
                        \ duration of the next three instructions

 STA MCNT               \ Set the main loop counter to 1, so the next iteration
                        \ through the main loop will potentially spawn ships
                        \ (see part 2 of the main game loop at me3)

 LSR A                  \ Set EV, the extra vessels spawning counter, to 0
 STA EV                 \ (the LSR produces a 0 as A was previously 1)

 LDX VIEW               \ Set X to the current view (front, rear, left or right)
 JMP LOOK1              \ and jump to LOOK1 to initialise that view, returning
                        \ from the subroutine using a tail call

.WA1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #40                \ If we get here then we can't do an in-system jump, so
 JMP NOISE              \ call the NOISE routine with A = 40 to make a long, low
                        \ beep and return from the subroutine using a tail call

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA #40                \ If we get here then we can't do an in-system jump, so
 BNE NOISE              \ call the NOISE routine with A = 40 to make a long, low
                        \ beep and return from the subroutine using a tail call
                        \ (the BNE is effectively a JMP as A is never zero)

ELIF _MASTER_VERSION

 JMP LOWBEEP            \ Call the LOWBEEP routine to make a long, low beep, and
                        \ return from the subroutine using a tail call

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

ELIF _ELITE_A_6502SP_PARA

 LDA #40                \ If we get here then we can't do an in-system jump, so
 JMP NOISE              \ call the NOISE routine with A = 40 to make a long, low
                        \ beep and return from the subroutine using a tail call

ENDIF

