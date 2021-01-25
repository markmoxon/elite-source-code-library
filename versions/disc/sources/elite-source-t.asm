\ ******************************************************************************
\
\ DISC ELITE DOCKED SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/T.CODE.unprot.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = TRUE
_DISC_FLIGHT            = FALSE


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
OSCLI = &FFF7           \ The address for the OSCLI routine

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

NRU% = 25               \ The number of planetary systems with special extended
                        \ descriptions in the RUTOK table

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
NA% = &1181
CHK2 = &11D3
CHK = &11D4

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
INCLUDE "library/common/main/subroutine/mveit_part_1_of_9.asm"

\ MVEIT Parts 2 to 6 not required when docked

INCLUDE "library/common/main/subroutine/mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine/mvt1.asm"
INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"
INCLUDE "library/common/main/subroutine/mvt6.asm"
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

.FLKB
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
INCLUDE "library/common/main/variable/prxs.asm"
INCLUDE "library/common/main/subroutine/status.asm"
INCLUDE "library/common/main/subroutine/plf2.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/6502sp/main/variable/dtw1.asm"
INCLUDE "library/6502sp/main/variable/dtw2.asm"
INCLUDE "library/6502sp/main/variable/dtw3.asm"
INCLUDE "library/6502sp/main/variable/dtw4.asm"
INCLUDE "library/6502sp/main/variable/dtw5.asm"
INCLUDE "library/6502sp/main/variable/dtw6.asm"
INCLUDE "library/6502sp/main/variable/dtw8.asm"
INCLUDE "library/6502sp/main/subroutine/feed.asm"
INCLUDE "library/6502sp/main/subroutine/mt16.asm"
INCLUDE "library/6502sp/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/6502sp/main/subroutine/hme2.asm"
INCLUDE "library/6502sp/main/variable/hatb.asm"
INCLUDE "library/6502sp/main/subroutine/hall.asm"
INCLUDE "library/6502sp/io/subroutine/hanger.asm"
INCLUDE "library/6502sp/main/subroutine/has1.asm"
INCLUDE "library/6502sp/io/subroutine/has2.asm"
INCLUDE "library/6502sp/io/subroutine/has3.asm"
INCLUDE "library/6502sp/main/subroutine/unwise.asm"
INCLUDE "library/common/main/subroutine/ll164.asm"
INCLUDE "library/common/main/subroutine/laun.asm"
INCLUDE "library/common/main/subroutine/hfs2.asm"

\ Junk?

        EQUB    $8C,$E7,$8D,$ED,$8A,$E6,$C1,$C8
        EQUB    $C8,$8B,$E0,$8A,$E6,$D6,$C5,$C6
        EQUB    $C1,$CA,$95,$9D,$9C,$97

INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"

\ Start of .MLS1?

        LDX     ALP1
        STX     P

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
INCLUDE "library/6502sp/main/subroutine/pdesc.asm"
INCLUDE "library/6502sp/main/subroutine/brief2.asm"
INCLUDE "library/6502sp/main/subroutine/brp.asm"
INCLUDE "library/6502sp/main/subroutine/brief3.asm"
INCLUDE "library/6502sp/main/subroutine/debrief2.asm"
INCLUDE "library/6502sp/main/subroutine/debrief.asm"
INCLUDE "library/6502sp/main/subroutine/brief.asm"
INCLUDE "library/6502sp/main/subroutine/bris.asm"
INCLUDE "library/6502sp/main/subroutine/pause.asm"
INCLUDE "library/6502sp/main/subroutine/mt23.asm"
INCLUDE "library/6502sp/main/subroutine/mt29.asm"
INCLUDE "library/6502sp/main/subroutine/pas1.asm"
INCLUDE "library/6502sp/main/subroutine/pause2.asm"
INCLUDE "library/common/main/subroutine/sight.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/delay.asm"
INCLUDE "library/cassette/main/subroutine/clyns.asm"
INCLUDE "library/cassette/main/subroutine/lyn.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/common/main/subroutine/tt20.asm"
INCLUDE "library/common/main/subroutine/tt54.asm"
INCLUDE "library/common/main/subroutine/tt146.asm"
INCLUDE "library/common/main/subroutine/tt60.asm"
INCLUDE "library/common/main/subroutine/ttx69.asm"
INCLUDE "library/common/main/subroutine/tt69.asm"
INCLUDE "library/common/main/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt70.asm"
INCLUDE "library/common/main/subroutine/spc.asm"
INCLUDE "library/common/main/subroutine/tt25.asm"
INCLUDE "library/common/main/subroutine/tt24.asm"
INCLUDE "library/common/main/subroutine/tt22.asm"
INCLUDE "library/common/main/subroutine/tt15.asm"
INCLUDE "library/common/main/subroutine/tt14.asm"
INCLUDE "library/common/main/subroutine/tt128.asm"
INCLUDE "library/common/main/subroutine/tt219.asm"
INCLUDE "library/common/main/subroutine/gnum.asm"
INCLUDE "library/6502sp/main/subroutine/nwdav4.asm"
INCLUDE "library/common/main/subroutine/tt208.asm"
INCLUDE "library/common/main/subroutine/tt210.asm"
INCLUDE "library/common/main/subroutine/tt213.asm"
INCLUDE "library/common/main/subroutine/tt214.asm"
INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"
INCLUDE "library/common/main/subroutine/tt23.asm"
INCLUDE "library/common/main/subroutine/tt81.asm"
INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"

