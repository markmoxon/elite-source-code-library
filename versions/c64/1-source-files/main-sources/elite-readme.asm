\ ******************************************************************************
\
\ COMMODORE 64 ELITE README
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
\ This source file produces a README file for Commodore 64 Elite.
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
 _GMA86_PAL             = (_VARIANT = 2)
 _GMA_RELEASE           = (_VARIANT = 1) OR (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)
 _SOURCE_DISK           = (_VARIANT = 3) OR (_VARIANT = 4)

MACRO CAP x
 EQUB x + 128
ENDMACRO

.readme

 EQUB 13
 EQUS "---------------------------------------"
 EQUB 13
 CAP 'F'
 EQUS "IREBIRD "
 CAP 'E'
 EQUS "LITE"
 EQUB 13
 EQUB 13
 CAP 'V'
 EQUS "ERSION: "
 CAP 'C'
 EQUS "OMMODORE 64"
 EQUB 13

IF _GMA85_NTSC

 CAP 'V'
 EQUS "ARIANT: "
 CAP 'G'
 CAP 'M'
 CAP 'A'
 EQUS "85 "
 CAP 'N'
 CAP 'T'
 CAP 'S'
 CAP 'C'
 EQUS " RELEASE"
 EQUB 13
 CAP 'P'
 EQUS "RODUCT: "
 CAP 'F'
 EQUS "IREBIRD "
 CAP 'G'
 CAP 'M'
 CAP 'A'
 EQUS "85"
 EQUB 13

ELIF _GMA86_PAL

 CAP 'V'
 EQUS "ARIANT: "
 CAP 'G'
 CAP 'M'
 CAP 'A'
 EQUS "86 "
 CAP 'P'
 CAP 'A'
 CAP 'L'
 EQUS " RELEASE"
 EQUB 13
 CAP 'P'
 EQUS "RODUCT: "
 CAP 'F'
 EQUS "IREBIRD "
 CAP 'G'
 CAP 'M'
 CAP 'A'
 EQUS "86"
 EQUB 13

ELIF _SOURCE_DISK_BUILD

 CAP 'V'
 EQUS "ARIANT: "
 CAP 'S'
 EQUS "OURCE DISK BUILD OUTPUT"
 EQUB 13

ELIF _SOURCE_DISK_FILES

 CAP 'V'
 EQUS "ARIANT: "
 CAP 'S'
 EQUS "OURCE DISK BINARY FILES"
 EQUB 13

ENDIF

 EQUB 13
 CAP 'S'
 EQUS "EE WWW.BBCELITE.COM FOR DETAILS"
 EQUB 13
 EQUS "---------------------------------------"
 EQUB 13

 SAVE "versions/c64/3-assembled-output/README.txt", readme, P%

