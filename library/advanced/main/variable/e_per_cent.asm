\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags
\  Deep dive: Ship blueprints
\
\ ------------------------------------------------------------------------------
\
\ When spawning a new ship, bits 0-3 and 5-6 from the relevant byte in this
\ table are applied to the new ship's NEWB flags in byte #36 (i.e. a set bit in
\ this table will set that bit in the NEWB flags). In other words, if a ship
\ blueprint is one of the following, then all spawned ships of that type will be
\ too: trader, bounty hunter, hostile, pirate, innocent, cop.
\
\ Bit 4 (docking) is set randomly on spawning for traders only, so 50% of
\ traders are trying to dock, while the other 50% fly towards the planet.
\
\ Bit 7 (has been scooped/has docked) is set when the ship docks or is scooped.
\
\ Bit 7 in the blueprint (as opposed to the spawned ship) is looked up during
\ tactics, for when the ship is about to die, to see if that ship type has an
\ escape pod. If it does, then the ship can launch an escape pod before dying.
\
\ Here's a breakdown of the NEWB flags:
\
\    * Bit 0: Trader flag (0 = not a trader, 1 = trader)
\
\             80% of traders are peaceful and mind their own business plying
\             their trade between the planet and space station, but 20% of them
\             moonlight as bounty hunters
\
\             Escape pod, Shuttle, Transporter, Anaconda, Rock hermit, Worm
\
\    * Bit 1: Bounty hunter flag (0 = not a bounty hunter, 1 = bounty hunter)
\
\             If we are a fugitive or a serious offender and we bump into a
\             bounty hunter, they will become hostile and attack us
\
\             Viper, Fer-de-lance
\
\    * Bit 2: Hostile flag (0 = not hostile, 1 = hostile)
\
\             Hostile ships will attack us on sight
\
\             Sidewinder, Mamba, Krait, Adder, Gecko, Cobra Mk I, Worm,
\             Cobra Mk III, Asp Mk II, Python (pirate), Moray, Thargoid,
\             Thargon, Constrictor
\
\    * Bit 3: Pirate flag (0 = not a pirate, 1 = pirate)
\
\             Hostile pirates will attack us on sight, but once we get inside
\             the space station safe zone, they will stop
\
\             Sidewinder, Mamba, Krait, Adder, Gecko, Cobra Mk I, Cobra Mk III,
\             Asp Mk II, Python (pirate), Moray, Thargoid
\
\    * Bit 4: Docking flag (0 = not docking, 1 = docking)
\
\             Traders with their docking flag set fly towards the space station
\             to try to dock, otherwise they aim for the planet
\
\             This flag is randomly set for traders when they are spawned
\
\    * Bit 5: Innocent bystander (0 = normal, 1 = innocent bystander)
\
\             If we attack an innocent ship within the space station safe zone,
\             then the station will get angry with us and start spawning cops
\
\             Shuttle, Transporter, Cobra Mk III, Python, Boa, Anaconda,
\             Rock hermit, Cougar
\
\    * Bit 6: Cop flag (0 = not a cop, 1 = cop)
\
\             If we destroy a cop, then we instantly becoime a fugitive (the
\             transporter isn't actually a cop, but it's clearly under police
\             protection)
\
\             Viper, Transporter
\
\    * Bit 7: For spawned ships, this flag indicates that the ship been scooped
\             or has docked (bit 7 is always clear on spawning)
\
\             For blueprints, this flag indicates whether the ship type has an
\             escape pod fitted, so it can launch it when in dire straits
\
\             Cobra Mk III, Python, Boa, Anaconda, Rock hermit, Viper, Mamba,
\             Krait, Adder, Cobra Mk I, Cobra Mk III (pirate), Asp Mk II,
\             Python (pirate), Fer-de-lance
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
IF _6502SP_VERSION \ Advanced
 EQUB %00000000         \ The Elite logo
ENDIF
 EQUB %00100000         \ Cougar                                        Innocent

 EQUB 0

