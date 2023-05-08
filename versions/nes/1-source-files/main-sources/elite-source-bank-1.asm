\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 1)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank1.bin
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _NTSC                  = (_VARIANT = 1)
 _PAL                   = (_VARIANT = 2)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
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

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 Y = 72                 \ The centre y-coordinate of the space view

 OIL = 5                \ Ship type for a cargo canister
 COPS = 16              \ Ship type for a Viper
 SH3 = 17               \ Ship type for a Sidewinder
 KRA = 19               \ Ship type for a Krait

 NI% = 42               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 S% = &C007             \ The game's main entry point in bank 7

 PPU_CTRL   = &2000     \ NES PPU registers
 PPU_MASK   = &2001
 PPU_STATUS = &2002
 OAM_ADDR   = &2003
 OAM_DATA   = &2004
 PPU_SCROLL = &2005
 PPU_ADDR   = &2006
 PPU_DATA   = &2007
 OAM_DMA    = &4014
 
 SNE                = &C500
 ACT                = &C520
 XX21               = &C540
 SwitchTablesTo0    = &D06D
 TWOS               = &D9F7
 yLookupLo          = &DA18
 yLookupHi          = &DAF8
 LOIN               = &DC0F
 LE04A              = &E04A
 LE0BA              = &E0BA
 PIXEL              = &E4F0
 MVS5_BANK0         = &F1A2
 TT66               = &F26E
 LF2CE              = &F2CE
 DORND2             = &F4AC
 DORND              = &F4AD
 PROJ               = &F4C1
 MLS2               = &F6BA
 MLS1               = &F6C2
 MULTS              = &F6C6
 SQUA2              = &F70E
 MLU1               = &F718
 MLU2               = &F71D
 MULTU              = &F721
 FMLTU2             = &F766
 FMLTU              = &F770
 MUT2               = &F7D2
 MUT1               = &F7D6
 MULT1              = &F7DA
 MULT12             = &F83C
 MAD                = &F86F
 ADD                = &F872
 TIS1               = &F8AE
 DV42               = &F8D1
 DV41               = &F8D4
 DVID4              = &F8D8
 DVID3B2            = &F962
 LL5                = &FA55
 LL28               = &FA91
 NORM               = &FAF8

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/nes/main/workspace/spr.asm"

\ ******************************************************************************
\
\       Name: WP
\       Type: Workspace
\    Address: &0300 to &05FF
\   Category: Workspaces
\    Summary: Ship slots, variables
\
\ ******************************************************************************

 L0374               = &0374
 L037E               = &037E
 MJ                  = &038A
 VIEW                = &038E
 QQ0                 = &039F
 QQ1                 = &03A0
 CASH                = &03A1
 GCNT                = &03A7
 CRGO                = &03AC
 QQ20                = &03AD
 BST                 = &03BF
 GHYP                = &03C3
 FIST                = &03C9
 AVL                 = &03CA
 QQ26                = &03DB
 L03DD               = &03DD
 QQ21                = &03DF
 NOSTM               = &03E5
 L03E6               = &03E6
 L03F1               = &03F1
 DTW6                = &03F3
 DTW2                = &03F4
 DTW3                = &03F5
 DTW4                = &03F6
 DTW5                = &03F7
 DTW1                = &03F8
 DTW8                = &03F9
 L040A               = &040A
 QQ19                = &044D
 K2                  = &0459
 SWAP                = &047F
 QQ24                = &0487
 QQ25                = &0488
 QQ28                = &0489
 QQ29                = &048A
 QQ8                 = &049B
 QQ9                 = &049D
 QQ10                = &049E
 QQ18Lo              = &04A4
 QQ18Hi              = &04A5
 TKN1Lo              = &04A6
 TKN1Hi              = &04A7
 SX                  = &04C8
 SY                  = &04DD
 SZ                  = &04F2
 BUFm1               = &0506
 BUF                 = &0507
 HANGFLAG            = &0561
 SXL                 = &05A5
 SYL                 = &05BA
 SZL                 = &05CF
 safehouse           = &05E4
 L05EA               = &05EA
 L05EB               = &05EB
 L05EC               = &05EC
 L05ED               = &05ED
 L05EE               = &05EE
 L05EF               = &05EF
 L05F0               = &05F0
 L05F1               = &05F1

INCLUDE "library/common/main/workspace/k_per_cent.asm"

