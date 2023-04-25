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

CODE% = &8000
LOAD% = &8000

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"

\ Workspace

L0200               = &0200
L0202               = &0202
L0203               = &0203
L0204               = &0204
L0206               = &0206
L0207               = &0207
L0208               = &0208
L0209               = &0209
L020A               = &020A
L020B               = &020B
L022C               = &022C
L0230               = &0230
L0234               = &0234
L0294               = &0294
L0295               = &0295
L0297               = &0297
L02E8               = &02E8
L02E9               = &02E9
L02EA               = &02EA
L02EB               = &02EB

\ WP workspace

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
QQ18LO              = &04A4
QQ18HI              = &04A5
TOKENLO             = &04A6
TOKENHI             = &04A7
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

\ NES PPU registers

PPUCTRL             = &2000
PPUMASK             = &2001
PPUSTATUS           = &2002
OAMADDR             = &2003
OAMDATA             = &2004
PPUSCROLL           = &2005
PPUADDR             = &2006
PPUDATA             = &2007
OAMDMA              = &4014

\ Shared code from 7.asm

LC006               = &C006
LC007               = &C007
RESETBANK           = &C0AD
SETBANK             = &C0AE
log                 = &C100
logL                = &C200
antilog             = &C300
antilogODD          = &C400
SNE                 = &C500
ACT                 = &C520
LC53F               = &C53F
XX21                = &C540
NMI                 = &CED5
NAMETABLE0          = &D06D
LD9F7               = &D9F7
LDA18               = &DA18
LDAF8               = &DAF8
LOIN                = &DC0F
LE04A               = &E04A
LE0BA               = &E0BA
PIXEL               = &E4F0
DELAY               = &EBA2
MESS                = &EBF2
PAS1                = &EF7A
DETOK               = &F082
DTS                 = &F09D
MVS5                = &F1A2
DASC                = &F1E6
TT27                = &F201
TT27_control_codes  = &F237
TT66                = &F26E
LF2CE               = &F2CE
CLYNS               = &F2DE
NLIN4               = &F473
DORND2              = &F4AC
DORND               = &F4AD
PROJ                = &F4C1
MU5                 = &F65A
MULT3               = &F664
MLS2                = &F6BA
MLS1                = &F6C2
MULTSm2             = &F6C4
MULTS               = &F6C6
MU6                 = &F707
SQUA                = &F70C
SQUA2               = &F70E
MU1                 = &F713
MLU1                = &F718
MLU2                = &F71D
MULTU               = &F721
MU11                = &F725
FMLTU2              = &F766
FMLTU               = &F770
MLTU2               = &F7AD
MUT2                = &F7D2
MUT1                = &F7D6
MULT1               = &F7DA
MULT12              = &F83C
MAD                 = &F86F
ADD                 = &F872
TIS1                = &F8AE
DV42                = &F8D1
DV41                = &F8D4
LF8D8               = &F8D8
DVID3B2             = &F962
LL5                 = &FA55
LL28                = &FA91
NORM                = &FAF8

 ORG CODE%

 SEI
 INC LC006
 JMP LC007

 EQUS "@ 5.0"

Y = 72

OIL = 5
COPS = 16
SH3 = 17
KRA = 19

NI% = 38


INCLUDE "library/nes/main/macro/set_nametable_0.asm"

 EQUW SHIP_ASTEROID     \ AST  =  7 = Asteroid
 EQUW SHIP_SPLINTER     \ SPL  =  8 = Splinter
 EQUW SHIP_SHUTTLE      \ SHU  =  9 = Shuttle
 EQUW SHIP_TRANSPORTER  \        10 = Transporter
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW SHIP_PYTHON       \        12 = Python
 EQUW SHIP_BOA          \        13 = Boa
 EQUW SHIP_ANACONDA     \ ANA  = 14 = Anaconda
 EQUW SHIP_ROCK_HERMIT  \ HER  = 15 = Rock hermit (asteroid)
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW SHIP_SIDEWINDER   \ SH3  = 17 = Sidewinder
 EQUW SHIP_MAMBA        \        18 = Mamba
 EQUW SHIP_KRAIT        \ KRA  = 19 = Krait
 EQUW SHIP_ADDER        \ ADA  = 20 = Adder
 EQUW SHIP_GECKO        \        21 = Gecko
 EQUW SHIP_COBRA_MK_1   \        22 = Cobra Mk I
 EQUW SHIP_WORM         \ WRM  = 23 = Worm
 EQUW SHIP_COBRA_MK_3_P \ CYL2 = 24 = Cobra Mk III (pirate)
 EQUW SHIP_ASP_MK_2     \ ASP  = 25 = Asp Mk II
 EQUW SHIP_PYTHON_P     \        26 = Python (pirate)
 EQUW SHIP_FER_DE_LANCE \        27 = Fer-de-lance
 EQUW SHIP_MORAY        \        28 = Moray
 EQUW SHIP_THARGOID     \ THG  = 29 = Thargoid
 EQUW SHIP_THARGON      \ TGL  = 30 = Thargon
 EQUW SHIP_CONSTRICTOR  \ CON  = 31 = Constrictor
 EQUW SHIP_COUGAR       \ COU  = 32 = Cougar
 EQUW SHIP_DODO         \ DOD  = 33 = Dodecahedron ("Dodo") space station

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
\INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
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

