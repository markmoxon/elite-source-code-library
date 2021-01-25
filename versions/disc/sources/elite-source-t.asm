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

CODE% = &11E3

 ORG CODE%

.x11E3

 JMP DOENTRY
 JMP DOBEGIN
 JMP CHPR

 EQUB &4B, &11
 EQUB &4C

.BRKV

 EQUB &D5
 EQUB &11

.INBAY

 LDX #&00
 LDY #&00
 JSR &8888
 JMP SCRAM

.DOBEGIN

 JSR scramble
 JMP BEGIN

.scramble

 LDY #&00
 STY SC
 LDX #&13

.L1207

 STX SCH
 TYA
 EOR (SC),Y
 EOR #&33
 STA (SC),Y
 DEY
 BNE &1207
 INX
 CPX #&60
 BNE &1207
 JMP BRKBK

INCLUDE "library/6502sp/main/subroutine/doentry.asm"

.SCRAM

 JSR scramble
 JSR RES2
 JMP TT170

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

 LDA #&0F
 TAX
 JMP OSBYTE

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

 EQUB &8C, &E7, &8D, &ED, &8A, &E6, &C1, &C8
 EQUB &C8, &8B, &E0, &8A, &E6, &D6, &C5, &C6
 EQUB &C1, &CA, &95, &9D, &9C, &97

INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"

\ Start of .MLS1?

 LDX ALP1
 STX P

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

 JSR TT111
 JMP TTX111

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

 LDX #&3F

.L2E94

 LDA QQ16,X
 STA QQ16_FLIGHT,X
 DEX
 BPL &2E94

 JSR &0D7A

 LDX #LO(RDLI)
 LDY #HI(RDLI)
 JMP OSCLI

INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"

.RDLI

 EQUS "R.D.CODE"
 EQUB 13

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
INCLUDE "library/common/main/subroutine/doexp.asm"
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

 LDA #&01
 STA LSP
 LDA #&FF
 STA LSX2
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
 JSR GTNME

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

 LDA JSTK
 BEQ DK9

 LDX #&01
 JSR DKS2

 ORA #&01
 STA JSTX
 LDX #&02
 JSR DKS2

 EOR JSTGY
 STA JSTY

INCLUDE "library/common/main/subroutine/dk4.asm"

.DK9

 STA BSTK
 BEQ DK4

INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"
INCLUDE "library/common/main/subroutine/shppt.asm"
INCLUDE "library/common/main/subroutine/ll5.asm"
INCLUDE "library/common/main/subroutine/ll28.asm"
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
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"

