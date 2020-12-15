\ ******************************************************************************
\
\       Name: Main flight loop (Part 11 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Process missile lock and firing our laser
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * If this is not the front space view, flip the axes of the ship's
\        coordinates in INWK
\
\     * Process missile lock
\
\     * Process our laser firing
\
\ ******************************************************************************

.MA26

IF _6502SP_VERSION

 LDA NEWB               \ If bit 7 of the ship's NEWB flags is clear, skip the
 BPL P%+5               \ following instruction

 JSR SCAN               \ Bit 7 of the ship's NEWB flags is set, which means the
                        \ ship has docked or been scooped, so we draw the ship
                        \ on the scanner, which has the effect of removing it

ENDIF

 LDA QQ11               \ If this is not a space view, jump to MA15 to skip
 BNE MA15               \ missile and laser locking

 JSR PLUT               \ Call PLUT to update the geometric axes in INWK to
                        \ match the view (front, rear, left, right)

 JSR HITCH              \ Call HITCH to see if this ship is in the crosshairs,
 BCC MA8                \ in which case the C flag will be set (so if there is
                        \ no missile or laser lock, we jump to MA8 to skip the
                        \ following)

 LDA MSAR               \ We have missile lock, so check whether the leftmost
 BEQ MA47               \ missile is currently armed, and if not, jump to MA47
                        \ to process laser fire, as we can't lock an unarmed
                        \ missile

 JSR BEEP               \ We have missile lock and an armed missile, so call
                        \ the BEEP subroutine to make a short, high beep

IF _CASSETTE_VERSION

 LDX XSAV               \ Call ABORT2 to store the details of this missile
 LDY #&0E               \ lock, with the targeted ship's slot number in X
 JSR ABORT2             \ (which we stored in XSAV at the start of this ship's
                        \ loop at MAL1), and set the colour of the missile
                        \ indicator to the colour in Y (red = &0E)

ELIF _6502SP_VERSION

 LDX XSAV               \ Call ABORT2 to store the details of this missile
 LDY #RED2              \ lock, with the targeted ship's slot number in X
 JSR ABORT2             \ (which we stored in XSAV at the start of this ship's
                        \ loop at MAL1), and set the colour of the missile
                        \ indicator to the colour in Y (red = &0E)

ENDIF

.MA47

                        \ If we get here then the ship is in our sights, but
                        \ we didn't lock a missile, so let's see if we're
                        \ firing the laser

 LDA LAS                \ If we are firing the laser then LAS will contain the
 BEQ MA8                \ laser power (which we set in MA68 above), so if this
                        \ is zero, jump down to MA8 to skip the following

 LDX #15                \ We are firing our laser and the ship in INWK is in
 JSR EXNO               \ the crosshairs, so call EXNO to make the sound of
                        \ us making a laser strike on another ship

IF _6502SP_VERSION

 LDA TYPE               \ Did we just hit the space station? If so, jump to
 CMP #SST               \ MA14+2 to make the station hostile, skipping the
 BEQ MA14+2             \ following as we can't destroy a space station

 CMP #CON               \ If the ship we hit is less than #CON - i.e. it's not
 BCC BURN               \ a Constrictor, Cougar, Dodo station or the Elite logo,
                        \ jump to BURN to skip the following

 LDA LAS                \ Set A to the power of the laser we just used to hit
                        \ the ship (i.e. the laser in the current view)

 CMP #(Armlas AND 127)  \ If the laser is not a military laser, jump to MA14+2
 BNE MA14+2             \ to skip the following, as only military lasers have
                        \ any effect on the Constrictor or Cougar (or the Elite
                        \ logo, should you ever bump into one of those out there
                        \ in the black...)

 LSR LAS                \ Divide the laser power of the current view by 4, so
 LSR LAS                \ the damage inflicted on the super-ship is a quarter of
                        \ the damage our military lasers would inflict on a
                        \ normal ship

.BURN

ENDIF

 LDA INWK+35            \ Fetch the hit ship's energy from byte #35 and subtract
 SEC                    \ our current laser power, and if the result is greater
 SBC LAS                \ than zero, the other ship has survived the hit, so
 BCS MA14               \ jump down to MA14

IF _CASSETTE_VERSION

 LDA TYPE               \ Did we just hit the space station? If so, jump to
 CMP #SST               \ MA14+2 to make the station hostile, skipping the
 BEQ MA14+2             \ following as we can't destroy a space station

 LDA INWK+31            \ Set bit 7 of the enemy ship's byte #31, to indicate
 ORA #%10000000         \ that it has been killed
 STA INWK+31

 BCS MA8                \ If the enemy ship type is >= SST (i.e. missile,
                        \ asteroid, canister, Thargon or escape pod) then
                        \ jump down to MA8

 JSR DORND              \ Fetch a random number, and jump to oh if it is
 BPL oh                 \ positive (50% chance)

 LDY #0                 \ Fetch the first byte of the hit ship's blueprint,
 AND (XX0),Y            \ which determines the maximum number of bits of
                        \ debris shown when the ship is destroyed, and AND
                        \ with the random number we just fetched

 STA CNT                \ Store the result in CNT, so CNT contains a random
                        \ number between 0 and the maximum number of bits of
                        \ debris that this ship will release when destroyed

.um

 BEQ oh                 \ We're going to go round a loop using CNT as a counter
                        \ so this checks whether the counter is zero and jumps
                        \ to oh when it gets there (which might be straight
                        \ away)

 LDX #OIL               \ Call SFS1 to spawn a cargo canister from the now
 LDA #0                 \ deceased parent ship, giving the spawned canister an
 JSR SFS1               \ AI flag of 0 (no AI, no E.C.M., non-hostile)

 DEC CNT                \ Decrease the loop counter

 BPL um                 \ Jump back up to um (this BPL is effectively a JMP as
                        \ CNT will never be negative)

.oh

ELIF _6502SP_VERSION

 ASL INWK+31            \ Set bit 7 of the ship byte #31 to indicate that it has
 SEC                    \ now been killed
 ROR INWK+31

 LDA TYPE               \ Did we just kill an asteroid? If not, jump to nosp,
 CMP #AST               \ otherwise keep going
 BNE nosp

 LDA LAS                \ Did we kill the asteroid using mining lasers? If not,
 CMP #Mlas              \ jump to nosp, otherwise keep going
 BNE nosp

 JSR DORND              \ Set A and X to random numbers

 LDX #SPL               \ Set X to the ship type for a splinter

 AND #3                 \ Reduce the random number in A to the range 0-3

 JSR SPIN2              \ Call SPIN2 to spawn A items of type X (i.e. spawn
                        \ 0-3 spliters)

.nosp

 LDY #PLT               \ Randomly spawn some alloy plates
 JSR SPIN

 LDY #OIL               \ Randomly spawn some cargo canisters
 JSR SPIN

ENDIF

 JSR EXNO2              \ Call EXNO2 to process the fact that we have killed a
                        \ ship (so increase the kill tally, make an explosion
                        \ sound and so on)

.MA14

 STA INWK+35            \ Store the hit ship's updated energy in ship byte #35

 LDA TYPE               \ Call ANGRY to make this ship hostile, now that we
 JSR ANGRY              \ have hit it

