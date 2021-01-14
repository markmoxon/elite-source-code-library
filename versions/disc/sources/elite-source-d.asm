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



.LOIN
        STY     YSAV
        LDA     #$80
        STA     S
        ASL     A
        STA     SWAP
        LDA     X2
        SBC     XX15
        BCS     L16D8

        EOR     #$FF
        ADC     #$01
        SEC
.L16D8
        STA     P
        LDA     Y2
        SBC     Y1
        BCS     L16E4

        EOR     #$FF
        ADC     #$01
.L16E4
        STA     Q
        CMP     P
        BCC     L16ED

        JMP     L1797

.L16ED
        LDX     XX15
        CPX     X2
        BCC     L1704

        DEC     SWAP
        LDA     X2
        STA     XX15
        STX     X2
        TAX
        LDA     Y2
        LDY     Y1
        STA     Y1
        STY     Y2
.L1704
        LDA     Y1
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        LDA     Y1
        AND     #$07
        TAY
        TXA
        AND     #$F8
        STA     SC
        TXA
        AND     #$07
        TAX
        LDA     TWOS,X
        STA     R
        LDA     Q
        LDX     #$FE
        STX     Q
.L1726
        ASL     A
        BCS     L172D

        CMP     P
        BCC     L1730

.L172D
        SBC     P
        SEC
.L1730
        ROL     Q
        BCS     L1726

        LDX     P
        INX
        LDA     Y2
        SBC     Y1
        BCS     L1769

        LDA     SWAP
        BNE     L1748

        DEX
.L1742
        LDA     R
        EOR     (SC),Y
        STA     (SC),Y
.L1748
        LSR     R
        BCC     L1754

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L1754
        LDA     S
        ADC     Q
        STA     S
        BCC     L1763

        DEY
        BPL     L1763

        DEC     SCH
        LDY     #$07
.L1763
        DEX
        BNE     L1742

        LDY     YSAV
        RTS

.L1769
        LDA     SWAP
        BEQ     L1774

        DEX
.L176E
        LDA     R
        EOR     (SC),Y
        STA     (SC),Y
.L1774
        LSR     R
        BCC     L1780

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L1780
        LDA     S
        ADC     Q
        STA     S
        BCC     L1791

        INY
        CPY     #$08
        BNE     L1791

        INC     SCH
        LDY     #$00
.L1791
        DEX
        BNE     L176E

        LDY     YSAV
        RTS

.L1797
        LDY     Y1
        TYA
        LDX     XX15
        CPY     Y2
        BCS     L17B0

        DEC     SWAP
        LDA     X2
        STA     XX15
        STX     X2
        TAX
        LDA     Y2
        STA     Y1
        STY     Y2
        TAY
.L17B0
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        TXA
        AND     #$F8
        STA     SC
        TXA
        AND     #$07
        TAX
        LDA     TWOS,X
        STA     R
        LDA     Y1
        AND     #$07
        TAY
        LDA     P
        LDX     #$01
        STX     P
.L17D0
        ASL     A
        BCS     L17D7

        CMP     Q
        BCC     L17DA

.L17D7
        SBC     Q
        SEC
.L17DA
        ROL     P
        BCC     L17D0

        LDX     Q
        INX
        LDA     X2
        SBC     XX15
        BCC     L1814

        CLC
        LDA     SWAP
        BEQ     L17F3

        DEX
.L17ED
        LDA     R
        EOR     (SC),Y
        STA     (SC),Y
.L17F3
        DEY
        BPL     L17FA

        DEC     SCH
        LDY     #$07
.L17FA
        LDA     S
        ADC     P
        STA     S
        BCC     L180E

        LSR     R
        BCC     L180E

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L180E
        DEX
        BNE     L17ED

        LDY     YSAV
        RTS

.L1814
        LDA     SWAP
        BEQ     L181F

        DEX
.L1819
        LDA     R
        EOR     (SC),Y
        STA     (SC),Y
.L181F
        DEY
        BPL     L1826

        DEC     SCH
        LDY     #$07
.L1826
        LDA     S
        ADC     P
        STA     S
        BCC     L183B

        ASL     R
        BCC     L183B

        ROL     R
        LDA     SC
        SBC     #$07
        STA     SC
        CLC
.L183B
        DEX
        BNE     L1819

        LDY     YSAV
.L1840
        RTS

        LDA     #$0F
        TAX
        JMP     OSBYTE

.NLIN3
        JSR     L339A

.NLIN4
        LDA     #$13
        BNE     NLIN2

.NLIN
        LDA     #$17
        INC     YC
.NLIN2
        STA     Y1
        LDX     #$02
        STX     XX15
        LDX     #$FE
        STX     X2
        BNE     HLOIN

.HLOIN2
        JSR     EDGES

        STY     Y1
        LDA     #$00
        STA     LSX,Y
.HLOIN
        STY     YSAV
        LDX     XX15
        CPX     X2
        BEQ     L1840

        BCC     L1879

        LDA     X2
        STA     XX15
        STX     X2
        TAX
.L1879
        DEC     X2
        LDA     Y1
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        LDA     Y1
        AND     #$07
        STA     SC
        TXA
        AND     #$F8
        TAY
        TXA
        AND     #$F8
        STA     T
        LDA     X2
        AND     #$F8
        SEC
        SBC     T
        BEQ     L18D3

        LSR     A
        LSR     A
        LSR     A
        STA     R
        LDA     XX15
        AND     #$07
        TAX
        LDA     L18F5,X
        EOR     (SC),Y
        STA     (SC),Y
        TYA
        ADC     #$08
        TAY
        LDX     R
        DEX
        BEQ     L18C4

        CLC
.L18B7
        LDA     #$FF
        EOR     (SC),Y
        STA     (SC),Y
        TYA
        ADC     #$08
        TAY
        DEX
        BNE     L18B7

.L18C4
        LDA     X2
        AND     #$07
        TAX
        LDA     L18EE,X
        EOR     (SC),Y
        STA     (SC),Y
        LDY     YSAV
        RTS

.L18D3
        LDA     XX15
        AND     #$07
        TAX
        LDA     L18F5,X
        STA     T
        LDA     X2
        AND     #$07
        TAX
        LDA     L18EE,X
        AND     T
        EOR     (SC),Y
        STA     (SC),Y
        LDY     YSAV
        RTS

.L18EE
        EQUB    $80,$C0,$E0,$F0,$F8,$FC,$FE

.L18F5
        EQUB    $FF,$7F,$3F,$1F,$0F,$07,$03,$01

.L18FD
        LDA     TWOS,X
        EOR     (SC),Y
        STA     (SC),Y
        LDY     T1
        RTS

.PIX1
        JSR     ADD

        STA     YY+1
        TXA
        STA     SYL,Y
.PIXEL2
        LDA     XX15
        BPL     L1919

        EOR     #$7F
        CLC
        ADC     #$01
.L1919
        EOR     #$80
        TAX
        LDA     Y1
        AND     #$7F
        CMP     #$60
        BCS     L196A

        LDA     Y1
        BPL     L192C

        EOR     #$7F
        ADC     #$01
.L192C
        STA     T
        LDA     #$61
        SBC     T
.PIXEL
        STY     T1
        TAY
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        TXA
        AND     #$F8
        STA     SC
        TYA
        AND     #$07
        TAY
        TXA
        AND     #$07
        TAX
        LDA     ZZ
        CMP     #$90
        BCS     L18FD

        LDA     TWOS2,X
        EOR     (SC),Y
        STA     (SC),Y
        LDA     ZZ
        CMP     #$50
        BCS     L1968

        DEY
        BPL     L1961

        LDY     #$01