.TKN1

 EQUB &57

 EQUB &5E, &5C, &56, &5F, &77, &A6, &04, &1C
 EQUB &77, &16, &14, &BE, &04, &04, &77, &1A
 EQUB &12, &B6, &80, &5D, &55, &66, &79, &77
 EQUB &C2, &80, &65, &79, &77, &04, &16, &AD
 EQUB &77, &CD, &77, &53, &80, &64, &79, &77
 EQUB &14, &A2, &16, &B7, &10, &02, &12, &80
 EQUB &63, &79, &77, &13, &12, &1B, &8A, &12
 EQUB &87, &11, &1E, &B2, &80, &62, &79, &77
 EQUB &12, &0F, &8C, &80, &57, &5B, &00, &1F
 EQUB &1E, &14, &1F, &77, &C0, &68, &57, &14
 EQUB &18, &1A, &07, &12, &AC, &AC, &88, &77
 EQUB &B6, &1A, &15, &A3, &6D, &57, &C1, &C0
 EQUB &77, &47, &CF, &80, &57, &E7, &3A, &9D
 EQUB &39, &E6, &57, &77, &77, &C2, &77, &56
 EQUB &7F, &0E, &78, &19, &7E, &68, &55, &5B
 EQUB &5B, &57, &07, &A5, &04, &04, &77, &04
 EQUB &07, &16, &BE, &77, &AA, &77, &11, &1E
 EQUB &A5, &7B, &CD, &79, &5B, &5B, &57, &CD
 EQUB &70, &04, &9F, &57, &42, &11, &1E, &B2
 EQUB &9E, &13, &12, &1B, &8A, &12, &68, &57
 EQUB &40, &59, &55, &10, &A5, &8A, &A7, &10
 EQUB &04, &82, &E5, &44, &1E, &77, &A0, &10
 EQUB &87, &1A, &18, &1A, &A1, &03, &77, &18
 EQUB &11, &77, &E4, &05, &77, &01, &B3, &02
 EQUB &8F, &B2, &77, &AC, &1A, &12, &9B, &00
 EQUB &12, &77, &00, &8E, &1B, &13, &77, &1B
 EQUB &1E, &1C, &12, &77, &E4, &9E, &13, &18
 EQUB &87, &1B, &8C, &03, &B2, &77, &1D, &18
 EQUB &15, &77, &11, &AA, &77, &BB, &9B, &C4
 EQUB &98, &77, &E4, &77, &8D, &12, &77, &1F
 EQUB &12, &A5, &9D, &16, &85, &1A, &18, &13
 EQUB &12, &1B, &7B, &77, &C4, &44, &14, &88
 EQUB &89, &05, &1E, &14, &03, &AA, &7B, &77
 EQUB &12, &A9, &1E, &07, &93, &00, &1E, &B5
 EQUB &87, &03, &18, &07, &77, &8D, &14, &05
 EQUB &8A, &85, &04, &1F, &1E, &12, &1B, &13
 EQUB &77, &10, &A1, &A3, &A2, &AA, &9B, &02
 EQUB &19, &11, &AA, &03, &02, &19, &A2, &12
 EQUB &1B, &0E, &77, &8C, &70, &04, &77, &A0
 EQUB &A1, &77, &89, &18, &1B, &A1, &9B, &41
 EQUB &8C, &77, &00, &A1, &03, &77, &1A, &1E
 EQUB &04, &04, &94, &11, &05, &18, &1A, &77
 EQUB &8E, &05, &77, &98, &77, &0E, &B9, &13
 EQUB &77, &88, &77, &44, &B1, &A3, &77, &11
 EQUB &1E, &AD, &77, &1A, &88, &B5, &04, &77
 EQUB &16, &10, &18, &E5, &4B, &9B, &E4, &05
 EQUB &77, &1A, &1E, &04, &04, &1E, &88, &7B
 EQUB &77, &04, &1F, &8E, &1B, &13, &77, &E4
 EQUB &77, &13, &12, &14, &1E, &13, &12, &9E
 EQUB &16, &14, &BE, &07, &03, &77, &8C, &7B
 EQUB &77, &1E, &04, &9E, &8D, &12, &1C, &E5
 EQUB &13, &BA, &03, &05, &18, &0E, &77, &C3
 EQUB &98, &9B, &E4, &77, &16, &A5, &77, &14
 EQUB &16, &02, &AC, &88, &93, &B5, &A2, &77
 EQUB &88, &1B, &0E, &77, &51, &22, &52, &04
 EQUB &77, &00, &8B, &1B, &77, &07, &A1, &8A
 EQUB &AF, &03, &12, &77, &C4, &19, &12, &00
 EQUB &77, &04, &1F, &1E, &12, &1B, &13, &04
 EQUB &E5, &B5, &A2, &77, &C4, &44, &14, &88
 EQUB &89, &05, &1E, &14, &03, &AA, &9D, &11
 EQUB &8C, &03, &93, &00, &1E, &B5, &77, &A8
 EQUB &77, &51, &3B, &52, &E6, &55, &5F, &10
 EQUB &18, &18, &13, &77, &1B, &02, &14, &1C
 EQUB &7B, &77, &CD, &83, &41, &57, &4E, &5E
 EQUB &40, &59, &55, &77, &77, &A2, &03, &A1
 EQUB &AC, &88, &82, &79, &77, &44, &00, &12
 EQUB &77, &1F, &16, &AD, &77, &19, &12, &93
 EQUB &18, &11, &77, &E4, &05, &77, &8D, &05
 EQUB &01, &1E, &14, &BA, &77, &16, &10, &16
 EQUB &A7, &9B, &1E, &11, &77, &E4, &77, &00
 EQUB &8E, &1B, &13, &77, &A0, &77, &BC, &77
 EQUB &10, &18, &18, &13, &77, &16, &04, &9E
 EQUB &10, &18, &9E, &44, &BE, &A3, &A6, &77
 EQUB &E4, &77, &00, &8B, &1B, &77, &A0, &77
 EQUB &15, &05, &1E, &12, &11, &AB, &9B, &1E
 EQUB &11, &77, &04, &02, &14, &BE, &04, &04
 EQUB &11, &02, &1B, &7B, &77, &E4, &77, &00
 EQUB &8B, &1B, &77, &A0, &77, &00, &12, &1B
 EQUB &1B, &77, &A5, &00, &B9, &13, &AB, &83
 EQUB &4F, &57, &7F, &44, &14, &7E, &77, &16
 EQUB &14, &AA, &19, &BC, &11, &03, &77, &66
 EQUB &6E, &6F, &63, &57, &15, &0E, &77, &13
 EQUB &79, &15, &AF, &A0, &19, &77, &71, &77
 EQUB &1E, &79, &A0, &1B, &1B, &57, &42, &C6
 EQUB &9F, &4D, &57, &4E, &5E, &40, &59, &55
 EQUB &77, &77, &14, &88, &10, &AF, &03, &02
 EQUB &AE, &AC, &88, &04, &77, &CD, &76, &5B
 EQUB &5B, &B5, &A3, &12, &5A, &77, &00, &8B
 EQUB &1B, &77, &B3, &00, &16, &0E, &04, &77
 EQUB &A0, &87, &07, &AE, &BE, &77, &11, &AA
 EQUB &77, &E4, &77, &A7, &84, &9B, &A8, &13
 EQUB &77, &B8, &0E, &A0, &77, &BC, &88, &A3
 EQUB &77, &B5, &A8, &77, &E4, &77, &B5, &A7
 EQUB &1C, &79, &79, &83, &4F, &57, &11, &8F
 EQUB &B2, &13, &57, &B4, &03, &8F, &B2, &57
 EQUB &00, &12, &1B, &1B, &77, &1C, &B4, &00
 EQUB &19, &57, &11, &16, &1A, &18, &BB, &57
 EQUB &B4, &03, &AB, &57, &AD, &05, &0E, &57
 EQUB &1A, &8B, &13, &1B, &0E, &57, &1A, &18
 EQUB &89, &57, &A5, &16, &04, &88, &8F, &1B
 EQUB &0E, &57, &57, &F2, &57, &25, &57, &10
 EQUB &A5, &A2, &57, &01, &16, &89, &57, &07
 EQUB &A7, &1C, &57, &55, &20, &77, &21, &5A
 EQUB &77, &EE, &16, &AC, &88, &04, &57, &CB
 EQUB &04, &57, &22, &57, &D7, &77, &11, &AA
 EQUB &BA, &03, &04, &57, &18, &BE, &A8, &04
 EQUB &57, &04, &1F, &0E, &19, &BA, &04, &57
 EQUB &04, &8B, &1B, &A7, &BA, &04, &57, &B8
 EQUB &03, &94, &03, &AF, &A6, &AC, &88, &04
 EQUB &57, &B7, &A2, &1F, &94, &18, &11, &77
 EQUB &33, &57, &B7, &AD, &77, &11, &AA, &77
 EQUB &33, &57, &11, &18, &18, &13, &77, &15
 EQUB &B2, &19, &13, &A3, &04, &57, &03, &8E
 EQUB &05, &1E, &89, &04, &57, &07, &18, &8A
 EQUB &05, &0E, &57, &A6, &04, &14, &18, &04
 EQUB &57, &3B, &57, &00, &B3, &1C, &94, &C9
 EQUB &57, &14, &AF, &15, &57, &15, &A2, &57
 EQUB &B7, &15, &89, &57, &45, &57, &A0, &04
 EQUB &8A, &57, &07, &AE, &10, &02, &AB, &57
 EQUB &AF, &01, &16, &10, &AB, &57, &14, &02
 EQUB &05, &04, &AB, &57, &04, &14, &8E, &05
 EQUB &10, &AB, &57, &26, &77, &14, &1E, &01
 EQUB &8B, &77, &00, &B9, &57, &3F, &77, &08
 EQUB &77, &37, &04, &57, &16, &77, &3F, &77
 EQUB &A6, &8D, &16, &8D, &57, &26, &77, &12
 EQUB &B9, &B5, &A9, &16, &1C, &BA, &57, &26
 EQUB &77, &BC, &AE, &05, &77, &16, &14, &AC
 EQUB &01, &8C, &0E, &57, &F8, &0A, &77, &09
 EQUB &57, &C4, &46, &77, &08, &77, &37, &57
 EQUB &F8, &96, &04, &70, &77, &35, &77, &34
 EQUB &57, &55, &2D, &5A, &57, &F8, &3C, &77
 EQUB &3B, &57, &1D, &02, &1E, &BE, &57, &15
 EQUB &AF, &19, &13, &0E, &57, &00, &A2, &A3
 EQUB &57, &15, &A5, &00, &57, &10, &B9, &10
 EQUB &B2, &77, &15, &AE, &89, &A3, &04, &57
 EQUB &45, &57, &46, &77, &37, &57, &46, &77
 EQUB &45, &57, &46, &77, &3F, &57, &3F, &77
 EQUB &45, &57, &11, &8F, &02, &B7, &BB, &57
 EQUB &12, &0F, &18, &AC, &14, &57, &1F, &18
 EQUB &18, &07, &0E, &57, &02, &B6, &04, &02
 EQUB &B3, &57, &12, &0F, &14, &8C, &A7, &10
 EQUB &57, &14, &02, &1E, &04, &A7, &12, &57
 EQUB &19, &1E, &10, &1F, &03, &77, &1B, &1E
 EQUB &11, &12, &57, &14, &16, &04, &1E, &B4
 EQUB &04, &57, &04, &8C, &77, &14, &18, &1A
 EQUB &04, &57, &55, &2D, &5A, &57, &54, &57
 EQUB &C4, &C6, &77, &54, &57, &C4, &C5, &77
 EQUB &54, &57, &C3, &C6, &57, &C3, &C5, &57
 EQUB &04, &88, &77, &18, &11, &87, &15, &8C
 EQUB &14, &1F, &57, &04, &14, &8E, &19, &13
 EQUB &A5, &1B, &57, &15, &AE, &14, &1C, &10
 EQUB &02, &B9, &13, &57, &05, &18, &10, &02
 EQUB &12, &57, &00, &1F, &AA, &BA, &88, &77
 EQUB &A0, &8A, &B2, &77, &1F, &12, &16, &13
 EQUB &91, &11, &AE, &07, &77, &12, &B9, &70
 EQUB &13, &77, &1C, &19, &16, &AD, &57, &19
 EQUB &77, &02, &19, &A5, &B8, &05, &1C, &8F
 EQUB &B2, &57, &77, &15, &AA, &A7, &10, &57
 EQUB &77, &13, &02, &1B, &1B, &57, &77, &03
 EQUB &12, &A6, &18, &BB, &57, &77, &A5, &01
 EQUB &18, &1B, &03, &A7, &10, &57, &C6, &57
 EQUB &C5, &57, &07, &AE, &BE, &57, &1B, &8C
 EQUB &03, &B2, &77, &C6, &57, &13, &02, &1A
 EQUB &07, &57, &1E, &77, &1F, &12, &B9, &87
 EQUB &25, &77, &B7, &18, &1C, &94, &98, &77
 EQUB &16, &07, &07, &12, &B9, &93, &A2, &86
 EQUB &57, &0E, &12, &16, &1F, &7B, &77, &1E
 EQUB &77, &1F, &12, &B9, &87, &25, &77, &98
 EQUB &77, &B2, &11, &03, &86, &87, &77, &00
 EQUB &1F, &1E, &B2, &77, &15, &16, &14, &1C
 EQUB &57, &10, &8A, &77, &E4, &05, &77, &1E
 EQUB &05, &88, &77, &16, &04, &04, &77, &18
 EQUB &01, &A3, &77, &03, &18, &86, &57, &BC
 EQUB &1A, &12, &77, &24, &85, &98, &77, &00
 EQUB &16, &04, &77, &8D, &A1, &77, &A2, &86
 EQUB &57, &03, &05, &0E, &86, &57, &57, &57
 EQUB &57, &57, &00, &16, &04, &07, &57, &1A
 EQUB &18, &B5, &57, &10, &05, &02, &15, &57
 EQUB &A8, &03, &57, &45, &57, &07, &18, &8A
 EQUB &57, &B9, &03, &04, &77, &10, &AF, &13
 EQUB &02, &A2, &12, &57, &0E, &16, &1C, &57
 EQUB &04, &19, &16, &8B, &57, &04, &1B, &02
 EQUB &10, &57, &03, &05, &18, &07, &1E, &14
 EQUB &B3, &57, &13, &A1, &8D, &57, &AF, &A7
 EQUB &57, &1E, &1A, &07, &A1, &8A, &AF, &15
 EQUB &B2, &57, &12, &0F, &02, &A0, &AF, &19
 EQUB &03, &57, &11, &02, &19, &19, &0E, &57
 EQUB &00, &1E, &A3, &13, &57, &02, &B6, &04
 EQUB &02, &B3, &57, &89, &AF, &19, &B0, &57
 EQUB &07, &12, &14, &02, &1B, &1E, &B9, &57
 EQUB &11, &A5, &A9, &A1, &03, &57, &18, &14
 EQUB &14, &16, &04, &1E, &88, &B3, &57, &02
 EQUB &19, &07, &A5, &A6, &14, &03, &8F, &B2
 EQUB &57, &13, &A5, &16, &13, &11, &02, &1B
 EQUB &57, &FC, &57, &0B, &77, &0C, &77, &11
 EQUB &AA, &77, &32, &57, &DB, &E5, &32, &57
 EQUB &31, &77, &15, &0E, &77, &30, &57, &DB
 EQUB &77, &15, &02, &03, &77, &D9, &57, &77
 EQUB &16, &38, &77, &27, &57, &07, &1B, &A8
 EQUB &8A, &57, &00, &AA, &1B, &13, &57, &B5
 EQUB &12, &77, &57, &B5, &1E, &04, &77, &57
 EQUB &B7, &16, &13, &85, &CD, &57, &5E, &5C
 EQUB &56, &5F, &57, &13, &05, &1E, &AD, &57
 EQUB &77, &14, &A2, &16, &B7, &10, &02, &12
 EQUB &57, &1E, &A8, &57, &44, &14, &18, &1A
 EQUB &1A, &A8, &13, &A3, &57, &3F, &57, &1A
 EQUB &8E, &19, &03, &16, &A7, &57, &AB, &1E
 EQUB &15, &B2, &57, &03, &A5, &12, &57, &04
 EQUB &07, &18, &03, &03, &AB, &57, &2F, &57
 EQUB &2E, &57, &36, &18, &1E, &13, &57, &28
 EQUB &57, &29, &57, &A8, &14, &1E, &A1, &03
 EQUB &57, &12, &0F, &BE, &07, &AC, &88, &B3
 EQUB &57, &12, &14, &BE, &19, &03, &05, &1E
 EQUB &14, &57, &A7, &10, &AF, &A7, &AB, &57
 EQUB &25, &57, &1C, &8B, &1B, &A3, &57, &13
 EQUB &12, &16, &13, &1B, &0E, &57, &12, &01
 EQUB &8B, &57, &B2, &B5, &B3, &57, &01, &1E
 EQUB &14, &1E, &18, &BB, &57, &8C, &04, &77
 EQUB &57, &5A, &59, &44, &57, &79, &5B, &58
 EQUB &57, &77, &A8, &13, &77, &57, &0E, &8E
 EQUB &57, &07, &B9, &1C, &94, &1A, &8A, &A3
 EQUB &04, &57, &13, &BB, &03, &77, &14, &B7
 EQUB &02, &13, &04, &57, &1E, &BE, &77, &A0
 EQUB &05, &10, &04, &57, &05, &18, &14, &1C
 EQUB &77, &11, &AA, &B8, &AC, &88, &04, &57
 EQUB &01, &18, &1B, &14, &16, &B4, &BA, &57
 EQUB &07, &1B, &A8, &03, &57, &03, &02, &1B
 EQUB &1E, &07, &57, &15, &A8, &A8, &16, &57
 EQUB &14, &AA, &19, &57, &45, &00, &12, &AB
 EQUB &57, &45, &57, &46, &77, &45, &57, &46
 EQUB &77, &3F, &57, &A7, &1F, &16, &BD, &03
 EQUB &A8, &03, &57, &E8, &57, &A7, &10, &77
 EQUB &57, &AB, &77, &57, &57, &57, &57, &77
 EQUB &19, &16, &1A, &12, &68, &77, &57, &77
 EQUB &03, &18, &77, &57, &77, &1E, &04, &77
 EQUB &57, &00, &16, &04, &77, &AE, &89, &77
 EQUB &8D, &A1, &77, &A2, &77, &44, &57, &79
 EQUB &5B, &77, &44, &57, &13, &18, &14, &1C
 EQUB &AB, &57, &56, &7F, &0E, &78, &19, &7E
 EQUB &68, &57, &04, &1F, &1E, &07, &57, &77
 EQUB &16, &77, &57, &77, &A3, &05, &1E, &BB
 EQUB &57, &77, &19, &12, &00, &77, &57, &55
 EQUB &77, &1F, &A3, &77, &B8, &1D, &BA, &03
 EQUB &0E, &70, &04, &77, &04, &07, &16, &BE
 EQUB &77, &19, &16, &01, &0E, &5A, &57, &E6
 EQUB &5F, &56, &77, &77, &1A, &BA, &04, &16
 EQUB &B0, &77, &A1, &13, &04, &57, &77, &CD
 EQUB &77, &53, &7B, &77, &1E, &77, &5A, &16
 EQUB &1A, &55, &77, &14, &16, &07, &03, &16
 EQUB &A7, &77, &4C, &77, &5A, &18, &11, &84
 EQUB &57, &57, &58, &77, &02, &19, &1C, &B4
 EQUB &00, &19, &77, &C6, &57, &5E, &5F, &40
 EQUB &56, &A7, &14, &18, &1A, &94, &1A, &BA
 EQUB &04, &16, &B0, &57, &14, &02, &05, &05
 EQUB &02, &B5, &A3, &04, &57, &11, &18, &04
 EQUB &13, &0E, &1C, &12, &77, &04, &1A, &0E
 EQUB &B5, &12, &57, &11, &AA, &03, &BA, &A9
 EQUB &12, &57, &9C, &A5, &BA, &A6, &BE, &57
 EQUB &1E, &04, &77, &A0, &1B, &1E, &12, &01
 EQUB &AB, &9E, &1F, &16, &AD, &77, &1D, &02
 EQUB &1A, &07, &AB, &9E, &C3, &10, &B3, &16
 EQUB &0F, &0E, &57, &4E, &5E, &4A, &59, &55
 EQUB &10, &18, &18, &13, &77, &13, &16, &0E
 EQUB &77, &CD, &77, &53, &9B, &1E, &5A, &77
 EQUB &16, &1A, &77, &44, &16, &10, &A1, &03
 EQUB &77, &44, &15, &AE, &1C, &12, &77, &18
 EQUB &11, &77, &44, &19, &16, &01, &16, &1B
 EQUB &77, &44, &A7, &03, &12, &1B, &B2, &10
 EQUB &A1, &BE, &9B, &16, &04, &77, &E4, &77
 EQUB &1C, &B4, &00, &7B, &77, &C4, &44, &19
 EQUB &16, &01, &0E, &77, &1F, &16, &AD, &77
 EQUB &A0, &A1, &77, &1C, &12, &12, &07, &94
 EQUB &C4, &44, &B5, &B9, &10, &18, &1E, &13
 EQUB &04, &77, &18, &11, &11, &77, &E4, &05
 EQUB &77, &16, &04, &04, &77, &8E, &03, &77
 EQUB &A7, &77, &13, &12, &12, &07, &77, &04
 EQUB &07, &16, &BE, &77, &11, &AA, &77, &B8
 EQUB &19, &0E, &77, &0E, &12, &B9, &04, &77
 EQUB &B4, &00, &79, &77, &44, &00, &12, &1B
 EQUB &1B, &77, &C4, &04, &8C, &02, &16, &AC
 EQUB &88, &77, &1F, &16, &04, &77, &14, &1F
 EQUB &A8, &10, &AB, &9B, &8E, &05, &77, &15
 EQUB &18, &0E, &04, &77, &B9, &12, &77, &A5
 EQUB &16, &13, &0E, &77, &11, &AA, &87, &07
 EQUB &02, &04, &1F, &77, &05, &1E, &10, &1F
 EQUB &03, &9E, &C4, &1F, &18, &1A, &12, &77
 EQUB &04, &0E, &04, &03, &12, &1A, &77, &18
 EQUB &11, &77, &B5, &18, &8D, &77, &1A, &18
 EQUB &B5, &A3, &04, &9B, &4F, &5E, &4A, &1E
 EQUB &5A, &77, &1F, &16, &AD, &77, &18, &15
 EQUB &03, &16, &A7, &93, &C4, &13, &12, &11
 EQUB &A1, &BE, &77, &07, &AE, &19, &04, &77
 EQUB &11, &AA, &77, &B5, &12, &1E, &05, &77
 EQUB &44, &1F, &1E, &AD, &77, &44, &00, &AA
 EQUB &1B, &13, &04, &9B, &C4, &A0, &8A, &B2
 EQUB &04, &77, &1C, &B4, &00, &77, &00, &12
 EQUB &70, &AD, &77, &10, &18, &03, &77, &BC
 EQUB &1A, &12, &B5, &94, &15, &02, &03, &77
 EQUB &B4, &03, &77, &00, &1F, &A2, &9B, &1E
 EQUB &11, &77, &44, &1E, &77, &03, &AF, &19
 EQUB &04, &1A, &8C, &77, &C4, &07, &AE, &19
 EQUB &04, &9E, &8E, &05, &77, &15, &16, &8D
 EQUB &77, &88, &77, &44, &BD, &A5, &AF, &77
 EQUB &B5, &12, &0E, &70, &1B, &1B, &77, &A7
 EQUB &03, &A3, &BE, &07, &03, &77, &C4, &03
 EQUB &05, &A8, &04, &1A, &1E, &04, &04, &1E
 EQUB &88, &79, &77, &44, &1E, &77, &19, &12
 EQUB &AB, &87, &98, &9E, &B8, &1C, &12, &77
 EQUB &C4, &05, &02, &19, &9B, &E4, &70, &A5
 EQUB &77, &12, &B2, &14, &03, &AB, &9B, &C4
 EQUB &07, &AE, &19, &04, &77, &16, &A5, &77
 EQUB &02, &19, &1E, &07, &02, &1B, &8D, &77
 EQUB &14, &18, &13, &93, &00, &1E, &B5, &A7
 EQUB &77, &C3, &03, &05, &A8, &04, &1A, &1E
 EQUB &04, &04, &1E, &88, &9B, &5F, &E4, &77
 EQUB &00, &8B, &1B, &77, &A0, &77, &07, &16
 EQUB &1E, &13, &9B, &77, &77, &77, &77, &44
 EQUB &10, &18, &18, &13, &77, &1B, &02, &14
 EQUB &1C, &77, &CD, &83, &4F, &57, &4E, &5E
 EQUB &4A, &5F, &59, &5A, &44, &00, &12, &1B
 EQUB &1B, &77, &13, &88, &12, &77, &CD, &9B
 EQUB &E4, &77, &1F, &16, &AD, &77, &8D, &05
 EQUB &01, &93, &02, &04, &77, &00, &12, &1B
 EQUB &1B, &E5, &00, &12, &77, &04, &1F, &B3
 EQUB &1B, &77, &A5, &1A, &12, &1A, &15, &A3
 EQUB &9B, &00, &12, &77, &13, &1E, &13, &77
 EQUB &B4, &03, &77, &12, &0F, &07, &12, &14
 EQUB &03, &77, &C4, &44, &B5, &B9, &10, &18
 EQUB &1E, &13, &04, &9E, &11, &A7, &13, &77
 EQUB &8E, &03, &77, &16, &15, &8E, &03, &77
 EQUB &E4, &9B, &11, &AA, &77, &C4, &1A, &18
 EQUB &1A, &A1, &03, &77, &07, &B2, &16, &8D
 EQUB &77, &16, &14, &BE, &07, &03, &77, &C3
 EQUB &44, &19, &16, &01, &0E, &77, &51, &25
 EQUB &52, &77, &16, &04, &77, &07, &16, &0E
 EQUB &1A, &A1, &03, &83, &4F, &57, &57, &04
 EQUB &1F, &A5, &00, &57, &A0, &16, &89, &57
 EQUB &15, &1E, &04, &88, &57, &04, &19, &16
 EQUB &1C, &12, &57, &00, &18, &1B, &11, &57
 EQUB &B2, &18, &07, &B9, &13, &57, &14, &A2
 EQUB &57, &1A, &88, &1C, &12, &0E, &57, &10
 EQUB &18, &A2, &57, &11, &1E, &04, &1F, &57
 EQUB &3D, &77, &3E, &57, &46, &77, &2F, &77
 EQUB &2C, &57, &F8, &3C, &77, &2E, &77, &2C
 EQUB &57, &2B, &77, &2A, &57, &3D, &77, &3E
 EQUB &57, &1A, &12, &A2, &57, &14, &02, &03
 EQUB &1B, &8A, &57, &89, &12, &16, &1C, &57
 EQUB &15, &02, &05, &10, &A3, &04, &57, &BC
 EQUB &02, &07, &57, &1E, &BE, &57, &1A, &02
 EQUB &13, &57, &0D, &A3, &18, &7A, &44, &10
 EQUB &57, &01, &16, &14, &02, &02, &1A, &57
 EQUB &46, &77, &02, &1B, &03, &AF, &57, &1F
 EQUB &18, &14, &1C, &12, &0E, &57, &14, &05
 EQUB &1E, &14, &1C, &8A, &57, &1C, &B9, &A2
 EQUB &12, &57, &07, &18, &B7, &57, &03, &A1
 EQUB &19, &1E, &04, &57

 EQUB &57

