\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.XX21

IF _CASSETTE_VERSION \ Standard: The cassette version has 13 different ship types with 12 distinct designs, including the Coriolis space station; the Electron version has 11 ship types with 10 distinct designs; the disc version has 31 ship types with 29 distinct designs, including an additional space station, the Dodo; and the advanced versions have 33 ship types with 30 distinct designs, again including both station types

 EQUW SHIP_SIDEWINDER   \         1 = Sidewinder
 EQUW SHIP_VIPER        \ COPS =  2 = Viper
 EQUW SHIP_MAMBA        \         3 = Mamba
 EQUW SHIP_PYTHON       \         4 = Python
 EQUW SHIP_COBRA_MK_3   \         5 = Cobra Mk III (bounty hunter)
 EQUW SHIP_THARGOID     \ THG  =  6 = Thargoid
 EQUW SHIP_COBRA_MK_3   \ CYL  =  7 = Cobra Mk III (trader)
 EQUW SHIP_CORIOLIS     \ SST  =  8 = Coriolis space station
 EQUW SHIP_MISSILE      \ MSL  =  9 = Missile
 EQUW SHIP_ASTEROID     \ AST  = 10 = Asteroid
 EQUW SHIP_CANISTER     \ OIL  = 11 = Cargo canister
 EQUW SHIP_THARGON      \ TGL  = 12 = Thargon
 EQUW SHIP_ESCAPE_POD   \ ESC  = 13 = Escape pod

ELIF _ELECTRON_VERSION

 EQUW SHIP_SIDEWINDER   \         1 = Sidewinder
 EQUW SHIP_VIPER        \ COPS =  2 = Viper
 EQUW SHIP_MAMBA        \         3 = Mamba
 EQUW SHIP_PYTHON       \         4 = Python
 EQUW SHIP_COBRA_MK_3   \         5 = Cobra Mk III (bounty hunter)
 EQUW SHIP_COBRA_MK_3   \ CYL  =  6 = Cobra Mk III (trader)
 EQUW SHIP_CORIOLIS     \ SST  =  7 = Coriolis space station
 EQUW SHIP_MISSILE      \ MSL  =  8 = Missile
 EQUW SHIP_ASTEROID     \ AST  =  9 = Asteroid
 EQUW SHIP_CANISTER     \ OIL  = 10 = Cargo canister
 EQUW SHIP_ESCAPE_POD   \ ESC  = 11 = Escape pod

ELIF _6502SP_VERSION OR _MASTER_VERSION

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_CORIOLIS     \ SST  =  2 = Coriolis space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW SHIP_PLATE        \ PLT  =  4 = Alloy plate
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW SHIP_BOULDER      \         6 = Boulder
 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid
 EQUW SHIP_SPLINTER     \ SPL  =  8 = Splinter
 EQUW SHIP_SHUTTLE      \ SHU  =  9 = Shuttle
 EQUW SHIP_TRANSPORTER  \        10 = Transporter
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW SHIP_PYTHON       \        12 = Python
 EQUW SHIP_BOA          \        13 = Boa
 EQUW SHIP_ANACONDA     \ ANA  = 14 = Anaconda
 EQUW SHIP_ROCK_HERMIT  \ HER  = 15 = Rock hermit (asteroid)
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW SHIP_MAMBA        \        18 = Mamba
 EQUW SHIP_KRAIT        \ KRA  = 19 = Krait
 EQUW SHIP_ADDER        \ ADA  = 20 = Adder
 EQUW SHIP_GECKO        \        21 = Gecko
 EQUW SHIP_COBRA_MK_1   \        22 = Cobra Mk I
 EQUW SHIP_WORM         \ WRM  = 23 = Worm
 EQUW SHIP_COBRA_MK_3_P \ CYL2 = 24 = Cobra Mk III (pirate)
 EQUW SHIP_ASP_MK_2     \ ASP  = 25 = Asp Mk II
 EQUW SHIP_PYTHON_P     \        26 = Python (pirate)
 EQUW SHIP_FER_DE_LANCE \        27 = Fer-de-lance
 EQUW SHIP_MORAY        \        28 = Moray
 EQUW SHIP_THARGOID     \ THG  = 29 = Thargoid
 EQUW SHIP_THARGON      \ TGL  = 30 = Thargon
 EQUW SHIP_CONSTRICTOR  \ CON  = 31 = Constrictor
ENDIF
IF _6502SP_VERSION \ 6502SP: The 6502SP version has an extra ship definition for the Elite logo that appears in the demo, but it doesn't turn up in-game, not surprisingly
 EQUW SHIP_LOGO         \ LGO  = 32 = The Elite logo
 EQUW SHIP_COUGAR       \ COU  = 33 = Cougar
 EQUW SHIP_DODO         \ DOD  = 34 = Dodecahedron ("Dodo") space station

ELIF _MASTER_VERSION
 EQUW SHIP_COUGAR       \ COU  = 32 = Cougar
 EQUW SHIP_DODO         \ DOD  = 33 = Dodecahedron ("Dodo") space station

ENDIF

