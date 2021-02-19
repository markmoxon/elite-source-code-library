\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE I/O LOADER (PART 2) SOURCE
\
\ 6502 Second Processor Elite was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1985
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITEa.bin
\
\ after reading in the following files:
\
\   * binaries/P.DIALS2P.bin
\   * binaries/P.DATE2P.bin
\   * binaries/Z.ACSOFT.bin
\   * binaries/Z.ELITE.bin
\   * binaries/Z.(C)ASFT.bin
\
\ ******************************************************************************

INCLUDE "versions/6502sp/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_SOURCE_DISC            = (_RELEASE = 1)
_SNG45                  = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

D% = &D000              \ The address where the ship blueprints get moved to
                        \ after loading, so they go from &D000 to &F200

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI routine

INCLUDE "library/6502sp/loader2/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

CODE% = &2000
LOAD% = &2000

ORG CODE%

INCLUDE "library/6502sp/loader2/macro/mve.asm"
INCLUDE "library/6502sp/loader2/subroutine/elite_loader_part_1_of_2.asm"
INCLUDE "library/6502sp/loader2/variable/mess2.asm"
INCLUDE "library/6502sp/loader2/variable/mess3.asm"
INCLUDE "library/6502sp/loader2/subroutine/mvbl.asm"
INCLUDE "library/6502sp/loader2/subroutine/elite_loader_part_2_of_2.asm"

\ ******************************************************************************
\
\ Save output/ELITEa.bin
\
\ ******************************************************************************

PRINT "S.ELITEa ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/6502sp/output/ELITEa.bin", CODE%, P%, LOAD%
