\ ******************************************************************************
\
\       Name: TACTICS (Part 6 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Consider firing a laser at us, if aim is true
\  Deep dive: Program flow of the tactics routine
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
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Comment
\     we're done
ELIF _MASTER_VERSION
\     move on to the next part to manoeuvre the attacking ship
ENDIF
\
\ ******************************************************************************

.TA3

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

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

IF _MASTER_VERSION \ Comment

\BPL TA4                \ This instruction is commented out in the original
                        \ source

ENDIF

IF NOT(_NES_VERSION)

 CPX #160               \ If X < 160, i.e. X > -32, then we are not in the enemy
 BCC TA4                \ ship's line of fire, so jump to TA4 to skip the laser
                        \ checks

ELIF _NES_VERSION

 CPX #158               \ If X < 158, i.e. X > -30, then we are not in the enemy
 BCC TA4                \ ship's line of fire, so jump to TA4 to skip the laser
                        \ checks

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Other: This might be a bug fix? When enemies have no lasers, the cassette version still allows them to damage us if they are pointing at us, and it even makes the laser noise. This is fixed in other versions

 LDY #19                \ Fetch the enemy ship's byte #19 from their ship's
 LDA (XX0),Y            \ blueprint into A

 AND #%11111000         \ Extract bits 3-7, which contain the enemy's laser
                        \ power

 BEQ TA4                \ If the enemy has no laser power, jump to TA4 to skip
                        \ the laser checks

ELIF _NES_VERSION

 LDY #19                \ Fetch the enemy ship's byte #19 from their ship's
 JSR GetShipBlueprint   \ blueprint into A

 AND #%11111000         \ Extract bits 3-7, which contain the enemy's laser
                        \ power

 BEQ TA4                \ If the enemy has no laser power, jump to TA4 to skip
                        \ the laser checks

 CPX #161               \ If X < 161, i.e. X > -31, then we are not in the enemy
 BCC tact1              \ ship's line of fire, so jump to tact1 to skip the laser
                        \ checks

ENDIF

 LDA INWK+31            \ Set bit 6 in byte #31 to denote that the ship is
 ORA #%01000000         \ firing its laser at us
 STA INWK+31

IF NOT(_NES_VERSION)

 CPX #163               \ If X < 163, i.e. X > -35, then we are not in the enemy
 BCC TA4                \ ship's crosshairs, so jump to TA4 to skip the laser
                        \ checks

ELIF _NES_VERSION

 CPX #163               \ If X >= 163, i.e. X <= -35, then we are in the enemy
 BCS tact2              \ ship's crosshairs, so jump to tact2 to skip the laser
                        \ checks

.tact1

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction

 LDA CNT                \ Change the sign of the dot product in CNT, so now it's
 EOR #%10000000         \ positive if the ships are facing each other, and
                        \ negative if they are facing the same way

 STA CNT                \ Update CNT with the new value in A

 JSR TA15               \ Call TA15 so the ship heads away from us

 JMP tact3              \ Jump to tact3 to continue with the checks

.tact2

ENDIF

IF _MASTER_VERSION \ Comment

\LDY #19                \ This instruction is commented out in the original
                        \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

.HIT

 LDY #19                \ We are being hit by enemy laser fire, so fetch the
 LDA (XX0),Y            \ enemy ship's byte #19 from their ship's blueprint
                        \ into A

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA (XX0),Y            \ Fetch the enemy ship's byte #19 from their ship's
                        \ blueprint into A

ELIF _NES_VERSION

 JSR GetShipBlueprint   \ Fetch the enemy ship's byte #19 from their ship's
                        \ blueprint into A

ENDIF

 LSR A                  \ Halve the enemy ship's byte #19 (which contains both
                        \ the laser power and number of missiles) to get the
                        \ amount of damage we should take

IF NOT(_ELITE_A_VERSION)

 JSR OOPS               \ Call OOPS to take some damage, which could do anything
                        \ from reducing the shields and energy, all the way to
                        \ losing cargo or dying (if the latter, we don't come
                        \ back from this subroutine)

ELIF _ELITE_A_VERSION

 JSR n_oops             \ Call n_oops to take some damage (taking the shields
                        \ into account), which could do anything from reducing
                        \ the shields and energy, all the way to losing cargo
                        \ or dying (if the latter, we don't come back from this
                        \ subroutine)

ENDIF

IF NOT(_NES_VERSION)

 DEC INWK+28            \ Halve the attacking ship's acceleration in byte #28

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA ECMA               \ If an E.C.M. is currently active (either ours or an
 BNE TA10               \ opponent's), return from the subroutine without making
                        \ the laser-strike sound (as TA10 contains an RTS)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA ECMA               \ If an E.C.M. is currently active (either ours or an
 BNE TA9-1              \ opponent's), return from the subroutine without making
                        \ the laser-strike sound (as TA9-1 contains an RTS)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the Master version, if we are being hit by lasers, the ship firing at us can still manoeuvre, whereas in the other versions enemies mysteriously forget to move if they manage to hit us

 LDA #8                 \ Call the NOISE routine with A = 8 to make the sound
 JMP NOISE              \ of us being hit by lasers, returning from the
                        \ subroutine using a tail call

ELIF _MASTER_VERSION

 JSR ELASNO             \ Call the ELASNO routine to make the sound of us
                        \ being hit by lasers

ELIF _NES_VERSION

 LDY #11                \ Call the NOISE routine with Y = 11 to make the sound
 JSR NOISE              \ of us being hit by lasers

.tact3

 LDA INWK+7             \ If z_hi >= 3 then the ship is quite far away, so jump
 CMP #3                 \ down to tact4 to apply the brakes
 BCS tact4

 JSR DORND              \ Set A and X to random numbers

 ORA #%11000000         \ Set bits 6 and 7 of A, so A is at least 192

 CMP INWK+32            \ If A < byte #32 (the ship's AI flag) then jump down
 BCC tact4              \ to tact4 to apply the brakes
                        \
                        \ We jump if A < byte #32, and the chances of this
                        \ being true are greater with high values of byte #32,
                        \ as long as they are at least 192
                        \
                        \ In other words, higher byte #32 values increase the
                        \ chances of a ship changing direction to head towards
                        \ us - or, to put it another way, ships with higher
                        \ byte #32 values over 192 are spoiling for a fight
                        \
                        \ Thargoids have byte #32 set to 255, which explains
                        \ an awful lot

 JSR DORND              \ Otherwise set the ship's pitch counter to a random
 AND #%10000111         \ number in the range 0 to 7, with a random pitch
 STA INWK+30            \ direction

 JMP tact8              \ Jump to tact8 to set the ship's acceleration to 3 and
                        \ return from the subroutine

.tact4

 LDA INWK+1             \ If none of x_hi, y_hi or z_hi has bits 5 to 7 set,
 ORA INWK+4             \ then they are all less than 31, so jump to tact11 to
 ORA INWK+7             \ set the ship's acceleration to -1 (or -2 if it is a
 AND #%11100000         \ missile)
 BEQ tact11

 BNE tact8              \ Otherwise jump to tact8 to set the ship's acceleration
                        \ to 3 and return from the subroutine (this BNE is
                        \ effectively a JMP as we just passed through a BEQ)

ENDIF

