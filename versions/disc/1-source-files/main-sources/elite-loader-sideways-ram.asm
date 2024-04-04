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

 CPU 1                  \ Switch to 65SC12 assembly, as this code contains a
                        \ BBC Master DEC A instruction

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

 XX3 = &0100

 IND1V = &0230

 LANGROM = &028C        \ Current language ROM in MOS workspace

 ROMTYPE = &02A1        \ Paged ROM type table in MOS workspace

 XFILEV = &0DBA

 XIND1V = &0DE7

 XX21 = &5600           \ The address of the ship blueprints lookup table, where
                        \ the chosen ship blueprints file is loaded

 VIA = &FE00            \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

 OSXIND1 = &FF48        \ IND1V's extended vector handler

 OSWRCH = &FFEE         \ The address for the OSWRCH routine

 OSFILE = &FFDD         \ The address for the OSFILE routine

INCLUDE "library/disc/loader-sideways-ram/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

\ ******************************************************************************
\
\       Name: L7400
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7400

 SKIP 16

\ ******************************************************************************
\
\       Name: L7410
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7410

 SKIP 16

\ ******************************************************************************
\
\       Name: L7420
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7420

 SKIP 16

\ ******************************************************************************
\
\       Name: L7430
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7430

 EQUB &FF

\ ******************************************************************************
\
\       Name: L7431
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L7431

 SKIP 1

\ ******************************************************************************
\
\       Name: Entry points
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.testbbc%

 JMP TestBBC

.testpro%

 JMP TestPro

.loadrom%

 JMP LoadRom

.makerom%

 JMP MakeRom

\ ******************************************************************************
\
\       Name: LoadRom
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.LoadRom

 LDA &F4                \ Switch to the ROM bank in X, storing the current ROM
 PHA                    \ bank on the stack
 STX &F4
 STX VIA+&30

 LDA #&34
 STA lrom1+2

 LDA #HI(ROM)
 STA lrom2+2

 LDY #&00
 LDX #&40

.lrom1

 LDA &3400,Y

.lrom2

 STA ROM,Y

 INY

 BNE lrom1

 INC lrom1+2

 INC lrom2+2

 DEX

 BNE lrom1

 LDX &F4
 LDA ROM+6
 STA ROMTYPE,X

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MakeRom
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The bank number of sideways RAM to use for Elite
\
\ ******************************************************************************

.MakeRom

 LDA &F4                \ Switch to the sideways RAM bank in X, storing the
 PHA                    \ current ROM bank on the stack
 STX &F4
 STX VIA+&30

                        \ We start by copying 256 bytes from ROMheader into the
                        \ sideways RAM bank at address ROM, and zeroing the next
                        \ 256 bytes at ROM + &100

 LDY #0                 \ Set a loop counter in Y to step through the 256 bytes

.mrom1

 LDA ROMheader,Y        \ Copy the Y-th byte from ROMheader to ROM
 STA ROM,Y

 LDA #0                 \ Zero the Y-th byte at ROM + &100
 STA ROM+&100,Y
 INY                    \ Increment the loop counter

 BNE mrom1              \ Loop back until we have copied and zeroed all 256
                        \ bytes

 LDA #LO(ROM+&200)     \ Set ZP = ROM + &200
 STA ZP
 LDA #HI(ROM+&200)
 STA ZP+1

 JSR L74CA

 LDA XFILEV             \ Copy extended vector XFILEV into XIND1V
 STA XIND1V
 LDA XFILEV+1
 STA XIND1V+1
 LDA XFILEV+2
 STA XIND1V+2

 LDA #LO(L8022)         \ Set extended vector XFILEV to L8022 in sideways RAM
 STA XFILEV
 LDA #HI(L8022)
 STA XFILEV+1
 LDA &F4
 STA XFILEV+2

 LDA #LO(OSXIND1)       \ Point IND1V to IND1V's extended vector handler
 STA IND1V
 LDA #HI(OSXIND1)
 STA IND1V+1

 PLA                    \ Switch back to the ROM bank number that we saved on
 STA &F4                \ the stack at the start of the routine
 STA VIA+&30

 RTS                    \ Return from the subroutine


\ ******************************************************************************
\
\       Name: L74CA
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L74CA

 LDA #'A'
 STA L76F0+4

.L74CF

 LDA #'.'
 JSR OSWRCH

 LDA #LO(XX21)
 STA L76DE+2
 LDA #HI(XX21)
 STA L76DE+3
 LDA #&FF
 STA L76DE+4
 STA L76DE+5
 LDA #&00
 STA L76DE+6
 LDX #LO(L76DE)         \ (Y X) = L76DE
 LDY #HI(L76DE)
 LDA #&FF
 JSR OSFILE

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
 INC L76F0+4
 LDA L76F0+4
 CMP #&51
 BNE L74CF
 RTS


.L750D

 STA ROM+&101,Y
 LDA P
 STA ROM+&100,Y

.L7515

 RTS


.L7516

 LDA ROM+&100,Y
 STA ROM+&7B
 LDA ROM+&101,Y
 STA ROM+&7C
 BNE L753C


.L7524

 TXA
 ASL A
 TAY
 LDA XX21+1,Y
 BEQ L7515
 CPX #&01
 BNE L7537
 LDA L76F0+4
 CMP #&42
 BEQ L7516

.L7537

 LDA ROM+&101,Y
 BNE L7515