.L1961
        LDA     TWOS2,X
        EOR     (SC),Y
        STA     (SC),Y
.L1968
        LDY     T1
.L196A
        RTS

.BLINE
        TXA
        ADC     K4
        STA     K6+2
        LDA     K4+1
        ADC     T
        STA     K6+3
        LDA     FLAG
        BEQ     L198C

        INC     FLAG
.L197C
        LDY     LSP
        LDA     #$FF
        CMP     LSY2-1,Y
        BEQ     L19ED

        STA     LSY2,Y
        INC     LSP
        BNE     L19ED

.L198C
        LDA     K5
        STA     XX15
        LDA     QQ19
        STA     Y1
        LDA     QQ19+1
        STA     X2
        LDA     QQ19+2
        STA     Y2
        LDA     K6
        STA     XX15+4
        LDA     K6+1
        STA     XX15+5
        LDA     K6+2
        STA     XX12
        LDA     K6+3
        STA     XX12+1
        JSR     LL145

        BCS     L197C

        LDA     SWAP
        BEQ     L19C5

        LDA     XX15
        LDY     X2
        STA     X2
        STY     XX15
        LDA     Y1
        LDY     Y2
        STA     Y2
        STY     Y1
.L19C5
        LDY     LSP
        LDA     LSY2-1,Y
        CMP     #$FF
        BNE     L19D9

        LDA     XX15
        STA     LSX2,Y
        LDA     Y1
        STA     LSY2,Y
        INY
.L19D9
        LDA     X2
        STA     LSX2,Y
        LDA     Y2
        STA     LSY2,Y
        INY
        STY     LSP
        JSR     LOIN

        LDA     XX13
        BNE     L197C

.L19ED
        LDA     K6
        STA     K5
        LDA     K6+1
        STA     QQ19
        LDA     K6+2
        STA     QQ19+1
        LDA     K6+3
        STA     QQ19+2
        LDA     CNT
        CLC
        ADC     STP
        STA     CNT
        RTS

.FLIP
        LDY     NOSTM
.L1A08
        LDX     SY,Y
        LDA     SX,Y
        STA     Y1
        STA     SY,Y
        TXA
        STA     XX15
        STA     SX,Y
        LDA     SZ,Y
        STA     ZZ
        JSR     PIXEL2

        DEY
        BNE     L1A08

        RTS

.STARS
        LDX     VIEW
        BEQ     L1A33

        DEX
        BNE     L1A30

        JMP     STARS6

.L1A30
        JMP     STARS2

.L1A33
        LDY     NOSTM
.STL1
        JSR     DV42

        LDA     R
        LSR     P
        ROR     A
        LSR     P
        ROR     A
        ORA     #$01
        STA     Q
        LDA     SZL,Y
        SBC     DELT4
        STA     SZL,Y
        LDA     SZ,Y
        STA     ZZ
        SBC     DELT4+1
        STA     SZ,Y
        JSR     L2817

        STA     YY+1
        LDA     P
        ADC     SYL,Y
        STA     YY
        STA     R
        LDA     Y1
        ADC     YY+1
        STA     YY+1
        STA     S
        LDA     SX,Y
        STA     XX15
        JSR     MLU2

        STA     XX+1
        LDA     P
        ADC     SXL,Y
        STA     XX
        LDA     XX15
        ADC     XX+1
        STA     XX+1
        EOR     ALP2+1
        JSR     MLS1

        JSR     ADD

        STA     YY+1
        STX     YY
        EOR     ALP2
        JSR     MLS2

        JSR     ADD

        STA     XX+1
        STX     XX
        LDX     BET1
        LDA     YY+1
        EOR     BET2+1
        JSR     L27C8

        STA     Q
        JSR     MUT2

        ASL     P
        ROL     A
        STA     T
        LDA     #$00
        ROR     A
        ORA     T
        JSR     ADD

        STA     XX+1
        TXA
        STA     SXL,Y
        LDA     YY
        STA     R
        LDA     YY+1
        STA     S
        LDA     #$00
        STA     P
        LDA     BETA
        EOR     #$80
        JSR     PIX1

        LDA     XX+1
        STA     XX15
        STA     SX,Y
        AND     #$7F
        CMP     #$78
        BCS     L1AFD

        LDA     YY+1
        STA     SY,Y
        STA     Y1
        AND     #$7F
        CMP     #$78
        BCS     L1AFD

        LDA     SZ,Y
        CMP     #$10
        BCC     L1AFD

        STA     ZZ
.STC1
        JSR     PIXEL2

        DEY
        BEQ     L1AFC

        JMP     STL1

.L1AFC
        RTS

.L1AFD
        JSR     DORND

        ORA     #$04
        STA     Y1
        STA     SY,Y
        JSR     DORND

        ORA     #$08
        STA     XX15
        STA     SX,Y
        JSR     DORND

        ORA     #$90
        STA     SZ,Y
        STA     ZZ
        LDA     Y1
        JMP     STC1

.STARS6
        LDY     NOSTM
.STL6
        JSR     DV42

        LDA     R
        LSR     P
        ROR     A
        LSR     P
        ROR     A
        ORA     #$01
        STA     Q
        LDA     SX,Y
        STA     XX15
        JSR     MLU2

        STA     XX+1
        LDA     SXL,Y
        SBC     P
        STA     XX
        LDA     XX15
        SBC     XX+1
        STA     XX+1
        JSR     L2817

        STA     YY+1
        LDA     SYL,Y
        SBC     P
        STA     YY
        STA     R
        LDA     Y1
        SBC     YY+1
        STA     YY+1
        STA     S
        LDA     SZL,Y
        ADC     DELT4
        STA     SZL,Y
        LDA     SZ,Y
        STA     ZZ
        ADC     DELT4+1
        STA     SZ,Y
        LDA     XX+1
        EOR     ALP2
        JSR     MLS1

        JSR     ADD

        STA     YY+1
        STX     YY
        EOR     ALP2+1
        JSR     MLS2

        JSR     ADD

        STA     XX+1
        STX     XX
        LDA     YY+1
        EOR     BET2+1
        LDX     BET1
        JSR     L27C8

        STA     Q
        LDA     XX+1
        STA     S
        EOR     #$80
        JSR     L28A2

        ASL     P
        ROL     A
        STA     T
        LDA     #$00
        ROR     A
        ORA     T
        JSR     ADD

        STA     XX+1
        TXA
        STA     SXL,Y
        LDA     YY
        STA     R
        LDA     YY+1
        STA     S
        LDA     #$00
        STA     P
        LDA     BETA
        JSR     PIX1

        LDA     XX+1
        STA     XX15
        STA     SX,Y
        LDA     YY+1
        STA     SY,Y
        STA     Y1
        AND     #$7F
        CMP     #$6E
        BCS     L1BEA

        LDA     SZ,Y
        CMP     #$A0
        BCS     L1BEA

        STA     ZZ
.STC6
        JSR     PIXEL2

        DEY
        BEQ     L1BE9

        JMP     STL6

.L1BE9
        RTS

.L1BEA
        JSR     DORND

        AND     #$7F
        ADC     #$0A
        STA     SZ,Y
        STA     ZZ
        LSR     A
        BCS     L1C0D

        LSR     A
        LDA     #$FC
        ROR     A
        STA     XX15
        STA     SX,Y
        JSR     DORND

        STA     Y1
        STA     SY,Y
        JMP     STC6

.L1C0D
        JSR     DORND

        STA     XX15
        STA     SX,Y
        LSR     A
        LDA     #$E6
        ROR     A
        STA     Y1
        STA     SY,Y
        BNE     STC6

