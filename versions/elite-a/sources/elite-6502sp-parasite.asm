\ ******************************************************************************
\
\ ELITE-A GAME SOURCE (PARASITE)
\
\ Elite-A was written by Angus Duggan, and is an extended version of the BBC
\ Micro disc version of Elite; the extra code is copyright Angus Duggan
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to Angus Duggan's source discs (it's just
\ been reformatted and variable names changed to be more readable)
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
\   * output/2.T.bin
\
\ ******************************************************************************

INCLUDE "versions/elite-a/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)
_ELITE_A_VERSION        = (_VERSION = 6)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = FALSE
_ELITE_A_DOCKED         = FALSE
_ELITE_A_FLIGHT         = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = TRUE
_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

LS% = &0CFF             \ The start of the descending ship line heap

NOST = 18               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 31                \ The number of different ship types

MSL = 1                 \ Ship type for a missile
SST = 2                 \ Ship type for a Coriolis space station
ESC = 3                 \ Ship type for an escape pod
PLT = 4                 \ Ship type for an alloy plate
OIL = 5                 \ Ship type for a cargo canister
AST = 7                 \ Ship type for an asteroid
SPL = 8                 \ Ship type for a splinter
SHU = 9                 \ Ship type for a Shuttle
CYL = 11                \ Ship type for a Cobra Mk III
ANA = 14                \ Ship type for an Anaconda
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

JL = ESC                \ Junk is defined as starting from the escape pod

JH = SHU+2              \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ Shuttle or Transporter

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

NRU% = 25               \ The number of planetary systems with extended system
                        \ description overrides in the RUTOK table

VE = 0                  \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code, which is
                        \ zero in Elite-A as the token table is not obfuscated

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

QQ16_FLIGHT = &0880     \ The address of the two-letter text token table in the
                        \ flight code (this gets populated by the docked code at
                        \ the start of the game)

CATD = &0D7A            \ The address of the CATD routine that is put in place
                        \ by the third loader, as set in elite-loader3.asm

IRQ1 = &114B            \ The address of the IRQ1 routine that implements the
                        \ split screen interrupt handler, as set in
                        \ elite-loader3.asm

BRBR1 = &11D5           \ The address of the main break handler, which BRKV
                        \ points to as set in elite-loader3.asm

SHIP_MISSILE = &7F00    \ The address of the missile ship blueprint, as set in
                        \ elite-loader3.asm

save_lock = &233        \ IND2V+1
new_file = &234         \ IND3V
new_posn = &235         \ IND3V+1

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/enhanced/main/workspace/up.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/common/main/workspace/wp.asm"

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

CODE% = &1000
LOAD% = &1000

ORG CODE%

LOAD_A% = LOAD%

dockedp = &A0
BRKV = &202

tube_r1s = &FEF8
tube_r1d = &FEF9
tube_r2s = &FEFA
tube_r2d = &FEFB
tube_r3s = &FEFC
tube_r3d = &FEFD
tube_r4s = &FEFE
tube_r4d = &FEFF



._117C

 EQUS ":0.E"

._1180

 EQUS "."

.NA%

 EQUS "NEWCOME"

._1188

 EQUS &0D

.commander

 EQUB &00, &14, &AD, &4A, &5A, &48, &02, &53, &B7, &00, &00, &13
 EQUB &88, &3C, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &0F, &11, &00, &03, &1C, &0E
 EQUB &00, &00, &0A, &00, &11, &3A, &07, &09, &08, &00, &00, &00
 EQUB &00, &20

.CHK2
 EQUB &F1

.CHK
 EQUB &58

.tube_write

 BIT tube_r1s
 NOP
 BVC tube_write
 STA tube_r1d
 RTS

.tube_read

 BIT tube_r2s
 NOP
 BPL tube_read
 LDA tube_r2d
 RTS

INCLUDE "library/enhanced/main/subroutine/doentry.asm"
INCLUDE "library/elite-a/docked/subroutine/scramble.asm"
INCLUDE "library/enhanced/main/subroutine/brkbk.asm"
INCLUDE "library/elite-a/encyclopedia/subroutine/write_msg3.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/common/main/subroutine/mveit_part_1_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvs5.asm"

.LOIN
.LL30

 LDA #&80
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &36
 JSR tube_write
 LDA &37
 JMP tube_write

INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"

.HLOIN

 LDA #&81
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &36
 JMP tube_write

.PIXEL

 PHA
 LDA #&82
 JSR tube_write
 TXA
 JSR tube_write
 PLA
 JSR tube_write
 LDA &88
 JMP tube_write

INCLUDE "library/common/main/subroutine/bline.asm"
INCLUDE "library/common/main/variable/prxs.asm"
INCLUDE "library/common/main/subroutine/status.asm"
INCLUDE "library/common/main/subroutine/plf2.asm"
INCLUDE "library/common/main/variable/tens.asm"
INCLUDE "library/common/main/subroutine/pr2.asm"
INCLUDE "library/common/main/subroutine/tt11.asm"
INCLUDE "library/common/main/subroutine/bprnt.asm"
INCLUDE "library/enhanced/main/variable/dtw1.asm"
INCLUDE "library/enhanced/main/variable/dtw2.asm"
INCLUDE "library/enhanced/main/variable/dtw3.asm"
INCLUDE "library/enhanced/main/variable/dtw4.asm"
INCLUDE "library/enhanced/main/variable/dtw5.asm"
INCLUDE "library/enhanced/main/variable/dtw6.asm"
INCLUDE "library/enhanced/main/variable/dtw8.asm"
INCLUDE "library/enhanced/main/subroutine/feed.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"

.DIL2

 PHA
 LDA #&87
 JSR tube_write
 PLA
 JSR tube_write
 LDA SC
 JSR tube_write
 LDA SC+1
 JSR tube_write
 INC SC+&01
 RTS

INCLUDE "library/enhanced/main/subroutine/hme2.asm"
INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"

.HANGER

 LDX #&02

.HAL1

 STX &84
 LDA #&82
 LDX &84
 STX &81
 JSR DVID4
 LDA #&9A
 JSR tube_write
 LDA &1B
 JSR tube_write
 LDA &85
 JSR tube_write
 LDX &84
 INX
 CPX #&0D
 BCC HAL1
 LDA #&10

.HAL6

 STA &84
 LDA #&9B
 JSR tube_write
 LDA &84
 JSR tube_write
 LDA &84
 CLC
 ADC #&10
 BNE HAL6
 RTS

INCLUDE "library/enhanced/main/subroutine/has1.asm"

.UNWISE

 LDA #&94
 JMP tube_write

INCLUDE "library/common/main/subroutine/hfs2.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/common/main/subroutine/dvid4-dvid4_duplicate.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/enhanced/main/subroutine/brief2.asm"
INCLUDE "library/enhanced/main/subroutine/brp.asm"
INCLUDE "library/enhanced/main/subroutine/brief3.asm"
INCLUDE "library/enhanced/main/subroutine/debrief2.asm"
INCLUDE "library/enhanced/main/subroutine/debrief.asm"
INCLUDE "library/enhanced/main/subroutine/brief.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/pas1.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/common/main/subroutine/tt66.asm"
INCLUDE "library/common/main/subroutine/ttx66-ttx662.asm"
INCLUDE "library/common/main/subroutine/delay.asm"

.CLYNS

 LDA #&FF
 STA DTW2
 LDA #&14
 STA YC
 JSR TT67
 LDY #&01 \INY
 STY XC
 DEY
 LDA #&84
 JMP tube_write

.WSCAN

 LDA #&85
 JSR tube_write
 JMP tube_read

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
INCLUDE "library/elite-a/docked/subroutine/sell_yn.asm"
INCLUDE "library/common/main/subroutine/gnum.asm"
INCLUDE "library/elite-a/docked/subroutine/sell_jump.asm"
INCLUDE "library/enhanced/main/subroutine/nwdav4.asm"
INCLUDE "library/common/main/subroutine/tt208.asm"
INCLUDE "library/common/main/subroutine/tt210.asm"
INCLUDE "library/common/main/subroutine/tt213.asm"
INCLUDE "library/common/main/subroutine/tt16.asm"
INCLUDE "library/common/main/subroutine/tt103.asm"
INCLUDE "library/common/main/subroutine/tt123.asm"
INCLUDE "library/common/main/subroutine/tt105.asm"
INCLUDE "library/common/main/subroutine/tt23.asm"
INCLUDE "library/common/main/subroutine/tt81.asm"
INCLUDE "library/common/main/subroutine/tt111.asm"
INCLUDE "library/common/main/subroutine/jmp.asm"
INCLUDE "library/common/main/subroutine/pr6.asm"
INCLUDE "library/common/main/subroutine/pr5.asm"
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
INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"

.update_pod

 LDA #&8F
 JSR tube_write
 LDA ESCP
 JSR tube_write
 LDA &0348
 JMP tube_write

INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
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
INCLUDE "library/common/main/subroutine/wpshps.asm"
INCLUDE "library/common/main/subroutine/flflls.asm"

.MSBAR

 LDA #&88
 JSR tube_write
 TXA
 JSR tube_write
 TYA
 JSR tube_write
 LDY #&00
 RTS

INCLUDE "library/common/main/subroutine/sun_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/sun_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/circle2.asm"
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
INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"

.INBAY

 \dead entry
 LDA #0
 STA save_lock
 STA dockedp
 JSR BRKBK
 JSR RES2
 JMP BR1

.boot_in

 LDA #0
 STA save_lock
 STA &0320
 STA &30
 STA dockedp
 JMP BEGIN

INCLUDE "library/enhanced/main/subroutine/brbr.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/enhanced/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/br1_part_1_of_2.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/common/main/subroutine/dfault-qu5.asm"
INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/check.asm"
INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/common/main/subroutine/gtnme-gtnmew.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/common/main/variable/rline.asm"
INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/enhanced/main/subroutine/zebc.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/enhanced/main/variable/ctli.asm"
INCLUDE "library/enhanced/main/variable/deli.asm"
INCLUDE "library/enhanced/main/subroutine/cats.asm"
INCLUDE "library/enhanced/main/subroutine/delt.asm"
INCLUDE "library/enhanced/main/subroutine/mebrk.asm"
INCLUDE "library/enhanced/main/subroutine/cat.asm"
INCLUDE "library/enhanced/main/subroutine/retry.asm"
INCLUDE "library/common/main/subroutine/sve.asm"
INCLUDE "library/elite-a/docked/subroutine/confirm.asm"
INCLUDE "library/common/main/subroutine/qus1.asm"
INCLUDE "library/enhanced/main/subroutine/gtdrv.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/common/main/subroutine/fx200.asm"
INCLUDE "library/common/main/subroutine/norm.asm"

.scan_fire

 LDA #&89
 JSR tube_write
 JMP tube_read

.RDKEY

 LDA #&8C
 JSR tube_write
 JSR tube_read
 TAX
 RTS

INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"

.DKS4

 LDA #&8B
 JSR tube_write
 TXA
 JSR tube_write
 JSR tube_read
 TAX
 RTS

INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"

.TT217

.t

 LDA #&8D
 JSR tube_write
 JSR tube_read
 TAX

.out

 RTS

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
INCLUDE "library/elite-a/docked/subroutine/n_buyship.asm"
INCLUDE "library/elite-a/docked/subroutine/n_load.asm"
INCLUDE "library/elite-a/docked/variable/count_offs.asm"
INCLUDE "library/elite-a/docked/subroutine/n_name.asm"
INCLUDE "library/elite-a/docked/subroutine/n_price.asm"
INCLUDE "library/elite-a/docked/subroutine/cour_buy.asm"
INCLUDE "library/elite-a/docked/subroutine/cour_dock.asm"
INCLUDE "library/elite-a/docked/subroutine/stay_here.asm"
INCLUDE "library/common/main/subroutine/gvl.asm"
INCLUDE "library/elite-a/docked/variable/new_offsets.asm"
INCLUDE "library/elite-a/docked/variable/new_ships.asm"
INCLUDE "library/elite-a/docked/variable/new_details.asm"
INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/elite-a/encyclopedia/variable/msg_3.asm"
INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/common/main/variable/qq18.asm"

.SNE

 EQUB &00, &19, &32, &4A, &62, &79, &8E, &A2, &B5, &C6, &D5, &E2
 EQUB &ED, &F5, &FB, &FF, &FF, &FF, &FB, &F5, &ED, &E2, &D5, &C6
 EQUB &B5, &A2, &8E, &79, &62, &4A, &32, &19

.ACT

 EQUB &00, &01, &03, &04, &05, &06, &08, &09, &0A, &0B, &0C, &0D
 EQUB &0F, &10, &11, &12, &13, &14, &15, &16, &17, &18, &19, &19
 EQUB &1A, &1B, &1C, &1D, &1D, &1E, &1F, &1F

.encyclopedia

 LDX #&00
 JSR menu
 CMP #&01
 BNE n_shipsag
 JMP ships_ag

.n_shipsag

 CMP #&02
 BNE n_shipskw
 JMP ships_kw

.n_shipskw

 CMP #&03
 BNE n_equipdat
 JMP equip_data

.n_equipdat

 CMP #&04
 BNE n_controls
 JMP controls

.n_controls

 CMP #&05
 BNE jmp_start3_dup
 JMP trading

.jmp_start3_dup

 \JSR dn2
 \JMP BAY
 JMP dn2

.ships_ag


.ships_kw

 PHA
 TAX
 JSR menu
 SBC #&00
 PLP
 BCS ship_over
 ADC menu_entry+1

.ship_over

 STA &8C
 CLC
 ADC #&07
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDX &8C
 LDA ship_posn,X
 TAX
 LDY #0
 JSR install_ship
 LDX &8C
 LDA ship_centre,X
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR ZINF
 LDA #&60
 STA &54
 LDA #&B0
 STA &4D
 LDX #&7F
 STX &63
 STX &64
 INX
 STA QQ17
 LDA &8C
 JSR write_card
 LDA #0
 JSR NWSHP
 JSR i_release

.i_395a

 LDX &8C
 LDA ship_dist,X
 CMP &4D
 BEQ i_3962
 DEC &4D

.i_3962

 JSR MVEIT
 LDA #&80
 STA &4C
 ASL A
 STA &46
 STA &49
 JSR LL9
 DEC &8A
 JSR check_keys
 CPX #0
 BEQ i_395a
 JMP BAY

.controls

 LDX #&03
 JSR menu
 ADC #&56
 PHA
 ADC #&04
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDA #&0B
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR MT2
 INC YC
 PLA
 JSR write_msg3
 JMP i_restart

.equip_data

 LDX #&04
 JSR menu
 ADC #&6B
 PHA
 SBC #&0C
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDA #&0B
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR MT2
 JSR MT13
 INC YC
 INC YC
 LDA #&01
 STA XC
 PLA
 JSR write_msg3
 JMP i_restart

.trading


.i_restart

 JSR check_keys
 TXA
 BEQ i_restart
 JMP BAY


.check_keys

 JSR WSCAN
 JSR RDKEY
 CPX #&69
 BNE not_freeze

.freeze_loop

 JSR WSCAN
 JSR RDKEY
 CPX #&70
 BNE dont_quit
 JMP DEATH2_FLIGHT

.dont_quit

 \CPX #&37
 \BNE dont_dump
 \JSR printer
 \dont_dump
 CPX #&59
 BNE freeze_loop

.i_release

 JSR RDKEY
 BNE i_release
 LDX #0 \ no key was pressed

.not_freeze

 RTS

INCLUDE "library/elite-a/encyclopedia/subroutine/write_card.asm"

