\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE K
\
\ Produces the binary file D.MOK.bin that gets loaded by the game on launching.
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE

SHIP_MISSILE = &7F00

CODE% = &5600
LOAD% = &5600

ORG CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the D.MOK file
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_CORIOLIS     \ SST  =  2 = Coriolis space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW 0
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW 0
 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid
 EQUW SHIP_SPLINTER     \ SPL  =  8 = Splinter
 EQUW 0
 EQUW 0
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW SHIP_PYTHON       \        12 = Python
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_GECKO        \        21 = Gecko
 EQUW SHIP_COBRA_MK_1   \        22 = Cobra Mk I
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_MORAY        \        28 = Moray
 EQUW 0
 EQUW 0
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the D.MOK file
\
\ ******************************************************************************

 EQUB %00000000         \ Missile
 EQUB %00000000         \ Coriolis space station
 EQUB %00000001         \ Escape pod                                      Trader
 EQUB 0
 EQUB %00000000         \ Cargo canister
 EQUB 0
 EQUB %00000000         \ Asteroid
 EQUB %00000000         \ Splinter
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB %10100000         \ Python                            Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %00001100         \ Gecko                                  Hostile, pirate
 EQUB %10001100         \ Cobra Mk I                 Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %00001100         \ Moray                                  Hostile, pirate
 EQUB 0
 EQUB 0
 EQUB 0

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/6502sp/main/variable/ship_splinter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/6502sp/main/variable/ship_gecko.asm"
INCLUDE "library/6502sp/main/variable/ship_cobra_mk_i.asm"
INCLUDE "library/6502sp/main/variable/ship_moray.asm"

\ ******************************************************************************
\
\ Save output/D.MOK.bin
\
\ ******************************************************************************

PRINT "S.D.MOK ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/D.MOK.bin", CODE%, CODE% + &A00

