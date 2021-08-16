\ ******************************************************************************
\
\ ELITE-A SHIP BLUEPRINTS FILE T
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
\   * output/S.T.bin
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
_ELITE_A_SHIPS_R        = FALSE
_ELITE_A_SHIPS_S        = FALSE
_ELITE_A_SHIPS_T        = TRUE
_ELITE_A_SHIPS_U        = FALSE
_ELITE_A_SHIPS_V        = FALSE
_ELITE_A_SHIPS_W        = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = FALSE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)
_BUG_FIX                = (_RELEASE = 3)

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
\    Summary: Ship blueprints lookup table for the S.T file
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
 EQUW SHIP_SHUTTLE_MK_2 \ SHU  =  9 = Shuttle Mk II                      Shuttle
 EQUW 0                 \                                            Transporter
 EQUW SHIP_COBRA_MK_3   \        11 = Cobra Mk III                        Trader
 EQUW 0                 \                                                 Trader
 EQUW SHIP_IGUANA       \        13 = Iguana                              Trader
 EQUW 0                 \                                             Large ship
 EQUW 0                 \                                             Small ship
 EQUW SHIP_VIPER        \ COPS = 16 = Viper                                  Cop
 EQUW SHIP_KRAIT        \        17 = Krait                               Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW SHIP_IGUANA       \        20 = Iguana                              Pirate
 EQUW SHIP_COBRA_MK_3   \        21 = Cobra Mk III                        Pirate
 EQUW 0                 \                                                 Pirate
 EQUW 0                 \                                                 Pirate
 EQUW SHIP_ASP_MK_2     \        24 = Asp Mk II                           Pirate
 EQUW SHIP_COBRA_MK_3   \        25 = Cobra Mk III                 Bounty hunter
 EQUW SHIP_IGUANA       \        26 = Iguana                       Bounty hunter
 EQUW SHIP_ASP_MK_2     \        27 = Asp Mk II                    Bounty hunter
 EQUW SHIP_KRAIT        \        28 = Krait                        Bounty hunter
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                               Thargoid
 EQUW 0                 \                                            Constrictor

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the S.T file
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
 EQUB %00100001         \ Shuttle Mk II                         Trader, innocent
 EQUB 0
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB 0
 EQUB %10100000         \ Iguana                            Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %10001100         \ Krait                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB %10001100         \ Iguana                     Hostile, pirate, escape pod
 EQUB %10000100         \ Cobra Mk III                       Hostile, escape pod
 EQUB 0
 EQUB 0
 EQUB %10001100         \ Asp Mk II                  Hostile, pirate, escape pod
 EQUB %10000010         \ Cobra Mk III                 Bounty hunter, escape pod
 EQUB %10100010         \ Iguana             Bounty hunter, innocent, escape pod
 EQUB %10000010         \ Asp Mk II                    Bounty hunter, escape pod
 EQUB %10100010         \ Krait              Bounty hunter, innocent, escape pod
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
INCLUDE "library/elite-a/flight/variable/ship_shuttle_mk_2.asm"
INCLUDE "library/elite-a/flight/variable/ship_iguana.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"

 EQUB 6                 \ This byte appears to be unused

\ ******************************************************************************
\
\ Save output/S.T.bin
\
\ ******************************************************************************

PRINT "S.S.T ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/S.T.bin", CODE%, CODE% + &0A00
