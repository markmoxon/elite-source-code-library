\ ******************************************************************************
\
\ COMMODORE 64 ELITE PDS SEND FILE
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
\   * SEND.bin
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
 _GMA_RELEASE           = (_VARIANT = 1) OR (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)
 _SOURCE_DISK           = (_VARIANT = 3) OR (_VARIANT = 4)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &1100          \ The address where the code will be run

 LOAD% = &1100          \ The address where the code will be loaded

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSBYTE = &FFF4         \ The address for the OSBYTE routine

 OSWORD = &FFF1         \ The address for the OSWORD routine

\ ******************************************************************************
\
\ ELITE PDS SEND
\
\ ******************************************************************************

 ORG CODE%

.L1100

 JSR L1133

 EQUB 13
 EQUS "File to transmit : "
 EQUB 0

 LDA #0
 LDX #&FC
 LDY #&12
 JSR OSWORD

 BCC L1175

 LDA #&7E
 JSR OSBYTE

 JMP L1100

.L112B

 LDX &F4
 LDY &03A3
 LDA #0
 RTS

.L1133

 PLA
 STA &F8
 PLA
 STA &F9
 TYA
 PHA
 LDY #0
 JSR L1154

.L1140

 LDA (&F8),Y
 JSR L1154
 CMP #0
 BEQ L114F
 JSR &FFE3
 JMP L1140

.L114F

 PLA
 TAY
 JMP (&00F8)

.L1154

 INC &F8
 BNE L115A
 INC &F9

.L115A

 RTS

.L115B

 PHA
 AND #&F0
 LSR A
 LSR A
 LSR A
 LSR A
 JSR L1168
 PLA
 AND #&0F

.L1168

 CLC
 ADC #&30
 CMP #&3A
 BCC L1172
 CLC
 ADC #&07

.L1172

 JMP OSWRCH

.L1175

 LDA L1319
 CMP #13
 BNE L117F
 JMP L112B

.L117F

 LDA #0
 STA L11CD+1
 LDA #&15
 STA L11CD+2
 LDX #&0C
 LDA #&20

.L118D

 STA L1306,X
 DEX
 BPL L118D
 LDY #0
 LDX #0

.L1197

 LDA L1319,X
 STA &1400,X
 STA L1306,X
 INX
 INY
 CMP #13
 BNE L1197
 DEX
 LDA #' '
 STA L1306,X
 JSR L1133

 EQUS "Sending parallel file..."
 EQUB 13
 EQUB 13
 EQUB 0

 JSR L1203

.L11CD

 LDA &1500
 JSR L12CA
 LDA &145A
 SEC
 SBC #&01
 STA &145A
 LDA &145B
 SBC #0
 STA &145B
 ORA &145A
 BEQ L11F4
 INC L11CD+1
 BNE L11CD
 INC L11CD+2
 JMP L11CD

.L11F4

 JSR L1133

 EQUB 13
 EQUS "Done."
 EQUB 13
 EQUB 13
 EQUB 0

 JMP L1100

.L1203

 LDA #&FF
 STA &FE62
 LDA #&18
 STA &FE6E
 LDA &FE6C
 AND #&0F
 ORA #&E0
 STA &FE6C
 LDX #&50
 LDY #&14
 LDA #0
 STA &1450
 LDA #&14
 STA &1451
 LDA #&05
 JSR &FFDD
 CMP #&01
 BEQ L125C
 JSR L1133

 EQUS "Tough Luck!! No can do!! Won't open!"
 EQUB 13
 EQUB 0

 PLA
 PLA
 JMP L1100

.L125C

 LDX #&01
 LDY #&13
 JSR &FFF7
 LDX &1452
 LDY &1453
 STX &74
 TXA
 JSR L12CA
 STY &75
 TYA
 JSR L12CA
 JSR L1133

 EQUS "Start : &"
 EQUB 0

 JSR L12ED
 LDX &145A
 LDY &145B
 STX &76
 TXA
 JSR L12CA
 STY &77
 TYA
 JSR L12CA
 JSR L1133

 EQUS "Length: &"
 EQUB 0

 JSR L12ED
 LDX &1456
 LDY &1457
 STX &78
 TXA
 JSR L12CA
 STY &79
 TYA
 JSR L12CA
 JSR L1133

 EQUS "Exec  : &"
 EQUB 0

 JSR L12ED
 RTS

.L12CA

 STA &FE60
 LDA &FE6C
 EOR #&20
 STA &FE6C

.L12D5

 LDA &FE6D
 AND #&10
 BEQ L12D5
 LDA &FE6D
 ORA #&20
 STA &FE6D
 LDA &FE6C
 EOR #&20
 STA &FE6C
 RTS

.L12ED

 TYA
 JSR L115B
 TXA
 JSR L115B
 JSR L1133

 EQUS "."
 EQUB 13
 EQUB 0

 RTS

 EQUB &19, &13, &0C
 EQUS " ~LOAD "

.L1306

 EQUS "              1500"
 EQUB 13

.L1319

 EQUS "            "

 SAVE "versions/c64/3-assembled-output/SEND.bin", CODE%, P%, LOAD%
