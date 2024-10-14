\ ******************************************************************************
\
\ APPLE II ELITE MOVER SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
\
\ The code on this site is identical to the source discs released on Ian Bell's
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
\ This source file produces the following binary file:
\
\   * MOVER.bin
\
\ ******************************************************************************

 INCLUDE "versions/apple/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_DISK               = (_VARIANT = 1)
 _SOURCE_DISK_BUILD     = (_VARIANT = 2)
 _SOURCE_DISK_CODE_FILES = (_VARIANT = 3)
 _SOURCE_DISK_ELT_FILES = (_VARIANT = 4)

 CODE% = &0300
 LOAD% = &0300

IF _IB_DISK

 BEGIN = &7EB9
 TT170 = &7ED2

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 BEGIN = &7EAB
 TT170 = &7EC4

ENDIF

 ORG CODE%

 STA &C080

 LDY #0
 STY &00
 STY &02

 LDA #&D0
 STA &01

 LDA #&90
 STA &03

.L0311

 LDA (&00),Y
 STA (&02),Y

 INY

 BNE L0311

 INC &01
 INC &03

 LDA &03
 CMP #&C0
 BCC L0311

 STA &C082

IF _MAX_COMMANDER

 JMP BEGIN

ELSE

 JMP TT170

ENDIF

 NOP

\ ******************************************************************************
\
\ Save MOVER.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 SAVE "versions/apple/3-assembled-output/MOVER.bin", CODE%, P%, LOAD%
