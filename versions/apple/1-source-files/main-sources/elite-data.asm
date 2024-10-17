\ ******************************************************************************
\
\ APPLE II ELITE DATA FILE SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
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
\ This source file produces the following binary file:
\
\   * DATA.unprot.bin
\
\ after reading in the following files:
\
\   * WORDS.bin
\   * IANTOK.bin
\   * FONT.bin
\
\ ******************************************************************************

 INCLUDE "versions/apple/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_DISK               = (_VARIANT = 1)
 _SOURCE_DISK_BUILD     = (_VARIANT = 2)
 _SOURCE_DISK_CODE_FILES = (_VARIANT = 3)
 _SOURCE_DISK_ELT_FILES = (_VARIANT = 4)
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

IF _IB_DISK

 CODE% = &0B00    		\ The address where the code will be run

 LOAD% = &0B00    		\ The address where the code will be loaded

ELSE

 CODE% = &0B60    		\ The address where the code will be run

 LOAD% = &0B60    		\ The address where the code will be loaded

ENDIF

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

IF _IB_DISK

 EQUB &5B, &79, &55, &82, &56, &88, &5B, &75
 EQUB &53, &6F, &4E, &76, &4E, &7E, &54, &6F
 EQUB &4E, &76, &4E, &75, &53, &7E, &54, &79
 EQUB &55, &82, &56, &81, &5B, &88, &5B, &90
 EQUB &61, &90, &63, &8C, &61, &90, &63, &90
 EQUB &61, &8C, &61, &60, &45, &5F, &44, &5F
 EQUB &44, &64, &45, &60, &45, &64, &45, &8A
 EQUB &1E, &8A, &18, &86, &1C, &8A, &1E, &6D
 EQUB &66, &69, &6A, &69, &6A, &69, &64, &6D
 EQUB &66, &69, &64, &6C, &6A, &6B, &66, &6F
 EQUB &66, &6B, &66, &20, &45, &51, &55, &57
 EQUB &26, &33, &43, &33, &43, &3A, &45, &51

ENDIF

.WORDS

INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/common/main/variable/sne.asm"

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

 PRINT "S.A.WORDS ",~WORDS," ",~P%," ",~LOAD%," ",~LOAD%
 SAVE "versions/apple/3-assembled-output/WORDS.bin", WORDS, P%, LOAD%

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

.endian

IF _SOURCE_DISK_BUILD

 EQUB &2E, &2E, &54, &72, &69, &62, &62

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES OR _SOURCE_DISK_ELT_FILES

 EQUB &2E, &54, &72, &69, &62, &62, &6C

ENDIF

\ ******************************************************************************
\
\ Save IANTOK.bin
\
\ ******************************************************************************

 PRINT "IANTOK"
 PRINT "Assembled at ", ~IANTOK
 PRINT "Ends at ", ~endian
 PRINT "Code size is ", ~(endian - IANTOK)
 PRINT "Execute at ", ~(IANTOK + LOAD% - CODE%)
 PRINT "Reload at ", ~(IANTOK + LOAD% - CODE%)

 PRINT "S.C.IANTOK ",~IANTOK," ",~endian," ",~(IANTOK + LOAD% - CODE%)," ",~(IANTOK + LOAD% - CODE%)
 SAVE "versions/apple/3-assembled-output/IANTOK.bin", IANTOK, endian, IANTOK + LOAD% - CODE%

\ ******************************************************************************
\
\ ELITE FONT FILE
\
\ ******************************************************************************

.FONT

IF _SOURCE_DISK_BUILD

 INCBIN "versions/apple/1-source-files/fonts/A.FLOWY.bin"

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES OR _SOURCE_DISK_ELT_FILES

 INCBIN "versions/apple/1-source-files/fonts/A.FONT.bin"

ENDIF

\ ******************************************************************************
\
\ Save DATA.unprot.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.DATA ", ~LOAD%, ~P%, " ", ~LOAD%, ~LOAD%
 SAVE "versions/apple/3-assembled-output/DATA.unprot.bin", CODE%, P%, LOAD%

 PRINT "IANTOK = ", ~IANTOK
 PRINT "FONT = ", ~FONT