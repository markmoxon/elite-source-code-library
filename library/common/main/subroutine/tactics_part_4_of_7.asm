\ ******************************************************************************
\
\       Name: TACTICS (Part 4 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Check energy levels, maybe launch escape pod if low
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section works out what kind of condition the ship is in. Specifically:
\
IF _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment
\   * If this is an Anaconda, consider spawning (22% chance) a Worm
\
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   * If this is an Anaconda, consider spawning (22% chance) a Worm (61% of the
\     time) or a Sidewinder (39% of the time)
\
ENDIF
\   * Rarely (2.5% chance) roll the ship by a noticeable amount
\
\   * If the ship has at least half its energy banks full, jump to part 6 to
\     consider firing the lasers
\
\   * If the ship is not into the last 1/8th of its energy, jump to part 5 to
\     consider firing a missile
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\   * If the ship is into the last 1/8th of its energy, then rarely (10% chance)
\     the ship launches an escape pod and is left drifting in space
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION
\   * If the ship is into the last 1/8th of its energy, and this ship type has
\     an escape pod fitted, then rarely (10% chance) the ship launches an escape
\     pod and is left drifting in space
ENDIF
\
\ ******************************************************************************

 LDA TYPE               \ If this is not a missile, skip the following
 CMP #MSL               \ instruction
 BNE P%+5

 JMP TA20               \ This is a missile, so jump down to TA20 to get
                        \ straight into some aggressive manoeuvring

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: In the enhanced versions, Anacondas can spawn other ships

 CMP #ANA               \ If this is not an Anaconda, jump down to TN7 to skip
 BNE TN7                \ the following

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), jump down to TN7 to skip the
 BCC TN7                \ following

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Advanced: In the disc version, Anacondas can only spawn Worms, while in the advanced versions they can also spawn Sidewinders

 LDX #WRM               \ Set X to the ship type for a Worm

 JMP TN6                \ Jump to TN6 to spawn the Worm and return from
                        \ the subroutine using a tail call

.TN7

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR DORND              \ Set A and X to random numbers

 LDX #WRM               \ Set X to the ship type for a Worm

 CMP #100               \ If A >= 100 (61% chance), skip the following
 BCS P%+4               \ instruction

 LDX #SH3               \ Set X to the ship type for a Sidewinder

 JMP TN6                \ Jump to TN6 to spawn the Worm or Sidewinder and return
                        \ from the subroutine using a tail call

.TN7

ENDIF

 JSR DORND              \ Set A and X to random numbers

 CMP #250               \ If A < 250 (97.5% chance), jump down to TA7 to skip
 BCC TA7                \ the following

 JSR DORND              \ Set A and X to random numbers

 ORA #104               \ Bump A up to at least 104 and store in the roll
 STA INWK+29            \ counter, to gives the ship a noticeable roll

.TA7

 LDY #14                \ Set A = the ship's maximum energy / 2
 LDA (XX0),Y
 LSR A

 CMP INWK+35            \ If the ship's current energy in byte #35 > A, i.e. the
 BCC TA3                \ ship has at least half of its energy banks charged,
                        \ jump down to TA3

 LSR A                  \ If the ship's current energy in byte #35 > A / 4, i.e.
 LSR A                  \ the ship is not into the last 1/8th of its energy,
 CMP INWK+35            \ jump down to ta3 to consider firing a missile
 BCC ta3

 JSR DORND              \ Set A and X to random numbers

 CMP #230               \ If A < 230 (90% chance), jump down to ta3 to consider
 BCC ta3                \ firing a missile

IF _CASSETTE_VERSION \ Standard: The cassette version has Thargoids but no NEWB flags, so we have to manually cater for Thargoids launching Thargons rather than using the same code as escape pods

 LDA TYPE               \ If this is a Thargoid, jump down to ta3 to consider
 CMP #THG               \ launching a Thargon
 BEQ ta3

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Enhanced: In the enhanced versions, the NEWB flags determine whether or not a ship has an escape pod it can launch when things go south, while in the cassette and Electron versions, every ship has an escape pod fitted

 LDX TYPE               \ Fetch the ship blueprint's default NEWB flags from the
 LDA E%-1,X             \ table at E%, and if bit 7 is clear (i.e. this ship
 BPL ta3                \ does not have an escape pod), jump to ta3 to skip the
                        \ spawning of an escape pod

ENDIF

                        \ By this point, the ship has run out of both energy and
                        \ luck, so it's time to bail

IF _MASTER_VERSION \ Master: In the Master version, escape pods that other ships drop do not inherit the parent ship's characteristics (i.e. trader, bounty hunter, hostile, pirate)

 LDA NEWB               \ Clear bits 0-3 of the NEWB flags, so the ship is no
 AND #%11110000         \ longer a trader, a bounty hunter, hostile or a pirate
 STA NEWB               \ and the escape pod we are about to spawn won't inherit
                        \ any of these traits

 LDY #36                \ Update the NEWB flags in the ship's data block
 STA (INF),Y

ENDIF

 LDA #0                 \ Set the AI flag to 0 to disable AI, hostility and
 STA INWK+32            \ E.C.M., so the ship's a sitting duck

 JMP SESCP              \ Jump to SESCP to spawn an escape pod from the ship,
                        \ returning from the subroutine using a tail call

