\ ******************************************************************************
\
\ COMMODORE 64 ELITE GMA1 LOADER FILE
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
\   * gma1.bin
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

 CODE% = &0334          \ The address where the code will be run

 LOAD% = &0334          \ The address where the code will be loaded

IF _GMA_RELEASE

 ENTRY = &7596          \ Entry point in elite-loader (gma4)

 S% = &1D22             \ Entry point in LOCODE (gma5)

ELIF _SOURCE_DISK

 ENTRY = &7607          \ Entry point in elite-loader (gma4)

 S% = &1D1F             \ Entry point in LOCODE (gma5)

ENDIF

\ ******************************************************************************
\
\ ELITE GMA1 LOADER
\
\ ******************************************************************************

 ORG CODE% - 2          \ Add a two-byte PRG header to the start of the file
 EQUW LOAD%             \ that contains the load address

IF _GMA86_PAL

 JMP L0345

 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &11, &04
 EQUB &11, &05
 EQUB &11, &06
 EQUB &13
 EQUB &00
 EQUB &14
 EQUB &08

.L0345

ENDIF

 LDA #&00
 JSR &FF90
 LDA #&FF
 STA &0329
 JSR L0661

IF _GMA86_PAL

 LDA #&03

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&33

ENDIF

 JSR L039B

 JSR &C800              \ Call the copy protection code in gma3 (this call gets
                        \ removed by elite-checksum.py)

IF _GMA86_PAL

 LDA &02
 EOR #&97

 BEQ L0363              \ Check against the checksum from gma3 (this check gets
                        \ removed by elite-checksum.py)

 JMP (&FFFC)

.L0363

ENDIF

IF _GMA86_PAL

 LDA #&04

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&34

ENDIF

 JSR L039B
 JSR &FF81
 LDA #&02
 STA &D020
 STA &D021
 LDA #&04
 STA &0288

 LDA #&4C               \ Set &CE0E = JMP L0370
 STA &CE0E
 LDA #LO(L0370)
 STA &CE0F

.L0382

 LDA #HI(L0370)
 STA &CE10

 JMP ENTRY              \ Jump to the entry point in elite-loader, which returns
                        \ to L0370 via the JMP command we put in &CE0E above

.L0370

 CLC
 JSR L064F
 LDA &01
 AND #&F8
 ORA #&2E
 STA &01

IF _GMA86_PAL

 LDA #&05
 JSR L039B
 LDA #&06
 JSR L039B

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&35
 JSR L039B
 LDA #&36
 JSR L039B

ENDIF

 LDA &01
 AND #&F8
 ORA #&06
 STA &01
 SEC
 JSR L064F
 JSR &FF8A
 JSR &FFE7

 JMP S%                 \ Jump to gma5 entry point at S% to start game

.L039B

 JSR L03AD
 LDA #&01
 LDX #&08
 LDY #&01
 JSR &FFBA
 LDA #&00
 JSR &FFD5
 RTS

.L03AD

IF _GMA86_PAL

 TAX
 CLC
 ADC #&30
 STA &03EA
 TXA
 ASL A
 TAX
 LDA &0337,X
 STA &04B9
 LDA &0338,X
 STA &04BD
 LDX #&E7

ELIF _GMA85_NTSC OR _SOURCE_DISK

 STA &03BD
 LDX #&BA

ENDIF

 LDY #&03
 LDA #&04
 JSR &FFBD
 RTS

 EQUS "GMA  WAS HERE 1985 OK"

.L03CF

 JSR L0610
 JSR L0605

 RTS
 LDA #&06
 STA &31
 JSR &F50A

.L03DD

 BVC L03DD
 CLV
 LDA &1C01

IF _GMA86_PAL

 STA &0600,Y

ELIF _GMA85_NTSC OR _SOURCE_DISK

 STA (&30),Y

ENDIF

 INY
 BNE L03DD
 LDY #&BA

.L03EA

 BVC L03EA
 CLV
 LDA &1C01
 STA &0100,Y
 INY
 BNE L03EA
 JSR &F8E0
 LDA &38
 CMP &47
 BEQ L0403
 LDA #&04
 BNE L0462

.L0403

 JSR &F5E9
 CMP &3A
 BEQ L040E
 LDA #&05
 BNE L0462

.L040E

