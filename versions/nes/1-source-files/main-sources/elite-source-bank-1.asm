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

; Memory locations
ZP                  = &0000
L0002               = &0002
L0003               = &0003
L0004               = &0004
L0005               = &0005
T1                  = &0006
SC                  = &0007
SC_1                = &0008
INWK                = &0009
INWK_1              = &000A
INWK_2              = &000B
INWK_3              = &000C
INWK_4              = &000D
INWK_5              = &000E
INWK_6              = &000F
INWK_7              = &0010
INWK_8              = &0011
INWK_9              = &0012
INWK_10             = &0013
INWK_11             = &0014
INWK_12             = &0015
INWK_13             = &0016
INWK_14             = &0017
INWK_15             = &0018
INWK_16             = &0019
INWK_17             = &001A
INWK_18             = &001B
INWK_19             = &001C
INWK_20             = &001D
INWK_21             = &001E
INWK_22             = &001F
INWK_23             = &0020
INWK_24             = &0021
INWK_25             = &0022
INWK_26             = &0023
INWK_27             = &0024
INWK_28             = &0025
INWK_29             = &0026
INWK_30             = &0027
INWK_31             = &0028
L002A               = &002A
L002B               = &002B
NEWB                = &002D
P                   = &002F
P_1                 = &0030
P_2                 = &0031
XC                  = &0032
YC                  = &003B
QQ17                = &003C
XX2                 = &003D
L003E               = &003E
L003F               = &003F
L0040               = &0040
K4                  = &004B
XX2_15              = &004C
XX16                = &004D
XX16_1              = &004E
XX16_2              = &004F
XX16_3              = &0050
L0051               = &0051
L0052               = &0052
XX16_6              = &0053
L0054               = &0054
XX16_9              = &0056
L0057               = &0057
L0058               = &0058
XX16_12             = &0059
L005A               = &005A
L005B               = &005B
L005C               = &005C
XX0                 = &005F
L0060               = &0060
INF                 = &0061
V                   = &0063
V_1                 = &0064
XX                  = &0065
XX_1                = &0066
YY                  = &0067
YY_1                = &0068
BETA                = &0069
BET1                = &006A
ALP1                = &006E
ALP2                = &006F
ALP2_1              = &0070
XX15                = &0071
Y1                  = &0072
X2                  = &0073
Y2                  = &0074
XX15_4              = &0075
XX15_5              = &0076
XX12                = &0077
XX12_1              = &0078
L0079               = &0079
L007A               = &007A
L007B               = &007B
L007C               = &007C
K                   = &007D
K_1                 = &007E
K_2                 = &007F
K_3                 = &0080
QQ15                = &0082
XX18                = &0088
L0089               = &0089
L008A               = &008A
L008B               = &008B
K6                  = &008C
K6_1                = &008D
L008E               = &008E
XX18_7              = &008F
L0090               = &0090
BET2                = &0091
BET2_1              = &0092
DELT4               = &0094
DELT4_1             = &0095
U                   = &0096
Q                   = &0097
R                   = &0098
S                   = &0099
T                   = &009A
XSAV                = &009B
L009C               = &009C
XX17                = &009D
L009E               = &009E
ZZ                  = &00A0
XX13                = &00A1
TYPE                = &00A3
ALPHA               = &00A4
TGT                 = &00A6
FLAG                = &00A7
CNT                 = &00A8
CNT2                = &00A9
STP                 = &00AA
XX4                 = &00AB
XX20                = &00AC
RAT                 = &00AE
RAT2                = &00AF
widget              = &00B0
L00B1               = &00B1
L00B2               = &00B2
Yx2M1               = &00B3
newzp               = &00B6
L00B9               = &00B9
L00BA               = &00BA
L00BB               = &00BB
L00D2               = &00D2
L00D8               = &00D8
L00E6               = &00E6
L00E9               = &00E9
BANK                = &00F7
L00F9               = &00F9
XX3                 = &0100
XX3_1               = &0101
L0102               = &0102
L0103               = &0103
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
L0374               = &0374
L037E               = &037E
VIEW                = &038E
L039F               = &039F
CASH                = &03A1
GCNT                = &03A7
CRGO                = &03AC
QQ20                = &03AD
BST                 = &03BF
L03DD               = &03DD
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
K2                  = &0459
K2_1                = &045A
K2_2                = &045B
K2_3                = &045C
SWAP                = &047F
QQ29                = &048A
QQ8                 = &049B
QQ18LO              = &04A4
QQ18HI              = &04A5
TOKENLO             = &04A6
TOKENHI             = &04A7
SX                  = &04C8
SY                  = &04DD
SZ                  = &04F2
BUFm1               = &0506
BUF                 = &0507
BUF_1               = &0508
HANGFLAG            = &0561
SXL                 = &05A5
SYL                 = &05BA
SZL                 = &05CF
L05EA               = &05EA
L05EB               = &05EB
L05EC               = &05EC
L05ED               = &05ED
L05EE               = &05EE
L05EF               = &05EF
L05F0               = &05F0
L05F1               = &05F1
L0606               = &0606
PPUCTRL             = &2000
PPUMASK             = &2001
PPUSTATUS           = &2002
OAMADDR             = &2003
OAMDATA             = &2004
PPUSCROLL           = &2005
PPUADDR             = &2006
PPUDATA             = &2007
OAMDMA              = &4014
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
LC53E               = &C53E
LC53F               = &C53F
XX21                = &C540
LCE9E               = &CE9E
NMI                 = &CED5
NAMETABLE0          = &D06D
LD9F7               = &D9F7
LDA18               = &DA18
LDAF8               = &DAF8
LOIN                = &DC0F
LE04A               = &E04A
LE0BA               = &E0BA
LE4F0               = &E4F0
DELAY               = &EBA2
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
LF4AC               = &F4AC
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

    ORG &8000

.pydis_start
    SEI                                           ; 8000: 78          x
    INC LC006                                     ; 8001: EE 06 C0    ...
    JMP LC007                                     ; 8004: 4C 07 C0    L..
    EQUS "@ 5.0"                                  ; 8007: 40 20 35... @ 5

XX1 = &0009 \ INWK
XX19 = &0061    \ INF
X1 = &0071  \ XX15
K3 = &003D  \ XX2

Y = 72

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

