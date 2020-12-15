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
\   * Rarely (2.5% chance) roll the ship by a noticeable amount
\
\   * If the ship has at least half its energy banks full, jump to part 6 to
\     consider firing the lasers
\
\   * If the ship isn't really low on energy, jump to part 5 to consider firing
\     a missile
\
\   * Rarely (10% chance) the ship runs out of both energy and luck, and bails,
\     launching an escape pod and drifting in space
\
\ ******************************************************************************

 LDA TYPE               \ If this is not a missile, skip the following
 CMP #MSL               \ instruction
 BNE P%+5

 JMP TA20               \ This is a missile, so jump down to TA20 to get
                        \ straight into some aggressive manoeuvring

IF _6502SP_VERSION

 CMP #ANA
 BNE TN7
 JSR DORND
 CMP #200
 BCC TN7
 JSR DORND
 LDX #WRM
 CMP #100
 BCS P%+4
 LDX #SH3
 JMP TN6

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

