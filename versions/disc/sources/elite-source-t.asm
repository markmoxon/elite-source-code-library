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
OSWRCH = &FFEE          \ The address for the OSWRCH routine
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

NRU% = 0                \ The number of planetary systems with special extended
                        \ descriptions in the RUTOK table. The value of this
                        \ variable is 0 in the original source, but this appears
                        \ to be a bug, as it should be 26

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/6502sp/main/workspace/up.asm"

QQ18 = &0400
SNE = &07C0
ACT = &07E0
QQ16_FLIGHT = &0880

INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

L00FD = &00FD
L0B00 = &0B00
L0B4A = &0B4A
L0B4B = &0B4B
L0C00 = &0C00
L0C03 = &0C03
L0C0B = &0C0B
L0C0F = &0C0F
L0D7A = &0D7A
L0E20 = &0E20

L117C = &117C
L1180 = &1180
L1181 = &1181
L1188 = &1188
L1189 = &1189
L11D3 = &11D3
L11D4 = &11D4
L8888 = &8888
L9A3A = &9A3A
LB0A9 = &B0A9

CODE% = &11E3



        ORG     CODE%

.x11E3
        JMP     DOENTRY
        JMP     DOBEGIN
        JMP     CHPR

        EQUB    $4B,$11
        EQUB    $4C

.BRKV
        EQUB    $D5
        EQUB    $11

.INBAY
        LDX     #$00
        LDY     #$00
        JSR     &8888
        JMP     SCRAM

.DOBEGIN
        JSR     scramble
        JMP     BEGIN

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
        BNE     &1207
        INX
        CPX     #$60
        BNE     &1207
        JMP     BRKBK

INCLUDE "library/6502sp/main/subroutine/doentry.asm"

.SCRAM
        JSR     scramble
        JSR     RES2
        JMP     TT170

INCLUDE "library/6502sp/main/subroutine/brkbk.asm"
INCLUDE "library/6502sp/main/subroutine/mt27.asm"
INCLUDE "library/6502sp/main/subroutine/mt28.asm"
INCLUDE "library/6502sp/main/subroutine/detok3.asm"
INCLUDE "library/6502sp/main/subroutine/detok.asm"
INCLUDE "library/6502sp/main/subroutine/detok2.asm"
INCLUDE "library/6502sp/main/subroutine/mt1.asm"
INCLUDE "library/6502sp/main/subroutine/mt2.asm"
INCLUDE "library/6502sp/main/subroutine/mt8.asm"
INCLUDE "library/6502sp/main/subroutine/mt9.asm"
INCLUDE "library/6502sp/main/subroutine/mt13.asm"
INCLUDE "library/6502sp/main/subroutine/mt6.asm"
INCLUDE "library/6502sp/main/subroutine/mt5.asm"
INCLUDE "library/6502sp/main/subroutine/mt14.asm"
INCLUDE "library/6502sp/main/subroutine/mt15.asm"
INCLUDE "library/6502sp/main/subroutine/mt17.asm"
INCLUDE "library/6502sp/main/subroutine/mt18.asm"
INCLUDE "library/6502sp/main/subroutine/mt19.asm"
INCLUDE "library/6502sp/main/subroutine/vowel.asm"
INCLUDE "library/6502sp/main/variable/jmtb.asm"
INCLUDE "library/6502sp/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"


.MVEIT
        LDA     INWK+31
        AND     #$20
        BNE     &14F2

        LDA     MCNT
        EOR     XSAV
        AND     #$0F
        BNE     &14F2

        JSR     TIDY

.L14F2
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
        BEQ     &152A

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

.L152A
        LDA     INWK+29
        AND     #$80
        STA     RAT2
        LDA     INWK+29
        AND     #$7F
        BEQ     &1553

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

.L1553
        LDA     INWK+31
        AND     #$20
        BNE     &155F

        LDA     INWK+31
        ORA     #$10
        STA     INWK+31
.L155F
        LDA     INWK+31
        AND     #$EF
        STA     INWK+31
        RTS

        AND     #$80
        ASL     A
        STA     S
        LDA     #$00
        ROR     A
        STA     T
        LSR     S
        EOR     INWK+2,X
        BMI     &158B

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

.L158B
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
        BCS     &15BC

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
.L15BC
        RTS

        LDA     K+3
        STA     S
        AND     #$80
        STA     T
        EOR     INWK+2,X
        BMI     &15E1

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

.L15E1
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
        BCS     &1618

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
.L1618
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
        JSR     &22B0

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
        JSR     &22B0

        STA     INWK+1,Y
        STX     XX1,Y
        LDX     Q
        LDA     K
        STA     XX1,X
        LDA     K+1
        STA     INWK+1,X
        RTS

        TAY
        EOR     INWK+2,X
        BMI     &1720

        LDA     P+1
        CLC
        ADC     XX1,X
        STA     P+1
        LDA     P+2
        ADC     INWK+1,X
        STA     P+2
        TYA
        RTS

.L1720
        LDA     XX1,X
        SEC
        SBC     P+1
        STA     P+1
        LDA     INWK+1,X
        SBC     P+2
        STA     P+2
        BCC     &1733

        TYA
        EOR     #$80
        RTS

.L1733
        LDA     #$01
        SBC     P+1
        STA     P+1
        LDA     #$00
        SBC     P+2
        STA     P+2
        TYA
        RTS

.L1741
        EQUB    $00

.L1742
        EQUB    $09,$25,$09,$4A,$09,$6F,$09,$94
        EQUB    $09,$B9,$09,$DE,$09,$03,$0A,$28
        EQUB    $0A,$4D,$0A,$72,$0A,$97,$0A,$BC
        EQUB    $0A

.L175B
        EQUB    $80,$40,$20,$10,$08,$04,$02,$01

.L1763
        EQUB    $C0,$60,$30,$18,$0C,$06,$03,$03

.L176B
        EQUB    $88

.L176C
        EQUB    $44,$22,$11

.LOIN
        STY     YSAV
        LDA     #$80
        STA     S
        ASL     A
        STA     SWAP
        LDA     X2
        SBC     XX15
        BCS     &1783

        EOR     #$FF
        ADC     #$01
        SEC
.L1783
        STA     P
        LDA     Y2
        SBC     Y1
        BCS     &178F

        EOR     #$FF
        ADC     #$01
.L178F
        STA     Q
        CMP     P
        BCC     &1798

        JMP     STPY

.L1798
        LDX     XX15
        CPX     X2
        BCC     &17AF

        DEC     SWAP
        LDA     X2
        STA     XX15
        STX     X2
        TAX
        LDA     Y2
        LDY     Y1
        STA     Y1
        STY     Y2
.L17AF
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
        LDA     L175B,X
        STA     R
        LDA     Q
        LDX     #$FE
        STX     Q
.L17D1
        ASL     A
        BCS     &17D8

        CMP     P
        BCC     &17DB

.L17D8
        SBC     P
        SEC
.L17DB
        ROL     Q
        BCS     &17D1

        LDX     P
        INX
        LDA     Y2
        SBC     Y1
        BCS     &1814

        LDA     SWAP
        BNE     &17F3

        DEX
.L17ED
        LDA     R
.L17EF
        EOR     (SC),Y
        STA     (SC),Y
.L17F3
        LSR     R
        BCC     &17FF

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L17FF
        LDA     S
        ADC     Q
        STA     S
        BCC     &180E

        DEY
        BPL     &180E

        DEC     SCH
        LDY     #$07
.L180E
        DEX
        BNE     &17ED

        LDY     YSAV
        RTS

.L1814
        LDA     SWAP
        BEQ     &181F

        DEX
.L1819
        LDA     R
.L181B
        EOR     (SC),Y
        STA     (SC),Y
.L181F
        LSR     R
        BCC     &182B

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L182B
        LDA     S
        ADC     Q
        STA     S
        BCC     &183C

        INY
        CPY     #$08
        BNE     &183C

        INC     SCH
        LDY     #$00
.L183C
        DEX
        BNE     &1819

        LDY     YSAV
        RTS

.STPY
        LDY     Y1
        TYA
        LDX     XX15
        CPY     Y2
        BCS     &185B

        DEC     SWAP
        LDA     X2
        STA     XX15
        STX     X2
        TAX
        LDA     Y2
        STA     Y1
        STY     Y2
        TAY
.L185B
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
        LDA     L175B,X
        STA     R
        LDA     Y1
        AND     #$07
        TAY
        LDA     P
        LDX     #$01
        STX     P
.L187B
        ASL     A
        BCS     &1882

        CMP     Q
        BCC     &1885

.L1882
        SBC     Q
        SEC
.L1885
        ROL     P
        BCC     &187B

        LDX     Q
        INX
        LDA     X2
        SBC     XX15
        BCC     &18BF

        CLC
        LDA     SWAP
        BEQ     &189E

        DEX
.L1898
        LDA     R
.L189A
        EOR     (SC),Y
        STA     (SC),Y
.L189E
        DEY
        BPL     &18A5

        DEC     SCH
        LDY     #$07
.L18A5
        LDA     S
        ADC     P
        STA     S
        BCC     &18B9

        LSR     R
        BCC     &18B9

        ROR     R
        LDA     SC
        ADC     #$08
        STA     SC
.L18B9
        DEX
        BNE     &1898

        LDY     YSAV
        RTS

.L18BF
        LDA     SWAP
        BEQ     &18CA

        DEX
.L18C4
        LDA     R
.L18C6
        EOR     (SC),Y
        STA     (SC),Y
.L18CA
        DEY
        BPL     &18D1

        DEC     SCH
        LDY     #$07
.L18D1
        LDA     S
        ADC     P
        STA     S
        BCC     &18E6

        ASL     R
        BCC     &18E6

        ROL     R
        LDA     SC
        SBC     #$07
        STA     SC
        CLC
.L18E6
        DEX
        BNE     &18C4

        LDY     YSAV
.L18EB
        RTS

.FLKB
        LDA     #$0F
        TAX
        JMP     OSBYTE

.NLIN3
        JSR     TT27

.NLIN4
        LDA     #$13
        BNE     &18FD

.L18F9
        LDA     #$17
        INC     YC
.L18FD
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
        BEQ     &18EB

        BCC     &1924

        LDA     X2
        STA     XX15
        STX     X2
        TAX
.L1924
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
        BEQ     &197E

        LSR     A
        LSR     A
        LSR     A
        STA     R
        LDA     XX15
        AND     #$07
        TAX
        LDA     L19A0,X
        EOR     (SC),Y
        STA     (SC),Y
        TYA
        ADC     #$08
        TAY
        LDX     R
        DEX
        BEQ     &196F

        CLC
.L1962
        LDA     #$FF
        EOR     (SC),Y
        STA     (SC),Y
        TYA
        ADC     #$08
        TAY
        DEX
        BNE     &1962

.L196F
        LDA     X2
        AND     #$07
        TAX
        LDA     L1999,X
        EOR     (SC),Y
        STA     (SC),Y
        LDY     YSAV
        RTS

.L197E
        LDA     XX15
        AND     #$07
        TAX
        LDA     L19A0,X
        STA     T
        LDA     X2
        AND     #$07
        TAX
        LDA     L1999,X
        AND     T
        EOR     (SC),Y
        STA     (SC),Y
        LDY     YSAV
        RTS

.L1999
.TWFL
        EQUB    $80,$C0,$E0,$F0,$F8,$FC,$FE

.L19A0
.TWFR
        EQUB    $FF,$7F,$3F,$1F,$0F,$07,$03,$01

.L19A8
.PX3
        LDA     L175B,X
        EOR     (SC),Y
        STA     (SC),Y
        LDY     T1
        RTS

        JSR     &22B0

        STA     YY+1
        TXA
        STA     SYL,Y
.PIXEL2
        LDA     XX15
        BPL     &19C4

        EOR     #$7F
        CLC
        ADC     #$01
.L19C4
        EOR     #$80
        TAX
        LDA     Y1
        AND     #$7F
        CMP     #$60
        BCS     &1A15

        LDA     Y1
        BPL     &19D7

        EOR     #$7F
        ADC     #$01
.L19D7
        STA     T
        LDA     #$61
        SBC     T
.L19DD
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
        BCS     &19A8

        LDA     L1763,X
        EOR     (SC),Y
        STA     (SC),Y
        LDA     ZZ
        CMP     #$50
        BCS     &1A13

        DEY
        BPL     &1A0C

        LDY     #$01
.L1A0C
        LDA     L1763,X
        EOR     (SC),Y
        STA     (SC),Y
.L1A13
        LDY     T1
.L1A15
        RTS

.BLINE
        TXA
        ADC     K4
        STA     K6+2
        LDA     K4+1
        ADC     T
        STA     K6+3
        LDA     FLAG
        BEQ     &1A37

        INC     FLAG
.L1A27
        LDY     LSP
        LDA     #$FF
        CMP     LSY2-1,Y
        BEQ     &1A98

        STA     LSY2,Y
        INC     LSP
        BNE     &1A98

.L1A37
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

        BCS     &1A27

        LDA     SWAP
        BEQ     &1A70

        LDA     XX15
        LDY     X2
        STA     X2
        STY     XX15
        LDA     Y1
        LDY     Y2
        STA     Y2
        STY     Y1
.L1A70
        LDY     LSP
        LDA     LSY2-1,Y
        CMP     #$FF
        BNE     &1A84

        LDA     XX15
        STA     LSX2,Y
        LDA     Y1
        STA     LSY2,Y
        INY
.L1A84
        LDA     X2
        STA     LSX2,Y
        LDA     Y2
        STA     LSY2,Y
        INY
        STY     LSP
        JSR     LOIN

        LDA     XX13
        BNE     &1A27

.L1A98
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

        LDY     NOSTM
.L1AB3
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
        BNE     &1AB3

        RTS

.L1AD0
.PRXS
        EQUB    $01

.L1AD1
        EQUB    $00,$2C,$01,$A0,$0F,$70,$17,$A0
        EQUB    $0F,$10,$27,$82,$14,$10,$27,$28
        EQUB    $23,$98,$3A,$10,$27,$50,$C3,$60
        EQUB    $EA,$40,$1F

.L1AEC
        LDX     #$09
        CMP     #$19
        BCS     &1B3F

        DEX
        CMP     #$0A
        BCS     &1B3F

        DEX
        CMP     #$02
        BCS     &1B3F

        DEX
        BNE     &1B3F

.L1AFF
        LDA     #$08
        JSR     TT66

        JSR     TT111

        LDA     #$07
        STA     XC
        LDA     #$7E
        JSR     NLIN3

        LDA     #$CD
        JSR     DETOK

        JSR     TT67

        LDA     #$7D
        JSR     &2690

        LDA     #$13
        LDY     FIST
        BEQ     &1B28

        CPY     #$32
        ADC     #$01
.L1B28
        JSR     plf

        LDA     #$10
        JSR     &2690

        LDA     TALLY+1
        BNE     &1AEC

        TAX
        LDA     TALLY
        LSR     A
        LSR     A
.L1B3B
        INX
        LSR     A
        BNE     &1B3B

.L1B3F
        TXA
        CLC
        ADC     #$15
        JSR     plf

        LDA     #$12
        JSR     plf2

        LDA     CRGO
        CMP     #$1A
        BCC     &1B57

        LDA     #$6B
        JSR     plf2

.L1B57
        LDA     BST
        BEQ     &1B61

        LDA     #$6F
        JSR     plf2

.L1B61
        LDA     ECM
        BEQ     &1B6B

        LDA     #$6C
        JSR     plf2

.L1B6B
        LDA     #$71
        STA     XX4
.L1B6F
        TAY
        LDX     FRIN,Y
        BEQ     &1B78

        JSR     plf2

.L1B78
        INC     XX4
        LDA     XX4
        CMP     #$75
        BCC     &1B6F

        LDX     #$00
.L1B82
        STX     CNT
        LDY     LASER,X
        BEQ     &1BAC

        TXA
        CLC
        ADC     #$60
        JSR     &2690

        LDA     #$67
        LDX     CNT
        LDY     LASER,X
        CPY     #$8F
        BNE     &1B9D

        LDA     #$68
.L1B9D
        CPY     #$97
        BNE     &1BA3

        LDA     #$75
.L1BA3
        CPY     #$32
        BNE     &1BA9

        LDA     #$76
.L1BA9
        JSR     plf2

.L1BAC
        LDX     CNT
        INX
        CPX     #$04
        BCC     &1B82

        RTS

.plf2
        JSR     plf

        LDX     #$06
        STX     XC
        RTS

.L1BBC
        EQUB    $48,$76,$E8,$00

.pr2
        LDA     #$03
.L1BC2
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
        BCC     &1BDB

        DEC     T
        DEC     U
.L1BDB
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
.L1BF9
        LDA     K,X
        STA     XX15,X
        DEX
        BPL     &1BF9

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
.L1C1B
        LDA     K,X
        ADC     XX15,X
        STA     K,X
        DEX
        BPL     &1C1B

        LDA     XX15+4
        ADC     S
        STA     S
        LDY     #$00
.TT36
        LDX     #$03
        SEC
.L1C2F
        LDA     K,X
        SBC     L1BBC,X
        STA     XX15,X
        DEX
        BPL     &1C2F

        LDA     S
        SBC     #$17
        STA     XX15+4
        BCC     &1C52

        LDX     #$03
.L1C43
        LDA     XX15,X
        STA     K,X
        DEX
        BPL     &1C43

        LDA     XX15+4
        STA     S
        INY
        JMP     TT36

.L1C52
        TYA
        BNE     &1C61

        LDA     T
        BEQ     &1C61

        DEC     U
        BPL     &1C6B

        LDA     #$20
        BNE     &1C68

.L1C61
        LDY     #$00
        STY     T
        CLC
        ADC     #$30
.L1C68
        JSR     TT26

.L1C6B
        DEC     T
        BPL     &1C71

        INC     T
.L1C71
        DEC     XX17
        BMI     &1C82

        BNE     &1C7F

        PLP
        BCC     &1C7F

        LDA     #$2E
        JSR     TT26

.L1C7F
        JMP     TT35

.L1C82
        RTS

.L1C83
.DTW1
        EQUB    $20

.L1C84
.DTW2
        EQUB    $FF

.DTW3
        EQUB    $00

.L1C86
.DTW4
        EQUB    $00

.DTW5
        EQUB    $00

.L1C88
.DTW6
        EQUB    $00

.DTW8
        EQUB    $FF

.L1C8A
.FEED
        EQUB    $A9,$0C,$2C
.MT16
        EQUB    $A9

.DTW7
        EQUB    $41

.TT26
.DASC
        STX     SC
        LDX     #$FF
        STX     DTW8
        CMP     #$2E
        BEQ     &1CAB

        CMP     #$3A
        BEQ     &1CAB

        CMP     #$0A
        BEQ     &1CAB

        CMP     #$0C
        BEQ     &1CAB

        CMP     #$20
        BEQ     &1CAB

        INX
.L1CAB
        STX     &1C84
        LDX     SC
        BIT     &1C86
        BMI     &1CB8

        JMP     CHPR

.L1CB8
        CMP     #$0C
        BEQ     &1CC9

        LDX     DTW5
        STA     BUF,X
        LDX     SC
        INC     DTW5
        CLC
        RTS

.L1CC9
        TXA
        PHA
        TYA
        PHA
.L1CCD
        LDX     DTW5
        BEQ     &1D4A

        CPX     #$1F
        BCC     &1D47

        LSR     SCH
.L1CD8
        LDA     SCH
        BMI     &1CE0

        LDA     #$40
        STA     SCH
.L1CE0
        LDY     #$1D
.L1CE2
        LDA     BUF+$1E
        CMP     #$20
        BEQ     &1D16

.L1CE9
        DEY
        BMI     &1CD8

        BEQ     &1CD8

        LDA     BUF,Y
        CMP     #$20
        BNE     &1CE9

        ASL     SCH
        BMI     &1CE9

        STY     SC
        LDY     DTW5
.L1CFE
        LDA     BUF,Y
        STA     BUF+1,Y
        DEY
        CPY     SC
        BCS     &1CFE

        INC     DTW5
.L1D0C
        CMP     BUF,Y
        BNE     &1CE2

        DEY
        BPL     &1D0C

        BMI     &1CD8

.L1D16
        LDX     #$1E
        JSR     DAS1

        LDA     #$0C
        JSR     CHPR

        LDA     DTW5
        SBC     #$1E
        STA     DTW5
        TAX
        BEQ     &1D4A

        LDY     #$00
        INX
.L1D2E
        LDA     L0E20,Y
        STA     BUF,Y
        INY
        DEX
        BNE     &1D2E

        BEQ     &1CCD

.DAS1
        LDY     #$00
.L1D3C
        LDA     BUF,Y
        JSR     CHPR

        INY
        DEX
        BNE     &1D3C

        RTS

.L1D47
        JSR     DAS1

.L1D4A
        STX     DTW5
        PLA
        TAY
        PLA
        TAX
        LDA     #$0C
        EQUB    $2C

.BELL
        LDA     #$07
.CHPR
        STA     K3
        STY     YSAV2
        STX     XSAV2
.L1D5E
        LDY     K5
        INY
        BEQ     RR4

        TAY
        BEQ     RR4

        BMI     RR4

        CMP     #$07
        BEQ     &1DDF

        CMP     #$20
        BCS     &1D80

        CMP     #$0A
        BEQ     &1D7C

        LDX     #$01
        STX     XC
        CMP     #$0D
        BEQ     RR4

.L1D7C
        INC     YC
        BNE     RR4

