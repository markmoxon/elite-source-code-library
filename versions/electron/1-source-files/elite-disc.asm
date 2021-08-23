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
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following SSD disc image:
\
\   * elite-electron-sth.ssd
\
\ This can be loaded into an emulator or a real Electron.
\
\ ******************************************************************************

PUTFILE "versions/electron/1-source-files/images/$.!BOOT.bin", "!BOOT", &FFFFFF, &FFFFFF
PUTFILE "versions/electron/1-source-files/images/$.ELITE.bin", "ELITE", &FF0E00, &FF8023
PUTFILE "versions/electron/3-assembled-output/ELITECO.bin", "ELITECO", &000000, &FFFFFF
PUTFILE "versions/electron/3-assembled-output/ELITEDA.bin", "ELITEDA", &FF4400, &FF5200
PUTFILE "versions/electron/3-assembled-output/README.txt", "README", &FFFFFF, &FFFFFF
