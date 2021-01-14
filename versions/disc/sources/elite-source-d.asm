INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

LS% = &0CFF             \ The start of the descending ship line heap

NOST = 18               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe (counting from 0, so there are actually 13
                        \ ship slots)

NTY = 31                \ The number of different ship types

MSL = 1                 \ Ship type for a missile
SST = 2                 \ Ship type for a Coriolis space station
ESC = 3                 \ Ship type for an escape pod
PLT = 4                 \ Ship type for an alloy plate
OIL = 5                 \ Ship type for a cargo canister
AST = 7                 \ Ship type for an asteroid
SPL = 8                 \ Ship type for a splinter
SHU = 9                 \ Ship type for a shuttle
CYL = 11                \ Ship type for a Cobra Mk III
ANA = 14                \ Ship type for an Anaconda
HER = 15                \ Ship type for a rock hermit (asteroid)
COPS = 16               \ Ship type for a Viper
SH3 = 17                \ Ship type for a Sidewinder
KRA = 19                \ Ship type for a Krait
ADA = 20                \ Ship type for a Adder
WRM = 23                \ Ship type for a Worm
CYL2 = 24               \ Ship type for a Cobra Mk III (pirate)
ASP = 25                \ Ship type for an Asp Mk II
THG = 29                \ Ship type for a Thargoid
TGL = 30                \ Ship type for a Thargon
CON = 31                \ Ship type for a Constrictor
LGO = 32                \ Ship type for the Elite logo
COU = 33                \ Ship type for a Cougar
DOD = 34                \ Ship type for a Dodecahedron ("Dodo") space station

JL = ESC                \ Junk is defined as starting from the escape pod

JH = SHU+2              \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ shuttle, transporter

PACK = SH3              \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

NI% = 37                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSFILE = &FFDD          \ The address for the OSFILE routine
SCLI = &FFF7            \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

VSCAN = 57              \ Defines the split position in the split-screen mode

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &20                \ Internal key number for red key f0 (Launch, Front)
f1 = &71                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &72                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &73                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &14                \ Internal key number for red key f4 (Long-range Chart)
f5 = &74                \ Internal key number for red key f5 (Short-range Chart)
f6 = &75                \ Internal key number for red key f6 (Data on System)
f7 = &16                \ Internal key number for red key f7 (Market Price)
f8 = &76                \ Internal key number for red key f8 (Status Mode)
f9 = &77                \ Internal key number for red key f9 (Inventory)

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/6502sp/main/workspace/up.asm"

QQ18 = &0400
SNE = &07C0
ACT = &07E0
QQ16 = &0880
XX21 = &5600

INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

L0D7A = &0D7A
L11D5 = &11D5
L5607 = &5607
L563D = &563D
L6CA9 = &6CA9
L6FA9 = &6FA9

E% = &563E

LFFFD = &FFFD

        org     $11E3
.x11E3
        JMP     scramble

        JMP     scramble

        JMP     TT26

        EQUB    $4B,$11

.L11EE
        JMP     L11D5

.L11F1
        LDX     #$F8
        LDY     #$11
        JSR     SCLI

.L11F8
        EQUS    "L.T.CODE"

        EQUB    $0D

.scramble
        LDY     #$00
        STY     SC
        LDX     #$13
.L1207
        STX     SCH
        TYA
        EOR     (SC),Y
        EOR     #$33
        STA     (SC),Y
        DEY
        BNE     L1207

        INX
        CPX     #$56
        BNE     L1207

        JMP     RSHIPS

.DOENTRY
        LDA     #$52
        STA     L11F8
.DEATH2
        JSR     RES2

        JSR     L0D7A

        BNE     L11F1

INCLUDE "library/common/main/subroutine/main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_3_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_4_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_5_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_6_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_7_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_8_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_9_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_10_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_11_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_12_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_13_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_14_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_15_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_16_of_16.asm"
INCLUDE "library/6502sp/main/subroutine/spin.asm"
INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"

        LDA     #$0F
        TAX
        JMP     OSBYTE

INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/cassette/main/subroutine/px3.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/cassette/main/subroutine/pixel.asm"
INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/subroutine/flip.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/mas1.asm"
INCLUDE "library/common/main/subroutine/mas2.asm"
INCLUDE "library/common/main/subroutine/mas3.asm"
INCLUDE "library/common/main/subroutine/status.asm"
INCLUDE "library/common/main/subroutine/plf2.asm"
INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/common/main/subroutine/tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_7_of_7.asm"
INCLUDE "library/6502sp/main/subroutine/dockit.asm"
INCLUDE "library/6502sp/main/subroutine/vcsu1.asm"
INCLUDE "library/6502sp/main/subroutine/vcsub.asm"
INCLUDE "library/common/main/subroutine/tas1.asm"
INCLUDE "library/6502sp/main/subroutine/tas4.asm"
INCLUDE "library/6502sp/main/subroutine/tas6.asm"
INCLUDE "library/6502sp/main/subroutine/dcs1.asm"
INCLUDE "library/common/main/subroutine/hitch.asm"
INCLUDE "library/common/main/subroutine/frs1.asm"
INCLUDE "library/common/main/subroutine/frmis.asm"
INCLUDE "library/common/main/subroutine/angry.asm"
INCLUDE "library/common/main/subroutine/fr1.asm"
INCLUDE "library/common/main/subroutine/sescp.asm"
INCLUDE "library/common/main/subroutine/sfs1.asm"
INCLUDE "library/common/main/subroutine/sfs2.asm"
INCLUDE "library/common/main/subroutine/ll164.asm"
INCLUDE "library/common/main/subroutine/laun.asm"
INCLUDE "library/common/main/subroutine/hfs2.asm"
INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/cassette/main/subroutine/unused_duplicate_of_multu.asm"
INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut3.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/tas3.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/common/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"


        EQUB    $8C,$E7,$8D,$ED,$8A,$E6,$C1,$C8
        EQUB    $C8,$8B,$E0,$8A,$E6,$D6,$C5,$C6
        EQUB    $C1,$CA,$95,$9D,$9C,$97

.tnpr
        STA     QQ29
        LDA     #$01
        PHA
        LDX     #$0C
        CPX     QQ29
        BCC     L2B04

.L2AF9
        ADC     QQ20,X
        DEX
        BPL     L2AF9

        CMP     CRGO
        PLA
        RTS

.L2B04
        LDY     QQ29
        LDA     QQ20,Y
        CMP     #$C8
        PLA
        RTS

.TT20
        JSR     L2B11

.L2B11
        JSR     TT54

.TT54
        LDA     QQ15
        CLC
        ADC     QQ15+2
        TAX
        LDA     QQ15+1
        ADC     QQ15+3
        TAY
        LDA     QQ15+2
        STA     QQ15
        LDA     QQ15+3
        STA     QQ15+1
        LDA     QQ15+5
        STA     QQ15+3
        LDA     QQ15+4
        STA     QQ15+2
        CLC
        TXA
        ADC     QQ15+2
        STA     QQ15+4
        TYA
        ADC     QQ15+3
        STA     QQ15+5
        RTS

.TT146
        LDA     QQ8
        ORA     QQ8+1
        BNE     L2B46

        INC     YC
        RTS

.L2B46
        LDA     #$BF
        JSR     TT68

        LDX     QQ8
        LDY     QQ8+1
        SEC
        JSR     pr5

        LDA     #$C3
.TT60
        JSR     TT27

.TTX69
        INC     YC
.TT69
        LDA     #$80
        STA     K5
.TT67
        LDA     #$0C
        JMP     TT27

.L2B65
        LDA     #$AD
        JSR     TT27

        JMP     TT72

.spc
        JSR     TT27

        JMP     TT162

.TT25
        LDA     #$01
        JSR     TT66

        LDA     #$09
        STA     XC
        LDA     #$A3
        JSR     TT27

        JSR     NLIN

        JSR     TTX69

        INC     YC
        JSR     TT146

        LDA     #$C2
        JSR     TT68

        LDA     QQ3
        CLC
        ADC     #$01
        LSR     A
        CMP     #$02
        BEQ     L2B65

        LDA     QQ3
        BCC     L2BA4

        SBC     #$05
        CLC
.L2BA4
        ADC     #$AA
        JSR     TT27

.TT72
        LDA     QQ3
        LSR     A
        LSR     A
        CLC
        ADC     #$A8
        JSR     TT60

        LDA     #$A2
        JSR     TT68

        LDA     QQ4
        CLC
        ADC     #$B1
        JSR     TT60

        LDA     #$C4
        JSR     TT68

        LDX     QQ5
        INX
        CLC
        JSR     pr2

        JSR     TTX69

        LDA     #$C0
        JSR     TT68

        SEC
        LDX     QQ6
        JSR     pr2

        LDA     #$C6
        JSR     TT60

        LDA     #$28
        JSR     TT27

        LDA     QQ15+4
        BMI     L2BF4

        LDA     #$BC
        JSR     TT27

        JMP     TT76

.L2BF4
        LDA     QQ15+5
        LSR     A
        LSR     A
        PHA
        AND     #$07
        CMP     #$03
        BCS     L2C04

        ADC     #$E3
        JSR     spc

.L2C04
        PLA
        LSR     A
        LSR     A
        LSR     A
        CMP     #$06
        BCS     L2C11

        ADC     #$E6
        JSR     spc

.L2C11
        LDA     QQ15+3
        EOR     QQ15+1
        AND     #$07
        STA     QQ19
        CMP     #$06
        BCS     L2C22

        ADC     #$EC
        JSR     spc

.L2C22
        LDA     QQ15+5
        AND     #$03
        CLC
        ADC     QQ19
        AND     #$07
        ADC     #$F2
        JSR     TT27

.TT76
        LDA     #$53
        JSR     TT27

        LDA     #$29
        JSR     TT60

        LDA     #$C1
        JSR     TT68

        LDX     QQ7
        LDY     QQ7+1
        JSR     pr6

        JSR     TT162

        LDA     #$00
        STA     K5
        LDA     #$4D
        JSR     TT27

        LDA     #$E2
        JSR     TT60

        LDA     #$FA
        JSR     TT68

        LDA     QQ15+5
        LDX     QQ15+3
        AND     #$0F
        CLC
        ADC     #$0B
        TAY
        JSR     pr5

        JSR     TT162

        LDA     #$6B
        JSR     TT26

        LDA     #$6D
        JMP     TT26

.TT24
        LDA     QQ15+1
        AND     #$07
        STA     QQ3
        LDA     QQ15+2
        LSR     A
        LSR     A
        LSR     A
        AND     #$07
        STA     QQ4
        LSR     A
        BNE     L2C94

        LDA     QQ3
        ORA     #$02
        STA     QQ3
.L2C94
        LDA     QQ3
        EOR     #$07
        CLC
        STA     QQ5
        LDA     QQ15+3
        AND     #$03
        ADC     QQ5
        STA     QQ5
        LDA     QQ4
        LSR     A
        ADC     QQ5
        STA     QQ5
        ASL     A
        ASL     A
        ADC     QQ3
        ADC     QQ4
        ADC     #$01
        STA     QQ6
        LDA     QQ3
        EOR     #$07
        ADC     #$03
        STA     P
        LDA     QQ4
        ADC     #$04
        STA     Q
        JSR     MULTU

        LDA     QQ6
        STA     Q
        JSR     MULTU

        ASL     P
        ROL     A
        ASL     P
        ROL     A
        ASL     P
        ROL     A
        STA     QQ7+1
        LDA     P
        STA     QQ7
        RTS

.TT22
        LDA     #$40
        JSR     TT66

        LDA     #$07
        STA     XC
        JSR     TT81

        LDA     #$C7
        JSR     TT27

        JSR     NLIN

        LDA     #$98
        JSR     NLIN2

        JSR     TT14

        LDX     #$00
.L2D09
        STX     XSAV
        LDX     QQ15+3
        LDY     QQ15+4
        TYA
        ORA     #$50
        STA     ZZ
        LDA     QQ15+1
        LSR     A
        CLC
        ADC     #$18
        STA     Y1
        JSR     PIXEL

        JSR     TT20

        LDX     XSAV
        INX
        BNE     L2D09

        LDA     QQ9
        STA     QQ19
        LDA     QQ10
        LSR     A
        STA     QQ19+1
        LDA     #$04
        STA     QQ19+2
.TT15
        LDA     #$18
        LDX     QQ11
        BPL     L2D3E

        LDA     #$00
.L2D3E
        STA     K6+2
        LDA     QQ19
        SEC
        SBC     QQ19+2
        BCS     L2D49

        LDA     #$00
.L2D49
        STA     XX15
        LDA     QQ19
        CLC
        ADC     QQ19+2
        BCC     L2D54

        LDA     #$FF
.L2D54
        STA     X2
        LDA     QQ19+1
        CLC
        ADC     K6+2
        STA     Y1
        JSR     HLOIN

        LDA     QQ19+1
        SEC
        SBC     QQ19+2
        BCS     L2D69

        LDA     #$00
.L2D69
        CLC
        ADC     K6+2
        STA     Y1
        LDA     QQ19+1
        CLC
        ADC     QQ19+2
        ADC     K6+2
        CMP     #$98
        BCC     L2D7F

        LDX     QQ11
        BMI     L2D7F

        LDA     #$97
.L2D7F
        STA     Y2
        LDA     QQ19
        STA     XX15
        STA     X2
        JMP     LOIN

.L2D8A
        LDA     #$68
        STA     QQ19
        LDA     #$5A
        STA     QQ19+1
        LDA     #$10
        STA     QQ19+2
        JSR     TT15

        LDA     QQ14
        STA     K
        JMP     TT128

.TT14
        LDA     QQ11
        BMI     L2D8A

        LDA     QQ14
        LSR     A
        LSR     A
        STA     K
        LDA     QQ0
        STA     QQ19
        LDA     QQ1
        LSR     A
        STA     QQ19+1
        LDA     #$07
        STA     QQ19+2
        JSR     TT15

        LDA     QQ19+1
        CLC
        ADC     #$18
        STA     QQ19+1
.TT128
        LDA     QQ19
        STA     K3
        LDA     QQ19+1
        STA     K4
        LDX     #$00
        STX     K4+1
        STX     K3+1
        INX
        STX     LSP
        LDX     #$02
        STX     STP
        JSR     CIRCLE2

        RTS

.TT210
        LDY     #$00
.L2DE0
        STY     QQ29
        LDX     QQ20,Y
        BEQ     L2E0C

        TYA
        ASL     A
        ASL     A
        TAY
        LDA     L461A,Y
        STA     QQ19+1
        TXA
        PHA
        JSR     TT69

        CLC
        LDA     QQ29
        ADC     #$D0
        JSR     TT27

        LDA     #$0E
        STA     XC
        PLA
        TAX
        CLC
        JSR     pr2

        JSR     TT152

.L2E0C
        LDY     QQ29
        INY
        CPY     #$11
        BCC     L2DE0

        RTS

.TT213
        LDA     #$08
        JSR     TT66

        LDA     #$0B
        STA     XC
        LDA     #$A4
        JSR     TT60

        JSR     NLIN4

        JSR     L3366

        LDA     CRGO
        CMP     #$1A
        BCC     L2E35

        LDA     #$6B
        JSR     TT27

.L2E35
        JMP     TT210

.TT16
        TXA
        PHA
        DEY
        TYA
        EOR     #$FF
        PHA
        JSR     WSCAN

        JSR     TT103

        PLA
        STA     K6
        LDA     QQ10
        JSR     TT123

        LDA     K6+1
        STA     QQ10
        STA     QQ19+1
        PLA
        STA     K6
        LDA     QQ9
        JSR     TT123

        LDA     K6+1
        STA     QQ9
        STA     QQ19
.TT103
        LDA     QQ11
        BMI     L2E8C

        LDA     QQ9
        STA     QQ19
        LDA     QQ10
        LSR     A
        STA     QQ19+1
        LDA     #$04
        STA     QQ19+2
        JMP     TT15

.TT123
        STA     K6+1
        CLC
        ADC     K6
        LDX     K6
        BMI     L2E87

        BCC     L2E89

        RTS

.L2E87
        BCC     L2E8B

.L2E89
        STA     K6+1
.L2E8B
        RTS

.L2E8C
        LDA     QQ9
        SEC
        SBC     QQ0
        CMP     #$26
        BCC     L2E9B

        CMP     #$E6
        BCC     L2E8B