.CA8F2
    LDA INWK_31                                   ; A8F2: A5 28       .(
    ORA #&A0                                      ; A8F4: 09 A0       ..
    STA INWK_31                                   ; A8F6: 85 28       .(
.CA8F8
    JMP LCE9E                                     ; A8F8: 4C 9E CE    L..

    EQUB 0, 2                                     ; A8FB: 00 02       ..

; ******************************************************************************
.DOEXP
    LDA L00E9                                     ; A8FD: A5 E9       ..
    BPL CA90A                                     ; A8FF: 10 09       ..
    LDA PPUSTATUS                                 ; A901: AD 02 20    ..
    ASL A                                         ; A904: 0A          .
    BPL CA90A                                     ; A905: 10 03       ..
    JSR NAMETABLE0                                ; A907: 20 6D D0     m.
.CA90A
    LDA INWK_6                                    ; A90A: A5 0F       ..
    STA T                                         ; A90C: 85 9A       ..
    LDA INWK_7                                    ; A90E: A5 10       ..
    CMP #&20 ; ' '                                ; A910: C9 20       .
    BCC CA918                                     ; A912: 90 04       ..
    LDA #&FE                                      ; A914: A9 FE       ..
    BNE CA920                                     ; A916: D0 08       ..
.CA918
    ASL T                                         ; A918: 06 9A       ..
    ROL A                                         ; A91A: 2A          *
    ASL T                                         ; A91B: 06 9A       ..
    ROL A                                         ; A91D: 2A          *
    SEC                                           ; A91E: 38          8
    ROL A                                         ; A91F: 2A          *
.CA920
    STA Q                                         ; A920: 85 97       ..
    LDA L002B                                     ; A922: A5 2B       .+
    ADC #4                                        ; A924: 69 04       i.
    BCS CA8F2                                     ; A926: B0 CA       ..
    STA L002B                                     ; A928: 85 2B       .+
    JSR LF8D8                                     ; A92A: 20 D8 F8     ..
    LDA L00E9                                     ; A92D: A5 E9       ..
    BPL CA93A                                     ; A92F: 10 09       ..
    LDA PPUSTATUS                                 ; A931: AD 02 20    ..
    ASL A                                         ; A934: 0A          .
    BPL CA93A                                     ; A935: 10 03       ..
    JSR NAMETABLE0                                ; A937: 20 6D D0     m.
.CA93A
    LDA P                                         ; A93A: A5 2F       ./
    CMP #&1C                                      ; A93C: C9 1C       ..
    BCC CA944                                     ; A93E: 90 04       ..
    LDA #&FE                                      ; A940: A9 FE       ..
    BNE CA94D                                     ; A942: D0 09       ..
.CA944
    ASL R                                         ; A944: 06 98       ..
    ROL A                                         ; A946: 2A          *
    ASL R                                         ; A947: 06 98       ..
    ROL A                                         ; A949: 2A          *
    ASL R                                         ; A94A: 06 98       ..
    ROL A                                         ; A94C: 2A          *
.CA94D
    STA L040A                                     ; A94D: 8D 0A 04    ...
    LDA INWK_31                                   ; A950: A5 28       .(
    AND #&BF                                      ; A952: 29 BF       ).
    STA INWK_31                                   ; A954: 85 28       .(
    AND #8                                        ; A956: 29 08       ).
    BEQ CA8F8                                     ; A958: F0 9E       ..
    LDA INWK_7                                    ; A95A: A5 10       ..
    BEQ CA967                                     ; A95C: F0 09       ..
    LDY L002B                                     ; A95E: A4 2B       .+
    CPY #&18                                      ; A960: C0 18       ..
    BCS CA967                                     ; A962: B0 03       ..
    JMP CBB24                                     ; A964: 4C 24 BB    L$.

.CA967
    JSR LCE9E                                     ; A967: 20 9E CE     ..
    LDA L040A                                     ; A96A: AD 0A 04    ...
    STA Q                                         ; A96D: 85 97       ..
    LDA L002B                                     ; A96F: A5 2B       .+
    BPL CA975                                     ; A971: 10 02       ..
    EOR #&FF                                      ; A973: 49 FF       I.
.CA975
    LSR A                                         ; A975: 4A          J
    LSR A                                         ; A976: 4A          J
    LSR A                                         ; A977: 4A          J
    LSR A                                         ; A978: 4A          J
    ORA #1                                        ; A979: 09 01       ..
    STA U                                         ; A97B: 85 96       ..
    LDY #7                                        ; A97D: A0 07       ..
    LDA (XX0),Y                                   ; A97F: B1 5F       ._
    STA TGT                                       ; A981: 85 A6       ..
    LDA L0003                                     ; A983: A5 03       ..
    PHA                                           ; A985: 48          H
    LDY #6                                        ; A986: A0 06       ..
.CA988
    LDX #3                                        ; A988: A2 03       ..
.loop_CA98A
    INY                                           ; A98A: C8          .
    LDA L00F9,Y                                   ; A98B: B9 F9 00    ...
    STA XX2,X                                     ; A98E: 95 3D       .=
    DEX                                           ; A990: CA          .
    BPL loop_CA98A                                ; A991: 10 F7       ..
    STY CNT                                       ; A993: 84 A8       ..
    LDY #&25 ; '%'                                ; A995: A0 25       .%
    LDA (INF),Y                                   ; A997: B1 61       .a
    EOR CNT                                       ; A999: 45 A8       E.
    STA L0002                                     ; A99B: 85 02       ..
    INY                                           ; A99D: C8          .
    LDA (INF),Y                                   ; A99E: B1 61       .a
    EOR CNT                                       ; A9A0: 45 A8       E.
    STA L0003                                     ; A9A2: 85 03       ..
    INY                                           ; A9A4: C8          .
    LDA (INF),Y                                   ; A9A5: B1 61       .a
    EOR CNT                                       ; A9A7: 45 A8       E.
    STA L0004                                     ; A9A9: 85 04       ..
    INY                                           ; A9AB: C8          .
    LDA (INF),Y                                   ; A9AC: B1 61       .a
    EOR CNT                                       ; A9AE: 45 A8       E.
    STA L0005                                     ; A9B0: 85 05       ..
    LDY U                                         ; A9B2: A4 96       ..
.CA9B4
    LDA L00E9                                     ; A9B4: A5 E9       ..
    BPL CA9C1                                     ; A9B6: 10 09       ..
    LDA PPUSTATUS                                 ; A9B8: AD 02 20    ..
    ASL A                                         ; A9BB: 0A          .
    BPL CA9C1                                     ; A9BC: 10 03       ..
    JSR NAMETABLE0                                ; A9BE: 20 6D D0     m.
.CA9C1
    CLC                                           ; A9C1: 18          .
    LDA L0002                                     ; A9C2: A5 02       ..
    ROL A                                         ; A9C4: 2A          *
    TAX                                           ; A9C5: AA          .
    ADC L0004                                     ; A9C6: 65 04       e.
    STA L0002                                     ; A9C8: 85 02       ..
    STX L0004                                     ; A9CA: 86 04       ..
    LDA L0003                                     ; A9CC: A5 03       ..
    TAX                                           ; A9CE: AA          .
    ADC L0005                                     ; A9CF: 65 05       e.
    STA L0003                                     ; A9D1: 85 03       ..
    STX L0005                                     ; A9D3: 86 05       ..
    STA ZZ                                        ; A9D5: 85 A0       ..
    LDA L003E                                     ; A9D7: A5 3E       .>
    STA R                                         ; A9D9: 85 98       ..
    LDA XX2                                       ; A9DB: A5 3D       .=
    JSR sub_CAA21                                 ; A9DD: 20 21 AA     !.
    BNE CAA0A                                     ; A9E0: D0 28       .(
    CPX Yx2M1                                     ; A9E2: E4 B3       ..
    BCS CAA0A                                     ; A9E4: B0 24       .$
    STX Y1                                        ; A9E6: 86 72       .r
    LDA L0040                                     ; A9E8: A5 40       .@
    STA R                                         ; A9EA: 85 98       ..
    LDA L003F                                     ; A9EC: A5 3F       .?
    JSR sub_CAA21                                 ; A9EE: 20 21 AA     !.
    BNE CA9F8                                     ; A9F1: D0 05       ..
    LDA Y1                                        ; A9F3: A5 72       .r
    JSR LE4F0                                     ; A9F5: 20 F0 E4     ..
.CA9F8
    DEY                                           ; A9F8: 88          .
    BPL CA9B4                                     ; A9F9: 10 B9       ..
    LDY CNT                                       ; A9FB: A4 A8       ..
    CPY TGT                                       ; A9FD: C4 A6       ..
    BCC CA988                                     ; A9FF: 90 87       ..
    PLA                                           ; AA01: 68          h
    STA L0003                                     ; AA02: 85 03       ..
    LDA L0606                                     ; AA04: AD 06 06    ...
    STA L0005                                     ; AA07: 85 05       ..
    RTS                                           ; AA09: 60          `

.CAA0A
    CLC                                           ; AA0A: 18          .
    LDA L0002                                     ; AA0B: A5 02       ..
    ROL A                                         ; AA0D: 2A          *
    TAX                                           ; AA0E: AA          .
    ADC L0004                                     ; AA0F: 65 04       e.
    STA L0002                                     ; AA11: 85 02       ..
    STX L0004                                     ; AA13: 86 04       ..
    LDA L0003                                     ; AA15: A5 03       ..
    TAX                                           ; AA17: AA          .
    ADC L0005                                     ; AA18: 65 05       e.
    STA L0003                                     ; AA1A: 85 03       ..
    STX L0005                                     ; AA1C: 86 05       ..
    JMP CA9F8                                     ; AA1E: 4C F8 A9    L..

.sub_CAA21
    STA S                                         ; AA21: 85 99       ..
    CLC                                           ; AA23: 18          .
    LDA L0002                                     ; AA24: A5 02       ..
    ROL A                                         ; AA26: 2A          *
    TAX                                           ; AA27: AA          .
    ADC L0004                                     ; AA28: 65 04       e.
    STA L0002                                     ; AA2A: 85 02       ..
    STX L0004                                     ; AA2C: 86 04       ..
    LDA L0003                                     ; AA2E: A5 03       ..
    TAX                                           ; AA30: AA          .
    ADC L0005                                     ; AA31: 65 05       e.
    STA L0003                                     ; AA33: 85 03       ..
    STX L0005                                     ; AA35: 86 05       ..
    ROL A                                         ; AA37: 2A          *
    BCS CAA45                                     ; AA38: B0 0B       ..
    JSR FMLTU                                     ; AA3A: 20 70 F7     p.
    ADC R                                         ; AA3D: 65 98       e.
    TAX                                           ; AA3F: AA          .
    LDA S                                         ; AA40: A5 99       ..
    ADC #0                                        ; AA42: 69 00       i.
    RTS                                           ; AA44: 60          `

.CAA45
    JSR FMLTU                                     ; AA45: 20 70 F7     p.
    STA T                                         ; AA48: 85 9A       ..
    LDA R                                         ; AA4A: A5 98       ..
    SBC T                                         ; AA4C: E5 9A       ..
    TAX                                           ; AA4E: AA          .
    LDA S                                         ; AA4F: A5 99       ..
    SBC #0                                        ; AA51: E9 00       ..
    RTS                                           ; AA53: 60          `

; ******************************************************************************
.PL2
    RTS                                           ; AA54: 60          `

; ******************************************************************************
.PLANET
    LDA INWK_8                                    ; AA55: A5 11       ..
    CMP #&30 ; '0'                                ; AA57: C9 30       .0
    BCS PL2                                       ; AA59: B0 F9       ..
    ORA INWK_7                                    ; AA5B: 05 10       ..
    BEQ PL2                                       ; AA5D: F0 F5       ..
    JSR PROJ                                      ; AA5F: 20 C1 F4     ..
    BCS PL2                                       ; AA62: B0 F0       ..
    LDA #&60 ; '`'                                ; AA64: A9 60       .`
    STA P_1                                       ; AA66: 85 30       .0
    LDA #0                                        ; AA68: A9 00       ..
    STA P                                         ; AA6A: 85 2F       ./
    JSR DVID3B2                                   ; AA6C: 20 62 F9     b.
    LDA K_1                                       ; AA6F: A5 7E       .~
    BEQ CAA77                                     ; AA71: F0 04       ..
    LDA #&F8                                      ; AA73: A9 F8       ..
    STA K                                         ; AA75: 85 7D       .}
.CAA77
    LDA TYPE                                      ; AA77: A5 A3       ..
    LSR A                                         ; AA79: 4A          J
    BCC PL9                                       ; AA7A: 90 03       ..
    JMP SUN                                       ; AA7C: 4C 25 AC    L%.

; ******************************************************************************
.PL9
    JSR CIRCLE                                    ; AA7F: 20 7B AF     {.
    BCS PL20                                      ; AA82: B0 04       ..
    LDA K_1                                       ; AA84: A5 7E       .~
    BEQ CAA89                                     ; AA86: F0 01       ..
.PL20
    RTS                                           ; AA88: 60          `

.CAA89
    LDA TYPE                                      ; AA89: A5 A3       ..
    CMP #&80                                      ; AA8B: C9 80       ..
    BNE PL26                                      ; AA8D: D0 3E       .>
; ******************************************************************************
.PL9_2
    LDA K                                         ; AA8F: A5 7D       .}
    CMP #6                                        ; AA91: C9 06       ..
    BCC PL20                                      ; AA93: 90 F3       ..
    LDA INWK_14                                   ; AA95: A5 17       ..
    EOR #&80                                      ; AA97: 49 80       I.
    STA P                                         ; AA99: 85 2F       ./
    LDA INWK_20                                   ; AA9B: A5 1D       ..
    JSR PLS4                                      ; AA9D: 20 D4 B0     ..
    LDX #9                                        ; AAA0: A2 09       ..
    JSR PLS1                                      ; AAA2: 20 27 AB     '.
    STA K2                                        ; AAA5: 8D 59 04    .Y.
    STY XX16                                      ; AAA8: 84 4D       .M
    JSR PLS1                                      ; AAAA: 20 27 AB     '.
    STA K2_1                                      ; AAAD: 8D 5A 04    .Z.
    STY XX16_1                                    ; AAB0: 84 4E       .N
    LDX #&0F                                      ; AAB2: A2 0F       ..
    JSR PLS5                                      ; AAB4: 20 E4 B0     ..
    JSR PLS2                                      ; AAB7: 20 45 AB     E.
    LDA INWK_14                                   ; AABA: A5 17       ..
    EOR #&80                                      ; AABC: 49 80       I.
    STA P                                         ; AABE: 85 2F       ./
    LDA INWK_26                                   ; AAC0: A5 23       .#
    JSR PLS4                                      ; AAC2: 20 D4 B0     ..
    LDX #&15                                      ; AAC5: A2 15       ..
    JSR PLS5                                      ; AAC7: 20 E4 B0     ..
    JMP PLS2                                      ; AACA: 4C 45 AB    LE.

; ******************************************************************************
.PL26
    LDA INWK_20                                   ; AACD: A5 1D       ..
    BMI PL20                                      ; AACF: 30 B7       0.
    LDX #&0F                                      ; AAD1: A2 0F       ..
    JSR PLS3                                      ; AAD3: 20 B3 B0     ..
    CLC                                           ; AAD6: 18          .
    ADC XX2                                       ; AAD7: 65 3D       e=
    STA XX2                                       ; AAD9: 85 3D       .=
    TYA                                           ; AADB: 98          .
    ADC L003E                                     ; AADC: 65 3E       e>
    STA L003E                                     ; AADE: 85 3E       .>
    JSR PLS3                                      ; AAE0: 20 B3 B0     ..
    STA P                                         ; AAE3: 85 2F       ./
    LDA K4                                        ; AAE5: A5 4B       .K
    SEC                                           ; AAE7: 38          8
    SBC P                                         ; AAE8: E5 2F       ./
    STA K4                                        ; AAEA: 85 4B       .K
    STY P                                         ; AAEC: 84 2F       ./
    LDA XX2_15                                    ; AAEE: A5 4C       .L
    SBC P                                         ; AAF0: E5 2F       ./
    STA XX2_15                                    ; AAF2: 85 4C       .L
    LDX #9                                        ; AAF4: A2 09       ..
    JSR PLS1                                      ; AAF6: 20 27 AB     '.
    LSR A                                         ; AAF9: 4A          J
    STA K2                                        ; AAFA: 8D 59 04    .Y.
    STY XX16                                      ; AAFD: 84 4D       .M
    JSR PLS1                                      ; AAFF: 20 27 AB     '.
    LSR A                                         ; AB02: 4A          J
    STA K2_1                                      ; AB03: 8D 5A 04    .Z.
    STY XX16_1                                    ; AB06: 84 4E       .N
    LDX #&15                                      ; AB08: A2 15       ..
    JSR PLS1                                      ; AB0A: 20 27 AB     '.
    LSR A                                         ; AB0D: 4A          J
    STA K2_2                                      ; AB0E: 8D 5B 04    .[.
    STY XX16_2                                    ; AB11: 84 4F       .O
    JSR PLS1                                      ; AB13: 20 27 AB     '.
    LSR A                                         ; AB16: 4A          J
    STA K2_3                                      ; AB17: 8D 5C 04    .\.
    STY XX16_3                                    ; AB1A: 84 50       .P
    LDA #&40 ; '@'                                ; AB1C: A9 40       .@
    STA TGT                                       ; AB1E: 85 A6       ..
    LDA #0                                        ; AB20: A9 00       ..
    STA CNT2                                      ; AB22: 85 A9       ..
    JMP PLS22                                     ; AB24: 4C 49 AB    LI.

; ******************************************************************************
.PLS1
    LDA INWK,X                                    ; AB27: B5 09       ..
    STA P                                         ; AB29: 85 2F       ./
    LDA INWK_1,X                                  ; AB2B: B5 0A       ..
    AND #&7F                                      ; AB2D: 29 7F       ).
    STA P_1                                       ; AB2F: 85 30       .0
    LDA INWK_1,X                                  ; AB31: B5 0A       ..
    AND #&80                                      ; AB33: 29 80       ).
    JSR DVID3B2                                   ; AB35: 20 62 F9     b.
    LDA K                                         ; AB38: A5 7D       .}
    LDY K_1                                       ; AB3A: A4 7E       .~
    BEQ CAB40                                     ; AB3C: F0 02       ..
    LDA #&FE                                      ; AB3E: A9 FE       ..
.CAB40
    LDY K_3                                       ; AB40: A4 80       ..
    INX                                           ; AB42: E8          .
    INX                                           ; AB43: E8          .
    RTS                                           ; AB44: 60          `

; ******************************************************************************
.PLS2
    LDA #&1F                                      ; AB45: A9 1F       ..
    STA TGT                                       ; AB47: 85 A6       ..
; ******************************************************************************
.PLS22
    LDX #0                                        ; AB49: A2 00       ..
    STX CNT                                       ; AB4B: 86 A8       ..
    DEX                                           ; AB4D: CA          .
    STX FLAG                                      ; AB4E: 86 A7       ..
.CAB50
    LDA CNT2                                      ; AB50: A5 A9       ..
    AND #&1F                                      ; AB52: 29 1F       ).
    TAX                                           ; AB54: AA          .
    LDA SNE,X                                     ; AB55: BD 00 C5    ...
    STA Q                                         ; AB58: 85 97       ..
    LDA K2_2                                      ; AB5A: AD 5B 04    .[.
    JSR FMLTU                                     ; AB5D: 20 70 F7     p.
    STA R                                         ; AB60: 85 98       ..
    LDA K2_3                                      ; AB62: AD 5C 04    .\.
    JSR FMLTU                                     ; AB65: 20 70 F7     p.
    STA K                                         ; AB68: 85 7D       .}
    LDX CNT2                                      ; AB6A: A6 A9       ..
    CPX #&21 ; '!'                                ; AB6C: E0 21       .!
    LDA #0                                        ; AB6E: A9 00       ..
    ROR A                                         ; AB70: 6A          j
    STA L0052                                     ; AB71: 85 52       .R
    LDA CNT2                                      ; AB73: A5 A9       ..
    CLC                                           ; AB75: 18          .
    ADC #&10                                      ; AB76: 69 10       i.
    AND #&1F                                      ; AB78: 29 1F       ).
    TAX                                           ; AB7A: AA          .
    LDA SNE,X                                     ; AB7B: BD 00 C5    ...
    STA Q                                         ; AB7E: 85 97       ..
    LDA K2_1                                      ; AB80: AD 5A 04    .Z.
    JSR FMLTU                                     ; AB83: 20 70 F7     p.
    STA K_2                                       ; AB86: 85 7F       ..
    LDA K2                                        ; AB88: AD 59 04    .Y.
    JSR FMLTU                                     ; AB8B: 20 70 F7     p.
    STA P                                         ; AB8E: 85 2F       ./
    LDA CNT2                                      ; AB90: A5 A9       ..
    ADC #&0F                                      ; AB92: 69 0F       i.
    AND #&3F ; '?'                                ; AB94: 29 3F       )?
    CMP #&21 ; '!'                                ; AB96: C9 21       .!
    LDA #0                                        ; AB98: A9 00       ..
    ROR A                                         ; AB9A: 6A          j
    STA L0051                                     ; AB9B: 85 51       .Q
    LDA L0052                                     ; AB9D: A5 52       .R
    EOR XX16_2                                    ; AB9F: 45 4F       EO
    STA S                                         ; ABA1: 85 99       ..
    LDA L0051                                     ; ABA3: A5 51       .Q
    EOR XX16                                      ; ABA5: 45 4D       EM
    JSR ADD                                       ; ABA7: 20 72 F8     r.
    STA T                                         ; ABAA: 85 9A       ..
    BPL CABBD                                     ; ABAC: 10 0F       ..
    TXA                                           ; ABAE: 8A          .
    EOR #&FF                                      ; ABAF: 49 FF       I.
    CLC                                           ; ABB1: 18          .
    ADC #1                                        ; ABB2: 69 01       i.
    TAX                                           ; ABB4: AA          .
    LDA T                                         ; ABB5: A5 9A       ..
    EOR #&7F                                      ; ABB7: 49 7F       I.
    ADC #0                                        ; ABB9: 69 00       i.
    STA T                                         ; ABBB: 85 9A       ..
.CABBD
    LDA L00E9                                     ; ABBD: A5 E9       ..
    BPL CABCA                                     ; ABBF: 10 09       ..
    LDA PPUSTATUS                                 ; ABC1: AD 02 20    ..
    ASL A                                         ; ABC4: 0A          .
    BPL CABCA                                     ; ABC5: 10 03       ..
    JSR NAMETABLE0                                ; ABC7: 20 6D D0     m.
.CABCA
    TXA                                           ; ABCA: 8A          .
    ADC XX2                                       ; ABCB: 65 3D       e=
    STA K6                                        ; ABCD: 85 8C       ..
    LDA T                                         ; ABCF: A5 9A       ..
    ADC L003E                                     ; ABD1: 65 3E       e>
    STA K6_1                                      ; ABD3: 85 8D       ..
    LDA K                                         ; ABD5: A5 7D       .}
    STA R                                         ; ABD7: 85 98       ..
    LDA L0052                                     ; ABD9: A5 52       .R
    EOR XX16_3                                    ; ABDB: 45 50       EP
    STA S                                         ; ABDD: 85 99       ..
    LDA K_2                                       ; ABDF: A5 7F       ..
    STA P                                         ; ABE1: 85 2F       ./
    LDA L0051                                     ; ABE3: A5 51       .Q
    EOR XX16_1                                    ; ABE5: 45 4E       EN
    JSR ADD                                       ; ABE7: 20 72 F8     r.
    EOR #&80                                      ; ABEA: 49 80       I.
    STA T                                         ; ABEC: 85 9A       ..
    BPL CABFF                                     ; ABEE: 10 0F       ..
    TXA                                           ; ABF0: 8A          .
    EOR #&FF                                      ; ABF1: 49 FF       I.
    CLC                                           ; ABF3: 18          .
    ADC #1                                        ; ABF4: 69 01       i.
    TAX                                           ; ABF6: AA          .
    LDA T                                         ; ABF7: A5 9A       ..
    EOR #&7F                                      ; ABF9: 49 7F       I.
    ADC #0                                        ; ABFB: 69 00       i.
    STA T                                         ; ABFD: 85 9A       ..
.CABFF
    JSR BLINE                                     ; ABFF: 20 3B B1     ;.
    CMP TGT                                       ; AC02: C5 A6       ..
    BEQ CAC08                                     ; AC04: F0 02       ..
    BCS CAC14                                     ; AC06: B0 0C       ..
.CAC08
    LDA CNT2                                      ; AC08: A5 A9       ..
    CLC                                           ; AC0A: 18          .
    ADC STP                                       ; AC0B: 65 AA       e.
    AND #&3F ; '?'                                ; AC0D: 29 3F       )?
    STA CNT2                                      ; AC0F: 85 A9       ..
    JMP CAB50                                     ; AC11: 4C 50 AB    LP.

.CAC14
    RTS                                           ; AC14: 60          `

.PLF3
    TXA                                           ; AC15: 8A          .
    EOR #&FF                                      ; AC16: 49 FF       I.
    CLC                                           ; AC18: 18          .
    ADC #1                                        ; AC19: 69 01       i.
    CMP K                                         ; AC1B: C5 7D       .}
    BCS CAC14                                     ; AC1D: B0 F5       ..
    TAX                                           ; AC1F: AA          .
.CAC20
    LDA #&FF                                      ; AC20: A9 FF       ..
    JMP CAC6C                                     ; AC22: 4C 6C AC    Ll.

; ******************************************************************************
.SUN
    LDA L03F1                                     ; AC25: AD F1 03    ...
    STA L0002                                     ; AC28: 85 02       ..
    JSR CHKON                                     ; AC2A: 20 77 B0     w.
    BCS CAC14                                     ; AC2D: B0 E5       ..
    LDA #0                                        ; AC2F: A9 00       ..
    LDX K                                         ; AC31: A6 7D       .}
    BEQ CAC14                                     ; AC33: F0 DF       ..
    CPX #&60 ; '`'                                ; AC35: E0 60       .`
    ROL A                                         ; AC37: 2A          *
    CPX #&28 ; '('                                ; AC38: E0 28       .(
    ROL A                                         ; AC3A: 2A          *
    CPX #&10                                      ; AC3B: E0 10       ..
    ROL A                                         ; AC3D: 2A          *
    STA CNT                                       ; AC3E: 85 A8       ..
    LDA Yx2M1                                     ; AC40: A5 B3       ..
    LDX P_2                                       ; AC42: A6 31       .1
    BNE CAC50                                     ; AC44: D0 0A       ..
    CMP P_1                                       ; AC46: C5 30       .0
    BCC CAC50                                     ; AC48: 90 06       ..
    LDA P_1                                       ; AC4A: A5 30       .0
    BNE CAC50                                     ; AC4C: D0 02       ..
    LDA #1                                        ; AC4E: A9 01       ..
.CAC50
    STA TGT                                       ; AC50: 85 A6       ..
    LDA Yx2M1                                     ; AC52: A5 B3       ..
    SEC                                           ; AC54: 38          8
    SBC K4                                        ; AC55: E5 4B       .K
    TAX                                           ; AC57: AA          .
    LDA #0                                        ; AC58: A9 00       ..
    SBC XX2_15                                    ; AC5A: E5 4C       .L
    BMI PLF3                                      ; AC5C: 30 B7       0.
    BNE CAC68                                     ; AC5E: D0 08       ..
    INX                                           ; AC60: E8          .
    DEX                                           ; AC61: CA          .
    BEQ CAC20                                     ; AC62: F0 BC       ..
    CPX K                                         ; AC64: E4 7D       .}
    BCC CAC6C                                     ; AC66: 90 04       ..
.CAC68
    LDX K                                         ; AC68: A6 7D       .}
    LDA #0                                        ; AC6A: A9 00       ..
.CAC6C
    STX V                                         ; AC6C: 86 63       .c
    STA V_1                                       ; AC6E: 85 64       .d
    LDA K                                         ; AC70: A5 7D       .}
    JSR SQUA2                                     ; AC72: 20 0E F7     ..
    STA K2_1                                      ; AC75: 8D 5A 04    .Z.
    LDA P                                         ; AC78: A5 2F       ./
    STA K2                                        ; AC7A: 8D 59 04    .Y.
    LDA XX2                                       ; AC7D: A5 3D       .=
    STA YY                                        ; AC7F: 85 67       .g
    LDA L003E                                     ; AC81: A5 3E       .>
    STA YY_1                                      ; AC83: 85 68       .h
    LDY TGT                                       ; AC85: A4 A6       ..
    LDA #0                                        ; AC87: A9 00       ..
    STA L05EB                                     ; AC89: 8D EB 05    ...
    STA L05EC                                     ; AC8C: 8D EC 05    ...
    STA L05ED                                     ; AC8F: 8D ED 05    ...
    STA L05EE                                     ; AC92: 8D EE 05    ...
    STA L05EF                                     ; AC95: 8D EF 05    ...
    STA L05F0                                     ; AC98: 8D F0 05    ...
    STA L05F1                                     ; AC9B: 8D F1 05    ...
    TYA                                           ; AC9E: 98          .
    TAX                                           ; AC9F: AA          .
    AND #&F8                                      ; ACA0: 29 F8       ).
    TAY                                           ; ACA2: A8          .
    LDA V_1                                       ; ACA3: A5 64       .d
    BNE CAD1D                                     ; ACA5: D0 76       .v
    TXA                                           ; ACA7: 8A          .
    AND #7                                        ; ACA8: 29 07       ).
    BEQ CAD04                                     ; ACAA: F0 58       .X
    CMP #2                                        ; ACAC: C9 02       ..
    BCC CACFA                                     ; ACAE: 90 4A       .J
    BEQ CACF0                                     ; ACB0: F0 3E       .>
    CMP #4                                        ; ACB2: C9 04       ..
    BCC CACE6                                     ; ACB4: 90 30       .0
    BEQ CACDC                                     ; ACB6: F0 24       .$
    CMP #6                                        ; ACB8: C9 06       ..
    BCC CACD2                                     ; ACBA: 90 16       ..
    BEQ CACC8                                     ; ACBC: F0 0A       ..
.CACBE
    JSR sub_CAF35                                 ; ACBE: 20 35 AF     5.
    STA L05F1                                     ; ACC1: 8D F1 05    ...
    DEC V                                         ; ACC4: C6 63       .c
    BEQ CAD2C                                     ; ACC6: F0 64       .d
.CACC8
    JSR sub_CAF35                                 ; ACC8: 20 35 AF     5.
    STA L05F0                                     ; ACCB: 8D F0 05    ...
    DEC V                                         ; ACCE: C6 63       .c
    BEQ CAD3B                                     ; ACD0: F0 69       .i
.CACD2
    JSR sub_CAF35                                 ; ACD2: 20 35 AF     5.
    STA L05EF                                     ; ACD5: 8D EF 05    ...
    DEC V                                         ; ACD8: C6 63       .c
    BEQ CAD4A                                     ; ACDA: F0 6E       .n
.CACDC
    JSR sub_CAF35                                 ; ACDC: 20 35 AF     5.
    STA L05EE                                     ; ACDF: 8D EE 05    ...
    DEC V                                         ; ACE2: C6 63       .c
    BEQ CAD59                                     ; ACE4: F0 73       .s
.CACE6
    JSR sub_CAF35                                 ; ACE6: 20 35 AF     5.
    STA L05ED                                     ; ACE9: 8D ED 05    ...
    DEC V                                         ; ACEC: C6 63       .c
    BEQ CAD68                                     ; ACEE: F0 78       .x
.CACF0
    JSR sub_CAF35                                 ; ACF0: 20 35 AF     5.
    STA L05EC                                     ; ACF3: 8D EC 05    ...
    DEC V                                         ; ACF6: C6 63       .c
    BEQ CAD77                                     ; ACF8: F0 7D       .}
.CACFA
    JSR sub_CAF35                                 ; ACFA: 20 35 AF     5.
    STA L05EB                                     ; ACFD: 8D EB 05    ...
    DEC V                                         ; AD00: C6 63       .c
    BEQ CAD1B                                     ; AD02: F0 17       ..