.RUPLA

 EQUB &D3, &96, &24, &1C, &FD, &4F, &35, &76
 EQUB &64, &20, &44, &A4, &DC, &6A, &10, &A2
 EQUB &03, &6B, &1A, &C0, &B8, &05, &65, &C1

 EQUB &29

.RUGAL

 EQUB &80, &00, &00, &00, &01, &01, &01, &01
 EQUB &82, &01, &01, &01, &01, &01, &01, &01
 EQUB &01, &01, &01, &01, &01, &01, &02, &01
 EQUB &82

.RUTOK

 EQUB &57, &C4, &14, &18, &B7, &19, &1E, &89
 EQUB &04, &77, &1F, &12, &A5, &77, &1F, &16
 EQUB &AD, &77, &01, &1E, &18, &1B, &A2, &AB
 EQUB &55, &77, &A7, &03, &A3, &10, &B3, &16
 EQUB &14, &AC, &14, &77, &14, &B7, &19, &94
 EQUB &07, &05, &18, &03, &18, &14, &18, &1B
 EQUB &5A, &E5, &04, &1F, &8E, &1B, &13, &77
 EQUB &A0, &77, &16, &01, &18, &1E, &13, &AB
 EQUB &57, &C4, &14, &88, &89, &05, &1E, &14
 EQUB &03, &AA, &77, &9C, &A5, &BA, &A6, &BE
 EQUB &7B, &77, &CD, &57, &16, &77, &25, &77
 EQUB &B7, &18, &1C, &94, &98, &77, &B2, &11
 EQUB &03, &77, &1F, &12, &A5, &87, &00, &1F
 EQUB &1E, &B2, &77, &15, &16, &14, &1C, &79
 EQUB &77, &1B, &18, &18, &1C, &93, &15, &8E
 EQUB &19, &13, &77, &11, &AA, &77, &B9, &12
 EQUB &B1, &57, &0E, &12, &07, &7B, &87, &25
 EQUB &85, &98, &77, &1F, &16, &13, &87, &10
 EQUB &B3, &16, &14, &AC, &14, &77, &1F, &0E
 EQUB &07, &A3, &13, &05, &1E, &AD, &77, &11
 EQUB &8C, &03, &93, &1F, &12, &A5, &79, &77
 EQUB &BB, &93, &8C, &77, &03, &18, &18, &57
 EQUB &C3, &77, &25, &77, &98, &77, &13, &12
 EQUB &1F, &0E, &07, &93, &1F, &12, &A5, &77
 EQUB &11, &05, &18, &1A, &77, &B4, &00, &1F
 EQUB &12, &A5, &7B, &77, &04, &02, &19, &77
 EQUB &04, &1C, &1E, &1A, &1A, &AB, &E5, &1D
 EQUB &02, &1A, &07, &AB, &79, &77, &1E, &77
 EQUB &1F, &12, &B9, &77, &8C, &77, &00, &A1
 EQUB &03, &9E, &A7, &BD, &A0, &57, &24, &77
 EQUB &98, &77, &00, &A1, &03, &77, &11, &AA
 EQUB &77, &1A, &12, &77, &A2, &77, &16, &BB
 EQUB &B9, &79, &77, &1A, &0E, &77, &AE, &04
 EQUB &A3, &04, &77, &13, &1E, &13, &19, &70
 EQUB &03, &77, &12, &01, &A1, &77, &04, &14
 EQUB &AF, &03, &14, &1F, &77, &C4, &24, &57
 EQUB &18, &1F, &77, &13, &12, &B9, &77, &1A
 EQUB &12, &77, &0E, &BA, &79, &87, &11, &05
 EQUB &1E, &10, &1F, &03, &11, &02, &1B, &77
 EQUB &05, &18, &10, &02, &12, &77, &00, &1E
 EQUB &B5, &77, &00, &1F, &A2, &77, &1E, &77
 EQUB &A0, &1B, &1E, &12, &AD, &77, &E4, &77
 EQUB &07, &12, &18, &07, &B2, &77, &14, &B3
 EQUB &1B, &87, &B2, &16, &13, &77, &07, &18
 EQUB &89, &A3, &1E, &AA, &77, &04, &1F, &18
 EQUB &03, &77, &02, &07, &77, &B7, &03, &04
 EQUB &77, &18, &11, &77, &B5, &18, &8D, &77
 EQUB &A0, &16, &89, &1B, &0E, &77, &07, &1E
 EQUB &AF, &03, &BA, &E5, &00, &A1, &03, &9E
 EQUB &BB, &B2, &05, &1E, &57, &E4, &77, &14
 EQUB &A8, &77, &03, &16, &14, &1C, &B2, &77
 EQUB &C4, &3F, &77, &24, &77, &1E, &11, &77
 EQUB &E4, &77, &1B, &1E, &1C, &12, &79, &77
 EQUB &1F, &12, &70, &04, &77, &A2, &77, &AA
 EQUB &B9, &AF, &57, &56, &14, &18, &1A, &94
 EQUB &BC, &88, &6D, &77, &12, &1B, &8C, &12
 EQUB &77, &1E, &1E, &57, &23, &57, &23, &57
 EQUB &23, &57, &23, &57, &23, &57, &23, &57
 EQUB &23, &57, &23, &57, &23, &57, &23, &57
 EQUB &23, &57, &23, &57, &23, &57, &15, &18
 EQUB &0E, &77, &16, &A5, &77, &E4, &77, &A7
 EQUB &77, &C4, &00, &05, &88, &10, &77, &10
 EQUB &B3, &16, &0F, &0E, &76, &57, &B5, &A3
 EQUB &12, &70