.L2E9B
        ASL     A
        ASL     A
        CLC
        ADC     #$68
        STA     QQ19
        LDA     QQ10
        SEC
        SBC     QQ1
        CMP     #$26
        BCC     L2EB1

        CMP     #$DC
        BCC     L2E8B

.L2EB1
        ASL     A
        CLC
        ADC     #$5A
        STA     QQ19+1
        LDA     #$08
        STA     QQ19+2
        JMP     TT15

.TT23
        LDA     #$80
        JSR     TT66

        LDA     #$07
        STA     XC
        LDA     #$BE
        JSR     NLIN3

        JSR     TT14

        JSR     TT103

        JSR     TT81

        LDA     #$00
        STA     XX20
        LDX     #$18
.L2EDB
        STA     XX1,X
        DEX
        BPL     L2EDB

.TT182
        LDA     QQ15+3
        SEC
        SBC     QQ0
        BCS     L2EEC

        EOR     #$FF
        ADC     #$01
.L2EEC
        CMP     #$14
        BCS     L2F60

        LDA     QQ15+1
        SEC
        SBC     QQ1
        BCS     L2EFC

        EOR     #$FF
        ADC     #$01
.L2EFC
        CMP     #$26
        BCS     L2F60

        LDA     QQ15+3
        SEC
        SBC     QQ0
        ASL     A
        ASL     A
        ADC     #$68
        STA     XX12
        LSR     A
        LSR     A
        LSR     A
        STA     XC
        INC     XC
        LDA     QQ15+1
        SEC
        SBC     QQ1
        ASL     A
        ADC     #$5A
        STA     K4
        LSR     A
        LSR     A
        LSR     A
        TAY
        LDX     XX1,Y
        BEQ     L2F31

        INY
        LDX     XX1,Y
        BEQ     L2F31

        DEY
        DEY
        LDX     XX1,Y
        BNE     L2F43

.L2F31
        STY     YC
        CPY     #$03
        BCC     L2F60

        LDA     #$FF
        STA     XX1,Y
        LDA     #$80
        STA     K5
        JSR     cpl

.L2F43
        LDA     #$00
        STA     K3+1
        STA     K4+1
        STA     K+1
        LDA     XX12
        STA     K3
        LDA     QQ15+5
        AND     #$01
        ADC     #$02
        STA     K
        JSR     FLFLLS

        JSR     SUN

        JSR     FLFLLS

.L2F60
        JSR     TT20

        INC     XX20
        BEQ     L2F74

        JMP     TT182

.TT81
        LDX     #$05
.L2F6C
        LDA     QQ21,X
        STA     QQ15,X
        DEX
        BPL     L2F6C

.L2F74
        RTS

.TT111
        JSR     TT81

        LDY     #$7F
        STY     T
        LDA     #$00
        STA     U
.L2F80
        LDA     QQ15+3
        SEC
        SBC     QQ9
        BCS     L2F8C

        EOR     #$FF
        ADC     #$01
.L2F8C
        LSR     A
        STA     S
        LDA     QQ15+1
        SEC
        SBC     QQ10
        BCS     L2F9B

        EOR     #$FF
        ADC     #$01
.L2F9B
        LSR     A
        CLC
        ADC     S
        CMP     T
        BCS     L2FAE

        STA     T
        LDX     #$05
.L2FA7
        LDA     QQ15,X
        STA     QQ19,X
        DEX
        BPL     L2FA7

.L2FAE
        JSR     TT20

        INC     U
        BNE     L2F80

        LDX     #$05
.L2FB7
        LDA     QQ19,X
        STA     QQ15,X
        DEX
        BPL     L2FB7

        LDA     QQ15+1
        STA     QQ10
        LDA     QQ15+3
        STA     QQ9
        SEC
        SBC     QQ0
        BCS     L2FD2

        EOR     #$FF
        ADC     #$01
.L2FD2
        JSR     SQUA2

        STA     K+1
        LDA     P
        STA     K
        LDA     QQ10
        SEC
        SBC     QQ1
        BCS     L2FE8

        EOR     #$FF
        ADC     #$01
.L2FE8
        LSR     A
        JSR     SQUA2

        PHA
        LDA     P
        CLC
        ADC     K
        STA     Q
        PLA
        ADC     K+1
        STA     R
        JSR     LL5

        LDA     Q
        ASL     A
        LDX     #$00
        STX     QQ8+1
        ROL     QQ8+1
        ASL     A
        ROL     QQ8+1
        STA     QQ8
        JMP     TT24

.hyp
        LDA     QQ22+1
        ORA     QQ12
        BNE     L3085

        JSR     CTRL

        BMI     L305E

        LDA     QQ11
        BNE     L3023

        JMP     TTH111

.L3023
        JSR     hm

.TTX111
        LDA     QQ8
        ORA     QQ8+1
        BEQ     L3085

        LDA     #$07
        STA     XC
        LDA     #$17
        STA     YC
        LDA     #$00
        STA     K5
        LDA     #$BD
        JSR     TT27

        LDA     QQ8+1
        BNE     L30B9

        LDA     QQ14
        CMP     QQ8
        BCC     L30B9

        LDA     #$2D
        JSR     TT27

        JSR     cpl

.wW
        LDA     #$0F
        STA     QQ22+1
        STA     QQ22
        TAX
        JMP     ee3

.L305E
        LDX     GHYP
        BEQ     L3085

        INX
        STX     GHYP
        STX     FIST
        JSR     wW

        LDX     #$05
        INC     GCNT
        LDA     GCNT
        AND     #$07
        STA     GCNT
.L307A
        LDA     QQ21,X
        ASL     A
        ROL     QQ21,X
        DEX
        BPL     L307A

.L3084
        LDA     #$60
L3085 = L3084+1
        STA     QQ9
        STA     QQ10
        JSR     TT110

        JSR     TT111

        LDX     #$00
        STX     QQ8
        STX     QQ8+1
        LDA     #$74
        JSR     MESS

.jmp
        LDA     QQ9
        STA     QQ0
        LDA     QQ10
        STA     QQ1
        RTS

.ee3
        LDY     #$01
        STY     XC
        STY     YC
        DEY
.pr6
        CLC
.pr5
        LDA     #$05
        JMP     TT11

.L30B9
        LDA     #$CA
        JSR     TT27

        LDA     #$3F
        JMP     TT27

.TTH111
        JSR     TT111

        JMP     TTX111

.TT151
        PHA
        STA     K6+1
        ASL     A
        ASL     A
        STA     QQ19
        LDA     #$01
        STA     XC
        PLA
        ADC     #$D0
        JSR     TT27

        LDA     #$0E
        STA     XC
        LDX     QQ19
        LDA     L461A,X
        STA     QQ19+1
        LDA     QQ26
        AND     L461C,X
        CLC
        ADC     L4619,X
        STA     QQ24
        JSR     TT152

        JSR     var

        LDA     QQ19+1
        BMI     L3104

        LDA     QQ24
        ADC     K6
        JMP     TT156

.L3104
        LDA     QQ24
        SEC
        SBC     K6
.TT156
        STA     QQ24
        STA     P
        LDA     #$00
        JSR     GC2

        SEC
        JSR     pr5

        LDY     K6+1
        LDA     #$05
        LDX     AVL,Y
        STX     QQ25
        CLC
        BEQ     L312B

        JSR     pr2+2

        JMP     TT152

.L312B
        LDA     XC
        ADC     #$04
        STA     XC
        LDA     #$2D
        BNE     L3144

.TT152
        LDA     QQ19+1
        AND     #$60
        BEQ     L3147

        CMP     #$20
        BEQ     L314E

        JSR     TT16a

.TT162
        LDA     #$20
.L3144
        JMP     TT27

.L3147
        LDA     #$74
        JSR     TT26

        BCC     TT162

.L314E
        LDA     #$6B
        JSR     TT26

.TT16a
        LDA     #$67
        JMP     TT26

.TT163
        LDA     #$11
        STA     XC
        LDA     #$FF
        BNE     L3144

.TT167
        LDA     #$10
        JSR     TT66

        LDA     #$05
        STA     XC
        LDA     #$A7
        JSR     NLIN3

        LDA     #$03
        STA     YC
        JSR     TT163

        LDA     #$00
        STA     QQ29
.L317A
        LDX     #$80
        STX     K5
        JSR     TT151

        INC     YC
        INC     QQ29
        LDA     QQ29
        CMP     #$11
        BCC     L317A

        RTS

.var
        LDA     QQ19+1
        AND     #$1F
        LDY     QQ28
        STA     QQ19+2
        CLC
        LDA     #$00
        STA     AVL+16
.TT153
        DEY
        BMI     L31A5

        ADC     QQ19+2
        JMP     TT153

.L31A5
        STA     K6
        RTS

        JSR     TT111

.L31AB
        JSR     jmp

        LDX     #$05
.L31B0
        LDA     QQ15,X
        STA     QQ2,X
        DEX
        BPL     L31B0

        INX
        STX     EV
        LDA     QQ3
        STA     QQ28
        LDA     QQ5
        STA     tek
        LDA     QQ4
        STA     gov
        JSR     DORND

        STA     QQ26
        LDX     #$00
        STX     XX4
.L31D8
        LDA     L461A,X
        STA     QQ19+1
        JSR     var

        LDA     L461C,X
        AND     QQ26
        CLC
        ADC     L461B,X
        LDY     QQ19+1
        BMI     L31F4

        SEC
        SBC     K6
        JMP     TT158

.L31F4
        CLC
        ADC     K6
.TT158
        BPL     L31FB

        LDA     #$00
.L31FB
        LDY     XX4
        AND     #$3F
        STA     AVL,Y
        INY
        TYA
        STA     XX4
        ASL     A
        ASL     A
        TAX
        CMP     #$3F
        BCC     L31D8

        RTS

.GTHG
        JSR     Ze

        LDA     #$FF
        STA     INWK+32
        LDA     #$1D
        JSR     NWSHP

        LDA     #$1E
        JMP     NWSHP

.L321F
        LSR     COK
        SEC
        ROL     COK
.L3226
        LDA     #$03
        JSR     SHIPinA

        LDA     #$03
        JSR     TT66

        JSR     LL164

        JSR     RES2

        STY     MJ
.L3239
        JSR     GTHG

        LDA     #$03
        CMP     MANY+29
        BCS     L3239

        STA     NOSTM
        LDX     #$00
        JSR     LOOK1

        LDA     QQ1
        EOR     #$1F
        STA     QQ1
        RTS

.TT18
        LDA     QQ14
        SEC
        SBC     QQ8
        STA     QQ14
        LDA     QQ11
        BNE     L3268

        JSR     TT66

        JSR     LL164

.L3268
        JSR     CTRL

        AND     PATG
        BMI     L321F

        JSR     DORND

        CMP     #$FD
        BCS     L3226

        JSR     L31AB

        JSR     RES2

        JSR     SOLAR

        JSR     LSHIPS

        LDA     QQ11
        AND     #$3F
        BNE     L32F0

        JSR     TTX66

        LDA     QQ11
        BNE     L32C8

        INC     QQ11
.TT110
        LDX     QQ12
        BEQ     L32C1

        JSR     LAUN

        JSR     RES2

        JSR     TT111

        INC     INWK+8
        JSR     SOS1

        LDA     #$80
        STA     INWK+8
        INC     INWK+7
        JSR     NWSPS

        LDA     #$0C
        STA     DELTA
        JSR     BAD

        ORA     FIST
        STA     FIST
        LDA     #$FF
        STA     QQ11
        JSR     HFS1

.L32C1
        LDX     #$00
        STX     QQ12
        JMP     LOOK1

.L32C8
        BMI     L32CD

        JMP     TT22

.L32CD
        JMP     TT23

.MCASH
        TXA
        CLC
        ADC     CASH+3
        STA     CASH+3
        TYA
        ADC     CASH+2
        STA     CASH+2
        LDA     CASH+1
        ADC     #$00
        STA     CASH+1
        LDA     CASH
        ADC     #$00
        STA     CASH
        CLC
.L32F0
        RTS

        JSR     MULTU

.GC2
        ASL     P
        ROL     A
        ASL     P
        ROL     A
        TAY
        LDX     P
        RTS

.hm
        JSR     TT103

        JSR     TT111

        JSR     TT103

        JMP     CLYNS

.cpl
        LDX     #$05
.L330C
        LDA     QQ15,X
        STA     QQ19,X
        DEX
        BPL     L330C

        LDY     #$03
        BIT     QQ15
        BVS     L331A

        DEY
.L331A
        STY     T
.L331C
        LDA     QQ15+5
        AND     #$1F
        BEQ     L3327

        ORA     #$80
        JSR     TT27

.L3327
        JSR     TT54

        DEC     T
        BPL     L331C

        LDX     #$05
.L3330
        LDA     QQ19,X
        STA     QQ15,X
        DEX
        BPL     L3330

        RTS

.L3338
        LDY     #$00
.L333A
        LDA     NAME,Y
        CMP     #$0D
        BEQ     L3347

        JSR     TT26

        INY
        BNE     L333A

.L3347
        RTS

.L3348
        JSR     TT62

        JSR     cpl

.TT62
        LDX     #$05
.L3350
        LDA     QQ15,X
        LDY     QQ2,X
        STA     QQ2,X
        STY     QQ15,X
        DEX
        BPL     L3350

        RTS

.L335E
        CLC
        LDX     GCNT
        INX
        JMP     pr2

.L3366
        LDA     #$69
        JSR     TT68

        LDX     QQ14
        SEC
        JSR     pr2

        LDA     #$C3
        JSR     plf

        LDA     #$77
        BNE     TT27

.L337B
        LDX     #$03
.L337D
        LDA     CASH,X
        STA     K,X
        DEX
        BPL     L337D

        LDA     #$09
        STA     U
        SEC
        JSR     BPRNT

        LDA     #$E2
.plf
        JSR     TT27

        JMP     TT67

.TT68
        JSR     TT27

.L3398
        LDA     #$3A
.TT27
        TAX
        BEQ     L337B

        BMI     L3413

        DEX
        BEQ     L335E

        DEX
        BEQ     L3348

        DEX
        BNE     L33AB

        JMP     cpl

.L33AB
        DEX
        BEQ     L3338

        DEX
        BEQ     L3366

        DEX
        BNE     L33B9

        LDA     #$80
        STA     K5
        RTS

.L33B9
        DEX
        DEX
        BNE     L33C0

        STX     K5
        RTS

.L33C0
        DEX
        BEQ     L33FB

        CMP     #$60
        BCS     ex

        CMP     #$0E
        BCC     L33CF

        CMP     #$20
        BCC     L33F7

.L33CF
        LDX     K5
        BEQ     L3410

        BMI     L33E6

        BIT     K5
        BVS     L3409

.L33D9
        CMP     #$41
        BCC     L33E3

        CMP     #$5B
        BCS     L33E3

        ADC     #$20
.L33E3
        JMP     TT26

.L33E6
        BIT     K5
        BVS     L3401

        CMP     #$41
        BCC     L3410

        PHA
        TXA
        ORA     #$40
        STA     K5
        PLA
        BNE     L33E3

.L33F7
        ADC     #$72
        BNE     ex

.L33FB
        LDA     #$15
        STA     XC
        BNE     L3398

.L3401
        CPX     #$FF
        BEQ     L3468

        CMP     #$41
        BCS     L33D9

.L3409
        PHA
        TXA
        AND     #$BF
        STA     K5
        PLA
.L3410
        JMP     TT26

.L3413
        CMP     #$A0
        BCS     L342B

        AND     #$7F
        ASL     A
        TAY
        LDA     QQ16,Y
        JSR     TT27

        LDA     QQ16+1,Y
        CMP     #$3F
        BEQ     L3468

        JMP     TT27

.L342B
        SBC     #$A0
.ex
        TAX
        LDA     #$00
        STA     V
        LDA     #$04
        STA     V+1
        LDY     #$00
        TXA
        BEQ     L344E

.L343B
        LDA     (V),Y
        BEQ     L3446

        INY
        BNE     L343B

        INC     V+1
        BNE     L343B

.L3446
        INY
        BNE     L344B

        INC     V+1
.L344B
        DEX
        BNE     L343B

.L344E
        TYA
        PHA
        LDA     V+1
        PHA
        LDA     (V),Y
        EOR     #$23
        JSR     TT27

        PLA
        STA     V+1
        PLA
        TAY
        INY
        BNE     L3464

        INC     V+1
.L3464
        LDA     (V),Y
        BNE     L344E

.L3468
        RTS

.L3469
        LDA     INWK+31
        ORA     #$A0
        STA     INWK+31
        RTS

