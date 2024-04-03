\ ******************************************************************************
\
\ DISC ELITE SIDEWAYS RAM LOADER SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
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
\   * MNUCODE.bin
\
\ ******************************************************************************

 INCLUDE "versions/disc/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = TRUE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE
 _IB_DISC               = (_VARIANT = 1)
 _STH_DISC              = (_VARIANT = 2)
 _SRAM_DISC             = (_VARIANT = 3)

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &7400          \ The address where the code will be run

 LOAD% = &7400          \ The address where the code will be loaded

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSFILE = &FFDD         \ The address for the OSFILE routine

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

 SKIP 48
 
 EQUB &FF, &00

 JMP L7630          \ testbbc%
 JMP L76C9          \ testpro%
 JMP L743E          \ loadrom% (used for Master, loads E00DFS)

.makerom%

 JMP L7475          \ makerom%

.loadrom%

.L743E

 LDA &F4
 PHA
 STX &F4
 STX &FE30
 LDA #&34
 STA &7456
 LDA #&80
 STA &7459
 LDY #&00
 LDX #&40

.L7454

 LDA &3400,Y
 STA &8000,Y
 INY
 BNE L7454
 INC &7456
 INC &7459
 DEX
 BNE L7454
 LDX &F4
 LDA &8006
 STA &02A1,X
 PLA
 STA &F4
 STA &FE30
 RTS

.L7475

                        \ ???

                        \ X = free SRAM bank

 LDA &F4                \ Set SRAM bank to X
 PHA
 STX &F4
 STX &FE30

 LDY #&00               \ Copy 256 bytes from &76F6 to &8000

.L747F

 LDA &76F6,Y
 STA &8000,Y
 LDA #&00               \ Zero 256 bytes at &8100
 STA &8100,Y
 INY
 BNE L747F

 LDA #&00               \ (&71 &70) = &8200
 STA &70
 LDA #&82
 STA &71

 JSR L74CA

 LDA &0DBA
 STA &0DE7
 LDA &0DBB
 STA &0DE8
 LDA &0DBC
 STA &0DE9
 LDA #&22
 STA &0DBA
 LDA #&80
 STA &0DBB
 LDA &F4
 STA &0DBC

 LDA #&48               \ https://tobylobster.github.io/mos/mos/S-s23.html
 STA &0230              \ ROM intercept vector mechanism
 LDA #&FF               \ Intercepts vector 24, E_IND1V
 STA &0231

 PLA                    \ Restore
 STA &F4
 STA &FE30
 RTS



.L74CA

 LDA #&41
 STA &76F4


.L74CF

 LDA #&2E
 JSR &FFEE              \ OWSRCH

 LDA #&00
 STA &76E0
 LDA #&56
 STA &76E1
 LDA #&FF
 STA &76E2
 STA &76E3
 LDA #&00
 STA &76E4
 LDX #&DE               \ (Y X) = &76DE
 LDY #&76
 LDA #&FF
 JSR &FFDD              \ OSFILE, loads D.MOA through D.MOP

 LDX #&00

.L74F6

 TXA
 PHA
 JSR L7524
 PLA
 TAX
 INX
 CPX #&1F
 BNE L74F6
 INC &76F4
 LDA &76F4
 CMP #&51
 BNE L74CF
 RTS


.L750D

 STA &8101,Y
 LDA &72
 STA &8100,Y

.L7515

 RTS


.L7516

 LDA &8100,Y
 STA &807B
 LDA &8101,Y
 STA &807C
 BNE L753C


.L7524

 TXA
 ASL A
 TAY
 LDA &5601,Y
 BEQ L7515
 CPX #&01
 BNE L7537
 LDA &76F4
 CMP #&42
 BEQ L7516

.L7537

 LDA &8101,Y
 BNE L7515

.L753C

 LDA &70
 STA &8100,Y
 LDA &71
 STA &8101,Y
 LDA &563E,X
 STA &813E,X
 LDA &5600,Y
 STA &72
 LDA &5601,Y
 STA &73
 CMP #&56
 BCC L750D
 CMP #&60
 BCS L750D
 JSR L75B1
 LDA #&00
 STA &74
 TAY
 LDA #&60
 STA &75

.L756A

 LDA &72
 CMP &5600,Y
 LDA &73
 SBC &5601,Y
 BCS L758C
 LDA &5600,Y
 CMP &74
 LDA &5601,Y
 SBC &75
 BCS L758C
 LDA &5600,Y
 STA &74
 LDA &5601,Y
 STA &75

.L758C

 INY
 INY
 CPY #&3E
 BNE L756A
 LDY #&00

.L7594

 LDA (&72),Y
 STA (&70),Y
 INC &72
 BNE L759E
 INC &73

.L759E

 INC &70
 BNE L75A4
 INC &71

.L75A4

 LDA &72
 CMP &74
 BNE L7594
 LDA &73
 CMP &75
 BNE L7594
 RTS


