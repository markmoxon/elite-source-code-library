\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 4)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code on this site has been reconstructed from a disassembly of the version
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
\ This source file produces the following binary file:
\
\   * bank4.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ ELITE BANK 4
\
\ Produces the binary file bank4.bin.
\
\ ******************************************************************************

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1_b4.asm"
INCLUDE "library/nes/main/subroutine/interrupts_b4.asm"
INCLUDE "library/nes/main/variable/version_number_b4.asm"
INCLUDE "library/nes/main/variable/facecount.asm"
INCLUDE "library/nes/main/variable/faceoffset.asm"
INCLUDE "library/nes/main/variable/faceimage0.asm"
INCLUDE "library/nes/main/variable/faceimage1.asm"
INCLUDE "library/nes/main/variable/faceimage2.asm"
INCLUDE "library/nes/main/variable/faceimage3.asm"
INCLUDE "library/nes/main/variable/faceimage4.asm"
INCLUDE "library/nes/main/variable/faceimage5.asm"
INCLUDE "library/nes/main/variable/faceimage6.asm"
INCLUDE "library/nes/main/variable/faceimage7.asm"
INCLUDE "library/nes/main/variable/faceimage8.asm"
INCLUDE "library/nes/main/variable/faceimage9.asm"
INCLUDE "library/nes/main/variable/faceimage10.asm"
INCLUDE "library/nes/main/variable/faceimage11.asm"
INCLUDE "library/nes/main/variable/faceimage12.asm"
INCLUDE "library/nes/main/variable/faceimage13.asm"
INCLUDE "library/nes/main/variable/headcount.asm"
INCLUDE "library/nes/main/variable/headoffset.asm"
INCLUDE "library/nes/main/variable/headimage0.asm"
INCLUDE "library/nes/main/variable/headimage1.asm"
INCLUDE "library/nes/main/variable/headimage2.asm"
INCLUDE "library/nes/main/variable/headimage3.asm"
INCLUDE "library/nes/main/variable/headimage4.asm"
INCLUDE "library/nes/main/variable/headimage5.asm"
INCLUDE "library/nes/main/variable/headimage6.asm"
INCLUDE "library/nes/main/variable/headimage7.asm"
INCLUDE "library/nes/main/variable/headimage8.asm"
INCLUDE "library/nes/main/variable/headimage9.asm"
INCLUDE "library/nes/main/variable/headimage10.asm"
INCLUDE "library/nes/main/variable/headimage11.asm"
INCLUDE "library/nes/main/variable/headimage12.asm"
INCLUDE "library/nes/main/variable/headimage13.asm"
INCLUDE "library/nes/main/variable/glassesimage.asm"
INCLUDE "library/nes/main/variable/biglogoimage.asm"
INCLUDE "library/nes/main/variable/biglogonames.asm"
INCLUDE "library/nes/main/variable/smalllogotile.asm"
INCLUDE "library/nes/main/variable/cobranames.asm"
INCLUDE "library/nes/main/subroutine/getheadshottype.asm"
INCLUDE "library/nes/main/variable/headshotsbyrank.asm"
INCLUDE "library/nes/main/subroutine/getheadshot.asm"
INCLUDE "library/nes/main/subroutine/getcmdrimage.asm"
INCLUDE "library/nes/main/subroutine/drawbiglogo.asm"
INCLUDE "library/nes/main/subroutine/drawimagenames.asm"
INCLUDE "library/nes/main/subroutine/drawsmalllogo.asm"
INCLUDE "library/nes/main/variable/vectors_b4.asm"

\ ******************************************************************************
\
\ Save bank4.bin
\
\ ******************************************************************************

 PRINT "S.bank4.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank4.bin", CODE%, P%, LOAD%
