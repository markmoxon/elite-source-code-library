\ ******************************************************************************
\
\ APPLE II ELITE DATA FILE SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
\
\ The code on this site is identical to the source discs released on Ian Bell's
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

IF _IB_DISK

 CODE% = &0B00
 LOAD% = &0B00

ELSE

 CODE% = &0B60
 LOAD% = &0B60

ENDIF

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

IF _IB_DISK

 INCBIN "versions/apple/1-source-files/other-files/ib-disk/A.WORDS.bin"

ELIF _SOURCE_DISK_BUILD

 INCBIN "versions/apple/1-source-files/other-files/source-disk-build/A.WORDS.bin"

ELIF _SOURCE_DISK_CODE_FILES

 INCBIN "versions/apple/1-source-files/other-files/source-disk-code-files/A.WORDS.bin"

ELIF _SOURCE_DISK_ELT_FILES

 INCBIN "versions/apple/1-source-files/other-files/source-disk-elt-files/A.WORDS.bin"

ENDIF

.IANTOK

 INCBIN "versions/apple/1-source-files/other-files/A.IANTOK.bin"

.endian

IF _SOURCE_DISK_BUILD

 EQUB &2E, &2E, &54, &72, &69, &62, &62

ELIF _IB_DISK OR _SOURCE_DISK_CODE_FILES OR _SOURCE_DISK_ELT_FILES

 EQUB &2E, &54, &72, &69, &62, &62, &6C

ENDIF

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