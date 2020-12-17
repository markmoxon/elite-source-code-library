\ ******************************************************************************
\
\ 6502 SECOND PROCESSOR ELITE DISC IMAGE SCRIPT
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

PUTFILE "versions/6502sp/output/ELITE.bin", "ELITE", &FF2000, &FF2085

PUTFILE "versions/6502sp/output/ELITEa.bin", "I.ELITEa", &FF2000, &FF2000

PUTFILE "versions/6502sp/output/I.CODE.bin", "I.CODE", &FF2400, &FF2C89

IF _REMOVE_CHECKSUMS
 PUTFILE "versions/6502sp/output/P.CODE.bin", "P.CODE", &1000, &10D1
ELSE
 PUTFILE "versions/6502sp/output/P.CODE.bin", "P.CODE", &1000, &106A
ENDIF