.L753C

 LDA ZP
 STA ROM+&100,Y
 LDA ZP+1
 STA ROM+&101,Y
 LDA XX21+&3E,X
 STA ROM+&13E,X
 LDA XX21,Y
 STA P
 LDA XX21+1,Y
 STA Q
 CMP #&56
 BCC L750D
 CMP #&60
 BCS L750D
 JSR L75B1
 LDA #&00
 STA R
 TAY
 LDA #&60
 STA S

.L756A

 LDA P
 CMP XX21,Y
 LDA Q
 SBC XX21+1,Y
 BCS L758C
 LDA XX21,Y
 CMP R
 LDA XX21+1,Y
 SBC S
 BCS L758C
 LDA XX21,Y
 STA R
 LDA XX21+1,Y
 STA S

.L758C

 INY
 INY
 CPY #&3E
 BNE L756A
 LDY #&00

.L7594

 LDA (P),Y
 STA (ZP),Y
 INC P
 BNE L759E
 INC Q

.L759E

 INC ZP
 BNE L75A4
 INC ZP+1

.L75A4

 LDA P
 CMP R
 BNE L7594
 LDA Q
 CMP S
 BNE L7594
 RTS


.L75B1

 TYA
 PHA
 TXA
 PHA
 CLC
 LDY #&03
 LDA (P),Y
 ADC P
 STA T
 LDY #&10
 LDA (P),Y
 ADC Q
 STA U
 LDY #&00
 LDX #&00
 LDA #LO(XX21)
 STA V
 LDA #HI(XX21)
 STA V+1

.L75D2

 LDA XX21,Y
 CMP T
 LDA XX21+1,Y
 SBC U
 BCS L75F6

.L75DE

 LDA XX21,Y
 CMP V
 LDA XX21+1,Y
 SBC V+1
 BCC L75F6
 LDA XX21,Y
 STA V
 LDA XX21+1,Y
 STA V+1
 TYA
 TAX

.L75F6

 INY
 INY
 CPY #&3E
 BNE L75D2
 SEC
 LDA T
 SBC XX21,X
 STA T
 LDA U
 SBC XX21+1,X
 STA U
 CLC
 LDA ROM+&100,X
 ADC T
 STA T
 LDA ROM+&101,X
 ADC U
 STA U
 SEC
 LDA T
 SBC ZP
 LDY #&03
 STA (P),Y
 LDA U
 SBC ZP+1
 LDY #&10
 STA (P),Y
 PLA
 TAX
 PLA
 TAY
 RTS

\ ******************************************************************************
\
\       Name: TestBBC
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.TestBBC

 LDA &F4
 PHA
 LDX #&0F

.L7635

 STX &F4
 STX VIA+&30
 LDA ROM+6
 PHA
 EOR #&01
 STA ROM+6
 CMP ROM+6
 BNE L764B
 DEC L7400,X

.L764B

 PLA
 STA ROM+6
 LDY ROM+7
 LDX #&FC

.L7654

 LDA L75DE,X
 CMP ROM,Y
 BNE L7668
 INY
 INX
 BNE L7654
 LDX &F4
 DEC L7410,X
 JMP L7670

.L7668

 LDX &F4
 TXA
 ORA #&F0
 STA ROM

.L7670

 BIT L7430
 BPL L7685
 LDY #&F2

.L7677

 LDA L75DE,Y
 CMP &7F17,Y
 BNE L7685
 INY
 BNE L7677
 STX L7430

.L7685

 TXA
 LDY #&10

.L7688

 STX &F4
 STX VIA+&30
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
 STX VIA+&30
 LDA (&F6),Y
 STY &F4
 STY VIA+&30
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
 STA L7420,X
 DEX
 BMI L76C2
 JMP L7635

.L76C2

 PLA
 STA &F4
 STA VIA+&30
 RTS

\ ******************************************************************************
\
\       Name: TestPro
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.TestPro

 LDA #0
 DEC A
 STA L7431
 RTS

.L76D0

 EQUB &53, &52
 EQUB &41, &4D
 EQUB &20, &45
 EQUB &4C, &49
 EQUB &54, &45
 EQUB &00, &28
 EQUB &43, &29

.L76DE

 EQUB &F0, &76
 EQUB &00, &56
 EQUB &FF, &FF
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00

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

 LDA ROM+&075,Y
 BEQ L803D
 CMP (&F2),Y
 BNE L806D

.L803D

 DEY
 BPL L8034
 INY

.L8041

 LDA ROM+&100,Y
 STA XX21,Y
 INY
 BNE L8041
 LDY #&04
 LDA (&F2),Y
 AND #&01
 BEQ L805E
 LDA ROM+&07B
 STA XX21+2
 LDA ROM+&07C
 STA XX21+3

.L805E

 TSX
 LDA &F4
 STA XX3+4,X
 STA LANGROM
 LDX &F0
 LDY &F1
 PLA
 RTS

.L806D

 LDX &F0
 LDY &F1
 PLA
 JMP (IND1V)

 EQUS "D.MO"
 EQUB 0
 EQUB 13
 EQUW 0
 COPYBLOCK ROM, P%, ROMheader

 ORG ROMheader + P% - ROM

\ ******************************************************************************
\
\ Save MNUCODE.bin
\
\ ******************************************************************************

 PRINT "T.MNUCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/disc/3-assembled-output/MNUCODE.bin", CODE%, P%, LOAD%