.CAD04
    JSR sub_CAF35                                 ; AD04: 20 35 AF     5.
    STA L05EA                                     ; AD07: 8D EA 05    ...
    DEC V                                         ; AD0A: C6 63       .c
    BEQ CAD19                                     ; AD0C: F0 0B       ..
    JSR CADC6                                     ; AD0E: 20 C6 AD     ..
    TYA                                           ; AD11: 98          .
    SEC                                           ; AD12: 38          8
    SBC #8                                        ; AD13: E9 08       ..
    TAY                                           ; AD15: A8          .
    BCS CACBE                                     ; AD16: B0 A6       ..
    RTS                                           ; AD18: 60          `

.CAD19
    BEQ CAD95                                     ; AD19: F0 7A       .z
.CAD1B
    BEQ CAD86                                     ; AD1B: F0 69       .i
.CAD1D
    JSR sub_CAF35                                 ; AD1D: 20 35 AF     5.
    STA L05F1                                     ; AD20: 8D F1 05    ...
    LDX V                                         ; AD23: A6 63       .c
    INX                                           ; AD25: E8          .
    STX V                                         ; AD26: 86 63       .c
    CPX K                                         ; AD28: E4 7D       .}
    BCS CADA3                                     ; AD2A: B0 77       .w
.CAD2C
    JSR sub_CAF35                                 ; AD2C: 20 35 AF     5.
    STA L05F0                                     ; AD2F: 8D F0 05    ...
    LDX V                                         ; AD32: A6 63       .c
    INX                                           ; AD34: E8          .
    STX V                                         ; AD35: 86 63       .c
    CPX K                                         ; AD37: E4 7D       .}
    BCS CADA8                                     ; AD39: B0 6D       .m
.CAD3B
    JSR sub_CAF35                                 ; AD3B: 20 35 AF     5.
    STA L05EF                                     ; AD3E: 8D EF 05    ...
    LDX V                                         ; AD41: A6 63       .c
    INX                                           ; AD43: E8          .
    STX V                                         ; AD44: 86 63       .c
    CPX K                                         ; AD46: E4 7D       .}
    BCS CADAD                                     ; AD48: B0 63       .c
.CAD4A
    JSR sub_CAF35                                 ; AD4A: 20 35 AF     5.
    STA L05EE                                     ; AD4D: 8D EE 05    ...
    LDX V                                         ; AD50: A6 63       .c
    INX                                           ; AD52: E8          .
    STX V                                         ; AD53: 86 63       .c
    CPX K                                         ; AD55: E4 7D       .}
    BCS CADB2                                     ; AD57: B0 59       .Y
.CAD59
    JSR sub_CAF35                                 ; AD59: 20 35 AF     5.
    STA L05ED                                     ; AD5C: 8D ED 05    ...
    LDX V                                         ; AD5F: A6 63       .c
    INX                                           ; AD61: E8          .
    STX V                                         ; AD62: 86 63       .c
    CPX K                                         ; AD64: E4 7D       .}
    BCS CADB7                                     ; AD66: B0 4F       .O
.CAD68
    JSR sub_CAF35                                 ; AD68: 20 35 AF     5.
    STA L05EC                                     ; AD6B: 8D EC 05    ...
    LDX V                                         ; AD6E: A6 63       .c
    INX                                           ; AD70: E8          .
    STX V                                         ; AD71: 86 63       .c
    CPX K                                         ; AD73: E4 7D       .}
    BCS CADBC                                     ; AD75: B0 45       .E
.CAD77
    JSR sub_CAF35                                 ; AD77: 20 35 AF     5.
    STA L05EB                                     ; AD7A: 8D EB 05    ...
    LDX V                                         ; AD7D: A6 63       .c
    INX                                           ; AD7F: E8          .
    STX V                                         ; AD80: 86 63       .c
    CPX K                                         ; AD82: E4 7D       .}
    BCS CADC1                                     ; AD84: B0 3B       .;
.CAD86
    JSR sub_CAF35                                 ; AD86: 20 35 AF     5.
    STA L05EA                                     ; AD89: 8D EA 05    ...
    LDX V                                         ; AD8C: A6 63       .c
    INX                                           ; AD8E: E8          .
    STX V                                         ; AD8F: 86 63       .c
    CPX K                                         ; AD91: E4 7D       .}
    BCS CADC6                                     ; AD93: B0 31       .1
.CAD95
    JSR CADC6                                     ; AD95: 20 C6 AD     ..
    TYA                                           ; AD98: 98          .
    SEC                                           ; AD99: 38          8
    SBC #8                                        ; AD9A: E9 08       ..
    TAY                                           ; AD9C: A8          .
    BCC CADA2                                     ; AD9D: 90 03       ..
    JMP CAD1D                                     ; AD9F: 4C 1D AD    L..

.CADA2
    RTS                                           ; ADA2: 60          `

.CADA3
    LDA #0                                        ; ADA3: A9 00       ..
    STA L05F0                                     ; ADA5: 8D F0 05    ...
.CADA8
    LDA #0                                        ; ADA8: A9 00       ..
    STA L05EF                                     ; ADAA: 8D EF 05    ...
.CADAD
    LDA #0                                        ; ADAD: A9 00       ..
    STA L05EE                                     ; ADAF: 8D EE 05    ...
.CADB2
    LDA #0                                        ; ADB2: A9 00       ..
    STA L05ED                                     ; ADB4: 8D ED 05    ...
.CADB7
    LDA #0                                        ; ADB7: A9 00       ..
    STA L05EC                                     ; ADB9: 8D EC 05    ...
.CADBC
    LDA #0                                        ; ADBC: A9 00       ..
    STA L05EB                                     ; ADBE: 8D EB 05    ...
.CADC1
    LDA #0                                        ; ADC1: A9 00       ..
    STA L05EA                                     ; ADC3: 8D EA 05    ...
.CADC6
    LDA L05EA                                     ; ADC6: AD EA 05    ...
    CMP L05EB                                     ; ADC9: CD EB 05    ...
    BCC CADD1                                     ; ADCC: 90 03       ..
    LDA L05EB                                     ; ADCE: AD EB 05    ...
.CADD1
    CMP L05EC                                     ; ADD1: CD EC 05    ...
    BCC CADD9                                     ; ADD4: 90 03       ..
    LDA L05EC                                     ; ADD6: AD EC 05    ...
.CADD9
    CMP L05ED                                     ; ADD9: CD ED 05    ...
    BCC CADE1                                     ; ADDC: 90 03       ..
    LDA L05EC                                     ; ADDE: AD EC 05    ...
.CADE1
    CMP L05EE                                     ; ADE1: CD EE 05    ...
    BCC CADE9                                     ; ADE4: 90 03       ..
    LDA L05EE                                     ; ADE6: AD EE 05    ...
.CADE9
    CMP L05EF                                     ; ADE9: CD EF 05    ...
    BCC CADF1                                     ; ADEC: 90 03       ..
    LDA L05EF                                     ; ADEE: AD EF 05    ...
.CADF1
    CMP L05F0                                     ; ADF1: CD F0 05    ...
    BCC CADF9                                     ; ADF4: 90 03       ..
    LDA L05F0                                     ; ADF6: AD F0 05    ...
.CADF9
    CMP L05F1                                     ; ADF9: CD F1 05    ...
    BCC CAE03                                     ; ADFC: 90 05       ..
    LDA L05F1                                     ; ADFE: AD F1 05    ...
    BEQ CAE29                                     ; AE01: F0 26       .&
.CAE03
    JSR EDGES                                     ; AE03: 20 14 B0     ..
    BCS CAE29                                     ; AE06: B0 21       .!
    LDA X2                                        ; AE08: A5 73       .s
    AND #&F8                                      ; AE0A: 29 F8       ).
    STA P_1                                       ; AE0C: 85 30       .0
    LDA XX15                                      ; AE0E: A5 71       .q
    ADC #7                                        ; AE10: 69 07       i.
    BCS CAE29                                     ; AE12: B0 15       ..
    AND #&F8                                      ; AE14: 29 F8       ).
    CMP P_1                                       ; AE16: C5 30       .0
    BCS CAE29                                     ; AE18: B0 0F       ..
    STA P                                         ; AE1A: 85 2F       ./
    CMP #&F8                                      ; AE1C: C9 F8       ..
    BCS CAE26                                     ; AE1E: B0 06       ..
    JSR sub_CAEE8                                 ; AE20: 20 E8 AE     ..
    JSR LE04A                                     ; AE23: 20 4A E0     J.
.CAE26
    JMP CAE9B                                     ; AE26: 4C 9B AE    L..

.CAE29
    LDA L00E9                                     ; AE29: A5 E9       ..
    BPL CAE36                                     ; AE2B: 10 09       ..
    LDA PPUSTATUS                                 ; AE2D: AD 02 20    ..
    ASL A                                         ; AE30: 0A          .
    BPL CAE36                                     ; AE31: 10 03       ..
    JSR NAMETABLE0                                ; AE33: 20 6D D0     m.
.CAE36
    TYA                                           ; AE36: 98          .
    CLC                                           ; AE37: 18          .
    ADC #7                                        ; AE38: 69 07       i.
    TAY                                           ; AE3A: A8          .
    LDA L05F1                                     ; AE3B: AD F1 05    ...
    JSR sub_CB012                                 ; AE3E: 20 12 B0     ..
    BCS CAE46                                     ; AE41: B0 03       ..
    JSR LE0BA                                     ; AE43: 20 BA E0     ..
.CAE46
    DEY                                           ; AE46: 88          .
    LDA L05F0                                     ; AE47: AD F0 05    ...
    JSR sub_CB012                                 ; AE4A: 20 12 B0     ..
    BCS CAE52                                     ; AE4D: B0 03       ..
    JSR LE0BA                                     ; AE4F: 20 BA E0     ..
.CAE52
    DEY                                           ; AE52: 88          .
    LDA L05EF                                     ; AE53: AD EF 05    ...
    JSR sub_CB012                                 ; AE56: 20 12 B0     ..
    BCS CAE5E                                     ; AE59: B0 03       ..
    JSR LE0BA                                     ; AE5B: 20 BA E0     ..
.CAE5E
    DEY                                           ; AE5E: 88          .
    LDA L05EE                                     ; AE5F: AD EE 05    ...
    JSR sub_CB012                                 ; AE62: 20 12 B0     ..
    BCS CAE6A                                     ; AE65: B0 03       ..
    JSR LE0BA                                     ; AE67: 20 BA E0     ..
.CAE6A
    DEY                                           ; AE6A: 88          .
    LDA L05ED                                     ; AE6B: AD ED 05    ...
    JSR sub_CB012                                 ; AE6E: 20 12 B0     ..
    BCS CAE76                                     ; AE71: B0 03       ..
    JSR LE0BA                                     ; AE73: 20 BA E0     ..
.CAE76
    DEY                                           ; AE76: 88          .
    LDA L05EC                                     ; AE77: AD EC 05    ...
    JSR sub_CB012                                 ; AE7A: 20 12 B0     ..
    BCS CAE82                                     ; AE7D: B0 03       ..
    JSR LE0BA                                     ; AE7F: 20 BA E0     ..
.CAE82
    DEY                                           ; AE82: 88          .
    LDA L05EB                                     ; AE83: AD EB 05    ...
    JSR sub_CB012                                 ; AE86: 20 12 B0     ..
    BCS CAE8E                                     ; AE89: B0 03       ..
    JSR LE0BA                                     ; AE8B: 20 BA E0     ..
.CAE8E
    DEY                                           ; AE8E: 88          .
    LDA L05EA                                     ; AE8F: AD EA 05    ...
    JSR sub_CB012                                 ; AE92: 20 12 B0     ..
    BCS CAE9A                                     ; AE95: B0 03       ..
    JMP LE0BA                                     ; AE97: 4C BA E0    L..

.CAE9A
    RTS                                           ; AE9A: 60          `

.CAE9B
    LDA L00E9                                     ; AE9B: A5 E9       ..
    BPL CAEA8                                     ; AE9D: 10 09       ..
    LDA PPUSTATUS                                 ; AE9F: AD 02 20    ..
    ASL A                                         ; AEA2: 0A          .
    BPL CAEA8                                     ; AEA3: 10 03       ..
    JSR NAMETABLE0                                ; AEA5: 20 6D D0     m.
.CAEA8
    LDX P                                         ; AEA8: A6 2F       ./
    BEQ CAE9A                                     ; AEAA: F0 EE       ..
    TYA                                           ; AEAC: 98          .
    CLC                                           ; AEAD: 18          .
    ADC #7                                        ; AEAE: 69 07       i.
    TAY                                           ; AEB0: A8          .
    LDA L05F1                                     ; AEB1: AD F1 05    ...
    JSR CB039                                     ; AEB4: 20 39 B0     9.
    DEY                                           ; AEB7: 88          .
    LDA L05F0                                     ; AEB8: AD F0 05    ...
    JSR CB039                                     ; AEBB: 20 39 B0     9.
    DEY                                           ; AEBE: 88          .
    LDA L05EF                                     ; AEBF: AD EF 05    ...
    JSR CB039                                     ; AEC2: 20 39 B0     9.
    DEY                                           ; AEC5: 88          .
    LDA L05EE                                     ; AEC6: AD EE 05    ...
    JSR CB039                                     ; AEC9: 20 39 B0     9.
    DEY                                           ; AECC: 88          .
    LDA L05ED                                     ; AECD: AD ED 05    ...
    JSR CB039                                     ; AED0: 20 39 B0     9.
    DEY                                           ; AED3: 88          .
    LDA L05EC                                     ; AED4: AD EC 05    ...
    JSR CB039                                     ; AED7: 20 39 B0     9.
    DEY                                           ; AEDA: 88          .
    LDA L05EB                                     ; AEDB: AD EB 05    ...
    JSR CB039                                     ; AEDE: 20 39 B0     9.
    DEY                                           ; AEE1: 88          .
    LDA L05EA                                     ; AEE2: AD EA 05    ...
    JMP CB039                                     ; AEE5: 4C 39 B0    L9.

.sub_CAEE8
    LDA L00E9                                     ; AEE8: A5 E9       ..
    BPL CAEF5                                     ; AEEA: 10 09       ..
    LDA PPUSTATUS                                 ; AEEC: AD 02 20    ..
    ASL A                                         ; AEEF: 0A          .
    BPL CAEF5                                     ; AEF0: 10 03       ..
    JSR NAMETABLE0                                ; AEF2: 20 6D D0     m.
.CAEF5
    LDX P_1                                       ; AEF5: A6 30       .0
    STX XX15                                      ; AEF7: 86 71       .q
    TYA                                           ; AEF9: 98          .
    CLC                                           ; AEFA: 18          .
    ADC #7                                        ; AEFB: 69 07       i.
    TAY                                           ; AEFD: A8          .
    LDA L05F1                                     ; AEFE: AD F1 05    ...
    JSR CB05D                                     ; AF01: 20 5D B0     ].
    DEY                                           ; AF04: 88          .
    LDA L05F0                                     ; AF05: AD F0 05    ...
    JSR CB05D                                     ; AF08: 20 5D B0     ].
    DEY                                           ; AF0B: 88          .
    LDA L05EF                                     ; AF0C: AD EF 05    ...
    JSR CB05D                                     ; AF0F: 20 5D B0     ].
    DEY                                           ; AF12: 88          .
    LDA L05EE                                     ; AF13: AD EE 05    ...
    JSR CB05D                                     ; AF16: 20 5D B0     ].
    DEY                                           ; AF19: 88          .
    LDA L05ED                                     ; AF1A: AD ED 05    ...
    JSR CB05D                                     ; AF1D: 20 5D B0     ].
    DEY                                           ; AF20: 88          .
    LDA L05EB                                     ; AF21: AD EB 05    ...
    JSR CB05D                                     ; AF24: 20 5D B0     ].
    DEY                                           ; AF27: 88          .
    LDA L05EB                                     ; AF28: AD EB 05    ...
    JSR CB05D                                     ; AF2B: 20 5D B0     ].
    DEY                                           ; AF2E: 88          .
    LDA L05EA                                     ; AF2F: AD EA 05    ...
    JMP CB05D                                     ; AF32: 4C 5D B0    L].

.sub_CAF35
    LDA L00E9                                     ; AF35: A5 E9       ..
    BPL CAF42                                     ; AF37: 10 09       ..
    LDA PPUSTATUS                                 ; AF39: AD 02 20    ..
    ASL A                                         ; AF3C: 0A          .
    BPL CAF42                                     ; AF3D: 10 03       ..
    JSR NAMETABLE0                                ; AF3F: 20 6D D0     m.
.CAF42
    STY Y1                                        ; AF42: 84 72       .r
    LDA V                                         ; AF44: A5 63       .c
    JSR SQUA2                                     ; AF46: 20 0E F7     ..
    STA T                                         ; AF49: 85 9A       ..
    LDA K2                                        ; AF4B: AD 59 04    .Y.
    SEC                                           ; AF4E: 38          8
    SBC P                                         ; AF4F: E5 2F       ./
    STA Q                                         ; AF51: 85 97       ..
    LDA K2_1                                      ; AF53: AD 5A 04    .Z.
    SBC T                                         ; AF56: E5 9A       ..
    STA R                                         ; AF58: 85 98       ..
    JSR LL5                                       ; AF5A: 20 55 FA     U.
    LDY Y1                                        ; AF5D: A4 72       .r
    LDA L00E9                                     ; AF5F: A5 E9       ..
    BPL CAF6C                                     ; AF61: 10 09       ..
    LDA PPUSTATUS                                 ; AF63: AD 02 20    ..
    ASL A                                         ; AF66: 0A          .
    BPL CAF6C                                     ; AF67: 10 03       ..
    JSR NAMETABLE0                                ; AF69: 20 6D D0     m.
.CAF6C
    JSR DORND                                     ; AF6C: 20 AD F4     ..
    AND CNT                                       ; AF6F: 25 A8       %.
    LDY Y1                                        ; AF71: A4 72       .r
    CLC                                           ; AF73: 18          .
    ADC Q                                         ; AF74: 65 97       e.
    BCC RTS2                                      ; AF76: 90 02       ..
    LDA #&FF                                      ; AF78: A9 FF       ..
.RTS2
    RTS                                           ; AF7A: 60          `

; ******************************************************************************
.CIRCLE
    LDA L00E9                                     ; AF7B: A5 E9       ..
    BPL CAF88                                     ; AF7D: 10 09       ..
    LDA PPUSTATUS                                 ; AF7F: AD 02 20    ..
    ASL A                                         ; AF82: 0A          .
    BPL CAF88                                     ; AF83: 10 03       ..
    JSR NAMETABLE0                                ; AF85: 20 6D D0     m.
.CAF88
    JSR CHKON                                     ; AF88: 20 77 B0     w.
    BCS RTS2                                      ; AF8B: B0 ED       ..
    LDX K                                         ; AF8D: A6 7D       .}
    LDA #8                                        ; AF8F: A9 08       ..
    CPX #8                                        ; AF91: E0 08       ..
    BCC CAF9B                                     ; AF93: 90 06       ..
    LSR A                                         ; AF95: 4A          J
    CPX #&3C ; '<'                                ; AF96: E0 3C       .<
    BCC CAF9B                                     ; AF98: 90 01       ..
    LSR A                                         ; AF9A: 4A          J
.CAF9B
    STA STP                                       ; AF9B: 85 AA       ..
; ******************************************************************************
.CIRCLE2
    LDX #&FF                                      ; AF9D: A2 FF       ..
    STX FLAG                                      ; AF9F: 86 A7       ..
    INX                                           ; AFA1: E8          .
    STX CNT                                       ; AFA2: 86 A8       ..
.CAFA4
    LDA CNT                                       ; AFA4: A5 A8       ..
    JSR FMLTU2                                    ; AFA6: 20 66 F7     f.
    LDX #0                                        ; AFA9: A2 00       ..
    STX T                                         ; AFAB: 86 9A       ..
    LDX CNT                                       ; AFAD: A6 A8       ..
    CPX #&21 ; '!'                                ; AFAF: E0 21       .!
    BCC CAFC0                                     ; AFB1: 90 0D       ..
    EOR #&FF                                      ; AFB3: 49 FF       I.
    ADC #0                                        ; AFB5: 69 00       i.
    TAX                                           ; AFB7: AA          .
    LDA #&FF                                      ; AFB8: A9 FF       ..
    ADC #0                                        ; AFBA: 69 00       i.
    STA T                                         ; AFBC: 85 9A       ..
    TXA                                           ; AFBE: 8A          .
    CLC                                           ; AFBF: 18          .