.ship_posn

 EQUB 20, 13, 23, 12, 33, 37, 22
 EQUB 10,  1,  0,  2, 24, 21, 32
 EQUB 35, 19, 18, 30, 25, 31, 11
 EQUB  8, 17, 26, 27,  9, 16, 14

INCLUDE "library/elite-a/encyclopedia/variable/ship_dist.asm"

.menu

 LDA menu_entry,X
 STA &03AB
 LDA menu_offset,X
 STA &03AD
 LDA menu_query,X
 PHA
 LDA menu_title,X
 PHA
 LDA menu_titlex,X
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 PLA
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 INC YC
 LDX #&00

.menu_loop

 STX &89
 JSR TT67
 LDX &89
 INX
 CLC
 JSR pr2
 JSR TT162
 JSR MT2
 LDA #&80
 STA QQ17
 CLC
 LDA &89
 ADC &03AD
 JSR write_msg3
 LDX &89
 INX
 CPX &03AB
 BCC menu_loop
 JSR CLYNS
 PLA
 JSR write_msg3
 LDA #'?'
 JSR DASC
 JSR gnum
 BEQ menu_start
 BCS menu_start
 RTS

.menu_start

 JMP BAY


INCLUDE "library/elite-a/encyclopedia/variable/menu_title.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_titlex.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_offset.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_entry.asm"
INCLUDE "library/elite-a/encyclopedia/variable/menu_query.asm"
INCLUDE "library/elite-a/encyclopedia/variable/ship_centre.asm"
INCLUDE "library/elite-a/encyclopedia/variable/card_pattern.asm"
INCLUDE "library/elite-a/encyclopedia/variable/card_addr.asm"
INCLUDE "library/elite-a/encyclopedia/variable/card_data.asm"

.install_ship

 \ install ship X in position Y with flags A
 TXA
 ASL A
 PHA
 ASL A
 TAX
 LDA ship_flags,Y
 AND #&7F
 ORA ship_bytes+1,X
 STA ship_flags,Y
 TYA
 ASL A
 TAY
 PLA
 TAX
 LDA ship_list,X
 STA XX21-2,Y
 LDA ship_list+1,X
 STA XX21-1,Y
 RTS

 \printer:
 \ TXA
 \ PHA
 \ LDA #&9C
 \ JSR tube_write
 \ JSR tube_read
 \ PLA
 \ TAX
 \ RTS


\ a.qcode_5

.DOENTRY_FLIGHT

 JSR RES2
 JMP DOENTRY

.DEATH2_FLIGHT

 JSR RES2
 JMP INBAY

INCLUDE "library/common/main/subroutine/main_flight_loop_part_1_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_2_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_3_of_16.asm"
INCLUDE "library/common/main/subroutine/main_flight_loop_part_4_of_16.asm"
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
INCLUDE "library/enhanced/main/subroutine/spin.asm"


.PIX1

 JSR ADD
 STA &27
 TXA
 STA &0F95,Y

.PIXEL2

 LDA &34
 BPL d_1919
 EOR #&7F
 CLC
 ADC #&01

.d_1919

 EOR #&80
 TAX
 LDA &35
 AND #&7F
 CMP #&60
 BCS d_196a
 LDA &35
 BPL d_192c
 EOR #&7F
 ADC #&01

.d_192c

 STA &D1
 LDA #&61
 SBC &D1
 JMP PIXEL

.d_196a

 RTS

INCLUDE "library/common/main/subroutine/flip.asm"
INCLUDE "library/common/main/subroutine/stars.asm"
INCLUDE "library/common/main/subroutine/stars1.asm"
INCLUDE "library/common/main/subroutine/stars6.asm"
INCLUDE "library/common/main/subroutine/mas1.asm"
INCLUDE "library/common/main/subroutine/mas2.asm"
INCLUDE "library/common/main/subroutine/mas3.asm"
INCLUDE "library/common/main/subroutine/mvt3.asm"
INCLUDE "library/common/main/subroutine/escape.asm"
INCLUDE "library/common/main/subroutine/tactics_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/tactics_part_7_of_7.asm"
INCLUDE "library/enhanced/main/subroutine/dockit.asm"
INCLUDE "library/enhanced/main/subroutine/vcsu1.asm"
INCLUDE "library/enhanced/main/subroutine/vcsub.asm"
INCLUDE "library/common/main/subroutine/tas1.asm"
INCLUDE "library/enhanced/main/subroutine/tas4.asm"
INCLUDE "library/enhanced/main/subroutine/tas6.asm"
INCLUDE "library/enhanced/main/subroutine/dcs1.asm"
INCLUDE "library/common/main/subroutine/hitch.asm"
INCLUDE "library/common/main/subroutine/frs1.asm"
INCLUDE "library/common/main/subroutine/frmis.asm"

.anger_8c

 LDA &8C

INCLUDE "library/common/main/subroutine/angry.asm"
INCLUDE "library/common/main/subroutine/fr1.asm"
INCLUDE "library/common/main/subroutine/sescp.asm"
INCLUDE "library/common/main/subroutine/sfs1.asm"
INCLUDE "library/common/main/subroutine/sfs2.asm"
INCLUDE "library/common/main/subroutine/ll164.asm"
INCLUDE "library/common/main/subroutine/laun.asm"

.HFS2

 STA &95
 JSR TTX66
 JMP HFS1

INCLUDE "library/common/main/subroutine/stars2.asm"
INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/original/main/subroutine/unused_duplicate_of_multu.asm"
INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"
INCLUDE "library/common/main/subroutine/tas3.asm"
INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
INCLUDE "library/elite-a/flight/subroutine/tnpr_flight.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/ee3.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"

.hyp1_FLIGHT

 JSR jmp                \ duplicate of hyp1
 LDX #&05

.d_31b0

 LDA &6C,X
 STA &03B2,X
 DEX
 BPL d_31b0
 INX
 STX &0349
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov

 JSR DORND
 STA QQ26
 JMP GVL

INCLUDE "library/common/main/subroutine/gthg.asm"
INCLUDE "library/common/main/subroutine/mjp.asm"
INCLUDE "library/common/main/subroutine/tt18.asm"
INCLUDE "library/common/main/subroutine/tt110.asm"
INCLUDE "library/common/main/subroutine/tt114.asm"

.write_0346

 PHA
 LDA #&97
 JSR tube_write
 PLA
 JMP tube_write

.read_0346

 LDA #&98
 JSR tube_write
 JSR tube_read
 STA &0346
 RTS

INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"
INCLUDE "library/common/main/subroutine/solar.asm"
INCLUDE "library/common/main/subroutine/nwstars.asm"
INCLUDE "library/common/main/subroutine/nwq.asm"

.WPSHPS2

 JMP WPSHPS

.DET1

 LDA #&95
 JSR tube_write
 TXA
 JMP tube_write

INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"
INCLUDE "library/common/main/subroutine/compas.asm"
INCLUDE "library/common/main/subroutine/sp2.asm"
INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix4.asm"

.CPIX2

 LDA #&90
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &91
 JMP tube_write

.OOPS2

 SEC \ reduce damage
 SBC new_shields
 BCC n_shok

INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"

.ECBLB

 LDA #&93
 JMP tube_write

.SPBLB

 LDA #&92
 JMP tube_write

.MSBAR2

 CPX #4
 BCC n_mok
 LDX #3

.n_mok

 JMP MSBAR

INCLUDE "library/common/main/subroutine/proj.asm"
INCLUDE "library/common/main/subroutine/pl2.asm"
INCLUDE "library/common/main/subroutine/planet.asm"
INCLUDE "library/common/main/subroutine/pl9_part_1_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_2_of_3.asm"
INCLUDE "library/common/main/subroutine/pl9_part_3_of_3.asm"
INCLUDE "library/common/main/subroutine/pls1.asm"
INCLUDE "library/common/main/subroutine/pls2.asm"
INCLUDE "library/common/main/subroutine/pls22.asm"
INCLUDE "library/common/main/subroutine/circle.asm"
INCLUDE "library/common/main/subroutine/wpls2.asm"
INCLUDE "library/common/main/subroutine/wp1.asm"
INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"

.PL21_FLIGHT

 SEC
 RTS

INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"
INCLUDE "library/common/main/subroutine/killshp.asm"

.rand_posn

 JSR ZINF
 JSR DORND
 STA &46
 STX &49
 STA &06
 LSR A
 ROR &48
 LSR A
 ROR &4B
 LSR A
 STA &4A
 TXA
 AND #&1F
 STA &47
 LDA #&50
 SBC &47
 SBC &4A
 STA &4D
 JMP DORND

INCLUDE "library/enhanced/main/subroutine/there.asm"
INCLUDE "library/common/main/subroutine/ze.asm"

.DORND2

 CLC
 JMP DORND

INCLUDE "library/common/main/subroutine/main_game_loop_part_1_of_6.asm"

.d_3fc0

 JSR M%
 DEC &034A
 BEQ d_3f54
 BPL d_3fcd
 INC &034A

.d_3fcd

 DEC &8A
 BEQ d_3fd4

.d_3fd1

 JMP MLOOP_FLIGHT

.d_3f54

 LDA &03A4
 JSR MESS
 LDA #&00
 STA &034A
 JMP d_3fcd

.d_3fd4

 LDA &0341
 BNE d_3fd1
 JSR DORND
 CMP #&33 \ trader fraction
 BCS MTT1
 LDA &033E
 CMP #&03
 BCS MTT1
 JSR rand_posn \ IN
 BVS MTT4
 ORA #&6F
 STA &63
 LDA &0320
 BNE MLOOPS
 TXA
 BCS d_401e
 AND #&0F
 STA &61
 BCC d_4022

.d_401e

 ORA #&7F
 STA &64

.d_4022

 JSR DORND
 CMP #&0A
 AND #&01
 ADC #&05
 BNE horde_plain

INCLUDE "library/common/main/subroutine/main_game_loop_part_3_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_4_of_6.asm"

.MLOOP_FLIGHT

 LDX #&FF
 TXS
 LDX GNTMP
 BEQ d_40e6
 DEC GNTMP

.d_40e6

 JSR DIALS
 JSR COMPAS
 LDA &87
 BEQ d_40f8
 \ AND PATG
 \ LSR A
 \ BCS d_40f8
 LDY #&02
 JSR DELAY
 \ JSR WSCAN

.d_40f8

 JSR d_44af
 JSR chk_dirn

.FRCE_FLIGHT

 PHA
 LDA &2F
 BNE d_locked
 PLA
 JSR TT102
 JMP d_3fc0

.d_locked

 PLA
 JSR d_416c
 JMP d_3fc0

INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/common/main/subroutine/farof.asm"
INCLUDE "library/common/main/subroutine/farof2.asm"
INCLUDE "library/common/main/subroutine/mas4.asm"
INCLUDE "library/common/main/subroutine/death.asm"
INCLUDE "library/disc/flight/subroutine/rships.asm"


.LSHIPS

 LDA #0
 STA &9F \ reset finder

.SHIPinA

 LDX #&00
 LDA tek
 CMP #&0A
 BCS mix_station
 INX

.mix_station

 LDY #&02
 JSR install_ship
 LDY #9

.mix_retry

 LDA #0
 STA &34

.mix_match

 JSR DORND
 CMP #ship_total \ # POSSIBLE SHIPS
 BCS mix_match
 ASL A
 ASL A
 STA &35
 TYA
 AND #&07
 TAX
 LDA mix_bits,X
 LDX &35
 CPY #16
 BCC mix_byte2
 CPY #24
 BCC mix_byte3
 INX \24-28

.mix_byte3

 INX \16-23

.mix_byte2

 INX \8-15
 AND ship_bits,X
 BEQ mix_fail

.mix_try

 JSR DORND
 LDX &35
 CMP ship_bytes,X
 BCC mix_ok

.mix_fail

 DEC &34
 BNE mix_match
 LDX #ship_total*4

.mix_ok

 STY &36
 CPX #52  \ ANACONDA?
 BEQ mix_anaconda
 CPX #116 \ DRAGON?
 BEQ mix_dragon
 TXA
 LSR A
 LSR A
 TAX

.mix_install

 JSR install_ship
 LDY &36

.mix_next

 INY
 CPY #15
 BNE mix_skip
 INY
 INY

.mix_skip

 CPY #29
 BNE mix_retry
 RTS

.mix_anaconda

 LDX #13
 LDY #14
 JSR install_ship
 LDX #14
 LDY #15
 JMP mix_install

.mix_dragon

 LDX #29
 LDY #14
 JSR install_ship
 LDX #17
 LDY #15
 JMP mix_install

.mix_bits

 EQUB &01, &02, &04, &08, &10, &20, &40, &80

INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/exno3.asm"
INCLUDE "library/common/main/subroutine/sfrmis.asm"
INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"

.DKS1

 LDA #&96
 JSR tube_write
 TYA
 JSR tube_write
 LDA BSTK
 JSR tube_write
 JSR tube_read
 BPL b_quit
 STA KL,Y

.b_quit

 RTS

.d_4473

 LDA &033F
 BNE d_44c7
 LDY #&01
 JSR DKS1
 INY
 JSR DKS1
 JSR scan_fire
 EOR #&10
 STA &0307
 LDX #&01
 JSR DKS2
 ORA #&01
 STA JSTX
 LDX #&02
 JSR DKS2
 EOR JSTGY
 STA JSTY
 JMP d_4555

.U%

 LDA #&00
 LDY #&10

.d_44a8

 STA KL,Y
 DEY
 BNE d_44a8
 RTS

.d_44af

 JSR U%
 LDA &2F
 BEQ d_open
 JMP d_4555

.d_open

 LDA JSTK
 BNE d_4473
 LDY #&07

.d_44bc

 JSR DKS1
 DEY
 BNE d_44bc
 LDA &033F
 BEQ d_4526

.d_44c7

 JSR ZINF
 LDA #&60
 STA &54
 ORA #&80
 STA &5C
 STA &8C
 LDA &7D \ ? Too Fast
 STA &61
 JSR DOCKIT
 LDA &61
 CMP #&16
 BCC d_44e3
 LDA #&16

.d_44e3

 STA &7D
 LDA #&FF
 LDX #&00
 LDY &62
 BEQ d_44f3
 BMI d_44f0
 INX

.d_44f0

 STA &0301,X

.d_44f3

 LDA #&80
 LDX #&00
 ASL &63
 BEQ d_450f
 BCC d_44fe
 INX

.d_44fe

 BIT &63
 BPL d_4509
 LDA #&40
 STA JSTX
 LDA #&00

.d_4509

 STA &0303,X
 LDA JSTX

.d_450f

 STA JSTX
 LDA #&80
 LDX #&00
 ASL &64
 BEQ d_4523
 BCS d_451d
 INX

.d_451d

 STA &0305,X
 LDA JSTY

.d_4523

 STA JSTY

.d_4526

 LDX JSTX
 LDA #&07
 LDY &0303
 BEQ d_4533
 JSR BUMP2

.d_4533

 LDY &0304
 BEQ d_453b
 JSR REDU2

.d_453b

 STX JSTX
 ASL A
 LDX JSTY
 LDY &0305
 BEQ d_454a
 JSR REDU2

.d_454a

 LDY &0306
 BEQ d_4552
 JSR BUMP2

.d_4552

 STX JSTY

.d_4555

 JSR RDKEY
 STX KL
 CPX #&69
 BNE d_459c

.d_455f

 JSR WSCAN
 JSR RDKEY
 CPX #&51
 BNE d_456e
 LDA #&00
 STA DNOIZ

.d_456e

 LDY #&40

.d_4570

 JSR DKS3
 INY
 CPY #&48
 BNE d_4570
 CPX #&10
 BNE d_457f
 STX DNOIZ