.TTC111
        JSR     TT111

        JMP     TTX111

INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/jmp.asm"
INCLUDE "library/common/main/subroutine/ee3.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"
INCLUDE "library/common/main/subroutine/prq.asm"
INCLUDE "library/common/main/subroutine/tt151.asm"
INCLUDE "library/common/main/subroutine/tt152.asm"
INCLUDE "library/common/main/subroutine/tt162.asm"
INCLUDE "library/common/main/subroutine/tt160.asm"
INCLUDE "library/common/main/subroutine/tt161.asm"
INCLUDE "library/common/main/subroutine/tt16a.asm"
INCLUDE "library/common/main/subroutine/tt163.asm"
INCLUDE "library/common/main/subroutine/tt167.asm"
INCLUDE "library/common/main/subroutine/var.asm"
INCLUDE "library/common/main/subroutine/hyp1.asm"


\ Start loading Flight code as key #f0 hit

.TT110
        LDX     #$3F
.L2E94
        LDA     QQ16,X
        STA     QQ16_FLIGHT,X
        DEX
        BPL     &2E94

        JSR     &0D7A

        LDX     #$FC
        LDY     #$2E
        JMP     OSCLI

INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"

.RDLI
.L2EFC
        EQUS    "R.D.CODE"

        EQUB    $0D

INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
INCLUDE "library/common/main/subroutine/hm.asm"

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

INCLUDE "library/6502sp/main/subroutine/refund.asm"
INCLUDE "library/common/main/subroutine/cpl.asm"
INCLUDE "library/common/main/subroutine/cmn.asm"
INCLUDE "library/common/main/subroutine/ypl.asm"
INCLUDE "library/common/main/subroutine/tal.asm"
INCLUDE "library/common/main/subroutine/fwl.asm"
INCLUDE "library/common/main/subroutine/csh.asm"
INCLUDE "library/common/main/subroutine/plf.asm"
INCLUDE "library/common/main/subroutine/tt68.asm"
INCLUDE "library/common/main/subroutine/tt73.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/crlf.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt46.asm"
INCLUDE "library/common/main/subroutine/tt74.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"


.EX2
        LDA     INWK+31
        ORA     #$A0
        STA     INWK+31
        RTS

.L3282
        RTS

INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/cassette/main/subroutine/spblb.asm"
INCLUDE "library/cassette/main/subroutine/bulb.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"


\ Last bit of WPLS2 - split out? is it used?

.WP1
        LDA     #$01
        STA     LSP
        LDA     #$FF
        STA     LSX2
        RTS

INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/tt17.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/common/main/variable/sfx.asm"
INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/ze.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"

\ No main game loop 1

INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"

\ No main game loop 3, 4

INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/common/main/subroutine/bad.asm"
INCLUDE "library/6502sp/main/variable/brkd.asm"
INCLUDE "library/6502sp/main/subroutine/brbr.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/6502sp/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
INCLUDE "library/cassette/main/subroutine/br1.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/6502sp/main/subroutine/dfault.asm"
INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/check.asm"
INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/6502sp/main/subroutine/gtnmew.asm"
INCLUDE "library/6502sp/main/subroutine/mt26.asm"
INCLUDE "library/6502sp/main/variable/rline.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/6502sp/main/subroutine/zebc.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/6502sp/main/variable/ctli.asm"
INCLUDE "library/6502sp/main/variable/deli.asm"
INCLUDE "library/6502sp/main/subroutine/cats.asm"
INCLUDE "library/6502sp/main/subroutine/delt.asm"
INCLUDE "library/6502sp/main/variable/stack.asm"
INCLUDE "library/6502sp/main/subroutine/mebrk.asm"
INCLUDE "library/6502sp/main/subroutine/cat.asm"
INCLUDE "library/6502sp/main/subroutine/retry.asm"
INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/common/main/subroutine/qus1.asm"
INCLUDE "library/6502sp/main/subroutine/gtdrv.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/common/main/subroutine/fx200.asm"

\?
        JSR     GTNME

        RTS

INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/cassette/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/cassette/main/subroutine/dks4.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dkj1.asm"

\ Very different DOKEY

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

INCLUDE "library/common/main/subroutine/dk4.asm"


.DK9
        STA     BSTK
        BEQ     DK4


INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"


.TI2
.L3DEA
        TYA
        LDY     #$02
        JSR     TIS3

        STA     INWK+20
        JMP     TI3

.TI1
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
.TIL1
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
.TIL2
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

.TI4
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
.DVIDT
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
.DVL2
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
.nono
.L3F23
        LDA     #$F7
        AND     INWK+31
        STA     INWK+31
        RTS

.Shpt
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
.LL6
.L3F4C
        CPX     Q
        BCC     &3F5E

        BNE     &3F56

        CPY     #$40
        BCC     &3F5E

.LL8
.L3F56
        TYA
        SBC     #$40
        TAY
        TXA
        SBC     Q
        TAX
.LL7
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
.LL31
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

.LL29
.L3F8B
        SBC     Q
        SEC
        ROL     R
        BCS     &3F7D

        RTS

.LL2
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

.LL39
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
.ll51
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
.EE55
.L403C
        INY
        JSR     DORND

        STA     (INWK+33),Y
        CPY     #$06
        BNE     &403C
.EE28
.L4046
        LDA     INWK+8
.EE49
        BPL     &4067
.LL14
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

.LL10
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
.LL13
.L40AA
        LDY     #$0D
        LDA     (XX0),Y
        CMP     INWK+7
        BCS     &40BB

        LDA     #$20
        AND     INWK+31
        BNE     &40BB

        JMP     SHPPT

.LL17
.L40BB
        LDX     #$05
.LL15
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
.LL21
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
.ll91
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
.EE30
.L4101
        STA     K3,X
        DEX
        BPL     &4101

        INX
        STX     XX4
.LL41
.L4109
        JMP     LL42

.EE29
.L410C
        LDA     (XX0),Y
        BEQ     &4109

        STA     XX20
        LDY     #$12
        LDA     (XX0),Y
        TAX
        LDA     K6+3
.LL90
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

.LL91
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

.LL87
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

.LL143
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

.ovflw
.L41C4
        LSR     K5
        LSR     K6+2
        LSR     QQ19+2
        LDX     #$01
.LL92
.L41CC
        LDA     XX12
        STA     XX15
        LDA     XX12+2
        STA     X2
        LDA     XX12+4
.LL93
        DEX
        BMI     &41E1

.L41D9
        LSR     XX15
        LSR     X2
        LSR     A
        DEX
        BPL     &41D9

.LL94
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

.LL49
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

.LL52
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

.LL54
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
.LL63
.L43B1
        LSR     A
        INX
        CMP     Q
        BCS     &43B1

        STX     S
        JSR     LL28

        LDX     S
        LDA     R
.LL64
.L43C0
        ASL     A
        ROL     U
        BMI     &43CB

        DEX
        BNE     &43C0

        STA     R
        RTS

.LL84
.L43CB
        LDA     #$32
        STA     R
        STA     U
        RTS

.LL62
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

.LL56
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

.LL140
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

.LL60
.L441B
        LDA     T
        STA     Q
        LDA     XX15
        CMP     Q
        BCC     &442B

        JSR     LL61

        JMP     LL65

.LL69
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

.LL70
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

.LL67
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