.DOEXP
        LDA     INWK+31
        AND     #$40
        BEQ     L3479

        JSR     PTCLS

.L3479
        LDA     INWK+6
        STA     T
        LDA     INWK+7
        CMP     #$20
        BCC     L3487

        LDA     #$FE
        BNE     L348F

.L3487
        ASL     T
        ROL     A
        ASL     T
        ROL     A
        SEC
        ROL     A
.L348F
        STA     Q
        LDY     #$01
        LDA     (INWK+33),Y
        ADC     #$04
        BCS     L3469

        STA     (INWK+33),Y
        JSR     DVID4

        LDA     P
        CMP     #$1C
        BCC     L34A8

        LDA     #$FE
        BNE     L34B1

.L34A8
        ASL     R
        ROL     A
        ASL     R
        ROL     A
        ASL     R
        ROL     A
.L34B1
        DEY
        STA     (INWK+33),Y
        LDA     INWK+31
        AND     #$BF
        STA     INWK+31
        AND     #$08
        BEQ     L3468

        LDY     #$02
        LDA     (INWK+33),Y
        TAY
.L34C3
        LDA     XX3-7,Y
        STA     (INWK+33),Y
        DEY
        CPY     #$06
        BNE     L34C3

        LDA     INWK+31
        ORA     #$40
        STA     INWK+31
.PTCLS
        LDY     #$00
        LDA     (INWK+33),Y
        STA     Q
        INY
        LDA     (INWK+33),Y
        BPL     L34E0

        EOR     #$FF
.L34E0
        LSR     A
        LSR     A
        LSR     A
        ORA     #$01
        STA     U
        INY
        LDA     (INWK+33),Y
        STA     TGT
        LDA     RAND+1
        PHA
        LDY     #$06
.L34F1
        LDX     #$03
.L34F3
        INY
        LDA     (INWK+33),Y
        STA     K3,X
        DEX
        BPL     L34F3

        STY     CNT
        LDY     #$02
.L34FF
        INY
        LDA     (INWK+33),Y
        EOR     CNT
        STA     LFFFD,Y
        CPY     #$06
        BNE     L34FF

        LDY     U
.L350D
        JSR     DORND2

        STA     ZZ
        LDA     K3+1
        STA     R
        LDA     K3
        JSR     EXS1

        BNE     L3545

        CPX     #$BF
        BCS     L3545

        STX     Y1
        LDA     K3+3
        STA     R
        LDA     K3+2
        JSR     EXS1

        BNE     EX4

        LDA     Y1
        JSR     PIXEL

.EX4
        DEY
        BPL     L350D

        LDY     CNT
        CPY     TGT
        BCC     L34F1

        PLA
        STA     RAND+1
        LDA     K%+6
        STA     RAND+3
        RTS

.L3545
        JSR     DORND2

        JMP     EX4

.EXS1
        STA     S
        JSR     DORND2

        ROL     A
        BCS     L355E

        JSR     FMLTU

        ADC     R
        TAX
        LDA     S
        ADC     #$00
        RTS

.L355E
        JSR     FMLTU

        STA     T
        LDA     R
        SBC     T
        TAX
        LDA     S
        SBC     #$00
        RTS

.SOS1
        JSR     msblob

        LDA     #$7F
        STA     INWK+29
        STA     INWK+30
        LDA     tek
        AND     #$02
        ORA     #$80
        JMP     NWSHP

.SOLAR
        LSR     FIST
        JSR     ZINF

        LDA     QQ15+1
        AND     #$03
        ADC     #$03
        STA     INWK+8
        ROR     A
        STA     INWK+2
        STA     INWK+5
        JSR     SOS1

        LDA     QQ15+3
        AND     #$07
        ORA     #$81
        STA     INWK+8
        LDA     QQ15+5
        AND     #$03
        STA     INWK+2
        STA     INWK+1
        LDA     #$00
        STA     INWK+29
        STA     INWK+30
        LDA     #$81
        JSR     NWSHP

.NWSTARS
        LDA     QQ11
        BNE     WPSHPS

.nWq
        LDY     NOSTM
.L35B8
        JSR     DORND

        ORA     #$08
        STA     SZ,Y
        STA     ZZ
        JSR     DORND

        STA     SX,Y
        STA     XX15
        JSR     DORND

        STA     SY,Y
        STA     Y1
        JSR     PIXEL2

        DEY
        BNE     L35B8

.WPSHPS
        LDX     #$00
.L35DA
        LDA     FRIN,X
        BEQ     L3602

        BMI     L35FF

        STA     TYPE
        JSR     GINF

        LDY     #$1F
.L35E8
        LDA     (INF),Y
        STA     XX1,Y
        DEY
        BPL     L35E8

        STX     XSAV
        JSR     SCAN

        LDX     XSAV
        LDY     #$1F
        LDA     (INF),Y
        AND     #$A7
        STA     (INF),Y
.L35FF
        INX
        BNE     L35DA

.L3602
        LDX     #$FF
        STX     LSX2
        STX     LSY2
.FLFLLS
        LDY     #$BF
        LDA     #$00
.L360E
        STA     LSX,Y
        DEY
        BNE     L360E

        DEY
        STY     LSX
        RTS

.DET1
        LDA     #$06
        SEI
        STA     VIA+$00
        STX     VIA+$01
        CLI
        RTS

.L3624
        DEX
        RTS

.SHD
        INX
        BEQ     L3624

.DENGY
        DEC     ENERGY
        PHP
        BNE     L3632

        INC     ENERGY
.L3632
        PLP
        RTS

.COMPAS
        JSR     DOT

        LDA     SSPR
        BNE     L366D

        JSR     SPS1

        JMP     SP2

.SPS2
        ASL     A
        TAX
        LDA     #$00
        ROR     A
        TAY
        LDA     #$14
        STA     Q
        TXA
        JSR     DVID4

        LDX     P
        TYA
        BMI     L3658

        LDY     #$00
        RTS

.L3658
        LDY     #$FF
        TXA
        EOR     #$FF
        TAX
        INX
        RTS

.SPS4
        LDX     #$08
.L3662
        LDA     K%+37,X
        STA     K3,X
        DEX
        BPL     L3662

        JMP     TAS2

.L366D
        JSR     SPS4

.SP2
        LDA     XX15
        JSR     SPS2

        TXA
        ADC     #$C3
        STA     COMX
        LDA     Y1
        JSR     SPS2

        STX     T
        LDA     #$CC
        SBC     T
        STA     COMY
        LDA     #$F0
        LDX     X2
        BPL     L3691

        LDA     #$FF
.L3691
        STA     COMC
.DOT
        LDA     COMY
        STA     Y1
        LDA     COMX
        STA     XX15
        LDA     COMC
        STA     COL
        CMP     #$F0
        BNE     CPIX2

.L36A7
        JSR     CPIX2

        DEC     Y1
.CPIX2
        LDA     Y1
        TAY
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        LDA     XX15
        AND     #$F8
        STA     SC
        TYA
        AND     #$07
        TAY
        LDA     XX15
        AND     #$06
        LSR     A
        TAX
        LDA     CTWOS,X
        AND     COL
        EOR     (SC),Y
        STA     (SC),Y
        LDA     CTWOS+1,X
        BPL     L36DD

        LDA     SC
        ADC     #$08
        STA     SC
        LDA     CTWOS+1,X
.L36DD
        AND     COL
.L36DF
        EOR     (SC),Y
        STA     (SC),Y
        RTS

.OOPS
        STA     T
        LDX     #$00
        LDY     #$08
        LDA     (INF),Y
        BMI     L36FE

        LDA     FSH
        SBC     T
        BCC     L36F9

        STA     FSH
        RTS

.L36F9
        STX     FSH
        BCC     L370C

.L36FE
        LDA     ASH
        SBC     T
        BCC     L3709

        STA     ASH
        RTS

.L3709
        STX     ASH
.L370C
        ADC     ENERGY
        STA     ENERGY
        BEQ     L3716

        BCS     L3719

.L3716
        JMP     DEATH

.L3719
        JSR     EXNO3

        JMP     OUCH

.SPS3
        LDA     K%+1,X
        STA     K3,X
        LDA     K%+2,X
        TAY
        AND     #$7F
        STA     K3+1,X
        TYA
        AND     #$80
        STA     K3+2,X
        RTS

.GINF
        TXA
        ASL     A
        TAY
        LDA     UNIV,Y
        STA     INF
        LDA     UNIV+1,Y
        STA     INF+1
        RTS

.NWSPS
        JSR     SPBLB

        LDX     #$81
        STX     INWK+32
        LDX     #$00
        STX     INWK+30
        STX     NEWB
        STX     FRIN+1
        DEX
        STX     INWK+29
        LDX     #$0A
        JSR     NwS1

        JSR     NwS1

        JSR     NwS1

        LDA     #$00
        STA     INWK+33
        LDA     #$0E
        STA     INWK+34
        LDA     #$02
.NWSHP
        STA     T
        LDX     #$00
.L376C
        LDA     FRIN,X
        BEQ     L3778

        INX
        CPX     #$0C
        BCC     L376C

.L3776
        CLC
.L3777
        RTS

.L3778
        JSR     GINF

        LDA     T
        BMI     L37D1

        ASL     A
        TAY
        LDA     L55FF,Y
        BEQ     L3776

        STA     XX0+1
        LDA     L55FE,Y
        STA     XX0
        CPY     #$04
        BEQ     L37C1

        LDY     #$05
        LDA     (XX0),Y
        STA     T1
        LDA     SLSP
        SEC
        SBC     T1
        STA     INWK+33
        LDA     SLSP+1
        SBC     #$00
        STA     INWK+34
        LDA     INWK+33
        SBC     INF
        TAY
        LDA     INWK+34
        SBC     INF+1
        BCC     L3777

        BNE     L37B7

        CPY     #$25
        BCC     L3777

.L37B7
        LDA     INWK+33
        STA     SLSP
        LDA     INWK+34
        STA     SLSP+1
.L37C1
        LDY     #$0E
        LDA     (XX0),Y
        STA     INWK+35
        LDY     #$13
        LDA     (XX0),Y
        AND     #$07
        STA     INWK+31
        LDA     T
.L37D1
        STA     FRIN,X
        TAX
        BMI     L37E5

        CPX     #$03
        BCC     L37E2

        CPX     #$0B
        BCS     L37E2

        INC     JUNK
.L37E2
        INC     MANY,X
.L37E5
        LDY     T
        LDA     L563D,Y
        AND     #$6F
        ORA     NEWB
        STA     NEWB
        LDY     #$24
.L37F2
        LDA     XX1,Y
        STA     (INF),Y
        DEY
        BPL     L37F2

        SEC
        RTS

.NwS1
        LDA     XX1,X
        EOR     #$80
        STA     XX1,X
        INX
        INX
        RTS

.ABORT
        LDX     #$FF
.ABORT2
        STX     MSTG
        LDX     NOMSL
        JSR     MSBAR

        STY     MSAR
        RTS

.ECBLB2
        LDA     #$20
        STA     ECMA
        ASL     A
        JSR     NOISE

.ECBLB
        LDA     #$38
        LDX     #$32
        BNE     L3825

.SPBLB
        LDA     #$C0
        LDX     #$35
.L3825
        LDY     #$38
        STA     SC
        STX     P+1
        STY     P+2
        LDA     #$7D
        JMP     RREN

.L3832
        EQUB    $E0,$E0,$80

        EQUB    $E0,$E0,$80,$E0,$E0,$20,$E0,$E0

.MSBAR
        TXA
        ASL     A
        ASL     A
        ASL     A
        STA     T
        LDA     #$31
        SBC     T
        STA     SC
        LDA     #$7E
        STA     SCH
        TYA
        LDY     #$05
.L3850
        STA     (SC),Y
        DEY
        BNE     L3850

        RTS

.PROJ
        LDA     XX1
        STA     P
        LDA     INWK+1
        STA     P+1
        LDA     INWK+2
        JSR     PLS6

        BCS     L388D

        LDA     K
        ADC     #$80
        STA     K3
        TXA
        ADC     #$00
        STA     K3+1
        LDA     INWK+3
        STA     P
        LDA     INWK+4
        STA     P+1
        LDA     INWK+5
        EOR     #$80
        JSR     PLS6

        BCS     L388D

        LDA     K
        ADC     #$60
        STA     K4
        TXA
        ADC     #$00
        STA     K4+1
        CLC
.L388D
        RTS

.L388E
        LDA     TYPE
        LSR     A
        BCS     L3896

        JMP     WPLS2

.L3896
        JMP     WPLS

.PLANET
        LDA     INWK+8
        BMI     L388E

        CMP     #$30
        BCS     L388E

        ORA     INWK+7
        BEQ     L388E

        JSR     PROJ

        BCS     L388E

        LDA     #$60
        STA     P+1
        LDA     #$00
        STA     P
        JSR     DVID3B2

        LDA     K+1
        BEQ     L38BD

        LDA     #$F8
        STA     K
.L38BD
        LDA     TYPE
        LSR     A
        BCC     L38C5

        JMP     SUN

.L38C5
        JSR     WPLS2

        JSR     CIRCLE

        BCS     L38D1

        LDA     K+1
        BEQ     L38D2

.L38D1
        RTS

.L38D2
        LDA     TYPE
        CMP     #$80
        BNE     L3914

        LDA     K
        CMP     #$06
        BCC     L38D1

        LDA     INWK+14
        EOR     #$80
        STA     P
        LDA     INWK+20
        JSR     PLS4

        LDX     #$09
        JSR     PLS1

        STA     K2
        STY     XX16
        JSR     PLS1

        STA     K2+1
        STY     XX16+1
        LDX     #$0F
        JSR     PLS5

        JSR     PLS2

        LDA     INWK+14
        EOR     #$80
        STA     P
        LDA     INWK+26
        JSR     PLS4

        LDX     #$15
        JSR     PLS5

        JMP     PLS2

.L3914
        LDA     INWK+20
        BMI     L38D1

        LDX     #$0F
        JSR     PLS3

        CLC
        ADC     K3
        STA     K3
        TYA
        ADC     K3+1
        STA     K3+1
        JSR     PLS3

        STA     P
        LDA     K4
        SEC
        SBC     P
        STA     K4
        STY     P
        LDA     K4+1
        SBC     P
        STA     K4+1
        LDX     #$09
        JSR     PLS1

        LSR     A
        STA     K2
        STY     XX16
        JSR     PLS1

        LSR     A
        STA     K2+1
        STY     XX16+1
        LDX     #$15
        JSR     PLS1

        LSR     A
        STA     K2+2
        STY     XX16+2
        JSR     PLS1

        LSR     A
        STA     K2+3
        STY     XX16+3
        LDA     #$40
        STA     TGT
        LDA     #$00
        STA     CNT2
        BEQ     L398B

.PLS1
        LDA     XX1,X
        STA     P
        LDA     INWK+1,X
        AND     #$7F
        STA     P+1
        LDA     INWK+1,X
        AND     #$80
        JSR     DVID3B2

        LDA     K
        LDY     K+1
        BEQ     L3982

        LDA     #$FE
.L3982
        LDY     K+3
        INX
        INX
        RTS

.PLS2
        LDA     #$1F
        STA     TGT
.L398B
        LDX     #$00
        STX     CNT
        DEX
        STX     FLAG
.PLL4
        LDA     CNT2
        AND     #$1F
        TAX
        LDA     SNE,X
        STA     Q
        LDA     K2+2
        JSR     FMLTU

        STA     R
        LDA     K2+3
        JSR     FMLTU

        STA     K
        LDX     CNT2
        CPX     #$21
        LDA     #$00
        ROR     A
        STA     XX16+5
        LDA     CNT2
        CLC
        ADC     #$10
        AND     #$1F
        TAX
        LDA     SNE,X
        STA     Q
        LDA     K2+1
        JSR     FMLTU

        STA     K+2
        LDA     K2
        JSR     FMLTU

        STA     P
        LDA     CNT2
        ADC     #$0F
        AND     #$3F
        CMP     #$21
        LDA     #$00
        ROR     A
        STA     XX16+4
        LDA     XX16+5
        EOR     XX16+2
        STA     S
        LDA     XX16+4
        EOR     XX16
        JSR     ADD

        STA     T
        BPL     L39FB

        TXA
        EOR     #$FF
        CLC
        ADC     #$01
        TAX
        LDA     T
        EOR     #$7F
        ADC     #$00
        STA     T
