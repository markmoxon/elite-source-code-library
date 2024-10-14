\ ******************************************************************************
\
\ COMMODORE 64 ELITE DATA FILE SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
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
\   * LODATA.bin
\
\ after reading in the following files:
\
\   * WORDS.bin
\   * FONT.bin
\   * IANTOK.bin
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

 CODE% = &0700
 LOAD% = &0700

 ORG CODE%

.WORDS

IF _GMA86_PAL OR _GMA85_NTSC

 INCBIN "versions/c64/1-source-files/other-files/gma85/P.WORDS.bin"

ELIF _SOURCE_DISK_BUILD

 INCBIN "versions/c64/1-source-files/other-files/source-disk-build/P.WORDS.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/other-files/source-disk-files/P.WORDS.bin"

ENDIF

.FONT

 INCBIN ("versions/c64/1-source-files/fonts/C.FONT.bin")

.IANTOK

IF _GMA86_PAL OR _GMA85_NTSC OR _SOURCE_DISK_BUILD

 INCBIN "versions/c64/1-source-files/other-files/source-disk-build/C.IANTOK.bin"

ELIF _SOURCE_DISC_FILES

 INCBIN "versions/c64/1-source-files/other-files/source-disk-files/C.IANTOK.bin"

ENDIF

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
\ Save LODATA.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.LODATA ", ~LOAD%, ~P%, " ", ~LOAD%, ~LOAD%
 SAVE "versions/c64/3-assembled-output/LODATA.bin", CODE%, P%, LOAD%