.L1D80
        LDX     #$BF
        ASL     A
        ASL     A
        BCC     &1D88

        LDX     #$C1
.L1D88
        ASL     A
        BCC     &1D8C

        INX
.L1D8C
        STA     P+1
        STX     P+2
        LDA     XC
        LDX     CATF
        BEQ     &1D9F

        CPY     #$20
        BNE     &1D9F

        CMP     #$11
        BEQ     RR4

.L1D9F
        ASL     A
        ASL     A
        ASL     A
        STA     SC
        LDA     YC
        CPY     #$7F
        BNE     &1DB6

        DEC     XC
        ADC     #$5E
        TAX
        LDY     #$F8
        JSR     ZES2

        BEQ     RR4

.L1DB6
        INC     XC
        CMP     #$18
        BCC     &1DC6

        PHA
        JSR     &2539

        PLA
        LDA     K3
        JMP     &1D5E

.L1DC6
        ORA     #$60
.RREN
        STA     SCH
        LDY     #$07
.L1DCC
        LDA     (P+1),Y
        ORA     (SC),Y
        STA     (SC),Y
        DEY
        BPL     &1DCC

.RR4
        LDY     YSAV2
        LDX     XSAV2
        LDA     K3
        CLC
.L1DDE
        RTS

.L1DDF
        JSR     BEEP

        JMP     RR4

.DIALS
        LDA     #$D0
        STA     SC
        LDA     #$78
        STA     SCH
        JSR     &1EA6

        STX     K+1
        STA     K
        LDA     #$0E
        STA     T1
        LDA     DELTA
        JSR     &1EB9

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
        JSR     &22B0

        JSR     DIL2

        LDA     BETA
        LDX     BET1
        BEQ     &1E1D

        SBC     #$01
.L1E1D
        JSR     &22B0

        JSR     DIL2

        LDA     MCNT
        AND     #$03
        BNE     &1DDE

        LDY     #$00
        JSR     &1EA6

        STX     K
        STA     K+1
        LDX     #$03
        STX     T1
.L1E36
        STY     XX12,X
        DEX
        BPL     &1E36

        LDX     #$03
        LDA     ENERGY
        LSR     A
        LSR     A
        STA     Q
.L1E44
        SEC
        SBC     #$10
        BCC     &1E56

        STA     Q
        LDA     #$10
        STA     XX12,X
        LDA     Q
        DEX
        BPL     &1E44

        BMI     &1E5A

.L1E56
        LDA     Q
        STA     XX12,X
.L1E5A
        LDA     XX12,Y
        STY     P
        JSR     &1EBA

        LDY     P
        INY
        CPY     #$04
        BNE     &1E5A

        LDA     #$78
        STA     SCH
        LDA     #$10
        STA     SC
        LDA     FSH
        JSR     &1EB6

        LDA     ASH
        JSR     &1EB6

        LDA     QQ14
        JSR     &1EB8

        JSR     &1EA6

        STX     K+1
        STA     K
        LDX     #$0B
        STX     T1
        LDA     CABTMP
        JSR     &1EB6

        LDA     GNTMP
        JSR     &1EB6

        LDA     #$F0
        STA     T1
        STA     K+1
        LDA     ALTIT
        JMP     &1EB6

.L1EA6
        LDX     #$F0
        LDA     MCNT
        AND     #$08
        AND     FLH
        BEQ     &1EB3

        TXA
        EQUB    $2C

.L1EB3
        LDA     #$0F
        RTS

.L1EB6
        LSR     A
        LSR     A
.L1EB8
        LSR     A
.L1EB9
        LSR     A
.L1EBA
        STA     Q
        LDX     #$FF
        STX     R
        CMP     T1
        BCS     &1EC8

        LDA     K+1
        BNE     &1ECA

.L1EC8
        LDA     K
.L1ECA
        STA     COL
        LDY     #$02
        LDX     #$03
.L1ED0
        LDA     Q
        CMP     #$04
        BCC     &1EF0

        SBC     #$04
        STA     Q
        LDA     R
.L1EDC
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
        BMI     &1F0A

        BPL     &1ED0

.L1EF0
        EOR     #$03
        STA     Q
        LDA     R
.L1EF6
        ASL     A
        AND     #$EF
        DEC     Q
        BPL     &1EF6

        PHA
        LDA     #$00
        STA     R
        LDA     #$63
        STA     Q
        PLA
        JMP     &1EDC

.L1F0A
        INC     SCH
        RTS

.DIL2
        LDY     #$01
        STA     Q
.L1F11
        SEC
        LDA     Q
        SBC     #$04
        BCS     &1F26

        LDA     #$FF
        LDX     Q
        STA     Q
        LDA     L176B,X
        AND     #$F0
        JMP     DLL12

.L1F26
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
        BCC     &1F11

        INC     SCH
        RTS

.HME2
        LDA     #$0E
        JSR     DETOK

        JSR     TT103

        JSR     TT81

        LDA     #$00
        STA     XX20
.L1F50
        JSR     MT14

        JSR     cpl

        LDX     DTW5
        LDA     INWK+5,X
        CMP     #$0D
        BNE     &1F6C

.L1F5F
        DEX
        LDA     INWK+5,X
        ORA     #$20
        CMP     BUF,X
        BEQ     &1F5F

        TXA
        BMI     &1F83

.L1F6C
        JSR     TT20

        INC     XX20
        BNE     &1F50

        JSR     TT111

        JSR     TT103

        LDA     #$28
        JSR     &3C6C

        LDA     #$D7
        JMP     DETOK

.L1F83
        LDA     QQ15+3
        STA     QQ9
        LDA     QQ15+1
        STA     QQ10
        JSR     TT111

        JSR     TT103

        JSR     MT15

        JMP     &3845

.L1F99
        EQUB    $02,$54,$3B,$03,$82,$B0,$00,$00
        EQUB    $00,$01,$50,$11,$01,$D1,$28,$01
        EQUB    $40,$06,$03,$60,$90,$04,$10,$D1
        EQUB    $00,$00,$00,$06,$51,$F8,$07,$60
        EQUB    $75,$00,$00,$00

.HALL
.L1FBD
        JSR     UNWISE

        LDA     #$00
        JSR     TT66

        JSR     DORND

        BPL     &1FF3

        AND     #$03
        STA     T
        ASL     A
        ASL     A
        ASL     A
        ADC     T
        TAX
        LDY     #$03
        STY     CNT2
.L1FD8
        LDY     #$02
.L1FDA
        LDA     L1F99,X
        STA     XX15,Y
        INX
        DEY
        BPL     &1FDA

        TXA
        PHA
        JSR     &2079

        PLA
        TAX
        DEC     CNT2
        BNE     &1FD8

        LDY     #$80
        BNE     &2007

.L1FF3
        LSR     A
        STA     Y1
        JSR     DORND

        STA     XX15
        JSR     DORND

        AND     #$07
        STA     X2
        JSR     &2079

        LDY     #$00
.L2007
        STY     YSAV
        JSR     UNWISE

        LDX     #$02
.L200E
        STX     XSAV
        LDA     #$82
        LDX     XSAV
        STX     Q
        JSR     &2316

        LDA     P
        CLC
        ADC     #$60
        LSR     A
        LSR     A
        LSR     A
        ORA     #$60
        STA     SCH
        LDA     P
        AND     #$07
        STA     SC
        LDY     #$00
        JSR     &20E8

        LDA     #$04
        LDY     #$F8
        JSR     &2101

        LDY     YSAV
        BEQ     &2045

        JSR     &20E8

        LDY     #$80
        LDA     #$40
        JSR     &2101

.L2045
        LDX     XSAV
        INX
        CPX     #$0D
        BCC     &200E

        LDA     #$10
.L204E
        LDX     #$60
        STX     SCH
        STA     XSAV
        AND     #$F8
        STA     SC
        LDX     #$80
        LDY     #$01
.L205C
        TXA
        AND     (SC),Y
        BNE     &2071

        TXA
        ORA     (SC),Y
        STA     (SC),Y
        INY
        CPY     #$08
        BNE     &205C

        INC     SCH
        LDY     #$00
        BEQ     &205C

.L2071
        LDA     XSAV
        CLC
        ADC     #$10
        BNE     &204E

        RTS

.L2079
        JSR     ZINF

        LDA     XX15
        STA     INWK+6
        LSR     A
        ROR     INWK+2
        LDA     Y1
        STA     XX1
        LSR     A
        LDA     #$01
        ADC     #$00
        STA     INWK+7
        LDA     #$80
        STA     INWK+5
        STA     RAT2
        LDA     #$0B
        STA     INWK+34
        JSR     DORND

        STA     XSAV
.L209D
        LDX     #$15
        LDY     #$09
        JSR     MVS5

        LDX     #$17
        LDY     #$0B
        JSR     MVS5

        LDX     #$19
        LDY     #$0D
        JSR     MVS5

        DEC     XSAV
        BNE     &209D

        LDY     X2
        BEQ     &2138

        LDX     #$04
.L20BC
        INX
        INX
        LDA     L55FE,X
        STA     XX0
        LDA     L55FF,X
        STA     XX0+1
        BEQ     &20BC

        DEY
        BNE     &20BC

        LDY     #$01
        LDA     (XX0),Y
        STA     Q
        INY
        LDA     (XX0),Y
        STA     R
        JSR     LL5

        LDA     #$64
        SBC     Q
        LSR     A
        STA     INWK+3
        JSR     TIDY

        JMP     LL9

.L20E8
        LDA     #$20
.L20EA
        TAX
        AND     (SC),Y
        BNE     &2100

        TXA
        ORA     (SC),Y
        STA     (SC),Y
        TXA
        LSR     A
        BCC     &20EA

        TYA
        ADC     #$07
        TAY
        LDA     #$80
        BCC     &20EA

.L2100
        RTS

.L2101
        TAX
        AND     (SC),Y
        BNE     &2100

        TXA
        ORA     (SC),Y
        STA     (SC),Y
        TXA
        ASL     A
        BCC     &2101

        TYA
        SBC     #$08
        TAY
        LDA     #$01
        BCS     &2101

        RTS

.UNWISE
        LDA     &17EF
        EOR     #$40
        STA     &17EF
        LDA     &181B
        EOR     #$40
        STA     &181B
        LDA     &189A
        EOR     #$40
        STA     &189A
        LDA     &18C6
        EOR     #$40
        STA     &18C6
.L2138
        RTS

        LDA     #$38
        JSR     &3C6C

        LDA     #$01
        STA     HFX
        LDA     #$04
        JSR     HFS2

        DEC     HFX
        RTS

        LDA     #$30
        JSR     &3C6C

        LDA     #$08
.HFS2
        STA     STP
        JSR     &2539

        JSR     &215B

.HFS1
        LDX     #$80
        STX     K3
        LDX     #$60
        STX     K4
        LDX     #$00
        STX     XX4
        STX     K3+1
        STX     K4+1
.L216B
        JSR     HFL1

        INC     XX4
        LDX     XX4
        CPX     #$08
        BNE     &216B

        RTS

.HFL1
        LDA     XX4
        AND     #$07
        CLC
        ADC     #$08
        STA     K
.L2180
        LDA     #$01
        STA     LSP
        JSR     CIRCLE2

        ASL     K
        BCS     &2191

        LDA     K
        CMP     #$A0
        BCC     &2180

.L2191
        RTS

        EQUB    $8C,$E7,$8D,$ED,$8A,$E6,$C1,$C8
        EQUB    $C8,$8B,$E0,$8A,$E6,$D6,$C5,$C6
        EQUB    $C1,$CA,$95,$9D,$9C,$97

.MU5
        STA     K
        STA     K+1
        STA     K+2
        STA     K+3
        CLC
        RTS

        LDX     XX
        STX     R
        LDX     XX+1
        STX     S
        LDX     ALP1
        STX     P
.SQUA
        AND     #$7F
.SQUA2
        STA     P
        TAX
        BNE     &21D7

.L21C5
        CLC
        STX     P
        TXA
        RTS

        LDA     SY,Y
        STA     Y1
        AND     #$7F
        STA     P
.L21D3
        LDX     Q
        BEQ     &21C5

.L21D7
        DEX
        STX     T
        LDA     #$00
        LDX     #$08
        LSR     P
.L21E0
        BCC     &21E4

        ADC     T
.L21E4
        ROR     A
        ROR     P
        DEX
        BNE     &21E0

        RTS

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
.L2202
        BCS     &220C

        ADC     Q
        ROR     A
        LSR     P
        BNE     &2202

        RTS

.L220C
        LSR     A
        LSR     P
        BNE     &2202

        RTS

        LDX     Q
        BEQ     &21C5

        DEX
        STX     T
        LDA     #$00
        LDX     #$08
        LSR     P
.L221F
        BCC     &2223

        ADC     T
.L2223
        ROR     A
        ROR     P
        DEX
        BNE     &221F

        RTS

        STX     Q
        EOR     #$FF
        LSR     A
        STA     P+1
        LDA     #$00
        LDX     #$10
        ROR     P
.L2237
        BCS     &2244

        ADC     Q
        ROR     A
        ROR     P+1
        ROR     P
        DEX
        BNE     &2237

        RTS

.L2244
        LSR     A
        ROR     P+1
        ROR     P
        DEX
        BNE     &2237

        RTS

        LDX     ALP1
        STX     P
        LDX     XX+1
        STX     S
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
        BEQ     &2284

        TAX
        DEX
        STX     T1
        LDA     #$00
        LDX     #$07
.L2274
        BCC     &2278

        ADC     T1
.L2278
        ROR     A
        ROR     P
        DEX
        BNE     &2274

        LSR     A
        ROR     P
        ORA     T
        RTS

.L2284
        STA     P
        RTS

.MULT12
        JSR     MULT1

        STA     S
        LDA     P
        STA     R
        RTS

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

.L22B0
        STA     T1
        AND     #$80
        STA     T
        EOR     S
        BMI     &22C7

        LDA     R
        CLC
        ADC     P
        TAX
        LDA     S
        ADC     T1
        ORA     T
        RTS

.L22C7
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
        BCS     &22E9

        STA     U
        TXA
        EOR     #$FF
        ADC     #$01
        TAX
        LDA     #$00
        SBC     U
        ORA     #$80
.L22E9
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
.L22FF
        ASL     A
        CMP     #$60
        BCC     &2306

        SBC     #$60
.L2306
        ROL     T1
        BCS     &22FF

        LDA     T1
        ORA     T
        RTS

        LDA     SZ,Y
        STA     Q
        LDA     DELTA
.L2316
        LDX     #$08
        ASL     A
        STA     P
        LDA     #$00
.L231D
        ROL     A
        BCS     &2324

        CMP     Q
        BCC     &2327

.L2324
        SBC     Q
        SEC
.L2327
        ROL     P
        DEX
        BNE     &231D

        JMP     &3F79

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
.L2351
        CMP     #$40
        BCS     &235D

        ASL     P
        ROL     P+1
        ROL     A
        INY
        BNE     &2351

.L235D
        STA     P+2
        LDA     S
        AND     #$7F
        BMI     &236D

.L2365
        DEY
        ASL     Q
        ROL     R
        ROL     A
        BPL     &2365

.L236D
        STA     Q
        LDA     #$FE
        STA     R
        LDA     P+2
        JSR     &3F7D

        LDA     #$00
        STA     K+1
        STA     K+2
        STA     K+3
        TYA
        BPL     &23A1

        LDA     R
.L2385
        ASL     A
        ROL     K+1
        ROL     K+2
        ROL     K+3
        INY
        BNE     &2385

        STA     K
        LDA     K+3
        ORA     T
        STA     K+3
        RTS

.L2398
        LDA     R
        STA     K
        LDA     T
        STA     K+3
        RTS

.L23A1
        BEQ     &2398

        LDA     R
.L23A5
        LSR     A
        DEY
        BNE     &23A5

        STA     K
        LDA     T
        STA     K+3
        RTS

        LDA     DAMP
        BNE     &23C1

        TXA
        BPL     &23BB

        DEX
        BMI     &23C1

.L23BB
        INX
        BNE     &23C1

        DEX
        BEQ     &23BB

.L23C1
        RTS

        STA     T
        TXA
        CLC
        ADC     T
        TAX
        BCC     &23CD

        LDX     #$FF
.L23CD
        BPL     &23DF

.L23CF
        LDA     T
        RTS

        STA     T
        TXA
        SEC
        SBC     T
        TAX
        BCS     &23DD

        LDX     #$01
.L23DD
        BPL     &23CF

.L23DF
        LDA     DJD
        BNE     &23CF

        LDX     #$80
        BMI     &23CF

.PDESC
        LDA     QQ8
        ORA     QQ8+1
        BNE     &2424

        LDY     #$19
.L23F2
        LDA     L5338,Y
        CMP     ZZ
        BNE     &2421

        LDA     L5351,Y
        AND     #$7F
        CMP     GCNT
        BNE     &2421

        LDA     L5351,Y
        BMI     &2414

        LDA     TP
        LSR     A
        BCC     &2424

        JSR     MT14

        LDA     #$01
.L2413
        BIT     &B0A9
L2414 = L2413+1
        JSR     DETOK2

        TYA
        JSR     DETOK3

        LDA     #$B1
        BNE     &242F

.L2421
        DEY
        BNE     &23F2

.L2424
        LDX     #$03
.L2426
        LDA     QQ15+2,X
        STA     ZP,X
        DEX
        BPL     &2426

        LDA     #$05
.L242F
        JMP     DETOK

.BRIEF2
.L2432
        LDA     TP
        ORA     #$04
        STA     TP
        LDA     #$0B
.L243C
        JSR     DETOK

        JMP     &38B0

.BRIEF3
.L2442
        LDA     TP
        AND     #$F0
        ORA     #$0A
        STA     TP
        LDA     #$DE
        BNE     &243C

.L2450
.DEBRIEF2
        LDA     TP
        ORA     #$04
        STA     TP
        LDA     #$02
        STA     ENGY
        INC     TALLY+1
        LDA     #$DF
        BNE     &243C

.DEBRIEF
.L2464
        LSR     TP
        ASL     TP
        INC     TALLY+1
        LDX     #$50
        LDY     #$C3
        JSR     &2ECE

        LDA     #$0F
.L2476
        BNE     &243C

.BRIEF
        LSR     TP
        SEC
        ROL     TP
        JSR     &24CD

        JSR     ZINF

        LDA     #$1F
        STA     TYPE
        JSR     &32FB

        LDA     #$01
        STA     XC
        STA     INWK+7
        JSR     TT66

        LDA     #$40
        STA     MCNT
.L2499
        LDX     #$7F
        STX     INWK+29
        STX     INWK+30
        JSR     LL9

        JSR     MVEIT

        DEC     MCNT
        BNE     &2499

.BRL2
        LSR     XX1
        INC     INWK+6
        BEQ     &24C7

        INC     INWK+6
        BEQ     &24C7

        LDX     INWK+3
        INX
        CPX     #$70
        BCC     &24BC

        LDX     #$70
.L24BC
        STX     INWK+3
        JSR     LL9

        JSR     MVEIT

        JMP     BRL2

.L24C7
        INC     INWK+7
        LDA     #$0A
        BNE     &2476

.L24CD
.BRIS
        LDA     #$D8
        JSR     DETOK

        LDY     #$64
        JMP     DELAY

.PAUSE
        JSR     &24F7

        BNE     PAUSE

.L24DC
        JSR     &24F7

        BEQ     &24DC

        LDA     #$00
        STA     INWK+31
        LDA     #$01
        JSR     TT66

        JSR     LL9

.MT23
        LDA     #$0A
        EQUB    $2C

.MT29
        LDA     #$06
        STA     YC
        JMP     MT13

.L24F7
        LDA     #$70
        STA     INWK+3
        LDA     #$00
        STA     XX1
        STA     INWK+6
        LDA     #$02
        STA     INWK+7
        JSR     LL9

        JSR     MVEIT

        JMP     RDKEY

.PAUSE2
        JSR     RDKEY

        BNE     PAUSE2

        JSR     RDKEY

        BEQ     PAUSE2

        RTS

        LDY     VIEW
        LDA     LASER,Y
        BEQ     &254E

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
.L2539
        JSR     MT2

        LDA     #$80
        STA     K5
        STA     &1C84
        ASL     A
        STA     LASCT
        STA     DLY
        STA     de
.L254D
        LDX     #$60
L254E = L254D+1
.L254F
        JSR     ZES1

        INX
        CPX     #$78
        BNE     &254F

        LDY     #$01
        STY     YC
        LDA     QQ11
        BNE     &2573

        LDY     #$0B
        STY     XC
        LDA     VIEW
        ORA     #$60
        JSR     TT27

        JSR     &2E05

        LDA     #$AF
        JSR     TT27

.L2573
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
        JSR     &258D

.L258D
        LDA     #$00
        STA     Y1
        LDA     #$BF
        STA     Y2
        DEC     XX15
        DEC     X2
        JMP     LOIN

.DELAY
        JSR     &260B

        DEY
        BNE     DELAY

        RTS

.CLYNS
        LDA     #$FF
        STA     &1C84
        LDA     #$14
        STA     YC
        JSR     TT67

        LDA     #$75
        STA     SCH
        LDA     #$07
        STA     SC
        LDA     #$00
        JSR     LYN

        INC     SCH
        JSR     LYN

        INC     SCH
        INY
        STY     XC
.LYN
        LDY     #$E9