.L39FB
        TXA
        ADC     K3
        STA     K6
        LDA     T
        ADC     K3+1
        STA     K6+1
        LDA     K
        STA     R
        LDA     XX16+5
        EOR     XX16+3
        STA     S
        LDA     K+2
        STA     P
        LDA     XX16+4
        EOR     XX16+1
        JSR     ADD

        EOR     #$80
        STA     T
        BPL     L3A30

        TXA
        EOR     #$FF
        CLC
        ADC     #$01
        TAX
        LDA     T
        EOR     #$7F
        ADC     #$00
        STA     T
.L3A30
        JSR     BLINE

        CMP     TGT
        BEQ     L3A39

        BCS     L3A45

.L3A39
        LDA     CNT2
        CLC
        ADC     STP
        AND     #$3F
        STA     CNT2
        JMP     PLL4

.L3A45
        RTS

.L3A46
        JMP     WPLS

.L3A49
        TXA
        EOR     #$FF
        CLC
        ADC     #$01
        TAX
.L3A50
        LDA     #$FF
        BNE     L3A99

.SUN
        LDA     #$01
        STA     LSX
        JSR     CHKON

        BCS     L3A46

        LDA     #$00
        LDX     K
        CPX     #$60
        ROL     A
        CPX     #$28
        ROL     A
        CPX     #$10
        ROL     A
        STA     CNT
        LDA     #$BF
        LDX     P+2
        BNE     L3A7D

        CMP     P+1
        BCC     L3A7D

        LDA     P+1
        BNE     L3A7D

        LDA     #$01
.L3A7D
        STA     TGT
        LDA     #$BF
        SEC
        SBC     K4
        TAX
        LDA     #$00
        SBC     K4+1
        BMI     L3A49

        BNE     L3A95

        INX
        DEX
        BEQ     L3A50

        CPX     K
        BCC     L3A99

.L3A95
        LDX     K
        LDA     #$00
.L3A99
        STX     V
        STA     V+1
        LDA     K
        JSR     SQUA2

        STA     K2+1
        LDA     P
        STA     K2
        LDY     #$BF
        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
.L3AB2
        CPY     TGT
        BEQ     PLFL

        LDA     LSX,Y
        BEQ     L3ABE

        JSR     HLOIN2

.L3ABE
        DEY
        BNE     L3AB2

.PLFL
        LDA     V
        JSR     SQUA2

        STA     T
        LDA     K2
        SEC
        SBC     P
        STA     Q
        LDA     K2+1
        SBC     T
        STA     R
        STY     Y1
        JSR     LL5

        LDY     Y1
        JSR     DORND

        AND     CNT
        CLC
        ADC     Q
        BCC     L3AE8

        LDA     #$FF
.L3AE8
        LDX     LSX,Y
        STA     LSX,Y
        BEQ     L3B3A

        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
        TXA
        JSR     EDGES

        LDA     XX15
        STA     XX
        LDA     X2
        STA     XX+1
        LDA     K3
        STA     YY
        LDA     K3+1
        STA     YY+1
        LDA     LSX,Y
        JSR     EDGES

        BCS     L3B1F

        LDA     X2
        LDX     XX
        STX     X2
        STA     XX
        JSR     HLOIN

.L3B1F
        LDA     XX
        STA     XX15
        LDA     XX+1
        STA     X2
.L3B27
        JSR     HLOIN

.L3B2A
        DEY
        BEQ     L3B6C

        LDA     V+1
        BNE     L3B4E

        DEC     V
        BNE     PLFL

        DEC     V+1
.L3B37
        JMP     PLFL

.L3B3A
        LDX     K3
        STX     YY
        LDX     K3+1
        STX     YY+1
        JSR     EDGES

        BCC     L3B27

        LDA     #$00
        STA     LSX,Y
        BEQ     L3B2A

.L3B4E
        LDX     V
        INX
        STX     V
        CPX     K
        BCC     L3B37

        BEQ     L3B37

        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
.L3B61
        LDA     LSX,Y
        BEQ     L3B69

        JSR     HLOIN2

.L3B69
        DEY
        BNE     L3B61

.L3B6C
        CLC
        LDA     K3
        STA     SUNX
        LDA     K3+1
        STA     SUNX+1
.L3B75
        RTS

.CIRCLE
        JSR     CHKON

        BCS     L3B75

        LDA     #$00
        STA     LSX2
        LDX     K
        LDA     #$08
        CPX     #$08
        BCC     L3B8E

        LSR     A
        CPX     #$3C
        BCC     L3B8E

        LSR     A
.L3B8E
        STA     STP
.CIRCLE2
        LDX     #$FF
        STX     FLAG
        INX
        STX     CNT
.PLL3
        LDA     CNT
        JSR     FMLTU2

        LDX     #$00
        STX     T
        LDX     CNT
        CPX     #$21
        BCC     L3BB3

        EOR     #$FF
        ADC     #$00
        TAX
        LDA     #$FF
        ADC     #$00
        STA     T
        TXA
        CLC
.L3BB3
        ADC     K3
        STA     K6
        LDA     K3+1
        ADC     T
        STA     K6+1
        LDA     CNT
        CLC
        ADC     #$10
        JSR     FMLTU2

        TAX
        LDA     #$00
        STA     T
        LDA     CNT
        ADC     #$0F
        AND     #$3F
        CMP     #$21
        BCC     L3BE1

        TXA
        EOR     #$FF
        ADC     #$00
        TAX
        LDA     #$FF
        ADC     #$00
        STA     T
        CLC
.L3BE1
        JSR     BLINE

        CMP     #$41
        BCS     L3BEB

        JMP     PLL3

.L3BEB
        CLC
        RTS

.WPLS2
        LDY     LSX2
        BNE     L3C26

.WPL1
        CPY     LSP
        BCS     L3C26

        LDA     LSY2,Y
        CMP     #$FF
        BEQ     L3C17

        STA     Y2
        LDA     LSX2,Y
        STA     X2
        JSR     LOIN

        INY
        LDA     SWAP
        BNE     WPL1

        LDA     X2
        STA     XX15
        LDA     Y2
        STA     Y1
        JMP     WPL1

.L3C17
        INY
        LDA     LSX2,Y
        STA     XX15
        LDA     LSY2,Y
        STA     Y1
        INY
        JMP     WPL1

.L3C26
        LDA     #$01
        STA     LSP
        LDA     #$FF
        STA     LSX2
.L3C2F
        RTS

.WPLS
        LDA     LSX
        BMI     L3C2F

        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
        LDY     #$BF
.L3C3F
        LDA     LSX,Y
        BEQ     L3C47

        JSR     HLOIN2

.L3C47
        DEY
        BNE     L3C3F

        DEY
        STY     LSX
        RTS

.EDGES
        STA     T
        CLC
        ADC     YY
        STA     X2
        LDA     YY+1
        ADC     #$00
        BMI     L3C79

        BEQ     L3C62

        LDA     #$FE
        STA     X2
.L3C62
        LDA     YY
        SEC
        SBC     T
        STA     XX15
        LDA     YY+1
        SBC     #$00
        BNE     L3C71

        CLC
        RTS

.L3C71
        BPL     L3C79

        LDA     #$02
        STA     XX15
        CLC
        RTS

.L3C79
        LDA     #$00
        STA     LSX,Y
        SEC
        RTS

.CHKON
        LDA     K3
        CLC
        ADC     K
        LDA     K3+1
        ADC     #$00
        BMI     L3CB8

        LDA     K3
        SEC
        SBC     K
        LDA     K3+1
        SBC     #$00
        BMI     L3C98

        BNE     L3CB8

.L3C98
        LDA     K4
        CLC
        ADC     K
        STA     P+1
        LDA     K4+1
        ADC     #$00
        BMI     L3CB8

        STA     P+2
        LDA     K4
        SEC
        SBC     K
        TAX
        LDA     K4+1
        SBC     #$00
        BMI     L3D1D

        BNE     L3CB8

        CPX     #$BF
        RTS

.L3CB8
        SEC
        RTS

.PLS3
        JSR     PLS1

        STA     P
        LDA     #$DE
        STA     Q
        STX     U
        JSR     MULTU

        LDX     U
        LDY     K+3
        BPL     L3CD8

        EOR     #$FF
        CLC
        ADC     #$01
        BEQ     L3CD8

        LDY     #$FF
        RTS

.L3CD8
        LDY     #$00
        RTS

.PLS4
        STA     Q
        JSR     ARCTAN

        LDX     INWK+14
        BMI     L3CE6

        EOR     #$80
.L3CE6
        LSR     A
        LSR     A
        STA     CNT2
        RTS

.PLS5
        JSR     PLS1

        STA     K2+2
        STY     XX16+2
        JSR     PLS1

        STA     K2+3
        STY     XX16+3
        RTS

.PLS6
        JSR     DVID3B2

        LDA     K+3
        AND     #$7F
        ORA     K+2
        BNE     L3CB8

        LDX     K+1
        CPX     #$04
        BCS     L3D1E

        LDA     K+3
        BPL     L3D1E

        LDA     K
        EOR     #$FF
        ADC     #$01
        STA     K
        TXA
        EOR     #$FF
        ADC     #$00
        TAX
.L3D1D
        CLC
.L3D1E
        RTS

.TT17
        JSR     DOKEY

        LDA     JSTK
        BEQ     TJ1

        LDA     JSTX
        EOR     #$FF
        JSR     TJS1

        TYA
        TAX
        LDA     JSTY
.TJS1
        TAY
        LDA     #$00
        CPY     #$10
        SBC     #$00
        CPY     #$40
        SBC     #$00
        CPY     #$C0
        ADC     #$00
        CPY     #$E0
        ADC     #$00
        TAY
        LDA     KL
        RTS

.TJ1
        LDA     KL
        LDX     #$00
        LDY     #$00
        CMP     #$19
        BNE     L3D58

        DEX
.L3D58
        CMP     #$79
        BNE     L3D5D

        INX
.L3D5D
        CMP     #$39
        BNE     L3D62

        INY
.L3D62
        CMP     #$29
        BNE     L3D67

        DEY
.L3D67
        RTS

.ping
        LDX     #$01
.L3D6A
        LDA     QQ0,X
        STA     QQ9,X
        DEX
        BPL     L3D6A

        RTS

.L3D74
        LDA     P
        STA     SLSP
        LDA     P+1
        STA     SLSP+1
        RTS

.KS1
.L3D7F
        LDX     XSAV
        JSR     KILLSHP

        LDX     XSAV
        JMP     MAL1

.L3D89
        JSR     ZINF

        JSR     FLFLLS

        STA     FRIN+1
        STA     SSPR
        JSR     SPBLB

        LDA     #$06
        STA     INWK+5
        LDA     #$81
        JMP     NWSHP

.KS2
        LDX     #$FF
.L3DA3
        INX
        LDA     FRIN,X
        BEQ     L3D74

        CMP     #$01
        BNE     L3DA3

        TXA
        ASL     A
        TAY
        LDA     UNIV,Y
        STA     SC
        LDA     UNIV+1,Y
        STA     SCH
        LDY     #$20
        LDA     (SC),Y
        BPL     L3DA3

        AND     #$7F
        LSR     A
        CMP     XX4
        BCC     L3DA3

        BEQ     L3DD2

        SBC     #$01
        ASL     A
        ORA     #$80
        STA     (SC),Y
        BNE     L3DA3

.L3DD2
        LDA     #$00
        STA     (SC),Y
        BEQ     L3DA3

.KILLSHP
        STX     XX4
        CPX     MSTG
        BNE     L3DE8

        LDY     #$EE
        JSR     ABORT

        LDA     #$C8
        JSR     MESS

.L3DE8
        LDY     XX4
        LDX     FRIN,Y
        CPX     #$02
        BEQ     L3D89

        CPX     #$1F
        BNE     L3DFD

        LDA     TP
        ORA     #$02
        STA     TP
.L3DFD
        CPX     #$03
        BCC     L3E08

        CPX     #$0B
        BCS     L3E08

        DEC     JUNK
.L3E08
        DEC     MANY,X
        LDX     XX4
        LDY     #$05
        LDA     (XX0),Y
        LDY     #$21
        CLC
        ADC     (INF),Y
        STA     P
        INY
        LDA     (INF),Y
        ADC     #$00
        STA     P+1
.L3E1F
        INX
        LDA     FRIN,X
        STA     KY20,X
        BNE     L3E2B

        JMP     KS2

.L3E2B
        ASL     A
        TAY
        LDA     L55FE,Y
        STA     SC
        LDA     L55FF,Y
        STA     SCH
        LDY     #$05
        LDA     (SC),Y
        STA     T
        LDA     P
        SEC
        SBC     T
        STA     P
        LDA     P+1
        SBC     #$00
        STA     P+1
        TXA
        ASL     A
        TAY
        LDA     UNIV,Y
        STA     SC
        LDA     UNIV+1,Y
        STA     SCH
        LDY     #$24
        LDA     (SC),Y
        STA     (INF),Y
        DEY
        LDA     (SC),Y
        STA     (INF),Y
        DEY
        LDA     (SC),Y
        STA     K+1
        LDA     P+1
        STA     (INF),Y
        DEY
        LDA     (SC),Y
        STA     K
        LDA     P
        STA     (INF),Y
        DEY
.L3E75
        LDA     (SC),Y
        STA     (INF),Y
        DEY
        BPL     L3E75

        LDA     SC
        STA     INF
        LDA     SCH
        STA     INF+1
        LDY     T
.L3E86
        DEY
        LDA     (K),Y
        STA     (P),Y
        TYA
        BNE     L3E86

        BEQ     L3E1F

.L3E90
        EQUB    $12,$01,$00,$10,$12,$02,$2C,$08
        EQUB    $11,$03,$F0,$18,$10,$F1,$07,$1A
        EQUB    $03,$F1,$BC,$01,$13,$F4,$0C,$08
        EQUB    $10,$F1,$06,$0C,$10,$02,$60,$10
        EQUB    $13,$04,$C2,$FF,$13,$00,$00,$00

.THERE
        LDX     GCNT
        DEX
        BNE     L3ECC

        LDA     QQ0
        CMP     #$90
        BNE     L3ECC

        LDA     QQ1
        CMP     #$21
        BEQ     L3ECD

.L3ECC
        CLC
.L3ECD
        RTS

.RESET
        JSR     ZERO

        LDX     #$08
.L3ED3
        STA     BETA,X
        DEX
        BPL     L3ED3

        TXA
        LDX     #$02
.L3EDB
        STA     FSH,X
        DEX
        BPL     L3EDB

.RES2
        LDA     #$12
        STA     NOSTM
        LDX     #$FF
        STX     LSX2
        STX     LSY2
        STX     MSTG
        LDA     #$80
        STA     JSTX
        STA     JSTY
        ASL     A
        STA     MCNT
        STA     QQ22+1
        LDA     #$03
        STA     DELTA
        LDA     SSPR
        BEQ     L3F09

        JSR     SPBLB

.L3F09
        LDA     ECMA
        BEQ     L3F10

        JSR     ECMOF

.L3F10
        JSR     WPSHPS

        JSR     ZERO

        LDA     #$FF
        STA     SLSP
        LDA     #$0C
        STA     SLSP+1
        JSR     DIALS

        JSR     Uperc

.ZINF
        LDY     #$24
        LDA     #$00
.L3F2A
        STA     XX1,Y
        DEY
        BPL     L3F2A

        LDA     #$60
        STA     INWK+18
        STA     INWK+22
        ORA     #$80
        STA     INWK+14
        RTS

.msblob
        LDX     #$04
.L3F3D
        CPX     NOMSL
        BEQ     L3F4B

        LDY     #$00
        JSR     MSBAR

        DEX
        BNE     L3F3D

        RTS

.L3F4B
        LDY     #$EE
        JSR     MSBAR

        DEX
        BNE     L3F4B

        RTS

.L3F54
        LDA     MCH
        JSR     MESS

        LDA     #$00
        STA     DLY
        JMP     me3

.Ze
        JSR     ZINF

        JSR     DORND

        STA     T1
        AND     #$80
        STA     INWK+2
        TXA
        AND     #$80
        STA     INWK+5
        LDA     #$19
        STA     INWK+1
        STA     INWK+4
        STA     INWK+7
        JSR     DORND

        CMP     #$F5
        ROL     A
        ORA     #$C0
        STA     INWK+32
.DORND2
        CLC
.DORND
        LDA     ZP
        ROL     A
        TAX
        ADC     RAND+2
        STA     ZP
        STX     RAND+2
        LDA     RAND+1
        TAX
        ADC     RAND+3
        STA     RAND+1
        STX     RAND+3
        RTS

