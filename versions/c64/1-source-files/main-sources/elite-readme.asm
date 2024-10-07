\ ******************************************************************************
\
\ COMMODORE 64 ELITE README
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
\   * README.txt
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
 _GMA85_PAL             = (_VARIANT = 2)
 _SOURCE_DISC_BUILD     = (_VARIANT = 3)
 _SOURCE_DISC_FILES     = (_VARIANT = 4)

.readme

 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13
 EQUS "Firebird Elite"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "Version: Commodore 64"
 EQUB 10, 13

 EQUS "Variant: Source disc"
 EQUB 10, 13

 EQUB 10, 13
 EQUS "See www.bbcelite.com for details"
 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13

 SAVE "versions/c64/3-assembled-output/README.txt", readme, P%

