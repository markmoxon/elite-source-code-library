\ ******************************************************************************
\
\ COMMODORE 64 ELITE GMA3 LOADER FILE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
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
\   * gma3.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85_NTSC            = (_VARIANT = 1)
 _GMA85_PAL             = (_VARIANT = 2)
 _SOURCE_DISC_BUILD     = (_VARIANT = 3)
 _SOURCE_DISC_FILES     = (_VARIANT = 4)

 CODE% = &C800
 LOAD% = &C800

 ORG CODE% - 2

 EQUW CODE%

 LDA #&00
 STA &FB
 LDA #&03
 STA &FC

IF _GMA85_PAL

 LDA #&97

ELIF _GMA85_NTSC OR _SOURCE_DISC_BUILD OR _SOURCE_DISC_FILES

 LDA #&93

ENDIF

 STA &FD
 LDA #&C8
 STA &FE

.LC810

 JSR LC873

 LDA #&57
 JSR &FFD2
 LDA &FB
 JSR &FFD2
 LDA &FC
 JSR &FFD2
 LDA #&20
 JSR &FFD2
 LDX #&20
 LDY #&00
 CLC
 LDA &FB
 ADC #&20
 STA &FB
 LDA #&00
 ADC &FC
 STA &FC

.LC838

 LDA (&FD),Y

 JSR &FFD2
 INC &FD
 BNE LC843
 INC &FE

.LC843

 DEX

 BNE LC838
 JSR &FFCC
 LDA &FB
 CMP #&8D
 LDA &FC
 SBC #&03
 BCC LC810
 JSR LC873
 LDA #&45
 JSR &FFD2
 LDA #&64
 JSR &FFD2
 LDA #&03
 JSR &FFD2
 JSR &FFCC

.LC868

 BIT &DD00

 BMI LC868

.LC86D

 BIT &DD00

 BPL LC86D
 RTS

.LC873

 LDA #&00

 JSR &FFBD
 LDA #&0F
 TAY
 LDX #&08
 JSR &FFBA
 JSR &FFC0
 LDX #&0F
 JSR &FFC9

IF _GMA85_PAL

 LDA #&97
 STA &02

ENDIF

 LDA #&4D
 JSR &FFD2
 LDA #&2D
 JSR &FFD2
 RTS
 LDA #&0F
 STA &1800
 STA &1800
 LDA &1C00
 AND #&9F
 STA &1C00
 LDY #&5A

.LC8A5

 DEY

 BNE LC8AD
 LDA #&02
 JMP &F969

.LC8AD

 BIT &1C00

 BMI LC8AD
 LDA &1C01
 CLV
 LDX #&04

.LC8B8

 BVC LC8B8

 CLV
 LDA &1C01
 STA &0500,X
 DEX
 BPL LC8B8
 CMP #&69
 BNE LC8A5
 LDA &0501
 CMP #&A9
 BNE LC8A5

.LC8CF

 BIT &1C00

 BMI LC8CF
 CLV
 LDA &1C01
 LDX #&00

.LC8DA

 BVC LC8DA

 CLV
 LDA &1C01
 STA &0508,X
 INX
 BNE LC8DA

.LC8E6

 BVC LC8E6

 CLV
 LDA &1C01
 STA &0608,X
 INX
 BNE LC8E6
 LDA #&01
 JMP &F969
 JSR &D042
 LDA #&25
 STA &06
 LDA #&01
 STA &07
 JSR &C118
 LDA #&E0
 STA &00

.LC909

 LDA &00

 BMI LC909
 CMP #&02
 BCC LC917
 JMP &037E
 JSR &C12C

.LC917

 LDA #&00

 STA &1800
 STA &1800
 RTS

\ ******************************************************************************
\
\ Save gma3.bin
\
\ ******************************************************************************

 SAVE "versions/c64/3-assembled-output/gma3.bin", CODE%-2, P%, LOAD%
