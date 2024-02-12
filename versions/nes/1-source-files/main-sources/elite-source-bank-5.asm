\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 5)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
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
\   * bank5.bin
\
\ ******************************************************************************

 _BANK = 5

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

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

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 5
\
\ Produces the binary file bank5.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/nes/main/variable/systemcount.asm"
INCLUDE "library/nes/main/variable/systemoffset.asm"
INCLUDE "library/nes/main/variable/systemimage0.asm"
INCLUDE "library/nes/main/variable/systemimage1.asm"
INCLUDE "library/nes/main/variable/systemimage2.asm"
INCLUDE "library/nes/main/variable/systemimage3.asm"
INCLUDE "library/nes/main/variable/systemimage4.asm"
INCLUDE "library/nes/main/variable/systemimage5.asm"
INCLUDE "library/nes/main/variable/systemimage6.asm"
INCLUDE "library/nes/main/variable/systemimage7.asm"
INCLUDE "library/nes/main/variable/systemimage8.asm"
INCLUDE "library/nes/main/variable/systemimage9.asm"
INCLUDE "library/nes/main/variable/systemimage10.asm"
INCLUDE "library/nes/main/variable/systemimage11.asm"
INCLUDE "library/nes/main/variable/systemimage12.asm"
INCLUDE "library/nes/main/variable/systemimage13.asm"
INCLUDE "library/nes/main/variable/systemimage14.asm"
INCLUDE "library/nes/main/variable/copyright-message.asm"
INCLUDE "library/nes/main/subroutine/getsystemimage.asm"
INCLUDE "library/nes/main/subroutine/getsystemback.asm"
INCLUDE "library/nes/main/subroutine/setdemoautoplay.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1lo.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1hi.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank5.bin
\
\ ******************************************************************************

 PRINT "S.bank5.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank5.bin", CODE%, P%, LOAD%
