\ ******************************************************************************
\
\ ACORN ELECTRON ELITE LOADING SCREEN SOURCE
\
\ Acorn Electron Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ This source file contains the loading screen for Acorn Electron Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * SCREEN.bin
\
\ ******************************************************************************

 INCLUDE "versions/electron/1-source-files/main-sources/elite-build-options.asm"

 _DEMO_VERSION          = (_VERSION = 0)
 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_SUPERIOR           = (_VARIANT = 1)
 _IB_ACORNSOFT          = (_VARIANT = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &1000          \ The address where the code will be run (the code is
                        \ relocatable so this address doesn't have any effect)

 LOAD% = &1000          \ The address where the code will be loaded (the code is
                        \ relocatable so this address doesn't have any effect)

 OSNEWL = &FFE7         \ The address for the OSNEWL routine

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSBYTE = &FFF4         \ The address for the OSBYTE routine

INCLUDE "library/original/loader2/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADING SCREEN
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/original/loader2/variable/echar.asm"
INCLUDE "library/original/loader2/variable/logo.asm"

 SKIP 28                \ These bytes appear to be unused
 EQUB &02, &0D
 SKIP 8

INCLUDE "library/original/loader2/subroutine/prot1.asm"

 SKIP 12                \ These bytes appear to be unused

INCLUDE "library/original/loader2/subroutine/loadscr.asm"
INCLUDE "library/original/loader2/subroutine/logos.asm"
INCLUDE "library/original/loader2/subroutine/prstr.asm"

\ ******************************************************************************
\
\ Save SCREEN.bin
\
\ ******************************************************************************

 PRINT "S.SCREEN ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/electron/3-assembled-output/SCREEN.bin", CODE%, P%, LOAD%
