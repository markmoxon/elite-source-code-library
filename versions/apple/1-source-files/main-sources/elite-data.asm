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
 _IB_DISC               = (_VARIANT = 1)
 _SOURCE_DISC_BUILD     = (_VARIANT = 2)
 _SOURCE_DISC_FILES     = (_VARIANT = 3)
 _SOURCE_DISC_ELT_FILES = (_VARIANT = 4)

 CODE% = &0B60
 LOAD% = &0B60

 ORG CODE%

.WORDS

IF _SOURCE_DISC_BUILD

 INCBIN "versions/apple/1-source-files/other-files/source-disc-build/A.WORDS.bin"

ELIF _SOURCE_DISC_FILES OR _SOURCE_DISC_ELT_FILES

 INCBIN "versions/apple/1-source-files/other-files/source-disc-files/A.WORDS.bin"

ENDIF

.IANTOK

 INCBIN "versions/apple/1-source-files/other-files/A.IANTOK.bin"

.endian

IF _SOURCE_DISC_BUILD

 EQUB &2E, &2E, &54, &72, &69, &62, &62

ELIF _SOURCE_DISC_FILES OR _SOURCE_DISC_ELT_FILES

 EQUB &2E, &54, &72, &69, &62, &62, &6C

ENDIF

.FONT

IF _SOURCE_DISC_BUILD

 INCBIN "versions/apple/1-source-files/fonts/source-disc-build/A.FONT.bin"

ELIF _SOURCE_DISC_FILES OR _SOURCE_DISC_ELT_FILES

 INCBIN "versions/apple/1-source-files/fonts/source-disc-files/A.FONT.bin"

ENDIF


\ ******************************************************************************
\
\ Save LODATA.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.LODATA ", ~LOAD%, ~P%, " ", ~LOAD%, ~LOAD%
 SAVE "versions/apple/3-assembled-output/DATA.unprot.bin", CODE%, P%, LOAD%

 PRINT "IANTOK = ", ~IANTOK
 PRINT "FONT = ", ~FONT