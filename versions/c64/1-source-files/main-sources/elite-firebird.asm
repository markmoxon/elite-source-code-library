\ ******************************************************************************
\
\ COMMODORE 64 ELITE FIREBIRD LOADER FILE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source disks released on Ian Bell's
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
\   * firebird.bin
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
 _GMA86_PAL             = (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)

 CODE% = &02A7
 LOAD% = &02A7

 ORG CODE% - 2

 EQUW CODE%

 EQUW &080B
 EQUW &0001
 EQUB &9E
 EQUB &32
 EQUB &30
 EQUB &36
 EQUB &31
 EQUB &00
 EQUB &00
 EQUB &00

 LDX #&65

.L02B5

 LDA &0801,X
 STA &02A7,X
 DEX
 BPL L02B5
 JMP L02C4

.L02C1

 EQUS "GM*"

.L02C4

 LDA #0
 JSR &FF90
 LDA #&02
 LDX #&08
 LDY #&FF
 JSR &FFBA
 LDA #&03
 LDX #LO(L02C1)
 LDY #HI(L02C1)
 JSR &FFBD
 LDA #&00
 JSR &FFD5
 LDA #&FF
 STA &0329

.L02E5

 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 JMP &0334              \ Load/execute address pf gma1

 EQUW &02C4
 EQUW &02C4
 EQUW &02C4
 EQUW &02C4
 EQUW &02C4
 EQUW &02C4

\ ******************************************************************************
\
\ Save firebird.bin
\
\ ******************************************************************************

 SAVE "versions/c64/3-assembled-output/firebird.bin", CODE%-2, P%, LOAD%
