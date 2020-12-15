\ ******************************************************************************
\
\       Name: TACTICS (Part 2 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Escape pod, station, lone Thargon, safe-zone pirate
\
\ ------------------------------------------------------------------------------
\
\ This section contains the main entry point at TACTICS, which is called from
\ part 2 of MVEIT for ships that have the AI flag set (i.e. bit 7 of byte #32).
\ This part does the following:
\
\   * If this is a missile, jump up to the missile code in part 1
\
\   * If this is an escape pod, point it at the planet and jump to the
\     manoeuvring code in part 7
\
\   * If this is the space station and it is hostile, spawn a cop and we're done
\
\   * If this is a lone Thargon without a mothership, set it adrift aimlessly
\     and we're done
\
\   * If this is a pirate and we are within the space station safe zone, stop
\     the pirate from attacking
\
\   * Recharge the ship's energy banks by 1
\
\ Arguments:
\
\   X                   The ship type
\
\ ******************************************************************************

.TACTICS

IF _6502SP_VERSION

 LDA #3                 \ Set RAT = 3
 STA RAT

 LDA #4                 \ Set RAT2 = 4
 STA RAT2

 LDA #22                \ Set CNT = 22
 STA CNT2

ENDIF

 CPX #MSL               \ If this is a missile, jump up to TA18 to implement
 BEQ TA18               \ missile tactics

IF _CASSETTE_VERSION

 CPX #ESC               \ If this is not an escape pod, skip the following two
 BNE P%+8               \ instructions

 JSR SPS1               \ This is an escape pod, so call SPS1 to calculate the
                        \ vector to the planet and store it in XX15

 JMP TA15               \ Jump down to TA15

ENDIF

 CPX #SST               \ If this is not the space station, jump down to TA13
 BNE TA13

IF _CASSETTE_VERSION

 JSR DORND              \ This is the space station, so set A and X to random
 CMP #140               \ numbers and if A < 140 (55% chance) return from the
 BCC TA14-1             \ subroutine (as TA14-1 contains an RTS)

 LDA MANY+COPS          \ We only call the tactics routine for the space station
 CMP #4                 \ when it is hostile, so first check the number of cops
 BCS TA14-1             \ in the vicinity, and if we already have 4 or more, we
                        \ don't need to spawn any more, so return from the
                        \ subroutine (as TA14-1 contains an RTS)

 LDX #COPS              \ Call SFS1 to spawn a cop from the space station that
 LDA #%11110001         \ is hostile, has AI and has E.C.M., and return from the
 JMP SFS1               \ subroutine using a tail call

.TA13

 CPX #TGL               \ If this is not a Thargon, jump down to TA14
 BNE TA14

 LDA MANY+THG           \ If there is at least one Thargoid in the vicinity,
 BNE TA14               \ jump down to TA14

 LSR INWK+32            \ This is a Thargon but there is no Thargoid mothership,
 ASL INWK+32            \ so clear bit 0 of the AI flag to disable its E.C.M.

 LSR INWK+27            \ And halve the Thargon's speed

 RTS                    \ Return from the subroutine

.TA14

 CPX #CYL               \ If A >= #CYL, i.e. this is a Cobra Mk III trader (as
 BCS TA62               \ asteroids and cargo canisters never have AI), jump
                        \ down to TA62

 CPX #COPS              \ If this is a cop, jump down to TA62
 BEQ TA62

 LDA SSPR               \ If we aren't within range of the space station, jump
 BEQ TA62               \ down to TA62

 LDA INWK+32            \ This is a pirate or bounty hunter, but we are inside
 AND #%10000001         \ the space station's safe zone, so clear bits 1-6 of
 STA INWK+32            \ the AI flag to stop it being hostile, because even
                        \ pirates aren't crazy enough to breach the station's
                        \ no-fire zone

.TA62

ELIF _6502SP_VERSION

 LDA NEWB               \ This is the space station, so check whether bit 2 of
 AND #%00000100         \ the ship's NEWB flags is set, and if it is (i.e. the
 BNE TN5                \ station is hostile), jump to TN5 to spawn some cops

 LDA MANY+SHU+1         \ The station is not hostile, so check how many
 BNE TA1                \ transporters there are in the vicinity, and if we
                        \ already have one, return from the subroutine (as TA1
                        \ contains an RTS)

                        \ If we get here then the station is not hostile, so we
                        \ can consider spawning a transporter or shuttle

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A < 253 (99.2% chance), return from the subroutine
 BCC TA1                \ (as TA1 contains an RTS)

 AND #1                 \ Set A = a random number that's either 0 or 1

 ADC #SHU-1             \ The C flag is set (as we didn't take the BCC above),
 TAX                    \ so this sets X to a value of either #SHU or #SHU + 1,
                        \ which is the ship type for a shuttle or a transporter

 BNE TN6                \ Jump to TN6 to spawn this ship type (this BNE is
                        \ effectively a JMP as A is never zero)

.TN5

                        \ If we get here then the station is hostile and we need
                        \ to spawn some cops

 JSR DORND              \ Set A and X to random numbers

 CMP #240               \ If A < 240 (93.8% chance), return from the subroutine
 BCC TA1                \ (as TA1 contains an RTS)

 LDA MANY+COPS          \ Check how many cops there are in the vicinity already,
 CMP #7                 \ and if there are 7 or more, return from the subroutine
 BCS TA22               \ (as TA22 contains an RTS)

 LDX #COPS              \ Set X to the ship type for a cop

.TN6

 LDA #%11110001         \ Set the AI flag to give the ship E.C.M., enable AI and
                        \ make it very aggressive (56 out of 63)

 JMP SFS1               \ Jump to SFS1 to spawn the ship, returning from the
                        \ subroutine using a tail call

.TA13

 CPX #HER               \ If this is not a rock hermit, jump down to TA17
 BNE TA17

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), return from the subroutine
 BCC TA22               \ (as TA22 contains an RTS)

 LDX #0                 \ Set byte #32 to %00000000 to disable AI, aggression
 STX INWK+32            \ and E.C.M.

 STX NEWB               \ Set the ship's NEWB flags to %00000000

 AND #3                 \ Set A = a random number that's in the range 0-3

 ADC #SH3               \ The C flag is set (as we didn't take the BCC above),
 TAX                    \ so this sets X to a random value between #SH3 + 1 and
                        \ #SH3 + 4, so that's a Sidewinder, Mamba, Krait, Adder
                        \ or Gecko

 JSR TN6                \ Call TN6 to spawn this ship with E.C.M., AI and a high
                        \ aggression (56 out of 63)

 LDA #0                 \ Set byte #32 to %00000000 to disable AI, aggression
 STA INWK+32            \ and E.C.M.

 RTS                    \ Return from the subroutine

.TA17

ENDIF

 LDY #14                \ If the ship's energy is greater or equal to the
 LDA INWK+35            \ maximum value from the ship's blueprint pointed to by
 CMP (XX0),Y            \ XX0, then skip the next instruction
 BCS TA21

 INC INWK+35            \ The ship's energy is not at maximum, so recharge the
                        \ energy banks by 1