.d_457f

 CPX #&70
 BNE d_4586
 JMP DEATH2_FLIGHT

.d_4586

 \ CPX #&37
 \ BNE dont_dump
 \ JSR printer
 \dont_dump
 CPX #&59
 BNE d_455f

.d_459c

 LDA &87
 BNE DK5
 LDY #&10

.d_45a4

 JSR DKS1
 DEY
 CPY #&07
 BNE d_45a4

.DK5

 RTS

.d_45b5

 STX &034A
 PHA
 LDA &03A4
 JSR d_45dd
 PLA
 EQUB &2C

.cargo_mtok

 ADC #&D0

.MESS

 LDX #&00
 STX QQ17
 LDY #&09
 STY XC
 LDY #&16
 STY YC
 CPX &034A
 BNE d_45b5
 STY &034A
 STA &03A4

.d_45dd

 JSR TT27
 LSR &034B
 BCC DK5
 LDA #&FD
 JMP TT27

INCLUDE "library/common/main/subroutine/ouch.asm"

.d_4889

 JMP PLANET

.LL9_FLIGHT

 LDA &8C
 BMI d_4889
 JMP LL9

.MVEIT_FLIGHT

 LDA &65
 AND #&A0
 BNE MV30
 LDA &8A
 EOR &84
 AND #&0F
 BNE P%+5
 JSR TIDY

INCLUDE "library/common/main/subroutine/mveit_part_2_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_3_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_4_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_5_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_6_of_9.asm"
INCLUDE "library/common/main/subroutine/mvt1.asm"
INCLUDE "library/common/main/subroutine/mvt6.asm"
INCLUDE "library/common/main/subroutine/mv40.asm"
INCLUDE "library/common/main/subroutine/plut-pu1.asm"
INCLUDE "library/common/main/subroutine/look1.asm"
INCLUDE "library/common/main/subroutine/sight.asm"

.iff_xor

 EQUB &00, &00, &0F \, &FF, &F0 overlap

.iff_base

 EQUB &FF, &F0, &FF, &F0, &FF

.d_5557

 RTS

.SCAN

 LDA &65
 AND #&10
 BEQ d_5557
 LDA &8C
 BMI d_5557
 LDX CRGO \ iff code
 BEQ iff_not
 LDY #&24
 LDA (&20),Y
 ASL A
 ASL A
 BCS iff_cop
 ASL A
 BCS iff_trade
 LDY &8C
 DEY
 BEQ iff_missle
 CPY #&08
 BCC iff_aster
 INX \ X=4

.iff_missle

 INX \ X=3

.iff_aster

 INX \ X=2

.iff_cop

 INX \ X=1

.iff_trade

 INX \ X=0

.iff_not

 LDA iff_base,X
 STA &91
 LDA iff_xor,X
 STA &37
 LDA &47
 ORA &4A
 ORA &4D
 AND #&C0
 BNE d_5557
 LDA &47
 CLC
 LDX &48
 BPL d_5581
 EOR #&FF
 ADC #&01

.d_5581

 ADC #&7B
 STA &34
 LDA &4D
 LSR A
 LSR A
 CLC
 LDX &4E
 BPL d_5591
 EOR #&FF
 SEC

.d_5591

 ADC #&23
 EOR #&FF
 STA SC
 LDA &4A
 LSR A
 CLC
 LDX &4B
 BMI d_55a2
 EOR #&FF
 SEC

.d_55a2

 ADC SC
 BPL d_55b0
 CMP #&C2
 BCS d_55ac
 LDA #&C2

.d_55ac

 CMP #&F7
 BCC d_55b2

.d_55b0

 LDA #&F6

.d_55b2

 STA &35
 SEC
 SBC SC
 TAX
 LDA #&91
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &91
 JSR tube_write
 LDA &37
 JSR tube_write
 TXA
 JSR tube_write
 LDX #0
 RTS

\ a.qship_1

.s_dodo

 EQUB &00, &90, &7E, &A4, &2C, &61, &00, &36, &90, &22, &00, &00
 EQUB &30, &7D, &F0, &00, &00, &01, &00, &00, &00, &96, &C4, &1F
 EQUB &01, &55, &8F, &2E, &C4, &1F, &01, &22, &58, &79, &C4, &5F
 EQUB &02, &33, &58, &79, &C4, &DF, &03, &44, &8F, &2E, &C4, &9F
 EQUB &04, &55, &00, &F3, &2E, &1F, &15, &66, &E7, &4B, &2E, &1F
 EQUB &12, &77, &8F, &C4, &2E, &5F, &23, &88, &8F, &C4, &2E, &DF
 EQUB &34, &99, &E7, &4B, &2E, &9F, &45, &AA, &8F, &C4, &2E, &3F
 EQUB &16, &77, &E7, &4B, &2E, &7F, &27, &88, &00, &F3, &2E, &7F
 EQUB &38, &99, &E7, &4B, &2E, &FF, &49, &AA, &8F, &C4, &2E, &BF
 EQUB &56, &AA, &58, &79, &C4, &3F, &67, &BB, &8F, &2E, &C4, &7F
 EQUB &78, &BB, &00, &96, &C4, &7F, &89, &BB, &8F, &2E, &C4, &FF
 EQUB &9A, &BB, &58, &79, &C4, &BF, &6A, &BB, &10, &20, &C4, &9E
 EQUB &00, &00, &10, &20, &C4, &DE, &00, &00, &10, &20, &C4, &17
 EQUB &00, &00, &10, &20, &C4, &57, &00, &00, &1F, &01, &00, &04
 EQUB &1F, &02, &04, &08, &1F, &03, &08, &0C, &1F, &04, &0C, &10
 EQUB &1F, &05, &10, &00, &1F, &16, &14, &28, &1F, &17, &28, &18
 EQUB &1F, &27, &18, &2C, &1F, &28, &2C, &1C, &1F, &38, &1C, &30
 EQUB &1F, &39, &30, &20, &1F, &49, &20, &34, &1F, &4A, &34, &24
 EQUB &1F, &5A, &24, &38, &1F, &56, &38, &14, &1F, &7B, &3C, &40
 EQUB &1F, &8B, &40, &44, &1F, &9B, &44, &48, &1F, &AB, &48, &4C
 EQUB &1F, &6B, &4C, &3C, &1F, &15, &00, &14, &1F, &12, &04, &18
 EQUB &1F, &23, &08, &1C, &1F, &34, &0C, &20, &1F, &45, &10, &24
 EQUB &1F, &67, &28, &3C, &1F, &78, &2C, &40, &1F, &89, &30, &44
 EQUB &1F, &9A, &34, &48, &1F, &6A, &38, &4C, &1E, &00, &50, &54
 EQUB &14, &00, &54, &5C, &17, &00, &5C, &58, &14, &00, &58, &50
 EQUB &1F, &00, &00, &C4, &1F, &67, &8E, &58, &5F, &A9, &37, &59
 EQUB &5F, &00, &B0, &58, &DF, &A9, &37, &59, &9F, &67, &8E, &58
 EQUB &3F, &00, &B0, &58, &3F, &A9, &37, &59, &7F, &67, &8E, &58
 EQUB &FF, &67, &8E, &58, &BF, &A9, &37, &59, &3F, &00, &00, &C4


.s_coriolis

 EQUB &00, &00, &64, &74, &E4, &55, &00, &36, &60, &1C, &00, &00
 EQUB &38, &78, &F0, &00, &00, &00, &00, &06, &A0, &00, &A0, &1F
 EQUB &10, &62, &00, &A0, &A0, &1F, &20, &83, &A0, &00, &A0, &9F
 EQUB &30, &74, &00, &A0, &A0, &5F, &10, &54, &A0, &A0, &00, &5F
 EQUB &51, &A6, &A0, &A0, &00, &1F, &62, &B8, &A0, &A0, &00, &9F
 EQUB &73, &C8, &A0, &A0, &00, &DF, &54, &97, &A0, &00, &A0, &3F
 EQUB &A6, &DB, &00, &A0, &A0, &3F, &B8, &DC, &A0, &00, &A0, &BF
 EQUB &97, &DC, &00, &A0, &A0, &7F, &95, &DA, &0A, &1E, &A0, &5E
 EQUB &00, &00, &0A, &1E, &A0, &1E, &00, &00, &0A, &1E, &A0, &9E
 EQUB &00, &00, &0A, &1E, &A0, &DE, &00, &00, &1F, &10, &00, &0C
 EQUB &1F, &20, &00, &04, &1F, &30, &04, &08, &1F, &40, &08, &0C
 EQUB &1F, &51, &0C, &10, &1F, &61, &00, &10, &1F, &62, &00, &14
 EQUB &1F, &82, &14, &04, &1F, &83, &04, &18, &1F, &73, &08, &18
 EQUB &1F, &74, &08, &1C, &1F, &54, &0C, &1C, &1F, &DA, &20, &2C
 EQUB &1F, &DB, &20, &24, &1F, &DC, &24, &28, &1F, &D9, &28, &2C
 EQUB &1F, &A5, &10, &2C, &1F, &A6, &10, &20, &1F, &B6, &14, &20
 EQUB &1F, &B8, &14, &24, &1F, &C8, &18, &24, &1F, &C7, &18, &28
 EQUB &1F, &97, &1C, &28, &1F, &95, &1C, &2C, &1E, &00, &30, &34
 EQUB &1E, &00, &34, &38, &1E, &00, &38, &3C, &1E, &00, &3C, &30
 EQUB &1F, &00, &00, &A0, &5F, &6B, &6B, &6B, &1F, &6B, &6B, &6B
 EQUB &9F, &6B, &6B, &6B, &DF, &6B, &6B, &6B, &5F, &00, &A0, &00
 EQUB &1F, &A0, &00, &00, &9F, &A0, &00, &00, &1F, &00, &A0, &00
 EQUB &FF, &6B, &6B, &6B, &7F, &6B, &6B, &6B, &3F, &6B, &6B, &6B
 EQUB &BF, &6B, &6B, &6B, &3F, &00, &00, &A0


.s_escape

 EQUB &20, &00, &01, &2C, &44, &19, &00, &16, &18, &06, &00, &00
 EQUB &10, &08, &08, &08, &00, &00, &04, &00, &07, &00, &24, &9F
 EQUB &12, &33, &07, &0E, &0C, &FF, &02, &33, &07, &0E, &0C, &BF
 EQUB &01, &33, &15, &00, &00, &1F, &01, &22, &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08, &1F, &01, &08, &0C, &1F, &12, &0C, &00
 EQUB &1F, &13, &00, &08, &1F, &02, &0C, &04, &3F, &34, &00, &7A
 EQUB &1F, &27, &67, &1E, &5F, &27, &67, &1E, &9F, &70, &00, &00


.s_alloys

 EQUB &80, &64, &00, &2C, &3C, &11, &00, &0A, &18, &04, &01, &00
 EQUB &04, &05, &08, &10, &00, &00, &03, &00, &0F, &16, &09, &FF
 EQUB &FF, &FF, &0F, &26, &09, &BF, &FF, &FF, &13, &20, &0B, &14
 EQUB &FF, &FF, &0A, &2E, &06, &54, &FF, &FF, &1F, &FF, &00, &04
 EQUB &10, &FF, &04, &08, &14, &FF, &08, &0C, &10, &FF, &0C, &00
 EQUB &00, &00, &00, &00


.s_barrel

 EQUB &00, &90, &01, &50, &8C, &31, &00, &12, &3C, &0F, &01, &00
 EQUB &1C, &0C, &08, &0F, &00, &00, &02, &00, &18, &10, &00, &1F
 EQUB &10, &55, &18, &05, &0F, &1F, &10, &22, &18, &0D, &09, &5F
 EQUB &20, &33, &18, &0D, &09, &7F, &30, &44, &18, &05, &0F, &3F
 EQUB &40, &55, &18, &10, &00, &9F, &51, &66, &18, &05, &0F, &9F
 EQUB &21, &66, &18, &0D, &09, &DF, &32, &66, &18, &0D, &09, &FF
 EQUB &43, &66, &18, &05, &0F, &BF, &54, &66, &1F, &10, &00, &04
 EQUB &1F, &20, &04, &08, &1F, &30, &08, &0C, &1F, &40, &0C, &10
 EQUB &1F, &50, &00, &10, &1F, &51, &00, &14, &1F, &21, &04, &18
 EQUB &1F, &32, &08, &1C, &1F, &43, &0C, &20, &1F, &54, &10, &24
 EQUB &1F, &61, &14, &18, &1F, &62, &18, &1C, &1F, &63, &1C, &20
 EQUB &1F, &64, &20, &24, &1F, &65, &24, &14, &1F, &60, &00, &00
 EQUB &1F, &00, &29, &1E, &5F, &00, &12, &30, &5F, &00, &33, &00
 EQUB &7F, &00, &12, &30, &3F, &00, &29, &1E, &9F, &60, &00, &00


.s_thargoid

 EQUB &00, &49, &26, &8C, &F4, &65, &3C, &26, &78, &1A, &F4, &01
 EQUB &28, &37, &FD, &27, &00, &00, &02, &38, &20, &30, &30, &5F
 EQUB &40, &88, &20, &44, &00, &5F, &10, &44, &20, &30, &30, &7F
 EQUB &21, &44, &20, &00, &44, &3F, &32, &44, &20, &30, &30, &3F
 EQUB &43, &55, &20, &44, &00, &1F, &54, &66, &20, &30, &30, &1F
 EQUB &64, &77, &20, &00, &44, &1F, &74, &88, &18, &74, &74, &DF
 EQUB &80, &99, &18, &A4, &00, &DF, &10, &99, &18, &74, &74, &FF
 EQUB &21, &99, &18, &00, &A4, &BF, &32, &99, &18, &74, &74, &BF
 EQUB &53, &99, &18, &A4, &00, &9F, &65, &99, &18, &74, &74, &9F
 EQUB &76, &99, &18, &00, &A4, &9F, &87, &99, &18, &40, &50, &9E
 EQUB &99, &99, &18, &40, &50, &BE, &99, &99, &18, &40, &50, &FE
 EQUB &99, &99, &18, &40, &50, &DE, &99, &99, &1F, &84, &00, &1C
 EQUB &1F, &40, &00, &04, &1F, &41, &04, &08, &1F, &42, &08, &0C
 EQUB &1F, &43, &0C, &10, &1F, &54, &10, &14, &1F, &64, &14, &18
 EQUB &1F, &74, &18, &1C, &1F, &80, &00, &20, &1F, &10, &04, &24
 EQUB &1F, &21, &08, &28, &1F, &32, &0C, &2C, &1F, &53, &10, &30
 EQUB &1F, &65, &14, &34, &1F, &76, &18, &38, &1F, &87, &1C, &3C
 EQUB &1F, &98, &20, &3C, &1F, &90, &20, &24, &1F, &91, &24, &28
 EQUB &1F, &92, &28, &2C, &1F, &93, &2C, &30, &1F, &95, &30, &34
 EQUB &1F, &96, &34, &38, &1F, &97, &38, &3C, &1E, &99, &40, &44
 EQUB &1E, &99, &48, &4C, &5F, &67, &3C, &19, &7F, &67, &3C, &19
 EQUB &7F, &67, &19, &3C, &3F, &67, &19, &3C, &1F, &40, &00, &00
 EQUB &3F, &67, &3C, &19, &1F, &67, &3C, &19, &1F, &67, &19, &3C
 EQUB &5F, &67, &19, &3C, &9F, &30, &00, &00


