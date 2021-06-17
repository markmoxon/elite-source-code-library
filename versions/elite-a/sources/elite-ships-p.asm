\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE P
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
\   * output/S.P.bin
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
\    Summary: Ship blueprints lookup table for the S.P file
\  Deep dive: Ship blueprints in the disc version
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_DODO         \         2 = Dodecahedron ("Dodo") space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW 0
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_TRANSPORTER  \        10 = Transporter
 EQUW 0
 EQUW ship_chameleon    \        12 = Chameleon
 EQUW ship_ophidian     \        13 = Ophidian
 EQUW 0
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_MAMBA        \        17 = Mamba
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW ship_ophidian     \        21 = Ophidian
 EQUW ship_chameleon    \        22 = Chameleon
 EQUW SHIP_MORAY        \        23 = Moray
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_MORAY        \        27 = Moray
 EQUW ship_chameleon    \        28 = Chameleon
 EQUW 0
 EQUW 0
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.P file
\  Deep dive: Ship blueprints
\             Advanced tactics with the NEWB flags
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %01000000         \ Dodo space station                                 Cop
 EQUB %01000001         \ Escape pod                                 Trader, cop
 EQUB 0
 EQUB %00000000         \ Cargo canister
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %01100001         \ Transporter                      Trader, innocent, cop
 EQUB 0
 EQUB %10100001         \ Chameleon                 Trader, innocent, escape pod
 EQUB %10100000         \ Ophidian                          Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %10001100         \ Mamba                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10000100         \ Ophidian                           Hostile, escape pod
 EQUB %10001100         \ Chameleon                  Hostile, pirate, escape pod
 EQUB %10000100         \ Moray                              Hostile, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10000010         \ Moray                        Bounty hunter, escape pod
 EQUB %10100010         \ Chameleon          Bounty hunter, innocent, escape pod
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
INCLUDE "library/enhanced/main/variable/ship_transporter.asm"
INCLUDE "library/elite-a/flight/variable/ship_chameleon.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/elite-a/flight/variable/ship_ophidian.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"


 EQUB 8                 \ AJD

\ ******************************************************************************
\
\ Save output/S.P.bin
\
\ ******************************************************************************

PRINT "S.S.P ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/S.P.bin", CODE%, CODE% + &0A00