.MTT4
        JSR     DORND

        LSR     A
        STA     INWK+32
        STA     INWK+29
        ROL     INWK+31
        AND     #$0F
        ORA     #$10
        STA     INWK+27
        JSR     DORND

        BMI     L3FB9

        LDA     INWK+32
        ORA     #$C0
        STA     INWK+32
        LDX     #$10
        STX     NEWB
.L3FB9
        AND     #$02
        ADC     #$0B
        JSR     NWSHP

.TT100
        JSR     M%

        DEC     DLY
        BEQ     L3F54

        BPL     me3

        INC     DLY
.me3
        DEC     MCNT
        BEQ     L3FD4

.L3FD1
        JMP     MLOOP

.L3FD4
        LDA     MJ
        BNE     L3FD1

        JSR     DORND

        CMP     #$23
        BCS     L402E

        LDA     JUNK
        CMP     #$03
        BCS     L402E

        JSR     ZINF

        LDA     #$26
        STA     INWK+7
        JSR     DORND

        STA     XX1
        STX     INWK+3
        AND     #$80
        STA     INWK+2
        TXA
        AND     #$80
        STA     INWK+5
        ROL     INWK+1
        ROL     INWK+1
        JSR     DORND

        BVS     MTT4

        NOP
        NOP
        NOP
        ORA     #$6F
        STA     INWK+29
        LDA     SSPR
        BNE     L402E

        TXA
        BCS     L401E

        AND     #$1F
        ORA     #$10
        STA     INWK+27
        BCC     L4022

.L401E
        ORA     #$7F
        STA     INWK+30
.L4022
        JSR     DORND

        CMP     #$0A
        AND     #$01
        ADC     #$05
        JSR     NWSHP

.L402E
        LDA     SSPR
.L4031
        BEQ     L4036

MLOOPS = L4031+1
.L4033
        JMP     MLOOP

.L4036
        JSR     BAD

        ASL     A
        LDX     MANY+16
        BEQ     L4042

        ORA     FIST
.L4042
        STA     T
        JSR     Ze

        CMP     T
        BCS     L4050

        LDA     #$10
.L404D
        JSR     NWSHP

anycop = L404D+2
.L4050
        LDA     MANY+16
        BNE     L4033

        DEC     EV
        BPL     L4033

        INC     EV
        LDA     TP
        AND     #$0C
        CMP     #$08
        BNE     L4070

        JSR     DORND

        CMP     #$C8
        BCC     L4070

        JSR     GTHG

.L4070
        JSR     DORND

        LDY     gov
        BEQ     L4083

        CMP     #$78
        BCS     L4033

        AND     #$07
        CMP     gov
        BCC     L4033

.L4083
        JSR     Ze

        CMP     #$64
        BCS     mt1

        INC     EV
        AND     #$03
        ADC     #$18
        TAY
        JSR     THERE

        BCC     L40A8

        LDA     #$F9
        STA     INWK+32
        LDA     TP
        AND     #$03
        LSR     A
        BCC     L40A8

        ORA     MANY+31
        BEQ     L40AA

.L40A8
        TYA
.L40A9
        BIT     &1FA9
L40AA = L40A9+1
        JSR     NWSHP

        JMP     MLOOP

.mt1
        AND     #$03
        STA     EV
        STA     XX13
.L40B9
        JSR     DORND

        STA     T
        JSR     DORND

        AND     T
        AND     #$07
        STA     CPIR
.L40C8
        LDA     CPIR
        ADC     #$11
        JSR     NWSHP

        BCS     L40D7

        DEC     CPIR
        BPL     L40C8

.L40D7
        DEC     XX13
        BPL     L40B9

.MLOOP
        LDX     #$FF
        TXS
        LDX     GNTMP
        BEQ     L40E6

        DEC     GNTMP
.L40E6
        JSR     DIALS

        LDA     QQ11
        BEQ     L40F8

        AND     PATG
        LSR     A
        BCS     L40F8

        LDY     #$02
        JSR     DELAY

.L40F8
        JSR     TT17

.FRCE
        JSR     TT102

        JMP     TT100

.TT102
        CMP     #$76
        BNE     L4108

        JMP     STATUS

.L4108
        CMP     #$14
        BNE     L410F

        JMP     TT22

.L410F
        CMP     #$74
        BNE     L4116

        JMP     TT23

.L4116
        CMP     #$75
        BNE     L4120

        JSR     TT111

        JMP     TT25

.L4120
        CMP     #$77
        BNE     L4127

        JMP     TT213

.L4127
        CMP     #$16
        BNE     L412E

        JMP     TT167

.L412E
        CMP     #$20
        BNE     L4135

        JMP     TT110

.L4135
        CMP     #$71
        BCC     L4143

        CMP     #$74
        BCS     L4143

        AND     #$03
        TAX
        JMP     LOOK1

.L4143
        CMP     #$54
        BNE     L414A

        JMP     hyp

.L414A
        CMP     #$32
        BEQ     L418B

        STA     T1
        LDA     QQ11
        AND     #$C0
        BEQ     L416C

        LDA     QQ22+1
        BNE     L416C

        LDA     T1
        CMP     #$36
        BNE     L4169

        JSR     TT103

        JSR     ping

        JSR     TT103

.L4169
        JSR     TT16

.L416C
        LDA     QQ22+1
        BEQ     L418A

        DEC     QQ22
        BNE     L418A

        LDX     QQ22+1
        DEX
        JSR     ee3

        LDA     #$05
        STA     QQ22
        LDX     QQ22+1
        JSR     ee3

        DEC     QQ22+1
        BNE     L418A

        JMP     TT18

.L418A
        RTS

.L418B
        LDA     QQ11
        AND     #$C0
        BEQ     L418A

        JSR     hm

        STA     K5
        JSR     cpl

        LDA     #$80
        STA     K5
        LDA     #$01
        STA     XC
        INC     YC
        JMP     TT146

.BAD
        LDA     QQ20+3
        CLC
        ADC     QQ20+6
        ASL     A
        ADC     QQ20+10
        RTS

.FAROF
        LDA     #$E0
.FAROF2
        CMP     INWK+1
        BCC     L41BE

        CMP     INWK+4
        BCC     L41BE

        CMP     INWK+7
.L41BE
        RTS

.MAS4
        ORA     INWK+1
        ORA     INWK+4
        ORA     INWK+7
        RTS

.DEATH
        JSR     EXNO3

        JSR     RES2

        ASL     DELTA
        ASL     DELTA
        LDX     #$18
        JSR     DET1

        JSR     TT66

        JSR     BOX

        JSR     nWq

        LDA     #$0C
        STA     YC
        STA     XC
        LDA     #$92
        JSR     ex

.L41E9
        JSR     Ze

        LSR     A
        LSR     A
        STA     XX1
        LDY     #$00
        STY     QQ11
        STY     INWK+1
        STY     INWK+4
        STY     INWK+7
        STY     INWK+32
        DEY
        STY     MCNT
        STY     LASCT
        EOR     #$2A
        STA     INWK+3
        ORA     #$50
        STA     INWK+6
        TXA
        AND     #$8F
        STA     INWK+29
        ROR     A
        AND     #$87
        STA     INWK+30
        LDX     #$05
        LDA     L5607
        BEQ     L421E

        BCC     L421E

        DEX
.L421E
        JSR     fq1

        JSR     DORND

        AND     #$80
        LDY     #$1F
        STA     (INF),Y
        LDA     FRIN+4
        BEQ     L41E9

        JSR     Uperc

        STA     DELTA
.L4234
        JSR     M%

        LDA     LASCT
        BNE     L4234

        LDX     #$1F
        JSR     DET1

        JMP     DEATH2

.RSHIPS
        JSR     LSHIPS

        JSR     RESET

        LDA     #$FF
        STA     QQ12
        STA     QQ11
        LDA     #$20
        JMP     FRCE

.LSHIPS
        JSR     THERE

        LDA     #$06
        BCS     SHIPinA

        JSR     DORND

        AND     #$03
        LDX     gov
        CPX     #$03
        ROL     A
        LDX     tek
        CPX     #$0A
        ROL     A
        TAX
        LDA     TP
        AND     #$0C
        CMP     #$08
        BNE     L427D

        TXA
        AND     #$01
        ORA     #$02
        TAX
.L427D
        TXA
.SHIPinA
        CLC
        ADC     #$41
        STA     L4294
        JSR     L0D7A

        LDX     #$8E
        LDY     #$42
        JMP     SCLI

.L428E
        EQUS    "L.D.MO"

.L4294
        EQUS    "0"

        EQUB    $0D

.ZERO
        LDX     #$3A
        LDA     #$00
.L429A
        STA     FRIN,X
        DEX
        BPL     L429A

        RTS

.ZES1
        STX     SCH
        LDA     #$00
        STA     SC
        TAY
.ZES2
        STA     (SC),Y
        DEY
        BNE     ZES2

        RTS

.SPS1
        LDX     #$00
        JSR     SPS3

        LDX     #$03
        JSR     SPS3

        LDX     #$06
        JSR     SPS3

.TAS2
        LDA     K3
        ORA     K3+3
        ORA     K3+6
        ORA     #$01
        STA     K3+9
        LDA     K3+1
.L42C9
        ORA     K3+4
NOISFR = L42C9+1
        ORA     K3+7
.L42CD
        ASL     K3+9
        ROL     A
        BCS     TA2

        ASL     K3
        ROL     K3+1
        ASL     K3+3
        ROL     K3+4
        ASL     K3+6
        ROL     K3+7
        BCC     L42CD

.TA2
        LDA     K3+1
        LSR     A
        ORA     K3+2
        STA     XX15
        LDA     K3+4
        LSR     A
        ORA     K3+5
        STA     Y1
        LDA     K3+7
        LSR     A
        ORA     K3+8
        STA     X2
.NORM
        LDA     XX15
        JSR     SQUA

        STA     R
        LDA     P
        STA     Q
        LDA     Y1
        JSR     SQUA

        STA     T
        LDA     P
        ADC     Q
        STA     Q
        LDA     T
        ADC     R
        STA     R
        LDA     X2
        JSR     SQUA

        STA     T
        LDA     P
        ADC     Q
        STA     Q
        LDA     T
        ADC     R
        STA     R
        JSR     LL5

        LDA     XX15
        JSR     TIS2

        STA     XX15
        LDA     Y1
        JSR     TIS2

        STA     Y1
        LDA     X2
        JSR     TIS2

        STA     X2
        RTS

.RDKEY
        LDX     #$10
.L4341
        JSR     DKS4

        BMI     L434A

        INX
        BPL     L4341

        TXA
.L434A
        EOR     #$80
        TAX
        RTS

.WARP
        LDX     JUNK
        LDA     FRIN+2,X
        ORA     SSPR
        ORA     MJ
        BNE     L439F

        LDY     K%+8
        BMI     L4368

        TAY
        JSR     MAS2

        LSR     A
        BEQ     L439F

.L4368
        LDY     K%+$2D
        BMI     L4375

        LDY     #$25
        JSR     m

        LSR     A
        BEQ     L439F

.L4375
        LDA     #$81
        STA     S
        STA     R
        STA     P
        LDA     K%+8
        JSR     ADD

        STA     K%+8
        LDA     K%+$2D
        JSR     ADD

        STA     K%+$2D
        LDA     #$01
        STA     QQ11
        STA     MCNT
        LSR     A
        STA     EV
        LDX     VIEW
        JMP     LOOK1

.L439F
        LDA     #$28
        BNE     NOISE

.ECMOF
        LDA     #$00
        STA     ECMA
        STA     ECMP
        JSR     ECBLB

        LDA     #$48
        BNE     NOISE

.EXNO3
        LDA     #$10
        JSR     NOISE

        LDA     #$18
        BNE     NOISE

.BEEP
        LDA     #$20
        BNE     NOISE

.SFRMIS
        LDX     #$01
        JSR     SFS1-2

        BCC     L4418

        LDA     #$78
        JSR     MESS

        LDA     #$30
        BNE     NOISE

.EXNO2
        INC     TALLY
        BNE     L43DB

        INC     TALLY+1
        LDA     #$65
        JSR     MESS

.L43DB
        LDX     #$07
.EXNO
        STX     T
        LDA     #$18
        JSR     NOS1

        LDA     INWK+7
        LSR     A
        LSR     A
        AND     T
        ORA     #$F1
        STA     XX16+2
        JSR     NO3

        LDA     #$10
.NOISE
        JSR     NOS1

.NO3
        LDX     DNOIZ
        BNE     L4418

        LDX     #$09
        LDY     #$00
        LDA     #$07
        JMP     OSWORD

.NOS1
        LSR     A
        ADC     #$03
        TAY
        LDX     #$07
.L440A
        LDA     #$00
        STA     XX16,X
        DEX
        LDA     L3E90,Y
        STA     XX16,X
        DEY
        DEX
        BPL     L440A

.L4418
        EQUB    $60,$E8,$E2,$E6,$E7,$C2,$D1,$C1
        EQUB    $60,$70,$23,$35,$65,$22,$45,$52
        EQUB    $37

.DKS1
        LDX     L4418,Y
        JSR     DKS4

        BPL     L4451

        LDA     #$FF
        STA     KL,Y
        RTS

.CTRL
        LDX     #$01
.DKS4
        LDA     #$03
        SEI
        STA     VIA+$40
        LDA     #$7F
        STA     VIA+$43
        STX     VIA+$4F
        LDX     VIA+$4F
        LDA     #$0B
        STA     VIA+$40
        CLI
        TXA
.L4451
        RTS

.DKS2
        LDA     #$80
        JSR     OSBYTE

        TYA
        EOR     JSTE
        RTS

.DKS3
        STY     T
        CPX     T
        BNE     L4472

        LDA     DAMP-$40,X
        EOR     #$FF
        STA     DAMP-$40,X
        JSR     BELL

        JSR     DELAY

        LDY     T
.L4472
        RTS

.L4473
        LDA     auto
        BNE     L44C7

        LDY     #$01
        JSR     DKS1

        INY
        JSR     DKS1

        LDA     VIA+$40
        TAX
        AND     #$10
        EOR     #$10
        STA     KY7
        LDX     #$01
        JSR     DKS2

        ORA     #$01
        STA     JSTX
        LDX     #$02
        JSR     DKS2

        EOR     JSTGY
        STA     JSTY
        JMP     DK4

.Uperc
        LDA     #$00
        LDY     #$10
.L44A8
        STA     KL,Y
        DEY
        BNE     L44A8

        RTS

.DOKEY
        JSR     Uperc

        LDA     JSTK
        BNE     L4473

        STA     BSTK
        LDY     #$07
.L44BC
        JSR     DKS1

        DEY
        BNE     L44BC

        LDA     auto
        BEQ     L4526

.L44C7
        JSR     ZINF

        LDA     #$60
        STA     INWK+14
        ORA     #$80
        STA     INWK+22
        STA     TYPE
        LDA     DELTA
        STA     INWK+27
        JSR     DOCKIT

        LDA     INWK+27
        CMP     #$16
        BCC     L44E3

        LDA     #$16
.L44E3
        STA     DELTA
        LDA     #$FF
        LDX     #$00
        LDY     INWK+28
        BEQ     L44F3

        BMI     L44F0

        INX
.L44F0
        STA     KY1,X
.L44F3
        LDA     #$80
        LDX     #$00
        ASL     INWK+29
        BEQ     L450F

        BCC     L44FE

        INX
.L44FE
        BIT     INWK+29
        BPL     L4509

        LDA     #$40
        STA     JSTX
        LDA     #$00
.L4509
        STA     KY3,X
        LDA     JSTX
.L450F
        STA     JSTX
        LDA     #$80
        LDX     #$00
        ASL     INWK+30
        BEQ     L4523

        BCS     L451D

        INX
.L451D
        STA     KY5,X
        LDA     JSTY
.L4523
        STA     JSTY
.L4526
        LDX     JSTX
        LDA     #$07
        LDY     KY3
        BEQ     L4533

        JSR     BUMP2

.L4533
        LDY     KY4
        BEQ     L453B

        JSR     REDU2

.L453B
        STX     JSTX
        ASL     A
        LDX     JSTY
        LDY     KY5
        BEQ     L454A

        JSR     REDU2

.L454A
        LDY     KY6
        BEQ     L4552

        JSR     BUMP2

.L4552
        STX     JSTY
.DK4
        JSR     RDKEY

        STX     KL
        CPX     #$69
        BNE     L459C

.L455F
        JSR     WSCAN

        JSR     RDKEY

        CPX     #$51
        BNE     L456E

        LDA     #$00
        STA     DNOIZ
