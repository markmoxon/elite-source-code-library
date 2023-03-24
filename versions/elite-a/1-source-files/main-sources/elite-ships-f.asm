\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE F
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
\   * S.F.bin
\
\ ******************************************************************************

 INCLUDE "versions/elite-a/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = TRUE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE
 _RELEASED              = (_VARIANT = 1)
 _SOURCE_DISC           = (_VARIANT = 2)
 _BUG_FIX               = (_VARIANT = 3)

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 SHIP_MISSILE = &7F00   \ The address of the missile ship blueprint

 CODE% = &5600          \ The flight code loads this file at address &5600, at
 LOAD% = &5600          \ label XX21

 ORG CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the S.F file
\  Deep dive: Ship blueprints in Elite-A
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile                            Missile
 EQUW SHIP_DODO         \         2 = Dodo space station                 Station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod                      Escape pod
 EQUW SHIP_PLATE        \ PLT  =  4 = Alloy plate                          Cargo
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister                       Cargo
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                Shuttle
 EQUW 0                 \                                            Transporter
 EQUW SHIP_PYTHON       \        11 = Python                              Trader
 EQUW SHIP_OPHIDIAN     \        12 = Ophidian                            Trader
 EQUW SHIP_BOA          \        13 = Boa                                 Trader
 EQUW 0                 \                                             Large ship
 EQUW 0                 \                                             Small ship
 EQUW SHIP_VIPER        \ COPS = 16 = Viper                                  Cop
 EQUW SHIP_MAMBA        \        17 = Mamba                               Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW SHIP_BUSHMASTER   \        20 = Bushmaster                          Pirate
 EQUW SHIP_OPHIDIAN     \        21 = Ophidian                            Pirate
 EQUW SHIP_PYTHON       \        22 = Python                              Pirate
 EQUW SHIP_IGUANA       \        23 = Iguana                              Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                          Bounty hunter
 EQUW SHIP_BUSHMASTER   \        26 = Bushmaster                   Bounty hunter
 EQUW SHIP_PYTHON       \        27 = Python                       Bounty hunter
 EQUW SHIP_OPHIDIAN     \        28 = Ophidian                     Bounty hunter
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                            Constrictor

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.F file
\  Deep dive: Ship blueprints in Elite-A
\             Advanced tactics with the NEWB flags
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %01000000         \ Dodo space station                                 Cop
 EQUB %01000001         \ Escape pod                                 Trader, cop
 EQUB %00000000         \ Alloy plate
 EQUB %00000000         \ Cargo canister
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Python                            Innocent, escape pod
 EQUB %10100001         \ Ophidian                  Trader, innocent, escape pod
 EQUB %10100000         \ Boa                               Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %10001100         \ Mamba                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB %10001100         \ Bushmaster                 Hostile, pirate, escape pod
 EQUB %10000100         \ Ophidian                           Hostile, escape pod
 EQUB %10001100         \ Python                     Hostile, pirate, escape pod
 EQUB %10000100         \ Iguana                             Hostile, escape pod
 EQUB 0
 EQUB 0
 EQUB %10100010         \ Bushmaster         Bounty hunter, innocent, escape pod
 EQUB %10000010         \ Python                       Bounty hunter, escape pod
 EQUB %10100010         \ Ophidian           Bounty hunter, innocent, escape pod
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
INCLUDE "library/elite-a/flight/variable/ship_ophidian.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/elite-a/flight/variable/ship_bushmaster.asm"
INCLUDE "library/elite-a/flight/variable/ship_iguana.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"

 EQUB 6                 \ This byte appears to be unused

\ ******************************************************************************
\
\ Save S.F.bin
\
\ ******************************************************************************

 PRINT "S.S.F ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/elite-a/3-assembled-output/S.F.bin", CODE%, CODE% + &0A00
