\ ******************************************************************************
\
\ ELECTRON ELITE DISC IMAGE SCRIPT
\
\ Electron Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
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
\   * elite-electron.ssd
\
\ This can be loaded into an emulator or a real Electron.
\
\ ******************************************************************************

PUTFILE "versions/electron/binaries/$.!BOOT.bin", "!BOOT", &0000, &0000
PUTFILE "versions/electron/binaries/$.ELITE.bin", "ELITE", &FF0E00, &FF8023
PUTFILE "versions/electron/output/ELITECO.bin", "ELITECO", &000000, &FFFFFF
PUTFILE "versions/electron/output/ELITEDA.bin", "ELITEDA", &FF4400, &FF5200