.L75B1

 TYA
 PHA
 TXA
 PHA
 CLC
 LDY #&03
 LDA (&72),Y
 ADC &72
 STA &76
 LDY #&10
 LDA (&72),Y
 ADC &73
 STA &77
 LDY #&00
 LDX #&00
 LDA #&00
 STA &78
 LDA #&56
 STA &79

.L75D2

 LDA &5600,Y
 CMP &76
 LDA &5601,Y
 SBC &77
 BCS L75F6
 LDA &5600,Y
 CMP &78
 LDA &5601,Y
 SBC &79
 BCC L75F6
 LDA &5600,Y
 STA &78
 LDA &5601,Y
 STA &79
 TYA
 TAX

.L75F6

 INY
 INY
 CPY #&3E
 BNE L75D2
 SEC
 LDA &76
 SBC &5600,X
 STA &76
 LDA &77
 SBC &5601,X
 STA &77
 CLC
 LDA &8100,X
 ADC &76
 STA &76
 LDA &8101,X
 ADC &77
 STA &77
 SEC
 LDA &76
 SBC &70
 LDY #&03
 STA (&72),Y
 LDA &77
 SBC &71
 LDY #&10
 STA (&72),Y
 PLA
 TAX
 PLA
 TAY
 RTS


.L7630

 LDA &F4
 PHA
 LDX #&0F

.L7635

 STX &F4
 STX &FE30
 LDA &8006
 PHA
 EOR #&01
 STA &8006
 CMP &8006
 BNE L764B
 DEC &7400,X

.L764B

 PLA
 STA &8006
 LDY &8007
 LDX #&FC

.L7654

 LDA &75DE,X
 CMP &8000,Y
 BNE L7668
 INY
 INX
 BNE L7654
 LDX &F4
 DEC &7410,X
 JMP L7670

.L7668

 LDX &F4
 TXA
 ORA #&F0
 STA &8000

.L7670

 BIT &7430
 BPL L7685
 LDY #&F2

.L7677

 LDA &75DE,Y
 CMP &7F17,Y
 BNE L7685
 INY
 BNE L7677
 STX &7430

.L7685

 TXA
 LDY #&10

.L7688

 STX &F4
 STX &FE30
 DEY
 TYA
 CMP &F4
 BEQ L76B8
 TYA
 EOR #&FF
 STA &F6
 LDA #&7F
 STA &F7

.L769C

 STX &F4
 STX &FE30
 LDA (&F6),Y
 STY &F4
 STY &FE30
 CMP (&F6),Y
 BNE L7688
 INC &F6
 BNE L769C
 INC &F7
 LDA &F7
 CMP #&84
 BNE L769C

.L76B8

 TYA
 STA &7420,X
 DEX
 BMI L76C2
 JMP L7635

.L76C2

 PLA
 STA &F4
 STA &FE30
 RTS

.L76C9

 EQUB &A9, &00, &3A, &8D
 EQUB &31, &74, &60, &53
 EQUB &52, &41, &4D, &20
 EQUB &45, &4C, &49, &54
 EQUB &45, &00, &28, &43
 EQUB &29, &F0, &76, &00
 EQUB &56, &FF, &FF, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00

.L76F0

 EQUS "D.MOA"
 EQUB 13

.ROMheader

 CLEAR &8000, &8000
 ORG &8000

.ROM

 JMP L8021
 JMP L8021

 EQUB &81
 EQUB &13
 EQUB 0

 EQUS "SRAM ELITE"
 EQUB 0

 EQUS "(C)Acornsoft"
 EQUB 0

.L8021

 RTS

.L8022

 PHA
 STX &F0
 STY &F1
 LDY #&00
 LDA (&F0),Y
 STA &F2
 INY
 LDA (&F0),Y
 STA &F3
 LDY #&05

.L8034

 LDA &8075,Y
 BEQ L803D
 CMP (&F2),Y
 BNE L806D

.L803D

 DEY
 BPL L8034
 INY

.L8041

 LDA &8100,Y
 STA &5600,Y
 INY
 BNE L8041
 LDY #&04
 LDA (&F2),Y
 AND #&01
 BEQ L805E
 LDA &807B
 STA &5602
 LDA &807C
 STA &5603

.L805E

 TSX
 LDA &F4
 STA &0104,X
 STA &028C
 LDX &F0
 LDY &F1
 PLA
 RTS

.L806D

 LDX &F0
 LDY &F1
 PLA
 JMP (&0230)            \ IND1V

 EQUS "D.MO"
 EQUB 0
 EQUB 13

 EQUB 0, 0

 COPYBLOCK ROM, P%, ROMheader

 ORG ROMheader + P% - ROM

\ ******************************************************************************
\
\ Save MNUCODE.bin
\
\ ******************************************************************************

 PRINT "S.MNUCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/MNUCODE.bin", CODE%, P%, LOAD%