.L456E
        LDY     #$40
.L4570
        JSR     DKS3

        INY
        CPY     #$47
        BNE     L4570

        CPX     #$10
        BNE     L457F

        STX     DNOIZ
.L457F
        CPX     #$70
        BNE     L4586

        JMP     DEATH2

.L4586
        CPX     #$64
        BNE     L4598

        LDA     BSTK
        EOR     #$FF
        STA     BSTK
        STA     JSTK
        STA     JSTE
.L4598
        CPX     #$59
        BNE     L455F

.L459C
        LDA     QQ11
        BNE     L45B4

        LDY     #$10
        LDA     #$FF
.L45A4
        LDX     L4418,Y
        CPX     KL
        BNE     L45AF

        STA     KL,Y
.L45AF
        DEY
        CPY     #$07
        BNE     L45A4

.L45B4
        RTS

.L45B5
        STX     DLY
        PHA
        LDA     MCH
        JSR     mes9

        PLA
.L45C0
        BIT     L6CA9
L45C1 = L45C0+1
.L45C3
        BIT     L6FA9
L45C4 = L45C3+1
.MESS
        LDX     #$00
        STX     K5
        LDY     #$09
        STY     XC
        LDY     #$16
        STY     YC
        CPX     DLY
        BNE     L45B5

        STY     DLY
        STA     MCH
.mes9
        JSR     TT27

        LSR     de
        BCC     L45B4

        LDA     #$FD
        JMP     TT27

.OUCH
        JSR     DORND

        BMI     L45B4

        CPX     #$16
        BCS     L45B4

        LDA     QQ20,X
        BEQ     L45B4

        LDA     DLY
        BNE     L45B4

        LDY     #$03
        STY     de
        STA     QQ20,X
        CPX     #$11
        BCS     L460E

        TXA
        ADC     #$D0
        BNE     MESS

.L460E
        BEQ     L45C1

        CPX     #$12
        BEQ     L45C4

        TXA
        ADC     #$5D
        BNE     MESS

.L4619
        EQUB    $13

.L461A
        EQUB    $82

.L461B
        EQUB    $06

.L461C
        EQUB    $01,$14,$81,$0A,$03,$41,$83,$02
        EQUB    $07,$28,$85,$E2,$1F,$53,$85,$FB
        EQUB    $0F,$C4,$08,$36,$03,$EB,$1D,$08
        EQUB    $78,$9A,$0E,$38,$03,$75,$06,$28
        EQUB    $07,$4E,$01,$11,$1F,$7C,$0D,$1D
        EQUB    $07,$B0,$89,$DC,$3F,$20,$81,$35
        EQUB    $03,$61,$A1,$42,$07,$AB,$A2,$37
        EQUB    $1F,$2D,$C1,$FA,$0F,$35,$0F,$C0
        EQUB    $07

.L465D
        TYA
        LDY     #$02
        JSR     TIS3

        STA     INWK+20
        JMP     TI3

.L4668
        TAX
        LDA     Y1
        AND     #$60
        BEQ     L465D

        LDA     #$02
        JSR     TIS3

        STA     INWK+18
        JMP     TI3

.TIDY
        LDA     INWK+10
        STA     XX15
        LDA     INWK+12
        STA     Y1
        LDA     INWK+14
        STA     X2
        JSR     NORM

        LDA     XX15
        STA     INWK+10
        LDA     Y1
        STA     INWK+12
        LDA     X2
        STA     INWK+14
        LDY     #$04
        LDA     XX15
        AND     #$60
        BEQ     L4668

        LDX     #$02
        LDA     #$00
        JSR     TIS3

        STA     INWK+16
.TI3
        LDA     INWK+16
        STA     XX15
        LDA     INWK+18
        STA     Y1
        LDA     INWK+20
        STA     X2
        JSR     NORM

        LDA     XX15
        STA     INWK+16
        LDA     Y1
        STA     INWK+18
        LDA     X2
        STA     INWK+20
        LDA     INWK+12
        STA     Q
        LDA     INWK+20
        JSR     MULT12

        LDX     INWK+14
        LDA     INWK+18
        JSR     TIS1

        EOR     #$80
        STA     INWK+22
        LDA     INWK+16
        JSR     MULT12

        LDX     INWK+10
        LDA     INWK+20
        JSR     TIS1

        EOR     #$80
        STA     INWK+24
        LDA     INWK+18
        JSR     MULT12

        LDX     INWK+12
        LDA     INWK+16
        JSR     TIS1

        EOR     #$80
.L46F2
        STA     INWK+26
LL155 = L46F2+1
        LDA     #$00
        LDX     #$0E
.L46F8
        STA     INWK+9,X
        DEX
        DEX
        BPL     L46F8

        RTS

.TIS2
        TAY
        AND     #$7F
        CMP     Q
        BCS     L4726

        LDX     #$FE
        STX     T
.L470A
        ASL     A
        CMP     Q
        BCC     L4711

        SBC     Q
.L4711
        ROL     T
        BCS     L470A

        LDA     T
        LSR     A
        LSR     A
        STA     T
        LSR     A
        ADC     T
        STA     T
        TYA
        AND     #$80
        ORA     T
        RTS

.L4726
        TYA
        AND     #$80
        ORA     #$60
        RTS

.TIS3
        STA     P+2
        LDA     INWK+10,X
        STA     Q
        LDA     INWK+16,X
        JSR     MULT12

        LDX     INWK+10,Y
        STX     Q
        LDA     INWK+16,Y
        JSR     MAD

        STX     P
        LDY     P+2
        LDX     INWK+10,Y
        STX     Q
        EOR     #$80
        STA     P+1
        EOR     Q
        AND     #$80
        STA     T
        LDA     #$00
        LDX     #$10
        ASL     P
        ROL     P+1
        ASL     Q
        LSR     Q
.L475F
        ROL     A
        CMP     Q
        BCC     L4766

        SBC     Q
.L4766
        ROL     P
        ROL     P+1
        DEX
        BNE     L475F

        LDA     P
        ORA     T
        RTS

.SHPPT
        JSR     EE51

        JSR     PROJ

        ORA     K3+1
        BNE     L479D

        LDA     K4
        CMP     #$BE
        BCS     L479D

        LDY     #$02
        JSR     Shpt

        LDY     #$06
        LDA     K4
        ADC     #$01
        JSR     Shpt

        LDA     #$08
        ORA     INWK+31
        STA     INWK+31
        LDA     #$08
        JMP     L4F74

.L479B
        PLA
        PLA
.L479D
        LDA     #$F7
        AND     INWK+31
        STA     INWK+31
        RTS

.Shpt
        STA     (INWK+33),Y
        INY
        INY
        STA     (INWK+33),Y
        LDA     K3
        DEY
        STA     (INWK+33),Y
        ADC     #$03
        BCS     L479B

        DEY
        DEY
        STA     (INWK+33),Y
        RTS

.LL5
        LDY     R
        LDA     Q
        STA     S
        LDX     #$00
        STX     Q
        LDA     #$08
        STA     T
.L47C6
        CPX     Q
        BCC     L47D8

        BNE     L47D0

        CPY     #$40
        BCC     L47D8

.L47D0
        TYA
        SBC     #$40
        TAY
        TXA
        SBC     Q
        TAX
.L47D8
        ROL     Q
        ASL     S
        TYA
        ROL     A
        TAY
        TXA
        ROL     A
        TAX
        ASL     S
        TYA
        ROL     A
        TAY
        TXA
        ROL     A
        TAX
        DEC     T
        BNE     L47C6

        RTS

.LL28
        CMP     Q
        BCS     L480D

.L47F3
        LDX     #$FE
        STX     R
.LL31
        ASL     A
        BCS     L4805

        CMP     Q
        BCC     L4800

        SBC     Q
.L4800
        ROL     R
        BCS     LL31

        RTS

.L4805
        SBC     Q
        SEC
        ROL     R
        BCS     LL31

        RTS

.L480D
        LDA     #$FF
        STA     R
        RTS

.LL38
        EOR     S
        BMI     L481C

        LDA     Q
        CLC
        ADC     R
        RTS

.L481C
        LDA     R
        SEC
        SBC     Q
        BCC     L4825

        CLC
        RTS

.L4825
        PHA
        LDA     S
        EOR     #$80
        STA     S
        PLA
        EOR     #$FF
        ADC     #$01
        RTS

.LL51
        LDX     #$00
        LDY     #$00
.L4836
        LDA     XX15
        STA     Q
        LDA     XX16,X
        JSR     FMLTU

        STA     T
        LDA     Y1
        EOR     XX16+1,X
        STA     S
        LDA     X2
        STA     Q
        LDA     XX16+2,X
        JSR     FMLTU

        STA     Q
        LDA     T
        STA     R
        LDA     Y2
        EOR     XX16+3,X
        JSR     LL38

        STA     T
        LDA     XX15+4
        STA     Q
        LDA     XX16+4,X
        JSR     FMLTU

        STA     Q
        LDA     T
        STA     R
        LDA     XX15+5
        EOR     XX16+5,X
        JSR     LL38

        STA     XX12,Y
        LDA     S
        STA     XX12+1,Y
        INY
        INY
        TXA
        CLC
        ADC     #$06
        TAX
        CMP     #$11
        BCC     L4836

        RTS

.L4889
        JMP     PLANET

.LL9
        LDA     TYPE
        BMI     L4889

        LDA     #$1F
        STA     XX4
        LDA     NEWB
        BMI     EE51

        LDA     #$20
        BIT     INWK+31
        BNE     L48CB

        BPL     L48CB

        ORA     INWK+31
        AND     #$3F
        STA     INWK+31
        LDA     #$00
        LDY     #$1C
        STA     (INF),Y
        LDY     #$1E
        STA     (INF),Y
        JSR     EE51

        LDY     #$01
        LDA     #$12
        STA     (INWK+33),Y
        LDY     #$07
        LDA     (XX0),Y
        LDY     #$02
        STA     (INWK+33),Y
.L48C1
        INY
        JSR     DORND

        STA     (INWK+33),Y
        CPY     #$06
        BNE     L48C1

.L48CB
        LDA     INWK+8
        BPL     L48EC

.L48CF
        LDA     INWK+31
        AND     #$20
        BEQ     EE51

        LDA     INWK+31
        AND     #$F7
        STA     INWK+31
        JMP     DOEXP

.EE51
        LDA     #$08
        BIT     INWK+31
        BEQ     L48EB

        EOR     INWK+31
        STA     INWK+31
        JMP     L4F78

.L48EB
        RTS

.L48EC
        LDA     INWK+7
        CMP     #$C0
        BCS     L48CF

        LDA     XX1
        CMP     INWK+6
        LDA     INWK+1
        SBC     INWK+7
        BCS     L48CF

        LDA     INWK+3
        CMP     INWK+6
        LDA     INWK+4
        SBC     INWK+7
        BCS     L48CF

        LDY     #$06
        LDA     (XX0),Y
        TAX
        LDA     #$FF
        STA     XX3,X
        STA     XX3+1,X
        LDA     INWK+6
        STA     T
        LDA     INWK+7
        LSR     A
        ROR     T
        LSR     A
        ROR     T
        LSR     A
        ROR     T
        LSR     A
        BNE     L492F

        LDA     T
        ROR     A
        LSR     A
        LSR     A
        LSR     A
        STA     XX4
        BPL     L4940

.L492F
        LDY     #$0D
        LDA     (XX0),Y
        CMP     INWK+7
        BCS     L4940

        LDA     #$20
        AND     INWK+31
        BNE     L4940

        JMP     SHPPT

.L4940
        LDX     #$05
.L4942
        LDA     INWK+21,X
        STA     XX16,X
        LDA     INWK+15,X
        STA     XX16+6,X
        LDA     INWK+9,X
        STA     XX16+12,X
        DEX
        BPL     L4942

        LDA     #$C5
        STA     Q
        LDY     #$10
.L4957
        LDA     XX16,Y
        ASL     A
        LDA     XX16+1,Y
        ROL     A
        JSR     LL28

        LDX     R
        STX     XX16,Y
        DEY
        DEY
        BPL     L4957

        LDX     #$08
.L496C
        LDA     XX1,X
        STA     K5,X
        DEX
        BPL     L496C

        LDA     #$FF
        STA     K4+1
        LDY     #$0C
        LDA     INWK+31
        AND     #$20
        BEQ     L4991

        LDA     (XX0),Y
        LSR     A
        LSR     A
        TAX
        LDA     #$FF
.L4986
        STA     K3,X
        DEX
        BPL     L4986

        INX
        STX     XX4
.L498E
        JMP     LL42

.L4991
        LDA     (XX0),Y
        BEQ     L498E

        STA     XX20
        LDY     #$12
        LDA     (XX0),Y
        TAX
        LDA     K6+3
        TAY
        BEQ     L49B0

.L49A1
        INX
        LSR     K6
        ROR     QQ19+2
        LSR     QQ19
        ROR     K5
        LSR     A
        ROR     K6+2
        TAY
        BNE     L49A1

.L49B0
        STX     XX17
        LDA     K6+4
        STA     XX15+5
        LDA     K5
        STA     XX15
        LDA     QQ19+1
        STA     Y1
        LDA     QQ19+2
        STA     X2
        LDA     K6+1
        STA     Y2
        LDA     K6+2
        STA     XX15+4
        JSR     LL51

        LDA     XX12
        STA     K5
        LDA     XX12+1
        STA     QQ19+1
        LDA     XX12+2
        STA     QQ19+2
        LDA     XX12+3
        STA     K6+1
        LDA     XX12+4
        STA     K6+2
        LDA     XX12+5
        STA     K6+4
        LDY     #$04
        LDA     (XX0),Y
        CLC
        ADC     XX0
        STA     V
        LDY     #$11
        LDA     (XX0),Y
        ADC     XX0+1
        STA     V+1
        LDY     #$00
.LL86
        LDA     (V),Y
        STA     XX12+1
        AND     #$1F
        CMP     XX4
        BCS     L4A11

        TYA
        LSR     A
        LSR     A
        TAX
        LDA     #$FF
        STA     K3,X
        TYA
        ADC     #$04
        TAY
        JMP     LL88

.L4A11
        LDA     XX12+1
        ASL     A
        STA     XX12+3
        ASL     A
        STA     XX12+5
        INY
        LDA     (V),Y
        STA     XX12
        INY
        LDA     (V),Y
        STA     XX12+2
        INY
        LDA     (V),Y
        STA     XX12+4
        LDX     XX17
        CPX     #$04
        BCC     L4A51

        LDA     K5
        STA     XX15
        LDA     QQ19+1
        STA     Y1
        LDA     QQ19+2
        STA     X2
        LDA     K6+1
        STA     Y2
        LDA     K6+2
        STA     XX15+4
        LDA     K6+4
        STA     XX15+5
        JMP     LL89

.L4A49
        LSR     K5
        LSR     K6+2
        LSR     QQ19+2
        LDX     #$01
.L4A51
        LDA     XX12
        STA     XX15
        LDA     XX12+2
        STA     X2
        LDA     XX12+4
        DEX
        BMI     L4A66

.L4A5E
        LSR     XX15
        LSR     X2
        LSR     A
        DEX
        BPL     L4A5E

.L4A66
        STA     R
        LDA     XX12+5
        STA     S
        LDA     K6+2
        STA     Q
        LDA     K6+4
        JSR     LL38

        BCS     L4A49

        STA     XX15+4
        LDA     S
        STA     XX15+5
        LDA     XX15
        STA     R
        LDA     XX12+1
        STA     S
        LDA     K5
        STA     Q
        LDA     QQ19+1
        JSR     LL38

        BCS     L4A49

        STA     XX15
        LDA     S
        STA     Y1
        LDA     X2
        STA     R
        LDA     XX12+3
        STA     S
        LDA     QQ19+2
        STA     Q
        LDA     K6+1
        JSR     LL38

        BCS     L4A49

        STA     X2
        LDA     S
        STA     Y2
.LL89
        LDA     XX12
        STA     Q
        LDA     XX15
        JSR     FMLTU

        STA     T
        LDA     XX12+1
        EOR     Y1
        STA     S
        LDA     XX12+2
        STA     Q
        LDA     X2
        JSR     FMLTU

        STA     Q
        LDA     T
        STA     R
        LDA     XX12+3
        EOR     Y2
        JSR     LL38

        STA     T
        LDA     XX12+4
        STA     Q
        LDA     XX15+4
        JSR     FMLTU

        STA     Q
        LDA     T
        STA     R
        LDA     XX15+5
        EOR     XX12+5
        JSR     LL38

        PHA
        TYA
        LSR     A
        LSR     A
        TAX
        PLA
        BIT     S
        BMI     L4AFA

        LDA     #$00