.MAS1
        LDA     XX1,Y
        ASL     A
        STA     K+1
        LDA     INWK+1,Y
        ROL     A
        STA     K+2
        LDA     #$00
        ROR     A
        STA     K+3
        JSR     MVT3

        STA     INWK+2,X
        LDY     K+1
        STY     XX1,X
        LDY     K+2
        STY     INWK+1,X
        AND     #$7F
        RTS

.m
        LDA     #$00
.MAS2
        ORA     K%+2,Y
        ORA     K%+5,Y
        ORA     K%+8,Y
        AND     #$7F
        RTS

.MAS3
        LDA     K%+1,Y
        JSR     SQUA2

        STA     R
        LDA     K%+4,Y
        JSR     SQUA2

        ADC     R
        BCS     L1C6D

        STA     R
        LDA     K%+7,Y
        JSR     SQUA2

        ADC     R
        BCC     L1C6F

.L1C6D
        LDA     #$FF
.L1C6F
        RTS

.L1C70
        LDX     #$09
        CMP     #$19
        BCS     L1CCF

        DEX
        CMP     #$0A
        BCS     L1CCF

        DEX
        CMP     #$02
        BCS     L1CCF

        DEX
        BNE     L1CCF

.STATUS
        LDA     #$08
        JSR     TT66

        JSR     TT111

        LDA     #$07
        STA     XC
        LDA     #$7E
        JSR     NLIN3

        LDA     #$E6
        LDY     JUNK
        LDX     FRIN+2,Y
        BEQ     L1CA5

        LDY     ENERGY
        CPY     #$80
        ADC     #$01
.L1CA5
        JSR     plf

        LDA     #$7D
        JSR     spc

        LDA     #$13
        LDY     FIST
        BEQ     L1CB8

        CPY     #$32
        ADC     #$01
.L1CB8
        JSR     plf

        LDA     #$10
        JSR     spc

        LDA     TALLY+1
        BNE     L1C70

        TAX
        LDA     TALLY
        LSR     A
        LSR     A
.L1CCB
        INX
        LSR     A
        BNE     L1CCB

.L1CCF
        TXA
        CLC
        ADC     #$15
        JSR     plf

        LDA     #$12
        JSR     plf2

        LDA     CRGO
        CMP     #$1A
        BCC     L1CE7

        LDA     #$6B
        JSR     plf2

.L1CE7
        LDA     BST
        BEQ     L1CF1

        LDA     #$6F
        JSR     plf2

.L1CF1
        LDA     ECM
        BEQ     L1CFB

        LDA     #$6C
        JSR     plf2

.L1CFB
        LDA     #$71
        STA     XX4
.L1CFF
        TAY
        LDX     FRIN,Y
        BEQ     L1D08

        JSR     plf2

.L1D08
        INC     XX4
        LDA     XX4
        CMP     #$75
        BCC     L1CFF

        LDX     #$00
.L1D12
        STX     CNT
        LDY     LASER,X
        BEQ     L1D3C

        TXA
        CLC
        ADC     #$60
        JSR     spc

        LDA     #$67
        LDX     CNT
        LDY     LASER,X
        CPY     #$8F
        BNE     L1D2D

        LDA     #$68
.L1D2D
        CPY     #$97
        BNE     L1D33

        LDA     #$75
.L1D33
        CPY     #$32
        BNE     L1D39

        LDA     #$76
.L1D39
        JSR     plf2

.L1D3C
        LDX     CNT
        INX
        CPX     #$04
        BCC     L1D12

        RTS

.plf2
        JSR     plf

        LDX     #$06
        STX     XC
        RTS

.MVT3
        LDA     K+3
        STA     S
        AND     #$80
        STA     T
        EOR     INWK+2,X
        BMI     L1D70

        LDA     K+1
        CLC
        ADC     XX1,X
        STA     K+1
        LDA     K+2
        ADC     INWK+1,X
        STA     K+2
        LDA     K+3
        ADC     INWK+2,X
        AND     #$7F
        ORA     T
        STA     K+3
        RTS

.L1D70
        LDA     S
        AND     #$7F
        STA     S
        LDA     XX1,X
        SEC
        SBC     K+1
        STA     K+1
        LDA     INWK+1,X
        SBC     K+2
        STA     K+2
        LDA     INWK+2,X
        AND     #$7F
        SBC     S
        ORA     #$80
        EOR     T
        STA     K+3
        BCS     L1DA7

        LDA     #$01
        SBC     K+1
        STA     K+1
        LDA     #$00
        SBC     K+2
        STA     K+2
        LDA     #$00
        SBC     K+3
        AND     #$7F
        ORA     T
        STA     K+3
.L1DA7
        RTS

.MVS5
        LDA     INWK+1,X
        AND     #$7F
        LSR     A
        STA     T
        LDA     XX1,X
        SEC
        SBC     T
        STA     R
        LDA     INWK+1,X
        SBC     #$00
        STA     S
        LDA     XX1,Y
        STA     P
        LDA     INWK+1,Y
        AND     #$80
        STA     T
        LDA     INWK+1,Y
        AND     #$7F
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        ORA     T
        EOR     RAT2
        STX     Q
        JSR     ADD

        STA     K+1
        STX     K
        LDX     Q
        LDA     INWK+1,Y
        AND     #$7F
        LSR     A
        STA     T
        LDA     XX1,Y
        SEC
        SBC     T
        STA     R
        LDA     INWK+1,Y
        SBC     #$00
        STA     S
        LDA     XX1,X
        STA     P
        LDA     INWK+1,X
        AND     #$80
        STA     T
        LDA     INWK+1,X
        AND     #$7F
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        ORA     T
        EOR     #$80
        EOR     RAT2
        STX     Q
        JSR     ADD

        STA     INWK+1,Y
        STX     XX1,Y
        LDX     Q
        LDA     K
        STA     XX1,X
        LDA     K+1
        STA     INWK+1,X
        RTS

.L1E34
        EQUB    $48,$76,$E8,$00

.pr2
        LDA     #$03
.L1E3A
        LDY     #$00
.TT11
        STA     U
        LDA     #$00
        STA     K
        STA     K+1
        STY     K+2
        STX     K+3
.BPRNT
        LDX     #$0B
        STX     T
        PHP
        BCC     L1E53

        DEC     T
        DEC     U
.L1E53
        LDA     #$0B
        SEC
        STA     XX17
        SBC     U
        STA     U
        INC     U
        LDY     #$00
        STY     S
        JMP     TT36

.TT35
        ASL     K+3
        ROL     K+2
        ROL     K+1
        ROL     K
        ROL     S
        LDX     #$03
.L1E71
        LDA     K,X
        STA     XX15,X
        DEX
        BPL     L1E71

        LDA     S
        STA     XX15+4
        ASL     K+3
        ROL     K+2
        ROL     K+1
        ROL     K
        ROL     S
        ASL     K+3
        ROL     K+2
        ROL     K+1
        ROL     K
        ROL     S
        CLC
        LDX     #$03
.L1E93
        LDA     K,X
        ADC     XX15,X
        STA     K,X
        DEX
        BPL     L1E93

        LDA     XX15+4
        ADC     S
        STA     S
        LDY     #$00
.TT36
        LDX     #$03
        SEC
.L1EA7
        LDA     K,X
        SBC     L1E34,X
        STA     XX15,X
        DEX
        BPL     L1EA7

        LDA     S
        SBC     #$17
        STA     XX15+4
        BCC     L1ECA

        LDX     #$03
.L1EBB
        LDA     XX15,X
        STA     K,X
        DEX
        BPL     L1EBB

        LDA     XX15+4
        STA     S
        INY
        JMP     TT36

.L1ECA
        TYA
        BNE     L1ED9

        LDA     T
        BEQ     L1ED9

        DEC     U
        BPL     L1EE3

        LDA     #$20
        BNE     L1EE0