.L5565

 EQUB &04, &87, &A5, &B3, &77, &24, &77, &07
 EQUB &1E, &AF, &03, &12, &77, &8E, &03, &77
 EQUB &B5, &A3, &12, &57, &C4, &96, &04, &77
 EQUB &18, &11, &77, &3A, &77, &16, &A5, &77
 EQUB &BC, &77, &16, &B8, &0D, &A7, &10, &1B
 EQUB &0E, &77, &07, &05, &1E, &1A, &1E, &AC
 EQUB &AD, &77, &B5, &A2, &77, &B5, &12, &0E
 EQUB &77, &89, &8B, &1B, &77, &B5, &A7, &1C
 EQUB &77, &44, &16, &7D, &7D, &7D, &7D, &7D
 EQUB &05, &9D, &16, &77, &07, &A5, &03, &03
 EQUB &0E, &77, &19, &12, &A2, &77, &10, &16
 EQUB &1A, &12, &57

.MTIN

 EQUB &10, &15, &1A, &1F, &9B, &A0, &2E, &A5
 EQUB &24, &29, &3D, &33, &38, &AA, &42, &47
 EQUB &4C, &51, &56, &8C, &60, &65, &87, &82
 EQUB &5B, &6A, &B4, &B9, &BE, &E1, &E6, &EB
 EQUB &F0, &F5, &FA, &73, &78, &7D
        
 EQUB &45, &4E
 EQUB &44, &2D, &45, &4E, &44, &2D, &45, &4E
 EQUB &44, &52, &50, &53, &00, &8E, &11, &D8
 EQUB &00, &00, &06, &56, &52, &49