.s_thargon

 EQUB &F0, &40, &06, &8C, &50, &41, &00, &12, &3C, &0F, &32, &00
 EQUB &1C, &14, &21, &1E, &FE, &00, &02, &20, &09, &00, &28, &9F
 EQUB &01, &55, &09, &26, &0C, &DF, &01, &22, &09, &18, &20, &FF
 EQUB &02, &33, &09, &18, &20, &BF, &03, &44, &09, &26, &0C, &9F
 EQUB &04, &55, &09, &00, &08, &3F, &15, &66, &09, &0A, &0F, &7F
 EQUB &12, &66, &09, &06, &1A, &7F, &23, &66, &09, &06, &1A, &3F
 EQUB &34, &66, &09, &0A, &0F, &3F, &45, &66, &9F, &24, &00, &00
 EQUB &5F, &14, &05, &07, &7F, &2E, &2A, &0E, &3F, &24, &00, &68
 EQUB &3F, &2E, &2A, &0E, &1F, &14, &05, &07, &1F, &24, &00, &00


.s_boulder

 EQUB &00, &84, &03, &3E, &7A, &2D, &00, &0E, &2A, &0F, &01, &00
 EQUB &28, &14, &10, &1E, &00, &00, &02, &00, &12, &25, &0B, &BF
 EQUB &01, &59, &1E, &07, &0C, &1F, &12, &56, &1C, &07, &0C, &7F
 EQUB &23, &67, &02, &00, &27, &3F, &34, &78, &1C, &22, &1E, &BF
 EQUB &04, &89, &05, &0A, &0D, &5F, &FF, &FF, &14, &11, &1E, &3F
 EQUB &FF, &FF, &1F, &15, &00, &04, &1F, &26, &04, &08, &1F, &37
 EQUB &08, &0C, &1F, &48, &0C, &10, &1F, &09, &10, &00, &1F, &01
 EQUB &00, &14, &1F, &12, &04, &14, &1F, &23, &08, &14, &1F, &34
 EQUB &0C, &14, &1F, &04, &10, &14, &1F, &59, &00, &18, &1F, &56
 EQUB &04, &18, &1F, &67, &08, &18, &1F, &78, &0C, &18, &1F, &89
 EQUB &10, &18, &DF, &0F, &03, &08, &9F, &07, &0C, &1E, &5F, &20
 EQUB &2F, &18, &FF, &03, &27, &07, &FF, &05, &04, &01, &1F, &31
 EQUB &54, &08, &3F, &70, &15, &15, &7F, &4C, &23, &52, &3F, &16
 EQUB &38, &89, &3F, &28, &6E, &26


.s_asteroid

 EQUB &00, &00, &19, &4A, &9E, &41, &00, &22, &36, &15, &0F, &00
 EQUB &38, &32, &38, &1E, &00, &00, &01, &00, &00, &50, &00, &1F
 EQUB &FF, &FF, &50, &0A, &00, &DF, &FF, &FF, &00, &50, &00, &5F
 EQUB &FF, &FF, &46, &28, &00, &5F, &FF, &FF, &3C, &32, &00, &1F
 EQUB &65, &DC, &32, &00, &3C, &1F, &FF, &FF, &28, &00, &46, &9F
 EQUB &10, &32, &00, &1E, &4B, &3F, &FF, &FF, &00, &32, &3C, &7F
 EQUB &98, &BA, &1F, &72, &00, &04, &1F, &D6, &00, &10, &1F, &C5
 EQUB &0C, &10, &1F, &B4, &08, &0C, &1F, &A3, &04, &08, &1F, &32
 EQUB &04, &18, &1F, &31, &08, &18, &1F, &41, &08, &14, &1F, &10
 EQUB &14, &18, &1F, &60, &00, &14, &1F, &54, &0C, &14, &1F, &20
 EQUB &00, &18, &1F, &65, &10, &14, &1F, &A8, &04, &20, &1F, &87
 EQUB &04, &1C, &1F, &D7, &00, &1C, &1F, &DC, &10, &1C, &1F, &C9
 EQUB &0C, &1C, &1F, &B9, &0C, &20, &1F, &BA, &08, &20, &1F, &98
 EQUB &1C, &20, &1F, &09, &42, &51, &5F, &09, &42, &51, &9F, &48
 EQUB &40, &1F, &DF, &40, &49, &2F, &5F, &2D, &4F, &41, &1F, &87
 EQUB &0F, &23, &1F, &26, &4C, &46, &BF, &42, &3B, &27, &FF, &43
 EQUB &0F, &50, &7F, &42, &0E, &4B, &FF, &46, &50, &28, &7F, &3A
 EQUB &66, &33, &3F, &51, &09, &43, &3F, &2F, &5E, &3F


.s_minerals

 EQUB &B0, &00, &01, &5A, &44, &19, &00, &16, &18, &06, &01, &00
 EQUB &10, &08, &10, &0A, &FE, &00, &05, &00, &18, &19, &10, &DF
 EQUB &12, &33, &00, &0C, &0A, &3F, &02, &33, &0B, &06, &02, &5F
 EQUB &01, &33, &0C, &2A, &07, &1F, &01, &22, &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08, &1F, &01, &08, &0C, &1F, &12, &0C, &00


.s_shuttle1

 EQUB &0F, &C4, &09, &86, &FE, &6D, &00, &26, &72, &1E, &00, &00
 EQUB &34, &16, &20, &08, &00, &00, &02, &00, &00, &23, &2F, &5F
 EQUB &FF, &FF, &23, &00, &2F, &9F, &FF, &FF, &00, &23, &2F, &1F
 EQUB &FF, &FF, &23, &00, &2F, &1F, &FF, &FF, &28, &28, &35, &FF
 EQUB &12, &39, &28, &28, &35, &BF, &34, &59, &28, &28, &35, &3F
 EQUB &56, &79, &28, &28, &35, &7F, &17, &89, &0A, &00, &35, &30
 EQUB &99, &99, &00, &05, &35, &70, &99, &99, &0A, &00, &35, &A8
 EQUB &99, &99, &00, &05, &35, &28, &99, &99, &00, &11, &47, &50
 EQUB &0A, &BC, &05, &02, &3D, &46, &FF, &02, &07, &17, &31, &07
 EQUB &01, &F4, &15, &09, &31, &07, &A1, &3F, &05, &02, &3D, &C6
 EQUB &6B, &23, &07, &17, &31, &87, &F8, &C0, &15, &09, &31, &87
 EQUB &4F, &18, &1F, &02, &00, &04, &1F, &4A, &04, &08, &1F, &6B
 EQUB &08, &0C, &1F, &8C, &00, &0C, &1F, &18, &00, &1C, &18, &12
 EQUB &00, &10, &1F, &23, &04, &10, &18, &34, &04, &14, &1F, &45
 EQUB &08, &14, &0C, &56, &08, &18, &1F, &67, &0C, &18, &18, &78
 EQUB &0C, &1C, &1F, &39, &10, &14, &1F, &59, &14, &18, &1F, &79
 EQUB &18, &1C, &1F, &19, &10, &1C, &10, &0C, &00, &30, &10, &0A
 EQUB &04, &30, &10, &AB, &08, &30, &10, &BC, &0C, &30, &10, &99
 EQUB &20, &24, &06, &99, &24, &28, &08, &99, &28, &2C, &06, &99
 EQUB &20, &2C, &04, &BB, &34, &38, &07, &BB, &38, &3C, &06, &BB
 EQUB &34, &3C, &04, &AA, &40, &44, &07, &AA, &44, &48, &06, &AA
 EQUB &40, &48, &DF, &6E, &6E, &50, &5F, &00, &95, &07, &DF, &66
 EQUB &66, &2E, &9F, &95, &00, &07, &9F, &66, &66, &2E, &1F, &00
 EQUB &95, &07, &1F, &66, &66, &2E, &1F, &95, &00, &07, &5F, &66
 EQUB &66, &2E, &3F, &00, &00, &D5, &9F, &51, &51, &B1, &1F, &51
 EQUB &51, &B1, &5F, &6E, &6E, &50


.s_transporter

 EQUB &00, &C4, &09, &F2, &AA, &91, &30, &1A, &DE, &2E, &00, &00
 EQUB &38, &10, &20, &0A, &00, &01, &01, &00, &00, &13, &33, &3F
 EQUB &06, &77, &33, &07, &33, &BF, &01, &77, &39, &07, &33, &FF
 EQUB &01, &22, &33, &11, &33, &FF, &02, &33, &33, &11, &33, &7F
 EQUB &03, &44, &39, &07, &33, &7F, &04, &55, &33, &07, &33, &3F
 EQUB &05, &66, &00, &0C, &18, &12, &FF, &FF, &3C, &02, &18, &DF
 EQUB &17, &89, &42, &11, &18, &DF, &12, &39, &42, &11, &18, &5F
 EQUB &34, &5A, &3C, &02, &18, &5F, &56, &AB, &16, &05, &3D, &DF
 EQUB &89, &CD, &1B, &11, &3D, &DF, &39, &DD, &1B, &11, &3D, &5F
 EQUB &3A, &DD, &16, &05, &3D, &5F, &AB, &CD, &0A, &0B, &05, &86
 EQUB &77, &77, &24, &05, &05, &86, &77, &77, &0A, &0D, &0E, &A6
 EQUB &77, &77, &24, &07, &0E, &A6, &77, &77, &17, &0C, &1D, &A6
 EQUB &77, &77, &17, &0A, &0E, &A6, &77, &77, &0A, &0F, &1D, &26
 EQUB &66, &66, &24, &09, &1D, &26, &66, &66, &17, &0A, &0E, &26
 EQUB &66, &66, &0A, &0C, &06, &26, &66, &66, &24, &06, &06, &26
 EQUB &66, &66, &17, &07, &10, &06, &66, &66, &17, &09, &06, &26
 EQUB &66, &66, &21, &11, &1A, &E5, &33, &33, &21, &11, &21, &C5
 EQUB &33, &33, &21, &11, &1A, &65, &33, &33, &21, &11, &21, &45
 EQUB &33, &33, &19, &06, &33, &E7, &00, &00, &1A, &06, &33, &67
 EQUB &00, &00, &11, &06, &33, &24, &00, &00, &11, &06, &33, &A4
 EQUB &00, &00, &1F, &07, &00, &04, &1F, &01, &04, &08, &1F, &02
 EQUB &08, &0C, &1F, &03, &0C, &10, &1F, &04, &10, &14, &1F, &05
 EQUB &14, &18, &1F, &06, &00, &18, &0F, &67, &00, &1C, &1F, &17
 EQUB &04, &20, &0A, &12, &08, &24, &1F, &23, &0C, &24, &1F, &34
 EQUB &10, &28, &0A, &45, &14, &28, &1F, &56, &18, &2C, &10, &78
 EQUB &1C, &20, &10, &19, &20, &24, &10, &5A, &28, &2C, &10, &6B
 EQUB &1C, &2C, &12, &BC, &1C, &3C, &12, &8C, &1C, &30, &10, &89
 EQUB &20, &30, &1F, &39, &24, &34, &1F, &3A, &28, &38, &10, &AB
 EQUB &2C, &3C, &1F, &9D, &30, &34, &1F, &3D, &34, &38, &1F, &AD
 EQUB &38, &3C, &1F, &CD, &30, &3C, &06, &77, &40, &44, &06, &77
 EQUB &48, &4C, &06, &77, &4C, &50, &06, &77, &48, &50, &06, &77
 EQUB &50, &54, &06, &66, &58, &5C, &06, &66, &5C, &60, &06, &66
 EQUB &60, &58, &06, &66, &64, &68, &06, &66, &68, &6C, &06, &66
 EQUB &64, &6C, &06, &66, &6C, &70, &05, &33, &74, &78, &05, &33
 EQUB &7C, &80, &07, &00, &84, &88, &04, &00, &88, &8C, &04, &00
 EQUB &8C, &90, &04, &00, &90, &84, &3F, &00, &00, &67, &BF, &6F
 EQUB &30, &07, &FF, &69, &3F, &15, &5F, &00, &22, &00, &7F, &69
 EQUB &3F, &15, &3F, &6F, &30, &07, &1F, &08, &20, &03, &9F, &08
 EQUB &20, &03, &92, &08, &22, &0B, &9F, &4B, &20, &4F, &1F, &4B
 EQUB &20, &4F, &12, &08, &22, &0B, &1F, &00, &26, &11, &1F, &00
 EQUB &00, &79


.s_cobra3

 EQUB &03, &41, &23, &BC, &54, &99, &54, &2A, &A8, &26, &C8, &00
 EQUB &34, &32, &62, &1C, &00, &01, &01, &24, &20, &00, &4C, &1F
 EQUB &FF, &FF, &20, &00, &4C, &9F, &FF, &FF, &00, &1A, &18, &1F
 EQUB &FF, &FF, &78, &03, &08, &FF, &73, &AA, &78, &03, &08, &7F
 EQUB &84, &CC, &58, &10, &28, &BF, &FF, &FF, &58, &10, &28, &3F
 EQUB &FF, &FF, &80, &08, &28, &7F, &98, &CC, &80, &08, &28, &FF
 EQUB &97, &AA, &00, &1A, &28, &3F, &65, &99, &20, &18, &28, &FF
 EQUB &A9, &BB, &20, &18, &28, &7F, &B9, &CC, &24, &08, &28, &B4
 EQUB &99, &99, &08, &0C, &28, &B4, &99, &99, &08, &0C, &28, &34
 EQUB &99, &99, &24, &08, &28, &34, &99, &99, &24, &0C, &28, &74
 EQUB &99, &99, &08, &10, &28, &74, &99, &99, &08, &10, &28, &F4
 EQUB &99, &99, &24, &0C, &28, &F4, &99, &99, &00, &00, &4C, &06
 EQUB &B0, &BB, &00, &00, &5A, &1F, &B0, &BB, &50, &06, &28, &E8
 EQUB &99, &99, &50, &06, &28, &A8, &99, &99, &58, &00, &28, &A6
 EQUB &99, &99, &50, &06, &28, &28, &99, &99, &58, &00, &28, &26
 EQUB &99, &99, &50, &06, &28, &68, &99, &99, &1F, &B0, &00, &04
 EQUB &1F, &C4, &00, &10, &1F, &A3, &04, &0C, &1F, &A7, &0C, &20
 EQUB &1F, &C8, &10, &1C, &1F, &98, &18, &1C, &1F, &96, &18, &24
 EQUB &1F, &95, &14, &24, &1F, &97, &14, &20, &1F, &51, &08, &14
 EQUB &1F, &62, &08, &18, &1F, &73, &0C, &14, &1F, &84, &10, &18
 EQUB &1F, &10, &04, &08, &1F, &20, &00, &08, &1F, &A9, &20, &28
 EQUB &1F, &B9, &28, &2C, &1F, &C9, &1C, &2C, &1F, &BA, &04, &28
 EQUB &1F, &CB, &00, &2C, &1D, &31, &04, &14, &1D, &42, &00, &18
 EQUB &06, &B0, &50, &54, &14, &99, &30, &34, &14, &99, &48, &4C
 EQUB &14, &99, &38, &3C, &14, &99, &40, &44, &13, &99, &3C, &40
 EQUB &11, &99, &38, &44, &13, &99, &34, &48, &13, &99, &30, &4C
 EQUB &1E, &65, &08, &24, &06, &99, &58, &60, &06, &99, &5C, &60
 EQUB &08, &99, &58, &5C, &06, &99, &64, &68, &06, &99, &68, &6C
 EQUB &08, &99, &64, &6C, &1F, &00, &3E, &1F, &9F, &12, &37, &10
 EQUB &1F, &12, &37, &10, &9F, &10, &34, &0E, &1F, &10, &34, &0E
 EQUB &9F, &0E, &2F, &00, &1F, &0E, &2F, &00, &9F, &3D, &66, &00
 EQUB &1F, &3D, &66, &00, &3F, &00, &00, &50, &DF, &07, &2A, &09
 EQUB &5F, &00, &1E, &06, &5F, &07, &2A, &09


