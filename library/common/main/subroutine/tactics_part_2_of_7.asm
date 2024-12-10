\ ******************************************************************************
\
\       Name: TACTICS (Part 2 of 7)
\       Type: Subroutine
\   Category: Tactics
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Apply tactics: Escape pod, station, lone Thargon, safe-zone pirate
ELIF _ELECTRON_VERSION
\    Summary: Apply tactics: Escape pod, station, safe-zone pirate
ENDIF
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section contains the main entry point at TACTICS, which is called from
\ part 2 of MVEIT for ships that have the AI flag set (i.e. bit 7 of byte #32).
\ This part does the following:
\
\   * If this is a missile, jump up to the missile code in part 1
\
IF _CASSETTE_VERSION \ Comment
\   * If this is an escape pod, point it at the planet and jump to the
\     manoeuvring code in part 7
\
\   * If this is the space station and it is hostile, consider spawning a cop
\     (45% chance, up to a maximum of four) and we're done
\
\   * If this is a lone Thargon without a mothership, set it adrift aimlessly
\     and we're done
\
\   * If this is a pirate and we are within the space station safe zone, stop
\     the pirate from attacking by removing all its aggression
\
ELIF _ELECTRON_VERSION
\   * If this is an escape pod, point it at the planet and jump to the
\     manoeuvring code in part 7
\
\   * If this is the space station and it is hostile, consider spawning a cop
\     (45% chance, up to a maximum of four) and we're done
\
\   * If this is a pirate and we are within the space station safe zone, stop
\     the pirate from attacking by removing all its aggression
\
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
\   * If this is the space station and it is hostile, consider spawning a cop
\     (6.2% chance, up to a maximum of seven) and we're done
\
\   * If this is the space station and it is not hostile, consider spawning
\     (0.8% chance if there are no Transporters around) a Transporter or Shuttle
\     (equal odds of each type) and we're done
\
ENDIF
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * If this is a rock hermit, consider spawning (22% chance) a highly
\     aggressive and hostile Sidewinder, Mamba, Krait, Adder or Gecko (equal
\     odds of each type) and we're done
\
ENDIF
\   * Recharge the ship's energy banks by 1
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The ship type
\
\ ******************************************************************************

.TACTICS

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Enhanced: Group A: The docking computer in the enhanced versions uses its own turning circle configuration, which is different to the turning circle used by the tactics routine, so the latter switches to its own configuration when it starts (as they share configuration variables)

 LDY #3                 \ Set RAT = 3, which is the magnitude we set the pitch
 STY RAT                \ or roll counter to in part 7 when turning a ship
                        \ towards a vector (a higher value giving a longer
                        \ turn). This value is not changed in the TACTICS
                        \ routine, but it is set to different values by the
                        \ DOCKIT routine

 INY                    \ Set RAT2 = 4, which is the threshold below which we
 STY RAT2               \ don't apply pitch and roll to the ship (so a lower
                        \ value means we apply pitch and roll more often, and a
                        \ value of 0 means we always apply them). The value is
                        \ compared with double the high byte of sidev . XX15,
                        \ where XX15 is the vector from the ship to the enemy
                        \ or planet. This value is set to different values by
                        \ both the TACTICS and DOCKIT routines

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDA #3                 \ Set RAT = 3, which is the magnitude we set the pitch
 STA RAT                \ or roll counter to in part 7 when turning a ship
                        \ towards a vector (a higher value giving a longer
                        \ turn). This value is not changed in the TACTICS
                        \ routine, but it is set to different values by the
                        \ DOCKIT routine

 LDA #4                 \ Set RAT2 = 4, which is the threshold below which we
 STA RAT2               \ don't apply pitch and roll to the ship (so a lower
                        \ value means we apply pitch and roll more often, and a
                        \ value of 0 means we always apply them). The value is
                        \ compared with double the high byte of sidev . XX15,
                        \ where XX15 is the vector from the ship to the enemy
                        \ or planet. This value is set to different values by
                        \ both the TACTICS and DOCKIT routines