.L4AFA
        STA     K3,X
        INY
.LL88
        CPY     XX20
        BCS     LL42

        JMP     LL86

.LL42
        LDY     XX16+2
        LDX     XX16+3
        LDA     XX16+6
        STA     XX16+2
        LDA     XX16+7
        STA     XX16+3
        STY     XX16+6
        STX     XX16+7
        LDY     XX16+4
        LDX     XX16+5
        LDA     XX16+12
        STA     XX16+4
        LDA     XX16+13
        STA     XX16+5
        STY     XX16+12
        STX     XX16+13
        LDY     XX16+10
        LDX     XX16+11
        LDA     XX16+14
        STA     XX16+10
        LDA     XX16+15
        STA     XX16+11
        STY     XX16+14
        STX     XX16+15
        LDY     #$08
        LDA     (XX0),Y
        STA     XX20
        LDA     XX0
        CLC
        ADC     #$14
        STA     V
        LDA     XX0+1
        ADC     #$00
        STA     V+1
        LDY     #$00
        STY     CNT
.LL48
        STY     XX17
        LDA     (V),Y
        STA     XX15
        INY
        LDA     (V),Y
        STA     X2
        INY
        LDA     (V),Y
        STA     XX15+4
        INY
        LDA     (V),Y
        STA     T
        AND     #$1F
        CMP     XX4
        BCC     L4B94

        INY
        LDA     (V),Y
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     L4B97

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     L4B97

        INY
        LDA     (V),Y
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     L4B97

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     L4B97

.L4B94
        JMP     LL50

.L4B97
        LDA     T
        STA     Y1
        ASL     A
        STA     Y2
        ASL     A
        STA     XX15+5
        JSR     LL51

        LDA     INWK+2
        STA     X2
        EOR     XX12+1
        BMI     L4BBC

        CLC
        LDA     XX12
        ADC     XX1
        STA     XX15
        LDA     INWK+1
        ADC     #$00
        STA     Y1
        JMP     LL53

.L4BBC
        LDA     XX1
        SEC
        SBC     XX12
        STA     XX15
        LDA     INWK+1
        SBC     #$00
        STA     Y1
        BCS     LL53

        EOR     #$FF
        STA     Y1
        LDA     #$01
        SBC     XX15
        STA     XX15
        BCC     L4BD9

        INC     Y1
.L4BD9
        LDA     X2
        EOR     #$80
        STA     X2
.LL53
        LDA     INWK+5
        STA     XX15+5
        EOR     XX12+3
        BMI     L4BF7

        CLC
        LDA     XX12+2
        ADC     INWK+3
        STA     Y2
        LDA     INWK+4
        ADC     #$00
        STA     XX15+4
        JMP     LL55

.L4BF7
        LDA     INWK+3
        SEC
        SBC     XX12+2
        STA     Y2
        LDA     INWK+4
        SBC     #$00
        STA     XX15+4
        BCS     LL55

        EOR     #$FF
        STA     XX15+4
        LDA     Y2
        EOR     #$FF
        ADC     #$01
        STA     Y2
        LDA     XX15+5
        EOR     #$80
        STA     XX15+5
        BCC     LL55

        INC     XX15+4
.LL55
        LDA     XX12+5
        BMI     L4C6A

        LDA     XX12+4
        CLC
        ADC     INWK+6
        STA     T
        LDA     INWK+7
        ADC     #$00
        STA     U
        JMP     LL57

.LL61
        LDX     Q
        BEQ     L4C50

        LDX     #$00
.L4C36
        LSR     A
        INX
        CMP     Q
        BCS     L4C36

        STX     S
        JSR     LL28

        LDX     S
        LDA     R
.L4C45
        ASL     A
        ROL     U
        BMI     L4C50

        DEX
        BNE     L4C45

        STA     R
        RTS

.L4C50
        LDA     #$32
        STA     R
        STA     U
        RTS

.L4C57
        LDA     #$80
        SEC
        SBC     R
        STA     XX3,X
        INX
        LDA     #$00
        SBC     U
        STA     XX3,X
        JMP     LL66

.L4C6A
        LDA     INWK+6
        SEC
        SBC     XX12+4
        STA     T
        LDA     INWK+7
        SBC     #$00
        STA     U
        BCC     L4C81

        BNE     LL57

        LDA     T
        CMP     #$04
        BCS     LL57

.L4C81
        LDA     #$00
        STA     U
        LDA     #$04
        STA     T
.LL57
        LDA     U
        ORA     Y1
        ORA     XX15+4
        BEQ     L4CA0

        LSR     Y1
        ROR     XX15
        LSR     XX15+4
        ROR     Y2
        LSR     U
        ROR     T
        JMP     LL57

.L4CA0
        LDA     T
        STA     Q
        LDA     XX15
        CMP     Q
        BCC     L4CB0

        JSR     LL61

        JMP     LL65

.L4CB0
        JSR     LL28

.LL65
        LDX     CNT
        LDA     X2
        BMI     L4C57

        LDA     R
        CLC
        ADC     #$80
        STA     XX3,X
        INX
        LDA     U
        ADC     #$00
        STA     XX3,X
.LL66
        TXA
        PHA
        LDA     #$00
        STA     U
        LDA     T
        STA     Q
        LDA     Y2
        CMP     Q
        BCC     L4CF2

        JSR     LL61

        JMP     LL68

.L4CDF
        LDA     #$60
        CLC
        ADC     R
        STA     XX3,X
        INX
        LDA     #$00
        ADC     U
        STA     XX3,X
        JMP     LL50

.L4CF2
        JSR     LL28

.LL68
        PLA
        TAX
        INX
        LDA     XX15+5
        BMI     L4CDF

        LDA     #$60
        SEC
        SBC     R
        STA     XX3,X
        INX
        LDA     #$00
        SBC     U
        STA     XX3,X
.LL50
        CLC
        LDA     CNT
        ADC     #$04
        STA     CNT
        LDA     XX17
        ADC     #$06
        TAY
        BCS     L4D21

        CMP     XX20
        BCS     L4D21

        JMP     LL48

.L4D21
        LDA     INWK+31
        AND     #$20
        BEQ     L4D30

        LDA     INWK+31
        ORA     #$08
        STA     INWK+31
        JMP     DOEXP

.L4D30
        LDA     #$08
        BIT     INWK+31
        BEQ     L4D3B

        JSR     L4F78

        LDA     #$08
.L4D3B
        ORA     INWK+31
        STA     INWK+31
        LDY     #$09
        LDA     (XX0),Y
        STA     XX20
        LDY     #$00
        STY     U
        STY     XX17
        INC     U
        BIT     INWK+31
        BVC     L4DA5

        LDA     INWK+31
        AND     #$BF
        STA     INWK+31
        LDY     #$06
        LDA     (XX0),Y
        TAY
        LDX     XX3,Y
        STX     XX15
        INX
        BEQ     L4DA5

        LDX     XX3+1,Y
        STX     Y1
        INX
        BEQ     L4DA5

        LDX     XX3+2,Y
        STX     X2
        LDX     XX3+3,Y
        STX     Y2
        LDA     #$00
        STA     XX15+4
        STA     XX15+5
        STA     XX12+1
        LDA     INWK+6
        STA     XX12
        LDA     INWK+2
        BPL     L4D88

        DEC     XX15+4
.L4D88
        JSR     LL145

        BCS     L4DA5

        LDY     U
        LDA     XX15
        STA     (INWK+33),Y
        INY
        LDA     Y1
        STA     (INWK+33),Y
        INY
        LDA     X2
        STA     (INWK+33),Y
        INY
        LDA     Y2
        STA     (INWK+33),Y
        INY
        STY     U
.L4DA5
        LDY     #$03
        CLC
        LDA     (XX0),Y
        ADC     XX0
        STA     V
        LDY     #$10
        LDA     (XX0),Y
        ADC     XX0+1
        STA     V+1
        LDY     #$05
        LDA     (XX0),Y
        STA     T1
        LDY     XX17
.LL75
        LDA     (V),Y
        CMP     XX4
        BCC     L4DDC

        INY
        LDA     (V),Y
        INY
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     L4DDF

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     L4DDF

.L4DDC
        JMP     L4F5B

.L4DDF
        LDA     (V),Y
        TAX
        INY
        LDA     (V),Y
        STA     Q
        LDA     XX3+1,X
        STA     Y1
        LDA     XX3,X
        STA     XX15
        LDA     XX3+2,X
        STA     X2
        LDA     XX3+3,X
        STA     Y2
        LDX     Q
        LDA     XX3,X
        STA     XX15+4
        LDA     XX3+3,X
        STA     XX12+1
        LDA     XX3+2,X
        STA     XX12
        LDA     XX3+1,X
        STA     XX15+5
        JSR     LL147

        BCS     L4DDC

        JMP     LL80

.LL145
        LDA     #$00
        STA     SWAP
        LDA     XX15+5
.LL147
        LDX     #$BF
        ORA     XX12+1
        BNE     L4E2B

        CPX     XX12
        BCC     L4E2B

        LDX     #$00
.L4E2B
        STX     XX13
        LDA     Y1
        ORA     Y2
        BNE     L4E4F

        LDA     #$BF
        CMP     X2
        BCC     L4E4F

        LDA     XX13
        BNE     L4E4D

.LL146
        LDA     X2
        STA     Y1
        LDA     XX15+4
        STA     X2
        LDA     XX12
        STA     Y2
        CLC
        RTS

.L4E4B
        SEC
        RTS

.L4E4D
        LSR     XX13
.L4E4F
        LDA     XX13
        BPL     L4E82

        LDA     Y1
        AND     XX15+5
        BMI     L4E4B

        LDA     Y2
        AND     XX12+1
        BMI     L4E4B

        LDX     Y1
        DEX
        TXA
        LDX     XX15+5
        DEX
        STX     XX12+2
        ORA     XX12+2
        BPL     L4E4B

        LDA     X2
        CMP     #$C0
        LDA     Y2
        SBC     #$00
        STA     XX12+2
        LDA     XX12
        CMP     #$C0
        LDA     XX12+1
        SBC     #$00
        ORA     XX12+2
        BPL     L4E4B

.L4E82
        TYA
        PHA
        LDA     XX15+4
        SEC
        SBC     XX15
        STA     XX12+2
        LDA     XX15+5
        SBC     Y1
        STA     XX12+3
        LDA     XX12
        SEC
        SBC     X2
        STA     XX12+4
        LDA     XX12+1
        SBC     Y2
        STA     XX12+5
        EOR     XX12+3
        STA     S
        LDA     XX12+5
        BPL     L4EB3

        LDA     #$00
        SEC
        SBC     XX12+4
        STA     XX12+4
        LDA     #$00
        SBC     XX12+5
        STA     XX12+5
.L4EB3
        LDA     XX12+3
        BPL     LL111

        SEC
        LDA     #$00
        SBC     XX12+2
        STA     XX12+2
        LDA     #$00
        SBC     XX12+3
.LL111
        TAX
        BNE     L4EC9

        LDX     XX12+5
        BEQ     L4ED3

.L4EC9
        LSR     A
        ROR     XX12+2
        LSR     XX12+5
        ROR     XX12+4
        JMP     LL111

.L4ED3
        STX     T
        LDA     XX12+2
        CMP     XX12+4
        BCC     L4EE5

        STA     Q
        LDA     XX12+4
        JSR     LL28

        JMP     LL116

.L4EE5
        LDA     XX12+4
        STA     Q
        LDA     XX12+2
        JSR     LL28

        DEC     T
.LL116
        LDA     R
        STA     XX12+2
        LDA     S
        STA     XX12+3
        LDA     XX13
        BEQ     L4EFE

        BPL     L4F11

.L4EFE
        JSR     LL118

        LDA     XX13
        BPL     L4F36

        LDA     Y1
        ORA     Y2
        BNE     L4F3B

        LDA     X2
        CMP     #$C0
        BCS     L4F3B

.L4F11
        LDX     XX15
        LDA     XX15+4
        STA     XX15
        STX     XX15+4
        LDA     XX15+5
        LDX     Y1
        STX     XX15+5
        STA     Y1
        LDX     X2
        LDA     XX12
        STA     X2
        STX     XX12
        LDA     XX12+1
        LDX     Y2
        STX     XX12+1
        STA     Y2
        JSR     LL118

        DEC     SWAP
.L4F36
        PLA
        TAY
        JMP     LL146

.L4F3B
        PLA
        TAY
        SEC
        RTS

.LL80
        LDY     U
        LDA     XX15
        STA     (INWK+33),Y
        INY
        LDA     Y1
        STA     (INWK+33),Y
        INY
        LDA     X2
        STA     (INWK+33),Y
        INY
        LDA     Y2
        STA     (INWK+33),Y
        INY
        STY     U
        CPY     T1
        BCS     LL81

.L4F5B
        INC     XX17
        LDY     XX17
        CPY     XX20
        BCS     LL81

        LDY     #$00
        LDA     V
        ADC     #$04
        STA     V
        BCC     L4F6F

        INC     V+1
.L4F6F
        JMP     LL75

.LL81
        LDA     U
.L4F74
        LDY     #$00
        STA     (INWK+33),Y
.L4F78
        LDY     #$00
        LDA     (INWK+33),Y
        STA     XX20
        CMP     #$04
        BCC     L4F9E

        INY
.L4F83
        LDA     (INWK+33),Y
        STA     XX15
        INY
        LDA     (INWK+33),Y
        STA     Y1
        INY
        LDA     (INWK+33),Y
        STA     X2
        INY
        LDA     (INWK+33),Y
        STA     Y2
        JSR     LOIN

        INY
        CPY     XX20
        BCC     L4F83

.L4F9E
        RTS

.LL118
        LDA     Y1
        BPL     L4FBA

        STA     S
        JSR     LL120

        TXA
        CLC
        ADC     X2
        STA     X2
        TYA
        ADC     Y2
        STA     Y2
        LDA     #$00
        STA     XX15
        STA     Y1
        TAX
.L4FBA
        BEQ     L4FD5

        STA     S
        DEC     S
        JSR     LL120

        TXA
        CLC
        ADC     X2
        STA     X2
        TYA
        ADC     Y2
        STA     Y2
        LDX     #$FF
        STX     XX15
        INX
        STX     Y1
.L4FD5
        LDA     Y2
        BPL     L4FF3

        STA     S
        LDA     X2
        STA     R
        JSR     LL123

        TXA
        CLC
        ADC     XX15
        STA     XX15
        TYA
        ADC     Y1
        STA     Y1
        LDA     #$00
        STA     X2
        STA     Y2
.L4FF3
        LDA     X2
        SEC
        SBC     #$C0
        STA     R
        LDA     Y2
        SBC     #$00
        STA     S
        BCC     L5018

        JSR     LL123

        TXA
        CLC
        ADC     XX15
        STA     XX15
        TYA
        ADC     Y1
        STA     Y1
        LDA     #$BF
        STA     X2
        LDA     #$00
        STA     Y2
.L5018
        RTS

.LL120
        LDA     XX15
        STA     R
        JSR     LL129

        PHA
        LDX     T
        BNE     L5050

.L5025
        LDA     #$00
        TAX
        TAY
        LSR     S
        ROR     R
        ASL     Q
        BCC     L503A

.L5031
        TXA
        CLC
        ADC     R
        TAX
        TYA
        ADC     S
        TAY
.L503A
        LSR     S
        ROR     R
        ASL     Q
        BCS     L5031

        BNE     L503A

        PLA
        BPL     L5077

        RTS

.LL123
        JSR     LL129

        PHA
        LDX     T
        BNE     L5025

.L5050
        LDA     #$FF
        TAY
        ASL     A
        TAX
.L5055
        ASL     R
        ROL     S
        LDA     S
        BCS     L5061

        CMP     Q
        BCC     L506C

.L5061
        SBC     Q
        STA     S
        LDA     R
        SBC     #$00
        STA     R
        SEC
.L506C
        TXA
        ROL     A
        TAX
        TYA
        ROL     A
        TAY
        BCS     L5055

        PLA
        BMI     L5083

.L5077
        TXA
        EOR     #$FF
        ADC     #$01
        TAX
        TYA
        EOR     #$FF
        ADC     #$00
        TAY
.L5083
        RTS

