\ ******************************************************************************
\
\ BBC MICRO ELITE DEMO DISC IMAGE SCRIPT
\
\ The BBC Micro Elite demo was written by Ian Bell and David Braben and is
\ copyright Acornsoft 1984
\
\ The code in this file is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces an SSD disc image for BBC Micro cassette Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces one of the following SSD disc images, depending on
\ which release is being built:
\
\   * elite-cassette-sth.ssd
\   * elite-cassette-from-source-disc.ssd
\   * elite-cassette-from-text-sources.ssd
\
\ This can be loaded into an emulator or a real BBC Micro.
\
\ ******************************************************************************

 INCLUDE "versions/demo/1-source-files/main-sources/elite-build-options.asm"

 PUTFILE "versions/demo/1-source-files/boot-files/$.!BOOT.bin", "!BOOT", &FFFFFF, &FFFFFF
 PUTFILE "versions/demo/3-assembled-output/ELITE.bin", "ELTDemo", &FF1100, &FF2000
 PUTFILE "versions/demo/3-assembled-output/ELTcode.bin", "ELTCode", &FF1128, &FF1128
 PUTFILE "versions/demo/3-assembled-output/README.txt", "README", &FFFFFF, &FFFFFF
