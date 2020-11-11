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
FF = &FF

CODE% = &2000
LOAD% = &2000

ORG CODE%

INCLUDE "library/6502sp/loader2/macro_mve.asm"
INCLUDE "library/6502sp/loader2/subroutine_elite_loader_part_1_of_2.asm"
INCLUDE "library/6502sp/loader2/variable_mess2.asm"
INCLUDE "library/6502sp/loader2/variable_mess3.asm"
INCLUDE "library/6502sp/loader2/subroutine_mvbl.asm"
INCLUDE "library/6502sp/loader2/subroutine_elite_loader_part_2_of_2.asm"

\ ******************************************************************************
\
\ Save output/ELITEa.bin
\
\ ******************************************************************************

PRINT "S.ELITEa ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "6502sp/output/ELITEa.bin", CODE%, P%, LOAD%