.L1ED9
        LDY     #$00
        STY     T
        CLC
        ADC     #$30
.L1EE0
        JSR     TT26

.L1EE3
        DEC     T
        BPL     L1EE9

        INC     T
.L1EE9
        DEC     XX17
        BMI     L1F5B

        BNE     L1EF7

        PLP
        BCC     L1EF7

        LDA     #$2E
        JSR     TT26

.L1EF7
        JMP     TT35

.BELL
        LDA     #$07
.TT26
        STA     K3
        STY     YSAV2
        STX     XSAV2
        LDY     K5
        CPY     #$FF
        BEQ     RR4

        CMP     #$07
        BEQ     L1F5C

        CMP     #$20
        BCS     L1F1E

        CMP     #$0A
        BEQ     L1F1A

        LDX     #$01
        STX     XC
.L1F1A
        INC     YC
        BNE     RR4

.L1F1E
        LDX     #$BF
        ASL     A
        ASL     A
        BCC     L1F26

        LDX     #$C1
.L1F26
        ASL     A
        BCC     L1F2A

        INX
.L1F2A
        STA     P+1
        STX     P+2
        LDA     XC
        ASL     A
        ASL     A
        ASL     A
        STA     SC
        INC     XC
        LDA     YC
        CMP     #$18
        BCC     L1F43

        JSR     TT66

        JMP     RR4

.L1F43
        ORA     #$60
.RREN
        STA     SCH
        LDY     #$07
.L1F49
        LDA     (P+1),Y
        EOR     (SC),Y
        STA     (SC),Y
        DEY
        BPL     L1F49

.RR4
        LDY     YSAV2
        LDX     XSAV2
        LDA     K3
        CLC
.L1F5B
        RTS

.L1F5C
        JSR     BEEP

        JMP     RR4

.DIALS
        LDA     #$D0
        STA     SC
        LDA     #$78
        STA     SCH
        JSR     PZW

        STX     K+1
        STA     K
        LDA     #$0E
        STA     T1
        LDA     DELTA
        JSR     L2039

        LDA     #$00
        STA     R
        STA     P
        LDA     #$08
        STA     S
        LDA     ALP1
        LSR     A
        LSR     A
        ORA     ALP2
        EOR     #$80
        JSR     ADD

        JSR     DIL2

        LDA     BETA
        LDX     BET1
        BEQ     L1F9A

        SBC     #$01
.L1F9A
        JSR     ADD

        JSR     DIL2

        LDA     MCNT
        AND     #$03
        BNE     L1F5B

        LDY     #$00
.L1FA8
        JSR     PZW

L1FA9 = L1FA8+1
        STX     K
        STA     K+1
        LDX     #$03
        STX     T1
.L1FB3
        STY     XX12,X
        DEX
        BPL     L1FB3

        LDX     #$03
        LDA     ENERGY
        LSR     A
        LSR     A
        STA     Q
.L1FC1
        SEC
        SBC     #$10
        BCC     L1FD3

        STA     Q
        LDA     #$10
        STA     XX12,X
        LDA     Q
        DEX
        BPL     L1FC1

        BMI     L1FD7

.L1FD3
        LDA     Q
        STA     XX12,X
.L1FD7
        LDA     XX12,Y
        STY     P
        JSR     DIL

        LDY     P
        INY
        CPY     #$04
        BNE     L1FD7

        LDA     #$78
        STA     SCH
        LDA     #$10
        STA     SC
        LDA     FSH
        JSR     DILX

        LDA     ASH
        JSR     DILX

        LDA     QQ14
        JSR     L2038

        JSR     PZW

        STX     K+1
        STA     K
        LDX     #$0B
        STX     T1
        LDA     CABTMP
        JSR     DILX

        LDA     GNTMP
        JSR     DILX

        LDA     #$F0
        STA     T1
        STA     K+1
        LDA     ALTIT
        JSR     DILX

        JMP     COMPAS

.PZW
        LDX     #$F0
        LDA     MCNT
        AND     #$08
        AND     FLH
        BEQ     L2033

        TXA
.L2032
        BIT     SZ+1
L2033 = L2032+1
        RTS

.DILX
        LSR     A
        LSR     A
.L2038
        LSR     A
.L2039
        LSR     A
.DIL
        STA     Q
        LDX     #$FF
        STX     R
        CMP     T1
        BCS     L2048

        LDA     K+1
        BNE     L204A

.L2048
        LDA     K
.L204A
        STA     COL
        LDY     #$02
        LDX     #$03
.L2050
        LDA     Q
        CMP     #$04
        BCC     L2070

        SBC     #$04
        STA     Q
        LDA     R
.DL5
        AND     COL
        STA     (SC),Y
        INY
        STA     (SC),Y
        INY
        STA     (SC),Y
        TYA
        CLC
        ADC     #$06
        TAY
        DEX
        BMI     L208A

        BPL     L2050

.L2070
        EOR     #$03
        STA     Q
        LDA     R
.L2076
        ASL     A
        AND     #$EF
        DEC     Q
        BPL     L2076

        PHA
        LDA     #$00
        STA     R
        LDA     #$63
        STA     Q
        PLA
        JMP     DL5

.L208A
        INC     SCH
        RTS

.DIL2
        LDY     #$01
        STA     Q
.L2091
        SEC
        LDA     Q
        SBC     #$04
        BCS     L20A6

        LDA     #$FF
        LDX     Q
        STA     Q
        LDA     CTWOS,X
        AND     #$F0
        JMP     DLL12

.L20A6
        STA     Q
        LDA     #$00
.DLL12
        STA     (SC),Y
        INY
        STA     (SC),Y
        INY
        STA     (SC),Y
        INY
        STA     (SC),Y
        TYA
        CLC
        ADC     #$05
        TAY
        CPY     #$1E
        BCC     L2091

        INC     SCH
        RTS

.ESCAPE
        JSR     RES2

        LDX     #$0B
        STX     TYPE
        JSR     FRS1

        BCS     L20D2

        LDX     #$18
        JSR     FRS1

.L20D2
        LDA     #$08
        STA     INWK+27
        LDA     #$C2
        STA     INWK+30
        LSR     A
        STA     INWK+32
.L20DD
        JSR     MVEIT

        JSR     LL9

        DEC     INWK+32
        BNE     L20DD

        JSR     SCAN

        LDA     #$00
        LDX     #$10
.L20EE
        STA     QQ20,X
        DEX
        BPL     L20EE

        STA     FIST
        STA     ESCP
        LDA     #$46
        STA     QQ14
        JMP     GOIN

.L2102
        LDA     #$00
        JSR     MAS4

        BEQ     L210C

        JMP     TA21

.L210C
        JSR     L2160

        JSR     EXNO3

        LDA     #$FA
        JMP     OOPS

.L2117
        LDA     ECMA
        BNE     L2150

        LDA     INWK+32
        ASL     A
        BMI     L2102

        LSR     A
        TAX
        LDA     UNIV,X
        STA     V
        LDA     UNIV+1,X
        JSR     VCSUB

        LDA     K3+2
        ORA     K3+5
        ORA     K3+8
        AND     #$7F
        ORA     K3+1
        ORA     K3+4
        ORA     K3+7
        BNE     L2166

        LDA     INWK+32
        CMP     #$82
        BEQ     L2150

        LDY     #$1F
        LDA     (V),Y
        BIT     L216E
        BNE     L2150

        ORA     #$80
        STA     (V),Y
.L2150
        LDA     XX1
        ORA     INWK+3
        ORA     INWK+6
        BNE     TA87

        LDA     #$50
        JSR     OOPS