.CAFC0
    ADC XX2                                       ; AFC0: 65 3D       e=
    STA K6                                        ; AFC2: 85 8C       ..
    LDA L003E                                     ; AFC4: A5 3E       .>
    ADC T                                         ; AFC6: 65 9A       e.
    STA K6_1                                      ; AFC8: 85 8D       ..
    LDA CNT                                       ; AFCA: A5 A8       ..
    CLC                                           ; AFCC: 18          .
    ADC #&10                                      ; AFCD: 69 10       i.
    JSR FMLTU2                                    ; AFCF: 20 66 F7     f.
    TAX                                           ; AFD2: AA          .
    LDA #0                                        ; AFD3: A9 00       ..
    STA T                                         ; AFD5: 85 9A       ..
    LDA CNT                                       ; AFD7: A5 A8       ..
    CLC                                           ; AFD9: 18          .
    ADC #&0F                                      ; AFDA: 69 0F       i.
    AND #&3F ; '?'                                ; AFDC: 29 3F       )?
    CMP #&21 ; '!'                                ; AFDE: C9 21       .!
    BCC CAFEF                                     ; AFE0: 90 0D       ..
    TXA                                           ; AFE2: 8A          .
    EOR #&FF                                      ; AFE3: 49 FF       I.
    ADC #0                                        ; AFE5: 69 00       i.
    TAX                                           ; AFE7: AA          .
    LDA #&FF                                      ; AFE8: A9 FF       ..
    ADC #0                                        ; AFEA: 69 00       i.
    STA T                                         ; AFEC: 85 9A       ..
    CLC                                           ; AFEE: 18          .
.CAFEF
    JSR BLINE                                     ; AFEF: 20 3B B1     ;.
    CMP #&41 ; 'A'                                ; AFF2: C9 41       .A
    BCS CAFF9                                     ; AFF4: B0 03       ..
    JMP CAFA4                                     ; AFF6: 4C A4 AF    L..

.CAFF9
    CLC                                           ; AFF9: 18          .
    RTS                                           ; AFFA: 60          `

.ED3
    BPL ED1                                       ; AFFB: 10 06       ..
    LDA #0                                        ; AFFD: A9 00       ..
    STA XX15                                      ; AFFF: 85 71       .q
    CLC                                           ; B001: 18          .
    RTS                                           ; B002: 60          `

.ED1
    LDA L00E9                                     ; B003: A5 E9       ..
    BPL CB010                                     ; B005: 10 09       ..
    LDA PPUSTATUS                                 ; B007: AD 02 20    ..
    ASL A                                         ; B00A: 0A          .
    BPL CB010                                     ; B00B: 10 03       ..
    JSR NAMETABLE0                                ; B00D: 20 6D D0     m.
.CB010
    SEC                                           ; B010: 38          8
    RTS                                           ; B011: 60          `

.sub_CB012
    BEQ ED1                                       ; B012: F0 EF       ..
; ******************************************************************************
.EDGES
    STA T                                         ; B014: 85 9A       ..
    CLC                                           ; B016: 18          .
    ADC YY                                        ; B017: 65 67       eg
    STA X2                                        ; B019: 85 73       .s
    LDA YY_1                                      ; B01B: A5 68       .h
    ADC #0                                        ; B01D: 69 00       i.
    BMI ED1                                       ; B01F: 30 E2       0.
    BEQ CB027                                     ; B021: F0 04       ..
    LDA #&FD                                      ; B023: A9 FD       ..
    STA X2                                        ; B025: 85 73       .s
.CB027
    LDA YY                                        ; B027: A5 67       .g
    SEC                                           ; B029: 38          8
    SBC T                                         ; B02A: E5 9A       ..
    STA XX15                                      ; B02C: 85 71       .q
    LDA YY_1                                      ; B02E: A5 68       .h
    SBC #0                                        ; B030: E9 00       ..
    BNE ED3                                       ; B032: D0 C7       ..
    LDA XX15                                      ; B034: A5 71       .q
    CMP X2                                        ; B036: C5 73       .s
    RTS                                           ; B038: 60          `

.CB039
    LDX P                                         ; B039: A6 2F       ./
    STX X2                                        ; B03B: 86 73       .s
    EOR #&FF                                      ; B03D: 49 FF       I.
    SEC                                           ; B03F: 38          8
    ADC YY                                        ; B040: 65 67       eg
    STA XX15                                      ; B042: 85 71       .q
    LDA YY_1                                      ; B044: A5 68       .h
    ADC #&FF                                      ; B046: 69 FF       i.
    BEQ CB04D                                     ; B048: F0 03       ..
    BMI CB056                                     ; B04A: 30 0A       0.
.CB04C
    RTS                                           ; B04C: 60          `

.CB04D
    LDA XX15                                      ; B04D: A5 71       .q
    CMP X2                                        ; B04F: C5 73       .s
    BCS CB04C                                     ; B051: B0 F9       ..
    JMP LE0BA                                     ; B053: 4C BA E0    L..

.CB056
    LDA #0                                        ; B056: A9 00       ..
    STA XX15                                      ; B058: 85 71       .q
    JMP LE0BA                                     ; B05A: 4C BA E0    L..

.CB05D
    CLC                                           ; B05D: 18          .
    ADC YY                                        ; B05E: 65 67       eg
    STA X2                                        ; B060: 85 73       .s
    LDA YY_1                                      ; B062: A5 68       .h
    ADC #0                                        ; B064: 69 00       i.
    BEQ CB04D                                     ; B066: F0 E5       ..
    BMI CB04C                                     ; B068: 30 E2       0.
    LDA #&FD                                      ; B06A: A9 FD       ..
    STA X2                                        ; B06C: 85 73       .s
    CMP XX15                                      ; B06E: C5 71       .q
    BEQ CB04C                                     ; B070: F0 DA       ..
    BCC CB04C                                     ; B072: 90 D8       ..
    JMP LE0BA                                     ; B074: 4C BA E0    L..

; ******************************************************************************
.CHKON
    LDA XX2                                       ; B077: A5 3D       .=
    CLC                                           ; B079: 18          .
    ADC K                                         ; B07A: 65 7D       e}
    LDA L003E                                     ; B07C: A5 3E       .>
    ADC #0                                        ; B07E: 69 00       i.
    BMI PL21                                      ; B080: 30 2D       0-
    LDA XX2                                       ; B082: A5 3D       .=
    SEC                                           ; B084: 38          8
    SBC K                                         ; B085: E5 7D       .}
    LDA L003E                                     ; B087: A5 3E       .>
    SBC #0                                        ; B089: E9 00       ..
    BMI CB08F                                     ; B08B: 30 02       0.
    BNE PL21                                      ; B08D: D0 20       .
.CB08F
    LDA K4                                        ; B08F: A5 4B       .K
    CLC                                           ; B091: 18          .
    ADC K                                         ; B092: 65 7D       e}
    STA P_1                                       ; B094: 85 30       .0
    LDA XX2_15                                    ; B096: A5 4C       .L
    ADC #0                                        ; B098: 69 00       i.
    BMI PL21                                      ; B09A: 30 13       0.
    STA P_2                                       ; B09C: 85 31       .1
    LDA K4                                        ; B09E: A5 4B       .K
    SEC                                           ; B0A0: 38          8
    SBC K                                         ; B0A1: E5 7D       .}
    TAX                                           ; B0A3: AA          .
    LDA XX2_15                                    ; B0A4: A5 4C       .L
    SBC #0                                        ; B0A6: E9 00       ..
    BMI CB0B1                                     ; B0A8: 30 07       0.
    BNE PL21                                      ; B0AA: D0 03       ..
    CPX Yx2M1                                     ; B0AC: E4 B3       ..
    RTS                                           ; B0AE: 60          `

; ******************************************************************************
.PL21
    SEC                                           ; B0AF: 38          8
    RTS                                           ; B0B0: 60          `

.CB0B1
    CLC                                           ; B0B1: 18          .
    RTS                                           ; B0B2: 60          `

; ******************************************************************************
.PLS3
    JSR PLS1                                      ; B0B3: 20 27 AB     '.
    STA P                                         ; B0B6: 85 2F       ./
    LDA #&DE                                      ; B0B8: A9 DE       ..
    STA Q                                         ; B0BA: 85 97       ..
    STX U                                         ; B0BC: 86 96       ..
    JSR MULTU                                     ; B0BE: 20 21 F7     !.
    LDX U                                         ; B0C1: A6 96       ..
    LDY K_3                                       ; B0C3: A4 80       ..
    BPL CB0D1                                     ; B0C5: 10 0A       ..
    EOR #&FF                                      ; B0C7: 49 FF       I.
    CLC                                           ; B0C9: 18          .
    ADC #1                                        ; B0CA: 69 01       i.
    BEQ CB0D1                                     ; B0CC: F0 03       ..
    LDY #&FF                                      ; B0CE: A0 FF       ..
    RTS                                           ; B0D0: 60          `

.CB0D1
    LDY #0                                        ; B0D1: A0 00       ..
    RTS                                           ; B0D3: 60          `

; ******************************************************************************
.PLS4
    STA Q                                         ; B0D4: 85 97       ..
    JSR ARCTAN                                    ; B0D6: 20 F5 B0     ..
    LDX INWK_14                                   ; B0D9: A6 17       ..
    BMI CB0DF                                     ; B0DB: 30 02       0.
    EOR #&80                                      ; B0DD: 49 80       I.
.CB0DF
    LSR A                                         ; B0DF: 4A          J
    LSR A                                         ; B0E0: 4A          J
    STA CNT2                                      ; B0E1: 85 A9       ..
    RTS                                           ; B0E3: 60          `

; ******************************************************************************
.PLS5
    JSR PLS1                                      ; B0E4: 20 27 AB     '.
    STA K2_2                                      ; B0E7: 8D 5B 04    .[.
    STY XX16_2                                    ; B0EA: 84 4F       .O
    JSR PLS1                                      ; B0EC: 20 27 AB     '.
    STA K2_3                                      ; B0EF: 8D 5C 04    .\.
    STY XX16_3                                    ; B0F2: 84 50       .P
    RTS                                           ; B0F4: 60          `

; ******************************************************************************
.ARCTAN
    LDA P                                         ; B0F5: A5 2F       ./
    EOR Q                                         ; B0F7: 45 97       E.
    STA T1                                        ; B0F9: 85 06       ..
    LDA Q                                         ; B0FB: A5 97       ..
    BEQ CB124                                     ; B0FD: F0 25       .%
    ASL A                                         ; B0FF: 0A          .
    STA Q                                         ; B100: 85 97       ..
    LDA P                                         ; B102: A5 2F       ./
    ASL A                                         ; B104: 0A          .
    CMP Q                                         ; B105: C5 97       ..
    BCS CB112                                     ; B107: B0 09       ..
    JSR sub_CB12E                                 ; B109: 20 2E B1     ..
    SEC                                           ; B10C: 38          8
.loop_CB10D
    LDX T1                                        ; B10D: A6 06       ..
    BMI CB127                                     ; B10F: 30 16       0.
    RTS                                           ; B111: 60          `

.CB112
    LDX Q                                         ; B112: A6 97       ..
    STA Q                                         ; B114: 85 97       ..
    STX P                                         ; B116: 86 2F       ./
    TXA                                           ; B118: 8A          .
    JSR sub_CB12E                                 ; B119: 20 2E B1     ..
    STA T                                         ; B11C: 85 9A       ..
    LDA #&40 ; '@'                                ; B11E: A9 40       .@
    SBC T                                         ; B120: E5 9A       ..
    BCS loop_CB10D                                ; B122: B0 E9       ..
.CB124
    LDA #&3F ; '?'                                ; B124: A9 3F       .?
    RTS                                           ; B126: 60          `

.CB127
    STA T                                         ; B127: 85 9A       ..
    LDA #&80                                      ; B129: A9 80       ..
    SBC T                                         ; B12B: E5 9A       ..
    RTS                                           ; B12D: 60          `

.sub_CB12E
    JSR LL28                                      ; B12E: 20 91 FA     ..
    LDA R                                         ; B131: A5 98       ..
    LSR A                                         ; B133: 4A          J
    LSR A                                         ; B134: 4A          J
    LSR A                                         ; B135: 4A          J
    TAX                                           ; B136: AA          .
    LDA ACT,X                                     ; B137: BD 20 C5    . .
    RTS                                           ; B13A: 60          `

; ******************************************************************************
.BLINE
    LDA L00E9                                     ; B13B: A5 E9       ..
    BPL CB148                                     ; B13D: 10 09       ..
    LDA PPUSTATUS                                 ; B13F: AD 02 20    ..
    ASL A                                         ; B142: 0A          .
    BPL CB148                                     ; B143: 10 03       ..
    JSR NAMETABLE0                                ; B145: 20 6D D0     m.
.CB148
    TXA                                           ; B148: 8A          .
    ADC K4                                        ; B149: 65 4B       eK
    STA L008E                                     ; B14B: 85 8E       ..
    LDA XX2_15                                    ; B14D: A5 4C       .L
    ADC T                                         ; B14F: 65 9A       e.
    STA XX18_7                                    ; B151: 85 8F       ..
    LDA FLAG                                      ; B153: A5 A7       ..
    BEQ BL1                                       ; B155: F0 05       ..
    INC FLAG                                      ; B157: E6 A7       ..
    JMP CB1A6                                     ; B159: 4C A6 B1    L..

.BL1
    LDA XX18                                      ; B15C: A5 88       ..
    STA XX15                                      ; B15E: 85 71       .q
    LDA L0089                                     ; B160: A5 89       ..
    STA Y1                                        ; B162: 85 72       .r
    LDA L008A                                     ; B164: A5 8A       ..
    STA X2                                        ; B166: 85 73       .s
    LDA L008B                                     ; B168: A5 8B       ..
    STA Y2                                        ; B16A: 85 74       .t
    LDA K6                                        ; B16C: A5 8C       ..
    STA XX15_4                                    ; B16E: 85 75       .u
    LDA K6_1                                      ; B170: A5 8D       ..
    STA XX15_5                                    ; B172: 85 76       .v
    LDA L008E                                     ; B174: A5 8E       ..
    STA XX12                                      ; B176: 85 77       .w
    LDA XX18_7                                    ; B178: A5 8F       ..
    STA XX12_1                                    ; B17A: 85 78       .x
    LDA L00E9                                     ; B17C: A5 E9       ..
    BPL CB189                                     ; B17E: 10 09       ..
    LDA PPUSTATUS                                 ; B180: AD 02 20    ..
    ASL A                                         ; B183: 0A          .
    BPL CB189                                     ; B184: 10 03       ..
    JSR NAMETABLE0                                ; B186: 20 6D D0     m.
.CB189
    JSR CLIP                                      ; B189: 20 5D A6     ].
    BCS CB1A6                                     ; B18C: B0 18       ..
    LDA SWAP                                      ; B18E: AD 7F 04    ...
    BEQ CB1A3                                     ; B191: F0 10       ..
    LDA XX15                                      ; B193: A5 71       .q
    LDY X2                                        ; B195: A4 73       .s
    STA X2                                        ; B197: 85 73       .s
    STY XX15                                      ; B199: 84 71       .q
    LDA Y1                                        ; B19B: A5 72       .r
    LDY Y2                                        ; B19D: A4 74       .t
    STA Y2                                        ; B19F: 85 74       .t
    STY Y1                                        ; B1A1: 84 72       .r
.CB1A3
    JSR LOIN                                      ; B1A3: 20 0F DC     ..
.CB1A6
    LDA K6                                        ; B1A6: A5 8C       ..
    STA XX18                                      ; B1A8: 85 88       ..
    LDA K6_1                                      ; B1AA: A5 8D       ..
    STA L0089                                     ; B1AC: 85 89       ..
    LDA L008E                                     ; B1AE: A5 8E       ..
    STA L008A                                     ; B1B0: 85 8A       ..
    LDA XX18_7                                    ; B1B2: A5 8F       ..
    STA L008B                                     ; B1B4: 85 8B       ..
    LDA CNT                                       ; B1B6: A5 A8       ..
    CLC                                           ; B1B8: 18          .
    ADC STP                                       ; B1B9: 65 AA       e.
    STA CNT                                       ; B1BB: 85 A8       ..
    RTS                                           ; B1BD: 60          `

; ******************************************************************************
.STARS
    LDX VIEW                                      ; B1BE: AE 8E 03    ...
    BEQ STARS1                                    ; B1C1: F0 09       ..
    DEX                                           ; B1C3: CA          .
    BNE CB1C9                                     ; B1C4: D0 03       ..
    JMP STARS6                                    ; B1C6: 4C 02 B3    L..

.CB1C9
    JMP STARS2                                    ; B1C9: 4C 3F B4    L?.

; ******************************************************************************
.STARS1
    LDY NOSTM                                     ; B1CC: AC E5 03    ...
.CB1CF
    LDA L00E9                                     ; B1CF: A5 E9       ..
    BPL CB1DC                                     ; B1D1: 10 09       ..
    LDA PPUSTATUS                                 ; B1D3: AD 02 20    ..
    ASL A                                         ; B1D6: 0A          .
    BPL CB1DC                                     ; B1D7: 10 03       ..
    JSR NAMETABLE0                                ; B1D9: 20 6D D0     m.
.CB1DC
    JSR DV42                                      ; B1DC: 20 D1 F8     ..
    LDA R                                         ; B1DF: A5 98       ..
    LSR P                                         ; B1E1: 46 2F       F/
    ROR A                                         ; B1E3: 6A          j
    LSR P                                         ; B1E4: 46 2F       F/
    ROR A                                         ; B1E6: 6A          j
    ORA #1                                        ; B1E7: 09 01       ..
    STA Q                                         ; B1E9: 85 97       ..
    LDA SZL,Y                                     ; B1EB: B9 CF 05    ...
    SBC DELT4                                     ; B1EE: E5 94       ..
    STA SZL,Y                                     ; B1F0: 99 CF 05    ...
    LDA SZ,Y                                      ; B1F3: B9 F2 04    ...
    STA ZZ                                        ; B1F6: 85 A0       ..
    SBC DELT4_1                                   ; B1F8: E5 95       ..
    STA SZ,Y                                      ; B1FA: 99 F2 04    ...
    JSR MLU1                                      ; B1FD: 20 18 F7     ..
    STA YY_1                                      ; B200: 85 68       .h
    LDA P                                         ; B202: A5 2F       ./
    ADC SYL,Y                                     ; B204: 79 BA 05    y..
    STA YY                                        ; B207: 85 67       .g
    STA R                                         ; B209: 85 98       ..
    LDA Y1                                        ; B20B: A5 72       .r
    ADC YY_1                                      ; B20D: 65 68       eh
    STA YY_1                                      ; B20F: 85 68       .h
    STA S                                         ; B211: 85 99       ..
    LDA SX,Y                                      ; B213: B9 C8 04    ...
    STA XX15                                      ; B216: 85 71       .q
    JSR MLU2                                      ; B218: 20 1D F7     ..
    STA XX_1                                      ; B21B: 85 66       .f
    LDA L00E9                                     ; B21D: A5 E9       ..
    BPL CB22A                                     ; B21F: 10 09       ..
    LDA PPUSTATUS                                 ; B221: AD 02 20    ..
    ASL A                                         ; B224: 0A          .
    BPL CB22A                                     ; B225: 10 03       ..
    JSR NAMETABLE0                                ; B227: 20 6D D0     m.
.CB22A
    LDA P                                         ; B22A: A5 2F       ./
    ADC SXL,Y                                     ; B22C: 79 A5 05    y..
    STA XX                                        ; B22F: 85 65       .e
    LDA XX15                                      ; B231: A5 71       .q
    ADC XX_1                                      ; B233: 65 66       ef
    STA XX_1                                      ; B235: 85 66       .f
    EOR ALP2_1                                    ; B237: 45 70       Ep
    JSR MLS1                                      ; B239: 20 C2 F6     ..
    JSR ADD                                       ; B23C: 20 72 F8     r.
    STA YY_1                                      ; B23F: 85 68       .h
    STX YY                                        ; B241: 86 67       .g
    EOR ALP2                                      ; B243: 45 6F       Eo
    JSR MLS2                                      ; B245: 20 BA F6     ..
    JSR ADD                                       ; B248: 20 72 F8     r.
    STA XX_1                                      ; B24B: 85 66       .f
    STX XX                                        ; B24D: 86 65       .e
    LDA L00E9                                     ; B24F: A5 E9       ..
    BPL CB25C                                     ; B251: 10 09       ..
    LDA PPUSTATUS                                 ; B253: AD 02 20    ..
    ASL A                                         ; B256: 0A          .
    BPL CB25C                                     ; B257: 10 03       ..
    JSR NAMETABLE0                                ; B259: 20 6D D0     m.
.CB25C
    LDX BET1                                      ; B25C: A6 6A       .j
    LDA YY_1                                      ; B25E: A5 68       .h
    EOR BET2_1                                    ; B260: 45 92       E.
    JSR MULTSm2                                   ; B262: 20 C4 F6     ..
    STA Q                                         ; B265: 85 97       ..
    JSR MUT2                                      ; B267: 20 D2 F7     ..
    ASL P                                         ; B26A: 06 2F       ./
    ROL A                                         ; B26C: 2A          *
    STA T                                         ; B26D: 85 9A       ..
    LDA #0                                        ; B26F: A9 00       ..
    ROR A                                         ; B271: 6A          j
    ORA T                                         ; B272: 05 9A       ..
    JSR ADD                                       ; B274: 20 72 F8     r.
    STA XX_1                                      ; B277: 85 66       .f
    TXA                                           ; B279: 8A          .
    STA SXL,Y                                     ; B27A: 99 A5 05    ...
    LDA YY                                        ; B27D: A5 67       .g
    STA R                                         ; B27F: 85 98       ..
    LDA YY_1                                      ; B281: A5 68       .h
    STA S                                         ; B283: 85 99       ..
    LDA #0                                        ; B285: A9 00       ..
    STA P                                         ; B287: 85 2F       ./
    LDA L00E9                                     ; B289: A5 E9       ..
    BPL CB296                                     ; B28B: 10 09       ..
    LDA PPUSTATUS                                 ; B28D: AD 02 20    ..
    ASL A                                         ; B290: 0A          .
    BPL CB296                                     ; B291: 10 03       ..
    JSR NAMETABLE0                                ; B293: 20 6D D0     m.
.CB296
    LDA BETA                                      ; B296: A5 69       .i
    EOR #&80                                      ; B298: 49 80       I.
    JSR ADD                                       ; B29A: 20 72 F8     r.
    STA YY_1                                      ; B29D: 85 68       .h
    TXA                                           ; B29F: 8A          .
    STA SYL,Y                                     ; B2A0: 99 BA 05    ...
    LDA XX_1                                      ; B2A3: A5 66       .f
    STA XX15                                      ; B2A5: 85 71       .q
    STA SX,Y                                      ; B2A7: 99 C8 04    ...
    AND #&7F                                      ; B2AA: 29 7F       ).
    CMP #&78 ; 'x'                                ; B2AC: C9 78       .x
    BCS KILL1                                     ; B2AE: B0 20       .
    LDA YY_1                                      ; B2B0: A5 68       .h
    STA SY,Y                                      ; B2B2: 99 DD 04    ...
    STA Y1                                        ; B2B5: 85 72       .r
    AND #&7F                                      ; B2B7: 29 7F       ).
    CMP #&78 ; 'x'                                ; B2B9: C9 78       .x
    BCS KILL1                                     ; B2BB: B0 13       ..
    LDA SZ,Y                                      ; B2BD: B9 F2 04    ...
    CMP #&10                                      ; B2C0: C9 10       ..
    BCC KILL1                                     ; B2C2: 90 0C       ..
    STA ZZ                                        ; B2C4: 85 A0       ..
.CB2C6
    JSR PIXEL2                                    ; B2C6: 20 FA BB     ..
    DEY                                           ; B2C9: 88          .
    BEQ CB2CF                                     ; B2CA: F0 03       ..
    JMP CB1CF                                     ; B2CC: 4C CF B1    L..

.CB2CF
    RTS                                           ; B2CF: 60          `