.L55FE

 EQUB &45

.L55FF

 EQUB &E6

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"

.XX21

 EQUB &00, &7F, &00, &00, &00, &00, &00, &00
 EQUB &5D, &56, &00, &00, &00, &00, &00, &00
 EQUB &05, &57, &37, &58, &19, &5A, &A1, &5B
 EQUB &00, &00, &00, &00, &00, &00, &93, &5C
 EQUB &00, &00, &00, &00, &6D, &5D, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &53, &5E

.E%

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &21, &61, &A0, &A0, &00, &00, &00, &C2
 EQUB &00, &00, &8C, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &8C

INCLUDE "library/common/main/variable/ship_canister.asm"

        
\ Shuttle
 EQUB &0F
 EQUB &C4, &09, &86, &FE, &6D, &00, &26, &72
 EQUB &1E, &00, &00, &34, &16, &20, &08, &00
 EQUB &00, &02, &00, &00, &23, &2F, &5F, &FF
 EQUB &FF, &23, &00, &2F, &9F, &FF, &FF, &00
 EQUB &23, &2F, &1F, &FF, &FF, &23, &00, &2F
 EQUB &1F, &FF, &FF, &28, &28, &35, &FF, &12
 EQUB &39, &28, &28, &35, &BF, &34, &59, &28
 EQUB &28, &35, &3F, &56, &79, &28, &28, &35
 EQUB &7F, &17, &89, &0A, &00, &35, &30, &99
 EQUB &99, &00, &05, &35, &70, &99, &99, &0A
 EQUB &00, &35, &A8, &99, &99, &00, &05, &35
 EQUB &28, &99, &99, &00, &11, &47, &50, &0A
 EQUB &BC, &05, &02, &3D, &46, &FF, &02, &07
 EQUB &17, &31, &07, &01, &F4, &15, &09, &31
 EQUB &07, &A1, &3F, &05, &02, &3D, &C6, &6B
 EQUB &23, &07, &17, &31, &87, &F8, &C0, &15
 EQUB &09, &31, &87, &4F, &18, &1F, &02, &00
 EQUB &04, &1F, &4A, &04, &08, &1F, &6B, &08
 EQUB &0C, &1F, &8C, &00, &0C, &1F, &18, &00
 EQUB &1C, &18, &12, &00, &10, &1F, &23, &04
 EQUB &10, &18, &34, &04, &14, &1F, &45, &08
 EQUB &14, &0C, &56, &08, &18, &1F, &67, &0C
 EQUB &18, &18, &78, &0C, &1C, &1F, &39, &10
 EQUB &14, &1F, &59, &14, &18, &1F, &79, &18
 EQUB &1C, &1F, &19, &10, &1C, &10, &0C, &00
 EQUB &30, &10, &0A, &04, &30, &10, &AB, &08
 EQUB &30, &10, &BC, &0C, &30, &10, &99, &20
 EQUB &24, &06, &99, &24, &28, &08, &99, &28
 EQUB &2C, &06, &99, &20, &2C, &04, &BB, &34
 EQUB &38, &07, &BB, &38, &3C, &06, &BB, &34
 EQUB &3C, &04, &AA, &40, &44, &07, &AA, &44
 EQUB &48, &06, &AA, &40, &48, &DF, &6E, &6E
 EQUB &50, &5F, &00, &95, &07, &DF, &66, &66
 EQUB &2E, &9F, &95, &00, &07, &9F, &66, &66
 EQUB &2E, &1F, &00, &95, &07, &1F, &66, &66
 EQUB &2E, &1F, &95, &00, &07, &5F, &66, &66
 EQUB &2E, &3F, &00, &00, &D5, &9F, &51, &51
 EQUB &B1, &1F, &51, &51, &B1, &5F, &6E, &6E
 EQUB &50
        
