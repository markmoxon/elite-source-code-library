\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 5)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
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
\ This source file contains the game code for ROM bank 5 of NES Elite.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank5.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ ELITE BANK 5
\
\ Produces the binary file bank5.bin.
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1_b5.asm"
INCLUDE "library/nes/main/subroutine/interrupts_b5.asm"
INCLUDE "library/nes/main/variable/version_number_b5.asm"
INCLUDE "library/nes/main/variable/systemcount.asm"
INCLUDE "library/nes/main/variable/systemoffset.asm"
INCLUDE "library/nes/main/variable/systemimage0.asm"
INCLUDE "library/nes/main/variable/systemimage1.asm"
INCLUDE "library/nes/main/variable/systemimage2.asm"
INCLUDE "library/nes/main/variable/systemimage3.asm"
INCLUDE "library/nes/main/variable/systemimage4.asm"
INCLUDE "library/nes/main/variable/systemimage5.asm"
INCLUDE "library/nes/main/variable/systemimage6.asm"
INCLUDE "library/nes/main/variable/systemimage7.asm"
INCLUDE "library/nes/main/variable/systemimage8.asm"
INCLUDE "library/nes/main/variable/systemimage9.asm"
INCLUDE "library/nes/main/variable/systemimage10.asm"
INCLUDE "library/nes/main/variable/systemimage11.asm"
INCLUDE "library/nes/main/variable/systemimage12.asm"
INCLUDE "library/nes/main/variable/systemimage13.asm"
INCLUDE "library/nes/main/variable/systemimage14.asm"
INCLUDE "library/nes/main/variable/copyright-message.asm"
INCLUDE "library/nes/main/subroutine/getsystemimage.asm"
INCLUDE "library/nes/main/subroutine/getsystemback.asm"
INCLUDE "library/nes/main/subroutine/setdemoautoplay.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1lo.asm"
INCLUDE "library/nes/main/variable/autoplaykeys1hi.asm"
INCLUDE "library/nes/main/variable/vectors_b5.asm"

\ ******************************************************************************
\
\ Save bank5.bin
\
\ ******************************************************************************

 PRINT "S.bank5.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank5.bin", CODE%, P%, LOAD%