.LL72
.L449C
        LDA     INWK+31
        AND     #$20
        BEQ     &44AB

        LDA     INWK+31
        ORA     #$08
        STA     INWK+31
        JMP     &3282

.EE31
.L44AB
        LDA     #$08
        BIT     INWK+31
        BEQ     &44B6

        JSR     LL155

        LDA     #$08
.LL74
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
        
.LL170
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

.LLx78
.L4557
        JMP     LL78

.LL79
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
.LL107
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

.LL109
.L45C6
        SEC
        RTS

.LL108
.L45C8
        LSR     XX13
.LL83
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

.LL115
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
        
.LL110
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

.LL112
.L4644
        LSR     A
        ROR     XX12+2
        LSR     XX12+5
        ROR     XX12+4
        JMP     LL111

.LL113
.L464E
        STX     T
        LDA     XX12+2
        CMP     XX12+4
        BCC     &4660

        STA     Q
        LDA     XX12+4
        JSR     LL28

        JMP     LL116

.LL114
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

.LL138
.L4679
        JSR     LL118

        LDA     XX13
        BPL     &46B1

.LL117
        LDA     Y1
        ORA     Y2
        BNE     &46B6

        LDA     X2
        CMP     #$C0
        BCS     &46B6

.LLX117
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
.LL124
.L46B1
        PLA
        TAY
        JMP     LL146

.LL137
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
.ll81
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
.LL27
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
.LL119
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
.LL134
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
.LL135
.L476E
        LDA     X2
        SEC
        SBC     #$C0
        STA     R
        LDA     Y2
        SBC     #$00
        STA     S
        BCC     &4793

.LL139
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
.LL136
.L4793
        RTS

.LL120
        LDA     XX15
        STA     R
        JSR     LL129

        PHA
        LDX     T
        BNE     &47CB
.LL122
.L47A0
        LDA     #$00
        TAX
        TAY
        LSR     S
        ROR     R
        ASL     Q
        BCC     &47B5

.LL125
.L47AC
        TXA
        CLC
        ADC     R
        TAX
        TYA
        ADC     S
        TAY
.LL126
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
.LL121
.L47CB
        LDA     #$FF
        TAY
        ASL     A
        TAX
.LL130
.L47D0
        ASL     R
        ROL     S
        LDA     S
        BCS     &47DC

        CMP     Q
        BCC     &47E7

.LL131
.L47DC
        SBC     Q
        STA     S
        LDA     R
        SBC     #$00
        STA     R
        SEC
.LL132
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

.LL133
.L47F2
        TXA
        EOR     #$FF
        ADC     #$01
        TAX
        TYA
        EOR     #$FF
        ADC     #$00
        TAY
.LL128
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
.LL127
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

        EQUB    $57
.RUPLA
        EQUB    $D3,$96,$24,$1C,$FD,$4F,$35,$76
        EQUB    $64,$20,$44,$A4,$DC,$6A,$10,$A2
        EQUB    $03,$6B,$1A,$C0,$B8,$05,$65,$C1

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
        EQUB    $F0,$F5,$FA,$73,$78,$7D
        
        EQUB    $45,$4E
        EQUB    $44,$2D,$45,$4E,$44,$2D,$45,$4E
        EQUB    $44,$52,$50,$53,$00,$8E,$11,$D8
        EQUB    $00,$00,$06,$56,$52,$49

.L55FE
        EQUB    $45

.L55FF
        EQUB    $E6

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"

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
        EQUB    $00,$00,$00,$00,$00,$00,$8C

INCLUDE "library/common/main/variable/ship_canister.asm"

        
\ Shuttle
        EQUB $0F
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
        EQUB    $50
        
\ Transporter
        EQUB $00,$C4,$09,$F2,$AA,$91,$30
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
        EQUB    $00,$00,$79
        
\ Cobra Mk III
        EQUB $03,$41,$23,$BC,$54
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
        EQUB    $07,$2A,$09
        
\ Python
        EQUB $05,$00,$19,$56,$BE
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
        EQUB    $0B,$3E,$00,$00,$70
        
INCLUDE "library/common/main/variable/ship_viper.asm"

        
\ Krait
        EQUB $01
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
        EQUB    $9A,$BF,$4D,$00,$9A
        
\ Constrictor
        EQUB $F3,$49,$26
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
        EQUB    $00,$00,$A0,$5F,$00,$1B,$00
        
\ End
        EQUB    $00
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