\ ******************************************************************************
\
\ ELITE BANK 1
\
\ Produces the binary file bank1.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/nes/main/macro/check_dashboard.asm"
INCLUDE "library/nes/main/variable/unused_copy_of_xx21.asm"
INCLUDE "library/advanced/main/variable/e_per_cent.asm"
INCLUDE "library/master/data/variable/kwl_per_cent.asm"
INCLUDE "library/master/data/variable/kwh_per_cent.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"
INCLUDE "library/common/main/variable/ship_coriolis.asm"
INCLUDE "library/common/main/variable/ship_escape_pod.asm"
INCLUDE "library/enhanced/main/variable/ship_plate.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
INCLUDE "library/enhanced/main/variable/ship_boulder.asm"
INCLUDE "library/common/main/variable/ship_asteroid.asm"
INCLUDE "library/enhanced/main/variable/ship_splinter.asm"
INCLUDE "library/enhanced/main/variable/ship_shuttle.asm"
INCLUDE "library/enhanced/main/variable/ship_transporter.asm"
INCLUDE "library/common/main/variable/ship_cobra_mk_3.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/enhanced/main/variable/ship_boa.asm"
INCLUDE "library/enhanced/main/variable/ship_anaconda.asm"
INCLUDE "library/advanced/main/variable/ship_rock_hermit.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
INCLUDE "library/common/main/variable/ship_sidewinder.asm"
INCLUDE "library/common/main/variable/ship_mamba.asm"
INCLUDE "library/enhanced/main/variable/ship_krait.asm"
INCLUDE "library/enhanced/main/variable/ship_adder.asm"
INCLUDE "library/enhanced/main/variable/ship_gecko.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_1.asm"
INCLUDE "library/enhanced/main/variable/ship_worm.asm"
INCLUDE "library/enhanced/main/variable/ship_cobra_mk_3_p.asm"
INCLUDE "library/enhanced/main/variable/ship_asp_mk_2.asm"

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/enhanced/main/variable/ship_python_p.asm"
INCLUDE "library/enhanced/main/variable/ship_fer_de_lance.asm"
INCLUDE "library/enhanced/main/variable/ship_moray.asm"
INCLUDE "library/common/main/variable/ship_thargoid.asm"
INCLUDE "library/common/main/variable/ship_thargon.asm"
INCLUDE "library/enhanced/main/variable/ship_constrictor.asm"
INCLUDE "library/advanced/main/variable/ship_cougar.asm"
INCLUDE "library/enhanced/main/variable/ship_dodo.asm"

 EQUB &00, &FF          \ These bytes appear to be unused
 EQUB &FF, &00

INCLUDE "library/common/main/subroutine/shppt.asm"
INCLUDE "library/common/main/subroutine/ll38.asm"
INCLUDE "library/common/main/subroutine/ll51.asm"
INCLUDE "library/common/main/subroutine/ll9_part_1_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_2_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_3_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_4_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_5_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_6_of_12.asm"
INCLUDE "library/common/main/subroutine/ll61.asm"
INCLUDE "library/common/main/subroutine/ll62.asm"
INCLUDE "library/common/main/subroutine/ll9_part_7_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_8_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_9_of_12.asm"
INCLUDE "library/common/main/subroutine/ll9_part_10_of_12.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/planet.asm"
INCLUDE "library/common/main/subroutine/pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine/pls1.asm"
INCLUDE "library/common/main/subroutine/pls2.asm"
INCLUDE "library/common/main/subroutine/pls22.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
INCLUDE "library/common/main/subroutine/edges.asm"

\ ******************************************************************************
\
\       Name: CB039
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: ??? called from sun part 2
\
\ ******************************************************************************

.CB039

 LDX P                  \ ???
 STX X2
 EOR #&FF
 SEC
 ADC YY
 STA XX15
 LDA YY+1
 ADC #&FF
 BEQ CB04D
 BMI CB056

.CB04C

 RTS

.CB04D

 LDA XX15
 CMP X2
 BCS CB04C
 JMP LE0BA

.CB056

 LDA #0
 STA XX15
 JMP LE0BA

\ ******************************************************************************
\
\       Name: CB05D
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: ??? called from sun part 2
\
\ ******************************************************************************

.CB05D

 CLC                    \ ???
 ADC YY
 STA X2
 LDA YY+1
 ADC #0
 BEQ CB04D
 BMI CB04C
 LDA #&FD
 STA X2
 CMP XX15
 BEQ CB04C
 BCC CB04C
 JMP LE0BA

INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"

\ ******************************************************************************
\
\       Name: PL44
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: ??? normally in edges.asm, but is here instead
\
\ ******************************************************************************

.PL44

 CLC
 RTS

INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/nes/main/subroutine/hanger.asm"
INCLUDE "library/nes/main/subroutine/has2.asm"
INCLUDE "library/nes/main/subroutine/has3.asm"
INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"

\ ******************************************************************************
\
\       Name: SCAN
\   Category: Dashboard
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.CB969
 LDA #&F0
 STA SPR_00_Y,Y
 STA SPR_01_Y,Y
 STA SPR_02_Y,Y
.CB974
 RTS

.SCAN

 LDA W                  \ ???
 BNE CB974
 LDX TYPE
 BMI CB974
 LDA L002A
 BEQ CB974
 TAX
 ASL A
 ADC L002A
 ASL A
 ASL A
 ADC #&2C
 TAY
 LDA L037E,X
 STA SPR_00_ATTR,Y
 LDA INWK+1
 CMP INWK+4
 BCS CB998
 LDA INWK+4
.CB998
 CMP INWK+7
 BCS CB99E
 LDA INWK+7
