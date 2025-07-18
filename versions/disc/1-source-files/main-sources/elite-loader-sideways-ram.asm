\ ******************************************************************************
\
\ BBC MICRO DISC ELITE SIDEWAYS RAM LOADER SOURCE
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
\ This source file contains the game loader for the sideways RAM variant of BBC
\ Micro disc Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * MNUCODE.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

 CPU 1                  \ Switch to 65SC12 assembly, as this code contains a
                        \ BBC Master DEC A instruction

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = TRUE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE
 _IB_DISC               = (_VARIANT = 1)
 _STH_DISC              = (_VARIANT = 2)
 _SRAM_DISC             = (_VARIANT = 3)

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7400          \ The address where the code will be run

 LOAD% = &7400          \ The address where the code will be loaded

 IND1V = &0230          \ The IND1 vector

 LANGROM = &028C        \ Current language ROM in MOS workspace

 ROMTYPE = &02A1        \ Paged ROM type table in MOS workspace

 XFILEV = &0DBA         \ The extended FILE vector

 XIND1V = &0DE7         \ The extended IND1 vector

 XX21 = &5600           \ The address of the ship blueprints lookup table in the
                        \ current blueprints file

 E% = &563E             \ The address of the default NEWB flags in the current
                        \ blueprints file

 ROM_XX21 = &8100       \ The address of the ship blueprints lookup table in the
                        \ sideways RAM image that we build

 ROM_E% = &813E         \ The address of the default NEWB flags in the sideways
                        \ RAM image that we build

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSXIND1 = &FF48        \ IND1V's extended vector handler

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSFILE = &FFDD         \ The address for the OSFILE routine

INCLUDE "library/disc/loader-sideways-ram/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/disc/loader-sideways-ram/variable/sram_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/used_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/dupl_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/eliterom_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/proflag_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/testbbc_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/testpro_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/loadrom_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/makerom_per_cent.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/loadrom.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/makerom.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/loadshipfiles.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/processblueprint.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/setedgesoffset.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/testbbc.asm"
INCLUDE "library/disc/loader-sideways-ram/subroutine/testpro.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/titlematch.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/copymatch.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/osfileblock.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/shipfilename.asm"
INCLUDE "library/disc/loader-sideways-ram/variable/eliteromheader.asm"

\ ******************************************************************************
\
\ Save MNUCODE.bin
\
\ ******************************************************************************

 PRINT "S.MNUCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/MNUCODE.bin", CODE%, P%, LOAD%