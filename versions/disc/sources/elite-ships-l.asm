\ ******************************************************************************
\
\ DISC ELITE SHIP BLUEPRINTS FILE L
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/D.MOL.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE

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
\    Summary: Ship blueprints lookup table for the D.MOL file
\  Deep dive: Ship blueprints in the disc version
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW SHIP_DODO         \ SST  =  2 = Dodo space station
 EQUW SHIP_ESCAPE_POD   \ ESC  =  3 = Escape pod
 EQUW 0
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW 0
 EQUW 0
 EQUW SHIP_ANACONDA     \ ANA  = 14 = Anaconda
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW SHIP_MAMBA        \        18 = Mamba
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_WORM         \ WRM  = 23 = Worm
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_FER_DE_LANCE \        27 = Fer-de-lance
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the D.MOL file
\
\ ******************************************************************************

.E%

 EQUB %00000000         \ Missile
 EQUB %00000000         \ Dodo space station
 EQUB %00000001         \ Escape pod                                      Trader
 EQUB 0
 EQUB %00000000         \ Cargo canister
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB %10100001         \ Anaconda                  Trader, innocent, escape pod
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB %00001100         \ Sidewinder                             Hostile, pirate
 EQUB %10001100         \ Mamba                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %00000100         \ Worm                                           Hostile
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10000010         \ Fer-de-lance                 Bounty hunter, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/6502sp/main/variable/ship_dodo.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/6502sp/main/variable/ship_anaconda.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/6502sp/main/variable/ship_worm.asm"
INCLUDE "library/6502sp/main/variable/ship_fer_de_lance.asm"

\ ******************************************************************************
\
\ Save output/D.MOL.bin
\
\ ******************************************************************************

PRINT "S.D.MOL ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/D.MOL.bin", CODE%, CODE% + &A00