.L25C8
        STA     (SC),Y
        DEY
        BNE     &25C8

        RTS

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
        LDA     L176B,X
        AND     COL
        EOR     (SC),Y
        STA     (SC),Y
        LDA     L176C,X
        BPL     &2604

        LDA     SC
        ADC     #$08
        STA     SC
        LDA     L176C,X
.L2604
        AND     COL
        EOR     (SC),Y
        STA     (SC),Y
        RTS

.L260B
        LDA     #$00
        STA     DL
.L260F
        LDA     DL
        BEQ     &260F

        RTS

.L2614
        PHA
        LDX     #$0C
        CPX     QQ29
        BCC     &2627

.L261C
        ADC     QQ20,X
        DEX
        BPL     &261C

        CMP     CRGO
        PLA
        RTS

.L2627
        LDY     QQ29
        ADC     QQ20,Y
        CMP     #$C8
        PLA
        RTS

.TT20
        JSR     &2634

.L2634
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
        BNE     &2669

        INC     YC
        RTS

.L2669
        LDA     #$BF
        JSR     TT68

        LDX     QQ8
        LDY     QQ8+1
        SEC
        JSR     pr5

        LDA     #$C3
.L267A
        JSR     TT27

.TTX69
        INC     YC
.L267F
        LDA     #$80
        STA     K5
.TT67
        LDA     #$0C
        JMP     TT27

.L2688
        LDA     #$AD
        JSR     TT27

        JMP     TT72

.L2690
        JSR     TT27

        JMP     &2E05

.TT25
        LDA     #$01
        JSR     TT66

        LDA     #$09
        STA     XC
        LDA     #$A3
        JSR     NLIN3

        JSR     TTX69

        JSR     TT146

        LDA     #$C2
        JSR     TT68

        LDA     QQ3
        CLC
        ADC     #$01
        LSR     A
        CMP     #$02
        BEQ     &2688

        LDA     QQ3
        BCC     &26C2

        SBC     #$05
        CLC
.L26C2
        ADC     #$AA
        JSR     TT27

.TT72
        LDA     QQ3
        LSR     A
        LSR     A
        CLC
        ADC     #$A8
        JSR     &267A

        LDA     #$A2
        JSR     TT68

        LDA     QQ4
        CLC
        ADC     #$B1
        JSR     &267A

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
        JSR     &267A

        LDA     #$28
        JSR     TT27

        LDA     QQ15+4
        BMI     &2712

        LDA     #$BC
        JSR     TT27

        JMP     TT76

.L2712
        LDA     QQ15+5
        LSR     A
        LSR     A
        PHA
        AND     #$07
        CMP     #$03
        BCS     &2722

        ADC     #$E3
        JSR     &2690

.L2722
        PLA
        LSR     A
        LSR     A
        LSR     A
        CMP     #$06
        BCS     &272F

        ADC     #$E6
        JSR     &2690

.L272F
        LDA     QQ15+3
        EOR     QQ15+1
        AND     #$07
        STA     QQ19
        CMP     #$06
        BCS     &2740

        ADC     #$EC
        JSR     &2690

.L2740
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
        JSR     &267A

        LDA     #$C1
        JSR     TT68

        LDX     QQ7
        LDY     QQ7+1
        JSR     pr6

        JSR     &2E05

        LDA     #$00
        STA     K5
        LDA     #$4D
        JSR     TT27

        LDA     #$E2
        JSR     &267A

        LDA     #$FA
        JSR     TT68

        LDA     QQ15+5
        LDX     QQ15+3
        AND     #$0F
        CLC
        ADC     #$0B
        TAY
        JSR     pr5

        JSR     &2E05

        LDA     #$6B
        JSR     TT26

        LDA     #$6D
        JSR     TT26

        JSR     TTX69

        JMP     PDESC

        LDX     ZZ
        RTS

.L279F
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
        BNE     &27BB

        LDA     QQ3
        ORA     #$02
        STA     QQ3
.L27BB
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
        JSR     &21D3

        LDA     QQ6
        STA     Q
        JSR     &21D3

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

        JSR     &18F9

        LDA     #$98
        JSR     &18FD

        JSR     TT14

        LDX     #$00
.L2830
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
        JSR     &19DD

        JSR     TT20

        LDX     XSAV
        INX
        BNE     &2830

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
        BPL     &2865

        LDA     #$00
.L2865
        STA     K6+2
        LDA     QQ19
        SEC
        SBC     QQ19+2
        BCS     &2870

        LDA     #$00
.L2870
        STA     XX15
        LDA     QQ19
        CLC
        ADC     QQ19+2
        BCC     &287B

        LDA     #$FF
.L287B
        STA     X2
        LDA     QQ19+1
        CLC
        ADC     K6+2
        STA     Y1
        JSR     HLOIN

        LDA     QQ19+1
        SEC
        SBC     QQ19+2
        BCS     &2890

        LDA     #$00
.L2890
        CLC
        ADC     K6+2
        STA     Y1
        LDA     QQ19+1
        CLC
        ADC     QQ19+2
        ADC     K6+2
        CMP     #$98
        BCC     &28A6

        LDX     QQ11
        BMI     &28A6

        LDA     #$97
.L28A6
        STA     Y2
        LDA     QQ19
        STA     XX15
        STA     X2
        JMP     LOIN

.L28B1
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
        BMI     &28B1

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
        JMP     CIRCLE2

.TT219
        LDA     #$02
        JSR     TT66

        JSR     TT163

        LDA     #$80
        STA     K5
        JSR     FLKB

        LDA     #$00
        STA     QQ29
.TT220
        JSR     TT151

        LDA     QQ25
        BNE     &292F

        JMP     TT222

.L2923
        LDY     #$B0
.L2925
        JSR     &2E05

        TYA
        JSR     prq

        JSR     dn2

.L292F
        JSR     CLYNS

        LDA     #$CC
        JSR     TT27

        LDA     QQ29
        CLC
        ADC     #$D0
        JSR     TT27

        LDA     #$2F
        JSR     TT27

        JSR     TT152

        LDA     #$3F
        JSR     TT27

        JSR     TT67

        LDX     #$00
        STX     R
        LDX     #$0C
        STX     T1
        JSR     gnum

        BCS     &2923

        STA     P
        JSR     &2614

        LDY     #$CE
        BCS     &2925

        LDA     QQ24
        STA     Q
        JSR     GCASH

        JSR     &2EA7

        LDY     #$C5
        BCC     &2925

        LDY     QQ29
        LDA     R
        PHA
        CLC
        ADC     QQ20,Y
        STA     QQ20,Y
        LDA     AVL,Y
        SEC
        SBC     R
        STA     AVL,Y
        PLA
        BEQ     TT222

        JSR     dn

.TT222
        LDA     QQ29
        CLC
        ADC     #$05
        STA     YC
        LDA     #$00
        STA     XC
        INC     QQ29
        LDA     QQ29
        CMP     #$11
        BCS     BAY2

        JMP     TT220

.BAY2
        LDA     #$77
        JMP     FRCE

.gnum
        LDX     #$00
        STX     R
        LDX     #$0C
        STX     T1
.L29B7
        JSR     TT217

        LDX     R
        BNE     &29C6

        CMP     #$79
        BEQ     &29F7

        CMP     #$6E
        BEQ     &2A00

.L29C6
        STA     Q
        SEC
        SBC     #$30
        BCC     &29F4

        CMP     #$0A
        BCS     BAY2

        STA     S
        LDA     R
        CMP     #$1A
        BCS     &29F4

        ASL     A
        STA     T
        ASL     A
        ASL     A
        ADC     T
        ADC     S
        STA     R
        CMP     QQ25
        BEQ     &29EB

        BCS     &29F4

.L29EB
        LDA     Q
        JSR     TT26

        DEC     T1
        BNE     &29B7

.L29F4
        LDA     R
        RTS

.L29F7
        JSR     TT26

        LDA     QQ25
        STA     R
        RTS

.L2A00
        JSR     TT26

        LDA     #$00
        STA     R
        RTS

.L2A08
        JSR     TT67

        LDA     #$B0
        JSR     prq

        JSR     dn2

        LDY     QQ29
        JMP     NWDAVxx

.TT208
        LDA     #$04
        JSR     TT66

        LDA     #$0A
        STA     XC
        JSR     FLKB

        LDA     #$CD
        JSR     TT27

        LDA     #$CE
        JSR     NLIN3

        JSR     TT67

.L2A32
        LDY     #$00
.L2A34
        STY     QQ29
.NWDAVxx
        LDX     QQ20,Y
        BEQ     &2AA3

        TYA
        ASL     A
        ASL     A
        TAY
        LDA     L3DA7,Y
        STA     QQ19+1
        TXA
        PHA
        JSR     &267F

        CLC
        LDA     QQ29
        ADC     #$D0
        JSR     TT27

        LDA     #$0E
        STA     XC
        PLA
        TAX
        STA     QQ25
        CLC
        JSR     pr2

        JSR     TT152

        LDA     QQ11
        CMP     #$04
        BNE     &2AA3

        LDA     #$CD
        JSR     TT27

        LDA     #$CE
        JSR     DETOK

        JSR     gnum

        BEQ     &2AA3

        BCS     &2A08

        LDA     QQ29
        LDX     #$FF
        STX     K5
        JSR     TT151

        LDY     QQ29
        LDA     QQ20,Y
        SEC
        SBC     R
        STA     QQ20,Y
        LDA     R
        STA     P
        LDA     QQ24
        STA     Q
        JSR     GCASH

        JSR     &2ECE

        LDA     #$00
        STA     K5
.L2AA3
        LDY     QQ29
        INY
        CPY     #$11
        BCC     &2A34

        LDA     QQ11
        CMP     #$04
        BNE     &2AB7

        JSR     dn2

        JMP     BAY2

.L2AB7
        RTS

.TT213
        LDA     #$08
        JSR     TT66

        LDA     #$0B
        STA     XC
        LDA     #$A4
        JSR     &267A

        JSR     NLIN4

        JSR     &3178

        LDA     CRGO
        CMP     #$1A
        BCC     &2AD8

        LDA     #$6B
        JSR     TT27

.L2AD8
        JMP     &2A32

        JSR     TT27

        LDA     #$CE
        JSR     DETOK

        JSR     TT217

        ORA     #$20
        CMP     #$79
        BEQ     &2AF1

        LDA     #$6E
        JMP     TT26

.L2AF1
        JSR     TT26

        SEC
        RTS

.TT16
        TXA
        PHA
        DEY
        TYA
        EOR     #$FF
        PHA
        JSR     &260B

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
        BMI     &2B4A

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
        BMI     &2B45

        BCC     &2B47

        RTS

.L2B45
        BCC     &2B49

.L2B47
        STA     K6+1
.L2B49
        RTS

.L2B4A
        LDA     QQ9
        SEC
        SBC     QQ0
        CMP     #$26
        BCC     &2B59

        CMP     #$E6
        BCC     &2B49

.L2B59
        ASL     A
        ASL     A
        CLC
        ADC     #$68
        STA     QQ19
        LDA     QQ10
        SEC
        SBC     QQ1
        CMP     #$26
        BCC     &2B6F

        CMP     #$DC
        BCC     &2B49

.L2B6F
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
.L2B99
        STA     XX1,X
        DEX
        BPL     &2B99

.TT182
        LDA     QQ15+3
        SEC
        SBC     QQ0
        BCS     &2BAA

        EOR     #$FF
        ADC     #$01
.L2BAA
        CMP     #$14
        BCS     &2C1E

        LDA     QQ15+1
        SEC
        SBC     QQ1
        BCS     &2BBA

        EOR     #$FF
        ADC     #$01
.L2BBA
        CMP     #$26
        BCS     &2C1E

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
        BEQ     &2BEF

        INY
        LDX     XX1,Y
        BEQ     &2BEF

        DEY
        DEY
        LDX     XX1,Y
        BNE     &2C01

.L2BEF
        STY     YC
        CPY     #$03
        BCC     &2C1E

        LDA     #$FF
        STA     XX1,Y
        LDA     #$80
        STA     K5
        JSR     cpl

.L2C01
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
        JSR     &32B0

        JSR     &33CB

        JSR     &32B0

.L2C1E
        JSR     TT20

        INC     XX20
        BEQ     &2C32

        JMP     TT182

.TT81
        LDX     #$05
.L2C2A
        LDA     QQ21,X
        STA     QQ15,X
        DEX
        BPL     &2C2A

.L2C32
        RTS

.TT111
        JSR     TT81

        LDY     #$7F
        STY     T
        LDA     #$00
        STA     U
.L2C3E
        LDA     QQ15+3
        SEC
        SBC     QQ9
        BCS     &2C4A

        EOR     #$FF
        ADC     #$01
.L2C4A
        LSR     A
        STA     S
        LDA     QQ15+1
        SEC
        SBC     QQ10
        BCS     &2C59

        EOR     #$FF
        ADC     #$01
.L2C59
        LSR     A
        CLC
        ADC     S
        CMP     T
        BCS     &2C70

        STA     T
        LDX     #$05
.L2C65
        LDA     QQ15,X
        STA     QQ19,X
        DEX
        BPL     &2C65

        LDA     U
        STA     ZZ
.L2C70
        JSR     TT20

        INC     U
        BNE     &2C3E

        LDX     #$05
.L2C79
        LDA     QQ19,X
        STA     QQ15,X
        DEX
        BPL     &2C79

        LDA     QQ15+1
        STA     QQ10
        LDA     QQ15+3
        STA     QQ9
        SEC
        SBC     QQ0
        BCS     &2C94

        EOR     #$FF
        ADC     #$01
.L2C94
        JSR     SQUA2

        STA     K+1
        LDA     P
        STA     K
        LDA     QQ10
        SEC
        SBC     QQ1
        BCS     &2CAA

        EOR     #$FF
        ADC     #$01
.L2CAA
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
        JMP     &279F

        LDA     QQ22+1
        ORA     QQ12
        BNE     &2D4E

        JSR     CTRL

        BMI     &2D27

        LDA     QQ11
        BEQ     &2D21

        AND     #$C0
        BEQ     &2D4E

        JSR     hm

.TTX111
        LDA     QQ8
        ORA     QQ8+1
        BEQ     &2D4E

        LDA     #$07
        STA     XC
        LDA     #$16
        STA     YC
        LDA     #$00
        STA     K5
        LDA     #$BD
        JSR     TT27

        LDA     QQ8+1
        BNE     &2D82

        LDA     QQ14
        CMP     QQ8
        BCC     &2D82

        LDA     #$2D
        JSR     TT27

        JSR     cpl

.wW
        LDA     #$0F
        STA     QQ22+1
        STA     QQ22
        TAX
        JMP     ee3

.L2D21
        JSR     TT111

        JMP     TTX111

.L2D27
        LDX     GHYP
        BEQ     &2D74

        INX
        STX     GHYP
        STX     FIST
        JSR     wW

        LDX     #$05
        INC     GCNT
        LDA     GCNT
        AND     #$07
        STA     GCNT
.L2D43
        LDA     QQ21,X
        ASL     A
        ROL     QQ21,X
        DEX
        BPL     &2D43

.L2D4D
        LDA     #$60
L2D4E = L2D4D+1
        STA     QQ9
        STA     QQ10
        JSR     Flight

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
.L2D74
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

.L2D82
        LDA     #$CA
.prq
        JSR     TT27

        LDA     #$3F
        JMP     TT27

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
        LDA     L3DA7,X
        STA     QQ19+1
        LDA     QQ26
        AND     L3DA9,X
        CLC
        ADC     L3DA6,X
        STA     QQ24
        JSR     TT152

        JSR     var

        LDA     QQ19+1
        BMI     &2DC7

        LDA     QQ24
        ADC     K6
        JMP     TT156

.L2DC7
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
        BEQ     &2DEE

        JSR     &1BC2

        JMP     TT152

.L2DEE
        LDA     XC
        ADC     #$04
        STA     XC
        LDA     #$2D
        BNE     &2E07

.TT152
        LDA     QQ19+1
        AND     #$60
        BEQ     &2E0A

        CMP     #$20
        BEQ     &2E11

        JSR     TT16a

.L2E05
        LDA     #$20
.L2E07
        JMP     TT27

.L2E0A
        LDA     #$74
        JSR     TT26

        BCC     &2E05

.L2E11
        LDA     #$6B
        JSR     TT26

.TT16a
        LDA     #$67
        JMP     TT26

.TT163
        LDA     #$11
        STA     XC
        LDA     #$FF
        BNE     &2E07

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
.L2E3D
        LDX     #$80
        STX     K5
        JSR     TT151

        INC     YC
        INC     QQ29
        LDA     QQ29
        CMP     #$11
        BCC     &2E3D

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
        BMI     &2E68

        ADC     QQ19+2
        JMP     TT153

.L2E68
        STA     K6
        RTS

.L2E6B
        JSR     TT111

        JSR     jmp

        LDX     #$05
.L2E73
        LDA     QQ15,X
        STA     QQ2,X
        DEX
        BPL     &2E73

        INX
        STX     EV
        LDA     QQ3
        STA     QQ28
        LDA     QQ5
        STA     tek
        LDA     QQ4
        STA     gov
        RTS

.Flight
        LDX     #$3F
.L2E94
        LDA     QQ16,X
        STA     QQ16_FLIGHT,X
        DEX
        BPL     &2E94

        JSR     &0D7A

        LDX     #$FC
        LDY     #$2E
        JMP     SCLI

.L2EA7
        STX     T1
        LDA     CASH+3
        SEC
        SBC     T1
        STA     CASH+3
        STY     T1
        LDA     CASH+2
        SBC     T1
        STA     CASH+2
        LDA     CASH+1
        SBC     #$00
        STA     CASH+1
        LDA     CASH
        SBC     #$00
        STA     CASH
        BCS     &2EEE

.L2ECE
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
.L2EEE
        RTS

.GCASH
        JSR     &21D3

.GC2
        ASL     P
        ROL     A
        ASL     P
        ROL     A
        TAY
        LDX     P
        RTS

.L2EFC
        EQUS    "R.D.CODE"

        EQUB    $0D

.bay
        JMP     &38B0

.EQSHP
        LDA     #$20
        JSR     TT66

        JSR     FLKB

        LDA     #$0C
        STA     XC
        LDA     #$CF
        JSR     &2690

        LDA     #$B9
        JSR     NLIN3

        LDA     #$80
        STA     K5
        INC     YC
        LDA     tek
        CLC
        ADC     #$03
        CMP     #$0C
        BCC     &2F30

        LDA     #$0E
.L2F30
        STA     Q
        STA     QQ25
        INC     Q
        LDA     #$46
        SEC
        SBC     QQ14
        ASL     A
        STA     &1AD0
        LDX     #$01
.L2F43
        STX     XX13
        JSR     TT67

        LDX     XX13
        CLC
        JSR     pr2

        JSR     &2E05

        LDA     XX13
        CLC
        ADC     #$68
        JSR     TT27

        LDA     XX13
        JSR     &3086

        SEC
        LDA     #$19
        STA     XC
        LDA     #$06
        JSR     TT11

        LDX     XX13
        INX
        CPX     Q
        BCC     &2F43

.L2F6F
        JSR     CLYNS

FLFLLS = L2F6F+2
        LDA     #$7F
        JSR     prq

        JSR     gnum

        BEQ     bay

        BCS     bay

        SBC     #$00
        LDX     #$02
        STX     XC
        INC     YC
        PHA
        JSR     eq

        PLA
        BNE     &2F92

.L2F8D
        LDX     #$46
NWSHP = L2F8D+1
        STX     QQ14
.L2F92
        CMP     #$01
        BNE     &2FA6

        LDX     NOMSL
        INX
        LDY     #$7C
        CPX     #$05
        BCS     pres

        STX     NOMSL
        JSR     msblob

.L2FA6
        LDY     #$6B
        CMP     #$02
        BNE     &2FB6

        LDX     #$25
        CPX     CRGO
        BEQ     pres

        STX     CRGO
.L2FB6
        CMP     #$03
        BNE     &2FC3

        INY
        LDX     ECM
        BNE     pres

        DEC     ECM
.L2FC3
        CMP     #$04
        BNE     &2FD1

        JSR     qv

        LDA     #$0F
        JSR     &30ED

        LDA     #$04
.L2FD1
        CMP     #$05
        BNE     &2FDD

        JSR     qv

        LDA     #$8F
        JSR     &30ED

.L2FDD
        LDY     #$6F
        CMP     #$06
        BNE     &3003

        LDX     BST
        BEQ     &3000

.pres
        STY     K
        JSR     prx

        JSR     &2ECE

        LDA     K
        JSR     &2690

        LDA     #$1F
        JSR     TT27

.err
        JSR     dn2

        JMP     &38B0

.L3000
        DEC     BST
.L3003
        INY
        CMP     #$07
        BNE     &3010

        LDX     ESCP
        BNE     pres

        DEC     ESCP
.L3010
        INY
        CMP     #$08
        BNE     &301F

        LDX     BOMB
        BNE     pres

        LDX     #$7F
        STX     BOMB
.L301F
        INY
        CMP     #$09
        BNE     &302C

        LDX     ENGY
        BNE     pres

        INC     ENGY
.L302C
        INY
        CMP     #$0A
        BNE     &3039

        LDX     DKCMP
        BNE     pres

        DEC     DKCMP
.L3039
        INY
        CMP     #$0B
        BNE     &3046

        LDX     GHYP
        BNE     pres

        DEC     GHYP
.L3046
        INY
        CMP     #$0C
        BNE     &3053

        JSR     qv

        LDA     #$97
        JSR     &30ED

.L3053
        INY
        CMP     #$0D
        BNE     &3060

        JSR     qv

        LDA     #$32
        JSR     &30ED