.TA87
        JSR     EXNO2

.L2160
        ASL     INWK+31
        SEC
        ROR     INWK+31
.L2165
        RTS

.L2166
        JSR     DORND

        CMP     #$10
        BCS     L2174

.M32
        LDY     #$20
L216E = M32+1
        LDA     (V),Y
        LSR     A
        BCS     L2177

.L2174
        JMP     TA19

.L2177
        JMP     ECBLB2

.TACTICS
        LDY     #$03
        STY     RAT
        INY
        STY     RAT2
        LDA     #$16
        STA     CNT2
        CPX     #$01
        BEQ     L2117

        CPX     #$02
        BNE     L21BB

        LDA     NEWB
        AND     #$04
        BNE     L21A6

        LDA     MANY+10
        BNE     L2165

        JSR     DORND

        CMP     #$FD
        BCC     L2165

        AND     #$01
        ADC     #$08
        TAX
        BNE     TN6

.L21A6
        JSR     DORND

        CMP     #$F0
        BCC     L2165

        LDA     MANY+16
        CMP     #$04
        BCS     L21D4

        LDX     #$10
.TN6
        LDA     #$F1
        JMP     SFS1

.L21BB
        LDY     #$0E
        LDA     INWK+35
        CMP     (XX0),Y
        BCS     TA21

        INC     INWK+35
.TA21
        CPX     #$1E
        BNE     L21D5

        LDA     MANY+29
        BNE     L21D5

        LSR     INWK+32
        ASL     INWK+32
        LSR     INWK+27
.L21D4
        RTS

.L21D5
        JSR     DORND

        LDA     NEWB
        LSR     A
        BCC     L21E1

        CPX     #$64
        BCS     L21D4

.L21E1
        LSR     A
        BCC     L21F3

        LDX     FIST
        CPX     #$28
        BCC     L21F3

        LDA     NEWB
        ORA     #$04
        STA     NEWB
        LSR     A
        LSR     A
.L21F3
        LSR     A
        BCS     L2203

        LSR     A
        LSR     A
        BCC     GOPL

        JMP     DOCKIT

.GOPL
        JSR     SPS1

        JMP     TA151

.L2203
        LSR     A
        BCC     L2211

        LDA     SSPR
        BEQ     L2211

        LDA     INWK+32
        AND     #$81
        STA     INWK+32
.L2211
        LDX     #$08
.L2213
        LDA     XX1,X
        STA     K3,X
        DEX
        BPL     L2213

.TA19
        JSR     TAS2

        JSR     L28DE

        STA     CNT
        LDA     TYPE
        CMP     #$01
        BNE     L222B

        JMP     TA20

.L222B
        CMP     #$0E
        BNE     L223B

        JSR     DORND

        CMP     #$C8
        BCC     L223B

        LDX     #$17
        JMP     TN6

.L223B
        JSR     DORND

        CMP     #$FA
        BCC     L2249

        JSR     DORND

        ORA     #$68
        STA     INWK+29
.L2249
        LDY     #$0E
        LDA     (XX0),Y
        LSR     A
        CMP     INWK+35
        BCC     L2294

        LSR     A
        LSR     A
        CMP     INWK+35
        BCC     L226D

        JSR     DORND

        CMP     #$E6
        BCC     L226D

        LDX     TYPE
        LDA     L563D,X
        BPL     L226D

        LDA     #$00
        STA     INWK+32
        JMP     SESCP

.L226D
        LDA     INWK+31
        AND     #$07
        BEQ     L2294

        STA     T
        JSR     DORND

        AND     #$1F
        CMP     T
        BCS     L2294

        LDA     ECMA
        BNE     L2294

        DEC     INWK+31
        LDA     TYPE
        CMP     #$1D
        BNE     L2291

        LDX     #$1E
        LDA     INWK+32
        JMP     SFS1

.L2291
        JMP     SFRMIS

.L2294
        LDA     #$00
        JSR     MAS4

        AND     #$E0
        BNE     L22C6

        LDX     CNT
        CPX     #$A0
        BCC     L22C6

        LDY     #$13
        LDA     (XX0),Y
        AND     #$F8
        BEQ     L22C6

        LDA     INWK+31
        ORA     #$40
        STA     INWK+31
        CPX     #$A3
        BCC     L22C6

        LDA     (XX0),Y
        LSR     A
        JSR     OOPS

        DEC     INWK+28
        LDA     ECMA
        BNE     L2311

        LDA     #$08
        JMP     NOISE

.L22C6
        LDA     INWK+7
        CMP     #$03
        BCS     L22D4

        LDA     INWK+1
        ORA     INWK+4
        AND     #$FE
        BEQ     L22E6

.L22D4
        JSR     DORND

        ORA     #$80
        CMP     INWK+32
        BCS     L22E6

.TA20
        JSR     TAS6

        LDA     CNT
        EOR     #$80
.TA152
        STA     CNT
.L22E6
        LDY     #$10
        JSR     TAS3

        TAX
        JSR     nroll

        STA     INWK+30
        LDA     INWK+29
        ASL     A
        CMP     #$20
        BCS     L2305

        LDY     #$16
        JSR     TAS3

        TAX
        EOR     INWK+30
        JSR     nroll

        STA     INWK+29
.L2305
        LDA     CNT
        BMI     L2312

        CMP     CNT2
        BCC     L2312

        LDA     #$03
        STA     INWK+28
.L2311
        RTS

.L2312
        AND     #$7F
        CMP     #$12
        BCC     L2323

        LDA     #$FF
        LDX     TYPE
        CPX     #$01
        BNE     L2321

        ASL     A
.L2321
        STA     INWK+28
.L2323
        RTS

.TA151
        JSR     L28DE

        CMP     #$98
        BCC     L232F

        LDX     #$00
        STX     RAT2
.L232F
        JMP     TA152

.nroll
        EOR     #$80
        AND     #$80
        STA     T
        TXA
        ASL     A
        CMP     RAT2
        BCC     L2343

        LDA     RAT
        ORA     T
        RTS

.L2343
        LDA     T
        RTS

.DOCKIT
        LDA     #$06
        STA     RAT2
        LSR     A
        STA     RAT
        LDA     #$1D
        STA     CNT2
        LDA     SSPR
        BNE     L2359

.L2356
        JMP     GOPL

.L2359
        JSR     VCSU1

        LDA     K3+2
        ORA     K3+5
        ORA     K3+8
        AND     #$7F
        BNE     L2356

        JSR     TA2

        LDA     Q
        STA     K
        JSR     TAS2

        LDY     #$0A
        JSR     TAS4

        BMI     L239A

        CMP     #$23
        BCC     L239A

        JSR     L28DE

        CMP     #$A2
        BCS     L23B4

        LDA     K
        CMP     #$9D
        BCC     L238C

        LDA     TYPE
        BMI     L23B4

.L238C
        JSR     TAS6

        JSR     TA151

.PH22
        LDX     #$00
        STX     INWK+28
        INX
        STX     INWK+27
        RTS

.L239A
        JSR     VCSU1

        JSR     DCS1

        JSR     DCS1

        JSR     TAS2

        JSR     TAS6

        JMP     TA151

.L23AC
        INC     INWK+28
        LDA     #$7F
        STA     INWK+29
        BNE     L23F9

.L23B4
        LDX     #$00
        STX     RAT2
        STX     INWK+30
        LDA     TYPE
        BPL     L23DE

        EOR     XX15
        EOR     Y1
        ASL     A
        LDA     #$02
        ROR     A
        STA     INWK+29
        LDA     XX15
        ASL     A
        CMP     #$0C
        BCS     PH22

        LDA     Y1
        ASL     A
        LDA     #$02
        ROR     A
        STA     INWK+30
        LDA     Y1
        ASL     A
        CMP     #$0C
        BCS     PH22

