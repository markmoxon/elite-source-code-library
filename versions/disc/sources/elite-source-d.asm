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

INCLUDE "library/6502sp/main/subroutine/tnpr1.asm"
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
INCLUDE "library/common/main/subroutine/tt210.asm"
INCLUDE "library/common/main/subroutine/tt213.asm"
INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"
INCLUDE "library/common/main/subroutine/tt23.asm"
INCLUDE "library/common/main/subroutine/tt81.asm"
INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/jmp.asm"
INCLUDE "library/common/main/subroutine/ee3.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"
INCLUDE "library/common/main/subroutine/prq.asm"

.TTH111
        JSR     TT111

        JMP     TTX111

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
INCLUDE "library/common/main/subroutine/gvl.asm"
INCLUDE "library/common/main/subroutine/gthg.asm"
INCLUDE "library/common/main/subroutine/mjp.asm"
INCLUDE "library/common/main/subroutine/tt18.asm"
INCLUDE "library/common/main/subroutine/tt110.asm"
INCLUDE "library/common/main/subroutine/tt114.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"
INCLUDE "library/common/main/subroutine/hm.asm"
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
INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"
INCLUDE "library/common/main/subroutine/det1-dodials.asm"
INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/sps4.asm"
INCLUDE "library/common/main/subroutine/sp1.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/cassette/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/cassette/main/subroutine/ecblb.asm"
INCLUDE "library/cassette/main/subroutine/spblb.asm"
INCLUDE "library/cassette/main/subroutine/bulb.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
INCLUDE "library/common/main/subroutine/proj.asm"
INCLUDE "library/common/main/subroutine/pl2.asm"
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
INCLUDE "library/cassette/main/subroutine/wpls2.asm"
INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"
INCLUDE "library/common/main/subroutine/tt17.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"
INCLUDE "library/common/main/subroutine/killshp.asm"
INCLUDE "library/common/main/variable/sfx.asm"
INCLUDE "library/6502sp/main/subroutine/there.asm"
INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"


        JSR     Uperc

INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/ze.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"


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
        BEQ     me2

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
        LDA     SFX,Y
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

.QQ23
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
        JSR     CPIX4

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
