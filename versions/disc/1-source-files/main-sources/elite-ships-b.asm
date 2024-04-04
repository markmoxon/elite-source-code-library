\ ******************************************************************************
\
\ DISC ELITE SHIP BLUEPRINTS FILE B
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\   * D.MOB.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

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
 _DISC_FLIGHT           = TRUE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &5600          \ The flight code runs this file at address &5600, at
                        \ label XX21

 LOAD% = &5600          \ The flight code loads this file at address &5600, at
                        \ label XX21

 SHIP_MISSILE = &7F00   \ The address of the missile ship blueprint

 ORG CODE%

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the D.MOB file
\  Deep dive: Ship blueprints in the disc version
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_DODO         \ SST  =  2 = Dodo space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW SHIP_PLATE        \ PLT  =  4 = Alloy plate
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW SHIP_BOULDER      \         6 = Boulder
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW 0
 EQUW SHIP_MAMBA        \        18 = Mamba
 EQUW SHIP_KRAIT        \ KRA  = 19 = Krait
 EQUW SHIP_ADDER        \ ADA  = 20 = Adder
 EQUW 0
 EQUW 0
 EQUW SHIP_WORM         \ WRM  = 23 = Worm
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the D.MOB file
\  Deep dive: Ship blueprints in the disc version
\             Advanced tactics with the NEWB flags
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %00000000         \ Dodo space station
 EQUB %00000001         \ Escape pod                                      Trader
 EQUB %00000000         \ Alloy plate
 EQUB %00000000         \ Cargo canister
 EQUB %00000000         \ Boulder
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB 0
 EQUB %10001100         \ Mamba                      Hostile, pirate, escape pod
 EQUB %10001100         \ Krait                      Hostile, pirate, escape pod
 EQUB %10001100         \ Adder                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB %00000100         \ Worm                                           Hostile
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/enhanced/main/variable/ship_adder.asm"
INCLUDE "library/enhanced/main/variable/ship_worm.asm"

\ ******************************************************************************
\
\ Save D.MOB.bin
\
\ ******************************************************************************

 PRINT "S.D.MOB ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/D.MOB.bin", CODE%, CODE% + &0A00

