\ ******************************************************************************
\
\ ELITE DISC IMAGE SCRIPT
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
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
\ ------------------------------------------------------------------------------
\
\ This source file produces the following SSD disc image:
\
\   * elite.ssd
\
\ This can be loaded into an emulator or a real BBC Micro.
\
\ ******************************************************************************

PUTFILE "cassette/binaries/$.!BOOT.bin", "!BOOT", &0000, &0000
PUTFILE "cassette/binaries/$.ELITE.bin", "ELITE", &1900, &8023
PUTFILE "cassette/output/ELITE.bin", "ELTdata", &1100, &2000
PUTFILE "cassette/output/ELTcode.bin", "ELTcode", &1128, &1128
