\ ******************************************************************************
\
\       Name: ship_bytes
\       Type: Variable
\   Category: Drawing ships
\    Summary: Table of data used when adding each ship type to the positions in
\             the blueprints table
\  Deep dive: Ship blueprints in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ This table contains ship data that's used when populating the ship blueprint
\ positions in LOMOD, and installing a ship into a blueprint position in
\ install_ship.
\
\ Each ship type has four associated bytes, but only the first two are used:
\
\   * Byte #0 is used in LOMOD when populating the ship blueprint positions. It
\     is the probability (out of 256) of installing this ship into one of the
\     positions in which it is allowed. So, if the figure is 100 (as it is for
\     the Mamba and Sidewinder), then the chance of us adding this ship to a
\     blueprint position is 100/256, or a 39% chance, while the much rarer
\     Dragon has a value of 3, so its probability of being added is 3/256, or a
\     1.2% chance
\
\   * Byte #1 determines whether this ship type comes with an escape pod fitted
\     as standard: if bit 7 is set it does have an escape pod, otherwise it
\     doesn't
\
\ ******************************************************************************

.ship_bytes

 EQUB   0, %00000000, 0, 2      \  0 = Dodo station
 EQUB   0, %00000000, 0, 2      \  1 = Coriolis station
 EQUB   0, %00000000, 0, 2      \  2 = Escape pod
 EQUB   0, %00000000, 0, 2      \  3 = Alloy plate
 EQUB   0, %00000000, 0, 2      \  4 = Cargo canister
 EQUB   0, %00000000, 0, 2      \  5 = Boulder
 EQUB   0, %00000000, 0, 2      \  6 = Asteroid
 EQUB   0, %00000000, 0, 2      \  7 = Splinter
 EQUB  50, %00000000, 0, 0      \  8 = Shuttle
 EQUB  50, %00000000, 0, 0      \  9 = Transporter
 EQUB  70, %10000000, 0, 2      \ 10 = Cobra Mk III
 EQUB  65, %10000000, 0, 2      \ 11 = Python
 EQUB  60, %10000000, 0, 2      \ 12 = Boa
 EQUB  10, %10000000, 0, 0      \ 13 = Anaconda
 EQUB  15, %00000000, 0, 0      \ 14 = Worm
 EQUB   0, %00000000, 0, 0      \ 15 = Missile
 EQUB   0, %10000000, 0, 2      \ 16 = Viper
 EQUB  90, %00000000, 0, 2      \ 17 = Sidewinder
 EQUB 100, %10000000, 0, 2      \ 18 = Mamba
 EQUB 100, %10000000, 0, 2      \ 19 = Krait
 EQUB  85, %10000000, 0, 2      \ 20 = Adder
 EQUB  80, %10000000, 0, 2      \ 21 = Gecko
 EQUB  80, %10000000, 0, 2      \ 22 = Cobra Mk I
 EQUB  10, %10000000, 0, 0      \ 23 = Asp Mk II
 EQUB  60, %10000000, 0, 1      \ 24 = Fer-de-Lance
 EQUB  60, %10000000, 0, 1      \ 25 = Moray
 EQUB   0, %00000000, 0, 2      \ 26 = Thargoid
 EQUB   0, %00000000, 0, 2      \ 27 = Thargon
 EQUB   0, %00000000, 0, 2      \ 28 = Constrictor
 EQUB   3, %00000000, 0, 0      \ 29 = Dragon
 EQUB  30, %10000000, 0, 0      \ 30 = Monitor
 EQUB  75, %10000000, 0, 2      \ 31 = Ophidian
 EQUB  50, %10000000, 0, 1      \ 32 = Ghavial
 EQUB  75, %10000000, 0, 2      \ 33 = Bushmaster
 EQUB  55, %10000000, 0, 1      \ 34 = Rattler
 EQUB  60, %10000000, 0, 1      \ 35 = Iguana
 EQUB  50, %00000000, 0, 0      \ 36 = Shuttle Mk II
 EQUB  45, %10000000, 0, 1      \ 37 = Chameleon

 EQUB 255, %00000000, 0, 0      \ 38 = No ship