.KILL1
    JSR DORND                                     ; B2D0: 20 AD F4     ..
    ORA #4                                        ; B2D3: 09 04       ..
    STA Y1                                        ; B2D5: 85 72       .r
    STA SY,Y                                      ; B2D7: 99 DD 04    ...
    JSR DORND                                     ; B2DA: 20 AD F4     ..
    ORA #&10                                      ; B2DD: 09 10       ..
    AND #&F0                                      ; B2DF: 29 F0       ).
    STA XX15                                      ; B2E1: 85 71       .q
    STA SX,Y                                      ; B2E3: 99 C8 04    ...
    JSR DORND                                     ; B2E6: 20 AD F4     ..
    ORA #&90                                      ; B2E9: 09 90       ..
    STA SZ,Y                                      ; B2EB: 99 F2 04    ...
    STA ZZ                                        ; B2EE: 85 A0       ..
    LDA L00E9                                     ; B2F0: A5 E9       ..
    BPL CB2FD                                     ; B2F2: 10 09       ..
    LDA PPUSTATUS                                 ; B2F4: AD 02 20    ..
    ASL A                                         ; B2F7: 0A          .
    BPL CB2FD                                     ; B2F8: 10 03       ..
    JSR NAMETABLE0                                ; B2FA: 20 6D D0     m.
.CB2FD
    LDA Y1                                        ; B2FD: A5 72       .r
    JMP CB2C6                                     ; B2FF: 4C C6 B2    L..

; ******************************************************************************
.STARS6
    LDY NOSTM                                     ; B302: AC E5 03    ...
.CB305
    LDA L00E9                                     ; B305: A5 E9       ..
    BPL CB312                                     ; B307: 10 09       ..
    LDA PPUSTATUS                                 ; B309: AD 02 20    ..
    ASL A                                         ; B30C: 0A          .
    BPL CB312                                     ; B30D: 10 03       ..
    JSR NAMETABLE0                                ; B30F: 20 6D D0     m.
.CB312
    JSR DV42                                      ; B312: 20 D1 F8     ..
    LDA R                                         ; B315: A5 98       ..
    LSR P                                         ; B317: 46 2F       F/
    ROR A                                         ; B319: 6A          j
    LSR P                                         ; B31A: 46 2F       F/
    ROR A                                         ; B31C: 6A          j
    ORA #1                                        ; B31D: 09 01       ..
    STA Q                                         ; B31F: 85 97       ..
    LDA SX,Y                                      ; B321: B9 C8 04    ...
    STA XX15                                      ; B324: 85 71       .q
    JSR MLU2                                      ; B326: 20 1D F7     ..
    STA XX_1                                      ; B329: 85 66       .f
    LDA SXL,Y                                     ; B32B: B9 A5 05    ...
    SBC P                                         ; B32E: E5 2F       ./
    STA XX                                        ; B330: 85 65       .e
    LDA XX15                                      ; B332: A5 71       .q
    SBC XX_1                                      ; B334: E5 66       .f
    STA XX_1                                      ; B336: 85 66       .f
    JSR MLU1                                      ; B338: 20 18 F7     ..
    STA YY_1                                      ; B33B: 85 68       .h
    LDA L00E9                                     ; B33D: A5 E9       ..
    BPL CB34A                                     ; B33F: 10 09       ..
    LDA PPUSTATUS                                 ; B341: AD 02 20    ..
    ASL A                                         ; B344: 0A          .
    BPL CB34A                                     ; B345: 10 03       ..
    JSR NAMETABLE0                                ; B347: 20 6D D0     m.
.CB34A
    LDA SYL,Y                                     ; B34A: B9 BA 05    ...
    SBC P                                         ; B34D: E5 2F       ./
    STA YY                                        ; B34F: 85 67       .g
    STA R                                         ; B351: 85 98       ..
    LDA Y1                                        ; B353: A5 72       .r
    SBC YY_1                                      ; B355: E5 68       .h
    STA YY_1                                      ; B357: 85 68       .h
    STA S                                         ; B359: 85 99       ..
    LDA SZL,Y                                     ; B35B: B9 CF 05    ...
    ADC DELT4                                     ; B35E: 65 94       e.
    STA SZL,Y                                     ; B360: 99 CF 05    ...
    LDA SZ,Y                                      ; B363: B9 F2 04    ...
    STA ZZ                                        ; B366: 85 A0       ..
    ADC DELT4_1                                   ; B368: 65 95       e.
    STA SZ,Y                                      ; B36A: 99 F2 04    ...
    LDA XX_1                                      ; B36D: A5 66       .f
    EOR ALP2                                      ; B36F: 45 6F       Eo
    JSR MLS1                                      ; B371: 20 C2 F6     ..
    JSR ADD                                       ; B374: 20 72 F8     r.
    STA YY_1                                      ; B377: 85 68       .h
    STX YY                                        ; B379: 86 67       .g
    EOR ALP2_1                                    ; B37B: 45 70       Ep
    JSR MLS2                                      ; B37D: 20 BA F6     ..
    JSR ADD                                       ; B380: 20 72 F8     r.
    STA XX_1                                      ; B383: 85 66       .f
    STX XX                                        ; B385: 86 65       .e
    LDA YY_1                                      ; B387: A5 68       .h
    EOR BET2_1                                    ; B389: 45 92       E.
    LDX BET1                                      ; B38B: A6 6A       .j
    JSR MULTSm2                                   ; B38D: 20 C4 F6     ..
    STA Q                                         ; B390: 85 97       ..
    LDA XX_1                                      ; B392: A5 66       .f
    STA S                                         ; B394: 85 99       ..
    EOR #&80                                      ; B396: 49 80       I.
    JSR MUT1                                      ; B398: 20 D6 F7     ..
    ASL P                                         ; B39B: 06 2F       ./
    ROL A                                         ; B39D: 2A          *
    STA T                                         ; B39E: 85 9A       ..
    LDA #0                                        ; B3A0: A9 00       ..
    ROR A                                         ; B3A2: 6A          j
    ORA T                                         ; B3A3: 05 9A       ..
    JSR ADD                                       ; B3A5: 20 72 F8     r.
    STA XX_1                                      ; B3A8: 85 66       .f
    TXA                                           ; B3AA: 8A          .
    STA SXL,Y                                     ; B3AB: 99 A5 05    ...
    LDA YY                                        ; B3AE: A5 67       .g
    STA R                                         ; B3B0: 85 98       ..
    LDA L00E9                                     ; B3B2: A5 E9       ..
    BPL CB3BF                                     ; B3B4: 10 09       ..
    LDA PPUSTATUS                                 ; B3B6: AD 02 20    ..
    ASL A                                         ; B3B9: 0A          .
    BPL CB3BF                                     ; B3BA: 10 03       ..
    JSR NAMETABLE0                                ; B3BC: 20 6D D0     m.
.CB3BF
    LDA YY_1                                      ; B3BF: A5 68       .h
    STA S                                         ; B3C1: 85 99       ..
    LDA #0                                        ; B3C3: A9 00       ..
    STA P                                         ; B3C5: 85 2F       ./
    LDA BETA                                      ; B3C7: A5 69       .i
    JSR ADD                                       ; B3C9: 20 72 F8     r.
    STA YY_1                                      ; B3CC: 85 68       .h
    TXA                                           ; B3CE: 8A          .
    STA SYL,Y                                     ; B3CF: 99 BA 05    ...
    LDA XX_1                                      ; B3D2: A5 66       .f
    STA XX15                                      ; B3D4: 85 71       .q
    STA SX,Y                                      ; B3D6: 99 C8 04    ...
    LDA YY_1                                      ; B3D9: A5 68       .h
    STA SY,Y                                      ; B3DB: 99 DD 04    ...
    STA Y1                                        ; B3DE: 85 72       .r
    AND #&7F                                      ; B3E0: 29 7F       ).
    CMP #&6E ; 'n'                                ; B3E2: C9 6E       .n
    BCS CB3F9                                     ; B3E4: B0 13       ..
    LDA SZ,Y                                      ; B3E6: B9 F2 04    ...
    CMP #&A0                                      ; B3E9: C9 A0       ..
    BCS CB41E                                     ; B3EB: B0 31       .1
    STA ZZ                                        ; B3ED: 85 A0       ..
.CB3EF
    JSR PIXEL2                                    ; B3EF: 20 FA BB     ..
    DEY                                           ; B3F2: 88          .
    BEQ CB3F8                                     ; B3F3: F0 03       ..
    JMP CB305                                     ; B3F5: 4C 05 B3    L..

.CB3F8
    RTS                                           ; B3F8: 60          `

.CB3F9
    JSR DORND                                     ; B3F9: 20 AD F4     ..
    AND #&1F                                      ; B3FC: 29 1F       ).
    ADC #&0A                                      ; B3FE: 69 0A       i.
    STA SZ,Y                                      ; B400: 99 F2 04    ...
    STA ZZ                                        ; B403: 85 A0       ..
    LSR A                                         ; B405: 4A          J
    BCS CB42A                                     ; B406: B0 22       ."
    LSR A                                         ; B408: 4A          J
    LDA #&E0                                      ; B409: A9 E0       ..
    ROR A                                         ; B40B: 6A          j
    STA XX15                                      ; B40C: 85 71       .q
    STA SX,Y                                      ; B40E: 99 C8 04    ...
    JSR DORND                                     ; B411: 20 AD F4     ..
    AND #&BF                                      ; B414: 29 BF       ).
    STA Y1                                        ; B416: 85 72       .r
    STA SY,Y                                      ; B418: 99 DD 04    ...
    JMP CB3EF                                     ; B41B: 4C EF B3    L..

.CB41E
    JSR DORND                                     ; B41E: 20 AD F4     ..
    AND #&7F                                      ; B421: 29 7F       ).
    ADC #&0A                                      ; B423: 69 0A       i.
    STA SZ,Y                                      ; B425: 99 F2 04    ...
    STA ZZ                                        ; B428: 85 A0       ..
.CB42A
    JSR DORND                                     ; B42A: 20 AD F4     ..
    AND #&F9                                      ; B42D: 29 F9       ).
    STA XX15                                      ; B42F: 85 71       .q
    STA SX,Y                                      ; B431: 99 C8 04    ...
    LSR A                                         ; B434: 4A          J
    LDA #&D8                                      ; B435: A9 D8       ..
    ROR A                                         ; B437: 6A          j
    STA Y1                                        ; B438: 85 72       .r
    STA SY,Y                                      ; B43A: 99 DD 04    ...
    BNE CB3EF                                     ; B43D: D0 B0       ..
; ******************************************************************************
.STARS2
    LDA #0                                        ; B43F: A9 00       ..
    CPX #2                                        ; B441: E0 02       ..
    ROR A                                         ; B443: 6A          j
    STA RAT                                       ; B444: 85 AE       ..
    EOR #&80                                      ; B446: 49 80       I.
    STA RAT2                                      ; B448: 85 AF       ..
    JSR CB52A                                     ; B44A: 20 2A B5     *.
    LDY NOSTM                                     ; B44D: AC E5 03    ...
.CB450
    LDA L00E9                                     ; B450: A5 E9       ..
    BPL CB45D                                     ; B452: 10 09       ..
    LDA PPUSTATUS                                 ; B454: AD 02 20    ..
    ASL A                                         ; B457: 0A          .
    BPL CB45D                                     ; B458: 10 03       ..
    JSR NAMETABLE0                                ; B45A: 20 6D D0     m.
.CB45D
    LDA SZ,Y                                      ; B45D: B9 F2 04    ...
    STA ZZ                                        ; B460: 85 A0       ..
    LSR A                                         ; B462: 4A          J
    LSR A                                         ; B463: 4A          J
    LSR A                                         ; B464: 4A          J
    JSR DV41                                      ; B465: 20 D4 F8     ..
    LDA P                                         ; B468: A5 2F       ./
    STA newzp                                     ; B46A: 85 B6       ..
    EOR RAT2                                      ; B46C: 45 AF       E.
    STA S                                         ; B46E: 85 99       ..
    LDA SXL,Y                                     ; B470: B9 A5 05    ...
    STA P                                         ; B473: 85 2F       ./
    LDA SX,Y                                      ; B475: B9 C8 04    ...
    STA XX15                                      ; B478: 85 71       .q
    JSR ADD                                       ; B47A: 20 72 F8     r.
    STA S                                         ; B47D: 85 99       ..
    STX R                                         ; B47F: 86 98       ..
    LDA L00E9                                     ; B481: A5 E9       ..
    BPL CB48E                                     ; B483: 10 09       ..
    LDA PPUSTATUS                                 ; B485: AD 02 20    ..
    ASL A                                         ; B488: 0A          .
    BPL CB48E                                     ; B489: 10 03       ..
    JSR NAMETABLE0                                ; B48B: 20 6D D0     m.
.CB48E
    LDA SY,Y                                      ; B48E: B9 DD 04    ...
    STA Y1                                        ; B491: 85 72       .r
    EOR BET2                                      ; B493: 45 91       E.
    LDX BET1                                      ; B495: A6 6A       .j
    JSR MULTSm2                                   ; B497: 20 C4 F6     ..
    JSR ADD                                       ; B49A: 20 72 F8     r.
    STX XX                                        ; B49D: 86 65       .e
    STA XX_1                                      ; B49F: 85 66       .f
    LDX SYL,Y                                     ; B4A1: BE BA 05    ...
    STX R                                         ; B4A4: 86 98       ..
    LDX Y1                                        ; B4A6: A6 72       .r
    STX S                                         ; B4A8: 86 99       ..
    LDX BET1                                      ; B4AA: A6 6A       .j
    EOR BET2_1                                    ; B4AC: 45 92       E.
    JSR MULTSm2                                   ; B4AE: 20 C4 F6     ..
    JSR ADD                                       ; B4B1: 20 72 F8     r.
    STX YY                                        ; B4B4: 86 67       .g
    STA YY_1                                      ; B4B6: 85 68       .h
    LDX ALP1                                      ; B4B8: A6 6E       .n
    EOR ALP2                                      ; B4BA: 45 6F       Eo
    JSR MULTSm2                                   ; B4BC: 20 C4 F6     ..
    STA Q                                         ; B4BF: 85 97       ..
    LDA XX                                        ; B4C1: A5 65       .e
    STA R                                         ; B4C3: 85 98       ..
    LDA XX_1                                      ; B4C5: A5 66       .f
    STA S                                         ; B4C7: 85 99       ..
    EOR #&80                                      ; B4C9: 49 80       I.
    JSR MAD                                       ; B4CB: 20 6F F8     o.
    STA XX_1                                      ; B4CE: 85 66       .f
    TXA                                           ; B4D0: 8A          .
    STA SXL,Y                                     ; B4D1: 99 A5 05    ...
    LDA L00E9                                     ; B4D4: A5 E9       ..
    BPL CB4E1                                     ; B4D6: 10 09       ..
    LDA PPUSTATUS                                 ; B4D8: AD 02 20    ..
    ASL A                                         ; B4DB: 0A          .
    BPL CB4E1                                     ; B4DC: 10 03       ..
    JSR NAMETABLE0                                ; B4DE: 20 6D D0     m.
.CB4E1
    LDA YY                                        ; B4E1: A5 67       .g
    STA R                                         ; B4E3: 85 98       ..
    LDA YY_1                                      ; B4E5: A5 68       .h
    STA S                                         ; B4E7: 85 99       ..
    JSR MAD                                       ; B4E9: 20 6F F8     o.
    STA S                                         ; B4EC: 85 99       ..
    STX R                                         ; B4EE: 86 98       ..
    LDA #0                                        ; B4F0: A9 00       ..
    STA P                                         ; B4F2: 85 2F       ./
    LDA ALPHA                                     ; B4F4: A5 A4       ..
    JSR ADD                                       ; B4F6: 20 72 F8     r.
    STA YY_1                                      ; B4F9: 85 68       .h
    TXA                                           ; B4FB: 8A          .
    STA SYL,Y                                     ; B4FC: 99 BA 05    ...
    LDA XX_1                                      ; B4FF: A5 66       .f
    STA SX,Y                                      ; B501: 99 C8 04    ...
    STA XX15                                      ; B504: 85 71       .q
    AND #&7F                                      ; B506: 29 7F       ).
    CMP #&78 ; 'x'                                ; B508: C9 78       .x
    BCS KILL2                                     ; B50A: B0 39       .9
    EOR #&7F                                      ; B50C: 49 7F       I.
    CMP newzp                                     ; B50E: C5 B6       ..
    BCC KILL2                                     ; B510: 90 33       .3
    BEQ KILL2                                     ; B512: F0 31       .1
    LDA YY_1                                      ; B514: A5 68       .h
    STA SY,Y                                      ; B516: 99 DD 04    ...
    STA Y1                                        ; B519: 85 72       .r
    AND #&7F                                      ; B51B: 29 7F       ).
    CMP #&74 ; 't'                                ; B51D: C9 74       .t
    BCS CB558                                     ; B51F: B0 37       .7
.CB521
    JSR PIXEL2                                    ; B521: 20 FA BB     ..
    DEY                                           ; B524: 88          .
    BEQ CB52A                                     ; B525: F0 03       ..
    JMP CB450                                     ; B527: 4C 50 B4    LP.

.CB52A
    LDA ALPHA                                     ; B52A: A5 A4       ..
    EOR RAT                                       ; B52C: 45 AE       E.
    STA ALPHA                                     ; B52E: 85 A4       ..
    LDA ALP2                                      ; B530: A5 6F       .o
    EOR RAT                                       ; B532: 45 AE       E.
    STA ALP2                                      ; B534: 85 6F       .o
    EOR #&80                                      ; B536: 49 80       I.
    STA ALP2_1                                    ; B538: 85 70       .p
    LDA BET2                                      ; B53A: A5 91       ..
    EOR RAT                                       ; B53C: 45 AE       E.
    STA BET2                                      ; B53E: 85 91       ..
    EOR #&80                                      ; B540: 49 80       I.
    STA BET2_1                                    ; B542: 85 92       ..
    RTS                                           ; B544: 60          `

