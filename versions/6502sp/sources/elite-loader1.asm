\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE I/O LOADER (PART 1) SOURCE
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
\ ******************************************************************************

INCLUDE "versions/6502sp/sources/elite-header.h.asm"

_CASSETTE_VERSION       = TRUE AND (_VERSION = 1)
_DISC_VERSION           = TRUE AND (_VERSION = 2)
_6502SP_VERSION         = TRUE AND (_VERSION = 3)

C% = &2000
L% = C%
D% = &D000
LC% = &8000-C%
svn = &7FFD
N% = 77

OSWRCH = &FFEE
OSBYTE = &FFF4
OSWORD = &FFF1
SCLI = &FFF7
IRQ1V = &204
ZP = &90
P = &92
Q = &93
YY = &94
T = &95
Z1 = ZP
Z2 = P

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

CODE% = &2000
LOAD% = &2000

ORG CODE%

INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/common/loader/macro/fne.asm"
INCLUDE "library/6502sp/loader1/subroutine/elite_loader.asm"
INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/6502sp/loader1/variable/rand.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"
INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"
INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/6502sp/loader1/subroutine/osb.asm"
INCLUDE "library/6502sp/loader1/variable/mess1.asm"
INCLUDE "library/6502sp/loader1/variable/mess2.asm"

\ ******************************************************************************
\
\ Save output/ELITE.bin
\
\ ******************************************************************************

PRINT "S.ELITE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/6502sp/output/ELITE.bin", CODE%, P%, LOAD%