\ Transporter
 EQUB &00, &C4, &09, &F2, &AA, &91, &30
 EQUB &1A, &DE, &2E, &00, &00, &38, &10, &20
 EQUB &0A, &00, &01, &01, &00, &00, &13, &33
 EQUB &3F, &06, &77, &33, &07, &33, &BF, &01
 EQUB &77, &39, &07, &33, &FF, &01, &22, &33
 EQUB &11, &33, &FF, &02, &33, &33, &11, &33
 EQUB &7F, &03, &44, &39, &07, &33, &7F, &04
 EQUB &55, &33, &07, &33, &3F, &05, &66, &00
 EQUB &0C, &18, &12, &FF, &FF, &3C, &02, &18
 EQUB &DF, &17, &89, &42, &11, &18, &DF, &12
 EQUB &39, &42, &11, &18, &5F, &34, &5A, &3C
 EQUB &02, &18, &5F, &56, &AB, &16, &05, &3D
 EQUB &DF, &89, &CD, &1B, &11, &3D, &DF, &39
 EQUB &DD, &1B, &11, &3D, &5F, &3A, &DD, &16
 EQUB &05, &3D, &5F, &AB, &CD, &0A, &0B, &05
 EQUB &86, &77, &77, &24, &05, &05, &86, &77
 EQUB &77, &0A, &0D, &0E, &A6, &77, &77, &24
 EQUB &07, &0E, &A6, &77, &77, &17, &0C, &1D
 EQUB &A6, &77, &77, &17, &0A, &0E, &A6, &77
 EQUB &77, &0A, &0F, &1D, &26, &66, &66, &24
 EQUB &09, &1D, &26, &66, &66, &17, &0A, &0E
 EQUB &26, &66, &66, &0A, &0C, &06, &26, &66
 EQUB &66, &24, &06, &06, &26, &66, &66, &17
 EQUB &07, &10, &06, &66, &66, &17, &09, &06
 EQUB &26, &66, &66, &21, &11, &1A, &E5, &33
 EQUB &33, &21, &11, &21, &C5, &33, &33, &21
 EQUB &11, &1A, &65, &33, &33, &21, &11, &21
 EQUB &45, &33, &33, &19, &06, &33, &E7, &00
 EQUB &00, &1A, &06, &33, &67, &00, &00, &11
 EQUB &06, &33, &24, &00, &00, &11, &06, &33
 EQUB &A4, &00, &00, &1F, &07, &00, &04, &1F
 EQUB &01, &04, &08, &1F, &02, &08, &0C, &1F
 EQUB &03, &0C, &10, &1F, &04, &10, &14, &1F
 EQUB &05, &14, &18, &1F, &06, &00, &18, &0F
 EQUB &67, &00, &1C, &1F, &17, &04, &20, &0A
 EQUB &12, &08, &24, &1F, &23, &0C, &24, &1F
 EQUB &34, &10, &28, &0A, &45, &14, &28, &1F
 EQUB &56, &18, &2C, &10, &78, &1C, &20, &10
 EQUB &19, &20, &24, &10, &5A, &28, &2C, &10
 EQUB &6B, &1C, &2C, &12, &BC, &1C, &3C, &12
 EQUB &8C, &1C, &30, &10, &89, &20, &30, &1F
 EQUB &39, &24, &34, &1F, &3A, &28, &38, &10
 EQUB &AB, &2C, &3C, &1F, &9D, &30, &34, &1F
 EQUB &3D, &34, &38, &1F, &AD, &38, &3C, &1F
 EQUB &CD, &30, &3C, &06, &77, &40, &44, &06
 EQUB &77, &48, &4C, &06, &77, &4C, &50, &06
 EQUB &77, &48, &50, &06, &77, &50, &54, &06
 EQUB &66, &58, &5C, &06, &66, &5C, &60, &06
 EQUB &66, &60, &58, &06, &66, &64, &68, &06
 EQUB &66, &68, &6C, &06, &66, &64, &6C, &06
 EQUB &66, &6C, &70, &05, &33, &74, &78, &05
 EQUB &33, &7C, &80, &07, &00, &84, &88, &04
 EQUB &00, &88, &8C, &04, &00, &8C, &90, &04
 EQUB &00, &90, &84, &3F, &00, &00, &67, &BF
 EQUB &6F, &30, &07, &FF, &69, &3F, &15, &5F
 EQUB &00, &22, &00, &7F, &69, &3F, &15, &3F
 EQUB &6F, &30, &07, &1F, &08, &20, &03, &9F
 EQUB &08, &20, &03, &92, &08, &22, &0B, &9F
 EQUB &4B, &20, &4F, &1F, &4B, &20, &4F, &12
 EQUB &08, &22, &0B, &1F, &00, &26, &11, &1F
 EQUB &00, &00, &79
        
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable/ship_python.asm"

