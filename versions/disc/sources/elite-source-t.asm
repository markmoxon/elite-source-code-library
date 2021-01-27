\ ******************************************************************************
\
\ DISC ELITE DOCKED SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
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
SHIP_MISSILE = &7F00

INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

CODE% = &11E3
LOAD% = &11E3

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

\ ******************************************************************************
\
\ ELITE B FILE
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\ ELITE C FILE
\
\ ******************************************************************************

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

\ Junk, same as in D.CODE

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

\ ******************************************************************************
\
\ ELITE D FILE
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\ ELITE E FILE
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\ ELITE F FILE
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\ ELITE G FILE
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\ ELITE H FILE
\
\ ******************************************************************************

INCLUDE "library/6502sp/main/macro/ejmp.asm"
INCLUDE "library/6502sp/main/macro/echr.asm"
INCLUDE "library/6502sp/main/macro/etok.asm"
INCLUDE "library/6502sp/main/macro/etwo.asm"
INCLUDE "library/6502sp/main/macro/ernd.asm"
INCLUDE "library/6502sp/main/macro/tokn.asm"
INCLUDE "library/6502sp/main/variable/tkn1.asm"
INCLUDE "library/6502sp/main/variable/rupla.asm"
INCLUDE "library/6502sp/main/variable/rugal.asm"
INCLUDE "library/6502sp/main/variable/rutok.asm"
INCLUDE "library/6502sp/main/variable/mtin.asm"

 EQUB &45, &4E
 EQUB &44, &2D, &45, &4E, &44, &2D, &45, &4E
 EQUB &44, &52, &50, &53, &00, &8E, &11, &D8
 EQUB &00, &00, &06, &56, &52, &49, &45, &E6

\ ******************************************************************************
\
\ ELITE SHIP BLUEPRINTS FILE
\
\ ******************************************************************************

\ ******************************************************************************
\
\       Name: XX21
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints lookup table for the ship hanger
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.XX21

 EQUW SHIP_MISSILE      \ MSL  =  1 = Missile
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_CANISTER     \ OIL  =  5 = Cargo canister
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_SHUTTLE      \ SHU  =  9 = Shuttle
 EQUW SHIP_TRANSPORTER  \        10 = Transporter
 EQUW SHIP_COBRA_MK_3   \ CYL  = 11 = Cobra Mk III
 EQUW SHIP_PYTHON       \        12 = Python
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_VIPER        \ COPS = 16 = Viper
 EQUW 0
 EQUW 0
 EQUW SHIP_KRAIT        \ KRA  = 19 = Krait
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW 0
 EQUW SHIP_CONSTRICTOR  \ CON  = 31 = Constrictor

\ ******************************************************************************
\
\       Name: E%
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprints default NEWB flags for the ship hanger
\
\ ******************************************************************************

 EQUB %00000000         \ Missile
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %00000000         \ Cargo canister
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %00100001         \ Shuttle                               Trader, innocent
 EQUB %01100001         \ Transporter                      Trader, innocent, cop
 EQUB %10100000         \ Cobra Mk III                      Innocent, escape pod
 EQUB %10100000         \ Python                            Innocent, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %11000010         \ Viper                   Bounty hunter, cop, escape pod
 EQUB 0
 EQUB 0
 EQUB %10001100         \ Krait                      Hostile, pirate, escape pod
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB %10001100         \ Constrictor                Hostile, pirate, escape pod

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_canister.asm"
        
.SHIP_SHUTTLE

 EQUB &0F
 EQUB &C4, &09
 EQUB &86
 EQUB &FE
 EQUB &6D
 EQUB &00
 EQUB &26
 EQUB &72
 EQUB &1E
 EQUB &00, &00
 EQUB &34
 EQUB &16
 EQUB &20
 EQUB &08
 EQUB &00
 EQUB &00
 EQUB &02
 EQUB &00
 
