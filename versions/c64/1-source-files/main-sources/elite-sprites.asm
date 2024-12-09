\ ******************************************************************************
\
\ COMMODORE 64 ELITE SPRITES SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code in this file is identical to the source disks released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains sprite definitions for Commodore 64 Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * SPRITE.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85_NTSC            = (_VARIANT = 1)
 _GMA86_PAL             = (_VARIANT = 2)
 _GMA_RELEASE           = (_VARIANT = 1) OR (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)
 _SOURCE_DISK           = (_VARIANT = 3) OR (_VARIANT = 4)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7C3A          \ The address where the code will be run

 LOAD% = &7C3A          \ The address where the code will be loaded

\ ******************************************************************************
\
\ ELITE SPRITES
\
\ ******************************************************************************

 ORG CODE%

INCLUDE "library/c64/data/macro/sprite2.asm"
INCLUDE "library/c64/data/macro/sprite2_byte.asm"
INCLUDE "library/c64/data/macro/sprite4.asm"
INCLUDE "library/c64/data/macro/sprite4_byte.asm"
INCLUDE "library/c64/data/variable/spritp.asm"

\ ******************************************************************************
\
\ Save SPRITE.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.SPRITE ", ~CODE%, " +1C0"
 SAVE "versions/c64/3-assembled-output/SPRITE.bin", CODE%, P%, LOAD%