.s_python

 EQUB &05, &00, &19, &56, &BE, &55, &00, &2A, &42, &1A, &2C, &01
 EQUB &34, &28, &7D, &14, &00, &00, &00, &2C, &00, &00, &E0, &1F
 EQUB &10, &32, &00, &30, &30, &1E, &10, &54, &60, &00, &10, &3F
 EQUB &FF, &FF, &60, &00, &10, &BF, &FF, &FF, &00, &30, &20, &3E
 EQUB &54, &98, &00, &18, &70, &3F, &89, &CC, &30, &00, &70, &BF
 EQUB &B8, &CC, &30, &00, &70, &3F, &A9, &CC, &00, &30, &30, &5E
 EQUB &32, &76, &00, &30, &20, &7E, &76, &BA, &00, &18, &70, &7E
 EQUB &BA, &CC, &1E, &32, &00, &20, &1F, &20, &00, &0C, &1F, &31
 EQUB &00, &08, &1E, &10, &00, &04, &1D, &59, &08, &10, &1D, &51
 EQUB &04, &08, &1D, &37, &08, &20, &1D, &40, &04, &0C, &1D, &62
 EQUB &0C, &20, &1D, &A7, &08, &24, &1D, &84, &0C, &10, &1D, &B6
 EQUB &0C, &24, &05, &88, &0C, &14, &05, &BB, &0C, &28, &05, &99
 EQUB &08, &14, &05, &AA, &08, &28, &1F, &A9, &08, &1C, &1F, &B8
 EQUB &0C, &18, &1F, &C8, &14, &18, &1F, &C9, &14, &1C, &1D, &AC
 EQUB &1C, &28, &1D, &CB, &18, &28, &1D, &98, &10, &14, &1D, &BA
 EQUB &24, &28, &1D, &54, &04, &10, &1D, &76, &20, &24, &9E, &1B
 EQUB &28, &0B, &1E, &1B, &28, &0B, &DE, &1B, &28, &0B, &5E, &1B
 EQUB &28, &0B, &9E, &13, &26, &00, &1E, &13, &26, &00, &DE, &13
 EQUB &26, &00, &5E, &13, &26, &00, &BE, &19, &25, &0B, &3E, &19
 EQUB &25, &0B, &7E, &19, &25, &0B, &FE, &19, &25, &0B, &3E, &00
 EQUB &00, &70


.s_boa

 EQUB &05, &24, &13, &62, &C2, &59, &00, &26, &4E, &18, &FA, &00
 EQUB &34, &28, &A4, &18, &00, &00, &00, &2A, &00, &00, &5D, &1F
 EQUB &FF, &FF, &00, &28, &57, &38, &02, &33, &26, &19, &63, &78
 EQUB &01, &44, &26, &19, &63, &F8, &12, &55, &26, &28, &3B, &BF
 EQUB &23, &69, &26, &28, &3B, &3F, &03, &6B, &3E, &00, &43, &3F
 EQUB &04, &8B, &18, &41, &4F, &7F, &14, &8A, &18, &41, &4F, &FF
 EQUB &15, &7A, &3E, &00, &43, &BF, &25, &79, &00, &07, &6B, &36
 EQUB &02, &AA, &0D, &09, &6B, &76, &01, &AA, &0D, &09, &6B, &F6
 EQUB &12, &CC, &1F, &6B, &00, &14, &1F, &8A, &00, &1C, &1F, &79
 EQUB &00, &24, &1D, &69, &00, &10, &1D, &8B, &00, &18, &1D, &7A
 EQUB &00, &20, &1F, &36, &10, &14, &1F, &0B, &14, &18, &1F, &48
 EQUB &18, &1C, &1F, &1A, &1C, &20, &1F, &57, &20, &24, &1F, &29
 EQUB &10, &24, &18, &23, &04, &10, &18, &03, &04, &14, &18, &25
 EQUB &0C, &24, &18, &15, &0C, &20, &18, &04, &08, &18, &18, &14
 EQUB &08, &1C, &16, &02, &04, &28, &16, &01, &08, &2C, &16, &12
 EQUB &0C, &30, &0E, &0C, &28, &2C, &0E, &1C, &2C, &30, &0E, &2C
 EQUB &30, &28, &3F, &2B, &25, &3C, &7F, &00, &2D, &59, &BF, &2B
 EQUB &25, &3C, &1F, &00, &28, &00, &7F, &3E, &20, &14, &FF, &3E
 EQUB &20, &14, &1F, &00, &17, &06, &DF, &17, &0F, &09, &5F, &17
 EQUB &0F, &09, &9F, &1A, &0D, &0A, &5F, &00, &1F, &0C, &1F, &1A
 EQUB &0D, &0A, &2E, &00, &00, &6B


.s_anaconda

 EQUB &07, &10, &27, &6E, &D2, &59, &30, &2E, &5A, &19, &5E, &01
 EQUB &30, &32, &FC, &0E, &00, &00, &01, &4F, &00, &07, &3A, &3E
 EQUB &01, &55, &2B, &0D, &25, &FE, &01, &22, &1A, &2F, &03, &FE
 EQUB &02, &33, &1A, &2F, &03, &7E, &03, &44, &2B, &0D, &25, &7E
 EQUB &04, &55, &00, &30, &31, &3E, &15, &66, &45, &0F, &0F, &BE
 EQUB &12, &77, &2B, &27, &28, &DF, &23, &88, &2B, &27, &28, &5F
 EQUB &34, &99, &45, &0F, &0F, &3E, &45, &AA, &2B, &35, &17, &BF
 EQUB &FF, &FF, &45, &01, &20, &DF, &27, &88, &00, &00, &FE, &1F
 EQUB &FF, &FF, &45, &01, &20, &5F, &49, &AA, &2B, &35, &17, &3F
 EQUB &FF, &FF, &1E, &01, &00, &04, &1E, &02, &04, &08, &1E, &03
 EQUB &08, &0C, &1E, &04, &0C, &10, &1E, &05, &00, &10, &1D, &15
 EQUB &00, &14, &1D, &12, &04, &18, &1D, &23, &08, &1C, &1D, &34
 EQUB &0C, &20, &1D, &45, &10, &24, &1E, &16, &14, &28, &1E, &17
 EQUB &18, &28, &1E, &27, &18, &2C, &1E, &28, &1C, &2C, &1F, &38
 EQUB &1C, &30, &1F, &39, &20, &30, &1E, &49, &20, &34, &1E, &4A
 EQUB &24, &34, &1E, &5A, &24, &38, &1E, &56, &14, &38, &1E, &6B
 EQUB &28, &38, &1F, &7B, &28, &30, &1F, &78, &2C, &30, &1F, &9A
 EQUB &30, &34, &1F, &AB, &30, &38, &7E, &00, &33, &31, &BE, &33
 EQUB &12, &57, &FE, &4D, &39, &13, &5F, &00, &5A, &10, &7E, &4D
 EQUB &39, &13, &3E, &33, &12, &57, &3E, &00, &6F, &14, &9F, &61
 EQUB &48, &18, &DF, &6C, &44, &22, &5F, &6C, &44, &22, &1F, &61
 EQUB &48, &18, &1F, &00, &5E, &12


.s_worm

 EQUB &00, &49, &26, &50, &90, &49, &00, &12, &3C, &10, &00, &00
 EQUB &20, &13, &20, &17, &00, &00, &03, &18, &0A, &0A, &23, &5F
 EQUB &02, &77, &0A, &0A, &23, &DF, &03, &77, &05, &06, &0F, &1F
 EQUB &01, &24, &05, &06, &0F, &9F, &01, &35, &0F, &0A, &19, &5F
 EQUB &24, &77, &0F, &0A, &19, &DF, &35, &77, &1A, &0A, &19, &7F
 EQUB &46, &77, &1A, &0A, &19, &FF, &56, &77, &08, &0E, &19, &3F
 EQUB &14, &66, &08, &0E, &19, &BF, &15, &66, &1F, &07, &00, &04
 EQUB &1F, &37, &04, &14, &1F, &57, &14, &1C, &1F, &67, &1C, &18
 EQUB &1F, &47, &18, &10, &1F, &27, &10, &00, &1F, &02, &00, &08
 EQUB &1F, &03, &04, &0C, &1F, &24, &10, &08, &1F, &35, &14, &0C
 EQUB &1F, &14, &08, &20, &1F, &46, &20, &18, &1F, &15, &0C, &24
 EQUB &1F, &56, &24, &1C, &1F, &01, &08, &0C, &1F, &16, &20, &24
 EQUB &1F, &00, &58, &46, &1F, &00, &45, &0E, &1F, &46, &42, &23
 EQUB &9F, &46, &42, &23, &1F, &40, &31, &0E, &9F, &40, &31, &0E
 EQUB &3F, &00, &00, &C8, &5F, &00, &50, &00


.s_missile

 EQUB &00, &40, &06, &7A, &DA, &51, &00, &0A, &66, &18, &00, &00
 EQUB &24, &0E, &02, &2C, &00, &00, &02, &00, &00, &00, &44, &1F
 EQUB &10, &32, &08, &08, &24, &5F, &21, &54, &08, &08, &24, &1F
 EQUB &32, &74, &08, &08, &24, &9F, &30, &76, &08, &08, &24, &DF
 EQUB &10, &65, &08, &08, &2C, &3F, &74, &88, &08, &08, &2C, &7F
 EQUB &54, &88, &08, &08, &2C, &FF, &65, &88, &08, &08, &2C, &BF
 EQUB &76, &88, &0C, &0C, &2C, &28, &74, &88, &0C, &0C, &2C, &68
 EQUB &54, &88, &0C, &0C, &2C, &E8, &65, &88, &0C, &0C, &2C, &A8
 EQUB &76, &88, &08, &08, &0C, &A8, &76, &77, &08, &08, &0C, &E8
 EQUB &65, &66, &08, &08, &0C, &28, &74, &77, &08, &08, &0C, &68
 EQUB &54, &55, &1F, &21, &00, &04, &1F, &32, &00, &08, &1F, &30
 EQUB &00, &0C, &1F, &10, &00, &10, &1F, &24, &04, &08, &1F, &51
 EQUB &04, &10, &1F, &60, &0C, &10, &1F, &73, &08, &0C, &1F, &74
 EQUB &08, &14, &1F, &54, &04, &18, &1F, &65, &10, &1C, &1F, &76
 EQUB &0C, &20, &1F, &86, &1C, &20, &1F, &87, &14, &20, &1F, &84
 EQUB &14, &18, &1F, &85, &18, &1C, &08, &85, &18, &28, &08, &87
 EQUB &14, &24, &08, &87, &20, &30, &08, &85, &1C, &2C, &08, &74
 EQUB &24, &3C, &08, &54, &28, &40, &08, &76, &30, &34, &08, &65
 EQUB &2C, &38, &9F, &40, &00, &10, &5F, &00, &40, &10, &1F, &40
 EQUB &00, &10, &1F, &00, &40, &10, &1F, &20, &00, &00, &5F, &00
 EQUB &20, &00, &9F, &20, &00, &00, &1F, &00, &20, &00, &3F, &00
 EQUB &00, &B0
 

.s_viper

 EQUB &00, &F9, &15, &6E, &BE, &4D, &00, &2A, &5A, &14, &00, &00
 EQUB &1C, &17, &5B, &20, &00, &00, &01, &29, &00, &00, &48, &1F
 EQUB &21, &43, &00, &10, &18, &1E, &10, &22, &00, &10, &18, &5E
 EQUB &43, &55, &30, &00, &18, &3F, &42, &66, &30, &00, &18, &BF
 EQUB &31, &66, &18, &10, &18, &7E, &54, &66, &18, &10, &18, &FE
 EQUB &35, &66, &18, &10, &18, &3F, &20, &66, &18, &10, &18, &BF
 EQUB &10, &66, &20, &00, &18, &B3, &66, &66, &20, &00, &18, &33
 EQUB &66, &66, &08, &08, &18, &33, &66, &66, &08, &08, &18, &B3
 EQUB &66, &66, &08, &08, &18, &F2, &66, &66, &08, &08, &18, &72
 EQUB &66, &66, &1F, &42, &00, &0C, &1E, &21, &00, &04, &1E, &43
 EQUB &00, &08, &1F, &31, &00, &10, &1E, &20, &04, &1C, &1E, &10
 EQUB &04, &20, &1E, &54, &08, &14, &1E, &53, &08, &18, &1F, &60
 EQUB &1C, &20, &1E, &65, &14, &18, &1F, &61, &10, &20, &1E, &63
 EQUB &10, &18, &1F, &62, &0C, &1C, &1E, &46, &0C, &14, &13, &66
 EQUB &24, &30, &12, &66, &24, &34, &13, &66, &28, &2C, &12, &66
 EQUB &28, &38, &10, &66, &2C, &38, &10, &66, &30, &34, &1F, &00
 EQUB &20, &00, &9F, &16, &21, &0B, &1F, &16, &21, &0B, &DF, &16
 EQUB &21, &0B, &5F, &16, &21, &0B, &5F, &00, &20, &00, &3F, &00
 EQUB &00, &30


.s_sidewinder

 EQUB &00, &81, &10, &50, &8C, &3D, &00, &1E, &3C, &0F, &64, &00
 EQUB &1C, &14, &49, &25, &00, &00, &02, &20, &20, &00, &24, &9F
 EQUB &10, &54, &20, &00, &24, &1F, &20, &65, &40, &00, &1C, &3F
 EQUB &32, &66, &40, &00, &1C, &BF, &31, &44, &00, &10, &1C, &3F
 EQUB &10, &32, &00, &10, &1C, &7F, &43, &65, &0C, &06, &1C, &AF
 EQUB &33, &33, &0C, &06, &1C, &2F, &33, &33, &0C, &06, &1C, &6C
 EQUB &33, &33, &0C, &06, &1C, &EC, &33, &33, &1F, &50, &00, &04
 EQUB &1F, &62, &04, &08, &1F, &20, &04, &10, &1F, &10, &00, &10
 EQUB &1F, &41, &00, &0C, &1F, &31, &0C, &10, &1F, &32, &08, &10
 EQUB &1F, &43, &0C, &14, &1F, &63, &08, &14, &1F, &65, &04, &14
 EQUB &1F, &54, &00, &14, &0F, &33, &18, &1C, &0C, &33, &1C, &20
 EQUB &0C, &33, &18, &24, &0C, &33, &20, &24, &1F, &00, &20, &08
 EQUB &9F, &0C, &2F, &06, &1F, &0C, &2F, &06, &3F, &00, &00, &70
 EQUB &DF, &0C, &2F, &06, &5F, &00, &20, &08, &5F, &0C, &2F, &06