\ CB039 is called from sun part 2

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

\ CB05D is called from sun part 2

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

\ This is normally in edges.asm, but is here instead

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

.CB969
 LDA #&F0
 STA L0200,Y
 STA L0204,Y
 STA L0208,Y
.CB974
 RTS

.F2A8_BANK1

 LDA W                  \ B975, called via F2A8 in 7.asm
 BNE CB974              \ (e.g. called from bank 0)
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
 STA L0202,Y
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
 STA L00BA
 LDA INWK+1
 ADC INWK+4
 ADC INWK+7
 BCS CB969
 SEC
 SBC L00BA
 LSR A
 LSR A
 STA L00BB
 LSR A
 LSR A
 ADC L00BB
 ADC L00BA
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
 STA L00BA
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
 STA L00BB
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
 LDA L00BB
 SEC
 SBC #8
 STA L00BB
 LDA Y1
 CMP #&10
 BCC CBA24
 LDA L00BA
 STA L0203,Y
 STA L0207,Y
 LDA L00BB
 STA L0200,Y
 SEC
 SBC #8
 STA L0204,Y
 LDA L0202,Y
 AND #3
 STA L0202,Y
 STA L0206,Y
 LDA L00BB
 SBC #&10
 STA L00BB
 BNE CBA4F
.CBA24
 CMP #8
 BCC CBA47
 LDA #&F0
 STA L0200,Y
 LDA L00BA
 STA L0207,Y
 LDA L00BB
 STA L0204,Y
 LDA L0202,Y
 AND #3
 STA L0206,Y
 LDA L00BB
 SBC #8
 STA L00BB
 BNE CBA4F
.CBA47
 LDA #&F0
 STA L0200,Y
 STA L0204,Y
.CBA4F
 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA L0209,Y
 LDA L0202,Y
 AND #3
 STA L020A,Y
 LDA L00BA
 STA L020B,Y
 LDA L00BB
 STA L0208,Y
 RTS

.CBA6C
 CLC
 ADC L00BB
 CMP #&DC
 BCC CBA75
 LDA #&DC
.CBA75
 SEC
 SBC L00BB
 STA Y1
 CMP #&10
 BCC CBAA5
 LDA L00BA
 STA L0203,Y
 STA L0207,Y
 LDA L00BB
 STA L0200,Y
 CLC
 ADC #8
 STA L0204,Y
 LDA L0202,Y
 ORA #&20
 STA L0202,Y
 STA L0206,Y
 LDA L00BB
 CLC
 ADC #&10
 STA L00BB
 BNE CBAD0
.CBAA5
 CMP #8
 BCC CBAC8
 LDA #&F0
 STA L0200,Y
 LDA L00BA
 STA L0207,Y
 LDA L00BB
 STA L0204,Y
 LDA L0202,Y
 ORA #&20
 STA L0206,Y
 LDA L00BB
 ADC #7
 STA L00BB
 BNE CBAD0
.CBAC8
 LDA #&F0
 STA L0200,Y
 STA L0204,Y
.CBAD0
 LDA Y1
 AND #7
 CLC
 ADC #&DB
 STA L0209,Y
 LDA L0202,Y
 ORA #&E0
 STA L020A,Y
 LDA L00BA
 STA L020B,Y
 LDA L00BB
 STA L0208,Y
 RTS

\ Called from LL9 part 1

.sub_CBAED

 LDA #0
 LDY #&21
 STA (INF),Y
 SET_NAMETABLE_0        \ Switch the base nametable address to nametable 0
 LDX L002A
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
 STA L022C,X
 STA L0230,X
 STA L0234,X
.CBB1F
 LDA #0
 STA L002A
.CBB23
 RTS

INCLUDE "library/nes/main/subroutine/ptcls2.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"

 FOR I%, &BC51, &BFF9

  EQUB &FF

 NEXT

 EQUW &C007             \ NMI handler

 EQUW &C000             \ Reset handler

 EQUW &C007             \ IRQ/BRK handler

\ ******************************************************************************
\
\ Save bank1.bin
\
\ ******************************************************************************

 PRINT "S.bank1.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank1.bin", CODE%, P%, LOAD%
