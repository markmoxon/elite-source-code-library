\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 2)
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
\ https://www.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank2.bin
\
\ ******************************************************************************

\ ******************************************************************************
\
\ ELITE BANK 2
\
\ Produces the binary file bank2.bin.
\
\ ******************************************************************************

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1_b2.asm"
INCLUDE "library/nes/main/subroutine/interrupts_b2.asm"
INCLUDE "library/nes/main/variable/version_number_b2.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"
INCLUDE "library/nes/main/variable/tkn1_de.asm"
INCLUDE "library/nes/main/variable/rupla_de.asm"
INCLUDE "library/nes/main/variable/rugal_de.asm"
INCLUDE "library/nes/main/variable/rutok_de.asm"
INCLUDE "library/nes/main/variable/tkn1_fr.asm"
INCLUDE "library/nes/main/variable/rupla_fr.asm"
INCLUDE "library/nes/main/variable/rugal_fr.asm"
INCLUDE "library/nes/main/variable/rutok_fr.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/nes/main/variable/qq18_de.asm"
INCLUDE "library/nes/main/variable/qq18_fr.asm"
INCLUDE "library/nes/main/variable/rutoklo.asm"
INCLUDE "library/nes/main/variable/rutokhi.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/master/main/subroutine/filepr.asm"
INCLUDE "library/master/main/subroutine/otherfilepr.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/nes/main/variable/ruplalo.asm"
INCLUDE "library/nes/main/variable/ruplahi.asm"
INCLUDE "library/nes/main/variable/rugallo.asm"
INCLUDE "library/nes/main/variable/rugalhi.asm"
INCLUDE "library/nes/main/variable/nru.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_1_of_6.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_2_of_6.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_3_of_6.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_4_of_6.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_5_of_6.asm"
INCLUDE "library/nes/main/subroutine/chpr_part_6_of_6.asm"
INCLUDE "library/nes/main/variable/lowercase.asm"
INCLUDE "library/nes/main/variable/vectors_b2.asm"

\ ******************************************************************************
\
\ Save bank2.bin
\
\ ******************************************************************************

 PRINT "S.bank2.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank2.bin", CODE%, P%, LOAD%
