\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE N
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
\ https://www.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * S.N.bin
\
\ ******************************************************************************

 INCLUDE "versions/elite-a/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
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

 CODE% = &5600          \ The flight code runs this file at address &5600, at
           				\ label XX21

 LOAD% = &5600			\ The flight code loads this file at address &5600, at
           				\ label XX21

 SHIP_MISSILE = &7F00   \ The address of the missile ship blueprint

 ORG CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the S.N file
\  Deep dive: Ship blueprints in Elite-A
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile                            Missile
 EQUW SHIP_DODO         \         2 = Dodo space station                 Station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod                      Escape pod
 EQUW 0                 \                                                  Cargo
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister                       Cargo
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                 Mining
 EQUW 0                 \                                                Shuttle
 EQUW 0                 \                                            Transporter
 EQUW SHIP_COBRA_MK_3   \        11 = Cobra Mk III                        Trader
 EQUW SHIP_RATTLER      \        12 = Rattler                             Trader
 EQUW SHIP_PYTHON       \        13 = Python                              Trader
 EQUW 0                 \                                             Large ship
 EQUW 0                 \                                             Small ship
 EQUW SHIP_VIPER        \ COPS = 16 = Viper                                  Cop
 EQUW SHIP_GECKO        \        17 = Gecko                               Pirate
 EQUW SHIP_KRAIT        \        18 = Krait                               Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW SHIP_COBRA_MK_3   \        21 = Cobra Mk III                        Pirate
 EQUW SHIP_RATTLER      \        22 = Rattler                             Pirate
 EQUW SHIP_PYTHON       \        23 = Python                              Pirate
 EQUW SHIP_ASP_MK_2     \        24 = Asp Mk II                           Pirate
 EQUW SHIP_COBRA_MK_3   \        25 = Cobra Mk III                 Bounty hunter
 EQUW 0                 \                                          Bounty hunter
 EQUW SHIP_GECKO        \        27 = Gecko                        Bounty hunter
 EQUW SHIP_RATTLER      \        28 = Rattler                      Bounty hunter
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                            Constrictor

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.N file
\  Deep dive: Ship blueprints in Elite-A
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
 EQUB 0
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB %10100001         \ Rattler                   Trader, innocent, escape pod
 EQUB %10100000         \ Python                            Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %10001100         \ Gecko                      Hostile, pirate, escape pod
 EQUB %10001100         \ Krait                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB %10000100         \ Cobra Mk III                       Hostile, escape pod
 EQUB %10001100         \ Rattler                    Hostile, pirate, escape pod
 EQUB %10000100         \ Python                             Hostile, escape pod
 EQUB %10001100         \ Asp Mk II                  Hostile, pirate, escape pod
 EQUB %10000010         \ Cobra Mk III                 Bounty hunter, escape pod
 EQUB 0
 EQUB %10000010         \ Gecko                        Bounty hunter, escape pod
 EQUB %10100010         \ Rattler            Bounty hunter, innocent, escape pod
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
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/elite-a/flight/variable/ship_rattler.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"

 EQUB 5                 \ This byte appears to be unused

\ ******************************************************************************
\
\ Save S.N.bin
\
\ ******************************************************************************

 PRINT "S.S.N ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/elite-a/3-assembled-output/S.N.bin", CODE%, CODE% + &0A00
