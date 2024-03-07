\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE I/O LOADER (PART 2) SOURCE
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
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
\   * ELITEa.bin
\
\ after reading in the following files:
\
\   * P.DIALS2P.bin
\   * P.DATE2P.bin
\   * Z.ACSOFT.bin
\   * Z.ELITE.bin
\   * Z.(C)ASFT.bin
\
\ ******************************************************************************

 INCLUDE "versions/6502sp/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _SOURCE_DISC           = (_VARIANT = 1)
 _SNG45                 = (_VARIANT = 2)
 _EXECUTIVE             = (_VARIANT = 3)

 GUARD &4000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &2000          \ The address where the code will be run

 LOAD% = &2000          \ The address where the code will be loaded

 D% = &D000             \ The address where the ship blueprints get moved to
                        \ after loading, so they go from &D000 to &F200

 OSCLI = &FFF7          \ The address for the OSCLI routine

INCLUDE "library/6502sp/loader2/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

INCLUDE "library/6502sp/loader2/macro/mve.asm"
INCLUDE "library/6502sp/loader2/subroutine/elite_loader_part_1_of_2.asm"
INCLUDE "library/6502sp/loader2/variable/mess2.asm"
INCLUDE "library/6502sp/loader2/variable/mess3.asm"
INCLUDE "library/6502sp/loader2/subroutine/mvbl.asm"
INCLUDE "library/6502sp/loader2/subroutine/elite_loader_part_2_of_2.asm"

\ ******************************************************************************
\
\ Save ELITEa.bin
\
\ ******************************************************************************

 PRINT "S.ELITEa ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/6502sp/3-assembled-output/ELITEa.bin", CODE%, P%, LOAD%