INCLUDE "library/common/main/variable/ship_viper.asm"

        
\ Krait
 EQUB &01
 EQUB &10, &0E, &7A, &CE, &55, &00, &12, &66
 EQUB &15, &64, &00, &18, &14, &50, &1E, &00
 EQUB &00, &02, &10, &00, &00, &60, &1F, &01
 EQUB &23, &00, &12, &30, &3F, &03, &45, &00
 EQUB &12, &30, &7F, &12, &45, &5A, &00, &03
 EQUB &3F, &01, &44, &5A, &00, &03, &BF, &23
 EQUB &55, &5A, &00, &57, &1C, &01, &11, &5A
 EQUB &00, &57, &9C, &23, &33, &00, &05, &35
 EQUB &09, &00, &33, &00, &07, &26, &06, &00
 EQUB &33, &12, &07, &13, &89, &33, &33, &12
 EQUB &07, &13, &09, &00, &00, &12, &0B, &27
 EQUB &28, &44, &44, &12, &0B, &27, &68, &44
 EQUB &44, &24, &00, &1E, &28, &44, &44, &12
 EQUB &0B, &27, &A8, &55, &55, &12, &0B, &27
 EQUB &E8, &55, &55, &24, &00, &1E, &A8, &55
 EQUB &55, &1F, &03, &00, &04, &1F, &12, &00
 EQUB &08, &1F, &01, &00, &0C, &1F, &23, &00
 EQUB &10, &1F, &35, &04, &10, &1F, &25, &10
 EQUB &08, &1F, &14, &08, &0C, &1F, &04, &0C
 EQUB &04, &1C, &01, &0C, &14, &1C, &23, &10
 EQUB &18, &05, &45, &04, &08, &09, &00, &1C
 EQUB &28, &06, &00, &20, &28, &09, &33, &1C
 EQUB &24, &06, &33, &20, &24, &08, &44, &2C
 EQUB &34, &08, &44, &34, &30, &07, &44, &30
 EQUB &2C, &07, &55, &38, &3C, &08, &55, &3C
 EQUB &40, &08, &55, &40, &38, &1F, &07, &30
 EQUB &06, &5F, &07, &30, &06, &DF, &07, &30
 EQUB &06, &9F, &07, &30, &06, &3F, &4D, &00
 EQUB &9A, &BF, &4D, &00, &9A
        