IF _GMA86_PAL

 LDA &0601
 STA &07
 LDY #&02
 LDX #&FF
 LDA &0600
 BEQ L044D
 STX &0601

.L044D

 INC &0601

.L0450

 LDX &0600,Y
 CPX #&01
 BNE L045A
 JSR L0382

.L045A

 JSR L0382
 INY
 CPY &0601
 BNE L0450
 LDA &0600
 BEQ L0476
 CMP &06
 STA &06
 BEQ L0465
 LDA #&01

.L0470

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA (&30),Y
 BNE L0415
 INC &0601

.L0415

 LDA (&30),Y
 TAX

.L0418

 BIT &1800
 BPL L0418
 LDA #&10
 STA &1800

.L0422

 BIT &1800
 BMI L0422
 TXA
 LSR A
 LSR A
 LSR A
 LSR A
 STA &1800
 ASL A
 AND #&0F
 NOP
 STA &1800
 TXA
 AND #&0F
 NOP
 STA &1800
 ASL A
 AND #&0F
 NOP
 STA &1800
 LDX #&0F
 NOP
 NOP
 STX &1800
 LDA &0600
 BEQ L0468
 INY
 BNE L0415
 LDA &0601
 STA &0F
 LDA (&30),Y
 CMP &0E
 STA &0E
 BEQ L0465
 LDA #&01

ENDIF

.L0462

 JMP &F969

.L0465

IF _GMA86_PAL

 JMP &0304

.L0476

 LDX #&01
 JSR L0382
 LDX #&02
 JSR L0382
 LDA #&7F
 JMP &F969

.L0485

 BIT &1800
 BPL L0485
 LDA #&10
 STA &1800

.L048F

 BIT &1800
 BMI L048F
 TXA
 LSR A
 LSR A
 LSR A
 LSR A
 STA &1800
 ASL A
 AND #&0F
 STA &1800
 TXA
 AND #&0F
 STA &1800
 ASL A
 AND #&0F
 STA &1800
 LDA #&0F
 NOP
 STA &1800
 RTS
 JSR &D042
 LDA #&FF
 STA &06
 LDA #&FF
 STA &07

ELIF _GMA85_NTSC OR _SOURCE_DISK

 JMP L0704

.L0468

 INY
 CPY &0601
 BNE L0415
 LDA #&7F
 BNE L0462
 LDA &18
 STA &0E
 LDA &19
 STA &0F

ENDIF

.L047A

IF _GMA86_PAL

 LDA #&E0
 STA &00

.L047E

 LDA &00

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&E0
 STA &04

.L047E

 LDA &04

ENDIF

 BMI L047E
 CMP #&7F
 BEQ L0488
 BCC L047A

.L0488

 JMP &D048

.L048B

 LDA &A4
 STA &DD00

.L0490

 LDA &DD00
 BPL L0490

.L0495

 LDA &D012
 CMP #&31
 BCC L04A2
 AND #&06
 CMP #&02
 BEQ L0495

.L04A2

 LDA &A5
 STA &DD00
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

IF _GMA86_PAL

 LDX &DD00
 LDA &CF00,X
 LDX &DD00
 ORA &CF08,X
 LDX &DD00
 ORA &CF10,X
 LDX &DD00
 ORA &CF18,X

ELIF _GMA85_NTSC OR _SOURCE_DISK

 NOP
 LDY &DD00
 LDA &CF00,Y
 NOP
 LDY &DD00
 ORA &CF08,Y
 NOP
 LDY &DD00
 ORA &CF10,Y
 NOP
 LDY &DD00
 ORA &CF18,Y

ENDIF

 RTS

IF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&00
 STA &93
 LDA &BA
 CMP #&08
 BCS L04DA
 LDA #&08

.L04DA

 STA &BA
 STA &B8
 JSR &F5AF
 JSR &F333
 LDX &B9
 STX &02
 LDA #&60
 STA &B9
 JSR &F3D5
 LDA &BA
 JSR &ED09
 LDA &B9
 JSR &EDC7
 JSR &EE13
 LDA &90
 LSR A
 LSR A
 BCC L0505
 JMP &F704

.L0505

 JSR &F5D2

ENDIF

 LDA #&00
 STA &A4

.L050C

 JSR L05DB
 LDA #&57
 JSR &EDDD
 LDA &A4
 JSR &EDDD

