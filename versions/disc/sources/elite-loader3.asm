\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 3) SOURCE
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
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITE4.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE
_IB_DISC                = (_RELEASE = 1)
_STH_DISC               = (_RELEASE = 2)

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

NETV = &224             \ The NETV vector that we intercept as part of the copy
                        \ protection

BRKV = &202             \ The break vector that we intercept to enable us to
                        \ handle and display system errors

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

WRCHV = &20E            \ The WRCHV vector that we intercept with our custom
                        \ text printing routine

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI vector

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

N% = 67                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them below

VSCAN = 57              \ Defines the split position in the split-screen mode

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, matching the address in the elite-missile.asm
                        \ source

ZP = &70                \ Temporary storage, used all over the place

P = &72                 \ Temporary storage, used all over the place

Q = &73                 \ Temporary storage, used all over the place

YY = &74                \ Temporary storage, used when drawing Saturn

T = &75                 \ Temporary storage, used all over the place

SC = &76                \ Used to store the screen address while plotting pixels

CHKSM = &78             \ Used in the copy protection code

DL = &8B                \ The vertical sync flag, matching the address in the
                        \ main game code

LASCT = &0346           \ The laser pulse count for the current laser, matching
                        \ the address in the main game code

HFX = &0348             \ A flag that toggles the hyperspace colour effect,
                        \ matching the address in the main game code

ESCP = &0386            \ The flag that determines whether we have an escape pod
                        \ fitted, matching the address in the main game code

S% = &11E3              \ The adress of the main entry point workspace in the
                        \ main game code

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
INCLUDE "library/6502sp/loader1/variable/rand.asm"
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

IF _MATCH_EXTRACTED_BINARIES

IF _STH_DISC
 INCBIN "versions/disc/extracted/sth/workspaces/loader3.bin"
ELIF _IB_DISC
 SKIP 158
ENDIF

ELSE

 SKIP 158               \ These bytes appear to be unused

ENDIF

\ ******************************************************************************
\
\ Save output/ELITE4.unprot.bin
\
\ ******************************************************************************

PRINT "S.ELITE4 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE4.unprot.bin", CODE%, P%, LOAD%

