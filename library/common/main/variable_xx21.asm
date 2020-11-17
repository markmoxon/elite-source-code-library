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

 EQUW SHIP1             \         1 = Sidewinder
 EQUW SHIP2             \ COPS =  2 = Viper
 EQUW SHIP3             \ MAM  =  3 = Mamba
 EQUW SHIP4             \         4 = Python
 EQUW SHIP5             \         5 = Cobra Mk III (bounty hunter)
 EQUW SHIP6             \ THG  =  6 = Thargoid
 EQUW SHIP5             \ CYL  =  7 = Cobra Mk III (trader)
 EQUW SHIP8             \ SST  =  8 = Coriolis space station
 EQUW SHIP9             \ MSL  =  9 = Missile
 EQUW SHIP10            \ AST  = 10 = Asteroid
 EQUW SHIP11            \ OIL  = 11 = Cargo canister
 EQUW SHIP12            \ TGL  = 12 = Thargon
 EQUW SHIP13            \ ESC  = 13 = Escape pod

ELIF _6502SP_VERSION

 EQUW &D066             \ MSL  =  1 = Missile
 EQUW &D164             \ SST  =  2 = Coriolis space station
 EQUW &D280             \ ESC  =  3 = Escape pod
 EQUW &D2D4             \ PLT  =  4 = Plate (alloys)
 EQUW &D314             \ OIL  =  5 = Cargo canister
 EQUW &D3BC             \         6 = Boulder
 EQUW &D45E             \ AST  =  7 = Asteroid
 EQUW &D534             \ SPL  =  8 = Splinter
 EQUW &D570             \ SHU  =  9 = Shuttle
 EQUW &D6A2             \        10 = Transporter
 EQUW &D884             \ CYL  = 11 = Cobra Mk III
 EQUW &DA0C             \        12 = Python
 EQUW &DAFE             \        13 = Boa
 EQUW &DBF4             \ ANA  = 14 = Anaconda
 EQUW &DCF6             \ HER  = 15 = Rock hermit (asteroid)
 EQUW &DDCC             \ COPS = 16 = Viper
 EQUW &DEA6             \ SH3  = 17 = Sidewinder
 EQUW &DF4E             \        18 = Mamba
 EQUW &E07C             \ KRA  = 19 = Krait
 EQUW &E162             \ ADA  = 20 = Adder
 EQUW &E292             \        21 = Gecko
 EQUW &E356             \        22 = Cobra Mk I
 EQUW &E41C             \ WRM  = 23 = Worm
 EQUW &E4CC             \ CYL2 = 24 = Cobra Mk III (pirate)
 EQUW &E654             \ ASP  = 25 = Asp Mk II
 EQUW &E77E             \        26 = Python (pirate)
 EQUW &E870             \        27 = Fer-de-lance
 EQUW &E98A             \        28 = Moray
 EQUW &EA62             \ THG  = 29 = Thargoid
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