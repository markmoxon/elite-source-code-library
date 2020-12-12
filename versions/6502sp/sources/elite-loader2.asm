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
\ ******************************************************************************

C% = &2000
L% = C%
D% = &D000
LC% = &8000-C%
OSWRCH = &FFEE
OSBYTE = &FFF4
OSWORD = &FFF1
SCLI = &FFF7
ZP = &90
P = &92
Q = &93
YY = &94
T = &95
Z1 = ZP
Z2 = P

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
