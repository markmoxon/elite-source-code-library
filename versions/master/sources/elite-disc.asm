\ ******************************************************************************
\
\ BBC MASTER ELITE DISC IMAGE SCRIPT
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
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
\ This source file produces the following SSD disc image:
\
\   * elite-master.ssd
\
\ This can be loaded into an emulator or a real BBC Master.
\
\ ******************************************************************************

INCLUDE "versions/master/sources/elite-header.h.asm"

PUTFILE "versions/master/output/M128Elt.bin", "M128Elt", &FF0E00, &FF0E43
PUTFILE "versions/master/output/BDATA.bin", "BDATA", &000000, &000000
PUTFILE "versions/master/output/BCODE.bin", "BCODE", &000000, &000000
