\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags
\  Deep dive: Ship blueprints
\             Advanced tactics with the NEWB flags
\
\ ------------------------------------------------------------------------------
\
\ When spawning a new ship, the bits from this table are applied to the new
\ ship's NEWB flags in byte #36 (i.e. a set bit in this table will set that bit
\ in the NEWB flags). In other words, if a ship blueprint is set to one of the
\ following, then all spawned ships of that type will be too: trader, bounty
\ hunter, hostile, pirate, innocent, cop.
\
\ The NEWB flags are as follows:
\
\    * Bit 0: Trader flag (0 = not a trader, 1 = trader)
\    * Bit 1: Bounty hunter flag (0 = not a bounty hunter, 1 = bounty hunter)
\    * Bit 2: Hostile flag (0 = not hostile, 1 = hostile)
\    * Bit 3: Pirate flag (0 = not a pirate, 1 = pirate)
\    * Bit 4: Docking flag (0 = not docking, 1 = docking)
\    * Bit 5: Innocent bystander (0 = normal, 1 = innocent bystander)
\    * Bit 6: Cop flag (0 = not a cop, 1 = cop)
\    * Bit 7: For spawned ships: ship been scooped or has docked
\             For blueprints: this ship type has an escape pod fitted
\
\ See the deep dive on "Advanced tactics with the NEWB flags" for details of
\ how this works.
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %00000000         \ Coriolis space station
 EQUB %00000001         \ Escape pod                                      Trader
 EQUB %00000000         \ Alloy plate
 EQUB %00000000         \ Cargo canister
 EQUB %00000000         \ Boulder
 EQUB %00000000         \ Asteroid
 EQUB %00000000         \ Splinter
 EQUB %00100001         \ Shuttle                               Trader, innocent
 EQUB %01100001         \ Transporter                      Trader, innocent, cop
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB %10100000         \ Python                            Innocent, escape pod
 EQUB %10100000         \ Boa                               Innocent, escape pod
 EQUB %10100001         \ Anaconda                  Trader, innocent, escape pod
 EQUB %10100001         \ Rock hermit (asteroid)    Trader, innocent, escape pod
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %10001100         \ Mamba                      Hostile, pirate, escape pod
 EQUB %10001100         \ Krait                      Hostile, pirate, escape pod
 EQUB %10001100         \ Adder                      Hostile, pirate, escape pod
 EQUB %00001100         \ Gecko                                  Hostile, pirate
 EQUB %10001100         \ Cobra Mk I                 Hostile, pirate, escape pod
 EQUB %00000101         \ Worm                                   Hostile, trader
 EQUB %10001100         \ Cobra Mk III (pirate)      Hostile, pirate, escape pod
 EQUB %10001100         \ Asp Mk II                  Hostile, pirate, escape pod
 EQUB %10001100         \ Python (pirate)            Hostile, pirate, escape pod
 EQUB %10000010         \ Fer-de-lance                 Bounty hunter, escape pod
 EQUB %00001100         \ Moray                                  Hostile, pirate
 EQUB %00001100         \ Thargoid                               Hostile, pirate
 EQUB %00000100         \ Thargon                                        Hostile
 EQUB %00000100         \ Constrictor                                    Hostile
IF _6502SP_VERSION \ 6502SP: The 6502SP version stores the Elite logo as a ship, with its own NEWB flags (none of which are set)
 EQUB %00000000         \ The Elite logo
ENDIF
 EQUB %00100000         \ Cougar                                        Innocent

 EQUB 0                 \ This byte appears to be unused