.L3060
        JSR     dn

        JMP     EQSHP

.dn
        JSR     &2E05

        LDA     #$77
        JSR     &2690

.dn2
        JSR     BEEP

        LDY     #$32
        JMP     DELAY

.eq
        JSR     prx

        JSR     &2EA7

        BCS     &3092

        LDA     #$C5
        JSR     prq

        JMP     err

.L3086
        SEC
        SBC     #$01
.prx
        ASL     A
        TAY
        LDX     L1AD0,Y
        LDA     L1AD1,Y
        TAY
.L3092
        RTS

.qv
        LDA     tek
        CMP     #$08
        BCC     &309F

        LDA     #$20
        JSR     TT66

.L309F
        LDY     #$10
        STY     YC
.L30A3
        LDX     #$0C
        STX     XC
        TYA
        CLC
        ADC     #$20
        JSR     &2690

        LDA     YC
        CLC
        ADC     #$50
        JSR     TT27

        INC     YC
        LDY     YC
        CPY     #$14
        BCC     &30A3

        JSR     CLYNS

.qv2
        LDA     #$AF
        JSR     prq

        JSR     TT217

        SEC
        SBC     #$30
        CMP     #$04
        BCC     &30D6

        JSR     CLYNS

        JMP     qv2

.L30D6
        TAX
        RTS

.hm
        JSR     TT103

        JSR     TT111

        JSR     TT103

        JMP     CLYNS

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
.L30ED
        STA     T1
        LDA     LASER,X
        BEQ     &3113

        LDY     #$04
        CMP     #$0F
        BEQ     &3108

        LDY     #$05
        CMP     #$8F
        BEQ     &3108

        LDY     #$0C
        CMP     #$97
        BEQ     &3108

        LDY     #$0D
.L3108
        STX     ZZ
        TYA
        JSR     prx

        JSR     &2ECE

        LDX     ZZ
.L3113
        LDA     T1
        STA     LASER,X
        RTS

.cpl
        LDX     #$05
.L311B
        LDA     QQ15,X
        STA     QQ19,X
        DEX
        BPL     &311B

        LDY     #$03
        BIT     QQ15
        BVS     &3129

        DEY
.L3129
        STY     T
.L312B
        LDA     QQ15+5
        AND     #$1F
        BEQ     &3136

        ORA     #$80
        JSR     TT27

.L3136
        JSR     TT54

        DEC     T
        BPL     &312B

        LDX     #$05
.L313F
        LDA     QQ19,X
        STA     QQ15,X
        DEX
        BPL     &313F

        RTS

.L3147
        JSR     MT19

        LDY     #$00
.L314C
        LDA     L1181,Y
        CMP     #$0D
        BEQ     &3159

        JSR     TT26

        INY
        BNE     &314C

.L3159
        RTS

.L315A
        JSR     TT62

        JSR     cpl

.TT62
        LDX     #$05
.L3162
        LDA     QQ15,X
        LDY     QQ2,X
        STA     QQ2,X
        STY     QQ15,X
        DEX
        BPL     &3162

        RTS

.L3170
        CLC
        LDX     GCNT
        INX
        JMP     pr2

.L3178
        LDA     #$69
        JSR     TT68

        LDX     QQ14
        SEC
        JSR     pr2

        LDA     #$C3
        JSR     plf

        LDA     #$77
        BNE     TT27

.L318D
        LDX     #$03
.L318F
        LDA     CASH,X
        STA     K,X
        DEX
        BPL     &318F

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

.L31AA
        LDA     #$3A
.TT27
        TAX
        BEQ     &318D

        BMI     &3225

        DEX
        BEQ     &3170

        DEX
        BEQ     &315A

        DEX
        BNE     &31BD

        JMP     cpl

.L31BD
        DEX
        BEQ     &3147

        DEX
        BEQ     &3178

        DEX
        BNE     &31CB

        LDA     #$80
        STA     K5
        RTS

.L31CB
        DEX
        DEX
        BNE     &31D2

        STX     K5
        RTS

.L31D2
        DEX
        BEQ     &320D

        CMP     #$60
        BCS     &323F

        CMP     #$0E
        BCC     &31E1

        CMP     #$20
        BCC     &3209

.L31E1
        LDX     K5
        BEQ     &3222

        BMI     &31F8

        BIT     K5
        BVS     &321B

.L31EB
        CMP     #$41
        BCC     &31F5

        CMP     #$5B
        BCS     &31F5

        ADC     #$20
.L31F5
        JMP     TT26

.L31F8
        BIT     K5
        BVS     &3213

        CMP     #$41
        BCC     &3222

        PHA
        TXA
        ORA     #$40
        STA     K5
        PLA
        BNE     &31F5

.L3209
        ADC     #$72
        BNE     &323F

.L320D
        LDA     #$15
        STA     XC
        BNE     &31AA

.L3213
        CPX     #$FF
        BEQ     &327A

        CMP     #$41
        BCS     &31EB

.L321B
        PHA
        TXA
        AND     #$BF
        STA     K5
        PLA
.L3222
        JMP     TT26

.L3225
        CMP     #$A0
        BCS     &323D

        AND     #$7F
        ASL     A
        TAY
        LDA     QQ16,Y
        JSR     TT27

        LDA     QQ16+1,Y
        CMP     #$3F
        BEQ     &327A

        JMP     TT27

.L323D
        SBC     #$A0
.L323F
        TAX
        LDA     #$00
        STA     V
        LDA     #$04
        STA     V+1
        LDY     #$00
        TXA
        BEQ     &3260

.L324D
        LDA     (V),Y
        BEQ     &3258

        INY
        BNE     &324D

        INC     V+1
        BNE     &324D

.L3258
        INY
        BNE     &325D

        INC     V+1
.L325D
        DEX
        BNE     &324D

.L3260
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
        BNE     &3276

        INC     V+1
.L3276
        LDA     (V),Y
        BNE     &3260

.L327A
        RTS

        LDA     INWK+31
        ORA     #$A0
        STA     INWK+31
        RTS

.L3282
        RTS

.WPSHPS
        LDX     #$00
.L3285
        LDA     FRIN,X
        BEQ     &32A8

        BMI     &32A5

        JSR     GINF

        LDY     #$1F
.L3291
        LDA     (INF),Y
        STA     XX1,Y
        DEY
        BPL     &3291

        STX     XSAV
        LDX     XSAV
        LDY     #$1F
        LDA     (INF),Y
        AND     #$A7
        STA     (INF),Y
.L32A5
        INX
        BNE     &3285

.L32A8
        LDX     #$FF
        STX     LSX2
        STX     LSY2
.L32B0
        LDY     #$BF
        LDA     #$00
.L32B4
        STA     LSX,Y
        DEY
        BNE     &32B4

        DEY
        STY     LSX
        RTS

        LDA     #$06
        SEI
        STA     VIA
        STX     VIA+$01
        CLI
        RTS

.L32CA
        DEX
        RTS

        INX
        BEQ     &32CA

        DEC     ENERGY
        PHP
        BNE     &32D8

        INC     ENERGY
.L32D8
        PLP
        RTS

.SPL1
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
        LDA     L1741,Y
        STA     INF
        LDA     L1742,Y
        STA     INF+1
        RTS

.L32FB
        STA     T
        LDX     #$00
.L32FF
        LDA     FRIN,X
        BEQ     &330B

        INX
        CPX     #$0C
        BCC     &32FF

        CLC
.L330A
        RTS

.L330B
        JSR     GINF

        LDA     T
        BMI     &3362

        ASL     A
        TAY
        LDA     L55FE,Y
        STA     XX0
        LDA     L55FF,Y
        STA     XX0+1
        CPY     #$04
        BEQ     &3352

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
        BCC     &330A

        BNE     &3348

        CPY     #$25
        BCC     &330A

.L3348
        LDA     INWK+33
        STA     SLSP
        LDA     INWK+34
        STA     SLSP+1
.L3352
        LDY     #$0E
        LDA     (XX0),Y
        STA     INWK+35
        LDY     #$13
        LDA     (XX0),Y
        AND     #$07
        STA     INWK+31
        LDA     T
.L3362
        STA     FRIN,X
        TAX
        BMI     &336B

        INC     MANY,X
.L336B
        LDY     #$24
.L336D
        LDA     XX1,Y
        STA     (INF),Y
        DEY
        BPL     &336D

        SEC
        RTS

        LDA     XX1,X
        EOR     #$80
        STA     XX1,X
        INX
        INX
        RTS

        LDX     #$FF
        STX     MSTG
        LDX     NOMSL
        JSR     MSBAR

        STY     MSAR
        RTS

        LDA     #$C0
        LDX     #$9F
        LDY     #$33
        STA     SC
        STX     P+1
        STY     P+2
        LDA     #$7D
        JMP     RREN

.L339F
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
.L33BA
        STA     (SC),Y
        DEY
        BNE     &33BA

        RTS

.L33C0
        TXA
        EOR     #$FF
        CLC
        ADC     #$01
        TAX
.L33C7
        LDA     #$FF
        BNE     &340E

.L33CB
        LDA     #$01
        STA     LSX
        JSR     CHKON

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
        BNE     &33F2

        CMP     P+1
        BCC     &33F2

        LDA     P+1
        BNE     &33F2

        LDA     #$01
.L33F2
        STA     TGT
        LDA     #$BF
        SEC
        SBC     K4
        TAX
        LDA     #$00
        SBC     K4+1
        BMI     &33C0

        BNE     &340A

        INX
        DEX
        BEQ     &33C7

        CPX     K
        BCC     &340E

.L340A
        LDX     K
        LDA     #$00
.L340E
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
.L3427
        CPY     TGT
        BEQ     PLFL

        LDA     LSX,Y
        BEQ     &3433

        JSR     HLOIN2

.L3433
        DEY
        BNE     &3427

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
        BCC     &345D

        LDA     #$FF
.L345D
        LDX     LSX,Y
        STA     LSX,Y
        BEQ     &34AF

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

        BCS     &3494

        LDA     X2
        LDX     XX
        STX     X2
        STA     XX
        JSR     HLOIN

.L3494
        LDA     XX
        STA     XX15
        LDA     XX+1
        STA     X2
.L349C
        JSR     HLOIN

.L349F
        DEY
        BEQ     &34E1

        LDA     V+1
        BNE     &34C3

        DEC     V
        BNE     PLFL

        DEC     V+1
.L34AC
        JMP     PLFL

.L34AF
        LDX     K3
        STX     YY
        LDX     K3+1
        STX     YY+1
        JSR     EDGES

        BCC     &349C

        LDA     #$00
        STA     LSX,Y
        BEQ     &349F

.L34C3
        LDX     V
        INX
        STX     V
        CPX     K
        BCC     &34AC

        BEQ     &34AC

        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
.L34D6
        LDA     LSX,Y
        BEQ     &34DE

        JSR     HLOIN2

.L34DE
        DEY
        BNE     &34D6

.L34E1
        CLC
        LDA     K3
        STA     SUNX
        LDA     K3+1
        STA     SUNX+1
        RTS

        LDA     #$00
        STA     LSX2
        LDX     K
        LDA     #$08
        CPX     #$08
        BCC     &34FE

        LSR     A
        CPX     #$3C
        BCC     &34FE

        LSR     A
.L34FE
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
        BCC     &3523

        EOR     #$FF
        ADC     #$00
        TAX
        LDA     #$FF
        ADC     #$00
        STA     T
        TXA
        CLC
.L3523
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
        BCC     &3551

        TXA
        EOR     #$FF
        ADC     #$00
        TAX
        LDA     #$FF
        ADC     #$00
        STA     T
        CLC
.L3551
        JSR     BLINE

        CMP     #$41
        BCS     &355B

        JMP     PLL3

.L355B
        CLC
        RTS

        LDA     #$01
        STA     LSP
        LDA     #$FF
        STA     LSX2
        RTS

        LDA     LSX
        BMI     &35AE

        LDA     SUNX
        STA     YY
        LDA     SUNX+1
        STA     YY+1
        LDY     #$BF
.L3576
        LDA     LSX,Y
        BEQ     &357E

        JSR     HLOIN2

.L357E
        DEY
        BNE     &3576

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
        BMI     &35B0

        BEQ     &3599

        LDA     #$FE
        STA     X2
.L3599
        LDA     YY
        SEC
        SBC     T
        STA     XX15
        LDA     YY+1
        SBC     #$00
        BNE     &35A8

        CLC
        RTS

.L35A8
        BPL     &35B0

        LDA     #$02
        STA     XX15
.L35AE
        CLC
        RTS

.L35B0
        LDA     #$00
        STA     LSX,Y
.L35B5
        SEC
        RTS

.CHKON
        LDA     K3
        CLC
        ADC     K
        LDA     K3+1
        ADC     #$00
        BMI     &35B5

        LDA     K3
        SEC
        SBC     K
        LDA     K3+1
        SBC     #$00
        BMI     &35CF

        BNE     &35B5

.L35CF
        LDA     K4
        CLC
        ADC     K
        STA     P+1
        LDA     K4+1
        ADC     #$00
        BMI     &35B5

        STA     P+2
        LDA     K4
        SEC
        SBC     K
        TAX
        LDA     K4+1
        SBC     #$00
        BMI     &35AE

        BNE     &35B5

        CPX     #$BF
        RTS

.TT17
        JSR     DOKEY

        LDA     JSTK
        BEQ     &361C

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

.L361C
        LDA     KL
        LDX     #$00
        LDY     #$00
        CMP     #$19
        BNE     &3628

        DEX
.L3628
        CMP     #$79
        BNE     &362D

        INX
.L362D
        CMP     #$39
        BNE     &3632

        INY
.L3632
        CMP     #$29
        BNE     &3637

        DEY
.L3637
        STX     T
        LDX     #$00
        JSR     DKS4

        BPL     &3648

        ASL     T
        ASL     T
        TYA
        ASL     A
        ASL     A
        TAY
.L3648
        LDX     T
        LDA     KL
        RTS

.ping
        LDX     #$01
.L3650
        LDA     QQ0,X
        STA     QQ9,X
        DEX
        BPL     &3650

        RTS

.L365A
        EQUB    $12,$01,$00,$10,$12,$02,$2C,$08
        EQUB    $11,$03,$F0,$18,$10,$F1,$07,$1A
        EQUB    $03,$F1,$BC,$01,$13,$F4,$0C,$08
        EQUB    $10,$F1,$06,$0C,$10,$02,$60,$10
        EQUB    $13,$04,$C2,$FF,$13,$00,$00,$00

.RESET
        JSR     ZERO

        LDX     #$06
.L3687
        STA     BETA,X
        DEX
        BPL     &3687

        TXA
        STA     QQ12
        LDX     #$02
.L3691
        STA     FSH,X
        DEX
        BPL     &3691

.RES2
        LDA     #$12
        STA     NOSTM
        LDX     #$FF
        STX     LSX2
        STX     LSY2
        STX     MSTG
        LDA     #$80
        STA     JSTY
        STA     ALP2
        STA     BET2
        ASL     A
        STA     ALP2+1
        STA     BET2+1
        STA     MCNT
        LDA     #$03
.L36B8
        STA     DELTA
L36B9 = L36B8+1
        STA     ALPHA
        STA     ALP1
        LDA     ECMA
        BEQ     yu

        JSR     ECMOF

.yu
        JSR     WPSHPS

        JSR     ZERO

        LDA     #$FF
        STA     SLSP
        LDA     #$0C
        STA     SLSP+1
        JSR     DIALS

.ZINF
        LDY     #$24
        LDA     #$00
.L36DC
        STA     XX1,Y
        DEY
        BPL     &36DC

        LDA     #$60
        STA     INWK+18
        STA     INWK+22
        ORA     #$80
        STA     INWK+14
        RTS

.msblob
        LDX     #$04
.L36EF
        CPX     NOMSL
        BEQ     &36FD

        LDY     #$00
        JSR     MSBAR

        DEX
        BNE     &36EF

        RTS

.L36FD
        LDY     #$EE
        JSR     MSBAR

        DEX
        BNE     &36FD

        RTS

.me2
        LDA     MCH
        JSR     MESS

        LDA     #$00
        STA     DLY
        JMP     &3754

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
        TXA
        CMP     #$F5
        ROL     A
        ORA     #$C0
        STA     INWK+32
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

.TT100
        DEC     DLY
        BEQ     me2

        BPL     &3754

        INC     DLY
.L3754
        DEC     MCNT
        BEQ     &375B

.L3758
        JMP     MLOOP

.L375B
        LDA     MJ
        BNE     &3758

        JSR     DORND

        CMP     #$23
        BCS     MLOOP

        LDA     MANY+7
        CMP     #$03
        BCS     MLOOP

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
.MLOOP
        LDX     #$FF
        TXS
        LDX     GNTMP
        BEQ     &3794

        DEC     GNTMP
.L3794
        JSR     DIALS

        LDA     QQ11
        BEQ     &37A0

        LDY     #$02
        JSR     DELAY

.L37A0
        JSR     TT17

.FRCE
        JSR     TT102

        LDA     QQ12
        BNE     MLOOP

        JMP     TT100

.TT102
        CMP     #$76
        BNE     &37B4

        JMP     &1AFF

.L37B4
        CMP     #$14
        BNE     &37BB

        JMP     TT22

.L37BB
        CMP     #$74
        BNE     &37C2

        JMP     TT23

.L37C2
        CMP     #$75
        BNE     &37CC

        JSR     TT111

        JMP     TT25

.L37CC
        CMP     #$77
        BNE     &37D3

        JMP     TT213

.L37D3
        CMP     #$16
        BNE     &37DA

        JMP     TT167

.L37DA
        CMP     #$20
        BNE     &37E1

        JMP     Flight

.L37E1
        CMP     #$73
        BNE     &37E8

        JMP     EQSHP

.L37E8
        CMP     #$71
        BNE     &37EF

        JMP     TT219

.L37EF
        CMP     #$47
        BNE     &37FE

        JSR     &3A86

        BCC     &37FB

        JMP     &389D

.L37FB
        JMP     &38B0

.L37FE
        CMP     #$72
        BNE     &3805

        JMP     TT208

.L3805
        CMP     #$54
        BNE     &3815

        JSR     CLYNS

        LDA     #$0F
        STA     XC
        LDA     #$CD
        JMP     DETOK

.L3815
        CMP     #$32
        BEQ     &3845

        CMP     #$43
        BNE     &3826

        LDA     QQ11
        AND     #$C0
        BEQ     &3844

        JMP     HME2

.L3826
        STA     T1
        LDA     QQ11
        AND     #$C0
        BEQ     &3844

        LDA     QQ22+1
        BNE     &3844

        LDA     T1
        CMP     #$36
        BNE     &3841

        JSR     TT103

        JSR     ping

        JSR     TT103

.L3841
        JSR     TT16

.L3844
        RTS

.L3845
        LDA     QQ11
        AND     #$C0
        BEQ     &3844

        JSR     hm

        STA     K5
        JSR     cpl

        LDA     #$80
        STA     K5
        LDA     #$01
        STA     XC
        INC     YC
        JMP     TT146

        LDA     QQ20+3
        CLC
        ADC     QQ20+6
        ASL     A
        ADC     QQ20+10
        RTS

.L386C
        EQUB    $00

.BRBR
        DEC     &386C
        BNE     BR1

        JSR     RES2

.BEGIN
        JSR     BRKBK

        LDX     #$0A
        LDA     #$00
.L387C
        STA     COMC,X
        DEX
        BPL     &387C

.TT170
        LDX     #$FF
        TXS
.BR1
        LDX     #$03
        STX     XC
        JSR     FX200

        LDX     #$0B
        LDA     #$06
        JSR     TITLE

        CMP     #$44
        BNE     &389D

        JSR     DFAULT

        JSR     &3A86

.L389D
        JSR     DFAULT

        JSR     msblob

        LDA     #$07
        LDX     #$13
        JSR     TITLE

        JSR     ping

        JSR     &2E6B

.BAY
.L38B0
        LDA     #$FF
        STA     QQ12
        LDA     #$76
        JMP     FRCE

.DFAULT
        LDX     #$53
.L38BB
        LDA     L1180,X
        STA     YSAV2,X
        DEX
        BNE     &38BB

        STX     QQ11
.L38C6
        JSR     CHECK

        CMP     &11D4
        BNE     &38C6

        EOR     #$A9
        TAX
        LDA     COK
        CPX     &11D3
        BEQ     &38DB

        ORA     #$80
.L38DB
        ORA     #$20
        STA     COK
        RTS

.TITLE
        PHA
        STX     TYPE
        JSR     RESET

        LDA     #$01
        JSR     TT66

        DEC     QQ11
        LDA     #$60
        STA     INWK+14
        LDA     K2+4
        CMP     #$DB
        BEQ     &3902

        LDA     #$10
        STA     &36B8
        LDA     #$FE
        STA     &36B9
.L3902
        STA     INWK+7
        LDX     #$7F
        STX     INWK+29
        STX     INWK+30
        INX
        STX     K5
        LDA     TYPE
        JSR     &32FB

        LDY     #$06
        STY     XC
        LDA     #$1E
        JSR     plf

        LDY     #$06
        STY     XC
        INC     YC
        LDA     PATG
        BEQ     &392B

        LDA     #$0D
        JSR     DETOK

.L392B
        LDA     &386C
        BEQ     &3945

        INC     &386C
        LDA     #$07
        STA     XC
        LDA     #$0A
        STA     YC
        LDY     #$00
