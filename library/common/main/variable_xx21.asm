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

IF _CASSETTE_VERSION

 EQUW SHIP_SIDEWINDER   \         1 = Sidewinder
 EQUW SHIP_VIPER        \ COPS =  2 = Viper
 EQUW SHIP_MAMBA        \ MAM  =  3 = Mamba
 EQUW SHIP_PYTHON       \         4 = Python
 EQUW SHIP_COBRA_3      \         5 = Cobra Mk III (bounty hunter)
 EQUW SHIP_THARGOID     \ THG  =  6 = Thargoid
 EQUW SHIP_COBRA_3      \ CYL  =  7 = Cobra Mk III (trader)
 EQUW SHIP_CORIOLIS     \ SST  =  8 = Coriolis space station
 EQUW SHIP_MISSILE      \ MSL  =  9 = Missile
 EQUW SHIP_ASTEROID     \ AST  = 10 = Asteroid
 EQUW SHIP_CANISTER     \ OIL  = 11 = Cargo canister
 EQUW SHIP_THARGON      \ TGL  = 12 = Thargon
 EQUW SHIP_ESCAPE_POD   \ ESC  = 13 = Escape pod

ELIF _6502SP_VERSION

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_CORIOLIS     \ SST  =  2 = Coriolis space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW &D2D4             \ PLT  =  4 = Plate (alloys)
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW &D3BC             \         6 = Boulder
 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid
 EQUW &D534             \ SPL  =  8 = Splinter
 EQUW &D570             \ SHU  =  9 = Shuttle
 EQUW &D6A2             \        10 = Transporter
 EQUW SHIP_COBRA_3      \ CYL  = 11 = Cobra Mk III
 EQUW &DA0C             \        12 = Python
 EQUW &DAFE             \        13 = Boa
 EQUW &DBF4             \ ANA  = 14 = Anaconda
 EQUW &DCF6             \ HER  = 15 = Rock hermit (asteroid)
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW SHIP_MAMBA        \        18 = Mamba
 EQUW &E07C             \ KRA  = 19 = Krait
 EQUW &E162             \ ADA  = 20 = Adder
 EQUW &E292             \        21 = Gecko
 EQUW &E356             \        22 = Cobra Mk I
 EQUW &E41C             \ WRM  = 23 = Worm
 EQUW SHIP_COBRA_3_P    \ CYL2 = 24 = Cobra Mk III (pirate)
 EQUW &E654             \ ASP  = 25 = Asp Mk II
 EQUW &E77E             \        26 = Python (pirate)
 EQUW &E870             \        27 = Fer-de-lance
 EQUW &E98A             \        28 = Moray
 EQUW SHIP_THARGOID     \ THG  = 29 = Thargoid
 EQUW &EB7E             \ TGL  = 30 = Thargon
 EQUW &EBEA             \ CON  = 31 = Constrictor
 EQUW &ECEC             \ LGO  = 32 = 
 EQUW &EEA4             \ COU  = 33 = Cougar
 EQUW &EFA6             \ DOD  = 34 = Dodecahedron space station

 EQUB &00, &00, &01, &00, &00, &00, &00, &00
 EQUB &21, &61, &A0, &A0, &A0, &A1, &A1, &C2
 EQUB &0C, &8C, &8C, &8C, &0C, &8C, &05, &8C
 EQUB &8C, &8C, &82, &0C, &0C, &04, &04, &00
 EQUB &20, &00

ENDIF