.s_mamba

 EQUB &01, &24, &13, &AA, &1A, &5D, &00, &22, &96, &1C, &96, &00
 EQUB &14, &19, &50, &1E, &00, &01, &02, &22, &00, &00, &40, &1F
 EQUB &10, &32, &40, &08, &20, &FF, &20, &44, &20, &08, &20, &BE
 EQUB &21, &44, &20, &08, &20, &3E, &31, &44, &40, &08, &20, &7F
 EQUB &30, &44, &04, &04, &10, &8E, &11, &11, &04, &04, &10, &0E
 EQUB &11, &11, &08, &03, &1C, &0D, &11, &11, &08, &03, &1C, &8D
 EQUB &11, &11, &14, &04, &10, &D4, &00, &00, &14, &04, &10, &54
 EQUB &00, &00, &18, &07, &14, &F4, &00, &00, &10, &07, &14, &F0
 EQUB &00, &00, &10, &07, &14, &70, &00, &00, &18, &07, &14, &74
 EQUB &00, &00, &08, &04, &20, &AD, &44, &44, &08, &04, &20, &2D
 EQUB &44, &44, &08, &04, &20, &6E, &44, &44, &08, &04, &20, &EE
 EQUB &44, &44, &20, &04, &20, &A7, &44, &44, &20, &04, &20, &27
 EQUB &44, &44, &24, &04, &20, &67, &44, &44, &24, &04, &20, &E7
 EQUB &44, &44, &26, &00, &20, &A5, &44, &44, &26, &00, &20, &25
 EQUB &44, &44, &1F, &20, &00, &04, &1F, &30, &00, &10, &1F, &40
 EQUB &04, &10, &1E, &42, &04, &08, &1E, &41, &08, &0C, &1E, &43
 EQUB &0C, &10, &0E, &11, &14, &18, &0C, &11, &18, &1C, &0D, &11
 EQUB &1C, &20, &0C, &11, &14, &20, &14, &00, &24, &2C, &10, &00
 EQUB &24, &30, &10, &00, &28, &34, &14, &00, &28, &38, &0E, &00
 EQUB &34, &38, &0E, &00, &2C, &30, &0D, &44, &3C, &40, &0E, &44
 EQUB &44, &48, &0C, &44, &3C, &48, &0C, &44, &40, &44, &07, &44
 EQUB &50, &54, &05, &44, &50, &60, &05, &44, &54, &60, &07, &44
 EQUB &4C, &58, &05, &44, &4C, &5C, &05, &44, &58, &5C, &1E, &21
 EQUB &00, &08, &1E, &31, &00, &0C, &5E, &00, &18, &02, &1E, &00
 EQUB &18, &02, &9E, &20, &40, &10, &1E, &20, &40, &10, &3E, &00
 EQUB &00, &7F


.s_krait

 EQUB &01, &10, &0E, &7A, &CE, &55, &00, &12, &66, &15, &64, &00
 EQUB &18, &19, &49, &1E, &00, &00, &01, &20, &00, &00, &60, &1F
 EQUB &01, &23, &00, &12, &30, &3F, &03, &45, &00, &12, &30, &7F
 EQUB &12, &45, &5A, &00, &03, &3F, &01, &44, &5A, &00, &03, &BF
 EQUB &23, &55, &5A, &00, &57, &1E, &01, &11, &5A, &00, &57, &9E
 EQUB &23, &33, &00, &05, &35, &09, &00, &33, &00, &07, &26, &06
 EQUB &00, &33, &12, &07, &13, &89, &33, &33, &12, &07, &13, &09
 EQUB &00, &00, &12, &0B, &27, &28, &44, &44, &12, &0B, &27, &68
 EQUB &44, &44, &24, &00, &1E, &28, &44, &44, &12, &0B, &27, &A8
 EQUB &55, &55, &12, &0B, &27, &E8, &55, &55, &24, &00, &1E, &A8
 EQUB &55, &55, &1F, &03, &00, &04, &1F, &12, &00, &08, &1F, &01
 EQUB &00, &0C, &1F, &23, &00, &10, &1F, &35, &04, &10, &1F, &25
 EQUB &10, &08, &1F, &14, &08, &0C, &1F, &04, &0C, &04, &1E, &01
 EQUB &0C, &14, &1E, &23, &10, &18, &08, &45, &04, &08, &09, &00
 EQUB &1C, &28, &06, &00, &20, &28, &09, &33, &1C, &24, &06, &33
 EQUB &20, &24, &08, &44, &2C, &34, &08, &44, &34, &30, &07, &44
 EQUB &30, &2C, &07, &55, &38, &3C, &08, &55, &3C, &40, &08, &55
 EQUB &40, &38, &1F, &03, &18, &03, &5F, &03, &18, &03, &DF, &03
 EQUB &18, &03, &9F, &03, &18, &03, &3F, &26, &00, &4D, &BF, &26
 EQUB &00, &4D


.s_adder

 EQUB &00, &C4, &09, &80, &F4, &61, &00, &16, &6C, &1D, &28, &00
 EQUB &3C, &17, &48, &18, &00, &00, &02, &21, &12, &00, &28, &9F
 EQUB &01, &BC, &12, &00, &28, &1F, &01, &23, &1E, &00, &18, &3F
 EQUB &23, &45, &1E, &00, &28, &3F, &45, &66, &12, &07, &28, &7F
 EQUB &56, &7E, &12, &07, &28, &FF, &78, &AE, &1E, &00, &28, &BF
 EQUB &89, &AA, &1E, &00, &18, &BF, &9A, &BC, &12, &07, &28, &BF
 EQUB &78, &9D, &12, &07, &28, &3F, &46, &7D, &12, &07, &0D, &9F
 EQUB &09, &BD, &12, &07, &0D, &1F, &02, &4D, &12, &07, &0D, &DF
 EQUB &1A, &CE, &12, &07, &0D, &5F, &13, &5E, &0B, &03, &1D, &85
 EQUB &00, &00, &0B, &03, &1D, &05, &00, &00, &0B, &04, &18, &04
 EQUB &00, &00, &0B, &04, &18, &84, &00, &00, &1F, &01, &00, &04
 EQUB &07, &23, &04, &08, &1F, &45, &08, &0C, &1F, &56, &0C, &10
 EQUB &1F, &7E, &10, &14, &1F, &8A, &14, &18, &1F, &9A, &18, &1C
 EQUB &07, &BC, &1C, &00, &1F, &46, &0C, &24, &1F, &7D, &24, &20
 EQUB &1F, &89, &20, &18, &1F, &0B, &00, &28, &1F, &9B, &1C, &28
 EQUB &1F, &02, &04, &2C, &1F, &24, &08, &2C, &1F, &1C, &00, &30
 EQUB &1F, &AC, &1C, &30, &1F, &13, &04, &34, &1F, &35, &08, &34
 EQUB &1F, &0D, &28, &2C, &1F, &1E, &30, &34, &1F, &9D, &20, &28
 EQUB &1F, &4D, &24, &2C, &1F, &AE, &14, &30, &1F, &5E, &10, &34
 EQUB &05, &00, &38, &3C, &03, &00, &3C, &40, &04, &00, &40, &44
 EQUB &03, &00, &44, &38, &1F, &00, &27, &0A, &5F, &00, &27, &0A
 EQUB &1F, &45, &32, &0D, &5F, &45, &32, &0D, &1F, &1E, &34, &00
 EQUB &5F, &1E, &34, &00, &3F, &00, &00, &A0, &3F, &00, &00, &A0
 EQUB &3F, &00, &00, &A0, &9F, &1E, &34, &00, &DF, &1E, &34, &00
 EQUB &9F, &45, &32, &0D, &DF, &45, &32, &0D, &1F, &00, &1C, &00
 EQUB &5F, &00, &1C, &00


.s_gecko

 EQUB &00, &49, &26, &5C, &A0, &41, &00, &1A, &48, &11, &37, &00
 EQUB &24, &12, &41, &1E, &00, &00, &03, &20, &0A, &04, &2F, &DF
 EQUB &03, &45, &0A, &04, &2F, &5F, &01, &23, &10, &08, &17, &BF
 EQUB &05, &67, &10, &08, &17, &3F, &01, &78, &42, &00, &03, &BF
 EQUB &45, &66, &42, &00, &03, &3F, &12, &88, &14, &0E, &17, &FF
 EQUB &34, &67, &14, &0E, &17, &7F, &23, &78, &08, &06, &21, &D0
 EQUB &33, &33, &08, &06, &21, &51, &33, &33, &08, &0D, &10, &F0
 EQUB &33, &33, &08, &0D, &10, &71, &33, &33, &1F, &03, &00, &04
 EQUB &1F, &12, &04, &14, &1F, &18, &14, &0C, &1F, &07, &0C, &08
 EQUB &1F, &56, &08, &10, &1F, &45, &10, &00, &1F, &28, &14, &1C
 EQUB &1F, &37, &1C, &18, &1F, &46, &18, &10, &1D, &05, &00, &08
 EQUB &1E, &01, &04, &0C, &1D, &34, &00, &18, &1E, &23, &04, &1C
 EQUB &14, &67, &08, &18, &14, &78, &0C, &1C, &10, &33, &20, &28
 EQUB &11, &33, &24, &2C, &1F, &00, &1F, &05, &1F, &04, &2D, &08
 EQUB &5F, &19, &6C, &13, &5F, &00, &54, &0C, &DF, &19, &6C, &13
 EQUB &9F, &04, &2D, &08, &BF, &58, &10, &D6, &3F, &00, &00, &BB
 EQUB &3F, &58, &10, &D6


.s_cobra1

 EQUB &03, &49, &26, &56, &9E, &45, &28, &1A, &42, &12, &4B, &00
 EQUB &28, &13, &51, &1A, &00, &00, &02, &22, &12, &01, &32, &DF
 EQUB &01, &23, &12, &01, &32, &5F, &01, &45, &42, &00, &07, &9F
 EQUB &23, &88, &42, &00, &07, &1F, &45, &99, &20, &0C, &26, &BF
 EQUB &26, &78, &20, &0C, &26, &3F, &46, &79, &36, &0C, &26, &FF
 EQUB &13, &78, &36, &0C, &26, &7F, &15, &79, &00, &0C, &06, &34
 EQUB &02, &46, &00, &01, &32, &42, &01, &11, &00, &01, &3C, &5F
 EQUB &01, &11, &1F, &01, &04, &00, &1F, &23, &00, &08, &1F, &38
 EQUB &08, &18, &1F, &17, &18, &1C, &1F, &59, &1C, &0C, &1F, &45
 EQUB &0C, &04, &1F, &28, &08, &10, &1F, &67, &10, &14, &1F, &49
 EQUB &14, &0C, &14, &02, &00, &20, &14, &04, &20, &04, &10, &26
 EQUB &10, &20, &10, &46, &20, &14, &1F, &78, &10, &18, &1F, &79
 EQUB &14, &1C, &14, &13, &00, &18, &14, &15, &04, &1C, &02, &01
 EQUB &28, &24, &1F, &00, &29, &0A, &5F, &00, &1B, &03, &9F, &08
 EQUB &2E, &08, &DF, &0C, &39, &0C, &1F, &08, &2E, &08, &5F, &0C
 EQUB &39, &0C, &1F, &00, &31, &00, &3F, &00, &00, &9A, &BF, &79
 EQUB &6F, &3E, &3F, &79, &6F, &3E


.s_asp

 EQUB &00, &10, &0E, &86, &F6, &65, &20, &1A, &72, &1C, &C2, &01
 EQUB &30, &28, &6D, &28, &00, &00, &01, &49, &00, &12, &00, &56
 EQUB &01, &22, &00, &09, &2D, &7F, &12, &BB, &2B, &00, &2D, &3F
 EQUB &16, &BB, &45, &03, &00, &5F, &16, &79, &2B, &0E, &1C, &5F
 EQUB &01, &77, &2B, &00, &2D, &BF, &25, &BB, &45, &03, &00, &DF
 EQUB &25, &8A, &2B, &0E, &1C, &DF, &02, &88, &1A, &07, &49, &5F
 EQUB &04, &79, &1A, &07, &49, &DF, &04, &8A, &2B, &0E, &1C, &1F
 EQUB &34, &69, &2B, &0E, &1C, &9F, &34, &5A, &00, &09, &2D, &3F
 EQUB &35, &6B, &11, &00, &2D, &AA, &BB, &BB, &11, &00, &2D, &29
 EQUB &BB, &BB, &00, &04, &2D, &6A, &BB, &BB, &00, &04, &2D, &28
 EQUB &BB, &BB, &00, &07, &49, &4A, &04, &04, &00, &07, &53, &4A
 EQUB &04, &04, &16, &12, &00, &04, &16, &01, &00, &10, &16, &02
 EQUB &00, &1C, &1F, &1B, &04, &08, &1F, &16, &08, &0C, &10, &79
 EQUB &0C, &20, &1F, &04, &20, &24, &10, &8A, &18, &24, &1F, &25
 EQUB &14, &18, &1F, &2B, &04, &14, &1F, &17, &0C, &10, &1F, &07
 EQUB &10, &20, &1F, &28, &18, &1C, &1F, &08, &1C, &24, &1F, &6B
 EQUB &08, &30, &1F, &5B, &14, &30, &16, &36, &28, &30, &16, &35
 EQUB &2C, &30, &16, &34, &28, &2C, &1F, &5A, &18, &2C, &1F, &4A
 EQUB &24, &2C, &1F, &69, &0C, &28, &1F, &49, &20, &28, &0A, &BB
 EQUB &34, &3C, &09, &BB, &3C, &38, &08, &BB, &38, &40, &08, &BB
 EQUB &40, &34, &0A, &04, &48, &44, &5F, &00, &23, &05, &7F, &08
 EQUB &26, &07, &FF, &08, &26, &07, &36, &00, &18, &01, &1F, &00
 EQUB &2B, &13, &BF, &06, &1C, &02, &3F, &06, &1C, &02, &5F, &3B
 EQUB &40, &1F, &DF, &3B, &40, &1F, &1F, &50, &2E, &32, &9F, &50
 EQUB &2E, &32, &3F, &00, &00, &5A


.s_ferdelance

 EQUB &00, &40, &06, &86, &F2, &69, &00, &1A, &72, &1B, &FA, &00
 EQUB &28, &28, &53, &1E, &00, &00, &01, &32, &00, &0E, &6C, &5F
 EQUB &01, &59, &28, &0E, &04, &FF, &12, &99, &0C, &0E, &34, &FF
 EQUB &23, &99, &0C, &0E, &34, &7F, &34, &99, &28, &0E, &04, &7F
 EQUB &45, &99, &28, &0E, &04, &BC, &01, &26, &0C, &02, &34, &BC
 EQUB &23, &67, &0C, &02, &34, &3C, &34, &78, &28, &0E, &04, &3C
 EQUB &04, &58, &00, &12, &14, &2F, &06, &78, &03, &0B, &61, &CB
 EQUB &00, &00, &1A, &08, &12, &89, &00, &00, &10, &0E, &04, &AB
 EQUB &00, &00, &03, &0B, &61, &4B, &00, &00, &1A, &08, &12, &09
 EQUB &00, &00, &10, &0E, &04, &2B, &00, &00, &00, &0E, &14, &6C
 EQUB &99, &99, &0E, &0E, &2C, &CC, &99, &99, &0E, &0E, &2C, &4C
 EQUB &99, &99, &1F, &19, &00, &04, &1F, &29, &04, &08, &1F, &39
 EQUB &08, &0C, &1F, &49, &0C, &10, &1F, &59, &00, &10, &1C, &01
 EQUB &00, &14, &1C, &26, &14, &18, &1C, &37, &18, &1C, &1C, &48
 EQUB &1C, &20, &1C, &05, &00, &20, &0F, &06, &14, &24, &0B, &67
 EQUB &18, &24, &0B, &78, &1C, &24, &0F, &08, &20, &24, &0E, &12
 EQUB &04, &14, &0E, &23, &08, &18, &0E, &34, &0C, &1C, &0E, &45
 EQUB &10, &20, &08, &00, &28, &2C, &09, &00, &2C, &30, &0B, &00
 EQUB &28, &30, &08, &00, &34, &38, &09, &00, &38, &3C, &0B, &00
 EQUB &34, &3C, &0C, &99, &40, &44, &0C, &99, &40, &48, &08, &99
 EQUB &44, &48, &1C, &00, &18, &06, &9F, &44, &00, &18, &BF, &3F
 EQUB &00, &25, &3F, &00, &00, &68, &3F, &3F, &00, &25, &1F, &44
 EQUB &00, &18, &BC, &0C, &2E, &13, &3C, &00, &2D, &16, &3C, &0C
 EQUB &2E, &13, &5F, &00, &1C, &00