.KILL2
    JSR DORND                                     ; B545: 20 AD F4     ..
    STA Y1                                        ; B548: 85 72       .r
    STA SY,Y                                      ; B54A: 99 DD 04    ...
    LDA #&73 ; 's'                                ; B54D: A9 73       .s
    ORA RAT                                       ; B54F: 05 AE       ..
    STA XX15                                      ; B551: 85 71       .q
    STA SX,Y                                      ; B553: 99 C8 04    ...
    BNE CB569                                     ; B556: D0 11       ..
.CB558
    JSR DORND                                     ; B558: 20 AD F4     ..
    STA XX15                                      ; B55B: 85 71       .q
    STA SX,Y                                      ; B55D: 99 C8 04    ...
    LDA #&7E ; '~'                                ; B560: A9 7E       .~
    ORA ALP2_1                                    ; B562: 05 70       .p
    STA Y1                                        ; B564: 85 72       .r
    STA SY,Y                                      ; B566: 99 DD 04    ...
.CB569
    JSR DORND                                     ; B569: 20 AD F4     ..
    ORA #8                                        ; B56C: 09 08       ..
    STA ZZ                                        ; B56E: 85 A0       ..
    STA SZ,Y                                      ; B570: 99 F2 04    ...
    BNE CB521                                     ; B573: D0 AC       ..
.CB575
    BVC LB5CF                                     ; B575: 50 58       PX
    EQUB &62, &78                                 ; B577: 62 78       bx

.sub_CB579
    LDX #0                                        ; B579: A2 00       ..
.CB57B
    STX TGT                                       ; B57B: 86 A6       ..
    LDA CB575,X                                   ; B57D: BD 75 B5    .u.
    TAY                                           ; B580: A8          .
    LDA #8                                        ; B581: A9 08       ..
    LDX #&1C                                      ; B583: A2 1C       ..
    JSR sub_CB62F                                 ; B585: 20 2F B6     /.
    LDA #&F0                                      ; B588: A9 F0       ..
    LDX #&1C                                      ; B58A: A2 1C       ..
    JSR sub_CB6A2                                 ; B58C: 20 A2 B6     ..
    LDA HANGFLAG                                  ; B58F: AD 61 05    .a.
    BEQ CB5A2                                     ; B592: F0 0E       ..
    LDA #&80                                      ; B594: A9 80       ..
    LDX #&0C                                      ; B596: A2 0C       ..
    JSR sub_CB62F                                 ; B598: 20 2F B6     /.
    LDA #&7F                                      ; B59B: A9 7F       ..
    LDX #&0C                                      ; B59D: A2 0C       ..
    JSR sub_CB6A2                                 ; B59F: 20 A2 B6     ..
.CB5A2
    LDX TGT                                       ; B5A2: A6 A6       ..
    INX                                           ; B5A4: E8          .
    CPX #4                                        ; B5A5: E0 04       ..
    BNE CB57B                                     ; B5A7: D0 D2       ..
    JSR DORND                                     ; B5A9: 20 AD F4     ..
    AND #7                                        ; B5AC: 29 07       ).
    ORA #4                                        ; B5AE: 09 04       ..
    LDY #0                                        ; B5B0: A0 00       ..
.loop_CB5B2
    JSR sub_CB5BF                                 ; B5B2: 20 BF B5     ..
    CLC                                           ; B5B5: 18          .
    ADC #&0A                                      ; B5B6: 69 0A       i.
    BCS CB5BE                                     ; B5B8: B0 04       ..
    CMP #&F8                                      ; B5BA: C9 F8       ..
    BCC loop_CB5B2                                ; B5BC: 90 F4       ..
.CB5BE
    RTS                                           ; B5BE: 60          `

.sub_CB5BF
    STA S                                         ; B5BF: 85 99       ..
    STY L009C                                     ; B5C1: 84 9C       ..
    LSR A                                         ; B5C3: 4A          J
    LSR A                                         ; B5C4: 4A          J
    LSR A                                         ; B5C5: 4A          J
    CLC                                           ; B5C6: 18          .
    ADC LDA18,Y                                   ; B5C7: 79 18 DA    y..
    STA L00BA                                     ; B5CA: 85 BA       ..
    LDA L00E6                                     ; B5CC: A5 E6       ..
.sub_CB5CE
LB5CF = sub_CB5CE+1
    ADC LDAF8,Y                                   ; B5CE: 79 F8 DA    y..
; overlapping: SED                                ; B5CF: F8          .
    STA L00BB                                     ; B5D1: 85 BB       ..
    LDA S                                         ; B5D3: A5 99       ..
    AND #7                                        ; B5D5: 29 07       ).
    STA T                                         ; B5D7: 85 9A       ..
.CB5D9
    LDA L00E9                                     ; B5D9: A5 E9       ..
    BPL CB5E6                                     ; B5DB: 10 09       ..
    LDA PPUSTATUS                                 ; B5DD: AD 02 20    ..
    ASL A                                         ; B5E0: 0A          .
    BPL CB5E6                                     ; B5E1: 10 03       ..
    JSR NAMETABLE0                                ; B5E3: 20 6D D0     m.
.CB5E6
    LDX #0                                        ; B5E6: A2 00       ..
    LDA (L00BA,X)                                 ; B5E8: A1 BA       ..
    BEQ CB615                                     ; B5EA: F0 29       .)
    LDX L00B9                                     ; B5EC: A6 B9       ..
    STX SC_1                                      ; B5EE: 86 08       ..
    ASL A                                         ; B5F0: 0A          .
    ROL SC_1                                      ; B5F1: 26 08       &.
    ASL A                                         ; B5F3: 0A          .
    ROL SC_1                                      ; B5F4: 26 08       &.
    ASL A                                         ; B5F6: 0A          .
    ROL SC_1                                      ; B5F7: 26 08       &.
    STA SC                                        ; B5F9: 85 07       ..
    LDY #0                                        ; B5FB: A0 00       ..
    LDX T                                         ; B5FD: A6 9A       ..
.loop_CB5FF
    LDA (SC),Y                                    ; B5FF: B1 07       ..
    AND LD9F7,X                                   ; B601: 3D F7 D9    =..
    BNE CB62A                                     ; B604: D0 24       .$
    LDA (SC),Y                                    ; B606: B1 07       ..
    ORA LD9F7,X                                   ; B608: 1D F7 D9    ...
    STA (SC),Y                                    ; B60B: 91 07       ..
    INY                                           ; B60D: C8          .
    CPY #8                                        ; B60E: C0 08       ..
    BNE loop_CB5FF                                ; B610: D0 ED       ..
    JMP CB61C                                     ; B612: 4C 1C B6    L..

.CB615
    LDA T                                         ; B615: A5 9A       ..
    CLC                                           ; B617: 18          .
    ADC #&34 ; '4'                                ; B618: 69 34       i4
    STA (L00BA,X)                                 ; B61A: 81 BA       ..
.CB61C
    LDA L00BA                                     ; B61C: A5 BA       ..
    CLC                                           ; B61E: 18          .
    ADC #&20 ; ' '                                ; B61F: 69 20       i
    STA L00BA                                     ; B621: 85 BA       ..
    BCC CB5D9                                     ; B623: 90 B4       ..
    INC L00BB                                     ; B625: E6 BB       ..
    JMP CB5D9                                     ; B627: 4C D9 B5    L..

.CB62A
    LDA S                                         ; B62A: A5 99       ..
    LDY L009C                                     ; B62C: A4 9C       ..
    RTS                                           ; B62E: 60          `

.sub_CB62F
    STX R                                         ; B62F: 86 98       ..
    STY L009C                                     ; B631: 84 9C       ..
    LSR A                                         ; B633: 4A          J
    LSR A                                         ; B634: 4A          J
    LSR A                                         ; B635: 4A          J
    CLC                                           ; B636: 18          .
    ADC LDA18,Y                                   ; B637: 79 18 DA    y..
    STA L00BA                                     ; B63A: 85 BA       ..
    LDA L00E6                                     ; B63C: A5 E6       ..
    ADC LDAF8,Y                                   ; B63E: 79 F8 DA    y..
    STA L00BB                                     ; B641: 85 BB       ..
    TYA                                           ; B643: 98          .
    AND #7                                        ; B644: 29 07       ).
    TAY                                           ; B646: A8          .
.CB647
    LDA L00E9                                     ; B647: A5 E9       ..
    BPL CB654                                     ; B649: 10 09       ..
    LDA PPUSTATUS                                 ; B64B: AD 02 20    ..
    ASL A                                         ; B64E: 0A          .
    BPL CB654                                     ; B64F: 10 03       ..
    JSR NAMETABLE0                                ; B651: 20 6D D0     m.
.CB654
    LDX #0                                        ; B654: A2 00       ..
    LDA (L00BA,X)                                 ; B656: A1 BA       ..
    BEQ CB699                                     ; B658: F0 3F       .?
    LDX L00B9                                     ; B65A: A6 B9       ..
    STX SC_1                                      ; B65C: 86 08       ..
    ASL A                                         ; B65E: 0A          .
    ROL SC_1                                      ; B65F: 26 08       &.
    ASL A                                         ; B661: 0A          .
    ROL SC_1                                      ; B662: 26 08       &.
    ASL A                                         ; B664: 0A          .
    ROL SC_1                                      ; B665: 26 08       &.
    STA SC                                        ; B667: 85 07       ..
    LDA (SC),Y                                    ; B669: B1 07       ..
    BEQ CB685                                     ; B66B: F0 18       ..
    LDA #&80                                      ; B66D: A9 80       ..
.loop_CB66F
    STA T                                         ; B66F: 85 9A       ..
    AND (SC),Y                                    ; B671: 31 07       1.
    BNE CB67C                                     ; B673: D0 07       ..
    LDA T                                         ; B675: A5 9A       ..
    SEC                                           ; B677: 38          8
    ROR A                                         ; B678: 6A          j
    JMP loop_CB66F                                ; B679: 4C 6F B6    Lo.

.CB67C
    LDA T                                         ; B67C: A5 9A       ..
    ORA (SC),Y                                    ; B67E: 11 07       ..
    STA (SC),Y                                    ; B680: 91 07       ..
    LDY L009C                                     ; B682: A4 9C       ..
    RTS                                           ; B684: 60          `

.CB685
    LDA #&FF                                      ; B685: A9 FF       ..
    STA (SC),Y                                    ; B687: 91 07       ..
.loop_CB689
    DEC R                                         ; B689: C6 98       ..
    BEQ CB696                                     ; B68B: F0 09       ..
    INC L00BA                                     ; B68D: E6 BA       ..
    BNE CB647                                     ; B68F: D0 B6       ..
    INC L00BB                                     ; B691: E6 BB       ..
    JMP CB647                                     ; B693: 4C 47 B6    LG.

.CB696
    LDY L009C                                     ; B696: A4 9C       ..
    RTS                                           ; B698: 60          `

.CB699
    TYA                                           ; B699: 98          .
    CLC                                           ; B69A: 18          .
    ADC #&25 ; '%'                                ; B69B: 69 25       i%
    STA (L00BA,X)                                 ; B69D: 81 BA       ..
    JMP loop_CB689                                ; B69F: 4C 89 B6    L..

.sub_CB6A2
    STX R                                         ; B6A2: 86 98       ..
    STY L009C                                     ; B6A4: 84 9C       ..
    LSR A                                         ; B6A6: 4A          J
    LSR A                                         ; B6A7: 4A          J
    LSR A                                         ; B6A8: 4A          J
    CLC                                           ; B6A9: 18          .
    ADC LDA18,Y                                   ; B6AA: 79 18 DA    y..
    STA L00BA                                     ; B6AD: 85 BA       ..
    LDA L00E6                                     ; B6AF: A5 E6       ..
    ADC LDAF8,Y                                   ; B6B1: 79 F8 DA    y..
    STA L00BB                                     ; B6B4: 85 BB       ..
    TYA                                           ; B6B6: 98          .
    AND #7                                        ; B6B7: 29 07       ).
    TAY                                           ; B6B9: A8          .
.CB6BA
    LDA L00E9                                     ; B6BA: A5 E9       ..
    BPL CB6C7                                     ; B6BC: 10 09       ..
    LDA PPUSTATUS                                 ; B6BE: AD 02 20    ..
    ASL A                                         ; B6C1: 0A          .
    BPL CB6C7                                     ; B6C2: 10 03       ..
    JSR NAMETABLE0                                ; B6C4: 20 6D D0     m.
.CB6C7
    LDX #0                                        ; B6C7: A2 00       ..
    LDA (L00BA,X)                                 ; B6C9: A1 BA       ..
    BEQ CB70B                                     ; B6CB: F0 3E       .>
    LDX L00B9                                     ; B6CD: A6 B9       ..
    STX SC_1                                      ; B6CF: 86 08       ..
    ASL A                                         ; B6D1: 0A          .
    ROL SC_1                                      ; B6D2: 26 08       &.
    ASL A                                         ; B6D4: 0A          .
    ROL SC_1                                      ; B6D5: 26 08       &.
    ASL A                                         ; B6D7: 0A          .
    ROL SC_1                                      ; B6D8: 26 08       &.
    STA SC                                        ; B6DA: 85 07       ..
    LDA (SC),Y                                    ; B6DC: B1 07       ..
    BEQ CB6F8                                     ; B6DE: F0 18       ..
    LDA #1                                        ; B6E0: A9 01       ..
.loop_CB6E2
    STA T                                         ; B6E2: 85 9A       ..
    AND (SC),Y                                    ; B6E4: 31 07       1.
    BNE CB6EF                                     ; B6E6: D0 07       ..
    LDA T                                         ; B6E8: A5 9A       ..
    SEC                                           ; B6EA: 38          8
    ROL A                                         ; B6EB: 2A          *
    JMP loop_CB6E2                                ; B6EC: 4C E2 B6    L..

.CB6EF
    LDA T                                         ; B6EF: A5 9A       ..
    ORA (SC),Y                                    ; B6F1: 11 07       ..
    STA (SC),Y                                    ; B6F3: 91 07       ..
