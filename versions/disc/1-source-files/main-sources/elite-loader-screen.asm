\ ******************************************************************************
\
\ BBC MICRO DISC ELITE SIDEWAYS RAM LOADING SCREEN SOURCE
\
\ BBC Micro disc Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
\
\ The sideways RAM menu and loader were written by Stuart McConnachie in 1988-9
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
\ This source file contains the loading screen for the sideways RAM variant of
\ BBC Micro disc Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * SCREEN.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

 _IB_DISC               = (_VARIANT = 1)
 _STH_DISC              = (_VARIANT = 2)
 _SRAM_DISC             = (_VARIANT = 3)

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7800          \ The address where the code will be run

 LOAD% = &7800          \ The address where the code will be loaded

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

\ ******************************************************************************
\
\ ELITE LOADING SCREEN
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/disc/loader-sideways-ram/variable/screendata.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/loadscreen.asm"

 EQUB &20, &20          \ These bytes appear to be unused
 EQUB &20, &20

\ ******************************************************************************
\
\ Save SCREEN.bin
\
\ ******************************************************************************

 PRINT "S.SCREEN ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/SCREEN.bin", CODE%, P%, LOAD%