.s_moray

 EQUB &01, &84, &03, &68, &B4, &45, &00, &1A, &54, &13, &32, &00
 EQUB &24, &28, &59, &19, &00, &00, &02, &2A, &0F, &00, &41, &1F
 EQUB &02, &78, &0F, &00, &41, &9F, &01, &67, &00, &12, &28, &31
 EQUB &FF, &FF, &3C, &00, &00, &9F, &13, &66, &3C, &00, &00, &1F
 EQUB &25, &88, &1E, &1B, &0A, &78, &45, &78, &1E, &1B, &0A, &F8
 EQUB &34, &67, &09, &04, &19, &E7, &44, &44, &09, &04, &19, &67
 EQUB &44, &44, &00, &12, &10, &67, &44, &44, &0D, &03, &31, &05
 EQUB &00, &00, &06, &00, &41, &05, &00, &00, &0D, &03, &31, &85
 EQUB &00, &00, &06, &00, &41, &85, &00, &00, &1F, &07, &00, &04
 EQUB &1F, &16, &04, &0C, &18, &36, &0C, &18, &18, &47, &14, &18
 EQUB &18, &58, &10, &14, &1F, &28, &00, &10, &0F, &67, &04, &18
 EQUB &0F, &78, &00, &14, &0F, &02, &00, &08, &0F, &01, &04, &08
 EQUB &11, &13, &08, &0C, &11, &25, &08, &10, &0D, &45, &08, &14
 EQUB &0D, &34, &08, &18, &05, &44, &1C, &20, &07, &44, &1C, &24
 EQUB &07, &44, &20, &24, &05, &00, &28, &2C, &05, &00, &30, &34
 EQUB &1F, &00, &2B, &07, &9F, &0A, &31, &07, &1F, &0A, &31, &07
 EQUB &F8, &3B, &1C, &65, &78, &00, &34, &4E, &78, &3B, &1C, &65
 EQUB &DF, &48, &63, &32, &5F, &00, &53, &1E, &5F, &48, &63, &32


.s_constrictor

 EQUB &F3, &49, &26, &7A, &DA, &4D, &00, &2E, &66, &18, &00, &00
 EQUB &28, &2D, &73, &37, &00, &00, &02, &47, &14, &07, &50, &5F
 EQUB &02, &99, &14, &07, &50, &DF, &01, &99, &36, &07, &28, &DF
 EQUB &14, &99, &36, &07, &28, &FF, &45, &89, &14, &0D, &28, &BF
 EQUB &56, &88, &14, &0D, &28, &3F, &67, &88, &36, &07, &28, &7F
 EQUB &37, &89, &36, &07, &28, &5F, &23, &99, &14, &0D, &05, &1F
 EQUB &FF, &FF, &14, &0D, &05, &9F, &FF, &FF, &14, &07, &3E, &52
 EQUB &99, &99, &14, &07, &3E, &D2, &99, &99, &19, &07, &19, &72
 EQUB &99, &99, &19, &07, &19, &F2, &99, &99, &0F, &07, &0F, &6A
 EQUB &99, &99, &0F, &07, &0F, &EA, &99, &99, &00, &07, &00, &40
 EQUB &9F, &01, &1F, &09, &00, &04, &1F, &19, &04, &08, &1F, &01
 EQUB &04, &24, &1F, &02, &00, &20, &1F, &29, &00, &1C, &1F, &23
 EQUB &1C, &20, &1F, &14, &08, &24, &1F, &49, &08, &0C, &1F, &39
 EQUB &18, &1C, &1F, &37, &18, &20, &1F, &67, &14, &20, &1F, &56
 EQUB &10, &24, &1F, &45, &0C, &24, &1F, &58, &0C, &10, &1F, &68
 EQUB &10, &14, &1F, &78, &14, &18, &1F, &89, &0C, &18, &1F, &06
 EQUB &20, &24, &12, &99, &28, &30, &05, &99, &30, &38, &0A, &99
 EQUB &38, &28, &0A, &99, &2C, &3C, &05, &99, &34, &3C, &12, &99
 EQUB &2C, &34, &1F, &00, &37, &0F, &9F, &18, &4B, &14, &1F, &18
 EQUB &4B, &14, &1F, &2C, &4B, &00, &9F, &2C, &4B, &00, &9F, &2C
 EQUB &4B, &00, &1F, &00, &35, &00, &1F, &2C, &4B, &00, &3F, &00
 EQUB &00, &A0, &5F, &00, &1B, &00


\ a.qship_2

.s_dragon

 EQUB &00, &50, &66, &4A, &9E, &41, &00, &3C, &36, &15, &00, &00
 EQUB &38, &20, &F7, &14, &00, &00, &00, &47, &00, &00, &FA, &1F
 EQUB &6B, &05, &D8, &00, &7C, &1F, &67, &01, &D8, &00, &7C, &3F
 EQUB &78, &12, &00, &28, &FA, &3F, &CD, &23, &00, &28, &FA, &7F
 EQUB &CD, &89, &D8, &00, &7C, &BF, &9A, &34, &D8, &00, &7C, &9F
 EQUB &AB, &45, &00, &50, &00, &1F, &FF, &FF, &00, &50, &00, &5F
 EQUB &FF, &FF, &1F, &01, &04, &1C, &1F, &12, &08, &1C, &1F, &23
 EQUB &0C, &1C, &1F, &34, &14, &1C, &1F, &45, &18, &1C, &1F, &50
 EQUB &00, &1C, &1F, &67, &04, &20, &1F, &78, &08, &20, &1F, &89
 EQUB &10, &20, &1F, &9A, &14, &20, &1F, &AB, &18, &20, &1F, &B6
 EQUB &00, &20, &1F, &06, &00, &04, &1F, &17, &04, &08, &1F, &4A
 EQUB &14, &18, &1F, &5B, &00, &18, &1F, &2C, &08, &0C, &1F, &8C
 EQUB &08, &10, &1F, &3D, &0C, &14, &1F, &9D, &10, &14, &1F, &CD
 EQUB &0C, &10, &1F, &10, &5A, &1C, &1F, &21, &5A, &00, &3F, &19
 EQUB &5B, &0E, &BF, &19, &5B, &0E, &9F, &21, &5A, &00, &9F, &10
 EQUB &5A, &1C, &5F, &10, &5A, &1C, &5F, &21, &5A, &00, &7F, &19
 EQUB &5B, &0E, &FF, &19, &5B, &0E, &DF, &21, &5A, &00, &DF, &10
 EQUB &5A, &1C, &3F, &30, &00, &52, &BF, &30, &00, &52


.s_monitor

 EQUB &04, &00, &36, &7A, &D6, &65, &00, &2A, &66, &17, &90, &01
 EQUB &2C, &28, &84, &10, &00, &00, &00, &37, &00, &0A, &8C, &1F
 EQUB &FF, &FF, &14, &28, &14, &3F, &23, &01, &14, &28, &14, &BF
 EQUB &50, &34, &32, &00, &0A, &1F, &78, &12, &32, &00, &0A, &9F
 EQUB &96, &45, &1E, &04, &3C, &3F, &AA, &28, &1E, &04, &3C, &BF
 EQUB &AA, &49, &12, &14, &3C, &3F, &AA, &23, &12, &14, &3C, &BF
 EQUB &AA, &34, &00, &14, &3C, &7F, &AA, &89, &00, &28, &0A, &5F
 EQUB &89, &67, &00, &22, &0A, &0A, &00, &00, &00, &1A, &32, &0A
 EQUB &00, &00, &14, &0A, &3C, &4A, &77, &77, &0A, &00, &64, &0A
 EQUB &77, &77, &14, &0A, &3C, &CA, &66, &66, &0A, &00, &64, &8A
 EQUB &66, &66, &1F, &01, &00, &04, &1F, &12, &04, &0C, &1F, &23
 EQUB &04, &1C, &1F, &34, &08, &20, &1F, &45, &08, &10, &1F, &50
 EQUB &00, &08, &1F, &03, &04, &08, &1F, &67, &00, &28, &1F, &78
 EQUB &0C, &28, &1F, &89, &24, &28, &1F, &96, &10, &28, &1F, &17
 EQUB &00, &0C, &1F, &28, &0C, &14, &1F, &49, &18, &10, &1F, &56
 EQUB &10, &00, &1F, &2A, &1C, &14, &1F, &3A, &20, &1C, &1F, &4A
 EQUB &20, &18, &1F, &8A, &14, &24, &1F, &9A, &18, &24, &0A, &00
 EQUB &2C, &30, &0A, &77, &34, &38, &0A, &66, &3C, &40, &1F, &00
 EQUB &3E, &0B, &1F, &2C, &2B, &0D, &3F, &36, &1C, &10, &3F, &00
 EQUB &39, &1C, &BF, &36, &1C, &10, &9F, &2C, &2B, &0D, &DF, &26
 EQUB &2F, &12, &5F, &26, &2F, &12, &7F, &27, &30, &0D, &FF, &27
 EQUB &30, &0D, &3F, &00, &00, &40


.s_ophidian

 EQUB &02, &88, &0E, &8C, &04, &71, &00, &3C, &78, &1E, &32, &00
 EQUB &30, &14, &40, &22, &00, &01, &01, &1A, &14, &00, &46, &9F
 EQUB &68, &02, &14, &00, &46, &1F, &67, &01, &00, &0A, &28, &1F
 EQUB &22, &01, &1E, &00, &1E, &9F, &8A, &24, &1E, &00, &1E, &1F
 EQUB &79, &13, &00, &10, &0A, &1F, &FF, &FF, &14, &0A, &32, &3F
 EQUB &9B, &35, &14, &0A, &32, &BF, &AB, &45, &1E, &00, &32, &BF
 EQUB &BB, &4A, &28, &00, &32, &B0, &FF, &FF, &1E, &00, &1E, &B0
 EQUB &FF, &FF, &1E, &00, &32, &3F, &BB, &39, &28, &00, &32, &30
 EQUB &FF, &FF, &1E, &00, &1E, &30, &FF, &FF, &00, &0A, &32, &7F
 EQUB &BB, &9A, &00, &10, &14, &5F, &FF, &FF, &0A, &04, &32, &30
 EQUB &BB, &BB, &0A, &02, &32, &70, &BB, &BB, &0A, &02, &32, &F0
 EQUB &BB, &BB, &0A, &04, &32, &B0, &BB, &BB, &1F, &06, &00, &04
 EQUB &1F, &01, &04, &08, &1F, &02, &00, &08, &1F, &12, &08, &14
 EQUB &1F, &13, &10, &14, &1F, &24, &0C, &14, &1F, &35, &14, &18
 EQUB &1F, &45, &14, &1C, &1F, &28, &00, &0C, &1F, &17, &04, &10
 EQUB &1F, &39, &10, &2C, &1F, &4A, &0C, &20, &1F, &67, &04, &3C
 EQUB &1F, &68, &00, &3C, &1F, &79, &10, &3C, &1F, &8A, &0C, &3C
 EQUB &1F, &9A, &38, &3C, &1F, &5B, &18, &1C, &1F, &3B, &18, &2C
 EQUB &1F, &4B, &1C, &20, &1F, &9B, &2C, &38, &1F, &AB, &20, &38
 EQUB &10, &BB, &40, &44, &10, &BB, &44, &48, &10, &BB, &48, &4C
 EQUB &10, &BB, &4C, &40, &10, &39, &30, &34, &10, &39, &2C, &30
 EQUB &10, &4A, &28, &24, &10, &4A, &24, &20, &1F, &00, &25, &0C
 EQUB &1F, &0B, &1C, &05, &9F, &0B, &1C, &05, &1F, &10, &22, &02
 EQUB &9F, &10, &22, &02, &3F, &00, &25, &03, &5F, &00, &1F, &0A
 EQUB &5F, &0A, &14, &02, &DF, &0A, &14, &02, &7F, &12, &20, &02
 EQUB &FF, &12, &20, &02, &3F, &00, &00, &25


.s_ghavial

 EQUB &03, &00, &26, &5C, &B4, &61, &00, &22, &48, &16, &64, &00
 EQUB &30, &0A, &72, &10, &00, &00, &00, &27, &1E, &00, &64, &1F
 EQUB &67, &01, &1E, &00, &64, &9F, &6B, &05, &28, &1E, &1A, &3F
 EQUB &23, &01, &28, &1E, &1A, &BF, &45, &03, &3C, &00, &14, &3F
 EQUB &78, &12, &28, &00, &3C, &3F, &89, &23, &3C, &00, &14, &BF
 EQUB &AB, &45, &28, &00, &3C, &BF, &9A, &34, &00, &1E, &14, &7F
 EQUB &FF, &FF, &0A, &18, &00, &09, &00, &00, &0A, &18, &00, &89
 EQUB &00, &00, &00, &16, &0A, &09, &00, &00, &1F, &01, &00, &08
 EQUB &1F, &12, &10, &08, &1F, &23, &14, &08, &1F, &30, &0C, &08
 EQUB &1F, &34, &1C, &0C, &1F, &45, &18, &0C, &1F, &50, &0C, &04
 EQUB &1F, &67, &00, &20, &1F, &78, &10, &20, &1F, &89, &14, &20
 EQUB &1F, &9A, &1C, &20, &1F, &AB, &18, &20, &1F, &B6, &04, &20
 EQUB &1F, &06, &04, &00, &1F, &17, &00, &10, &1F, &28, &10, &14
 EQUB &1F, &39, &14, &1C, &1F, &4A, &1C, &18, &1F, &5B, &18, &04
 EQUB &09, &00, &24, &28, &09, &00, &28, &2C, &09, &00, &2C, &24
 EQUB &1F, &00, &3E, &0E, &1F, &33, &24, &0C, &3F, &33, &1C, &19
 EQUB &3F, &00, &30, &2A, &BF, &33, &1C, &19, &9F, &33, &24, &0C
 EQUB &5F, &00, &3E, &0F, &5F, &1C, &38, &07, &7F, &1B, &37, &0D
 EQUB &7F, &00, &33, &26, &FF, &1B, &37, &0D, &DF, &1C, &38, &07


.s_bushmaster

 EQUB &00, &9A, &10, &5C, &A8, &51, &00, &1E, &48, &13, &96, &00
 EQUB &24, &14, &4A, &23, &00, &00, &02, &21, &00, &00, &3C, &1F
 EQUB &23, &01, &32, &00, &14, &1F, &57, &13, &32, &00, &14, &9F
 EQUB &46, &02, &00, &14, &00, &1F, &45, &01, &00, &14, &28, &7F
 EQUB &FF, &FF, &00, &0E, &28, &3F, &88, &45, &28, &00, &28, &3F
 EQUB &88, &57, &28, &00, &28, &BF, &88, &46, &00, &04, &28, &2A
 EQUB &88, &88, &0A, &00, &28, &2A, &88, &88, &00, &04, &28, &6A
 EQUB &88, &88, &0A, &00, &28, &AA, &88, &88, &1F, &13, &00, &04
 EQUB &1F, &02, &00, &08, &1F, &01, &00, &0C, &1F, &23, &00, &10
 EQUB &1F, &45, &0C, &14, &1F, &04, &08, &0C, &1F, &15, &04, &0C
 EQUB &1F, &46, &08, &1C, &1F, &57, &04, &18, &1F, &26, &08, &10
 EQUB &1F, &37, &04, &10, &1F, &48, &14, &1C, &1F, &58, &14, &18
 EQUB &1F, &68, &10, &1C, &1F, &78, &10, &18, &0A, &88, &20, &24
 EQUB &0A, &88, &24, &28, &0A, &88, &28, &2C, &0A, &88, &2C, &20
 EQUB &9F, &17, &58, &1D, &1F, &17, &58, &1D, &DF, &0E, &5D, &12
 EQUB &5F, &0E, &5D, &12, &BF, &1F, &59, &0D, &3F, &1F, &59, &0D
 EQUB &FF, &2A, &55, &07, &7F, &2A, &55, &07, &3F, &00, &00, &60