\ Constrictor
 EQUB &F3, &49, &26
 EQUB &7A, &DA, &4D, &00, &2E, &66, &18, &00
 EQUB &00, &28, &2D, &C8, &37, &00, &00, &02
 EQUB &2F, &14, &07, &50, &5F, &02, &99, &14
 EQUB &07, &50, &DF, &01, &99, &36, &07, &28
 EQUB &DF, &14, &99, &36, &07, &28, &FF, &45
 EQUB &89, &14, &0D, &28, &BF, &56, &88, &14
 EQUB &0D, &28, &3F, &67, &88, &36, &07, &28
 EQUB &7F, &37, &89, &36, &07, &28, &5F, &23
 EQUB &99, &14, &0D, &05, &1F, &FF, &FF, &14
 EQUB &0D, &05, &9F, &FF, &FF, &14, &07, &3E
 EQUB &52, &99, &99, &14, &07, &3E, &D2, &99
 EQUB &99, &19, &07, &19, &72, &99, &99, &19
 EQUB &07, &19, &F2, &99, &99, &0F, &07, &0F
 EQUB &6A, &99, &99, &0F, &07, &0F, &EA, &99
 EQUB &99, &00, &07, &00, &40, &9F, &01, &1F
 EQUB &09, &00, &04, &1F, &19, &04, &08, &1F
 EQUB &01, &04, &24, &1F, &02, &00, &20, &1F
 EQUB &29, &00, &1C, &1F, &23, &1C, &20, &1F
 EQUB &14, &08, &24, &1F, &49, &08, &0C, &1F
 EQUB &39, &18, &1C, &1F, &37, &18, &20, &1F
 EQUB &67, &14, &20, &1F, &56, &10, &24, &1F
 EQUB &45, &0C, &24, &1F, &58, &0C, &10, &1F
 EQUB &68, &10, &14, &1F, &78, &14, &18, &1F
 EQUB &89, &0C, &18, &1F, &06, &20, &24, &12
 EQUB &99, &28, &30, &05, &99, &30, &38, &0A
 EQUB &99, &38, &28, &0A, &99, &2C, &3C, &05
 EQUB &99, &34, &3C, &12, &99, &2C, &34, &1F
 EQUB &00, &37, &0F, &9F, &18, &4B, &14, &1F
 EQUB &18, &4B, &14, &1F, &2C, &4B, &00, &9F
 EQUB &2C, &4B, &00, &9F, &2C, &4B, &00, &1F
 EQUB &00, &35, &00, &1F, &2C, &4B, &00, &3F
 EQUB &00, &00, &A0, &5F, &00, &1B, &00
        
 SKIP 171

SAVE "versions/disc/output/T.CODE.unprot.bin", CODE%, P%

