\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE D
\
\ Elite-A is an extended version of BBC Micro Elite by Angus Duggan
\
\ The original Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984, and the extra code in Elite-A is copyright Angus Duggan
\
\ The code on this site is identical to Angus Duggan's source discs (it's just
\ been reformatted and variable names changed to be more readable)
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
\   * output/S.D.bin
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
\    Summary: Ship blueprints lookup table for the S.D file
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
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_BOA          \        11 = Boa
 EQUW 0
 EQUW 0
 EQUW ship_dragon       \        14 = Dragon
 EQUW SHIP_SIDEWINDER   \        15 = Sidewinder
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \        17 = Sidewinder
 EQUW SHIP_SIDEWINDER   \        18 = Sidewinder
 EQUW SHIP_GECKO        \        19 = Gecko
 EQUW ship_bushmaster   \        20 = Bushmaster
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW ship_bushmaster   \        26 = Bushmaster
 EQUW SHIP_GECKO        \        27 = Gecko
 EQUW SHIP_SIDEWINDER   \        28 = Sidewinder
 EQUW SHIP_THARGOID     \ THG  = 29 = Thargoid
 EQUW SHIP_THARGON      \ TGL  = 30 = Thargon
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.D file
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
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Boa                        I       nnocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %00100001         \ Dragon                                Trader, innocent
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %11000010         \ Viper              Bounty hunter, cop, escape pod
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %10000100         \ Gecko                              Hostile, escape pod
 EQUB %10001100         \ Bushmaster                 Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100010         \ Bushmaster         Bounty hunter, innocent, escape pod
 EQUB %10000010         \ Gecko                        Bounty hunter, escape pod
 EQUB %00100010         \ Sidewinder                     Bounty hunter, innocent
 EQUB %00001100         \ Thargoid                               Hostile, pirate
 EQUB %00000100         \ Thargon                                        Hostile
 EQUB 0

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/elite-a/flight/variable/ship_dragon.asm"
INCLUDE "library/elite-a/flight/variable/ship_bushmaster.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"

 EQUB 8                 \ AJD

\ ******************************************************************************
\
\ Save output/S.D.bin
\
\ ******************************************************************************

PRINT "S.S.D ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/S.D.bin", CODE%, CODE% + &0A00
