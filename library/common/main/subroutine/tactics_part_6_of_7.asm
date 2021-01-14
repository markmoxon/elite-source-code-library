\ ******************************************************************************
\
\       Name: TACTICS (Part 6 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Consider firing a laser at us, if aim is true
\
\ ------------------------------------------------------------------------------
\
\ This section looks at potentially firing the ship's laser at us. Specifically:
\
\   * If the ship is not pointing at us, skip to the next part
\
\   * If the ship is pointing at us but not accurately, fire its laser at us and
\     skip to the next part
\
\   * If we are in the ship's crosshairs, register some damage to our ship, slow
\     down the attacking ship, make the noise of us being hit by laser fire, and
\     we're done
\
\ ******************************************************************************

.TA3

                        \ If we get here then the ship either has plenty of
                        \ energy, or levels are low but it couldn't manage to
                        \ launch a missile, so maybe we can fire the laser?

 LDA #0                 \ Set A to x_hi OR y_hi OR z_hi
 JSR MAS4

 AND #%11100000         \ If any of the hi bytes have any of bits 5-7 set, then
 BNE TA4                \ jump to TA4 to skip the laser checks, as the ship is
                        \ too far away from us to hit us with a laser

 LDX CNT                \ Set X = the dot product set above in CNT. If this is
                        \ positive, this ship and our ship are facing in similar
                        \ directions, but if it's negative then we are facing
                        \ each other, so for us to be in the enemy ship's line
                        \ of fire, X needs to be negative. The value in X can
                        \ have a maximum magnitude of 36, which would mean we
                        \ were facing each other square on, so in the following
                        \ code we check X like this:
                        \
                        \   X = 0 to -31, we are not in the enemy ship's line
                        \       of fire, so they can't shoot at us
                        \
                        \   X = -32 to -34, we are in the enemy ship's line
                        \       of fire, so they can shoot at us, but they can't
                        \       hit us as we're not dead in their crosshairs
                        \
                        \   X = -35 to -36, we are bang in the middle of the
                        \       enemy ship's crosshairs, so they can not only
                        \       shoot us, they can hit us

 CPX #160               \ If X < 160, i.e. X > -32, then we are not in the enemy
 BCC TA4                \ ship's line of fire, so jump to TA4 to skip the laser
                        \ checks

IF _6502SP_VERSION OR _DISC_VERSION

 LDY #19                \ Fetch the enemy ship's byte #19 from their ship's
 LDA (XX0),Y            \ blueprint into A

 AND #%11111000         \ Extract bits 3-7, which contain the enemy's laser
                        \ power

 BEQ TA4                \ If the enemy has no laser power, jump to TA4 to skip
                        \ the laser checks

ENDIF

 LDA INWK+31            \ Set bit 6 in byte #31 to denote that the ship is
 ORA #%01000000         \ firing its laser at us
 STA INWK+31

 CPX #163               \ If X < 163, i.e. X > -35, then we are not in the enemy
 BCC TA4                \ ship's crosshairs, so jump to TA4 to skip the laser

IF _CASSETTE_VERSION

.HIT

 LDY #19                \ We are being hit by enemy laser fire, so fetch the
 LDA (XX0),Y            \ enemy ship's byte #19 from their ship's blueprint
                        \ into A

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDA (XX0),Y            \ Fetch the enemy ship's byte #19 from their ship's
                        \ blueprint into A

ENDIF

 LSR A                  \ Halve the enemy ship's byte #19 (which contains both
                        \ the laser power and number of missiles) to get the
                        \ amount of damage we should take

 JSR OOPS               \ Call OOPS to take some damage, which could do anything
                        \ from reducing the shields and energy, all the way to
                        \ losing cargo or dying (if the latter, we don't come
                        \ back from this subroutine)

 DEC INWK+28            \ Halve the attacking ship's acceleration in byte #28

IF _CASSETTE_VERSION

 LDA ECMA               \ If an E.C.M. is currently active (either our's or an
 BNE TA10               \ opponent's), return from the subroutine without making
                        \ the laser-strike sound (as TA10 contains an RTS)

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDA ECMA               \ If an E.C.M. is currently active (either our's or an
 BNE TA9-1              \ opponent's), return from the subroutine without making
                        \ the laser-strike sound (as TA9-1 contains an RTS)

ENDIF

 LDA #8                 \ Call the NOISE routine with A = 8 to make the sound
 JMP NOISE              \ of us being hit by lasers, returning from the
                        \ subroutine using a tail call