.loop_CB6F5
    LDY L009C                                     ; B6F5: A4 9C       ..
    RTS                                           ; B6F7: 60          `

.CB6F8
    LDA #&FF                                      ; B6F8: A9 FF       ..
    STA (SC),Y                                    ; B6FA: 91 07       ..
.loop_CB6FC
    DEC R                                         ; B6FC: C6 98       ..
    BEQ loop_CB6F5                                ; B6FE: F0 F5       ..
    LDA L00BA                                     ; B700: A5 BA       ..
    BNE CB706                                     ; B702: D0 02       ..
    DEC L00BB                                     ; B704: C6 BB       ..
.CB706
    DEC L00BA                                     ; B706: C6 BA       ..
    JMP CB6BA                                     ; B708: 4C BA B6    L..

.CB70B
    TYA                                           ; B70B: 98          .
    CLC                                           ; B70C: 18          .
    ADC #&25 ; '%'                                ; B70D: 69 25       i%
    STA (L00BA,X)                                 ; B70F: 81 BA       ..
    JMP loop_CB6FC                                ; B711: 4C FC B6    L..

.HATB
    EQUB   9, &54, &3B, &0A, &82, &B0,   0,   0   ; B714: 09 54 3B... .T;
    EQUB   0,   5, &50, &11,   5, &D1, &28,   5   ; B71C: 00 05 50... ..P
    EQUB &40,   6, &10, &60, &90, &13, &10, &D1   ; B724: 40 06 10... @..
    EQUB   0,   0,   0, &10, &51, &F8, &13, &60   ; B72C: 00 00 00... ...
    EQUB &75,   0,   0,   0                       ; B734: 75 00 00... u..

; ******************************************************************************
.HALL
    LDA #0                                        ; B738: A9 00       ..
    JSR TT66                                      ; B73A: 20 6E F2     n.
    LDA L03F1                                     ; B73D: AD F1 03    ...
    STA L0003                                     ; B740: 85 03       ..
    LDA #&86                                      ; B742: A9 86       ..
    STA L0005                                     ; B744: 85 05       ..
    LDA L039F                                     ; B746: AD 9F 03    ...
    STA L0002                                     ; B749: 85 02       ..
    LDA L03DD                                     ; B74B: AD DD 03    ...
    STA L0004                                     ; B74E: 85 04       ..
    JSR DORND                                     ; B750: 20 AD F4     ..
    BPL CB77E                                     ; B753: 10 29       .)
    AND #3                                        ; B755: 29 03       ).
    STA T                                         ; B757: 85 9A       ..
    ASL A                                         ; B759: 0A          .
    ASL A                                         ; B75A: 0A          .
    ASL A                                         ; B75B: 0A          .
    ADC T                                         ; B75C: 65 9A       e.
    TAX                                           ; B75E: AA          .
    LDY #3                                        ; B75F: A0 03       ..
    STY CNT2                                      ; B761: 84 A9       ..
.loop_CB763
    LDY #2                                        ; B763: A0 02       ..
.loop_CB765
    LDA HATB,X                                    ; B765: BD 14 B7    ...
    STA XX15,Y                                    ; B768: 99 71 00    .q.
    INX                                           ; B76B: E8          .
    DEY                                           ; B76C: 88          .
    BPL loop_CB765                                ; B76D: 10 F6       ..
    TXA                                           ; B76F: 8A          .
    PHA                                           ; B770: 48          H
    JSR HAS1                                      ; B771: 20 D4 B7     ..
    PLA                                           ; B774: 68          h
    TAX                                           ; B775: AA          .
    DEC CNT2                                      ; B776: C6 A9       ..
    BNE loop_CB763                                ; B778: D0 E9       ..
    LDY #&80                                      ; B77A: A0 80       ..
    BNE CB794                                     ; B77C: D0 16       ..
.CB77E
    LSR A                                         ; B77E: 4A          J
    STA Y1                                        ; B77F: 85 72       .r
    JSR DORND                                     ; B781: 20 AD F4     ..
    STA XX15                                      ; B784: 85 71       .q
    JSR DORND                                     ; B786: 20 AD F4     ..
    AND #3                                        ; B789: 29 03       ).
    ADC #&11                                      ; B78B: 69 11       i.
    STA X2                                        ; B78D: 85 73       .s
    JSR HAS1                                      ; B78F: 20 D4 B7     ..
    LDY #0                                        ; B792: A0 00       ..
.CB794
    STY HANGFLAG                                  ; B794: 8C 61 05    .a.
    JSR sub_CB579                                 ; B797: 20 79 B5     y.
    LDA #0                                        ; B79A: A9 00       ..
    STA L00D2                                     ; B79C: 85 D2       ..
    LDA #&50 ; 'P'                                ; B79E: A9 50       .P
    STA L00D8                                     ; B7A0: 85 D8       ..
    JMP LF2CE                                     ; B7A2: 4C CE F2    L..

; ******************************************************************************
.ZINF
    LDA L00E9                                     ; B7A5: A5 E9       ..
    BPL CB7B2                                     ; B7A7: 10 09       ..
    LDA PPUSTATUS                                 ; B7A9: AD 02 20    ..
    ASL A                                         ; B7AC: 0A          .
    BPL CB7B2                                     ; B7AD: 10 03       ..
    JSR NAMETABLE0                                ; B7AF: 20 6D D0     m.
.CB7B2
    LDY #&25 ; '%'                                ; B7B2: A0 25       .%
    LDA #0                                        ; B7B4: A9 00       ..
.loop_CB7B6
    STA INWK,Y                                    ; B7B6: 99 09 00    ...
    DEY                                           ; B7B9: 88          .
    BPL loop_CB7B6                                ; B7BA: 10 FA       ..
    LDA L00E9                                     ; B7BC: A5 E9       ..
    BPL CB7C9                                     ; B7BE: 10 09       ..
    LDA PPUSTATUS                                 ; B7C0: AD 02 20    ..
    ASL A                                         ; B7C3: 0A          .
    BPL CB7C9                                     ; B7C4: 10 03       ..
    JSR NAMETABLE0                                ; B7C6: 20 6D D0     m.
.CB7C9
    LDA #&60 ; '`'                                ; B7C9: A9 60       .`
    STA INWK_18                                   ; B7CB: 85 1B       ..
    STA INWK_22                                   ; B7CD: 85 1F       ..
    ORA #&80                                      ; B7CF: 09 80       ..
    STA INWK_14                                   ; B7D1: 85 17       ..
    RTS                                           ; B7D3: 60          `

; ******************************************************************************
.HAS1
    JSR ZINF                                      ; B7D4: 20 A5 B7     ..
    LDA XX15                                      ; B7D7: A5 71       .q
    STA INWK_6                                    ; B7D9: 85 0F       ..
    LSR A                                         ; B7DB: 4A          J
    ROR INWK_2                                    ; B7DC: 66 0B       f.
    LDA Y1                                        ; B7DE: A5 72       .r
    STA INWK                                      ; B7E0: 85 09       ..
    LSR A                                         ; B7E2: 4A          J
    LDA #1                                        ; B7E3: A9 01       ..
    ADC #0                                        ; B7E5: 69 00       i.
    STA INWK_7                                    ; B7E7: 85 10       ..
    LDA #&80                                      ; B7E9: A9 80       ..
    STA INWK_5                                    ; B7EB: 85 0E       ..
    STA RAT2                                      ; B7ED: 85 AF       ..
    LDA #&0B                                      ; B7EF: A9 0B       ..
    STA L002B                                     ; B7F1: 85 2B       .+
    JSR DORND                                     ; B7F3: 20 AD F4     ..
    STA XSAV                                      ; B7F6: 85 9B       ..
.loop_CB7F8
    LDX #&15                                      ; B7F8: A2 15       ..
    LDY #9                                        ; B7FA: A0 09       ..
    JSR MVS5                                      ; B7FC: 20 A2 F1     ..
    LDX #&17                                      ; B7FF: A2 17       ..
    LDY #&0B                                      ; B801: A0 0B       ..
    JSR MVS5                                      ; B803: 20 A2 F1     ..
    LDX #&19                                      ; B806: A2 19       ..
    LDY #&0D                                      ; B808: A0 0D       ..
    JSR MVS5                                      ; B80A: 20 A2 F1     ..
    DEC XSAV                                      ; B80D: C6 9B       ..
    BNE loop_CB7F8                                ; B80F: D0 E7       ..
    LDY X2                                        ; B811: A4 73       .s
    BEQ CB83F                                     ; B813: F0 2A       .*
    TYA                                           ; B815: 98          .
    ASL A                                         ; B816: 0A          .
    TAX                                           ; B817: AA          .
    LDA LC53E,X                                   ; B818: BD 3E C5    .>.
    STA XX0                                       ; B81B: 85 5F       ._
    LDA LC53F,X                                   ; B81D: BD 3F C5    .?.
    STA L0060                                     ; B820: 85 60       .`
    BEQ CB83F                                     ; B822: F0 1B       ..
    LDY #1                                        ; B824: A0 01       ..
    LDA (XX0),Y                                   ; B826: B1 5F       ._
    STA Q                                         ; B828: 85 97       ..
    INY                                           ; B82A: C8          .
    LDA (XX0),Y                                   ; B82B: B1 5F       ._
    STA R                                         ; B82D: 85 98       ..
    JSR LL5                                       ; B82F: 20 55 FA     U.
    LDA #&64 ; 'd'                                ; B832: A9 64       .d
    SBC Q                                         ; B834: E5 97       ..
    LSR A                                         ; B836: 4A          J
    STA INWK_3                                    ; B837: 85 0C       ..
    JSR TIDY                                      ; B839: 20 5C B8     \.
    JMP LL9                                       ; B83C: 4C 70 A0    Lp.

.CB83F
    RTS                                           ; B83F: 60          `

.TI2
    TYA                                           ; B840: 98          .
    LDY #2                                        ; B841: A0 02       ..
    JSR TIS3                                      ; B843: 20 23 B9     #.
    STA INWK_20                                   ; B846: 85 1D       ..
    JMP CB895                                     ; B848: 4C 95 B8    L..

.CB84B
    TAX                                           ; B84B: AA          .
    LDA Y1                                        ; B84C: A5 72       .r
    AND #&60 ; '`'                                ; B84E: 29 60       )`
    BEQ TI2                                       ; B850: F0 EE       ..
    LDA #2                                        ; B852: A9 02       ..
    JSR TIS3                                      ; B854: 20 23 B9     #.
    STA INWK_18                                   ; B857: 85 1B       ..
    JMP CB895                                     ; B859: 4C 95 B8    L..

; ******************************************************************************
.TIDY
    LDA L00E9                                     ; B85C: A5 E9       ..
    BPL CB869                                     ; B85E: 10 09       ..
    LDA PPUSTATUS                                 ; B860: AD 02 20    ..
    ASL A                                         ; B863: 0A          .
    BPL CB869                                     ; B864: 10 03       ..
    JSR NAMETABLE0                                ; B866: 20 6D D0     m.
.CB869
    LDA INWK_10                                   ; B869: A5 13       ..
    STA XX15                                      ; B86B: 85 71       .q
    LDA INWK_12                                   ; B86D: A5 15       ..
    STA Y1                                        ; B86F: 85 72       .r
    LDA INWK_14                                   ; B871: A5 17       ..
    STA X2                                        ; B873: 85 73       .s
    JSR NORM                                      ; B875: 20 F8 FA     ..
    LDA XX15                                      ; B878: A5 71       .q
    STA INWK_10                                   ; B87A: 85 13       ..
    LDA Y1                                        ; B87C: A5 72       .r
    STA INWK_12                                   ; B87E: 85 15       ..
    LDA X2                                        ; B880: A5 73       .s
    STA INWK_14                                   ; B882: 85 17       ..
    LDY #4                                        ; B884: A0 04       ..
    LDA XX15                                      ; B886: A5 71       .q
    AND #&60 ; '`'                                ; B888: 29 60       )`
    BEQ CB84B                                     ; B88A: F0 BF       ..
    LDX #2                                        ; B88C: A2 02       ..
    LDA #0                                        ; B88E: A9 00       ..
    JSR TIS3                                      ; B890: 20 23 B9     #.
    STA INWK_16                                   ; B893: 85 19       ..
.CB895
    LDA L00E9                                     ; B895: A5 E9       ..
    BPL CB8A2                                     ; B897: 10 09       ..
    LDA PPUSTATUS                                 ; B899: AD 02 20    ..
    ASL A                                         ; B89C: 0A          .
    BPL CB8A2                                     ; B89D: 10 03       ..
    JSR NAMETABLE0                                ; B89F: 20 6D D0     m.
.CB8A2
    LDA INWK_16                                   ; B8A2: A5 19       ..
    STA XX15                                      ; B8A4: 85 71       .q
    LDA INWK_18                                   ; B8A6: A5 1B       ..
    STA Y1                                        ; B8A8: 85 72       .r
    LDA INWK_20                                   ; B8AA: A5 1D       ..
    STA X2                                        ; B8AC: 85 73       .s
    JSR NORM                                      ; B8AE: 20 F8 FA     ..
    LDA XX15                                      ; B8B1: A5 71       .q
    STA INWK_16                                   ; B8B3: 85 19       ..
    LDA Y1                                        ; B8B5: A5 72       .r
    STA INWK_18                                   ; B8B7: 85 1B       ..
    LDA X2                                        ; B8B9: A5 73       .s
    STA INWK_20                                   ; B8BB: 85 1D       ..
    LDA INWK_12                                   ; B8BD: A5 15       ..
    STA Q                                         ; B8BF: 85 97       ..
    LDA INWK_20                                   ; B8C1: A5 1D       ..
    JSR MULT12                                    ; B8C3: 20 3C F8     <.
    LDX INWK_14                                   ; B8C6: A6 17       ..
    LDA INWK_18                                   ; B8C8: A5 1B       ..
    JSR TIS1                                      ; B8CA: 20 AE F8     ..
    EOR #&80                                      ; B8CD: 49 80       I.
    STA INWK_22                                   ; B8CF: 85 1F       ..
    LDA L00E9                                     ; B8D1: A5 E9       ..
    BPL CB8DE                                     ; B8D3: 10 09       ..
    LDA PPUSTATUS                                 ; B8D5: AD 02 20    ..
    ASL A                                         ; B8D8: 0A          .
    BPL CB8DE                                     ; B8D9: 10 03       ..
    JSR NAMETABLE0                                ; B8DB: 20 6D D0     m.
.CB8DE
    LDA INWK_16                                   ; B8DE: A5 19       ..
    JSR MULT12                                    ; B8E0: 20 3C F8     <.
    LDX INWK_10                                   ; B8E3: A6 13       ..
    LDA INWK_20                                   ; B8E5: A5 1D       ..
    JSR TIS1                                      ; B8E7: 20 AE F8     ..
    EOR #&80                                      ; B8EA: 49 80       I.
    STA INWK_24                                   ; B8EC: 85 21       .!
    LDA L00E9                                     ; B8EE: A5 E9       ..
    BPL CB8FB                                     ; B8F0: 10 09       ..
    LDA PPUSTATUS                                 ; B8F2: AD 02 20    ..
    ASL A                                         ; B8F5: 0A          .
    BPL CB8FB                                     ; B8F6: 10 03       ..
    JSR NAMETABLE0                                ; B8F8: 20 6D D0     m.
.CB8FB
    LDA INWK_18                                   ; B8FB: A5 1B       ..
    JSR MULT12                                    ; B8FD: 20 3C F8     <.
    LDX INWK_12                                   ; B900: A6 15       ..
    LDA INWK_16                                   ; B902: A5 19       ..
    JSR TIS1                                      ; B904: 20 AE F8     ..
    EOR #&80                                      ; B907: 49 80       I.
    STA INWK_26                                   ; B909: 85 23       .#
    LDA L00E9                                     ; B90B: A5 E9       ..
    BPL CB918                                     ; B90D: 10 09       ..
    LDA PPUSTATUS                                 ; B90F: AD 02 20    ..
    ASL A                                         ; B912: 0A          .
    BPL CB918                                     ; B913: 10 03       ..
    JSR NAMETABLE0                                ; B915: 20 6D D0     m.
.CB918
    LDA #0                                        ; B918: A9 00       ..
    LDX #&0E                                      ; B91A: A2 0E       ..
.loop_CB91C
    STA INWK_9,X                                  ; B91C: 95 12       ..
    DEX                                           ; B91E: CA          .
    DEX                                           ; B91F: CA          .
    BPL loop_CB91C                                ; B920: 10 FA       ..
    RTS                                           ; B922: 60          `

; ******************************************************************************
.TIS3
    STA P_2                                       ; B923: 85 31       .1
    LDA INWK_10,X                                 ; B925: B5 13       ..
    STA Q                                         ; B927: 85 97       ..
    LDA INWK_16,X                                 ; B929: B5 19       ..
    JSR MULT12                                    ; B92B: 20 3C F8     <.
    LDX INWK_10,Y                                 ; B92E: B6 13       ..
    STX Q                                         ; B930: 86 97       ..
    LDA INWK_16,Y                                 ; B932: B9 19 00    ...
    JSR MAD                                       ; B935: 20 6F F8     o.
    STX P                                         ; B938: 86 2F       ./
    LDY P_2                                       ; B93A: A4 31       .1
    LDX INWK_10,Y                                 ; B93C: B6 13       ..
    STX Q                                         ; B93E: 86 97       ..
    EOR #&80                                      ; B940: 49 80       I.
; ******************************************************************************
.DVIDT
    STA P_1                                       ; B942: 85 30       .0
    EOR Q                                         ; B944: 45 97       E.
    AND #&80                                      ; B946: 29 80       ).
    STA T                                         ; B948: 85 9A       ..
    LDA #0                                        ; B94A: A9 00       ..
    LDX #&10                                      ; B94C: A2 10       ..
    ASL P                                         ; B94E: 06 2F       ./
    ROL P_1                                       ; B950: 26 30       &0
    ASL Q                                         ; B952: 06 97       ..
    LSR Q                                         ; B954: 46 97       F.
.loop_CB956
    ROL A                                         ; B956: 2A          *
    CMP Q                                         ; B957: C5 97       ..
    BCC CB95D                                     ; B959: 90 02       ..
    SBC Q                                         ; B95B: E5 97       ..
.CB95D
    ROL P                                         ; B95D: 26 2F       &/
    ROL P_1                                       ; B95F: 26 30       &0
    DEX                                           ; B961: CA          .
    BNE loop_CB956                                ; B962: D0 F2       ..
    LDA P                                         ; B964: A5 2F       ./
    ORA T                                         ; B966: 05 9A       ..
    RTS                                           ; B968: 60          `

.CB969
    LDA #&F0                                      ; B969: A9 F0       ..
    STA L0200,Y                                   ; B96B: 99 00 02    ...
    STA L0204,Y                                   ; B96E: 99 04 02    ...
    STA L0208,Y                                   ; B971: 99 08 02    ...
.CB974
    RTS                                           ; B974: 60          `

    LDA L009E                                     ; B975: A5 9E       ..
    BNE CB974                                     ; B977: D0 FB       ..
    LDX TYPE                                      ; B979: A6 A3       ..
    BMI CB974                                     ; B97B: 30 F7       0.
    LDA L002A                                     ; B97D: A5 2A       .*
    BEQ CB974                                     ; B97F: F0 F3       ..
    TAX                                           ; B981: AA          .
    ASL A                                         ; B982: 0A          .
    ADC L002A                                     ; B983: 65 2A       e*
    ASL A                                         ; B985: 0A          .
    ASL A                                         ; B986: 0A          .
    ADC #&2C ; ','                                ; B987: 69 2C       i,
    TAY                                           ; B989: A8          .
    LDA L037E,X                                   ; B98A: BD 7E 03    .~.
    STA L0202,Y                                   ; B98D: 99 02 02    ...
    LDA INWK_1                                    ; B990: A5 0A       ..
    CMP INWK_4                                    ; B992: C5 0D       ..
    BCS CB998                                     ; B994: B0 02       ..
    LDA INWK_4                                    ; B996: A5 0D       ..
.CB998
    CMP INWK_7                                    ; B998: C5 10       ..
    BCS CB99E                                     ; B99A: B0 02       ..
    LDA INWK_7                                    ; B99C: A5 10       ..
.CB99E
    CMP #&40 ; '@'                                ; B99E: C9 40       .@
    BCS CB969                                     ; B9A0: B0 C7       ..
    STA L00BA                                     ; B9A2: 85 BA       ..
    LDA INWK_1                                    ; B9A4: A5 0A       ..
    ADC INWK_4                                    ; B9A6: 65 0D       e.
    ADC INWK_7                                    ; B9A8: 65 10       e.
    BCS CB969                                     ; B9AA: B0 BD       ..
    SEC                                           ; B9AC: 38          8
    SBC L00BA                                     ; B9AD: E5 BA       ..
    LSR A                                         ; B9AF: 4A          J
    LSR A                                         ; B9B0: 4A          J
    STA L00BB                                     ; B9B1: 85 BB       ..
    LSR A                                         ; B9B3: 4A          J
    LSR A                                         ; B9B4: 4A          J
    ADC L00BB                                     ; B9B5: 65 BB       e.
    ADC L00BA                                     ; B9B7: 65 BA       e.
    CMP #&40 ; '@'                                ; B9B9: C9 40       .@
    BCS CB969                                     ; B9BB: B0 AC       ..
    LDA INWK_1                                    ; B9BD: A5 0A       ..
    CLC                                           ; B9BF: 18          .
    LDX INWK_2                                    ; B9C0: A6 0B       ..
    BPL CB9C8                                     ; B9C2: 10 04       ..
    EOR #&FF                                      ; B9C4: 49 FF       I.
    ADC #1                                        ; B9C6: 69 01       i.
.CB9C8
    ADC #&7C ; '|'                                ; B9C8: 69 7C       i|
    STA L00BA                                     ; B9CA: 85 BA       ..
    LDA INWK_7                                    ; B9CC: A5 10       ..
    LSR A                                         ; B9CE: 4A          J
    LSR A                                         ; B9CF: 4A          J
    CLC                                           ; B9D0: 18          .
    LDX INWK_8                                    ; B9D1: A6 11       ..
    BMI CB9D8                                     ; B9D3: 30 03       0.
    EOR #&FF                                      ; B9D5: 49 FF       I.
    SEC                                           ; B9D7: 38          8
.CB9D8
    ADC #&C7                                      ; B9D8: 69 C7       i.
    STA L00BB                                     ; B9DA: 85 BB       ..
    LDA INWK_4                                    ; B9DC: A5 0D       ..
    CMP #&30 ; '0'                                ; B9DE: C9 30       .0
    BCC CB9E4                                     ; B9E0: 90 02       ..
    LDA #&2F ; '/'                                ; B9E2: A9 2F       ./
.CB9E4
    LSR A                                         ; B9E4: 4A          J
    STA Y1                                        ; B9E5: 85 72       .r
    CLC                                           ; B9E7: 18          .
    BEQ CB9F1                                     ; B9E8: F0 07       ..
    LDX INWK_5                                    ; B9EA: A6 0E       ..
    BPL CB9F1                                     ; B9EC: 10 03       ..
    JMP CBA6C                                     ; B9EE: 4C 6C BA    Ll.

.CB9F1
    LDA L00BB                                     ; B9F1: A5 BB       ..
    SEC                                           ; B9F3: 38          8
    SBC #8                                        ; B9F4: E9 08       ..
    STA L00BB                                     ; B9F6: 85 BB       ..
    LDA Y1                                        ; B9F8: A5 72       .r
    CMP #&10                                      ; B9FA: C9 10       ..
    BCC CBA24                                     ; B9FC: 90 26       .&
    LDA L00BA                                     ; B9FE: A5 BA       ..
    STA L0203,Y                                   ; BA00: 99 03 02    ...
    STA L0207,Y                                   ; BA03: 99 07 02    ...
    LDA L00BB                                     ; BA06: A5 BB       ..
    STA L0200,Y                                   ; BA08: 99 00 02    ...
    SEC                                           ; BA0B: 38          8
    SBC #8                                        ; BA0C: E9 08       ..
    STA L0204,Y                                   ; BA0E: 99 04 02    ...
    LDA L0202,Y                                   ; BA11: B9 02 02    ...
    AND #3                                        ; BA14: 29 03       ).
    STA L0202,Y                                   ; BA16: 99 02 02    ...
    STA L0206,Y                                   ; BA19: 99 06 02    ...
    LDA L00BB                                     ; BA1C: A5 BB       ..
    SBC #&10                                      ; BA1E: E9 10       ..
    STA L00BB                                     ; BA20: 85 BB       ..
    BNE CBA4F                                     ; BA22: D0 2B       .+
.CBA24
    CMP #8                                        ; BA24: C9 08       ..
    BCC CBA47                                     ; BA26: 90 1F       ..
    LDA #&F0                                      ; BA28: A9 F0       ..
    STA L0200,Y                                   ; BA2A: 99 00 02    ...
    LDA L00BA                                     ; BA2D: A5 BA       ..
    STA L0207,Y                                   ; BA2F: 99 07 02    ...
    LDA L00BB                                     ; BA32: A5 BB       ..
    STA L0204,Y                                   ; BA34: 99 04 02    ...
    LDA L0202,Y                                   ; BA37: B9 02 02    ...
    AND #3                                        ; BA3A: 29 03       ).
    STA L0206,Y                                   ; BA3C: 99 06 02    ...
    LDA L00BB                                     ; BA3F: A5 BB       ..
    SBC #8                                        ; BA41: E9 08       ..
    STA L00BB                                     ; BA43: 85 BB       ..
    BNE CBA4F                                     ; BA45: D0 08       ..
.CBA47
    LDA #&F0                                      ; BA47: A9 F0       ..
    STA L0200,Y                                   ; BA49: 99 00 02    ...
    STA L0204,Y                                   ; BA4C: 99 04 02    ...
.CBA4F
    LDA Y1                                        ; BA4F: A5 72       .r
    AND #7                                        ; BA51: 29 07       ).
    CLC                                           ; BA53: 18          .
    ADC #&DB                                      ; BA54: 69 DB       i.
    STA L0209,Y                                   ; BA56: 99 09 02    ...
    LDA L0202,Y                                   ; BA59: B9 02 02    ...
    AND #3                                        ; BA5C: 29 03       ).
    STA L020A,Y                                   ; BA5E: 99 0A 02    ...
    LDA L00BA                                     ; BA61: A5 BA       ..
    STA L020B,Y                                   ; BA63: 99 0B 02    ...
    LDA L00BB                                     ; BA66: A5 BB       ..
    STA L0208,Y                                   ; BA68: 99 08 02    ...
    RTS                                           ; BA6B: 60          `