.s_rattler

 EQUB &02, &70, &17, &6E, &D6, &59, &00, &2A, &5A, &1A, &96, &00
 EQUB &34, &0A, &71, &1F, &00, &00, &01, &22, &00, &00, &3C, &1F
 EQUB &89, &23, &28, &00, &28, &1F, &9A, &34, &28, &00, &28, &9F
 EQUB &78, &12, &3C, &00, &00, &1F, &AB, &45, &3C, &00, &00, &9F
 EQUB &67, &01, &46, &00, &28, &3F, &CC, &5B, &46, &00, &28, &BF
 EQUB &CC, &06, &00, &14, &28, &3F, &FF, &FF, &00, &14, &28, &7F
 EQUB &FF, &FF, &0A, &06, &28, &AA, &CC, &CC, &0A, &06, &28, &EA
 EQUB &CC, &CC, &14, &00, &28, &AA, &CC, &CC, &0A, &06, &28, &2A
 EQUB &CC, &CC, &0A, &06, &28, &6A, &CC, &CC, &14, &00, &28, &2A
 EQUB &CC, &CC, &1F, &06, &10, &18, &1F, &17, &08, &10, &1F, &28
 EQUB &00, &08, &1F, &39, &00, &04, &1F, &4A, &04, &0C, &1F, &5B
 EQUB &0C, &14, &1F, &0C, &18, &1C, &1F, &6C, &18, &20, &1F, &01
 EQUB &10, &1C, &1F, &67, &10, &20, &1F, &12, &08, &1C, &1F, &78
 EQUB &08, &20, &1F, &23, &00, &1C, &1F, &89, &00, &20, &1F, &34
 EQUB &04, &1C, &1F, &9A, &04, &20, &1F, &45, &0C, &1C, &1F, &AB
 EQUB &0C, &20, &1F, &5C, &14, &1C, &1F, &BC, &14, &20, &0A, &CC
 EQUB &24, &28, &0A, &CC, &28, &2C, &0A, &CC, &2C, &24, &0A, &CC
 EQUB &30, &34, &0A, &CC, &34, &38, &0A, &CC, &38, &30, &9F, &1A
 EQUB &5C, &06, &9F, &17, &5C, &0B, &9F, &09, &5D, &12, &1F, &09
 EQUB &5D, &12, &1F, &17, &5C, &0B, &1F, &1A, &5C, &06, &DF, &1A
 EQUB &5C, &06, &DF, &17, &5C, &0B, &DF, &09, &5D, &12, &5F, &09
 EQUB &5D, &12, &5F, &17, &5C, &0B, &5F, &1A, &5C, &06, &3F, &00
 EQUB &00, &60


.s_iguana

 EQUB &01, &AC, &0D, &6E, &CA, &51, &00, &1A, &5A, &17, &96, &00
 EQUB &28, &0A, &5A, &21, &00, &00, &01, &23, &00, &00, &5A, &1F
 EQUB &23, &01, &00, &14, &1E, &1F, &46, &02, &28, &00, &0A, &9F
 EQUB &45, &01, &00, &14, &1E, &5F, &57, &13, &28, &00, &0A, &1F
 EQUB &67, &23, &00, &14, &28, &3F, &89, &46, &28, &00, &1E, &BF
 EQUB &88, &45, &00, &14, &28, &7F, &89, &57, &28, &00, &1E, &3F
 EQUB &99, &67, &28, &00, &28, &9E, &11, &00, &28, &00, &28, &1E
 EQUB &33, &22, &00, &08, &28, &2A, &99, &88, &10, &00, &24, &AA
 EQUB &88, &88, &00, &08, &28, &6A, &99, &88, &10, &00, &24, &2A
 EQUB &99, &99, &1F, &02, &00, &04, &1F, &01, &00, &08, &1F, &13
 EQUB &00, &0C, &1F, &23, &00, &10, &1F, &46, &04, &14, &1F, &45
 EQUB &08, &18, &1F, &57, &0C, &1C, &1F, &67, &10, &20, &1F, &48
 EQUB &14, &18, &1F, &58, &18, &1C, &1F, &69, &14, &20, &1F, &79
 EQUB &1C, &20, &1F, &04, &04, &08, &1F, &15, &08, &0C, &1F, &26
 EQUB &04, &10, &1F, &37, &0C, &10, &1F, &89, &14, &1C, &1E, &01
 EQUB &08, &24, &1E, &23, &10, &28, &0A, &88, &2C, &30, &0A, &88
 EQUB &34, &30, &0A, &99, &2C, &38, &0A, &99, &34, &38, &9F, &33
 EQUB &4D, &19, &DF, &33, &4D, &19, &1F, &33, &4D, &19, &5F, &33
 EQUB &4D, &19, &9F, &2A, &55, &00, &DF, &2A, &55, &00, &1F, &2A
 EQUB &55, &00, &5F, &2A, &55, &00, &BF, &17, &00, &5D, &3F, &17
 EQUB &00, &5D


.s_shuttle2

 EQUB &0F, &C4, &09, &7A, &EA, &59, &00, &26, &66, &1C, &00, &00
 EQUB &34, &0A, &20, &09, &00, &00, &02, &00, &00, &00, &28, &1F
 EQUB &23, &01, &00, &14, &1E, &1F, &34, &00, &14, &00, &1E, &9F
 EQUB &15, &00, &00, &14, &1E, &5F, &26, &11, &14, &00, &1E, &1F
 EQUB &37, &22, &14, &14, &14, &9F, &58, &04, &14, &14, &14, &DF
 EQUB &69, &15, &14, &14, &14, &5F, &7A, &26, &14, &14, &14, &1F
 EQUB &7B, &34, &00, &14, &28, &3F, &BC, &48, &14, &00, &28, &BF
 EQUB &9C, &58, &00, &14, &28, &7F, &AC, &69, &14, &00, &28, &3F
 EQUB &BC, &7A, &04, &04, &28, &AA, &CC, &CC, &04, &04, &28, &EA
 EQUB &CC, &CC, &04, &04, &28, &6A, &CC, &CC, &04, &04, &28, &2A
 EQUB &CC, &CC, &1F, &01, &00, &08, &1F, &12, &00, &0C, &1F, &23
 EQUB &00, &10, &1F, &30, &00, &04, &1F, &04, &04, &14, &1F, &05
 EQUB &08, &14, &1F, &15, &08, &18, &1F, &16, &0C, &18, &1F, &26
 EQUB &0C, &1C, &1F, &27, &10, &1C, &1F, &37, &10, &20, &1F, &34
 EQUB &04, &20, &1F, &48, &14, &24, &1F, &58, &14, &28, &1F, &59
 EQUB &18, &28, &1F, &69, &18, &2C, &1F, &6A, &1C, &2C, &1F, &7A
 EQUB &1C, &30, &1F, &7B, &20, &30, &1F, &4B, &20, &24, &1F, &8C
 EQUB &24, &28, &1F, &9C, &28, &2C, &1F, &AC, &2C, &30, &1F, &BC
 EQUB &30, &24, &0A, &CC, &34, &38, &0A, &CC, &38, &3C, &0A, &CC
 EQUB &3C, &40, &0A, &CC, &40, &34, &9F, &27, &27, &4E, &DF, &27
 EQUB &27, &4E, &5F, &27, &27, &4E, &1F, &27, &27, &4E, &1F, &00
 EQUB &60, &00, &9F, &60, &00, &00, &5F, &00, &60, &00, &1F, &60
 EQUB &00, &00, &BF, &42, &42, &16, &FF, &42, &42, &16, &7F, &42
 EQUB &42, &16, &3F, &42, &42, &16, &3F, &00, &00, &60


.s_chameleon

 EQUB &03, &A0, &0F, &80, &F4, &59, &00, &1A, &6C, &1D, &C8, &00
 EQUB &34, &0A, &64, &1D, &00, &00, &01, &23, &12, &00, &6E, &9F
 EQUB &25, &01, &12, &00, &6E, &1F, &34, &01, &28, &00, &00, &9F
 EQUB &8B, &25, &08, &18, &00, &9F, &68, &22, &08, &18, &00, &1F
 EQUB &69, &33, &28, &00, &00, &1F, &9A, &34, &08, &18, &00, &5F
 EQUB &7A, &44, &08, &18, &00, &DF, &7B, &55, &00, &18, &28, &1F
 EQUB &36, &02, &00, &18, &28, &5F, &57, &14, &20, &00, &28, &BF
 EQUB &BC, &88, &00, &18, &28, &3F, &9C, &68, &20, &00, &28, &3F
 EQUB &AC, &99, &00, &18, &28, &7F, &BC, &7A, &08, &00, &28, &AA
 EQUB &CC, &CC, &00, &08, &28, &2A, &CC, &CC, &08, &00, &28, &2A
 EQUB &CC, &CC, &00, &08, &28, &6A, &CC, &CC, &1F, &01, &00, &04
 EQUB &1F, &02, &00, &20, &1F, &15, &00, &24, &1F, &03, &04, &20
 EQUB &1F, &14, &04, &24, &1F, &34, &04, &14, &1F, &25, &00, &08
 EQUB &1F, &26, &0C, &20, &1F, &36, &10, &20, &1F, &75, &1C, &24
 EQUB &1F, &74, &18, &24, &1F, &39, &10, &14, &1F, &4A, &14, &18
 EQUB &1F, &28, &08, &0C, &1F, &5B, &08, &1C, &1F, &8B, &08, &28
 EQUB &1F, &9A, &14, &30, &1F, &68, &0C, &2C, &1F, &7B, &1C, &34
 EQUB &1F, &69, &10, &2C, &1F, &7A, &18, &34, &1F, &8C, &28, &2C
 EQUB &1F, &BC, &28, &34, &1F, &9C, &2C, &30, &1F, &AC, &30, &34
 EQUB &0A, &CC, &38, &3C, &0A, &CC, &3C, &40, &0A, &CC, &40, &44
 EQUB &0A, &CC, &44, &38, &1F, &00, &5A, &1F, &5F, &00, &5A, &1F
 EQUB &9F, &39, &4C, &0B, &1F, &39, &4C, &0B, &5F, &39, &4C, &0B
 EQUB &DF, &39, &4C, &0B, &1F, &00, &60, &00, &5F, &00, &60, &00
 EQUB &BF, &39, &4C, &0B, &3F, &39, &4C, &0B, &7F, &39, &4C, &0B
 EQUB &FF, &39, &4C, &0B, &3F, &00, &00, &60


ship_total = 38


.ship_list

 EQUW s_dodo, s_coriolis, s_escape, s_alloys
 EQUW s_barrel, s_boulder, s_asteroid, s_minerals
 EQUW s_shuttle1, s_transporter, s_cobra3, s_python
 EQUW s_boa, s_anaconda, s_worm, s_missile
 EQUW s_viper, s_sidewinder, s_mamba, s_krait
 EQUW s_adder, s_gecko, s_cobra1, s_asp
 EQUW s_ferdelance, s_moray, s_thargoid, s_thargon
 EQUW s_constrictor, s_dragon, s_monitor, s_ophidian
 EQUW s_ghavial, s_bushmaster, s_rattler, s_iguana
 EQUW s_shuttle2, s_chameleon

 EQUW &0000


.ship_data

 EQUW 0

.XX21

 EQUW s_missile, 0, s_escape
 EQUW s_alloys, s_barrel, s_boulder, s_asteroid
 EQUW s_minerals, 0, s_transporter, 0
 EQUW 0, 0, 0, 0
 EQUW s_viper, 0, 0, 0
 EQUW 0, 0, 0, 0
 EQUW 0, 0, 0, 0
 EQUW 0, s_thargoid, s_thargon, s_constrictor
 

.ship_flags

 EQUB &00

.E%
 EQUB &00, &40, &41
 EQUB &00, &00, &00, &00
 EQUB &00, &21, &61, &20
 EQUB &21, &20, &A1, &0C
 EQUB &C2, &0C, &0C, &04
 EQUB &0C, &04, &0C, &04
 EQUB &0C, &02, &22, &02
 EQUB &22, &0C, &04, &8C


.ship_bits

 EQUD %00000000000000000000000000000100
 EQUD %00000000000000000000000000000100
 EQUD %00000000000000000000000000001000
 EQUD %00000000000000000000000000010000
 EQUD %00000000000000000000000000100000
 EQUD %00000000000000000000000001000000
 EQUD %00000000000000000000000010000000
 EQUD %00000000000000000000000100000000
 EQUD %00000000000000000000001000000000
 EQUD %00000000000000000000010000000000
 EQUD %00011111111000000011100000000000
 EQUD %00011001110000000011100000000000
 EQUD %00000000000000000011100000000000
 EQUD %00000000000000000100000000000000
 EQUD %00000001110000001000000000000000
 EQUD %00000000000000000000000000000010
 EQUD %00000000000000010000000000000000
 EQUD %00010001111111101000000000000000
 EQUD %00010001111111100000000000000000
 EQUD %00010001111111100000000000000000
 EQUD %00011001111110000011000000000000
 EQUD %00011001111111100000000000000000
 EQUD %00011001111111100010000000000000
 EQUD %00011001000000000000000000000000
 EQUD %00011111000000000010000000000000
 EQUD %00011001110000000011000000000000
 EQUD %00100000000000000000000000000000
 EQUD %01000000000000000000000000000000
 EQUD %10000000000000000000000000000000
 EQUD %00000000000000000100000000000000
 EQUD %00010001000000000011100000000000
 EQUD %00010001111000000011000000000000
 EQUD %00010000000000000011100000000000
 EQUD %00011101111100000000000000000000
 EQUD %00010001110000000011000000000000
 EQUD %00011101111100000010000000000000
 EQUD %00000000000000000000011000000000
 EQUD %00010001110000000011000000000000

 EQUD %00011111111111100111111000000000


.ship_bytes

 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 050, &00, 0, 0
 EQUB 050, &00, 0, 0
 EQUB 070, &80, 0, 2
 EQUB 065, &80, 0, 2
 EQUB 060, &80, 0, 2
 EQUB 010, &80, 0, 0
 EQUB 015, &00, 0, 0
 EQUB 000, &00, 0, 0
 EQUB 000, &80, 0, 2
 EQUB 090, &00, 0, 2
 EQUB 100, &80, 0, 2
 EQUB 100, &80, 0, 2
 EQUB 085, &80, 0, 2
 EQUB 080, &80, 0, 2
 EQUB 080, &80, 0, 2
 EQUB 010, &80, 0, 0
 EQUB 060, &80, 0, 1
 EQUB 060, &80, 0, 1
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 000, &00, 0, 2
 EQUB 003, &00, 0, 0
 EQUB 030, &80, 0, 0
 EQUB 075, &80, 0, 2
 EQUB 050, &80, 0, 1
 EQUB 075, &80, 0, 2
 EQUB 055, &80, 0, 1
 EQUB 060, &80, 0, 1
 EQUB 050, &00, 0, 0
 EQUB 045, &80, 0, 1

 EQUB 255, &00, 0, 0

\ ******************************************************************************
\
\ Save output/2.T.bin
\
\ ******************************************************************************

PRINT "S.2.T ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/2.T.bin", CODE%, P%, LOAD%