ELIF _NES_VERSION

 LDA #3                 \ Set RAT = 3, which is the magnitude we set the pitch
 STA RAT                \ or roll counter to in part 7 when turning a ship
                        \ towards a vector (a higher value giving a longer
                        \ turn). This value is not changed in the TACTICS
                        \ routine, but it is set to different values by the
                        \ DOCKIT routine

 STA shipIsAggressive   \ Set shipIsAggressive = 3 so that bit 7 is clear, so
                        \ the default position is that the ship we are
                        \ processing tactics for is not looking for a fight
                        \ (though this might change, of course)

 LDA #4                 \ Set RAT2 = 4, which is the threshold below which we
 STA RAT2               \ don't apply pitch and roll to the ship (so a lower
                        \ value means we apply pitch and roll more often, and a
                        \ value of 0 means we always apply them). The value is
                        \ compared with double the high byte of sidev . XX15,
                        \ where XX15 is the vector from the ship to the enemy
                        \ or planet. This value is set to different values by
                        \ both the TACTICS and DOCKIT routines

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: See group A

 LDA #22                \ Set CNT2 = 22, which is the maximum angle beyond which
 STA CNT2               \ a ship will slow down to start turning towards its
                        \ prey (a lower value means a ship will start to slow
                        \ down even if its angle with the enemy ship is large,
                        \ which gives a tighter turn). This value is not changed
                        \ in the TACTICS routine, but it is set to different
                        \ values by the DOCKIT routine

ENDIF

 CPX #MSL               \ If this is a missile, jump up to TA18 to implement
 BEQ TA18               \ missile tactics

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The enhanced versions let the NEWB flags determine whether ships should be heading for the planet (which is applied to traders, ships who are docking, escape pods and so on). The cassette and Electron versions are a lot simpler and only send escape pods in the direction of the planet

 CPX #ESC               \ If this is not an escape pod, skip the following two
 BNE P%+8               \ instructions

 JSR SPS1               \ This is an escape pod, so call SPS1 to calculate the
                        \ vector to the planet and store it in XX15

 JMP TA15               \ Jump down to TA15

ENDIF

 CPX #SST               \ If this is not the space station, jump down to TA13
 BNE TA13

IF _6502SP_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: Space stations in the enhanced versions regularly spawn Transporters and Shuttles that ply their trade between the station and the planet

 LDA NEWB               \ This is the space station, so check whether bit 2 of
 AND #%00000100         \ the ship's NEWB flags is set, and if it is (i.e. the
 BNE TN5                \ station is hostile), jump to TN5 to spawn some cops

 LDA MANY+SHU+1         \ The station is not hostile, so check how many
 BNE TA1                \ Transporters there are in the vicinity, and if we
                        \ already have one, return from the subroutine (as TA1
                        \ contains an RTS)

                        \ If we get here then the station is not hostile, so we
                        \ can consider spawning a Transporter or Shuttle

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A < 253 (99.2% chance), return from the subroutine
 BCC TA1                \ (as TA1 contains an RTS)

 AND #1                 \ Set A = a random number that's either 0 or 1

 ADC #SHU-1             \ The C flag is set (as we didn't take the BCC above),
 TAX                    \ so this sets X to a value of either #SHU or #SHU + 1,
                        \ which is the ship type for a Shuttle or a Transporter

 BNE TN6                \ Jump to TN6 to spawn this ship type and return from
                        \ the subroutine using a tail call (this BNE is
                        \ effectively a JMP as A is never zero)

.TN5