.CBA6C
    CLC                                           ; BA6C: 18          .
    ADC L00BB                                     ; BA6D: 65 BB       e.
    CMP #&DC                                      ; BA6F: C9 DC       ..
    BCC CBA75                                     ; BA71: 90 02       ..
    LDA #&DC                                      ; BA73: A9 DC       ..
.CBA75
    SEC                                           ; BA75: 38          8
    SBC L00BB                                     ; BA76: E5 BB       ..
    STA Y1                                        ; BA78: 85 72       .r
    CMP #&10                                      ; BA7A: C9 10       ..
    BCC CBAA5                                     ; BA7C: 90 27       .'
    LDA L00BA                                     ; BA7E: A5 BA       ..
    STA L0203,Y                                   ; BA80: 99 03 02    ...
    STA L0207,Y                                   ; BA83: 99 07 02    ...
    LDA L00BB                                     ; BA86: A5 BB       ..
    STA L0200,Y                                   ; BA88: 99 00 02    ...
    CLC                                           ; BA8B: 18          .
    ADC #8                                        ; BA8C: 69 08       i.
    STA L0204,Y                                   ; BA8E: 99 04 02    ...
    LDA L0202,Y                                   ; BA91: B9 02 02    ...
    ORA #&20 ; ' '                                ; BA94: 09 20       .
    STA L0202,Y                                   ; BA96: 99 02 02    ...
    STA L0206,Y                                   ; BA99: 99 06 02    ...
    LDA L00BB                                     ; BA9C: A5 BB       ..
    CLC                                           ; BA9E: 18          .
    ADC #&10                                      ; BA9F: 69 10       i.
    STA L00BB                                     ; BAA1: 85 BB       ..
    BNE CBAD0                                     ; BAA3: D0 2B       .+
.CBAA5
    CMP #8                                        ; BAA5: C9 08       ..
    BCC CBAC8                                     ; BAA7: 90 1F       ..
    LDA #&F0                                      ; BAA9: A9 F0       ..
    STA L0200,Y                                   ; BAAB: 99 00 02    ...
    LDA L00BA                                     ; BAAE: A5 BA       ..
    STA L0207,Y                                   ; BAB0: 99 07 02    ...
    LDA L00BB                                     ; BAB3: A5 BB       ..
    STA L0204,Y                                   ; BAB5: 99 04 02    ...
    LDA L0202,Y                                   ; BAB8: B9 02 02    ...
    ORA #&20 ; ' '                                ; BABB: 09 20       .
    STA L0206,Y                                   ; BABD: 99 06 02    ...
    LDA L00BB                                     ; BAC0: A5 BB       ..
    ADC #7                                        ; BAC2: 69 07       i.
    STA L00BB                                     ; BAC4: 85 BB       ..
    BNE CBAD0                                     ; BAC6: D0 08       ..
.CBAC8
    LDA #&F0                                      ; BAC8: A9 F0       ..
    STA L0200,Y                                   ; BACA: 99 00 02    ...
    STA L0204,Y                                   ; BACD: 99 04 02    ...
.CBAD0
    LDA Y1                                        ; BAD0: A5 72       .r
    AND #7                                        ; BAD2: 29 07       ).
    CLC                                           ; BAD4: 18          .
    ADC #&DB                                      ; BAD5: 69 DB       i.
    STA L0209,Y                                   ; BAD7: 99 09 02    ...
    LDA L0202,Y                                   ; BADA: B9 02 02    ...
    ORA #&E0                                      ; BADD: 09 E0       ..
    STA L020A,Y                                   ; BADF: 99 0A 02    ...
    LDA L00BA                                     ; BAE2: A5 BA       ..
    STA L020B,Y                                   ; BAE4: 99 0B 02    ...
    LDA L00BB                                     ; BAE7: A5 BB       ..
    STA L0208,Y                                   ; BAE9: 99 08 02    ...
    RTS                                           ; BAEC: 60          `

.sub_CBAED
    LDA #0                                        ; BAED: A9 00       ..
    LDY #&21 ; '!'                                ; BAEF: A0 21       .!
    STA (INF),Y                                   ; BAF1: 91 61       .a
    LDA L00E9                                     ; BAF3: A5 E9       ..
    BPL CBB00                                     ; BAF5: 10 09       ..
    LDA PPUSTATUS                                 ; BAF7: AD 02 20    ..
    ASL A                                         ; BAFA: 0A          .
    BPL CBB00                                     ; BAFB: 10 03       ..
    JSR NAMETABLE0                                ; BAFD: 20 6D D0     m.
.CBB00
    LDX L002A                                     ; BB00: A6 2A       .*
    BEQ CBB23                                     ; BB02: F0 1F       ..
    LDA #0                                        ; BB04: A9 00       ..
    STA L0374,X                                   ; BB06: 9D 74 03    .t.
    TXA                                           ; BB09: 8A          .
    ASL A                                         ; BB0A: 0A          .
    ADC L002A                                     ; BB0B: 65 2A       e*
    ASL A                                         ; BB0D: 0A          .
    ASL A                                         ; BB0E: 0A          .
    TAX                                           ; BB0F: AA          .
    LDA L009E                                     ; BB10: A5 9E       ..
    BNE CBB1F                                     ; BB12: D0 0B       ..
    LDA #&F0                                      ; BB14: A9 F0       ..
    STA L022C,X                                   ; BB16: 9D 2C 02    .,.
    STA L0230,X                                   ; BB19: 9D 30 02    .0.
    STA L0234,X                                   ; BB1C: 9D 34 02    .4.
.CBB1F
    LDA #0                                        ; BB1F: A9 00       ..
    STA L002A                                     ; BB21: 85 2A       .*
.CBB23
    RTS                                           ; BB23: 60          `

.CBB24
    LDY #0                                        ; BB24: A0 00       ..
    STY L03E6                                     ; BB26: 8C E6 03    ...
    LDA L040A                                     ; BB29: AD 0A 04    ...
    STA Q                                         ; BB2C: 85 97       ..
    LDA L002B                                     ; BB2E: A5 2B       .+
    BPL CBB34                                     ; BB30: 10 02       ..
    EOR #&FF                                      ; BB32: 49 FF       I.
.CBB34
    LSR A                                         ; BB34: 4A          J
    LSR A                                         ; BB35: 4A          J
    LSR A                                         ; BB36: 4A          J
    LSR A                                         ; BB37: 4A          J
    ORA #1                                        ; BB38: 09 01       ..
    STA U                                         ; BB3A: 85 96       ..
    LDY #7                                        ; BB3C: A0 07       ..
    LDA (XX0),Y                                   ; BB3E: B1 5F       ._
    STA TGT                                       ; BB40: 85 A6       ..
    LDA L0003                                     ; BB42: A5 03       ..
    PHA                                           ; BB44: 48          H
    LDY #6                                        ; BB45: A0 06       ..
.CBB47
    LDX #3                                        ; BB47: A2 03       ..
.loop_CBB49
    INY                                           ; BB49: C8          .
    LDA L00F9,Y                                   ; BB4A: B9 F9 00    ...
    STA XX2,X                                     ; BB4D: 95 3D       .=
    DEX                                           ; BB4F: CA          .
    BPL loop_CBB49                                ; BB50: 10 F7       ..
    STY CNT                                       ; BB52: 84 A8       ..
    LDA L03E6                                     ; BB54: AD E6 03    ...
    CLC                                           ; BB57: 18          .
    ADC #4                                        ; BB58: 69 04       i.
    CMP #&10                                      ; BB5A: C9 10       ..
    BCS CBB8D                                     ; BB5C: B0 2F       ./
    STA L03E6                                     ; BB5E: 8D E6 03    ...
    TAY                                           ; BB61: A8          .
    LDA XX2                                       ; BB62: A5 3D       .=
    ORA L003F                                     ; BB64: 05 3F       .?
    BNE CBB7C                                     ; BB66: D0 14       ..
    LDA L0040                                     ; BB68: A5 40       .@
    SBC #3                                        ; BB6A: E9 03       ..
    BCC CBB7C                                     ; BB6C: 90 0E       ..
    STA L02EB,Y                                   ; BB6E: 99 EB 02    ...
    LDA #2                                        ; BB71: A9 02       ..
    STA L02EA,Y                                   ; BB73: 99 EA 02    ...
    LDA L003E                                     ; BB76: A5 3E       .>
    CMP #&80                                      ; BB78: C9 80       ..
    BCC CBB83                                     ; BB7A: 90 07       ..
.CBB7C
    LDA #&F0                                      ; BB7C: A9 F0       ..
    STA L02E8,Y                                   ; BB7E: 99 E8 02    ...
    BNE CBB8D                                     ; BB81: D0 0A       ..
.CBB83
    ADC #&0A                                      ; BB83: 69 0A       i.
    STA L02E8,Y                                   ; BB85: 99 E8 02    ...
    LDA #&F5                                      ; BB88: A9 F5       ..
    STA L02E9,Y                                   ; BB8A: 99 E9 02    ...
.CBB8D
    LDY #&25 ; '%'                                ; BB8D: A0 25       .%
    LDA (INF),Y                                   ; BB8F: B1 61       .a
    EOR CNT                                       ; BB91: 45 A8       E.
    STA L0002                                     ; BB93: 85 02       ..
    INY                                           ; BB95: C8          .
    LDA (INF),Y                                   ; BB96: B1 61       .a
    EOR CNT                                       ; BB98: 45 A8       E.
    STA L0003                                     ; BB9A: 85 03       ..
    INY                                           ; BB9C: C8          .
    LDA (INF),Y                                   ; BB9D: B1 61       .a
    EOR CNT                                       ; BB9F: 45 A8       E.
    STA L0004                                     ; BBA1: 85 04       ..
    INY                                           ; BBA3: C8          .
    LDA (INF),Y                                   ; BBA4: B1 61       .a
    EOR CNT                                       ; BBA6: 45 A8       E.
    STA L0005                                     ; BBA8: 85 05       ..
    LDY U                                         ; BBAA: A4 96       ..
.CBBAC
    LDA L00E9                                     ; BBAC: A5 E9       ..
    BPL CBBB9                                     ; BBAE: 10 09       ..
    LDA PPUSTATUS                                 ; BBB0: AD 02 20    ..
    ASL A                                         ; BBB3: 0A          .
    BPL CBBB9                                     ; BBB4: 10 03       ..
    JSR NAMETABLE0                                ; BBB6: 20 6D D0     m.
.CBBB9
    JSR LF4AC                                     ; BBB9: 20 AC F4     ..
    STA ZZ                                        ; BBBC: 85 A0       ..
    LDA L003E                                     ; BBBE: A5 3E       .>
    STA R                                         ; BBC0: 85 98       ..
    LDA XX2                                       ; BBC2: A5 3D       .=
    JSR sub_CAA21                                 ; BBC4: 20 21 AA     !.
    BNE CBBF4                                     ; BBC7: D0 2B       .+
    CPX Yx2M1                                     ; BBC9: E4 B3       ..
    BCS CBBF4                                     ; BBCB: B0 27       .'
    STX Y1                                        ; BBCD: 86 72       .r
    LDA L0040                                     ; BBCF: A5 40       .@
    STA R                                         ; BBD1: 85 98       ..
    LDA L003F                                     ; BBD3: A5 3F       .?
    JSR sub_CAA21                                 ; BBD5: 20 21 AA     !.
    BNE CBBDF                                     ; BBD8: D0 05       ..
    LDA Y1                                        ; BBDA: A5 72       .r
    JSR LE4F0                                     ; BBDC: 20 F0 E4     ..
.CBBDF
    DEY                                           ; BBDF: 88          .
    BPL CBBAC                                     ; BBE0: 10 CA       ..
    LDY CNT                                       ; BBE2: A4 A8       ..
    CPY TGT                                       ; BBE4: C4 A6       ..
    BCS CBBEB                                     ; BBE6: B0 03       ..
    JMP CBB47                                     ; BBE8: 4C 47 BB    LG.

.CBBEB
    PLA                                           ; BBEB: 68          h
    STA L0003                                     ; BBEC: 85 03       ..
    LDA L0606                                     ; BBEE: AD 06 06    ...
    STA L0005                                     ; BBF1: 85 05       ..
    RTS                                           ; BBF3: 60          `

.CBBF4
    JSR LF4AC                                     ; BBF4: 20 AC F4     ..
    JMP CBBDF                                     ; BBF7: 4C DF BB    L..

; ******************************************************************************
.PIXEL2
    STY T1                                        ; BBFA: 84 06       ..
    TYA                                           ; BBFC: 98          .
    ASL A                                         ; BBFD: 0A          .
    ASL A                                         ; BBFE: 0A          .
    TAY                                           ; BBFF: A8          .
    LDA #&D2                                      ; BC00: A9 D2       ..
    LDX ZZ                                        ; BC02: A6 A0       ..
    CPX #&18                                      ; BC04: E0 18       ..
    ADC #0                                        ; BC06: 69 00       i.
    CPX #&30 ; '0'                                ; BC08: E0 30       .0
    ADC #0                                        ; BC0A: 69 00       i.
    CPX #&70 ; 'p'                                ; BC0C: E0 70       .p
    ADC #0                                        ; BC0E: 69 00       i.
    CPX #&90                                      ; BC10: E0 90       ..
    ADC #0                                        ; BC12: 69 00       i.
    STA L0295,Y                                   ; BC14: 99 95 02    ...
    LDA XX15                                      ; BC17: A5 71       .q
    BPL CBC20                                     ; BC19: 10 05       ..
    EOR #&7F                                      ; BC1B: 49 7F       I.
    CLC                                           ; BC1D: 18          .
    ADC #1                                        ; BC1E: 69 01       i.
.CBC20
    EOR #&80                                      ; BC20: 49 80       I.
    SBC #3                                        ; BC22: E9 03       ..
    CMP #&F4                                      ; BC24: C9 F4       ..
    BCS CBC49                                     ; BC26: B0 21       .!
    STA L0297,Y                                   ; BC28: 99 97 02    ...
    LDA Y1                                        ; BC2B: A5 72       .r
    AND #&7F                                      ; BC2D: 29 7F       ).
    CMP L00B1                                     ; BC2F: C5 B1       ..
    BCS CBC49                                     ; BC31: B0 16       ..
    LDA Y1                                        ; BC33: A5 72       .r
    BPL CBC3B                                     ; BC35: 10 04       ..
    EOR #&7F                                      ; BC37: 49 7F       I.
    ADC #1                                        ; BC39: 69 01       i.
.CBC3B
    STA T                                         ; BC3B: 85 9A       ..
    LDA L00B1                                     ; BC3D: A5 B1       ..
    SBC T                                         ; BC3F: E5 9A       ..
    ADC #&0A                                      ; BC41: 69 0A       i.
    STA L0294,Y                                   ; BC43: 99 94 02    ...
    LDY T1                                        ; BC46: A4 06       ..
    RTS                                           ; BC48: 60          `

.CBC49
    LDA #&F0                                      ; BC49: A9 F0       ..
    STA L0294,Y                                   ; BC4B: 99 94 02    ...
    LDY T1                                        ; BC4E: A4 06       ..
    RTS                                           ; BC50: 60          `

    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC51: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC59: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC61: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC69: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC71: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC79: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC81: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC89: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC91: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BC99: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCA1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCA9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCB1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCB9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCC1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCC9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCD1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCD9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCE1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCE9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCF1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BCF9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD01: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD09: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD11: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD19: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD21: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD29: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD31: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD39: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD41: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD49: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD51: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD59: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD61: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD69: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD71: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD79: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD81: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD89: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD91: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BD99: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDA1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDA9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDB1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDB9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDC1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDC9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDD1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDD9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDE1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDE9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDF1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BDF9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE01: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE09: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE11: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE19: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE21: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE29: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE31: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE39: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE41: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE49: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE51: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE59: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE61: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE69: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE71: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE79: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE81: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE89: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE91: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BE99: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEA1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEA9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEB1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEB9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEC1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEC9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BED1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BED9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEE1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEE9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEF1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BEF9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF01: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF09: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF11: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF19: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF21: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF29: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF31: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF39: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF41: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF49: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF51: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF59: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF61: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF69: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF71: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF79: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF81: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF89: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF91: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BF99: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFA1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFA9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFB1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFB9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFC1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFC9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFD1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFD9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFE1: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFE9: FF FF FF... ...
    EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF   ; BFF1: FF FF FF... ...
    EQUB &FF,   7, &C0,   0, &C0,   7, &C0        ; BFF9: FF 07 C0... ...
.pydis_end



\ ******************************************************************************
\
\ Save bank1.bin
\
\ ******************************************************************************

 PRINT "S.bank1.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank1.bin", CODE%, P%, LOAD%