.L23DE
        STX     INWK+29
        LDA     INWK+22
        STA     XX15
        LDA     INWK+24
        STA     Y1
        LDA     INWK+26
        STA     X2
        LDY     #$10
        JSR     TAS4

        ASL     A
        CMP     #$42
        BCS     L23AC

        JSR     PH22

.L23F9
        LDA     K3+10
        BNE     L2402

        ASL     NEWB
        SEC
        ROR     NEWB
.L2402
        RTS

.VCSU1
        LDA     #$25
        STA     V
        LDA     #$09
.VCSUB
        STA     V+1
        LDY     #$02
        JSR     TAS1

        LDY     #$05
        JSR     TAS1

        LDY     #$08
.TAS1
        LDA     (V),Y
        EOR     #$80
        STA     K+3
        DEY
        LDA     (V),Y
        STA     K+2
        DEY
        LDA     (V),Y
        STA     K+1
        STY     U
        LDX     U
        JSR     MVT3

        LDY     U
        STA     K3+2,X
        LDA     K+2
        STA     K3+1,X
        LDA     K+1
        STA     K3,X
        RTS

.TAS4
        LDX     K%+37,Y
        STX     Q
        LDA     XX15
        JSR     MULT12

        LDX     K%+39,Y
        STX     Q
        LDA     Y1
        JSR     MAD

        STA     S
        STX     R
        LDX     K%+41,Y
        STX     Q
        LDA     X2
        JMP     MAD

.TAS6
        LDA     XX15
        EOR     #$80
        STA     XX15
        LDA     Y1
        EOR     #$80
        STA     Y1
        LDA     X2
        EOR     #$80
        STA     X2
        RTS

.DCS1
        JSR     L2473

.L2473
        LDA     K%+$2F
        LDX     #$00
        JSR     TAS7

        LDA     K%+$31
        LDX     #$03
        JSR     TAS7

        LDA     K%+$33
        LDX     #$06
.TAS7
        ASL     A
        STA     R
        LDA     #$00
        ROR     A
        EOR     #$80
        EOR     K3+2,X
        BMI     L249F

        LDA     R
        ADC     K3,X
        STA     K3,X
        BCC     TS72

        INC     K3+1,X
.TS72
        RTS

.L249F
        LDA     K3,X
        SEC
        SBC     R
        STA     K3,X
        LDA     K3+1,X
        SBC     #$00
        STA     K3+1,X
        BCS     TS72

        LDA     K3,X
        EOR     #$FF
        ADC     #$01
        STA     K3,X
        LDA     K3+1,X
        EOR     #$FF
        ADC     #$00
        STA     K3+1,X
        LDA     K3+2,X
        EOR     #$80
        STA     K3+2,X
        JMP     TS72

.HITCH
        CLC
        LDA     INWK+8
        BNE     L2505

        LDA     TYPE
        BMI     L2505

        LDA     INWK+31
        AND     #$20
        ORA     INWK+1
        ORA     INWK+4
        BNE     L2505

        LDA     XX1
        JSR     SQUA2

        STA     S
        LDA     P
        STA     R
        LDA     INWK+3
        JSR     SQUA2

        TAX
        LDA     P
        ADC     R
        STA     R
        TXA
        ADC     S
        BCS     L2506

        STA     S
        LDY     #$02
        LDA     (XX0),Y
        CMP     S
        BNE     L2505

        DEY
        LDA     (XX0),Y
        CMP     R
.L2505
        RTS

.L2506
        CLC
        RTS

.FRS1
        JSR     ZINF

        LDA     #$1C
        STA     INWK+3
        LSR     A
        STA     INWK+6
        LDA     #$80
        STA     INWK+5
        LDA     MSTG
        ASL     A
        ORA     #$80
        STA     INWK+32
.fq1
        LDA     #$60
        STA     INWK+14
        ORA     #$80
        STA     INWK+22
        LDA     DELTA
        ROL     A
        STA     INWK+27
        TXA
        JMP     NWSHP

.FRMIS
        LDX     #$01
        JSR     FRS1

        BCC     L2589

        LDX     MSTG
        JSR     GINF

        LDA     FRIN,X
        JSR     ANGRY

        LDY     #$00
        JSR     ABORT

        DEC     NOMSL
        LDA     #$30
        JMP     NOISE

.ANGRY
        CMP     #$02
        BEQ     AN2

        LDY     #$24
        LDA     (INF),Y
        AND     #$20
        BEQ     L255C

        JSR     AN2

.L255C
        LDY     #$20
        LDA     (INF),Y
        BEQ     L2505

        ORA     #$80
        STA     (INF),Y
        LDY     #$1C
        LDA     #$02
        STA     (INF),Y
        ASL     A
        LDY     #$1E
        STA     (INF),Y
        LDA     TYPE
        CMP     #$0B
        BCC     L257F

        LDY     #$24
        LDA     (INF),Y
        ORA     #$04
        STA     (INF),Y
.L257F
        RTS

.AN2
        LDA     K%+$49
        ORA     #$04
        STA     K%+$49
        RTS

.L2589
        LDA     #$C9
        JMP     MESS

.SESCP
        LDX     #$03
.L2590
        LDA     #$FE
.SFS1
        STA     T1
        TXA
        PHA
        LDA     XX0
        PHA
        LDA     XX0+1
        PHA
        LDA     INF
        PHA
        LDA     INF+1
        PHA
        LDY     #$24
.L25A4
        LDA     XX1,Y
        STA     XX3,Y
        LDA     (INF),Y
        STA     XX1,Y
        DEY
        BPL     L25A4

        LDA     NEWB
        AND     #$1C
        STA     NEWB
        LDA     TYPE
        CMP     #$02
        BNE     L25DB

        TXA
        PHA
        LDA     #$20
        STA     INWK+27
        LDX     #$00
        LDA     INWK+10
        JSR     SFS2

        LDX     #$03
        LDA     INWK+12
        JSR     SFS2

        LDX     #$06
        LDA     INWK+14
        JSR     SFS2

        PLA
        TAX
.L25DB
        LDA     T1
        STA     INWK+32
        LSR     INWK+29
        ASL     INWK+29
        TXA
        CMP     #$09
        BCS     L25FE

        CMP     #$04
        BCC     L25FE

        PHA
        JSR     DORND

        ASL     A
        STA     INWK+30
        TXA
        AND     #$0F
        STA     INWK+27
        LDA     #$FF
        ROR     A
        STA     INWK+29
        PLA
.L25FE
        JSR     NWSHP

        PLA
        STA     INF+1
        PLA
        STA     INF
        LDX     #$24
.L2609
        LDA     XX3,X
        STA     XX1,X
        DEX
        BPL     L2609

        PLA
        STA     XX0+1
        PLA
        STA     XX0
        PLA
        TAX
        RTS

.SFS2
        ASL     A
        STA     R
        LDA     #$00
        ROR     A
        JMP     MVT1

.LL164
        LDA     #$38
        JSR     NOISE

        LDA     #$01
        STA     HFX
        LDA     #$04
        JSR     HFS2

        DEC     HFX
        RTS

.LAUN
        LDA     #$30
        JSR     NOISE

        LDA     #$08
.HFS2
        STA     STP
        JSR     TTX66

.L2642
        LDX     #$80
        STX     K3
        LDX     #$60
        STX     K4
        LDX     #$00
        STX     XX4
        STX     K3+1
        STX     K4+1
.L2652
        JSR     HFL1

        INC     XX4
        LDX     XX4
        CPX     #$08
        BNE     L2652

        RTS