\ Vertices

 EQUB &00, &23, &2F, &5F, &FF, &FF
 EQUB &23, &00, &2F, &9F, &FF, &FF
 EQUB &00, &23, &2F, &1F, &FF, &FF
 EQUB &23, &00, &2F, &1F, &FF, &FF
 EQUB &28, &28, &35, &FF, &12, &39

 EQUB &28, &28, &35, &BF, &34, &59
 EQUB &28, &28, &35, &3F, &56, &79
 EQUB &28, &28, &35, &7F, &17, &89
 EQUB &0A, &00, &35, &30, &99, &99
 EQUB &00, &05, &35, &70, &99, &99

 EQUB &0A, &00, &35, &A8, &99, &99
 EQUB &00, &05, &35, &28, &99, &99
 EQUB &00, &11, &47, &50, &0A, &BC
 EQUB &05, &02, &3D, &46, &FF, &02
 EQUB &07, &17, &31, &07, &01, &F4

 EQUB &15, &09, &31, &07, &A1, &3F
 EQUB &05, &02, &3D, &C6, &6B, &23
 EQUB &07, &17, &31, &87, &F8, &C0
 EQUB &15, &09, &31, &87, &4F, &18

\ Edges

 EQUB &1F, &02, &00, &04
 EQUB &1F, &4A, &04, &08
 EQUB &1F, &6B, &08, &0C
 EQUB &1F, &8C, &00, &0C
 EQUB &1F, &18, &00, &1C

 EQUB &18, &12, &00, &10
 EQUB &1F, &23, &04, &10
 EQUB &18, &34, &04, &14
 EQUB &1F, &45, &08, &14
 EQUB &0C, &56, &08, &18

 EQUB &1F, &67, &0C, &18
 EQUB &18, &78, &0C, &1C
 EQUB &1F, &39, &10, &14
 EQUB &1F, &59, &14, &18
 EQUB &1F, &79, &18, &1C

 EQUB &1F, &19, &10, &1C
 EQUB &10, &0C, &00, &30
 EQUB &10, &0A, &04, &30
 EQUB &10, &AB, &08, &30
 EQUB &10, &BC, &0C, &30

 EQUB &10, &99, &20, &24
 EQUB &06, &99, &24, &28
 EQUB &08, &99, &28, &2C
 EQUB &06, &99, &20, &2C
 EQUB &04, &BB, &34, &38

 EQUB &07, &BB, &38, &3C
 EQUB &06, &BB, &34, &3C
 EQUB &04, &AA, &40, &44
 EQUB &07, &AA, &44, &48
 EQUB &06, &AA, &40, &48

\ Faces

 EQUB &DF, &6E, &6E, &50
 EQUB &5F, &00, &95, &07
 EQUB &DF, &66, &66, &2E
 EQUB &9F, &95, &00, &07
 EQUB &9F, &66, &66, &2E

 EQUB &1F, &00, &95, &07
 EQUB &1F, &66, &66, &2E
 EQUB &1F, &95, &00, &07
 EQUB &5F, &66, &66, &2E
 EQUB &3F, &00, &00, &D5

 EQUB &9F, &51, &51, &B1
 EQUB &1F, &51, &51, &B1
 EQUB &5F, &6E, &6E, &50
        
