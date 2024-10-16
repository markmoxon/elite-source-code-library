\ ******************************************************************************
\
\ COMMODORE 64 ELITE GAME DATA FILE SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source disks released on Ian Bell's
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
\ This source file produces the following binary files:
\
\	* IANTOK.bin
\   * LODATA.bin
\	* WORDS.bin
\
\ after reading in the following file:
\
\   * FONT.bin
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
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISC_FILES     = (_VARIANT = 4)
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

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &0700    		\ The address where the code will be run

 LOAD% = &4000    		\ The address where the code will be loaded

 RE = &23               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ ******************************************************************************

 ORG CODE%

.WORDS

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
 PRINT "Assembled at ", ~WORDS
 PRINT "Ends at ", ~P%
 PRINT "Code size is ", ~(P% - WORDS)
 PRINT "Execute at ", ~LOAD%
 PRINT "Reload at ", ~LOAD%

 PRINT "S.C.WORDS ",~WORDS," ",~P%," ",~LOAD%," ",~LOAD%
 SAVE "versions/c64/3-assembled-output/WORDS.bin", WORDS, P%, LOAD%

\ ******************************************************************************
\
\ ELITE FONT FILE
\
\ ******************************************************************************

.FONT

 INCBIN ("versions/c64/1-source-files/fonts/C.FONT.bin")

\ ******************************************************************************
\
\ ELITE EXTENDED TEXT TOKEN FILE
\
\ ******************************************************************************

.IANTOK

INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"

.ENDTOK

IF _GMA86_PAL OR _GMA85_NTSC

 EQUB &3A, &4C, &44, &41, &58, &58, &31, &2B
 EQUB &31, &3A, &41, &44, &43, &23, &30, &3A
 EQUB &53, &54, &41, &58, &58, &31, &35, &2B
 EQUB &31, &3A, &4A, &4D, &50, &4C, &4C, &35
 EQUB &33, &0D, &21, &7A, &3D, &2E, &4C, &4C
 EQUB &35, &32, &20, &4C, &44, &41, &58, &58
 EQUB &31, &3A, &53

ELIF _SOURCE_DISK_BUILD

 EQUB &3E, &4C, &20, &59, &3C, &32, &31, &37
 EQUB &3E, &20, &54, &41, &4B, &45, &20, &3C
 EQUB &32, &31, &39, &3E, &3C, &30, &30, &31
 EQUB &3E, &28, &59, &2F, &4E, &29, &3F, &3C
 EQUB &30, &31, &32, &3E, &3C, &30, &31, &35
 EQUB &3E, &3C, &30, &30, &31, &3E, &3C, &30
 EQUB &30, &38, &3E

ELIF _SOURCE_DISC_FILES

 EQUB &3A, &4C, &44, &41, &58, &58, &31, &2B
 EQUB &31, &3A, &41, &44, &43, &23, &30, &3A
 EQUB &53, &54, &41, &58, &58, &31, &35, &2B
 EQUB &31, &3A, &4A, &4D, &50, &4C, &4C, &35
 EQUB &33, &0D, &21, &7A, &3D, &2E, &4C, &4C
 EQUB &35, &32, &20, &4C, &44, &41, &58, &58
 EQUB &31, &3A, &53

ENDIF

\ ******************************************************************************
\
\ Save WORDS.bin
\
\ ******************************************************************************

 PRINT "IANTOK"
 PRINT "Assembled at ", ~IANTOK
 PRINT "Ends at ", ~ENDTOK
 PRINT "Code size is ", ~(ENDTOK - IANTOK)
 PRINT "Execute at ", ~(IANTOK + LOAD% - CODE%)
 PRINT "Reload at ", ~(IANTOK + LOAD% - CODE%)

 PRINT "S.C.IANTOK ",~IANTOK," ",~ENDTOK," ",~(IANTOK + LOAD% - CODE%)," ",~(IANTOK + LOAD% - CODE%)
 SAVE "versions/c64/3-assembled-output/IANTOK.bin", IANTOK, ENDTOK, IANTOK + LOAD% - CODE%

\ ******************************************************************************
\
\ Save LODATA.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.LODATA ", ~LOAD%, ~P%, " ", ~LOAD%, ~LOAD%
 SAVE "versions/c64/3-assembled-output/LODATA.bin", CODE%, P%, LOAD%