.HFL1
        LDA     XX4
        AND     #$07
        CLC
        ADC     #$08
        STA     K
.L2667
        LDA     #$01
        STA     LSP
        JSR     CIRCLE2

        ASL     K
        BCS     L2678

        LDA     K
        CMP     #$A0
        BCC     L2667

.L2678
        RTS

.STARS2
        LDA     #$00
        CPX     #$02
        ROR     A
        STA     RAT
        EOR     #$80
        STA     RAT2
        JSR     ST2

        LDY     NOSTM
.STL2
        LDA     SZ,Y
        STA     ZZ
        LSR     A
        LSR     A
        LSR     A
        JSR     DV41

        LDA     P
        EOR     RAT2
        STA     S
        LDA     SXL,Y
        STA     P
        LDA     SX,Y
        STA     XX15
        JSR     ADD

        STA     S
        STX     R
        LDA     SY,Y
        STA     Y1
        EOR     BET2
        LDX     BET1
        JSR     L27C8

        JSR     ADD

        STX     XX
        STA     XX+1
        LDX     SYL,Y
        STX     R
        LDX     Y1
        STX     S
        LDX     BET1
        EOR     BET2+1
        JSR     L27C8

        JSR     ADD

        STX     YY
        STA     YY+1
        LDX     ALP1
        EOR     ALP2
        JSR     L27C8

        STA     Q
        LDA     XX
        STA     R
        LDA     XX+1
        STA     S
        EOR     #$80
        JSR     MAD

        STA     XX+1
        TXA
        STA     SXL,Y
        LDA     YY
        STA     R
        LDA     YY+1
        STA     S
        JSR     MAD

        STA     S
        STX     R
        LDA     #$00
        STA     P
        LDA     ALPHA
        JSR     PIX1

        LDA     XX+1
        STA     SX,Y
        STA     XX15
        AND     #$7F
        CMP     #$74
        BCS     L2748

        LDA     YY+1
        STA     SY,Y
        STA     Y1
        AND     #$7F
        CMP     #$74
        BCS     L275B

.L2724
        JSR     PIXEL2

        DEY
        BEQ     ST2

        JMP     STL2

.ST2
        LDA     ALPHA
        EOR     RAT
        STA     ALPHA
        LDA     ALP2
        EOR     RAT
        STA     ALP2
        EOR     #$80
        STA     ALP2+1
        LDA     BET2
        EOR     RAT
        STA     BET2
        EOR     #$80
        STA     BET2+1
        RTS

.L2748
        JSR     DORND

        STA     Y1
        STA     SY,Y
        LDA     #$73
        ORA     RAT
        STA     XX15
        STA     SX,Y
        BNE     L276C

.L275B
        JSR     DORND

        STA     XX15
        STA     SX,Y
        LDA     #$6E
        ORA     ALP2+1
        STA     Y1
        STA     SY,Y
.L276C
        JSR     DORND

        ORA     #$08
        STA     ZZ
        STA     SZ,Y
        BNE     L2724

.L2778
        STA     K
        STA     K+1
        STA     K+2
        STA     K+3
        CLC
        RTS

.MULT3
        STA     R
        AND     #$7F
        STA     K+2
        LDA     Q
        AND     #$7F
        BEQ     L2778

        SEC
        SBC     #$01
        STA     T
        LDA     P+1
        LSR     K+2
        ROR     A
        STA     K+1
        LDA     P
        ROR     A
        STA     K
        LDA     #$00
        LDX     #$18
.L27A3
        BCC     L27A7

        ADC     T
.L27A7
        ROR     A
        ROR     K+2
        ROR     K+1
        ROR     K
        DEX
        BNE     L27A3

        STA     T
        LDA     R
        EOR     Q
        AND     #$80
        ORA     T
        STA     K+3
        RTS

.MLS2
        LDX     XX
        STX     R
        LDX     XX+1
        STX     S
.MLS1
        LDX     ALP1
.L27C8
        STX     P
        TAX
        AND     #$80
        STA     T
        TXA
        AND     #$7F
        BEQ     L2838

        TAX
        DEX
        STX     T1
        LDA     #$00
        LSR     P
        BCC     L27E0

        ADC     T1
.L27E0
        ROR     A
        ROR     P
        BCC     L27E7

        ADC     T1
.L27E7
        ROR     A
        ROR     P
        BCC     L27EE

        ADC     T1
.L27EE
        ROR     A
        ROR     P
        BCC     L27F5

        ADC     T1
.L27F5
        ROR     A
        ROR     P
        BCC     L27FC

        ADC     T1
.L27FC
        ROR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        LSR     A
        ROR     P
        ORA     T
        RTS

.SQUA
        AND     #$7F
.SQUA2
        STA     P
        TAX
        BNE     L2824

.L2812
        CLC
        STX     P
        TXA
        RTS

.L2817
        LDA     SY,Y
        STA     Y1
.MLU2
        AND     #$7F
        STA     P
.MULTU
        LDX     Q
        BEQ     L2812

.L2824
        DEX
        STX     T
        LDA     #$00
        LDX     #$08
        LSR     P
.L282D
        BCC     L2831

        ADC     T
.L2831
        ROR     A
        ROR     P
        DEX
        BNE     L282D

        RTS

.L2838
        STA     P+1
        STA     P
        RTS

.FMLTU2
        AND     #$1F
        TAX
        LDA     SNE,X
        STA     Q
        LDA     K
.FMLTU
        EOR     #$FF
        SEC
        ROR     A
        STA     P
        LDA     #$00
.L284F
        BCS     L2859

        ADC     Q
        ROR     A
        LSR     P
        BNE     L284F

        RTS

.L2859
        LSR     A
        LSR     P
        BNE     L284F

        RTS

        LDX     Q
        BEQ     L2812

        DEX
        STX     T
        LDA     #$00
        LDX     #$08
        LSR     P
.L286C
        BCC     L2870

        ADC     T
.L2870
        ROR     A
        ROR     P
        DEX
        BNE     L286C

        RTS

.L2877
        STX     Q
.MLTU2
        EOR     #$FF
        LSR     A
        STA     P+1
        LDA     #$00
        LDX     #$10
        ROR     P
.L2884
        BCS     L2891

        ADC     Q
        ROR     A
        ROR     P+1
        ROR     P
        DEX
        BNE     L2884

        RTS

.L2891
        LSR     A
        ROR     P+1
        ROR     P
        DEX
        BNE     L2884

        RTS

        LDX     ALP1
        STX     P
.MUT2
        LDX     XX+1
        STX     S
.L28A2
        LDX     XX
        STX     R
.MULT1
        TAX
        AND     #$7F
        LSR     A
        STA     P
        TXA
        EOR     Q
        AND     #$80
        STA     T
        LDA     Q
        AND     #$7F
        BEQ     L28D1

        TAX
        DEX
        STX     T1
        LDA     #$00
        LDX     #$07
.L28C1
        BCC     L28C5

        ADC     T1
.L28C5
        ROR     A
        ROR     P
        DEX
        BNE     L28C1

        LSR     A
        ROR     P
        ORA     T
        RTS

.L28D1
        STA     P
        RTS

.MULT12
        JSR     MULT1

        STA     S
        LDA     P
        STA     R
        RTS

.L28DE
        LDY     #$0A
.TAS3
        LDX     XX1,Y
        STX     Q
        LDA     XX15
        JSR     MULT12

        LDX     INWK+2,Y
        STX     Q
        LDA     Y1
        JSR     MAD

        STA     S
        STX     R
        LDX     INWK+4,Y
        STX     Q
        LDA     X2
.MAD
        JSR     MULT1

