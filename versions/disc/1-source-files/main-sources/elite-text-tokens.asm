\ ******************************************************************************
\
\ BBC MICRO DISC ELITE GAME DATA SOURCE
\
\ BBC Micro disc Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ This source file contains the game data for BBC Micro disc Elite, including
\ the game text.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * WORDS.bin
\
\ This gets loaded as part of elite-loader3.asm and gets moved to &0400 during
\ the loading process.
\
\ The binary file also includes the sine and arctan tables, so the three parts
\ end up as follows:
\
\   * Recursive token table:    QQ18 = &0400 to &07FF
\   * Sine lookup table:        SNE  = &07C0 to &07DF
\   * Arctan lookup table:      ACT  = &07E0 to &07FF
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
 _DISC_DOCKED           = TRUE
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
 _IB_DISC               = (_VARIANT = 1)
 _STH_DISC              = (_VARIANT = 2)
 _SRAM_DISC             = (_VARIANT = 3)

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE_WORDS% = &0400    \ The address where the text data will be run

 LOAD_WORDS% = &254B    \ The address where the text data will be loaded

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 ORG CODE_WORDS%        \ Set the assembly address to CODE_WORDS%

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"

\ ******************************************************************************
\
\ Save WORDS.bin
\
\ ******************************************************************************

 PRINT "WORDS"
 PRINT "Assembled at ", ~CODE_WORDS%
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - CODE_WORDS%)
 PRINT "Execute at ", ~LOAD_WORDS%
 PRINT "Reload at ", ~LOAD_WORDS%

 PRINT "S.WORDS ", ~CODE_WORDS%, " ", ~P%, " ", ~LOAD_WORDS%, " ", ~LOAD_WORDS%
 SAVE "versions/disc/3-assembled-output/WORDS.bin", CODE_WORDS%, P%, LOAD_WORDS%
