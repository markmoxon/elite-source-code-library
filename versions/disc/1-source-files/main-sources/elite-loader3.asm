\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 3) SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\   * ELITE4.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
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

 GUARD &6000            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

N% = 67                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them below

VSCAN = 57              \ Defines the split position in the split-screen mode

POW = 15                \ Pulse laser power

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, matching the address in the elite-missile.asm
                        \ source

BRKV = &0202            \ The break vector that we intercept to enable us to
                        \ handle and display system errors

IRQ1V = &0204           \ The IRQ1V vector that we intercept to implement the
                        \ split-screen mode

WRCHV = &020E           \ The WRCHV vector that we intercept with our custom
                        \ text printing routine

NETV = &0224            \ The NETV vector that we intercept as part of the copy
                        \ protection

LASCT = &0346           \ The laser pulse count for the current laser, matching
                        \ the address in the main game code

HFX = &0348             \ A flag that toggles the hyperspace colour effect,
                        \ matching the address in the main game code

ESCP = &0386            \ The flag that determines whether we have an escape pod
                        \ fitted, matching the address in the main game code

S% = &11E3              \ The adress of the main entry point workspace in the
                        \ main game code

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI vector

INCLUDE "library/disc/loader3/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

CODE% = &1900
LOAD% = &1900

 ORG CODE%

INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/common/loader/macro/fne.asm"
INCLUDE "library/disc/loader3/subroutine/elite_loader_part_1_of_3.asm"
INCLUDE "library/disc/loader3/subroutine/check.asm"
INCLUDE "library/disc/loader3/copyblock/loadcode.asm"
INCLUDE "library/disc/loader3/copyblock/catdcode.asm"
INCLUDE "library/disc/loader3/subroutine/prot1.asm"

 EQUB &AC               \ This byte appears to be unused

INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/enhanced/loader/variable/rand.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"
INCLUDE "library/disc/loader3/subroutine/prot2.asm"
INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"
INCLUDE "library/disc/loader3/subroutine/prot3.asm"
INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"

 EQUB &0E               \ This byte appears to be unused

INCLUDE "library/disc/loader3/subroutine/mvpg.asm"

 EQUB &0E               \ This byte appears to be unused

INCLUDE "library/disc/loader3/subroutine/mvbl.asm"
INCLUDE "library/disc/loader3/variable/mess1.asm"
INCLUDE "library/disc/loader3/subroutine/elite_loader_part_2_of_3.asm"
INCLUDE "library/disc/loader3/subroutine/osbmod.asm"
INCLUDE "library/disc/loader3/copyblock/tvt1code.asm"
INCLUDE "library/disc/loader3/subroutine/elite_loader_part_3_of_3.asm"

IF _MATCH_ORIGINAL_BINARIES

 IF _STH_DISC
  INCBIN "versions/disc/4-reference-binaries/sth/workspaces/loader3.bin"
 ELIF _IB_DISC
  SKIP 158
 ENDIF

ELSE

  SKIP 158              \ These bytes appear to be unused

ENDIF

\ ******************************************************************************
\
\ Save ELITE4.unprot.bin
\
\ ******************************************************************************

 PRINT "S.ELITE4 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/ELITE4.unprot.bin", CODE%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "Load address = ", ~CODE%
 PRINT "TVT1code = ", ~TVT1code
 PRINT "ELITE = ", ~ELITE
 PRINT "LOADcode = ", ~LOADcode
 PRINT "CATDcode = ", ~CATDcode
 PRINT "DIALS = ", ~DIALS
 PRINT "OSBmod = ", ~OSBmod
 PRINT "ELITE = ", ~ELITE
 PRINT "End of ELITE4 file = ", ~P%
 PRINT "TVT1code = ", ~TVT1code
 PRINT "TVT1 = ", ~TVT1
 PRINT "NA% = ", ~NA%
 PRINT "CHK2 = ", ~CHK2