.L393D
        JSR     OSWRCH

        INY
        LDA     (L00FD),Y
        BNE     &393D

.L3945
        JSR     CLYNS

        STY     DELTA
        STY     JSTK
        PLA
        JSR     DETOK

        LDA     #$0C
        LDX     #$07
        STX     XC
        JSR     DETOK

.L395A
        LDA     INWK+7
        CMP     #$01
        BEQ     &3962

        DEC     INWK+7
.L3962
        JSR     MVEIT

        LDA     #$80
        STA     INWK+6
        ASL     A
        STA     XX1
        STA     INWK+3
        JSR     LL9

        DEC     MCNT
        LDA     VIA+$40
        AND     #$10
        BEQ     &3980

        JSR     RDKEY

        BEQ     &395A

        RTS

.L3980
        DEC     JSTK
        RTS

.CHECK
        LDX     #$49
        CLC
        TXA
.L3988
        ADC     L1188,X
        EOR     L1189,X
        DEX
        BNE     &3988

        RTS

.TRNME
        LDX     #$07
.L3994
        LDA     INWK+5,X
        STA     L1181,X
        DEX
        BPL     &3994

.L399C
        LDX     #$07
.L399E
        LDA     L1181,X
        STA     INWK+5,X
        DEX
        BPL     &399E

        RTS

.GTNMEW
        LDY     #$08
        JSR     DELAY

.GTNME
        LDX     #$04
.L39AE
        LDA     L117C,X
        STA     XX1,X
        DEX
        BPL     &39AE

        LDA     #$07
        STA     &39EB
        LDA     #$08
        JSR     DETOK

        JSR     MT26

        LDA     #$09
        STA     &39EB
        TYA
        BEQ     &399C

        RTS

.MT26
        LDA     #$81
        STA     VIA+$4E
        JSR     FLKB

        LDX     #$E9
        LDY     #$39
        LDA     #$00
        JSR     OSWORD

        BCC     &39E1

        LDY     #$00
.L39E1
        LDA     #$01
        STA     VIA+$4E
        JMP     &1C8A

.L39E9
        EQUB    $4B,$00

.L39EB
        EQUB    $09,$21,$7B

.ZERO
        LDX     #$3A
        LDA     #$00
.L39F2
        STA     FRIN,X
        DEX
        BPL     &39F2

        RTS

.ZEBC
        LDX     #$0C
        JSR     ZES1

        DEX
.ZES1
        LDY     #$00
        STY     SC
.ZES2
        LDA     #$00
        STX     SCH
.L3A07
        STA     (SC),Y
        INY
        BNE     &3A07

        RTS

.L3A0D
        EQUS    "."

.L3A0E
        EQUS    "0"

        EQUB    $0D

.L3A10
        EQUS    "DE.:"

.L3A14
        EQUS    "0"

.L3A15
        EQUS    ".E.1234567"

        EQUB    $0D

.CATS
        JSR     GTDRV

        BCS     &3A42

        STA     &3A0E
        STA     DTW7
        LDA     #$04
        JSR     DETOK

        LDA     #$01
        STA     CATF
        STA     XC
        LDX     #$0D
        LDY     #$3A
        JSR     SCLI

        DEC     CATF
        CLC
.L3A42
        RTS

.L3A43
        JSR     CATS

        BCS     &3A86

        LDA     &3A0E
        STA     &3A14
        LDA     #$09
        JSR     DETOK

        JSR     MT26

        TYA
        BEQ     &3A86

        LDX     #$09
.L3A5B
        LDA     INWK+4,X
        STA     L3A15,X
        DEX
        BNE     &3A5B

        LDX     #$10
        LDY     #$3A
        JSR     SCLI

        JMP     &3A86

.stack
        BRK
        EQUB    $AE

        ADC     &9A3A
        LDY     #$00
        LDA     #$07
.L3A76
        JSR     OSWRCH

        INY
        LDA     (L00FD),Y
        BNE     &3A76

        BEQ     &3A83

.L3A80
        JSR     CATS

.L3A83
        JSR     &3D61

.L3A86
        JSR     ZEBC

        TSX
        STX     stack
        LDA     #$6E
        STA     &11EF
        LDA     #$3A
        STA     &11F0
        LDA     #$01
        JSR     DETOK

        JSR     &3D61

        CMP     #$31
        BCC     &3B14

        CMP     #$34
        BEQ     &3A43

        BCS     &3B14

        CMP     #$32
        BCS     &3AB9

        JSR     GTNMEW

        JSR     LOD

        JSR     TRNME

        SEC
        BCS     &3B15

.L3AB9
        BNE     &3A80

        JSR     GTNMEW

        JSR     TRNME

        LSR     SVC
        LDA     #$03
        JSR     DETOK

        LDX     #$4B
.L3ACB
        LDA     TP,X
        STA     L0B00,X
        STA     L1189,X
        DEX
        BPL     &3ACB

        JSR     CHECK

        STA     &11D4
        PHA
        ORA     #$80
        STA     K
        EOR     COK
        STA     K+2
        EOR     CASH+2
        STA     K+1
        EOR     #$5A
        EOR     TALLY+1
        STA     K+3
        CLC
        JSR     BPRNT

        JSR     TT67

        PLA
        STA     &0B4B
        EOR     #$A9
        STA     &11D3
        STA     &0B4A
        LDY     #$0B
        STY     &0C0B
        INY
        STY     &0C0F
        LDA     #$00
        JSR     QUS1

.L3B14
        CLC
.L3B15
        JMP     BRKBK

.QUS1
        PHA
        JSR     GTDRV

        STA     INWK+1
        PLA
        BCS     &3B2E

        LDX     #$46
        STX     &0C00
        LDX     #$00
        LDY     #$0C
        JSR     OSFILE

        CLC
.L3B2E
        RTS

.GTDRV
        LDA     #$02
        JSR     DETOK

        JSR     &3D61

        ORA     #$10
        JSR     CHPR

        PHA
        JSR     &1C8A

        PLA
        CMP     #$30
        BCC     &3B6A

        CMP     #$34
        RTS

.LOD
        JSR     ZEBC

        LDY     #$0B
        STY     &0C03
        INC     &0C0B
        LDA     #$FF
        JSR     QUS1

        BCS     &3B6A

        LDA     &0B00
        BMI     &3B6C

        LDX     #$4B
.L3B61
        LDA     L0B00,X
        STA     L1189,X
        DEX
        BPL     &3B61

.L3B6A
        SEC
        RTS

.L3B6C
        EQUB    $00,$49,$49,$6C,$6C,$65,$67,$61
        EQUB    $6C,$20,$45,$4C,$49,$54,$45,$20
        EQUB    $49,$49,$20,$66,$69,$6C,$65,$00

.FX200
        LDY     #$00
        LDA     #$C8
        JMP     OSBYTE

        JSR     GTNME

        RTS

        LDX     #$00
        JSR     SPL1

        LDX     #$03
        JSR     SPL1

        LDX     #$06
        JSR     SPL1

        LDA     K3
        ORA     K3+3
        ORA     K3+6
        ORA     #$01
        STA     K3+9
        LDA     K3+1
        ORA     K3+4
        ORA     K3+7
.L3BAE
        ASL     K3+9
        ROL     A
        BCS     &3BC1

        ASL     K3
        ROL     K3+1
        ASL     K3+3
        ROL     K3+4
        ASL     K3+6
        ROL     K3+7
        BCC     &3BAE

.L3BC1
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
.L3C1F
        RTS

.RDKEY
        LDX     #$10
.L3C22
        JSR     DKS4

        BMI     &3C2B

        INX
        BPL     &3C22

        TXA
.L3C2B
        EOR     #$80
        TAX
        RTS

.ECMOF
        LDA     #$00
        STA     ECMA
        STA     ECMP
        LDA     #$48
        BNE     &3C6C

        LDA     #$10
        JSR     &3C6C

        LDA     #$18
        BNE     &3C6C

.BEEP
        LDA     #$20
        BNE     &3C6C

        INC     TALLY
        BNE     &3C54

        INC     TALLY+1
        LDA     #$65
        JSR     MESS

.L3C54
        LDX     #$07
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
.L3C6C
        JSR     NOS1

.NO3
        LDX     DNOIZ
        BNE     &3C1F

        LDX     #$09
        LDY     #$00
        LDA     #$07
        JMP     OSWORD

.NOS1
        LSR     A
        ADC     #$03
        TAY
        LDX     #$07
.L3C83
        LDA     #$00
        STA     XX16,X
        DEX
        LDA     L365A,Y
        STA     XX16,X
        DEY
        DEX
        BPL     &3C83

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
        BNE     &3CCC

        LDA     DAMP-$40,X
        EOR     #$FF
        STA     DAMP-$40,X
        JSR     BELL

        JSR     DELAY

        LDY     T
.L3CCC
        RTS

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

.DOKEY
        LDA     JSTK
        BEQ     DK9

        LDX     #$01
        JSR     DKS2

        ORA     #$01
        STA     JSTX
        LDX     #$02
        JSR     DKS2

        EOR     JSTGY
        STA     JSTY
.DK4
        JSR     RDKEY

        STX     KL
        CPX     #$69
        BNE     &3D51

.L3D14
        JSR     &260B

        JSR     RDKEY

        CPX     #$51
        BNE     &3D23

        LDA     #$00
        STA     DNOIZ
.L3D23
        LDY     #$40
.L3D25
        JSR     DKS3

        INY
        CPY     #$47
        BNE     &3D25

        CPX     #$10
        BNE     &3D34

        STX     DNOIZ
.L3D34
        CPX     #$70
        BNE     &3D3B

        JMP     BR1

.L3D3B
        CPX     #$64
        BNE     &3D4D

        LDA     BSTK
        EOR     #$FF
        STA     BSTK
        STA     JSTK
        STA     JSTE
.L3D4D
        CPX     #$59
        BNE     &3D14

.L3D51
        LDA     QQ11
        BNE     &3D76

        LDY     #$10
        LDA     #$FF
        RTS

.DK9
        STA     BSTK
        BEQ     DK4

.TT217
        STY     YSAV
.L3D61
        LDY     #$02
        JSR     DELAY

        JSR     RDKEY

        BNE     &3D61

.L3D6B
        JSR     RDKEY

        BEQ     &3D6B

        TAY
        LDA     (TRTB%),Y
        LDY     YSAV
        TAX
.L3D76
        RTS

.L3D77
        STX     DLY
        PHA
        LDA     MCH
        JSR     mes9

        PLA
.MESS
        LDX     #$00
        STX     K5
        LDY     #$09
        STY     XC
        LDY     #$16
        STY     YC
        CPX     DLY
        BNE     &3D77

        STY     DLY
        STA     MCH
.mes9
        JSR     TT27

        LSR     de
        BEQ     &3D76

        LDA     #$FD
        JMP     TT27

.L3DA6
        EQUB    $13

.L3DA7
        EQUB    $82,$06

.L3DA9
        EQUB    $01,$14,$81,$0A,$03,$41,$83,$02
        EQUB    $07,$28,$85,$E2,$1F,$53,$85,$FB
        EQUB    $0F,$C4,$08,$36,$03,$EB,$1D,$08
        EQUB    $78,$9A,$0E,$38,$03,$75,$06,$28
        EQUB    $07,$4E,$01,$11,$1F,$7C,$0D,$1D
        EQUB    $07,$B0,$89,$DC,$3F,$20,$81,$35
        EQUB    $03,$61,$A1,$42,$07,$AB,$A2,$37
        EQUB    $1F,$2D,$C1,$FA,$0F,$35,$0F,$C0
        EQUB    $07

.L3DEA
        TYA
        LDY     #$02
        JSR     TIS3

        STA     INWK+20
        JMP     TI3

.L3DF5
        TAX
        LDA     Y1
        AND     #$60
        BEQ     &3DEA

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
        BEQ     &3DF5

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
        STA     INWK+26
        LDA     #$00
        LDX     #$0E
.L3E85
        STA     INWK+9,X
        DEX
        DEX
        BPL     &3E85

        RTS

.TIS2
        TAY
        AND     #$7F
        CMP     Q
        BCS     &3EB3

        LDX     #$FE
        STX     T
.L3E97
        ASL     A
        CMP     Q
        BCC     &3E9E

        SBC     Q
.L3E9E
        ROL     T
        BCS     &3E97

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

.L3EB3
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
.L3EEC
        ROL     A
        CMP     Q
        BCC     &3EF3

        SBC     Q
.L3EF3
        ROL     P
        ROL     P+1
        DEX
        BNE     &3EEC

        LDA     P
        ORA     T
        RTS

.SHPPT
        JSR     EE51

        LDA     #$60
        CMP     #$BE
        BCS     &3F23

        LDY     #$02
        JSR     &3F2A

        LDY     #$06
        LDA     #$60
        ADC     #$01
        JSR     &3F2A

        LDA     #$08
        ORA     INWK+31
        STA     INWK+31
        LDA     #$08
        JMP     &46EF

.L3F21
        PLA
        PLA
.L3F23
        LDA     #$F7
        AND     INWK+31
        STA     INWK+31
        RTS

.L3F2A
        STA     (INWK+33),Y
        INY
        INY
        STA     (INWK+33),Y
        LDA     #$80
        DEY
        STA     (INWK+33),Y
        ADC     #$03
        BCS     &3F21

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
.L3F4C
        CPX     Q
        BCC     &3F5E

        BNE     &3F56

        CPY     #$40
        BCC     &3F5E

.L3F56
        TYA
        SBC     #$40
        TAY
        TXA
        SBC     Q
        TAX
.L3F5E
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
        BNE     &3F4C

        RTS

.LL28
        CMP     Q
        BCS     &3F93

.L3F79
        LDX     #$FE
        STX     R
.L3F7D
        ASL     A
        BCS     &3F8B

        CMP     Q
        BCC     &3F86

        SBC     Q
.L3F86
        ROL     R
        BCS     &3F7D

        RTS

.L3F8B
        SBC     Q
        SEC
        ROL     R
        BCS     &3F7D

        RTS

.L3F93
        LDA     #$FF
        STA     R
        RTS

.LL38
        EOR     S
        BMI     &3FA2

        LDA     Q
        CLC
        ADC     R
        RTS

.L3FA2
        LDA     R
        SEC
        SBC     Q
        BCC     &3FAB

        CLC
        RTS

.L3FAB
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
.L3FBC
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
        BCC     &3FBC

        RTS

.LL9
        LDA     #$1F
        STA     XX4
        LDA     #$20
        BIT     INWK+31
        BNE     &4046

        BPL     &4046

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
.L403C
        INY
        JSR     DORND

        STA     (INWK+33),Y
        CPY     #$06
        BNE     &403C

.L4046
        LDA     INWK+8
        BPL     &4067

.L404A
        LDA     INWK+31
        AND     #$20
        BEQ     EE51

        LDA     INWK+31
        AND     #$F7
        STA     INWK+31
        JMP     &3282

.EE51
        LDA     #$08
        BIT     INWK+31
        BEQ     &4066

        EOR     INWK+31
        STA     INWK+31
        JMP     LL155

.L4066
        RTS

.L4067
        LDA     INWK+7
        CMP     #$C0
        BCS     &404A

        LDA     XX1
        CMP     INWK+6
        LDA     INWK+1
        SBC     INWK+7
        BCS     &404A

        LDA     INWK+3
        CMP     INWK+6
        LDA     INWK+4
        SBC     INWK+7
        BCS     &404A

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
        BNE     &40AA

        LDA     T
        ROR     A
        LSR     A
        LSR     A
        LSR     A
        STA     XX4
        BPL     &40BB

.L40AA
        LDY     #$0D
        LDA     (XX0),Y
        CMP     INWK+7
        BCS     &40BB

        LDA     #$20
        AND     INWK+31
        BNE     &40BB

        JMP     SHPPT

.L40BB
        LDX     #$05
.L40BD
        LDA     INWK+21,X
        STA     XX16,X
        LDA     INWK+15,X
        STA     XX16+6,X
        LDA     INWK+9,X
        STA     XX16+12,X
        DEX
        BPL     &40BD

        LDA     #$C5
        STA     Q
        LDY     #$10
.L40D2
        LDA     XX16,Y
        ASL     A
        LDA     XX16+1,Y
        ROL     A
        JSR     LL28

        LDX     R
        STX     XX16,Y
        DEY
        DEY
        BPL     &40D2

        LDX     #$08
.L40E7
        LDA     XX1,X
        STA     K5,X
        DEX
        BPL     &40E7

        LDA     #$FF
        STA     K4+1
        LDY     #$0C
        LDA     INWK+31
        AND     #$20
        BEQ     &410C

        LDA     (XX0),Y
        LSR     A
        LSR     A
        TAX
        LDA     #$FF
.L4101
        STA     K3,X
        DEX
        BPL     &4101

        INX
        STX     XX4
.L4109
        JMP     LL42

.L410C
        LDA     (XX0),Y
        BEQ     &4109

        STA     XX20
        LDY     #$12
        LDA     (XX0),Y
        TAX
        LDA     K6+3
        TAY
        BEQ     &412B

.L411C
        INX
        LSR     K6
        ROR     QQ19+2
        LSR     QQ19
        ROR     K5
        LSR     A
        ROR     K6+2
        TAY
        BNE     &411C

.L412B
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
        BCS     &418C

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

.L418C
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
        BCC     &41CC

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

.L41C4
        LSR     K5
        LSR     K6+2
        LSR     QQ19+2
        LDX     #$01
.L41CC
        LDA     XX12
        STA     XX15
        LDA     XX12+2
        STA     X2
        LDA     XX12+4
        DEX
        BMI     &41E1

.L41D9
        LSR     XX15
        LSR     X2
        LSR     A
        DEX
        BPL     &41D9

.L41E1
        STA     R
        LDA     XX12+5
        STA     S
        LDA     K6+2
        STA     Q
        LDA     K6+4
        JSR     LL38

        BCS     &41C4

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

        BCS     &41C4

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

        BCS     &41C4

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
        BMI     &4275

        LDA     #$00
.L4275
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
        BCC     &430F

        INY
        LDA     (V),Y
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     &4312

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     &4312

        INY
        LDA     (V),Y
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     &4312

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     &4312

.L430F
        JMP     LL50

.L4312
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
        BMI     &4337

        CLC
        LDA     XX12
        ADC     XX1
        STA     XX15
        LDA     INWK+1
        ADC     #$00
        STA     Y1
        JMP     LL53

.L4337
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
        BCC     &4354

        INC     Y1
.L4354
        LDA     X2
        EOR     #$80
        STA     X2
.LL53
        LDA     INWK+5
        STA     XX15+5
        EOR     XX12+3
        BMI     &4372

        CLC
        LDA     XX12+2
        ADC     INWK+3
        STA     Y2
        LDA     INWK+4
        ADC     #$00
        STA     XX15+4
        JMP     LL55

.L4372
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
        BMI     &43E5

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
        BEQ     &43CB

        LDX     #$00
.L43B1
        LSR     A
        INX
        CMP     Q
        BCS     &43B1

        STX     S
        JSR     LL28

        LDX     S
        LDA     R
.L43C0
        ASL     A
        ROL     U
        BMI     &43CB

        DEX
        BNE     &43C0

        STA     R
        RTS

.L43CB
        LDA     #$32
        STA     R
        STA     U
        RTS

.L43D2
        LDA     #$80
        SEC
        SBC     R
        STA     XX3,X
        INX
        LDA     #$00
        SBC     U
        STA     XX3,X
        JMP     LL66

.L43E5
        LDA     INWK+6
        SEC
        SBC     XX12+4
        STA     T
        LDA     INWK+7
        SBC     #$00
        STA     U
        BCC     &43FC

        BNE     LL57

        LDA     T
        CMP     #$04
        BCS     LL57

.L43FC
        LDA     #$00
        STA     U
        LDA     #$04
        STA     T
.LL57
        LDA     U
        ORA     Y1
        ORA     XX15+4
        BEQ     &441B

        LSR     Y1
        ROR     XX15
        LSR     XX15+4
        ROR     Y2
        LSR     U
        ROR     T
        JMP     LL57

.L441B
        LDA     T
        STA     Q
        LDA     XX15
        CMP     Q
        BCC     &442B

        JSR     LL61

        JMP     LL65

.L442B
        JSR     LL28

.LL65
        LDX     CNT
        LDA     X2
        BMI     &43D2

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
        BCC     &446D

        JSR     LL61

        JMP     LL68

.L445A
        LDA     #$60
        CLC
        ADC     R
        STA     XX3,X
        INX
        LDA     #$00
        ADC     U
        STA     XX3,X
        JMP     LL50

.L446D
        JSR     LL28

.LL68
        PLA
        TAX
        INX
        LDA     XX15+5
        BMI     &445A

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
        BCS     &449C

        CMP     XX20
        BCS     &449C

        JMP     LL48

.L449C
        LDA     INWK+31
        AND     #$20
        BEQ     &44AB

        LDA     INWK+31
        ORA     #$08
        STA     INWK+31
        JMP     &3282

.L44AB
        LDA     #$08
        BIT     INWK+31
        BEQ     &44B6

        JSR     LL155

        LDA     #$08
.L44B6
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
        BVC     &4520

        LDA     INWK+31
        AND     #$BF
        STA     INWK+31
        LDY     #$06
        LDA     (XX0),Y
        TAY
        LDX     XX3,Y
        STX     XX15
        INX
        BEQ     &4520

        LDX     XX3+1,Y
        STX     Y1
        INX
        BEQ     &4520

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
        BPL     &4503

        DEC     XX15+4
