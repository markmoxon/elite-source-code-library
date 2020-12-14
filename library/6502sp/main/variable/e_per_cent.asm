\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints NEWB table
\
\ ------------------------------------------------------------------------------
\
\    * Bit 0: Trader flag (0 = not a trader, 1 = trader)
\
\    * Bit 1: Bounty hunter flag (0 = not a bounty hunter, 1 = bounty hunter)
\
\    * Bit 2: Hostile flag (0 = not hostile, 1 = hostile)
\             (replaces bit 7 of INWK+32, in ANGRY and ISDK, at least)
\
\    * Bit 3: Pirate flag (0 = not a pirate, 1 = pirate)
\
\    * Bit 4: Docking flag (0 = not docking, 1 = docking)
\             but gets randomly set in main game loop 1
\
\    * Bit 5: Innocent flag?
\             (in ANGRY if it's clear, this is not the space station)
\
\    * Bit 6: Cop flag (0 = not a cop, 1 = cop)
\
\    * Bit 7: Ship has been scooped/docked/disappeared, so remove with no explosion
\             LL9 1,  it calls EE51 to remove itself
\             gets set in main flight 8 when we scoop an item
\             gets removed from the scanner in main flight 11
\             skips legal checks
\             Maybe also "has Escape pod" flag?
\
\ ******************************************************************************

.E%

 EQUB 0

 EQUB %00000000         \ Missile
 EQUB %00000001         \ Coriolis space station
 EQUB %00000000         \ Escape pod
 EQUB %00000000         \ Alloy plate
 EQUB %00000000         \ Cargo canister
 EQUB %00000000         \ Boulder
 EQUB %00000000         \ Asteroid
 EQUB %00100001         \ Splinter
 EQUB %01100001         \ Shuttle
 EQUB %10100000         \ Transporter
 EQUB %10100000         \ Cobra Mk III
 EQUB %10100000         \ Python
 EQUB %10100001         \ Boa
 EQUB %10100001         \ Anaconda
 EQUB %11000010         \ Rock hermit (asteroid)
 EQUB %00001100         \ Viper
 EQUB %10001100         \ Sidewinder
 EQUB %10001100         \ Mamba
 EQUB %10001100         \ Krait
 EQUB %00001100         \ Adder
 EQUB %10001100         \ Gecko
 EQUB %00000101         \ Cobra Mk I
 EQUB %10001100         \ Worm
 EQUB %10001100         \ Cobra Mk III (pirate)
 EQUB %10001100         \ Asp Mk II
 EQUB %10000010         \ Python (pirate)
 EQUB %00001100         \ Fer-de-lance
 EQUB %00001100         \ Moray
 EQUB %00000100         \ Thargoid
 EQUB %00000100         \ Thargon
 EQUB %00000000         \ Constrictor
 EQUB %00100000         \ The Elite logo
 EQUB %00000000         \ Cougar