ELIF _NES_VERSION OR _ELITE_A_VERSION

 LDA NEWB               \ This is the space station, so check whether bit 2 of
 AND #%00000100         \ the ship's NEWB flags is set, and if it is (i.e. the
 BNE TN5                \ station is hostile), jump to TN5 to spawn some cops

 LDA MANY+SHU+1         \ Set A to the number of Transporters in the vicinity

 ORA auto               \ If the docking computer is on then auto is &FF, so
                        \ this ensures that A is always non-zero when we are
                        \ auto-docking, so the following jump to TA1 will be
                        \ taken and no Transporters will be spawned from the
                        \ space station (unlike in the disc version, where you
                        \ can get smashed into space dust by a badly timed
                        \ Transporter launch when using the docking computer)

 BNE TA1                \ The station is not hostile, so check how many
                        \ Transporters there are in the vicinity, and if we
                        \ already have one, return from the subroutine (as TA1
                        \ contains an RTS)

                        \ If we get here then the station is not hostile, so we
                        \ can consider spawning a Transporter or Shuttle

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A < 253 (99.2% chance), return from the subroutine
 BCC TA1                \ (as TA1 contains an RTS)

 AND #1                 \ Set A = a random number that's either 0 or 1

 ADC #SHU-1             \ The C flag is set (as we didn't take the BCC above),
 TAX                    \ so this sets X to a value of either #SHU or #SHU + 1,
                        \ which is the ship type for a Shuttle or a Transporter

 BNE TN6                \ Jump to TN6 to spawn this ship type and return from
                        \ the subroutine using a tail call (this BNE is
                        \ effectively a JMP as A is never zero)

.TN5

ENDIF

                        \ We only call the tactics routine for the space station
                        \ when it is hostile, so if we get here then this is the
                        \ station, and we already know it's hostile, so we need
                        \ to spawn some cops

 JSR DORND              \ Set A and X to random numbers

IF _CASSETTE_VERSION \ Standard: In the cassette version there is a 45% chance that an angry station will spawn a cop, while in the enhanced versions there is only a 6.2% chance

 CMP #140               \ If A < 140 (55% chance) then return from the
 BCC TA14-1             \ subroutine (as TA14-1 contains an RTS)

ELIF _ELECTRON_VERSION

 CMP #140               \ If A < 140 (55% chance) then return from the
 BCC TA1                \ subroutine (as TA1 contains an RTS)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 CMP #240               \ If A < 240 (93.8% chance), return from the subroutine
 BCC TA1                \ (as TA1 contains an RTS)

ENDIF

IF _CASSETTE_VERSION \ Standard: In the Electron version there can be up to three cops in the vicinity, in the cassette and disc versions there can be up to four, in the Master version there can be up to six, and in the 6502SP there can be up to seven

 LDA MANY+COPS          \ We only call the tactics routine for the space station
 CMP #4                 \ when it is hostile, so first check the number of cops
 BCS TA14-1             \ in the vicinity, and if we already have 4 or more, we
                        \ don't need to spawn any more, so return from the
                        \ subroutine (as TA14-1 contains an RTS)

ELIF _ELECTRON_VERSION

 LDA MANY+COPS          \ We only call the tactics routine for the space station
 CMP #3                 \ when it is hostile, so first check the number of cops
 BCS TA1                \ in the vicinity, and if we already have 3 or more, we
                        \ don't need to spawn any more, so return from the
                        \ subroutine (as TA1 contains an RTS)

ELIF _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDA MANY+COPS          \ Check how many cops there are in the vicinity already,
 CMP #4                 \ and if there are 4 or more, return from the subroutine
 BCS TA22               \ (as TA22 contains an RTS)

ELIF _6502SP_VERSION OR _ELITE_A_VERSION

 LDA MANY+COPS          \ Check how many cops there are in the vicinity already,
 CMP #7                 \ and if there are 7 or more, return from the subroutine
 BCS TA22               \ (as TA22 contains an RTS)

ELIF _MASTER_VERSION

 LDA MANY+COPS          \ Check how many cops there are in the vicinity already,
 CMP #6                 \ and if there are 6 or more, return from the subroutine
 BCS TA22               \ (as TA22 contains an RTS)

