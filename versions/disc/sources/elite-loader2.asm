L0001   = $0001
L0002   = $0002
USERV   = $0200
BRKV    = $0202
IRQ1V   = $0204
IRQ2V   = $0206
CLIV    = $0208
BYTEV   = $020A
L020B   = $020B
WORDV   = $020C
WRCHV   = $020E
RDCHV   = $0210
FILEV   = $0212
ARGSV   = $0214
BGETV   = $0216
BPUTV   = $0218
GBPBV   = $021A
FINDV   = $021C
FSCV    = $021E
EVENTV  = $0220
UPTV    = $0222
NETV    = $0224
VDUV    = $0226
KEYV    = $0228
INSV    = $022A
REMV    = $022C
CNPV    = $022E
INDV1   = $0230
INDV2   = $0232
INDV3   = $0234
L5700   = $5700
LD941   = $D941
VIA     = $FE00
OSWRSC  = $FFB3
LFFB6   = $FFB6
LFFB7   = $FFB7
LFFB8   = $FFB8
OSRDSC  = $FFB9
OSEVEN  = $FFBF
GSINIT  = $FFC2
GSREAD  = $FFC5
NVRDCH  = $FFC8
NNWRCH  = $FFCB
OSFIND  = $FFCE
OSGBPB  = $FFD1
OSBPUT  = $FFD4
OSBGET  = $FFD7
OSARGS  = $FFDA
OSFILE  = $FFDD
OSRDCH  = $FFE0
OSASCI  = $FFE3
OSNEWL  = $FFE7
OSWRCH  = $FFEE
OSWORD  = $FFF1
OSBYTE  = $FFF4
OSCLI   = $FFF7

        org     $2F00
.BeebDisStartAddr
        JMP     L2F23

.L2F03
        LDA     BeebDisStartAddr
L2F04 = L2F03+1
.L2F06
        EOR     BeebDisStartAddr,X
        STA     BeebDisStartAddr,X
        INX
        BNE     L2F06

.L2F0F
        INC     L2F04
        BEQ     L2F1E

        LDA     L2F04
        CMP     #$1E
        BEQ     L2F0F

        JMP     BeebDisStartAddr

.L2F1E
        BIT     L020B
        BPL     BeebDisStartAddr

.L2F23
        LDA     #$00
        LDX     #$01
        JSR     OSBYTE

        LDY     #$00
        SEI
        CPX     #$01
        BEQ     L2F3E

.L2F31
        LDA     LD941,Y
        STA     USERV
        INY
        CPY     #$36
        BNE     L2F31

        BEQ     L2F53

.L2F3E
        LDA     LFFB7
        STA     L0001
        LDA     LFFB8
        STA     L0002
.L2F48
        LDA     (L0001),Y
        STA     USERV,Y
        INY
        CPY     LFFB6
        BNE     L2F48

.L2F53
        CLI
        LDX     #$F0
        LDY     #$2F
        JSR     OSCLI

        LDA     #$C9
        LDX     #$01
        LDY     #$00
        JSR     OSBYTE

        LDA     #$C8
        LDX     #$00
        LDY     #$00
        JSR     OSBYTE

        LDA     #$77
        JSR     OSBYTE

        LDY     #$00
.L2F74
        LDA     L2FF5,Y
        NOP
        INY
        CPY     #$09
        BNE     L2F74

        LDY     #$00
.L2F7F
        LDA     L2FC4,Y
        JSR     OSWRCH

        INY
        CPY     #$0C
        BNE     L2F7F

.L2F8A
        LDX     #$98
        LDY     #$2F
        JSR     OSCLI

        JMP     L5700

        NOP
        NOP
        NOP
        NOP
.L2F98
        EQUS    "LOAD Elite3"

        EQUB    $0D

.L2FA4
        JSR     L2FB8

        JMP     L2F8A

        LDA     #$02
        STA     L2FEE
        LDA     #$7F
        LDX     #$E6
        LDY     #$2F
        JMP     OSWORD

.L2FB8
        STA     L2FE4
        LDA     #$7F
        LDX     #$DD
        LDY     #$2F
        JMP     OSWORD

.L2FC4
        EQUB    $16

        EQUB    $07,$17,$00,$0A,$20,$00,$00,$00
        EQUB    $00,$00,$00,$00,$00,$FF,$00,$57
        EQUB    $FF,$FF,$03,$53,$26,$F6,$29,$00

        EQUB    $FF,$FF,$FF,$FF,$FF,$01,$69

.L2FE4
        EQUB    $02,$00

        EQUB    $FF,$FF,$FF,$FF,$FF,$02,$7A,$12

.L2FEE
        EQUB    $26,$00

.L2FF0
        EQUS    "DISK"

        EQUB    $0D

.L2FF5
        EQUB    $19,$7A,$02,$01,$EC,$19,$00,$56
        EQUB    $FF,$00,$00

.BeebDisEndAddr

SAVE "versions/disc/output/ELITE2.bin",BeebDisStartAddr,BeebDisEndAddr