.SHIP_TRANSPORTER

 EQUB &00
 EQUB &C4, &09
 EQUB &F2
 EQUB &AA
 EQUB &91
 EQUB &30
 EQUB &1A
 EQUB &DE
 EQUB &2E
 EQUB &00, &00
 EQUB &38
 EQUB &10
 EQUB &20
 EQUB &0A
 EQUB &00
 EQUB &01
 EQUB &01 \ is 2 in include
 EQUB &00
 
 \ Vertices

 EQUB &00, &13, &33, &3F, &06, &77
 EQUB &33, &07, &33, &BF, &01, &77
 EQUB &39, &07, &33, &FF, &01, &22
 EQUB &33, &11, &33, &FF, &02, &33
 EQUB &33, &11, &33, &7F, &03, &44

 EQUB &39, &07, &33, &7F, &04, &55
 EQUB &33, &07, &33, &3F, &05, &66
 EQUB &00, &0C, &18, &12, &FF, &FF
 EQUB &3C, &02, &18, &DF, &17, &89
 EQUB &42, &11, &18, &DF, &12, &39

 EQUB &42, &11, &18, &5F, &34, &5A
 EQUB &3C, &02, &18, &5F, &56, &AB
 EQUB &16, &05, &3D, &DF, &89, &CD
 EQUB &1B, &11, &3D, &DF, &39, &DD
 EQUB &1B, &11, &3D, &5F, &3A, &DD

 EQUB &16, &05, &3D, &5F, &AB, &CD
 EQUB &0A, &0B, &05, &86, &77, &77
 EQUB &24, &05, &05, &86, &77, &77
 EQUB &0A, &0D, &0E, &A6, &77, &77
 EQUB &24, &07, &0E, &A6, &77, &77

 EQUB &17, &0C, &1D, &A6, &77, &77
 EQUB &17, &0A, &0E, &A6, &77, &77
 EQUB &0A, &0F, &1D, &26, &66, &66
 EQUB &24, &09, &1D, &26, &66, &66
 EQUB &17, &0A, &0E, &26, &66, &66

 EQUB &0A, &0C, &06, &26, &66, &66
 EQUB &24, &06, &06, &26, &66, &66
 EQUB &17, &07, &10, &06, &66, &66
 EQUB &17, &09, &06, &26, &66, &66
 EQUB &21, &11, &1A, &E5, &33, &33

 EQUB &21, &11, &21, &C5, &33, &33
 EQUB &21, &11, &1A, &65, &33, &33
 EQUB &21, &11, &21, &45, &33, &33
 EQUB &19, &06, &33, &E7, &00, &00
 EQUB &1A, &06, &33, &67, &00, &00

 EQUB &11, &06, &33, &24, &00, &00
 EQUB &11, &06, &33, &A4, &00, &00

\ Edges

 EQUB &1F, &07, &00, &04
 EQUB &1F, &01, &04, &08
 EQUB &1F, &02, &08, &0C
 EQUB &1F, &03, &0C, &10
 EQUB &1F, &04, &10, &14

 EQUB &1F, &05, &14, &18
 EQUB &1F, &06, &00, &18
 EQUB &0F, &67, &00, &1C
 EQUB &1F, &17, &04, &20
 EQUB &0A, &12, &08, &24

 EQUB &1F, &23, &0C, &24
 EQUB &1F, &34, &10, &28
 EQUB &0A, &45, &14, &28
 EQUB &1F, &56, &18, &2C
 EQUB &10, &78, &1C, &20

 EQUB &10, &19, &20, &24
 EQUB &10, &5A, &28, &2C
 EQUB &10, &6B, &1C, &2C
 EQUB &12, &BC, &1C, &3C
 EQUB &12, &8C, &1C, &30

 EQUB &10, &89, &20, &30
 EQUB &1F, &39, &24, &34
 EQUB &1F, &3A, &28, &38
 EQUB &10, &AB, &2C, &3C
 EQUB &1F, &9D, &30, &34

 EQUB &1F, &3D, &34, &38
 EQUB &1F, &AD, &38, &3C
 EQUB &1F, &CD, &30, &3C
 EQUB &06, &77, &40, &44
 EQUB &06, &77, &48, &4C

 EQUB &06, &77, &4C, &50
 EQUB &06, &77, &48, &50
 EQUB &06, &77, &50, &54
 EQUB &06, &66, &58, &5C
 EQUB &06, &66, &5C, &60

 EQUB &06, &66, &60, &58
 EQUB &06, &66, &64, &68
 EQUB &06, &66, &68, &6C
 EQUB &06, &66, &64, &6C
 EQUB &06, &66, &6C, &70

 EQUB &05, &33, &74, &78
 EQUB &05, &33, &7C, &80
 EQUB &07, &00, &84, &88
 EQUB &04, &00, &88, &8C
 EQUB &04, &00, &8C, &90

 EQUB &04, &00, &90, &84

