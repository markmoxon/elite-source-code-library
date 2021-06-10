\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 1) SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITE2.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE
_ELITE_A_DOCKED         = FALSE
_ELITE_A_FLIGHT         = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = FALSE
_IB_DISC                = (_RELEASE = 1)
_STH_DISC               = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

BYTEV = &020A           \ The BYTEV vector that we check as part of the copy
                        \ protection

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI routine

INCLUDE "library/disc/loader1/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

CODE% = &2F00
LOAD% = &2F00

ORG CODE%

INCLUDE "library/disc/loader1/subroutine/begin.asm"
INCLUDE "library/disc/loader1/subroutine/elite_loader.asm"

 NOP                    \ These bytes appear to be unused
 NOP
 NOP
 NOP

INCLUDE "library/disc/loader1/variable/mess2.asm"
INCLUDE "library/disc/loader1/subroutine/load.asm"
INCLUDE "library/disc/loader1/variable/b_per_cent.asm"

 SKIP 2                 \ These bytes appear to be unused

INCLUDE "library/disc/loader1/variable/params3.asm"
INCLUDE "library/disc/loader1/variable/params2.asm"
INCLUDE "library/disc/loader1/variable/params1.asm"
INCLUDE "library/disc/loader1/variable/mess1.asm"
INCLUDE "library/disc/loader1/variable/block.asm"

\ ******************************************************************************
\
\ Save output/ELITE2.bin
\
\ ******************************************************************************

PRINT "S.ELITE2 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE2.bin", CODE%, P%, LOAD%