.L4503
        JSR     LL145

        BCS     &4520

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
.L4520
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
        BCC     &4557

        INY
        LDA     (V),Y
        INY
        STA     P
        AND     #$0F
        TAX
        LDA     K3,X
        BNE     &455A

        LDA     P
        LSR     A
        LSR     A
        LSR     A
        LSR     A
        TAX
        LDA     K3,X
        BNE     &455A

.L4557
        JMP     LL78

.L455A
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

        BCS     &4557

        JMP     LL80

.LL145
        LDA     #$00
        STA     SWAP
        LDA     XX15+5
.LL147
        LDX     #$BF
        ORA     XX12+1
        BNE     &45A6

        CPX     XX12
        BCC     &45A6

        LDX     #$00
.L45A6
        STX     XX13
        LDA     Y1
        ORA     Y2
        BNE     &45CA

        LDA     #$BF
        CMP     X2
        BCC     &45CA

        LDA     XX13
        BNE     &45C8

.LL146
        LDA     X2
        STA     Y1
        LDA     XX15+4
        STA     X2
        LDA     XX12
        STA     Y2
        CLC
        RTS

.L45C6
        SEC
        RTS

.L45C8
        LSR     XX13
.L45CA
        LDA     XX13
        BPL     &45FD

        LDA     Y1
        AND     XX15+5
        BMI     &45C6

        LDA     Y2
        AND     XX12+1
        BMI     &45C6

        LDX     Y1
        DEX
        TXA
        LDX     XX15+5
        DEX
        STX     XX12+2
        ORA     XX12+2
        BPL     &45C6

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
        BPL     &45C6

.L45FD
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
        BPL     &462E

        LDA     #$00
        SEC
        SBC     XX12+4
        STA     XX12+4
        LDA     #$00
        SBC     XX12+5
        STA     XX12+5
.L462E
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
        BNE     &4644

        LDX     XX12+5
        BEQ     &464E

.L4644
        LSR     A
        ROR     XX12+2
        LSR     XX12+5
        ROR     XX12+4
        JMP     LL111

.L464E
        STX     T
        LDA     XX12+2
        CMP     XX12+4
        BCC     &4660

        STA     Q
        LDA     XX12+4
        JSR     LL28

        JMP     LL116

.L4660
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
        BEQ     &4679

        BPL     &468C

.L4679
        JSR     LL118

        LDA     XX13
        BPL     &46B1

        LDA     Y1
        ORA     Y2
        BNE     &46B6

        LDA     X2
        CMP     #$C0
        BCS     &46B6

.L468C
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
.L46B1
        PLA
        TAY
        JMP     LL146

.L46B6
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

.LL78
        INC     XX17
        LDY     XX17
        CPY     XX20
        BCS     LL81

        LDY     #$00
        LDA     V
        ADC     #$04
        STA     V
        BCC     &46EA

        INC     V+1
.L46EA
        JMP     LL75

.LL81
        LDA     U
.L46EF
        LDY     #$00
        STA     (INWK+33),Y
.LL155
        LDY     #$00
        LDA     (INWK+33),Y
        STA     XX20
        CMP     #$04
        BCC     &4719

        INY
.L46FE
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
        BCC     &46FE

.L4719
        RTS

.LL118
        LDA     Y1
        BPL     &4735

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
.L4735
        BEQ     &4750

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
.L4750
        LDA     Y2
        BPL     &476E

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
.L476E
        LDA     X2
        SEC
        SBC     #$C0
        STA     R
        LDA     Y2
        SBC     #$00
        STA     S
        BCC     &4793

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
.L4793
        RTS

.LL120
        LDA     XX15
        STA     R
        JSR     LL129

        PHA
        LDX     T
        BNE     &47CB

.L47A0
        LDA     #$00
        TAX
        TAY
        LSR     S
        ROR     R
        ASL     Q
        BCC     &47B5

.L47AC
        TXA
        CLC
        ADC     R
        TAX
        TYA
        ADC     S
        TAY
.L47B5
        LSR     S
        ROR     R
        ASL     Q
        BCS     &47AC

        BNE     &47B5

        PLA
        BPL     &47F2

        RTS

.LL123
        JSR     LL129

        PHA
        LDX     T
        BNE     &47A0

.L47CB
        LDA     #$FF
        TAY
        ASL     A
        TAX
.L47D0
        ASL     R
        ROL     S
        LDA     S
        BCS     &47DC

        CMP     Q
        BCC     &47E7

.L47DC
        SBC     Q
        STA     S
        LDA     R
        SBC     #$00
        STA     R
        SEC
.L47E7
        TXA
        ROL     A
        TAX
        TYA
        ROL     A
        TAY
        BCS     &47D0

        PLA
        BMI     &47FE

.L47F2
        TXA
        EOR     #$FF
        ADC     #$01
        TAX
        TYA
        EOR     #$FF
        ADC     #$00
        TAY
.L47FE
        RTS

.LL129
        LDX     XX12+2
        STX     Q
        LDA     S
        BPL     &4818

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
.L4818
        EOR     XX12+3
        RTS

.TKN1
        EQUB    $57

        EQUB    $5E,$5C,$56,$5F,$77,$A6,$04,$1C
        EQUB    $77,$16,$14,$BE,$04,$04,$77,$1A
        EQUB    $12,$B6,$80,$5D,$55,$66,$79,$77
        EQUB    $C2,$80,$65,$79,$77,$04,$16,$AD
        EQUB    $77,$CD,$77,$53,$80,$64,$79,$77
        EQUB    $14,$A2,$16,$B7,$10,$02,$12,$80
        EQUB    $63,$79,$77,$13,$12,$1B,$8A,$12
        EQUB    $87,$11,$1E,$B2,$80,$62,$79,$77
        EQUB    $12,$0F,$8C,$80,$57,$5B,$00,$1F
        EQUB    $1E,$14,$1F,$77,$C0,$68,$57,$14
        EQUB    $18,$1A,$07,$12,$AC,$AC,$88,$77
        EQUB    $B6,$1A,$15,$A3,$6D,$57,$C1,$C0
        EQUB    $77,$47,$CF,$80,$57,$E7,$3A,$9D
        EQUB    $39,$E6,$57,$77,$77,$C2,$77,$56
        EQUB    $7F,$0E,$78,$19,$7E,$68,$55,$5B
        EQUB    $5B,$57,$07,$A5,$04,$04,$77,$04
        EQUB    $07,$16,$BE,$77,$AA,$77,$11,$1E
        EQUB    $A5,$7B,$CD,$79,$5B,$5B,$57,$CD
        EQUB    $70,$04,$9F,$57,$42,$11,$1E,$B2
        EQUB    $9E,$13,$12,$1B,$8A,$12,$68,$57
        EQUB    $40,$59,$55,$10,$A5,$8A,$A7,$10
        EQUB    $04,$82,$E5,$44,$1E,$77,$A0,$10
        EQUB    $87,$1A,$18,$1A,$A1,$03,$77,$18
        EQUB    $11,$77,$E4,$05,$77,$01,$B3,$02
        EQUB    $8F,$B2,$77,$AC,$1A,$12,$9B,$00
        EQUB    $12,$77,$00,$8E,$1B,$13,$77,$1B
        EQUB    $1E,$1C,$12,$77,$E4,$9E,$13,$18
        EQUB    $87,$1B,$8C,$03,$B2,$77,$1D,$18
        EQUB    $15,$77,$11,$AA,$77,$BB,$9B,$C4
        EQUB    $98,$77,$E4,$77,$8D,$12,$77,$1F
        EQUB    $12,$A5,$9D,$16,$85,$1A,$18,$13
        EQUB    $12,$1B,$7B,$77,$C4,$44,$14,$88
        EQUB    $89,$05,$1E,$14,$03,$AA,$7B,$77
        EQUB    $12,$A9,$1E,$07,$93,$00,$1E,$B5
        EQUB    $87,$03,$18,$07,$77,$8D,$14,$05
        EQUB    $8A,$85,$04,$1F,$1E,$12,$1B,$13
        EQUB    $77,$10,$A1,$A3,$A2,$AA,$9B,$02
        EQUB    $19,$11,$AA,$03,$02,$19,$A2,$12
        EQUB    $1B,$0E,$77,$8C,$70,$04,$77,$A0
        EQUB    $A1,$77,$89,$18,$1B,$A1,$9B,$41
        EQUB    $8C,$77,$00,$A1,$03,$77,$1A,$1E
        EQUB    $04,$04,$94,$11,$05,$18,$1A,$77
        EQUB    $8E,$05,$77,$98,$77,$0E,$B9,$13
        EQUB    $77,$88,$77,$44,$B1,$A3,$77,$11
        EQUB    $1E,$AD,$77,$1A,$88,$B5,$04,$77
        EQUB    $16,$10,$18,$E5,$4B,$9B,$E4,$05
        EQUB    $77,$1A,$1E,$04,$04,$1E,$88,$7B
        EQUB    $77,$04,$1F,$8E,$1B,$13,$77,$E4
        EQUB    $77,$13,$12,$14,$1E,$13,$12,$9E
        EQUB    $16,$14,$BE,$07,$03,$77,$8C,$7B
        EQUB    $77,$1E,$04,$9E,$8D,$12,$1C,$E5
        EQUB    $13,$BA,$03,$05,$18,$0E,$77,$C3
        EQUB    $98,$9B,$E4,$77,$16,$A5,$77,$14
        EQUB    $16,$02,$AC,$88,$93,$B5,$A2,$77
        EQUB    $88,$1B,$0E,$77,$51,$22,$52,$04
        EQUB    $77,$00,$8B,$1B,$77,$07,$A1,$8A
        EQUB    $AF,$03,$12,$77,$C4,$19,$12,$00
        EQUB    $77,$04,$1F,$1E,$12,$1B,$13,$04
        EQUB    $E5,$B5,$A2,$77,$C4,$44,$14,$88
        EQUB    $89,$05,$1E,$14,$03,$AA,$9D,$11
        EQUB    $8C,$03,$93,$00,$1E,$B5,$77,$A8
        EQUB    $77,$51,$3B,$52,$E6,$55,$5F,$10
        EQUB    $18,$18,$13,$77,$1B,$02,$14,$1C
        EQUB    $7B,$77,$CD,$83,$41,$57,$4E,$5E
        EQUB    $40,$59,$55,$77,$77,$A2,$03,$A1
        EQUB    $AC,$88,$82,$79,$77,$44,$00,$12
        EQUB    $77,$1F,$16,$AD,$77,$19,$12,$93
        EQUB    $18,$11,$77,$E4,$05,$77,$8D,$05
        EQUB    $01,$1E,$14,$BA,$77,$16,$10,$16
        EQUB    $A7,$9B,$1E,$11,$77,$E4,$77,$00
        EQUB    $8E,$1B,$13,$77,$A0,$77,$BC,$77
        EQUB    $10,$18,$18,$13,$77,$16,$04,$9E
        EQUB    $10,$18,$9E,$44,$BE,$A3,$A6,$77
        EQUB    $E4,$77,$00,$8B,$1B,$77,$A0,$77
        EQUB    $15,$05,$1E,$12,$11,$AB,$9B,$1E
        EQUB    $11,$77,$04,$02,$14,$BE,$04,$04
        EQUB    $11,$02,$1B,$7B,$77,$E4,$77,$00
        EQUB    $8B,$1B,$77,$A0,$77,$00,$12,$1B
        EQUB    $1B,$77,$A5,$00,$B9,$13,$AB,$83
        EQUB    $4F,$57,$7F,$44,$14,$7E,$77,$16
        EQUB    $14,$AA,$19,$BC,$11,$03,$77,$66
        EQUB    $6E,$6F,$63,$57,$15,$0E,$77,$13
        EQUB    $79,$15,$AF,$A0,$19,$77,$71,$77
        EQUB    $1E,$79,$A0,$1B,$1B,$57,$42,$C6
        EQUB    $9F,$4D,$57,$4E,$5E,$40,$59,$55
        EQUB    $77,$77,$14,$88,$10,$AF,$03,$02
        EQUB    $AE,$AC,$88,$04,$77,$CD,$76,$5B
        EQUB    $5B,$B5,$A3,$12,$5A,$77,$00,$8B
        EQUB    $1B,$77,$B3,$00,$16,$0E,$04,$77
        EQUB    $A0,$87,$07,$AE,$BE,$77,$11,$AA
        EQUB    $77,$E4,$77,$A7,$84,$9B,$A8,$13
        EQUB    $77,$B8,$0E,$A0,$77,$BC,$88,$A3
        EQUB    $77,$B5,$A8,$77,$E4,$77,$B5,$A7
        EQUB    $1C,$79,$79,$83,$4F,$57,$11,$8F
        EQUB    $B2,$13,$57,$B4,$03,$8F,$B2,$57
        EQUB    $00,$12,$1B,$1B,$77,$1C,$B4,$00
        EQUB    $19,$57,$11,$16,$1A,$18,$BB,$57
        EQUB    $B4,$03,$AB,$57,$AD,$05,$0E,$57
        EQUB    $1A,$8B,$13,$1B,$0E,$57,$1A,$18
        EQUB    $89,$57,$A5,$16,$04,$88,$8F,$1B
        EQUB    $0E,$57,$57,$F2,$57,$25,$57,$10
        EQUB    $A5,$A2,$57,$01,$16,$89,$57,$07
        EQUB    $A7,$1C,$57,$55,$20,$77,$21,$5A
        EQUB    $77,$EE,$16,$AC,$88,$04,$57,$CB
        EQUB    $04,$57,$22,$57,$D7,$77,$11,$AA
        EQUB    $BA,$03,$04,$57,$18,$BE,$A8,$04
        EQUB    $57,$04,$1F,$0E,$19,$BA,$04,$57
        EQUB    $04,$8B,$1B,$A7,$BA,$04,$57,$B8
        EQUB    $03,$94,$03,$AF,$A6,$AC,$88,$04
        EQUB    $57,$B7,$A2,$1F,$94,$18,$11,$77
        EQUB    $33,$57,$B7,$AD,$77,$11,$AA,$77
        EQUB    $33,$57,$11,$18,$18,$13,$77,$15
        EQUB    $B2,$19,$13,$A3,$04,$57,$03,$8E
        EQUB    $05,$1E,$89,$04,$57,$07,$18,$8A
        EQUB    $05,$0E,$57,$A6,$04,$14,$18,$04
        EQUB    $57,$3B,$57,$00,$B3,$1C,$94,$C9
        EQUB    $57,$14,$AF,$15,$57,$15,$A2,$57
        EQUB    $B7,$15,$89,$57,$45,$57,$A0,$04
        EQUB    $8A,$57,$07,$AE,$10,$02,$AB,$57
        EQUB    $AF,$01,$16,$10,$AB,$57,$14,$02
        EQUB    $05,$04,$AB,$57,$04,$14,$8E,$05
        EQUB    $10,$AB,$57,$26,$77,$14,$1E,$01
        EQUB    $8B,$77,$00,$B9,$57,$3F,$77,$08
        EQUB    $77,$37,$04,$57,$16,$77,$3F,$77
        EQUB    $A6,$8D,$16,$8D,$57,$26,$77,$12
        EQUB    $B9,$B5,$A9,$16,$1C,$BA,$57,$26
        EQUB    $77,$BC,$AE,$05,$77,$16,$14,$AC
        EQUB    $01,$8C,$0E,$57,$F8,$0A,$77,$09
        EQUB    $57,$C4,$46,$77,$08,$77,$37,$57
        EQUB    $F8,$96,$04,$70,$77,$35,$77,$34
        EQUB    $57,$55,$2D,$5A,$57,$F8,$3C,$77
        EQUB    $3B,$57,$1D,$02,$1E,$BE,$57,$15
        EQUB    $AF,$19,$13,$0E,$57,$00,$A2,$A3
        EQUB    $57,$15,$A5,$00,$57,$10,$B9,$10
        EQUB    $B2,$77,$15,$AE,$89,$A3,$04,$57
        EQUB    $45,$57,$46,$77,$37,$57,$46,$77
        EQUB    $45,$57,$46,$77,$3F,$57,$3F,$77
        EQUB    $45,$57,$11,$8F,$02,$B7,$BB,$57
        EQUB    $12,$0F,$18,$AC,$14,$57,$1F,$18
        EQUB    $18,$07,$0E,$57,$02,$B6,$04,$02
        EQUB    $B3,$57,$12,$0F,$14,$8C,$A7,$10
        EQUB    $57,$14,$02,$1E,$04,$A7,$12,$57
        EQUB    $19,$1E,$10,$1F,$03,$77,$1B,$1E
        EQUB    $11,$12,$57,$14,$16,$04,$1E,$B4
        EQUB    $04,$57,$04,$8C,$77,$14,$18,$1A
        EQUB    $04,$57,$55,$2D,$5A,$57,$54,$57
        EQUB    $C4,$C6,$77,$54,$57,$C4,$C5,$77
        EQUB    $54,$57,$C3,$C6,$57,$C3,$C5,$57
        EQUB    $04,$88,$77,$18,$11,$87,$15,$8C
        EQUB    $14,$1F,$57,$04,$14,$8E,$19,$13
        EQUB    $A5,$1B,$57,$15,$AE,$14,$1C,$10
        EQUB    $02,$B9,$13,$57,$05,$18,$10,$02
        EQUB    $12,$57,$00,$1F,$AA,$BA,$88,$77
        EQUB    $A0,$8A,$B2,$77,$1F,$12,$16,$13
        EQUB    $91,$11,$AE,$07,$77,$12,$B9,$70
        EQUB    $13,$77,$1C,$19,$16,$AD,$57,$19
        EQUB    $77,$02,$19,$A5,$B8,$05,$1C,$8F
        EQUB    $B2,$57,$77,$15,$AA,$A7,$10,$57
        EQUB    $77,$13,$02,$1B,$1B,$57,$77,$03
        EQUB    $12,$A6,$18,$BB,$57,$77,$A5,$01
        EQUB    $18,$1B,$03,$A7,$10,$57,$C6,$57
        EQUB    $C5,$57,$07,$AE,$BE,$57,$1B,$8C
        EQUB    $03,$B2,$77,$C6,$57,$13,$02,$1A
        EQUB    $07,$57,$1E,$77,$1F,$12,$B9,$87
        EQUB    $25,$77,$B7,$18,$1C,$94,$98,$77
        EQUB    $16,$07,$07,$12,$B9,$93,$A2,$86
        EQUB    $57,$0E,$12,$16,$1F,$7B,$77,$1E
        EQUB    $77,$1F,$12,$B9,$87,$25,$77,$98
        EQUB    $77,$B2,$11,$03,$86,$87,$77,$00
        EQUB    $1F,$1E,$B2,$77,$15,$16,$14,$1C
        EQUB    $57,$10,$8A,$77,$E4,$05,$77,$1E
        EQUB    $05,$88,$77,$16,$04,$04,$77,$18
        EQUB    $01,$A3,$77,$03,$18,$86,$57,$BC
        EQUB    $1A,$12,$77,$24,$85,$98,$77,$00
        EQUB    $16,$04,$77,$8D,$A1,$77,$A2,$86
        EQUB    $57,$03,$05,$0E,$86,$57,$57,$57
        EQUB    $57,$57,$00,$16,$04,$07,$57,$1A
        EQUB    $18,$B5,$57,$10,$05,$02,$15,$57
        EQUB    $A8,$03,$57,$45,$57,$07,$18,$8A
        EQUB    $57,$B9,$03,$04,$77,$10,$AF,$13
        EQUB    $02,$A2,$12,$57,$0E,$16,$1C,$57
        EQUB    $04,$19,$16,$8B,$57,$04,$1B,$02
        EQUB    $10,$57,$03,$05,$18,$07,$1E,$14
        EQUB    $B3,$57,$13,$A1,$8D,$57,$AF,$A7
        EQUB    $57,$1E,$1A,$07,$A1,$8A,$AF,$15
        EQUB    $B2,$57,$12,$0F,$02,$A0,$AF,$19
        EQUB    $03,$57,$11,$02,$19,$19,$0E,$57
        EQUB    $00,$1E,$A3,$13,$57,$02,$B6,$04
        EQUB    $02,$B3,$57,$89,$AF,$19,$B0,$57
        EQUB    $07,$12,$14,$02,$1B,$1E,$B9,$57
        EQUB    $11,$A5,$A9,$A1,$03,$57,$18,$14
        EQUB    $14,$16,$04,$1E,$88,$B3,$57,$02
        EQUB    $19,$07,$A5,$A6,$14,$03,$8F,$B2
        EQUB    $57,$13,$A5,$16,$13,$11,$02,$1B
        EQUB    $57,$FC,$57,$0B,$77,$0C,$77,$11
        EQUB    $AA,$77,$32,$57,$DB,$E5,$32,$57
        EQUB    $31,$77,$15,$0E,$77,$30,$57,$DB
        EQUB    $77,$15,$02,$03,$77,$D9,$57,$77
        EQUB    $16,$38,$77,$27,$57,$07,$1B,$A8
        EQUB    $8A,$57,$00,$AA,$1B,$13,$57,$B5
        EQUB    $12,$77,$57,$B5,$1E,$04,$77,$57
        EQUB    $B7,$16,$13,$85,$CD,$57,$5E,$5C
        EQUB    $56,$5F,$57,$13,$05,$1E,$AD,$57
        EQUB    $77,$14,$A2,$16,$B7,$10,$02,$12
        EQUB    $57,$1E,$A8,$57,$44,$14,$18,$1A
        EQUB    $1A,$A8,$13,$A3,$57,$3F,$57,$1A
        EQUB    $8E,$19,$03,$16,$A7,$57,$AB,$1E
        EQUB    $15,$B2,$57,$03,$A5,$12,$57,$04
        EQUB    $07,$18,$03,$03,$AB,$57,$2F,$57
        EQUB    $2E,$57,$36,$18,$1E,$13,$57,$28
        EQUB    $57,$29,$57,$A8,$14,$1E,$A1,$03
        EQUB    $57,$12,$0F,$BE,$07,$AC,$88,$B3
        EQUB    $57,$12,$14,$BE,$19,$03,$05,$1E
        EQUB    $14,$57,$A7,$10,$AF,$A7,$AB,$57
        EQUB    $25,$57,$1C,$8B,$1B,$A3,$57,$13
        EQUB    $12,$16,$13,$1B,$0E,$57,$12,$01
        EQUB    $8B,$57,$B2,$B5,$B3,$57,$01,$1E
        EQUB    $14,$1E,$18,$BB,$57,$8C,$04,$77
        EQUB    $57,$5A,$59,$44,$57,$79,$5B,$58
        EQUB    $57,$77,$A8,$13,$77,$57,$0E,$8E
        EQUB    $57,$07,$B9,$1C,$94,$1A,$8A,$A3
        EQUB    $04,$57,$13,$BB,$03,$77,$14,$B7
        EQUB    $02,$13,$04,$57,$1E,$BE,$77,$A0
        EQUB    $05,$10,$04,$57,$05,$18,$14,$1C
        EQUB    $77,$11,$AA,$B8,$AC,$88,$04,$57
        EQUB    $01,$18,$1B,$14,$16,$B4,$BA,$57
        EQUB    $07,$1B,$A8,$03,$57,$03,$02,$1B
        EQUB    $1E,$07,$57,$15,$A8,$A8,$16,$57
        EQUB    $14,$AA,$19,$57,$45,$00,$12,$AB
        EQUB    $57,$45,$57,$46,$77,$45,$57,$46
        EQUB    $77,$3F,$57,$A7,$1F,$16,$BD,$03
        EQUB    $A8,$03,$57,$E8,$57,$A7,$10,$77
        EQUB    $57,$AB,$77,$57,$57,$57,$57,$77
        EQUB    $19,$16,$1A,$12,$68,$77,$57,$77
        EQUB    $03,$18,$77,$57,$77,$1E,$04,$77
        EQUB    $57,$00,$16,$04,$77,$AE,$89,$77
        EQUB    $8D,$A1,$77,$A2,$77,$44,$57,$79
        EQUB    $5B,$77,$44,$57,$13,$18,$14,$1C
        EQUB    $AB,$57,$56,$7F,$0E,$78,$19,$7E
        EQUB    $68,$57,$04,$1F,$1E,$07,$57,$77
        EQUB    $16,$77,$57,$77,$A3,$05,$1E,$BB
        EQUB    $57,$77,$19,$12,$00,$77,$57,$55
        EQUB    $77,$1F,$A3,$77,$B8,$1D,$BA,$03
        EQUB    $0E,$70,$04,$77,$04,$07,$16,$BE
        EQUB    $77,$19,$16,$01,$0E,$5A,$57,$E6
        EQUB    $5F,$56,$77,$77,$1A,$BA,$04,$16
        EQUB    $B0,$77,$A1,$13,$04,$57,$77,$CD
        EQUB    $77,$53,$7B,$77,$1E,$77,$5A,$16
        EQUB    $1A,$55,$77,$14,$16,$07,$03,$16
        EQUB    $A7,$77,$4C,$77,$5A,$18,$11,$84
        EQUB    $57,$57,$58,$77,$02,$19,$1C,$B4
        EQUB    $00,$19,$77,$C6,$57,$5E,$5F,$40
        EQUB    $56,$A7,$14,$18,$1A,$94,$1A,$BA
        EQUB    $04,$16,$B0,$57,$14,$02,$05,$05
        EQUB    $02,$B5,$A3,$04,$57,$11,$18,$04
        EQUB    $13,$0E,$1C,$12,$77,$04,$1A,$0E
        EQUB    $B5,$12,$57,$11,$AA,$03,$BA,$A9
        EQUB    $12,$57,$9C,$A5,$BA,$A6,$BE,$57
        EQUB    $1E,$04,$77,$A0,$1B,$1E,$12,$01
        EQUB    $AB,$9E,$1F,$16,$AD,$77,$1D,$02
        EQUB    $1A,$07,$AB,$9E,$C3,$10,$B3,$16
        EQUB    $0F,$0E,$57,$4E,$5E,$4A,$59,$55
        EQUB    $10,$18,$18,$13,$77,$13,$16,$0E
        EQUB    $77,$CD,$77,$53,$9B,$1E,$5A,$77
        EQUB    $16,$1A,$77,$44,$16,$10,$A1,$03
        EQUB    $77,$44,$15,$AE,$1C,$12,$77,$18
        EQUB    $11,$77,$44,$19,$16,$01,$16,$1B
        EQUB    $77,$44,$A7,$03,$12,$1B,$B2,$10
        EQUB    $A1,$BE,$9B,$16,$04,$77,$E4,$77
        EQUB    $1C,$B4,$00,$7B,$77,$C4,$44,$19
        EQUB    $16,$01,$0E,$77,$1F,$16,$AD,$77
        EQUB    $A0,$A1,$77,$1C,$12,$12,$07,$94
        EQUB    $C4,$44,$B5,$B9,$10,$18,$1E,$13
        EQUB    $04,$77,$18,$11,$11,$77,$E4,$05
        EQUB    $77,$16,$04,$04,$77,$8E,$03,$77
        EQUB    $A7,$77,$13,$12,$12,$07,$77,$04
        EQUB    $07,$16,$BE,$77,$11,$AA,$77,$B8
        EQUB    $19,$0E,$77,$0E,$12,$B9,$04,$77
        EQUB    $B4,$00,$79,$77,$44,$00,$12,$1B
        EQUB    $1B,$77,$C4,$04,$8C,$02,$16,$AC
        EQUB    $88,$77,$1F,$16,$04,$77,$14,$1F
        EQUB    $A8,$10,$AB,$9B,$8E,$05,$77,$15
        EQUB    $18,$0E,$04,$77,$B9,$12,$77,$A5
        EQUB    $16,$13,$0E,$77,$11,$AA,$87,$07
        EQUB    $02,$04,$1F,$77,$05,$1E,$10,$1F
        EQUB    $03,$9E,$C4,$1F,$18,$1A,$12,$77
        EQUB    $04,$0E,$04,$03,$12,$1A,$77,$18
        EQUB    $11,$77,$B5,$18,$8D,$77,$1A,$18
        EQUB    $B5,$A3,$04,$9B,$4F,$5E,$4A,$1E
        EQUB    $5A,$77,$1F,$16,$AD,$77,$18,$15
        EQUB    $03,$16,$A7,$93,$C4,$13,$12,$11
        EQUB    $A1,$BE,$77,$07,$AE,$19,$04,$77
        EQUB    $11,$AA,$77,$B5,$12,$1E,$05,$77
        EQUB    $44,$1F,$1E,$AD,$77,$44,$00,$AA
        EQUB    $1B,$13,$04,$9B,$C4,$A0,$8A,$B2
        EQUB    $04,$77,$1C,$B4,$00,$77,$00,$12
        EQUB    $70,$AD,$77,$10,$18,$03,$77,$BC
        EQUB    $1A,$12,$B5,$94,$15,$02,$03,$77
        EQUB    $B4,$03,$77,$00,$1F,$A2,$9B,$1E
        EQUB    $11,$77,$44,$1E,$77,$03,$AF,$19
        EQUB    $04,$1A,$8C,$77,$C4,$07,$AE,$19
        EQUB    $04,$9E,$8E,$05,$77,$15,$16,$8D
        EQUB    $77,$88,$77,$44,$BD,$A5,$AF,$77
        EQUB    $B5,$12,$0E,$70,$1B,$1B,$77,$A7
        EQUB    $03,$A3,$BE,$07,$03,$77,$C4,$03
        EQUB    $05,$A8,$04,$1A,$1E,$04,$04,$1E
        EQUB    $88,$79,$77,$44,$1E,$77,$19,$12
        EQUB    $AB,$87,$98,$9E,$B8,$1C,$12,$77
        EQUB    $C4,$05,$02,$19,$9B,$E4,$70,$A5
        EQUB    $77,$12,$B2,$14,$03,$AB,$9B,$C4
        EQUB    $07,$AE,$19,$04,$77,$16,$A5,$77
        EQUB    $02,$19,$1E,$07,$02,$1B,$8D,$77
        EQUB    $14,$18,$13,$93,$00,$1E,$B5,$A7
        EQUB    $77,$C3,$03,$05,$A8,$04,$1A,$1E
        EQUB    $04,$04,$1E,$88,$9B,$5F,$E4,$77
        EQUB    $00,$8B,$1B,$77,$A0,$77,$07,$16
        EQUB    $1E,$13,$9B,$77,$77,$77,$77,$44
        EQUB    $10,$18,$18,$13,$77,$1B,$02,$14
        EQUB    $1C,$77,$CD,$83,$4F,$57,$4E,$5E
        EQUB    $4A,$5F,$59,$5A,$44,$00,$12,$1B
        EQUB    $1B,$77,$13,$88,$12,$77,$CD,$9B
        EQUB    $E4,$77,$1F,$16,$AD,$77,$8D,$05
        EQUB    $01,$93,$02,$04,$77,$00,$12,$1B
        EQUB    $1B,$E5,$00,$12,$77,$04,$1F,$B3
        EQUB    $1B,$77,$A5,$1A,$12,$1A,$15,$A3
        EQUB    $9B,$00,$12,$77,$13,$1E,$13,$77
        EQUB    $B4,$03,$77,$12,$0F,$07,$12,$14
        EQUB    $03,$77,$C4,$44,$B5,$B9,$10,$18
        EQUB    $1E,$13,$04,$9E,$11,$A7,$13,$77
        EQUB    $8E,$03,$77,$16,$15,$8E,$03,$77
        EQUB    $E4,$9B,$11,$AA,$77,$C4,$1A,$18
        EQUB    $1A,$A1,$03,$77,$07,$B2,$16,$8D
        EQUB    $77,$16,$14,$BE,$07,$03,$77,$C3
        EQUB    $44,$19,$16,$01,$0E,$77,$51,$25
        EQUB    $52,$77,$16,$04,$77,$07,$16,$0E
        EQUB    $1A,$A1,$03,$83,$4F,$57,$57,$04
        EQUB    $1F,$A5,$00,$57,$A0,$16,$89,$57
        EQUB    $15,$1E,$04,$88,$57,$04,$19,$16
        EQUB    $1C,$12,$57,$00,$18,$1B,$11,$57
        EQUB    $B2,$18,$07,$B9,$13,$57,$14,$A2
        EQUB    $57,$1A,$88,$1C,$12,$0E,$57,$10
        EQUB    $18,$A2,$57,$11,$1E,$04,$1F,$57
        EQUB    $3D,$77,$3E,$57,$46,$77,$2F,$77
        EQUB    $2C,$57,$F8,$3C,$77,$2E,$77,$2C
        EQUB    $57,$2B,$77,$2A,$57,$3D,$77,$3E
        EQUB    $57,$1A,$12,$A2,$57,$14,$02,$03
        EQUB    $1B,$8A,$57,$89,$12,$16,$1C,$57
        EQUB    $15,$02,$05,$10,$A3,$04,$57,$BC
        EQUB    $02,$07,$57,$1E,$BE,$57,$1A,$02
        EQUB    $13,$57,$0D,$A3,$18,$7A,$44,$10
        EQUB    $57,$01,$16,$14,$02,$02,$1A,$57
        EQUB    $46,$77,$02,$1B,$03,$AF,$57,$1F
        EQUB    $18,$14,$1C,$12,$0E,$57,$14,$05
        EQUB    $1E,$14,$1C,$8A,$57,$1C,$B9,$A2
        EQUB    $12,$57,$07,$18,$B7,$57,$03,$A1
        EQUB    $19,$1E,$04,$57