IF _GMA86_PAL

 LDA #&03

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&07

ENDIF

 JSR &EDDD
 LDA #&20
 JSR &EDDD
 LDY &A4
 CLC
 LDA &A4
 ADC #&20
 STA &A4

.L052C

IF _GMA86_PAL

 LDA &0403,Y

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA &03D6,Y

ENDIF

 JSR &EDDD
 INY
 CPY &A4
 BNE L052C

IF _GMA86_PAL

 JSR &FFCC
 LDA &A4
 CMP #&CE

ELIF _GMA85_NTSC OR _SOURCE_DISK

 JSR &EDFE
 LDA &A4
 CMP #&B5

ENDIF

 BCC L050C
 JSR L05DB
 LDA #&45
 JSR &EDDD

IF _GMA86_PAL

 LDA #&B2
 JSR &EDDD
 LDA #&03
 JSR &EDDD
 JSR &FFCC

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&9C
 JSR &EDDD
 LDA #&07
 JSR &EDDD
 JSR &EDFE

ENDIF

 LDA &DD00
 AND #&07
 STA &A5
 ORA #&08
 STA &A4
 SEI

IF _GMA85_NTSC OR _SOURCE_DISK

 LDX #&04

.L0563

 JSR L048B
 BEQ L0597
 CMP #&FF
 BNE L0572
 LDA #&02
 STA &90
 BNE L05BB

.L0572

 JSR L048B
 CPX #&02
 BEQ L057C
 JSR L05F0

.L057C

 JSR L048B
 JSR L062B
 LDY #&00
 STA (&AE),Y
 INC &AE
 BEQ L0592

.L058A

 INX
 BNE L057C
 LDX #&02
 JMP L0563

.L0592

 INC &AF
 JMP L058A

.L0597

 JSR L048B
 CPX #&02
 PHP
 TAX
 PLP
 BEQ L05A6

 JSR L05F0
 DEX
 DEX

.L05A6

 DEX
 DEX

.L05A8

 JSR L048B

ENDIF

IF _GMA86_PAL

 JSR L05F0

 LDY #&00

.L056E

 JSR L062B
 JSR L048B
 CMP #&01
 BNE L057F
 JSR L048B
 CMP #&01
 BNE L0588

.L057F

 STA (&AE),Y
 INY
 BNE L056E
 INC &AF
 BNE L056E

.L0588

 LDA &A5
 STA &0618
 JSR &F646

ELIF _GMA85_NTSC OR _SOURCE_DISK

 JSR L062B

 LDY #&00

 STA (&AE),Y
 INC &AE
 BNE L05B8
 INC &AF

.L05B8

 DEX
 BNE L05A8

.L05BB

 LDA &A5
 STA &064E
 JSR &F646

ENDIF

.L05C3

 LDA &D011
 BPL L05C3
 JSR &FDA3
 LDA &DD00
 AND #&F8

IF _GMA86_PAL

 ORA &0618
 STA &DD00

ELIF _GMA85_NTSC OR _SOURCE_DISK

 ORA &064E
 STA &DD00
 LDX &AE
 LDY &AF

ENDIF

 RTS

.L05DB

IF _GMA86_PAL

 LDA #&00
 JSR &FFBD
 LDA #&0F
 TAY
 LDX #&08
 JSR &FFBA
 JSR &FFC0
 LDX #&0F
 JSR &FFC9

 LDA #&4D
 JSR &FFD2
 LDA #&2D
 JSR &FFD2

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA &BA
 JSR &ED0C
 LDA #&6F
 JSR &EDB9

 LDA #&4D
 JSR &EDDD
 LDA #&2D
 JSR &EDDD

ENDIF

 RTS

.L05F0

 JSR L048B
 STA &AE
 JSR L048B

IF _GMA85_NTSC OR _SOURCE_DISK

 LDY &02
 BNE L0602
 LDA &C3
 STA &AE
 LDA &C4

.L0602

ENDIF

 STA &AF
 RTS

.L0605

IF _GMA86_PAL

 LDA #&10
 STA &0330
 LDA #&05
 STA &0331

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA #&CE
 STA &0330
 LDA #&04
 STA &0331

ENDIF

 RTS

.L0610

 LDX #&00
 LDY #&00