\ Faces

 EQUB &3F, &00, &00, &67
 EQUB &BF, &6F, &30, &07
 EQUB &FF, &69, &3F, &15
 EQUB &5F, &00, &22, &00
 EQUB &7F, &69, &3F, &15

 EQUB &3F, &6F, &30, &07
 EQUB &1F, &08, &20, &03
 EQUB &9F, &08, &20, &03
 EQUB &92, &08, &22, &0B
 EQUB &9F, &4B, &20, &4F

 EQUB &1F, &4B, &20, &4F
 EQUB &12, &08, &22, &0B
 EQUB &1F, &00, &26, &11
 EQUB &1F, &00, &00, &79
        
INCLUDE "library/common/main/variable/ship_cobra_mk_iii.asm"
INCLUDE "library/common/main/variable/ship_python.asm"
INCLUDE "library/common/main/variable/ship_viper.asm"
 
.SHIP_KRAIT

 EQUB &01
 EQUB &10, &0E
 EQUB &7A
 EQUB &CE
 EQUB &55
 EQUB &00
 EQUB &12
 EQUB &66
 EQUB &15
 EQUB &64, &00
 EQUB &18
 EQUB &14
 EQUB &50
 EQUB &1E
 EQUB &00
 EQUB &00
 EQUB &02 \ is 1 in include
 EQUB &10
 
\ Vertices

 EQUB &00, &00, &60, &1F, &01, &23
 EQUB &00, &12, &30, &3F, &03, &45
 EQUB &00, &12, &30, &7F, &12, &45
 EQUB &5A, &00, &03, &3F, &01, &44
 EQUB &5A, &00, &03, &BF, &23, &55

 EQUB &5A, &00, &57, &1C, &01, &11
 EQUB &5A, &00, &57, &9C, &23, &33
 EQUB &00, &05, &35, &09, &00, &33
 EQUB &00, &07, &26, &06, &00, &33
 EQUB &12, &07, &13, &89, &33, &33

 EQUB &12, &07, &13, &09, &00, &00
 EQUB &12, &0B, &27, &28, &44, &44
 EQUB &12, &0B, &27, &68, &44, &44
 EQUB &24, &00, &1E, &28, &44, &44
 EQUB &12, &0B, &27, &A8, &55, &55

 EQUB &12, &0B, &27, &E8, &55, &55
 EQUB &24, &00, &1E, &A8, &55, &55

\ Edges

 EQUB &1F, &03, &00, &04
 EQUB &1F, &12, &00, &08
 EQUB &1F, &01, &00, &0C
 EQUB &1F, &23, &00, &10
 EQUB &1F, &35, &04, &10

 EQUB &1F, &25, &10, &08
 EQUB &1F, &14, &08, &0C
 EQUB &1F, &04, &0C, &04
 EQUB &1C, &01, &0C, &14
 EQUB &1C, &23, &10, &18

 EQUB &05, &45, &04, &08
 EQUB &09, &00, &1C, &28
 EQUB &06, &00, &20, &28
 EQUB &09, &33, &1C, &24
 EQUB &06, &33, &20, &24

 EQUB &08, &44, &2C, &34
 EQUB &08, &44, &34, &30
 EQUB &07, &44, &30, &2C
 EQUB &07, &55, &38, &3C
 EQUB &08, &55, &3C, &40

 EQUB &08, &55, &40, &38

\ Faces

 EQUB &1F, &07, &30, &06
 EQUB &5F, &07, &30, &06
 EQUB &DF, &07, &30, &06
 EQUB &9F, &07, &30, &06
 EQUB &3F, &4D, &00, &9A

 EQUB &BF, &4D, &00, &9A
        
INCLUDE "library/6502sp/main/variable/ship_constrictor.asm"

 SKIP 171

\ ******************************************************************************
\
\ Save output/T.CODE.unprot.bin
\
\ ******************************************************************************

PRINT "S.T.CODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/T.CODE.unprot.bin", CODE%, P%