.L5338
        EQUB    $57
.RUPLA
        EQUB    $D3,$96,$24,$1C,$FD,$4F,$35,$76
        EQUB    $64,$20,$44,$A4,$DC,$6A,$10,$A2
        EQUB    $03,$6B,$1A,$C0,$B8,$05,$65,$C1

.L5351
        EQUB    $29
.RUGAL
        EQUB    $80,$00,$00,$00,$01,$01,$01,$01
        EQUB    $82,$01,$01,$01,$01,$01,$01,$01
        EQUB    $01,$01,$01,$01,$01,$01,$02,$01
        EQUB    $82
.RUTOK
        EQUB    $57,$C4,$14,$18,$B7,$19,$1E,$89
        EQUB    $04,$77,$1F,$12,$A5,$77,$1F,$16
        EQUB    $AD,$77,$01,$1E,$18,$1B,$A2,$AB
        EQUB    $55,$77,$A7,$03,$A3,$10,$B3,$16
        EQUB    $14,$AC,$14,$77,$14,$B7,$19,$94
        EQUB    $07,$05,$18,$03,$18,$14,$18,$1B
        EQUB    $5A,$E5,$04,$1F,$8E,$1B,$13,$77
        EQUB    $A0,$77,$16,$01,$18,$1E,$13,$AB
        EQUB    $57,$C4,$14,$88,$89,$05,$1E,$14
        EQUB    $03,$AA,$77,$9C,$A5,$BA,$A6,$BE
        EQUB    $7B,$77,$CD,$57,$16,$77,$25,$77
        EQUB    $B7,$18,$1C,$94,$98,$77,$B2,$11
        EQUB    $03,$77,$1F,$12,$A5,$87,$00,$1F
        EQUB    $1E,$B2,$77,$15,$16,$14,$1C,$79
        EQUB    $77,$1B,$18,$18,$1C,$93,$15,$8E
        EQUB    $19,$13,$77,$11,$AA,$77,$B9,$12
        EQUB    $B1,$57,$0E,$12,$07,$7B,$87,$25
        EQUB    $85,$98,$77,$1F,$16,$13,$87,$10
        EQUB    $B3,$16,$14,$AC,$14,$77,$1F,$0E
        EQUB    $07,$A3,$13,$05,$1E,$AD,$77,$11
        EQUB    $8C,$03,$93,$1F,$12,$A5,$79,$77
        EQUB    $BB,$93,$8C,$77,$03,$18,$18,$57
        EQUB    $C3,$77,$25,$77,$98,$77,$13,$12
        EQUB    $1F,$0E,$07,$93,$1F,$12,$A5,$77
        EQUB    $11,$05,$18,$1A,$77,$B4,$00,$1F
        EQUB    $12,$A5,$7B,$77,$04,$02,$19,$77
        EQUB    $04,$1C,$1E,$1A,$1A,$AB,$E5,$1D
        EQUB    $02,$1A,$07,$AB,$79,$77,$1E,$77
        EQUB    $1F,$12,$B9,$77,$8C,$77,$00,$A1
        EQUB    $03,$9E,$A7,$BD,$A0,$57,$24,$77
        EQUB    $98,$77,$00,$A1,$03,$77,$11,$AA
        EQUB    $77,$1A,$12,$77,$A2,$77,$16,$BB
        EQUB    $B9,$79,$77,$1A,$0E,$77,$AE,$04
        EQUB    $A3,$04,$77,$13,$1E,$13,$19,$70
        EQUB    $03,$77,$12,$01,$A1,$77,$04,$14
        EQUB    $AF,$03,$14,$1F,$77,$C4,$24,$57
        EQUB    $18,$1F,$77,$13,$12,$B9,$77,$1A
        EQUB    $12,$77,$0E,$BA,$79,$87,$11,$05
        EQUB    $1E,$10,$1F,$03,$11,$02,$1B,$77
        EQUB    $05,$18,$10,$02,$12,$77,$00,$1E
        EQUB    $B5,$77,$00,$1F,$A2,$77,$1E,$77
        EQUB    $A0,$1B,$1E,$12,$AD,$77,$E4,$77
        EQUB    $07,$12,$18,$07,$B2,$77,$14,$B3
        EQUB    $1B,$87,$B2,$16,$13,$77,$07,$18
        EQUB    $89,$A3,$1E,$AA,$77,$04,$1F,$18
        EQUB    $03,$77,$02,$07,$77,$B7,$03,$04
        EQUB    $77,$18,$11,$77,$B5,$18,$8D,$77
        EQUB    $A0,$16,$89,$1B,$0E,$77,$07,$1E
        EQUB    $AF,$03,$BA,$E5,$00,$A1,$03,$9E
        EQUB    $BB,$B2,$05,$1E,$57,$E4,$77,$14
        EQUB    $A8,$77,$03,$16,$14,$1C,$B2,$77
        EQUB    $C4,$3F,$77,$24,$77,$1E,$11,$77
        EQUB    $E4,$77,$1B,$1E,$1C,$12,$79,$77
        EQUB    $1F,$12,$70,$04,$77,$A2,$77,$AA
        EQUB    $B9,$AF,$57,$56,$14,$18,$1A,$94
        EQUB    $BC,$88,$6D,$77,$12,$1B,$8C,$12
        EQUB    $77,$1E,$1E,$57,$23,$57,$23,$57
        EQUB    $23,$57,$23,$57,$23,$57,$23,$57
        EQUB    $23,$57,$23,$57,$23,$57,$23,$57
        EQUB    $23,$57,$23,$57,$23,$57,$15,$18
        EQUB    $0E,$77,$16,$A5,$77,$E4,$77,$A7
        EQUB    $77,$C4,$00,$05,$88,$10,$77,$10
        EQUB    $B3,$16,$0F,$0E,$76,$57,$B5,$A3
        EQUB    $12,$70

.L5565
        EQUB    $04,$87,$A5,$B3,$77,$24,$77,$07
        EQUB    $1E,$AF,$03,$12,$77,$8E,$03,$77
        EQUB    $B5,$A3,$12,$57,$C4,$96,$04,$77
        EQUB    $18,$11,$77,$3A,$77,$16,$A5,$77
        EQUB    $BC,$77,$16,$B8,$0D,$A7,$10,$1B
        EQUB    $0E,$77,$07,$05,$1E,$1A,$1E,$AC
        EQUB    $AD,$77,$B5,$A2,$77,$B5,$12,$0E
        EQUB    $77,$89,$8B,$1B,$77,$B5,$A7,$1C
        EQUB    $77,$44,$16,$7D,$7D,$7D,$7D,$7D
        EQUB    $05,$9D,$16,$77,$07,$A5,$03,$03
        EQUB    $0E,$77,$19,$12,$A2,$77,$10,$16
        EQUB    $1A,$12,$57
.MTIN
        EQUB    $10,$15,$1A,$1F,$9B,$A0,$2E,$A5
        EQUB    $24,$29,$3D,$33,$38,$AA,$42,$47
        EQUB    $4C,$51,$56,$8C,$60,$65,$87,$82
        EQUB    $5B,$6A,$B4,$B9,$BE,$E1,$E6,$EB
        EQUB    $F0,$F5,$FA,$73,$78,$7D,$45,$4E
        EQUB    $44,$2D,$45,$4E,$44,$2D,$45,$4E
        EQUB    $44,$52,$50,$53,$00,$8E,$11,$D8
        EQUB    $00,$00,$06,$56,$52,$49

.L55FE
        EQUB    $45

.L55FF
        EQUB    $E6
.XX21
        EQUB    $00,$7F,$00,$00,$00,$00,$00,$00
        EQUB    $5D,$56,$00,$00,$00,$00,$00,$00
        EQUB    $05,$57,$37,$58,$19,$5A,$A1,$5B
        EQUB    $00,$00,$00,$00,$00,$00,$93,$5C
        EQUB    $00,$00,$00,$00,$6D,$5D,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$53,$5E