.L0614

 LDA #&08

IF _GMA86_PAL

 STA &0618
 LDA &05FC,X

ELIF _GMA85_NTSC OR _SOURCE_DISK

 STA &064E
 LDA &0632,X

ENDIF

.L061C

 STA &CF00,Y
 INY

IF _GMA86_PAL

 DEC &0618

ELIF _GMA85_NTSC OR _SOURCE_DISK

 DEC &064E

ENDIF

 BNE L061C
 INX
 CPX #&1C
 BCC L0614
 RTS

.L062B

 INC &D020
 DEC &D020
 RTS

 EQUB &A0, &50
 EQUB &0A
 EQUB &05, &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &20, &10, &02
 EQUB &01, &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &80
 EQUB &40
 EQUB &08
 EQUB &04
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &FF
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &FF

.L064F

 LDX #&02

.L0651

 LDA &00,X
 BCC L0658
 LDA &CE00,X

.L0658

 STA &0000,X
 STA &CE00,X
 INX
 BNE L0651
 RTS

.L0661

 LDA &D011
 BPL L0661
 LDA #&08
 STA &0288
 JSR &FF81

 LDA &D018              \ Set the high nibble of &D018 to &02, so it's &2x
 AND #&0F               \ (where x is the original low nibble of &D018)
 ORA #&20               \
 STA &D018              \ The high nibble of &D018 defines the start address for
                        \ ???, in multiples of 1024 bytes,
                        \ so this sets ??? to:
                        \
                        \   2 * 1024 = 2048
                        \            = &0800

 LDA #&02
 STA &D020
 STA &D021
 LDX #&00
 JSR L06A6
 TXA
 PHA

IF _GMA86_PAL

 LDA &067D
 BNE L06A4
 INC &067D
 LDA #&1C
 STA &06B3

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA &06B3
 BNE L06A4
 INC &06B3
 LDA #&1C
 STA &06E9

ENDIF

.L0694

 JSR &FFE4
 BEQ L0694
 CMP #&4E
 BEQ L06A4
 CMP #&59
 BNE L0694
 JSR L03CF

.L06A4

 PLA
 TAX

.L06A6

IF _GMA86_PAL

 LDA &067E,X

ELIF _GMA85_NTSC OR _SOURCE_DISK

 LDA &06B4,X

ENDIF

 BEQ L06B1
 JSR &FFD2
 INX
 BNE L06A6

.L06B1

 INX
 RTS

 EQUB &00
 EQUB &93
 EQUB &96, &8E
 EQUB &08
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &47
 EQUB &4D, &41, &38

IF _GMA86_PAL

 EQUB &36

ELIF _GMA85_NTSC OR _SOURCE_DISK

 EQUB &35

ENDIF

 EQUB &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &9E
 EQUB &20, &44, &4F
 EQUB &20, &59, &4F
 EQUB &55, &20
 EQUB &57
 EQUB &41, &4E
 EQUB &54
 EQUB &20, &54, &4F
 EQUB &20, &55, &53
 EQUB &45, &0D
 EQUB &0D, &20, &54
 EQUB &48
 EQUB &45, &20

.L0704

 EQUB &46, &41
 EQUB &53
 EQUB &54
 EQUB &20, &4C, &4F
 EQUB &41, &44
 EQUB &45, &52
 EQUB &3F
 EQUB &20, &28, &59
 EQUB &2F
 EQUB &4E, &29, &00
 EQUB &93
 EQUB &96, &8E
 EQUB &08
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &47
 EQUB &4D, &41, &38

IF _GMA86_PAL

 EQUB &36

ELIF _GMA85_NTSC OR _SOURCE_DISK

 EQUB &35

ENDIF

 EQUB &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &11, &11
 EQUB &9E
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &4C
 EQUB &4F
 EQUB &41, &44
 EQUB &49, &4E
 EQUB &47
 EQUB &0D, &0D, &20
 EQUB &20, &20, &20
 EQUB &20
 EQUB &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &20
 EQUB &20, &20, &45
 EQUB &4C, &49, &54
 EQUB &45, &2E
 EQUB &00

\ ******************************************************************************
\
\ Save gma1.bin
\
\ ******************************************************************************

 SAVE "versions/c64/3-assembled-output/gma1.bin", CODE%-2, P%, LOAD%
