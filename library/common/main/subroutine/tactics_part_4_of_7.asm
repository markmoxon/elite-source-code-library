\ ******************************************************************************
\
\       Name: TACTICS (Part 4 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Check energy levels, maybe launch escape pod if low
\
\ ------------------------------------------------------------------------------
\
\ This section works out what kind of condition the ship is in. Specifically:
\
IF _6502SP_VERSION
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
IF _CASSETTE_VERSION
\   * If the ship is into the last 1/8th of its energy, then rarely (10% chance)
\     the ship launches an escape pod and is left drifting in space
ELIF _6502SP_VERSION
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

IF _6502SP_VERSION

 CMP #ANA               \ If this is not an Anaconda, jump down to TN7 to skip
 BNE TN7                \ the following

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), jump down to TN7 to skip the
 BCC TN7                \ following

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

IF _CASSETTE_VERSION

 LDA TYPE               \ If this is a Thargoid, jump down to ta3 to consider
 CMP #THG               \ launching a Thargon
 BEQ ta3

ELIF _6502SP_VERSION

 LDX TYPE               \ Fetch the ship blueprint's default NEWB flags from the
 LDA E%-1,X             \ table at E%, and if bit 7 is clear (i.e. this ship
 BPL ta3                \ does not have an escape pod), jump to ta3 to skip the
                        \ spawning of an escape pod

ENDIF

                        \ By this point, the ship has run out of both energy and
                        \ luck, so it's time to bail

 LDA #0                 \ Set the AI flag to 0 to disable AI, hostility and
 STA INWK+32            \ E.C.M., so the ship's a sitting duck

 JMP SESCP              \ Jump to SESCP to spawn an escape pod from the ship,
                        \ returning from the subroutine using a tail call