.CB99E
 CMP #&40
 BCS CB969
 STA addr3
 LDA INWK+1
 ADC INWK+4
 ADC INWK+7
 BCS CB969
 SEC
 SBC addr3
 LSR A
 LSR A
 STA addr3+1
 LSR A
 LSR A
 ADC addr3+1
 ADC addr3
 CMP #&40
 BCS CB969
 LDA INWK+1
 CLC
 LDX INWK+2
 BPL CB9C8
 EOR #&FF
 ADC #1
.CB9C8
 ADC #&7C
 STA addr3
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDX INWK+8
 BMI CB9D8
 EOR #&FF
 SEC
.CB9D8
 ADC #&C7
 STA addr3+1
 LDA INWK+4
 CMP #&30
 BCC CB9E4
 LDA #&2F
.CB9E4
 LSR A
 STA Y1
 CLC
 BEQ CB9F1
 LDX INWK+5
 BPL CB9F1
 JMP CBA6C

.CB9F1
 LDA addr3+1
 SEC
 SBC #8
 STA addr3+1
 LDA Y1
 CMP #&10
 BCC CBA24
 LDA addr3
 STA SPR_00_X,Y
 STA SPR_01_X,Y
 LDA addr3+1
 STA SPR_00_Y,Y
 SEC
 SBC #8
 STA SPR_01_Y,Y
 LDA SPR_00_ATTR,Y
 AND #3
 STA SPR_00_ATTR,Y
 STA SPR_01_ATTR,Y
 LDA addr3+1
 SBC #&10
 STA addr3+1
 BNE CBA4F
.CBA24
 CMP #8
 BCC CBA47
 LDA #&F0
 STA SPR_00_Y,Y
 LDA addr3
 STA SPR_01_X,Y
 LDA addr3+1
 STA SPR_01_Y,Y
 LDA SPR_00_ATTR,Y
 AND #3
 STA SPR_01_ATTR,Y
 LDA addr3+1
 SBC #8
 STA addr3+1
 BNE CBA4F
.CBA47
 LDA #&F0
 STA SPR_00_Y,Y
 STA SPR_01_Y,Y
.CBA4F
 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA SPR_02_TILE,Y
 LDA SPR_00_ATTR,Y
 AND #3
 STA SPR_02_ATTR,Y
 LDA addr3
 STA SPR_02_X,Y
 LDA addr3+1
 STA SPR_02_Y,Y
 RTS

.CBA6C
 CLC
 ADC addr3+1
 CMP #&DC
 BCC CBA75
 LDA #&DC
.CBA75
 SEC
 SBC addr3+1
 STA Y1
 CMP #&10
 BCC CBAA5
 LDA addr3
 STA SPR_00_X,Y
 STA SPR_01_X,Y
 LDA addr3+1
 STA SPR_00_Y,Y
 CLC
 ADC #8
 STA SPR_01_Y,Y
 LDA SPR_00_ATTR,Y
 ORA #&20
 STA SPR_00_ATTR,Y
 STA SPR_01_ATTR,Y
 LDA addr3+1
 CLC
 ADC #&10
 STA addr3+1
 BNE CBAD0
.CBAA5
 CMP #8
 BCC CBAC8
 LDA #&F0
 STA SPR_00_Y,Y
 LDA addr3
 STA SPR_01_X,Y
 LDA addr3+1
 STA SPR_01_Y,Y
 LDA SPR_00_ATTR,Y
 ORA #&20
 STA SPR_01_ATTR,Y
 LDA addr3+1
 ADC #7
 STA addr3+1
 BNE CBAD0
.CBAC8
 LDA #&F0
 STA SPR_00_Y,Y
 STA SPR_01_Y,Y
.CBAD0
 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA SPR_02_TILE,Y
 LDA SPR_00_ATTR,Y
 ORA #&E0
 STA SPR_02_ATTR,Y
 LDA addr3
 STA SPR_02_X,Y
 LDA addr3+1
 STA SPR_02_Y,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_CBAED
\   Category: Dashboard
\   Category: Drawing ships
\    Summary: ??? Called from LL9 part 1
\
\ ******************************************************************************

.sub_CBAED

 LDA #0                 \ ???
 LDY #&21
 STA (INF),Y

 CHECK_DASHBOARD        \ If the PPU has started drawing the dashboard, switch
                        \ to nametable 0 (&2000) and pattern table 0 (&0000)

\ ******************************************************************************
\
\       Name: sub_CBAF3
\   Category: Dashboard
\   Category: Drawing ships
\    Summary: ??? Called via CBAF3_BANK1
\
\ ******************************************************************************

.sub_CBAF3

 LDX L002A              \ ???
 BEQ CBB23
 LDA #0
 STA L0374,X
 TXA
 ASL A
 ADC L002A
 ASL A
 ASL A
 TAX
 LDA W
 BNE CBB1F
 LDA #&F0
 STA SPR_11_Y,X
 STA SPR_12_Y,X
 STA SPR_13_Y,X
.CBB1F
 LDA #0
 STA L002A
.CBB23
 RTS

INCLUDE "library/nes/main/subroutine/ptcls2.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank1.bin
\
\ ******************************************************************************

 PRINT "S.bank1.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank1.bin", CODE%, P%, LOAD%
