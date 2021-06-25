\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE R
\
\ Elite-A is an extended version of BBC Micro Elite by Angus Duggan
\
\ The original Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984, and the extra code in Elite-A is copyright Angus Duggan
\
\ The code on this site is identical to Angus Duggan's source discs (it's just
\ been reformatted, and the label names have been changed to be consistent with
\ the sources for the original BBC Micro disc version on which it is based)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/S.R.bin
\
\ ******************************************************************************

INCLUDE "versions/elite-a/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE
_ELITE_A_DOCKED         = FALSE
_ELITE_A_FLIGHT         = TRUE
_ELITE_A_SHIPS_R        = TRUE
_ELITE_A_SHIPS_S        = FALSE
_ELITE_A_SHIPS_T        = FALSE
_ELITE_A_SHIPS_U        = FALSE
_ELITE_A_SHIPS_V        = FALSE
_ELITE_A_SHIPS_W        = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = FALSE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

SHIP_MISSILE = &7F00    \ The address of the missile ship blueprint

CODE% = &5600           \ The flight code loads this file at address &5600, at
LOAD% = &5600           \ label XX21

ORG CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the S.R file
\  Deep dive: Ship blueprints in the disc version
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_DODO         \         2 = Dodecahedron ("Dodo") space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW SHIP_PLATE        \ PLT  =  4 = Alloy plate
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW SHIP_BOULDER      \         6 = Boulder
 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid
 EQUW SHIP_SPLINTER     \ SPL  =  8 = Splinter
 EQUW 0
 EQUW 0
 EQUW SHIP_BOA          \        11 = Boa
 EQUW SHIP_OPHIDIAN     \        12 = Ophidian
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW SHIP_GECKO        \        18 = Gecko
 EQUW 0
 EQUW SHIP_BUSHMASTER   \        20 = Bushmaster
 EQUW SHIP_OPHIDIAN     \        21 = Ophidian
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_BUSHMASTER   \        26 = Bushmaster
 EQUW SHIP_GECKO        \        27 = Gecko
 EQUW SHIP_SIDEWINDER   \        28 = Sidewinder
 EQUW 0
 EQUW 0
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.R file
\  Deep dive: Ship blueprints
\             Advanced tactics with the NEWB flags
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %01000000         \ Dodo space station                                 Cop
 EQUB %01000001         \ Escape pod                                 Trader, cop
 EQUB %00000000         \ Alloy plate
 EQUB %00000000         \ Cargo canister
 EQUB %00000000         \ Boulder
 EQUB %00000000         \ Asteroid
 EQUB %00000000         \ Splinter
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Boa                               Innocent, escape pod
 EQUB %10100001         \ Ophidian                  Trader, innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %10001100         \ Gecko                      Hostile, pirate, escape pod
 EQUB 0
 EQUB %10001100         \ Bushmaster                 Hostile, pirate, escape pod
 EQUB %10000100         \ Ophidian                           Hostile, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100010         \ Bushmaster         Bounty hunter, innocent, escape pod
 EQUB %10000010         \ Gecko                        Bounty hunter, escape pod
 EQUB %00100010         \ Sidewinder                     Bounty hunter, innocent
 EQUB 0
 EQUB 0
 EQUB 0

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/elite-a/flight/variable/ship_bushmaster.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/enhanced/main/variable/ship_splinter.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/elite-a/flight/variable/ship_ophidian.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"


 EQUB 8                 \ AJD

\ ******************************************************************************
\
\ Save output/S.R.bin
\
\ ******************************************************************************

PRINT "S.S.R ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/S.R.bin", CODE%, CODE% + &0A00