.LL129
        LDX     XX12+2
        STX     Q
        LDA     S
        BPL     L509D

        LDA     #$00
        SEC
        SBC     R
        STA     R
        LDA     S
        PHA
        EOR     #$FF
        ADC     #$00
        STA     S
        PLA
.L509D
        EOR     XX12+3
        RTS

.MVEIT
        LDA     INWK+31
        AND     #$A0
        BNE     L50CB

        LDA     MCNT
        EOR     XSAV
        AND     #$0F
        BNE     L50B1

        JSR     TIDY

.L50B1
        LDX     TYPE
        BPL     L50B8

        JMP     MV40

.L50B8
        LDA     INWK+32
        BPL     L50CB

        CPX     #$01
        BEQ     L50C8

        LDA     MCNT
        EOR     XSAV
        AND     #$07
        BNE     L50CB

.L50C8
        JSR     TACTICS

.L50CB
        JSR     SCAN

        LDA     INWK+27
        ASL     A
        ASL     A
        STA     Q
        LDA     INWK+10
        AND     #$7F
        JSR     FMLTU

        STA     R
        LDA     INWK+10
        LDX     #$00
        JSR     L524A

        LDA     INWK+12
        AND     #$7F
        JSR     FMLTU

        STA     R
        LDA     INWK+12
        LDX     #$03
        JSR     L524A

        LDA     INWK+14
        AND     #$7F
        JSR     FMLTU

        STA     R
        LDA     INWK+14
        LDX     #$06
        JSR     L524A

        LDA     INWK+27
        CLC
        ADC     INWK+28
        BPL     L510D

        LDA     #$00
.L510D
        LDY     #$0F
        CMP     (XX0),Y
        BCC     L5115

        LDA     (XX0),Y
.L5115
        STA     INWK+27
        LDA     #$00
        STA     INWK+28
        LDX     ALP1
        LDA     XX1
        EOR     #$FF
        STA     P
        LDA     INWK+1
        JSR     MLTU2-2

        STA     P+2
        LDA     ALP2+1
        EOR     INWK+2
        LDX     #$03
        JSR     MVT6

        STA     K2+3
        LDA     P+1
        STA     K2+1
        EOR     #$FF
        STA     P
        LDA     P+2
        STA     K2+2
        LDX     BET1
        JSR     MLTU2-2

        STA     P+2
        LDA     K2+3
        EOR     BET2
        LDX     #$06
        JSR     MVT6

        STA     INWK+8
        LDA     P+1
        STA     INWK+6
        EOR     #$FF
        STA     P
        LDA     P+2
        STA     INWK+7
        JSR     MLTU2

        STA     P+2
        LDA     K2+3
        STA     INWK+5
        EOR     BET2
        EOR     INWK+8
        BPL     L517D

        LDA     P+1
        ADC     K2+1
        STA     INWK+3
        LDA     P+2
        ADC     K2+2
        STA     INWK+4
        JMP     MV44

.L517D
        LDA     K2+1
        SBC     P+1
        STA     INWK+3
        LDA     K2+2
        SBC     P+2
        STA     INWK+4
        BCS     MV44

        LDA     #$01
        SBC     INWK+3
        STA     INWK+3
        LDA     #$00
        SBC     INWK+4
        STA     INWK+4
        LDA     INWK+5
        EOR     #$80
        STA     INWK+5
.MV44
        LDX     ALP1
        LDA     INWK+3
        EOR     #$FF
        STA     P
        LDA     INWK+4
        JSR     MLTU2-2

        STA     P+2
        LDA     ALP2
        EOR     INWK+5
        LDX     #$00
        JSR     MVT6

        STA     INWK+2
        LDA     P+2
        STA     INWK+1
        LDA     P+1
        STA     XX1
.MV45
        LDA     DELTA
        STA     R
        LDA     #$80
        LDX     #$06
        JSR     MVT1

        LDA     TYPE
        AND     #$81
        CMP     #$81
        BNE     L51D3

        RTS

.L51D3
        LDY     #$09
        JSR     MVS4

        LDY     #$0F
        JSR     MVS4

        LDY     #$15
        JSR     MVS4

        LDA     INWK+30
        AND     #$80
        STA     RAT2
        LDA     INWK+30
        AND     #$7F
        BEQ     L520B

        CMP     #$7F
        SBC     #$00
        ORA     RAT2
        STA     INWK+30
        LDX     #$0F
        LDY     #$09
        JSR     MVS5

        LDX     #$11
        LDY     #$0B
        JSR     MVS5

        LDX     #$13
        LDY     #$0D
        JSR     MVS5

.L520B
        LDA     INWK+29
        AND     #$80
        STA     RAT2
        LDA     INWK+29
        AND     #$7F
        BEQ     L5234

        CMP     #$7F
        SBC     #$00
        ORA     RAT2
        STA     INWK+29
        LDX     #$0F
        LDY     #$15
        JSR     MVS5

        LDX     #$11
        LDY     #$17
        JSR     MVS5

        LDX     #$13
        LDY     #$19
        JSR     MVS5

.L5234
        LDA     INWK+31
        AND     #$A0
        BNE     L5243

        LDA     INWK+31
        ORA     #$10
        STA     INWK+31
        JMP     SCAN

.L5243
        LDA     INWK+31
        AND     #$EF
        STA     INWK+31
        RTS

.L524A
        AND     #$80
.MVT1
        ASL     A
        STA     S
        LDA     #$00
        ROR     A
        STA     T
        LSR     S
        EOR     INWK+2,X
        BMI     L526F

        LDA     R
        ADC     XX1,X
        STA     XX1,X
        LDA     S
        ADC     INWK+1,X
        STA     INWK+1,X
        LDA     INWK+2,X
        ADC     #$00
        ORA     T
        STA     INWK+2,X
        RTS

.L526F
        LDA     XX1,X
        SEC
        SBC     R
        STA     XX1,X
        LDA     INWK+1,X
        SBC     S
        STA     INWK+1,X
        LDA     INWK+2,X
        AND     #$7F
        SBC     #$00
        ORA     #$80
        EOR     T
        STA     INWK+2,X
        BCS     L52A0

        LDA     #$01
        SBC     XX1,X
        STA     XX1,X
        LDA     #$00
        SBC     INWK+1,X
        STA     INWK+1,X
        LDA     #$00
        SBC     INWK+2,X
        AND     #$7F
        ORA     T
        STA     INWK+2,X
.L52A0
        RTS

.MVS4
        LDA     ALPHA
        STA     Q
        LDX     INWK+2,Y
        STX     R
        LDX     INWK+3,Y
        STX     S
        LDX     XX1,Y
        STX     P
        LDA     INWK+1,Y
        EOR     #$80
        JSR     MAD

        STA     INWK+3,Y
        STX     INWK+2,Y
        STX     P
        LDX     XX1,Y
        STX     R
        LDX     INWK+1,Y
        STX     S
        LDA     INWK+3,Y
        JSR     MAD

        STA     INWK+1,Y
        STX     XX1,Y
        STX     P
        LDA     BETA
        STA     Q
        LDX     INWK+2,Y
        STX     R
        LDX     INWK+3,Y
        STX     S
        LDX     INWK+4,Y
        STX     P
        LDA     INWK+5,Y
        EOR     #$80
        JSR     MAD

        STA     INWK+3,Y
        STX     INWK+2,Y
        STX     P
        LDX     INWK+4,Y
        STX     R
        LDX     INWK+5,Y
        STX     S
        LDA     INWK+3,Y
        JSR     MAD

        STA     INWK+5,Y
        STX     INWK+4,Y
        RTS

.MVT6
        TAY
        EOR     INWK+2,X
        BMI     L531C

        LDA     P+1
        CLC
        ADC     XX1,X
        STA     P+1
        LDA     P+2
        ADC     INWK+1,X
        STA     P+2
        TYA
        RTS

.L531C
        LDA     XX1,X
        SEC
        SBC     P+1
        STA     P+1
        LDA     INWK+1,X
        SBC     P+2
        STA     P+2
        BCC     L532F

        TYA
        EOR     #$80
        RTS

.L532F
        LDA     #$01
        SBC     P+1
        STA     P+1
        LDA     #$00
        SBC     P+2
        STA     P+2
        TYA
        RTS

.MV40
        LDA     ALPHA
        EOR     #$80
        STA     Q
        LDA     XX1
        STA     P
        LDA     INWK+1
        STA     P+1
        LDA     INWK+2
        JSR     MULT3

        LDX     #$03
        JSR     MVT3

        LDA     K+1
        STA     K2+1
        STA     P
        LDA     K+2
        STA     K2+2
        STA     P+1
        LDA     BETA
        STA     Q
        LDA     K+3
        STA     K2+3
        JSR     MULT3

        LDX     #$06
        JSR     MVT3

        LDA     K+1
        STA     P
        STA     INWK+6
        LDA     K+2
        STA     P+1
        STA     INWK+7
        LDA     K+3
        STA     INWK+8
        EOR     #$80
        JSR     MULT3

        LDA     K+3
        AND     #$80
        STA     T
        EOR     K2+3
        BMI     L53A8

        LDA     K
        CLC
        ADC     K2
        LDA     K+1
        ADC     K2+1
        STA     INWK+3
        LDA     K+2
        ADC     K2+2
        STA     INWK+4
        LDA     K+3
        ADC     K2+3
        JMP     MV2

.L53A8
        LDA     K
        SEC
        SBC     K2
        LDA     K+1
        SBC     K2+1
        STA     INWK+3
        LDA     K+2
        SBC     K2+2
        STA     INWK+4
        LDA     K2+3
        AND     #$7F
        STA     P
        LDA     K+3
        AND     #$7F
        SBC     P
        STA     P
        BCS     MV2

        LDA     #$01
        SBC     INWK+3
        STA     INWK+3
        LDA     #$00
        SBC     INWK+4
        STA     INWK+4
        LDA     #$00
        SBC     P
        ORA     #$80
.MV2
        EOR     T
        STA     INWK+5
        LDA     ALPHA
        STA     Q
        LDA     INWK+3
        STA     P
        LDA     INWK+4
        STA     P+1
        LDA     INWK+5
        JSR     MULT3

        LDX     #$00
        JSR     MVT3

        LDA     K+1
        STA     XX1
        LDA     K+2
        STA     INWK+1
        LDA     K+3
        STA     INWK+2
        JMP     MV45

.PU1
        DEX
        BNE     L5438

        LDA     INWK+2
        EOR     #$80
        STA     INWK+2
        LDA     INWK+8
        EOR     #$80
        STA     INWK+8
        LDA     INWK+10
        EOR     #$80
        STA     INWK+10
        LDA     INWK+14
        EOR     #$80
        STA     INWK+14
        LDA     INWK+16
        EOR     #$80
        STA     INWK+16
        LDA     INWK+20
        EOR     #$80
        STA     INWK+20
        LDA     INWK+22
        EOR     #$80
        STA     INWK+22
        LDA     INWK+26
        EOR     #$80
        STA     INWK+26
        RTS

.L5438
        LDA     #$00
        CPX     #$02
        ROR     A
        STA     RAT2
        EOR     #$80
        STA     RAT
        LDA     XX1
        LDX     INWK+6
        STA     INWK+6
        STX     XX1
        LDA     INWK+1
        LDX     INWK+7
        STA     INWK+7
        STX     INWK+1
        LDA     INWK+2
        EOR     RAT
        TAX
        LDA     INWK+8
        EOR     RAT2
        STA     INWK+2
        STX     INWK+8
        LDY     #$09
        JSR     PUS1

        LDY     #$0F
        JSR     PUS1

        LDY     #$15
.PUS1
        LDA     XX1,Y
        LDX     INWK+4,Y
        STA     INWK+4,Y
        STX     XX1,Y
        LDA     INWK+1,Y
        EOR     RAT
        TAX
        LDA     INWK+5,Y
        EOR     RAT2
        STA     INWK+1,Y
        STX     INWK+5,Y
.L5486
        RTS

.L5487
        STX     VIEW
        JSR     TT66

        JSR     SIGHT

        JMP     NWSTARS

.LOOK1
        LDA     #$00
        LDY     QQ11
        BNE     L5487

        CPX     VIEW
        BEQ     L5486

        STX     VIEW
        JSR     TT66

        JSR     FLIP

        JSR     WPSHPS

.SIGHT
        LDY     VIEW
        LDA     LASER,Y
        BEQ     L5486

        LDA     #$80
        STA     QQ19
        LDA     #$48
        STA     QQ19+1
        LDA     #$14
        STA     QQ19+2
        JSR     TT15

        LDA     #$0A
        STA     QQ19+2
        JMP     TT15

.TT66
        STA     QQ11
.TTX66
        LDA     #$80
        STA     K5
        JSR     FLFLLS

        STA     LAS2
        STA     DLY
        STA     de
        LDX     #$60
.L54DC
        JSR     ZES1

        INX
        CPX     #$78
        BNE     L54DC

        LDX     QQ22+1
        BEQ     BOX

        JSR     ee3

.BOX
        LDY     #$01
        STY     YC
        LDA     QQ11
        BNE     L5507

        LDY     #$0B
        STY     XC
        LDA     VIEW
        ORA     #$60
        JSR     TT27

        JSR     TT162

        LDA     #$AF
        JSR     TT27

.L5507
        LDX     #$00
        STX     XX15
        STX     Y1
        STX     K5
        DEX
        STX     X2
        JSR     HLOIN

        LDA     #$02
        STA     XX15
        STA     X2
        JSR     BOS2

.BOS2
        JSR     L5521

.L5521
        LDA     #$00
        STA     Y1
        LDA     #$BF
        STA     Y2
        DEC     XX15
        DEC     X2
        JMP     LOIN

.DELAY
        JSR     WSCAN

        DEY
        BNE     DELAY

        RTS

.CLYNS
        LDA     #$14
        STA     YC
        LDA     #$75
        STA     SCH
        LDA     #$07
        STA     SC
        JSR     TT67

        LDA     #$00
        JSR     LYN

        INC     SCH
        INY
        STY     XC
.LYN
        LDY     #$E9
.L5552
        STA     (SC),Y
        DEY
        BNE     L5552

.L5557
        RTS

.SCAN
        LDA     INWK+31
        AND     #$10
        BEQ     L5557

        LDA     TYPE
        BMI     L5557

        LDX     #$FF
        CMP     #$01
        BNE     L556A

        LDX     #$F0
.L556A
        STX     COL
        LDA     INWK+1
        ORA     INWK+4
        ORA     INWK+7
        AND     #$C0
        BNE     L5557

        LDA     INWK+1
        CLC
        LDX     INWK+2
        BPL     L5581

        EOR     #$FF
        ADC     #$01
.L5581
        ADC     #$7B
        STA     XX15
        LDA     INWK+7
        LSR     A
        LSR     A
        CLC
        LDX     INWK+8
        BPL     L5591

        EOR     #$FF
        SEC
.L5591
        ADC     #$23
        EOR     #$FF
        STA     SC
        LDA     INWK+4
        LSR     A
        CLC
        LDX     INWK+5
        BMI     L55A2

        EOR     #$FF
        SEC
.L55A2
        ADC     SC
        BPL     L55B0

        CMP     #$C2
        BCS     L55AC

        LDA     #$C2
.L55AC
        CMP     #$F7
        BCC     L55B2

.L55B0
        LDA     #$F6
.L55B2
        STA     Y1
        SEC
        SBC     SC
        PHP
        PHA
        JSR     L36A7

        LDA     CTWOS+1,X
        AND     COL
        STA     XX15
        PLA
        PLP
        TAX
        BEQ     L55DA

        BCC     L55DB

.L55CA
        DEY
        BPL     L55D1

        LDY     #$07
        DEC     SCH
.L55D1
        LDA     XX15
        EOR     (SC),Y
        STA     (SC),Y
        DEX
        BNE     L55CA

.L55DA
        RTS

.L55DB
        INY
        CPY     #$08
        BNE     L55E4

        LDY     #$00
        INC     SCH
.L55E4
        INY
        CPY     #$08
        BNE     L55ED

        LDY     #$00
        INC     SCH
.L55ED
        LDA     XX15
        EOR     (SC),Y
        STA     (SC),Y
        INX
        BNE     L55E4

        RTS

.WSCAN
        LDA     #$00
        STA     DL
.L55FB
        LDA     DL
.L55FD
        BEQ     L55FB

L55FE = L55FD+1
.L55FF
        RTS

.BeebDisEndAddr





SAVE "versions/disc/output/D.CODE.unprot.bin", &11E3, BeebDisEndAddr