ENDIF

 LDX #COPS              \ Set X to the ship type for a cop

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Label

.TN6

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: The cops that the space station spawns to defend itself are slightly less aggressive in the Electron version than in the other versions

 LDA #%11110001         \ Set the AI flag to give the ship E.C.M., enable AI and
                        \ make it very aggressive (60 out of 63)

ELIF _ELECTRON_VERSION

 LDA #%11100001         \ Set the AI flag to give the ship E.C.M., enable AI and
                        \ make it pretty aggressive (56 out of 63)

ENDIF

 JMP SFS1               \ Jump to SFS1 to spawn the ship, returning from the
                        \ subroutine using a tail call

.TA13

IF _CASSETTE_VERSION \ Platform: This logic is in part 3 for the other versions

 CPX #TGL               \ If this is not a Thargon, jump down to TA14
 BNE TA14

 LDA MANY+THG           \ If there is at least one Thargoid in the vicinity,
 BNE TA14               \ jump down to TA14

 LSR INWK+32            \ This is a Thargon but there is no Thargoid mothership,
 ASL INWK+32            \ so clear bit 0 of the AI flag to disable its E.C.M.

 LSR INWK+27            \ And halve the Thargon's speed

 RTS                    \ Return from the subroutine

.TA14

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform: Without the NEWB flags, the logic in the cassette and Electron versions is much simpler (traders always fly a Cobra Mk III)

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

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Advanced: Rock hermits have a 22% chance of spawning a ship

 CPX #HER               \ If this is not a rock hermit, jump down to TA17
 BNE TA17

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If A < 200 (78% chance), return from the subroutine
 BCC TA22               \ (as TA22 contains an RTS)

 LDX #0                 \ Set byte #32 to %00000000 to disable AI, aggression
 STX INWK+32            \ and E.C.M.

ENDIF

IF _6502SP_VERSION \ Master: In the Master version, rock hermits spawn ships that are hostile and innocent bystanders

 STX NEWB               \ Set the ship's NEWB flags to %00000000 so the ship we
                        \ spawn below will inherit the default values from E%

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDX #%00100100         \ Set the ship's NEWB flags to %00100100 so the ship we
 STX NEWB               \ spawn below will inherit the default values from E% as
                        \ well as having bit 2 (hostile) and bit 5 (innocent
                        \ bystander) set

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Advanced: Rock hermits can spawn a Sidewinder, Mamba, Krait, Adder or Gecko

 AND #3                 \ Set A = a random number that's in the range 0-3

 ADC #SH3               \ The C flag is set (as we didn't take the BCC above),
 TAX                    \ so this sets X to a random value between #SH3 + 1 and
                        \ #SH3 + 4, so that's a Sidewinder, Mamba, Krait, Adder
                        \ or Gecko

 JSR TN6                \ Call TN6 to spawn this ship with E.C.M., AI and a high
                        \ aggression (56 out of 63)

 LDA #0                 \ Set byte #32 to %00000000 to disable AI, aggression
 STA INWK+32            \ and E.C.M. (for the rock hermit)

 RTS                    \ Return from the subroutine

.TA17

ENDIF

IF NOT(_NES_VERSION)

 LDY #14                \ If the ship's energy is greater or equal to the
 LDA INWK+35            \ maximum value from the ship's blueprint pointed to by
 CMP (XX0),Y            \ XX0, then skip the next instruction
 BCS TA21

ELIF _NES_VERSION

 LDY #14                \ If the ship's energy is greater or equal to the
 JSR GetShipBlueprint   \ maximum value from the ship's blueprint pointed to by
 CMP INWK+35            \ XX0, then skip the next instruction
 BCC TA21
 BEQ TA21

ENDIF

 INC INWK+35            \ The ship's energy is not at maximum, so recharge the
                        \ energy banks by 1