.E%
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $21,$61,$A0,$A0,$00,$00,$00,$C2
        EQUB    $00,$00,$8C,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$8C,$00
        EQUB    $90,$01,$50,$8C,$31,$00,$12,$3C
        EQUB    $0F,$00,$00,$1C,$0C,$11,$0F,$00
        EQUB    $00,$02,$00,$18,$10,$00,$1F,$10
        EQUB    $55,$18,$05,$0F,$1F,$10,$22,$18
        EQUB    $0D,$09,$5F,$20,$33,$18,$0D,$09
        EQUB    $7F,$30,$44,$18,$05,$0F,$3F,$40
        EQUB    $55,$18,$10,$00,$9F,$51,$66,$18
        EQUB    $05,$0F,$9F,$21,$66,$18,$0D,$09
        EQUB    $DF,$32,$66,$18,$0D,$09,$FF,$43
        EQUB    $66,$18,$05,$0F,$BF,$54,$66,$1F
        EQUB    $10,$00,$04,$1F,$20,$04,$08,$1F
        EQUB    $30,$08,$0C,$1F,$40,$0C,$10,$1F
        EQUB    $50,$00,$10,$1F,$51,$00,$14,$1F
        EQUB    $21,$04,$18,$1F,$32,$08,$1C,$1F
        EQUB    $43,$0C,$20,$1F,$54,$10,$24,$1F
        EQUB    $61,$14,$18,$1F,$62,$18,$1C,$1F
        EQUB    $63,$1C,$20,$1F,$64,$20,$24,$1F
        EQUB    $65,$24,$14,$1F,$60,$00,$00,$1F
        EQUB    $00,$29,$1E,$5F,$00,$12,$30,$5F
        EQUB    $00,$33,$00,$7F,$00,$12,$30,$3F
        EQUB    $00,$29,$1E,$9F,$60,$00,$00,$0F
        EQUB    $C4,$09,$86,$FE,$6D,$00,$26,$72
        EQUB    $1E,$00,$00,$34,$16,$20,$08,$00
        EQUB    $00,$02,$00,$00,$23,$2F,$5F,$FF
        EQUB    $FF,$23,$00,$2F,$9F,$FF,$FF,$00
        EQUB    $23,$2F,$1F,$FF,$FF,$23,$00,$2F
        EQUB    $1F,$FF,$FF,$28,$28,$35,$FF,$12
        EQUB    $39,$28,$28,$35,$BF,$34,$59,$28
        EQUB    $28,$35,$3F,$56,$79,$28,$28,$35
        EQUB    $7F,$17,$89,$0A,$00,$35,$30,$99
        EQUB    $99,$00,$05,$35,$70,$99,$99,$0A
        EQUB    $00,$35,$A8,$99,$99,$00,$05,$35
        EQUB    $28,$99,$99,$00,$11,$47,$50,$0A
        EQUB    $BC,$05,$02,$3D,$46,$FF,$02,$07
        EQUB    $17,$31,$07,$01,$F4,$15,$09,$31
        EQUB    $07,$A1,$3F,$05,$02,$3D,$C6,$6B
        EQUB    $23,$07,$17,$31,$87,$F8,$C0,$15
        EQUB    $09,$31,$87,$4F,$18,$1F,$02,$00
        EQUB    $04,$1F,$4A,$04,$08,$1F,$6B,$08
        EQUB    $0C,$1F,$8C,$00,$0C,$1F,$18,$00
        EQUB    $1C,$18,$12,$00,$10,$1F,$23,$04
        EQUB    $10,$18,$34,$04,$14,$1F,$45,$08
        EQUB    $14,$0C,$56,$08,$18,$1F,$67,$0C
        EQUB    $18,$18,$78,$0C,$1C,$1F,$39,$10
        EQUB    $14,$1F,$59,$14,$18,$1F,$79,$18
        EQUB    $1C,$1F,$19,$10,$1C,$10,$0C,$00
        EQUB    $30,$10,$0A,$04,$30,$10,$AB,$08
        EQUB    $30,$10,$BC,$0C,$30,$10,$99,$20
        EQUB    $24,$06,$99,$24,$28,$08,$99,$28
        EQUB    $2C,$06,$99,$20,$2C,$04,$BB,$34
        EQUB    $38,$07,$BB,$38,$3C,$06,$BB,$34
        EQUB    $3C,$04,$AA,$40,$44,$07,$AA,$44
        EQUB    $48,$06,$AA,$40,$48,$DF,$6E,$6E
        EQUB    $50,$5F,$00,$95,$07,$DF,$66,$66
        EQUB    $2E,$9F,$95,$00,$07,$9F,$66,$66
        EQUB    $2E,$1F,$00,$95,$07,$1F,$66,$66
        EQUB    $2E,$1F,$95,$00,$07,$5F,$66,$66
        EQUB    $2E,$3F,$00,$00,$D5,$9F,$51,$51
        EQUB    $B1,$1F,$51,$51,$B1,$5F,$6E,$6E
        EQUB    $50,$00,$C4,$09,$F2,$AA,$91,$30
        EQUB    $1A,$DE,$2E,$00,$00,$38,$10,$20
        EQUB    $0A,$00,$01,$01,$00,$00,$13,$33
        EQUB    $3F,$06,$77,$33,$07,$33,$BF,$01
        EQUB    $77,$39,$07,$33,$FF,$01,$22,$33
        EQUB    $11,$33,$FF,$02,$33,$33,$11,$33
        EQUB    $7F,$03,$44,$39,$07,$33,$7F,$04
        EQUB    $55,$33,$07,$33,$3F,$05,$66,$00
        EQUB    $0C,$18,$12,$FF,$FF,$3C,$02,$18
        EQUB    $DF,$17,$89,$42,$11,$18,$DF,$12
        EQUB    $39,$42,$11,$18,$5F,$34,$5A,$3C
        EQUB    $02,$18,$5F,$56,$AB,$16,$05,$3D
        EQUB    $DF,$89,$CD,$1B,$11,$3D,$DF,$39
        EQUB    $DD,$1B,$11,$3D,$5F,$3A,$DD,$16
        EQUB    $05,$3D,$5F,$AB,$CD,$0A,$0B,$05
        EQUB    $86,$77,$77,$24,$05,$05,$86,$77
        EQUB    $77,$0A,$0D,$0E,$A6,$77,$77,$24
        EQUB    $07,$0E,$A6,$77,$77,$17,$0C,$1D
        EQUB    $A6,$77,$77,$17,$0A,$0E,$A6,$77
        EQUB    $77,$0A,$0F,$1D,$26,$66,$66,$24
        EQUB    $09,$1D,$26,$66,$66,$17,$0A,$0E
        EQUB    $26,$66,$66,$0A,$0C,$06,$26,$66
        EQUB    $66,$24,$06,$06,$26,$66,$66,$17
        EQUB    $07,$10,$06,$66,$66,$17,$09,$06
        EQUB    $26,$66,$66,$21,$11,$1A,$E5,$33
        EQUB    $33,$21,$11,$21,$C5,$33,$33,$21
        EQUB    $11,$1A,$65,$33,$33,$21,$11,$21
        EQUB    $45,$33,$33,$19,$06,$33,$E7,$00
        EQUB    $00,$1A,$06,$33,$67,$00,$00,$11
        EQUB    $06,$33,$24,$00,$00,$11,$06,$33
        EQUB    $A4,$00,$00,$1F,$07,$00,$04,$1F
        EQUB    $01,$04,$08,$1F,$02,$08,$0C,$1F
        EQUB    $03,$0C,$10,$1F,$04,$10,$14,$1F
        EQUB    $05,$14,$18,$1F,$06,$00,$18,$0F
        EQUB    $67,$00,$1C,$1F,$17,$04,$20,$0A
        EQUB    $12,$08,$24,$1F,$23,$0C,$24,$1F
        EQUB    $34,$10,$28,$0A,$45,$14,$28,$1F
        EQUB    $56,$18,$2C,$10,$78,$1C,$20,$10
        EQUB    $19,$20,$24,$10,$5A,$28,$2C,$10
        EQUB    $6B,$1C,$2C,$12,$BC,$1C,$3C,$12
        EQUB    $8C,$1C,$30,$10,$89,$20,$30,$1F
        EQUB    $39,$24,$34,$1F,$3A,$28,$38,$10
        EQUB    $AB,$2C,$3C,$1F,$9D,$30,$34,$1F
        EQUB    $3D,$34,$38,$1F,$AD,$38,$3C,$1F
        EQUB    $CD,$30,$3C,$06,$77,$40,$44,$06
        EQUB    $77,$48,$4C,$06,$77,$4C,$50,$06
        EQUB    $77,$48,$50,$06,$77,$50,$54,$06
        EQUB    $66,$58,$5C,$06,$66,$5C,$60,$06
        EQUB    $66,$60,$58,$06,$66,$64,$68,$06
        EQUB    $66,$68,$6C,$06,$66,$64,$6C,$06
        EQUB    $66,$6C,$70,$05,$33,$74,$78,$05
        EQUB    $33,$7C,$80,$07,$00,$84,$88,$04
        EQUB    $00,$88,$8C,$04,$00,$8C,$90,$04
        EQUB    $00,$90,$84,$3F,$00,$00,$67,$BF
        EQUB    $6F,$30,$07,$FF,$69,$3F,$15,$5F
        EQUB    $00,$22,$00,$7F,$69,$3F,$15,$3F
        EQUB    $6F,$30,$07,$1F,$08,$20,$03,$9F
        EQUB    $08,$20,$03,$92,$08,$22,$0B,$9F
        EQUB    $4B,$20,$4F,$1F,$4B,$20,$4F,$12
        EQUB    $08,$22,$0B,$1F,$00,$26,$11,$1F
        EQUB    $00,$00,$79,$03,$41,$23,$BC,$54
        EQUB    $99,$54,$2A,$A8,$26,$00,$00,$34
        EQUB    $32,$96,$1C,$00,$01,$01,$13,$20
        EQUB    $00,$4C,$1F,$FF,$FF,$20,$00,$4C
        EQUB    $9F,$FF,$FF,$00,$1A,$18,$1F,$FF
        EQUB    $FF,$78,$03,$08,$FF,$73,$AA,$78
        EQUB    $03,$08,$7F,$84,$CC,$58,$10,$28
        EQUB    $BF,$FF,$FF,$58,$10,$28,$3F,$FF
        EQUB    $FF,$80,$08,$28,$7F,$98,$CC,$80
        EQUB    $08,$28,$FF,$97,$AA,$00,$1A,$28
        EQUB    $3F,$65,$99,$20,$18,$28,$FF,$A9
        EQUB    $BB,$20,$18,$28,$7F,$B9,$CC,$24
        EQUB    $08,$28,$B4,$99,$99,$08,$0C,$28
        EQUB    $B4,$99,$99,$08,$0C,$28,$34,$99
        EQUB    $99,$24,$08,$28,$34,$99,$99,$24
        EQUB    $0C,$28,$74,$99,$99,$08,$10,$28
        EQUB    $74,$99,$99,$08,$10,$28,$F4,$99
        EQUB    $99,$24,$0C,$28,$F4,$99,$99,$00
        EQUB    $00,$4C,$06,$B0,$BB,$00,$00,$5A
        EQUB    $1F,$B0,$BB,$50,$06,$28,$E8,$99
        EQUB    $99,$50,$06,$28,$A8,$99,$99,$58
        EQUB    $00,$28,$A6,$99,$99,$50,$06,$28
        EQUB    $28,$99,$99,$58,$00,$28,$26,$99
        EQUB    $99,$50,$06,$28,$68,$99,$99,$1F
        EQUB    $B0,$00,$04,$1F,$C4,$00,$10,$1F
        EQUB    $A3,$04,$0C,$1F,$A7,$0C,$20,$1F
        EQUB    $C8,$10,$1C,$1F,$98,$18,$1C,$1F
        EQUB    $96,$18,$24,$1F,$95,$14,$24,$1F
        EQUB    $97,$14,$20,$1F,$51,$08,$14,$1F
        EQUB    $62,$08,$18,$1F,$73,$0C,$14,$1F
        EQUB    $84,$10,$18,$1F,$10,$04,$08,$1F
        EQUB    $20,$00,$08,$1F,$A9,$20,$28,$1F
        EQUB    $B9,$28,$2C,$1F,$C9,$1C,$2C,$1F
        EQUB    $BA,$04,$28,$1F,$CB,$00,$2C,$1D
        EQUB    $31,$04,$14,$1D,$42,$00,$18,$06
        EQUB    $B0,$50,$54,$14,$99,$30,$34,$14
        EQUB    $99,$48,$4C,$14,$99,$38,$3C,$14
        EQUB    $99,$40,$44,$13,$99,$3C,$40,$11
        EQUB    $99,$38,$44,$13,$99,$34,$48,$13
        EQUB    $99,$30,$4C,$1E,$65,$08,$24,$06
        EQUB    $99,$58,$60,$06,$99,$5C,$60,$08
        EQUB    $99,$58,$5C,$06,$99,$64,$68,$06
        EQUB    $99,$68,$6C,$08,$99,$64,$6C,$1F
        EQUB    $00,$3E,$1F,$9F,$12,$37,$10,$1F
        EQUB    $12,$37,$10,$9F,$10,$34,$0E,$1F
        EQUB    $10,$34,$0E,$9F,$0E,$2F,$00,$1F
        EQUB    $0E,$2F,$00,$9F,$3D,$66,$00,$1F
        EQUB    $3D,$66,$00,$3F,$00,$00,$50,$DF
        EQUB    $07,$2A,$09,$5F,$00,$1E,$06,$5F
        EQUB    $07,$2A,$09,$05,$00,$19,$56,$BE
        EQUB    $55,$00,$2A,$42,$1A,$00,$00,$34
        EQUB    $28,$FA,$14,$00,$00,$00,$1B,$00
        EQUB    $00,$E0,$1F,$10,$32,$00,$30,$30
        EQUB    $1E,$10,$54,$60,$00,$10,$3F,$FF
        EQUB    $FF,$60,$00,$10,$BF,$FF,$FF,$00
        EQUB    $30,$20,$3E,$54,$98,$00,$18,$70
        EQUB    $3F,$89,$CC,$30,$00,$70,$BF,$B8
        EQUB    $CC,$30,$00,$70,$3F,$A9,$CC,$00
        EQUB    $30,$30,$5E,$32,$76,$00,$30,$20
        EQUB    $7E,$76,$BA,$00,$18,$70,$7E,$BA
        EQUB    $CC,$1E,$32,$00,$20,$1F,$20,$00
        EQUB    $0C,$1F,$31,$00,$08,$1E,$10,$00
        EQUB    $04,$1D,$59,$08,$10,$1D,$51,$04
        EQUB    $08,$1D,$37,$08,$20,$1D,$40,$04
        EQUB    $0C,$1D,$62,$0C,$20,$1D,$A7,$08
        EQUB    $24,$1D,$84,$0C,$10,$1D,$B6,$0C
        EQUB    $24,$05,$88,$0C,$14,$05,$BB,$0C
        EQUB    $28,$05,$99,$08,$14,$05,$AA,$08
        EQUB    $28,$1F,$A9,$08,$1C,$1F,$B8,$0C
        EQUB    $18,$1F,$C8,$14,$18,$1F,$C9,$14
        EQUB    $1C,$1D,$AC,$1C,$28,$1D,$CB,$18
        EQUB    $28,$1D,$98,$10,$14,$1D,$BA,$24
        EQUB    $28,$1D,$54,$04,$10,$1D,$76,$20
        EQUB    $24,$9E,$1B,$28,$0B,$1E,$1B,$28
        EQUB    $0B,$DE,$1B,$28,$0B,$5E,$1B,$28
        EQUB    $0B,$9E,$13,$26,$00,$1E,$13,$26
        EQUB    $00,$DE,$13,$26,$00,$5E,$13,$26
        EQUB    $00,$BE,$19,$25,$0B,$3E,$19,$25
        EQUB    $0B,$7E,$19,$25,$0B,$FE,$19,$25
        EQUB    $0B,$3E,$00,$00,$70,$00,$F9,$15
        EQUB    $6E,$BE,$4D,$00,$2A,$5A,$14,$00
        EQUB    $00,$1C,$17,$64,$20,$00,$00,$01
        EQUB    $11,$00,$00,$48,$1F,$21,$43,$00
        EQUB    $10,$18,$1E,$10,$22,$00,$10,$18
        EQUB    $5E,$43,$55,$30,$00,$18,$3F,$42
        EQUB    $66,$30,$00,$18,$BF,$31,$66,$18
        EQUB    $10,$18,$7E,$54,$66,$18,$10,$18
        EQUB    $FE,$35,$66,$18,$10,$18,$3F,$20
        EQUB    $66,$18,$10,$18,$BF,$10,$66,$20
        EQUB    $00,$18,$B3,$66,$66,$20,$00,$18
        EQUB    $33,$66,$66,$08,$08,$18,$33,$66
        EQUB    $66,$08,$08,$18,$B3,$66,$66,$08
        EQUB    $08,$18,$F2,$66,$66,$08,$08,$18
        EQUB    $72,$66,$66,$1F,$42,$00,$0C,$1E
        EQUB    $21,$00,$04,$1E,$43,$00,$08,$1F
        EQUB    $31,$00,$10,$1E,$20,$04,$1C,$1E
        EQUB    $10,$04,$20,$1E,$54,$08,$14,$1E
        EQUB    $53,$08,$18,$1F,$60,$1C,$20,$1E
        EQUB    $65,$14,$18,$1F,$61,$10,$20,$1E
        EQUB    $63,$10,$18,$1F,$62,$0C,$1C,$1E
        EQUB    $46,$0C,$14,$13,$66,$24,$30,$12
        EQUB    $66,$24,$34,$13,$66,$28,$2C,$12
        EQUB    $66,$28,$38,$10,$66,$2C,$38,$10
        EQUB    $66,$30,$34,$1F,$00,$20,$00,$9F
        EQUB    $16,$21,$0B,$1F,$16,$21,$0B,$DF
        EQUB    $16,$21,$0B,$5F,$16,$21,$0B,$5F
        EQUB    $00,$20,$00,$3F,$00,$00,$30,$01
        EQUB    $10,$0E,$7A,$CE,$55,$00,$12,$66
        EQUB    $15,$64,$00,$18,$14,$50,$1E,$00
        EQUB    $00,$02,$10,$00,$00,$60,$1F,$01
        EQUB    $23,$00,$12,$30,$3F,$03,$45,$00
        EQUB    $12,$30,$7F,$12,$45,$5A,$00,$03
        EQUB    $3F,$01,$44,$5A,$00,$03,$BF,$23
        EQUB    $55,$5A,$00,$57,$1C,$01,$11,$5A
        EQUB    $00,$57,$9C,$23,$33,$00,$05,$35
        EQUB    $09,$00,$33,$00,$07,$26,$06,$00
        EQUB    $33,$12,$07,$13,$89,$33,$33,$12
        EQUB    $07,$13,$09,$00,$00,$12,$0B,$27
        EQUB    $28,$44,$44,$12,$0B,$27,$68,$44
        EQUB    $44,$24,$00,$1E,$28,$44,$44,$12
        EQUB    $0B,$27,$A8,$55,$55,$12,$0B,$27
        EQUB    $E8,$55,$55,$24,$00,$1E,$A8,$55
        EQUB    $55,$1F,$03,$00,$04,$1F,$12,$00
        EQUB    $08,$1F,$01,$00,$0C,$1F,$23,$00
        EQUB    $10,$1F,$35,$04,$10,$1F,$25,$10
        EQUB    $08,$1F,$14,$08,$0C,$1F,$04,$0C
        EQUB    $04,$1C,$01,$0C,$14,$1C,$23,$10
        EQUB    $18,$05,$45,$04,$08,$09,$00,$1C
        EQUB    $28,$06,$00,$20,$28,$09,$33,$1C
        EQUB    $24,$06,$33,$20,$24,$08,$44,$2C
        EQUB    $34,$08,$44,$34,$30,$07,$44,$30
        EQUB    $2C,$07,$55,$38,$3C,$08,$55,$3C
        EQUB    $40,$08,$55,$40,$38,$1F,$07,$30
        EQUB    $06,$5F,$07,$30,$06,$DF,$07,$30
        EQUB    $06,$9F,$07,$30,$06,$3F,$4D,$00
        EQUB    $9A,$BF,$4D,$00,$9A,$F3,$49,$26
        EQUB    $7A,$DA,$4D,$00,$2E,$66,$18,$00
        EQUB    $00,$28,$2D,$C8,$37,$00,$00,$02
        EQUB    $2F,$14,$07,$50,$5F,$02,$99,$14
        EQUB    $07,$50,$DF,$01,$99,$36,$07,$28
        EQUB    $DF,$14,$99,$36,$07,$28,$FF,$45
        EQUB    $89,$14,$0D,$28,$BF,$56,$88,$14
        EQUB    $0D,$28,$3F,$67,$88,$36,$07,$28
        EQUB    $7F,$37,$89,$36,$07,$28,$5F,$23
        EQUB    $99,$14,$0D,$05,$1F,$FF,$FF,$14
        EQUB    $0D,$05,$9F,$FF,$FF,$14,$07,$3E
        EQUB    $52,$99,$99,$14,$07,$3E,$D2,$99
        EQUB    $99,$19,$07,$19,$72,$99,$99,$19
        EQUB    $07,$19,$F2,$99,$99,$0F,$07,$0F
        EQUB    $6A,$99,$99,$0F,$07,$0F,$EA,$99
        EQUB    $99,$00,$07,$00,$40,$9F,$01,$1F
        EQUB    $09,$00,$04,$1F,$19,$04,$08,$1F
        EQUB    $01,$04,$24,$1F,$02,$00,$20,$1F
        EQUB    $29,$00,$1C,$1F,$23,$1C,$20,$1F
        EQUB    $14,$08,$24,$1F,$49,$08,$0C,$1F
        EQUB    $39,$18,$1C,$1F,$37,$18,$20,$1F
        EQUB    $67,$14,$20,$1F,$56,$10,$24,$1F
        EQUB    $45,$0C,$24,$1F,$58,$0C,$10,$1F
        EQUB    $68,$10,$14,$1F,$78,$14,$18,$1F
        EQUB    $89,$0C,$18,$1F,$06,$20,$24,$12
        EQUB    $99,$28,$30,$05,$99,$30,$38,$0A
        EQUB    $99,$38,$28,$0A,$99,$2C,$3C,$05
        EQUB    $99,$34,$3C,$12,$99,$2C,$34,$1F
        EQUB    $00,$37,$0F,$9F,$18,$4B,$14,$1F
        EQUB    $18,$4B,$14,$1F,$2C,$4B,$00,$9F
        EQUB    $2C,$4B,$00,$9F,$2C,$4B,$00,$1F
        EQUB    $00,$35,$00,$1F,$2C,$4B,$00,$3F
        EQUB    $00,$00,$A0,$5F,$00,$1B,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$00,$00,$00
        EQUB    $00,$00




SAVE "versions/disc/output/T.CODE.unprot.bin", CODE%, P%

