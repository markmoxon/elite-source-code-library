\ ******************************************************************************
\
\ BBC MICRO ELITE DEMO README SOURCE
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
\ This source file produces a README file for BBC Micro cassette Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * README.txt
\
\ ******************************************************************************

 INCLUDE "versions/demo/1-source-files/main-sources/elite-build-options.asm"

.readme

 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13
 EQUS "Acornsoft Elite demo"
 EQUB 10, 13
 EQUB 10, 13
 EQUS "Version: BBC Micro"
 EQUB 10, 13

 EQUB 10, 13
 EQUS "See www.bbcelite.com for details"
 EQUB 10, 13
 EQUS "---------------------------------------"
 EQUB 10, 13

 SAVE "versions/demo/3-assembled-output/README.txt", readme, P%