.ADD
        STA     T1
        AND     #$80
        STA     T
        EOR     S
        BMI     L2916

        LDA     R
        CLC
        ADC     P
        TAX
        LDA     S
        ADC     T1
        ORA     T
        RTS

.L2916
        LDA     S
        AND     #$7F
        STA     U
        LDA     P
        SEC
        SBC     R
        TAX
        LDA     T1
        AND     #$7F
        SBC     U
        BCS     L2938

        STA     U
        TXA
        EOR     #$FF
        ADC     #$01
        TAX
        LDA     #$00
        SBC     U
        ORA     #$80
.L2938
        EOR     T
        RTS

.TIS1
        STX     Q
        EOR     #$80
        JSR     MAD

        TAX
        AND     #$80
        STA     T
        TXA
        AND     #$7F
        LDX     #$FE
        STX     T1
.L294E
        ASL     A
        CMP     #$60
        BCC     L2955

        SBC     #$60
.L2955
        ROL     T1
        BCS     L294E

        LDA     T1
        ORA     T
        RTS

.DV42
        LDA     SZ,Y
.DV41
        STA     Q
        LDA     DELTA
.DVID4
        LDX     #$08
        ASL     A
        STA     P
        LDA     #$00
.L296C
        ROL     A
        BCS     L2973

        CMP     Q
        BCC     L2976

.L2973
        SBC     Q
        SEC
.L2976
        ROL     P
        DEX
        BNE     L296C

        JMP     L47F3

.DVID3B2
        STA     P+2
        LDA     INWK+6
        STA     Q
        LDA     INWK+7
        STA     R
        LDA     INWK+8
        STA     S
        LDA     P
        ORA     #$01
        STA     P
        LDA     P+2
        EOR     S
        AND     #$80
        STA     T
        LDY     #$00
        LDA     P+2
        AND     #$7F
.L29A0
        CMP     #$40
        BCS     L29AC

        ASL     P
        ROL     P+1
        ROL     A
        INY
        BNE     L29A0

.L29AC
        STA     P+2
        LDA     S
        AND     #$7F
        BMI     L29BC

.L29B4
        DEY
        ASL     Q
        ROL     R
        ROL     A
        BPL     L29B4

.L29BC
        STA     Q
        LDA     #$FE
        STA     R
        LDA     P+2
        JSR     L47F7

        LDA     #$00
        STA     K+1
        STA     K+2
        STA     K+3
        TYA
        BPL     L29F0

        LDA     R
.L29D4
        ASL     A
        ROL     K+1
        ROL     K+2
        ROL     K+3
        INY
        BNE     L29D4

        STA     K
        LDA     K+3
        ORA     T
        STA     K+3
        RTS

.L29E7
        LDA     R
        STA     K
        LDA     T
        STA     K+3
        RTS

.L29F0
        BEQ     L29E7

        LDA     R
.L29F4
        LSR     A
        DEY
        BNE     L29F4

        STA     K
        LDA     T
        STA     K+3
        RTS

.cntr
        LDA     auto
        BNE     L2A09

        LDA     DAMP
        BNE     L2A15

.L2A09
        TXA
        BPL     L2A0F

        DEX
        BMI     L2A15

.L2A0F
        INX
        BNE     L2A15

        DEX
        BEQ     L2A0F

.L2A15
        RTS

.BUMP2
        STA     T
        TXA
        CLC
        ADC     T
        TAX
        BCC     L2A21

        LDX     #$FF
.L2A21
        BPL     L2A33

.L2A23
        LDA     T
        RTS

.REDU2
        STA     T
        TXA
        SEC
        SBC     T
        TAX
        BCS     L2A31

        LDX     #$01
.L2A31
        BPL     L2A23

.L2A33
        LDA     DJD
        BNE     L2A23

        LDX     #$80
        BMI     L2A23

.ARCTAN
        LDA     P
        EOR     Q
        STA     T1
        LDA     Q
        BEQ     L2A6B

        ASL     A
        STA     Q
        LDA     P
        ASL     A
        CMP     Q
        BCS     L2A59

        JSR     ARS1

        SEC
.L2A54
        LDX     T1
        BMI     L2A6E

        RTS

.L2A59
        LDX     Q
        STA     Q
        STX     P
        TXA
        JSR     ARS1

        STA     T
        LDA     #$40
        SBC     T
        BCS     L2A54

.L2A6B
        LDA     #$3F
        RTS

.L2A6E
        STA     T
        LDA     #$80
        SBC     T
        RTS

.ARS1
        JSR     LL28

        LDA     R
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     ACT,X
.L2A81
        RTS

.LASLI
        JSR     DORND

        AND     #$07
        ADC     #$5C
        STA     LASY
        JSR     DORND

        AND     #$07
        ADC     #$7C
        STA     LASX
        LDA     GNTMP
        ADC     #$08
        STA     GNTMP
        JSR     DENGY

.LASLI2
        LDA     QQ11
        BNE     L2A81

        LDA     #$20
        LDY     #$E0
        JSR     L2AB0

        LDA     #$30
        LDY     #$D0
.L2AB0
        STA     X2
        LDA     LASX
        STA     XX15
        LDA     LASY
        STA     Y1
        LDA     #$BF
        STA     Y2
        JSR     LOIN

        LDA     LASX
        STA     XX15
        LDA     LASY
        STA     Y1
        STY     X2
        LDA     #$BF
        STA     Y2
        JMP     LOIN

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
        JSR     L339A

.TTX69
        INC     YC
.TT69
        LDA     #$80
        STA     K5
.TT67
        LDA     #$0C
        JMP     L339A

.L2B65
        LDA     #$AD
        JSR     L339A

        JMP     TT72

.spc
        JSR     L339A

        JMP     TT162

.TT25
        LDA     #$01
        JSR     TT66

        LDA     #$09
        STA     XC
        LDA     #$A3
        JSR     L339A

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
        JSR     L339A

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
        JSR     L339A

        LDA     QQ15+4
        BMI     L2BF4

        LDA     #$BC
        JSR     L339A

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
        JSR     L339A

.TT76
        LDA     #$53
        JSR     L339A

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
        JSR     L339A

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
        JSR     L339A

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
        JSR     L339A

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
        JSR     L339A

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
        JSR     L339A

        LDA     QQ8+1
        BNE     L30B9

        LDA     QQ14
        CMP     QQ8
        BCC     L30B9

        LDA     #$2D
        JSR     L339A

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
        JSR     L339A

        LDA     #$3F
        JMP     L339A

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
        JSR     L339A

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

        JSR     L1E3A

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
        JMP     L339A

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
        JSR     L2642

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
        JSR     L339A

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
        BNE     L339A

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
        JSR     L339A

        JMP     TT67

.TT68
        JSR     L339A

.L3398
        LDA     #$3A
.L339A
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
        JSR     L339A

        LDA     QQ16+1,Y
        CMP     #$3F
        BEQ     L3468

        JMP     L339A

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
        JSR     L339A

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
TT27 = L36DF+1
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
        BIT     L1FA9
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
.L42A8
        STA     (SC),Y
        DEY
        BNE     L42A8

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
        JSR     L2590

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
        JSR     L339A

        LSR     de
        BCC     L45B4

        LDA     #$FD
        JMP     L339A

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
.L47F7
        ASL     A
        BCS     L4805

        CMP     Q
        BCC     L4800

        SBC     Q
.L4800
        ROL     R
        BCS     L47F7

        RTS

.L4805
        SBC     Q
        SEC
        ROL     R
        BCS     L47F7

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
        JSR     L2877

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
        JSR     L2877

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
        JSR     L2877

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
        JSR     L339A

        JSR     TT162

        LDA     #$AF
        JSR     L339A

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
