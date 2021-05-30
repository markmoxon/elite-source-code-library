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

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

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

 \ a.qcode - ELITE III second processor code

\EXEC = boot_in

dockedp = &A0
brk_line = &FD
BRKV = &202
cmdr_ship = &36D
cmdr_cour = &387
cmdr_courx = &389
cmdr_coury = &38A

a_flag = &3C8
b_flag = &3CE

save_lock = &233
new_file = &234
new_posn = &235
new_type = &36D
new_pulse = &3D0
new_beam = &3D1
new_military = &3D2
new_mining = &3D3
new_mounts = &3D4
new_missiles = &3D5
new_shields = &3D6
new_energy = &3D7
new_speed = &3D8
new_hold = &3D9
new_range = &3DA
new_costs = &3DB
new_max = &3DC
new_min = &3DD
new_space = &3DE
 \new_:	EQU &3DF
 \new_name:	EQU &74D

osfile = &FFDD
oswrch = &FFEE
osword = &FFF1
osbyte = &FFF4
oscli = &FFF7

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

.scramble

 STA save_lock

INCLUDE "library/enhanced/main/subroutine/brkbk.asm"

.write_msg3

 PHA
 TAX
 TYA
 PHA
 LDA &22
 PHA
 LDA &23
 PHA
 LDA #LO(msg_3)
 STA &22
 LDA #HI(msg_3)
 BNE DTEN

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


.plf2

 STX &93
 STA &96
 JSR TT27
 LDX &87
 CPX #&08
 BEQ status_keep
 LDA #&15
 STA XC
 JSR vdu_80
 LDA #&01
 STA &03AB
 JSR sell_yn
 BEQ status_no
 BCS status_no
 LDA &96
 CMP #&6B
 BCS status_over
 ADC #&07

.status_over

 SBC #&68
 JSR prx-3
 LSR A
 TAY
 TXA
 ROR A
 TAX
 JSR MCASH
 INC new_hold	\**
 LDX &93
 LDA #&00
 STA LASER,X
 JSR update_pod

.status_no

 LDX #&01

.status_keep

 STX XC
 LDA #&0A
 JMP TT27

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

.l_200e

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
 BCC l_200e
 LDA #&10

.l_204e

 STA &84
 LDA #&9B
 JSR tube_write
 LDA &84
 JSR tube_write
 LDA &84
 CLC
 ADC #&10
 BNE l_204e
 RTS

.HAS1

 JSR ZINF
 LDA &34
 STA &4C
 LSR A
 ROR &48
 LDA &35
 STA &46
 LSR A
 LDA #&01
 ADC #&00
 STA &4D
 LDA #&80
 STA &4B
 STA &9A
 LDA #&0B
 STA &68
 JSR DORND
 STA &84

.HAL5

 LDX #&15
 LDY #&09
 JSR MVS5
 LDX #&17
 LDY #&0B
 JSR MVS5
 LDX #&19
 LDY #&0D
 JSR MVS5
 DEC &84
 BNE HAL5
 LDY &36
 BEQ HA1
 LDX #&04

.hloop

 INX
 INX
 LDA XX21-2,X
 STA &1E
 LDA XX21-1,X
 STA &1F
 BEQ hloop
 DEY
 BNE hloop
 LDY #&01
 LDA (&1E),Y
 STA &81
 INY
 LDA (&1E),Y
 STA &82
 JSR LL5
 LDA #&64
 SBC &81
 LSR A
 STA &49
 JSR TIDY
 JMP LL9         \ Same as LL9_FLIGHT

.HA1

 RTS

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
 LDY #&01	\INY
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


.sell_yn

 LDA #&CD
 JSR TT27
 LDA #&CE
 JSR DETOK

INCLUDE "library/common/main/subroutine/gnum.asm"

.sell_jump

 INC XC
 LDA #&CF
 JSR NLIN3
 JSR TT69
 JSR TT67
 JSR sell_equip
 LDA ESCP
 BEQ sell_escape
 LDA #&70
 LDX #&1E
 JSR plf2

.sell_escape

 JMP BAY

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

.TT100

 DEC &034A
 BEQ me2
 BPL me3
 INC &034A

.me3

 DEC &8A

INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"

.dead_in

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

.confirm

 CMP save_lock
 BEQ confirmed
 LDA #&03
 JSR DETOK
 JSR t
 JSR CHPR
 ORA #&20
 PHA
 JSR TT67
 JSR FEED
 PLA
 CMP #&79

.confirmed

 RTS

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


.LL10

 LDA &4D
 CMP #&C0
 BCS LL14
 LDA &46
 CMP &4C
 LDA &47
 SBC &4D
 BCS LL14
 LDA &49
 CMP &4C
 LDA &4A
 SBC &4D
 BCS LL14
 LDY #&06
 LDA (&1E),Y
 TAX
 LDA #&FF
 STA &0100,X
 STA &0101,X
 LDA &4C
 STA &D1
 LDA &4D
 LSR A
 ROR &D1
 LSR A
 ROR &D1
 LSR A
 ROR &D1
 LSR A
 BNE l_40aa
 LDA &D1
 ROR A
 LSR A
 LSR A
 LSR A
 STA &96
 BPL l_40bb

.l_40aa

 LDY #&0D
 LDA (&1E),Y
 CMP &4D
 BCS l_40bb
 LDA #&20
 AND &65
 BNE l_40bb
 JMP SHPPT

.l_40bb

 LDX #&05

.l_40bd

 LDA &5B,X
 STA &09,X
 LDA &55,X
 STA &0F,X
 LDA &4F,X
 STA &15,X
 DEX
 BPL l_40bd
 LDA #&C5
 STA &81
 LDY #&10

.l_40d2

 LDA &09,Y
 ASL A
 LDA &0A,Y
 ROL A
 JSR LL28
 LDX &82
 STX &09,Y
 DEY
 DEY
 BPL l_40d2
 LDX #&08

.l_40e7

 LDA &46,X
 STA QQ17,X
 DEX
 BPL l_40e7
 LDA #&FF
 STA &E1
 LDY #&0C
 LDA &65
 AND #&20
 BEQ l_410c
 LDA (&1E),Y
 LSR A
 LSR A
 TAX
 LDA #&FF

.l_4101

 STA &D2,X
 DEX
 BPL l_4101
 INX
 STX &96

.l_4109

 JMP l_427f

.l_410c

 LDA (&1E),Y
 BEQ l_4109
 STA &97
 LDY #&12
 LDA (&1E),Y
 TAX
 LDA &79
 TAY
 BEQ l_412b

.l_411c

 INX
 LSR &76
 ROR &75
 LSR &73
 ROR QQ17
 LSR A
 ROR &78
 TAY
 BNE l_411c

.l_412b

 STX &86
 LDA &7A
 STA &39
 LDA QQ17
 STA &34
 LDA &74
 STA &35
 LDA &75
 STA &36
 LDA &77
 STA &37
 LDA &78
 STA &38
 JSR LL51
 LDA &3A
 STA QQ17
 LDA &3B
 STA &74
 LDA &3C
 STA &75
 LDA &3D
 STA &77
 LDA &3E
 STA &78
 LDA &3F
 STA &7A
 LDY #&04
 LDA (&1E),Y
 CLC
 ADC &1E
 STA &22
 LDY #&11
 LDA (&1E),Y
 ADC &1F
 STA &23
 LDY #&00

.l_4173

 LDA (&22),Y
 STA &3B
 AND #&1F
 CMP &96
 BCS l_418c
 TYA
 LSR A
 LSR A
 TAX
 LDA #&FF
 STA &D2,X
 TYA
 ADC #&04
 TAY
 JMP l_4278

.l_418c

 LDA &3B
 ASL A
 STA &3D
 ASL A
 STA &3F
 INY
 LDA (&22),Y
 STA &3A
 INY
 LDA (&22),Y
 STA &3C
 INY
 LDA (&22),Y
 STA &3E
 LDX &86
 CPX #&04
 BCC l_41cc
 LDA QQ17
 STA &34
 LDA &74
 STA &35
 LDA &75
 STA &36
 LDA &77
 STA &37
 LDA &78
 STA &38
 LDA &7A
 STA &39
 JMP l_422a

.l_41c4

 LSR QQ17
 LSR &78
 LSR &75
 LDX #&01

.l_41cc

 LDA &3A
 STA &34
 LDA &3C
 STA &36
 LDA &3E
 DEX
 BMI l_41e1

.l_41d9

 LSR &34
 LSR &36
 LSR A
 DEX
 BPL l_41d9

.l_41e1

 STA &82
 LDA &3F
 STA &83
 LDA &78
 STA &81
 LDA &7A
 JSR LL38
 BCS l_41c4
 STA &38
 LDA &83
 STA &39
 LDA &34
 STA &82
 LDA &3B
 STA &83
 LDA QQ17
 STA &81
 LDA &74
 JSR LL38
 BCS l_41c4
 STA &34
 LDA &83
 STA &35
 LDA &36
 STA &82
 LDA &3D
 STA &83
 LDA &75
 STA &81
 LDA &77
 JSR LL38
 BCS l_41c4
 STA &36
 LDA &83
 STA &37

.l_422a

 LDA &3A
 STA &81
 LDA &34
 JSR FMLTU
 STA &D1
 LDA &3B
 EOR &35
 STA &83
 LDA &3C
 STA &81
 LDA &36
 JSR FMLTU
 STA &81
 LDA &D1
 STA &82
 LDA &3D
 EOR &37
 JSR LL38
 STA &D1
 LDA &3E
 STA &81
 LDA &38
 JSR FMLTU
 STA &81
 LDA &D1
 STA &82
 LDA &39
 EOR &3F
 JSR LL38
 PHA
 TYA
 LSR A
 LSR A
 TAX
 PLA
 BIT &83
 BMI l_4275
 LDA #&00

.l_4275

 STA &D2,X
 INY

.l_4278

 CPY &97
 BCS l_427f
 JMP l_4173

.l_427f

 LDY &0B
 LDX &0C
 LDA &0F
 STA &0B
 LDA &10
 STA &0C
 STY &0F
 STX &10
 LDY &0D
 LDX &0E
 LDA &15
 STA &0D
 LDA &16
 STA &0E
 STY &15
 STX &16
 LDY &13
 LDX &14
 LDA &17
 STA &13
 LDA &18
 STA &14
 STY &17
 STX &18
 LDY #&08
 LDA (&1E),Y
 STA &97
 LDA &1E
 CLC
 ADC #&14
 STA &22
 LDA &1F
 ADC #&00
 STA &23
 LDY #&00
 STY &93

.l_42c6

 STY &86
 LDA (&22),Y
 STA &34
 INY
 LDA (&22),Y
 STA &36
 INY
 LDA (&22),Y
 STA &38
 INY
 LDA (&22),Y
 STA &D1
 AND #&1F
 CMP &96
 BCC l_430f
 INY
 LDA (&22),Y
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_4312
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_4312
 INY
 LDA (&22),Y
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_4312
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_4312

.l_430f

 JMP l_4487

.l_4312

 LDA &D1
 STA &35
 ASL A
 STA &37
 ASL A
 STA &39
 JSR LL51
 LDA &48
 STA &36
 EOR &3B
 BMI l_4337
 CLC
 LDA &3A
 ADC &46
 STA &34
 LDA &47
 ADC #&00
 STA &35
 JMP l_435a

.l_4337

 LDA &46
 SEC
 SBC &3A
 STA &34
 LDA &47
 SBC #&00
 STA &35
 BCS l_435a
 EOR #&FF
 STA &35
 LDA #&01
 SBC &34
 STA &34
 BCC l_4354
 INC &35

.l_4354

 LDA &36
 EOR #&80
 STA &36

.l_435a

 LDA &4B
 STA &39
 EOR &3D
 BMI l_4372
 CLC
 LDA &3C
 ADC &49
 STA &37
 LDA &4A
 ADC #&00
 STA &38
 JMP l_4397

.l_4372

 LDA &49
 SEC
 SBC &3C
 STA &37
 LDA &4A
 SBC #&00
 STA &38
 BCS l_4397
 EOR #&FF
 STA &38
 LDA &37
 EOR #&FF
 ADC #&01
 STA &37
 LDA &39
 EOR #&80
 STA &39
 BCC l_4397
 INC &38

.l_4397

 LDA &3F
 BMI l_43e5
 LDA &3E
 CLC
 ADC &4C
 STA &D1
 LDA &4D
 ADC #&00
 STA &80
 JMP l_4404

.l_43ab

 LDX &81
 BEQ l_43cb
 LDX #&00

.l_43b1

 LSR A
 INX
 CMP &81
 BCS l_43b1
 STX &83
 JSR LL28
 LDX &83
 LDA &82

.l_43c0

 ASL A
 ROL &80
 BMI l_43cb
 DEX
 BNE l_43c0
 STA &82
 RTS

.l_43cb

 LDA #&32
 STA &82
 STA &80
 RTS

.l_43d2

 LDA #&80
 SEC
 SBC &82
 STA &0100,X
 INX
 LDA #&00
 SBC &80
 STA &0100,X
 JMP l_4444

.l_43e5

 LDA &4C
 SEC
 SBC &3E
 STA &D1
 LDA &4D
 SBC #&00
 STA &80
 BCC l_43fc
 BNE l_4404
 LDA &D1
 CMP #&04
 BCS l_4404

.l_43fc

 LDA #&00
 STA &80
 LDA #&04
 STA &D1

.l_4404

 LDA &80
 ORA &35
 ORA &38
 BEQ l_441b
 LSR &35
 ROR &34
 LSR &38
 ROR &37
 LSR &80
 ROR &D1
 JMP l_4404

.l_441b

 LDA &D1
 STA &81
 LDA &34
 CMP &81
 BCC l_442b
 JSR l_43ab
 JMP l_442e

.l_442b

 JSR LL28

.l_442e

 LDX &93
 LDA &36
 BMI l_43d2
 LDA &82
 CLC
 ADC #&80
 STA &0100,X
 INX
 LDA &80
 ADC #&00
 STA &0100,X

.l_4444

 TXA
 PHA
 LDA #&00
 STA &80
 LDA &D1
 STA &81
 LDA &37
 CMP &81
 BCC l_446d
 JSR l_43ab
 JMP l_4470

.l_445a

 LDA #&60
 CLC
 ADC &82
 STA &0100,X
 INX
 LDA #&00
 ADC &80
 STA &0100,X
 JMP l_4487

.l_446d

 JSR LL28

.l_4470

 PLA
 TAX
 INX
 LDA &39
 BMI l_445a
 LDA #&60
 SEC
 SBC &82
 STA &0100,X
 INX
 LDA #&00
 SBC &80
 STA &0100,X

.l_4487

 CLC
 LDA &93
 ADC #&04
 STA &93
 LDA &86
 ADC #&06
 TAY
 BCS l_449c
 CMP &97
 BCS l_449c
 JMP l_42c6

.l_449c

 LDA &65
 AND #&20
 BEQ l_44ab
 LDA &65
 ORA #&08
 STA &65
 JMP DOEXP	\JMP TT48

.l_44ab

 LDA #&08
 BIT &65
 BEQ l_44b6
 JSR LL155
 LDA #&08

.l_44b6

 ORA &65
 STA &65
 LDY #&09
 LDA (&1E),Y
 STA &97
 LDY #&00
 STY &80
 STY &86
 INC &80
 BIT &65
 BVC l_4520
 LDA &65
 AND #&BF
 STA &65
 LDY #&06
 LDA (&1E),Y
 TAY
 LDX &0100,Y
 STX &34
 INX
 BEQ l_4520
 LDX &0101,Y
 STX &35
 INX
 BEQ l_4520
 LDX &0102,Y
 STX &36
 LDX &0103,Y
 STX &37
 LDA #&00
 STA &38
 STA &39
 STA &3B
 LDA &4C
 STA &3A
 LDA &48
 BPL l_4503
 DEC &38

.l_4503

 JSR LL145
 BCS l_4520
 LDY &80
 LDA &34
 STA (&67),Y
 INY
 LDA &35
 STA (&67),Y
 INY
 LDA &36
 STA (&67),Y
 INY
 LDA &37
 STA (&67),Y
 INY
 STY &80

.l_4520

 LDY #&03
 CLC
 LDA (&1E),Y
 ADC &1E
 STA &22
 LDY #&10
 LDA (&1E),Y
 ADC &1F
 STA &23
 LDY #&05
 LDA (&1E),Y
 STA &06
 LDY &86

.l_4539

 LDA (&22),Y
 CMP &96
 BCC l_4557
 INY
 LDA (&22),Y
 INY
 STA &1B
 AND #&0F
 TAX
 LDA &D2,X
 BNE l_455a
 LDA &1B
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA &D2,X
 BNE l_455a

.l_4557

 JMP l_46d6

.l_455a

 LDA (&22),Y
 TAX
 INY
 LDA (&22),Y
 STA &81
 LDA &0101,X
 STA &35
 LDA &0100,X
 STA &34
 LDA &0102,X
 STA &36
 LDA &0103,X
 STA &37
 LDX &81
 LDA &0100,X
 STA &38
 LDA &0103,X
 STA &3B
 LDA &0102,X
 STA &3A
 LDA &0101,X
 STA &39
 JSR l_459a
 BCS l_4557
 JMP l_46ba

.LL145

 LDA #&00
 STA &90
 LDA &39

.l_459a

 LDX #&BF
 ORA &3B
 BNE l_45a6
 CPX &3A
 BCC l_45a6
 LDX #&00

.l_45a6

 STX &89
 LDA &35
 ORA &37
 BNE l_45ca
 LDA #&BF
 CMP &36
 BCC l_45ca
 LDA &89
 BNE l_45c8

.l_45b8

 LDA &36
 STA &35
 LDA &38
 STA &36
 LDA &3A
 STA &37
 CLC
 RTS

.l_45c6

 SEC
 RTS

.l_45c8

 LSR &89

.l_45ca

 LDA &89
 BPL l_45fd
 LDA &35
 AND &39
 BMI l_45c6
 LDA &37
 AND &3B
 BMI l_45c6
 LDX &35
 DEX
 TXA
 LDX &39
 DEX
 STX &3C
 ORA &3C
 BPL l_45c6
 LDA &36
 CMP #&C0
 LDA &37
 SBC #&00
 STA &3C
 LDA &3A
 CMP #&C0
 LDA &3B
 SBC #&00
 ORA &3C
 BPL l_45c6

.l_45fd

 TYA
 PHA
 LDA &38
 SEC
 SBC &34
 STA &3C
 LDA &39
 SBC &35
 STA &3D
 LDA &3A
 SEC
 SBC &36
 STA &3E
 LDA &3B
 SBC &37
 STA &3F
 EOR &3D
 STA &83
 LDA &3F
 BPL l_462e
 LDA #&00
 SEC
 SBC &3E
 STA &3E
 LDA #&00
 SBC &3F
 STA &3F

.l_462e

 LDA &3D
 BPL l_463d
 SEC
 LDA #&00
 SBC &3C
 STA &3C
 LDA #&00
 SBC &3D

.l_463d

 TAX
 BNE l_4644
 LDX &3F
 BEQ l_464e

.l_4644

 LSR A
 ROR &3C
 LSR &3F
 ROR &3E
 JMP l_463d

.l_464e

 STX &D1
 LDA &3C
 CMP &3E
 BCC l_4660
 STA &81
 LDA &3E
 JSR LL28
 JMP l_466b

.l_4660

 LDA &3E
 STA &81
 LDA &3C
 JSR LL28
 DEC &D1

.l_466b

 LDA &82
 STA &3C
 LDA &83
 STA &3D
 LDA &89
 BEQ l_4679
 BPL l_468c

.l_4679

 JSR l_471a
 LDA &89
 BPL l_46b1
 LDA &35
 ORA &37
 BNE l_46b6
 LDA &36
 CMP #&C0
 BCS l_46b6

.l_468c

 LDX &34
 LDA &38
 STA &34
 STX &38
 LDA &39
 LDX &35
 STX &39
 STA &35
 LDX &36
 LDA &3A
 STA &36
 STX &3A
 LDA &3B
 LDX &37
 STX &3B
 STA &37
 JSR l_471a
 DEC &90

.l_46b1

 PLA
 TAY
 JMP l_45b8

.l_46b6

 PLA
 TAY
 SEC
 RTS

.l_46ba

 LDY &80
 LDA &34
 STA (&67),Y
 INY
 LDA &35
 STA (&67),Y
 INY
 LDA &36
 STA (&67),Y
 INY
 LDA &37
 STA (&67),Y
 INY
 STY &80
 CPY &06
 BCS LL81

.l_46d6

 INC &86
 LDY &86
 CPY &97
 BCS LL81
 LDY #&00
 LDA &22
 ADC #&04
 STA &22
 BCC l_46ea
 INC &23

.l_46ea

 JMP l_4539

.LL81

 LDA &80

.l_46ef

 LDY #&00
 STA (&67),Y

.LL155

 LDY #&00
 LDA (&67),Y
 STA &97
 CMP #&04
 BCC l_4719
 INY

.l_46fe

 LDA (&67),Y
 STA &34
 INY
 LDA (&67),Y
 STA &35
 INY
 LDA (&67),Y
 STA &36
 INY
 LDA (&67),Y
 STA &37
 JSR LOIN
 INY
 CPY &97
 BCC l_46fe

.l_4719

 RTS

.l_471a

 LDA &35
 BPL l_4735
 STA &83
 JSR l_4794
 TXA
 CLC
 ADC &36
 STA &36
 TYA
 ADC &37
 STA &37
 LDA #&00
 STA &34
 STA &35
 TAX

.l_4735

 BEQ l_4750
 STA &83
 DEC &83
 JSR l_4794
 TXA
 CLC
 ADC &36
 STA &36
 TYA
 ADC &37
 STA &37
 LDX #&FF
 STX &34
 INX
 STX &35

.l_4750

 LDA &37
 BPL l_476e
 STA &83
 LDA &36
 STA &82
 JSR l_47c3
 TXA
 CLC
 ADC &34
 STA &34
 TYA
 ADC &35
 STA &35
 LDA #&00
 STA &36
 STA &37

.l_476e

 LDA &36
 SEC
 SBC #&C0
 STA &82
 LDA &37
 SBC #&00
 STA &83
 BCC l_4793
 JSR l_47c3
 TXA
 CLC
 ADC &34
 STA &34
 TYA
 ADC &35
 STA &35
 LDA #&BF
 STA &36
 LDA #&00
 STA &37

.l_4793

 RTS

.l_4794

 LDA &34
 STA &82
 JSR l_47ff
 PHA
 LDX &D1
 BNE l_47cb

.l_47a0

 LDA #&00
 TAX
 TAY
 LSR &83
 ROR &82
 ASL &81
 BCC l_47b5

.l_47ac

 TXA
 CLC
 ADC &82
 TAX
 TYA
 ADC &83
 TAY

.l_47b5

 LSR &83
 ROR &82
 ASL &81
 BCS l_47ac
 BNE l_47b5
 PLA
 BPL l_47f2
 RTS

.l_47c3

 JSR l_47ff
 PHA
 LDX &D1
 BNE l_47a0

.l_47cb

 LDA #&FF
 TAY
 ASL A
 TAX

.l_47d0

 ASL &82
 ROL &83
 LDA &83
 BCS l_47dc
 CMP &81
 BCC l_47e7

.l_47dc

 SBC &81
 STA &83
 LDA &82
 SBC #&00
 STA &82
 SEC

.l_47e7

 TXA
 ROL A
 TAX
 TYA
 ROL A
 TAY
 BCS l_47d0
 PLA
 BMI l_47fe

.l_47f2

 TXA
 EOR #&FF
 ADC #&01
 TAX
 TYA
 EOR #&FF
 ADC #&00
 TAY

.l_47fe

 RTS

.l_47ff

 LDX &3C
 STX &81
 LDA &83
 BPL l_4818
 LDA #&00
 SEC
 SBC &82
 STA &82
 LDA &83
 PHA
 EOR #&FF
 ADC #&00
 STA &83
 PLA

.l_4818

 EOR &3D
 RTS

 \ additions start here

.n_buyship

 LDX #&00
 SEC
 LDA #&0F	\LDA #&0D
 SBC QQ28
 SBC QQ28	\++
 STA &03AB

.n_bloop

 STX &89
 JSR TT67
 LDX &89
 INX
 CLC
 JSR pr2
 JSR TT162
 LDY &89
 JSR n_name
 LDY &89
 JSR n_price
 LDA #&16
 STA XC
 LDA #&09
 STA &80
 SEC
 JSR BPRNT
 LDX &89
 INX
 CPX &03AB
 BCC n_bloop
 JSR CLYNS
 LDA #&B9
 JSR prq
 JSR gnum
 BEQ jmp_start3
 BCS jmp_start3
 SBC #&00
 CMP &03AB
 BCS jmp_start3
 LDX #&02
 STX XC
 INC YC
 STA &81
 LDY new_type
 JSR n_price
 CLC
 LDX #3

.n_addl

 LDA CASH,X
 ADC &40,X
 STA &09,X
 DEX
 BPL n_addl
 LDY &81
 JSR n_price
 SEC
 LDX #3

.n_subl

 LDA &09,X
 SBC &40,X
 STA &40,X
 DEX
 BPL n_subl
 LDA &81
 BCS n_buy

.cash_query

 LDA #&C5
 JSR prq

.jmp_start3

 JSR dn2
 JMP BAY

.n_buy

 TAX
 LDY #3

.n_cpyl

 LDA &40,Y
 STA CASH,Y
 DEY
 BPL n_cpyl
 LDA #&00
 LDY #&24

.n_wipe

 STA &0368,Y
 DEY
 BPL n_wipe
 STX new_type
 JSR n_load
 LDA new_range
 STA QQ14
 JSR msblob
 JSR update_pod
 JMP BAY


.n_load

 LDY new_type
 LDX new_offsets,Y
 LDY #0

.n_lname

 CPY #9
 BCS n_linfo
 LDA new_ships,X
 EOR #&23
 STA new_name,Y

.n_linfo

 LDA new_details,X
 STA new_pulse,Y
 INX
 INY
 CPY #13
 BNE n_lname
 LDA new_max
 EOR #&FE
 STA new_min
 LDY #&0B

.count_lasers

 LDX count_offs,Y
 LDA LASER,X
 BEQ count_sys
 DEC new_hold	\**

.count_sys

 DEY
 BPL count_lasers
 RTS

.count_offs

 EQUB &00, &01, &02, &03, &06, &18, &19, &1A, &1B, &1C, &1D, &1E


.n_name

 \ name ship in 0 <= Y <= &C
 LDX new_offsets,Y
 LDA #9
 STA &41

.n_lprint

 LDA new_ships,X
 STX &40
 JSR TT27
 LDX &40
 INX
 DEC &41
 BNE n_lprint
 RTS


.n_price

 \ put price 0 <= Y <= &C into 40-43
 LDX new_offsets,Y
 LDY #3

.n_lprice

 LDA new_price,X
 STA &40,Y
 INX
 DEY
 BPL n_lprice
 RTS


.cour_buy

 LDA cmdr_cour
 ORA cmdr_cour+1
 BEQ cour_start
 JMP jmp_start3

.cour_start

 LDA #&0A
 STA XC
 LDA #&6F
 JSR DETOK
 JSR NLIN4
 LDA #&80
 STA QQ17
 LDA QQ26
 EOR QQ0
 EOR QQ1
 EOR FIST
 EOR TALLY
 STA &46
 SEC
 LDA FIST
 ADC GCNT
 ADC cmdr_ship
 STA &47
 ADC &46
 SBC cmdr_courx
 SBC cmdr_coury
 AND #&0F
 STA &03AB
 BEQ cour_pres
 LDA #&00
 STA &49
 STA &4C
 JSR TT81

.cour_loop

 LDA &49
 CMP &03AB
 BCC cour_count

.cour_menu

 JSR CLYNS
 LDA #&CE
 JSR prq
 JSR gnum
 BEQ cour_pres
 BCS cour_pres
 TAX
 DEX
 CPX &49
 BCS cour_pres
 LDA #&02
 STA XC
 INC YC
 STX &46
 LDY &0C50,X
 LDA &0C40,X
 TAX
 JSR LCASH
 BCS cour_cash
 JMP cash_query

.cour_cash

 LDX &46
 LDA &0C00,X
 STA cmdr_courx
 LDA &0C10,X
 STA cmdr_coury
 CLC
 LDA &0C20,X
 ADC FIST
 STA FIST
 LDA &0C30,X
 STA cmdr_cour+1
 LDA &0C40,X
 STA cmdr_cour

.cour_pres

 JMP jmp_start3

.cour_count

 JSR TT20
 INC &4C
 BEQ cour_menu
 DEC &46
 BNE cour_count	
 LDX &49
 LDA &6F
 CMP QQ0
 BNE cour_star
 LDA &6D
 CMP QQ1
 BNE cour_star
 JMP cour_next

.cour_star

 LDA &6F
 EOR &71
 EOR &47
 CMP FIST
 BCC cour_legal
 LDA #0

.cour_legal

 STA &0C20,X
 LDA &6F
 STA &0C00,X
 SEC
 SBC QQ0
 BCS cour_negx
 EOR #&FF
 ADC #&01

.cour_negx

 JSR SQUA2
 STA &41
 LDA &1B
 STA &40
 LDX &49
 LDA &6D
 STA &0C10,X
 SEC
 SBC QQ1
 BCS cour_negy
 EOR #&FF
 ADC #&01

.cour_negy

 LSR A
 JSR SQUA2
 PHA
 LDA &1B
 CLC
 ADC &40
 STA &81
 PLA
 ADC &41
 STA &82
 JSR LL5
 LDX &49
 LDA &6D
 EOR &71
 EOR &47
 LSR A
 LSR A
 LSR A
 CMP &81
 BCS cour_dist
 LDA &81

.cour_dist

 ORA &0C20,X
 STA &0C30,X
 STA &4A
 LSR A
 ROR &4A
 LSR A
 ROR &4A
 LSR A
 ROR &4A
 STA &4B
 STA &0C50,X
 LDA &4A
 STA &0C40,X
 LDA #&01
 STA XC
 CLC
 LDA &49
 ADC #&03
 STA YC
 LDX &49
 INX
 CLC
 JSR pr2
 JSR TT162
 JSR cpl
 LDX &4A
 LDY &4B
 SEC
 LDA #&19
 STA XC
 LDA #&06
 JSR TT11
 INC &49

.cour_next

 LDA &47
 STA &46
 JMP cour_loop


.cour_dock

 LDA cmdr_cour
 ORA cmdr_cour+1
 BEQ cour_quit
 LDA QQ0
 CMP cmdr_courx
 BNE cour_half
 LDA QQ1
 CMP cmdr_coury
 BNE cour_half
 LDA #&02
 JSR TT66
 LDA #&06
 STA XC
 LDA #&0A
 STA YC
 LDA #&71
 JSR DETOK
 LDX cmdr_cour
 LDY cmdr_cour+1
 SEC
 LDA #&06
 JSR TT11
 LDA #&E2
 JSR TT27
 LDX cmdr_cour
 LDY cmdr_cour+1
 JSR MCASH
 LDA #0
 STA cmdr_cour
 STA cmdr_cour+1
 LDY #&60
 JSR DELAY

.cour_half

 LSR cmdr_cour+1
 ROR cmdr_cour

.cour_quit

 RTS


.stay_here

 LDX #&F4
 LDY #&01
 JSR LCASH
 BCC stay_quit
 JSR cour_dock
 JSR DORND
 STA QQ26
 JSR GVL

.stay_quit

 JMP BAY

INCLUDE "library/common/main/subroutine/gvl.asm"

.new_offsets

 EQUB   0,  13,  26,  39,  52,  65,  78,  91
 EQUB 104, 117, 130, 143, 156, 169, 182	\, 195

 \ Name
 \ Price
 \ Pulse, Beam, Military, Mining Lasers, Mounts, Missiles
 \ Shields, Energy, Speed, Hold, Range, Costs
 \ Manouvre-h, Manoevre-l	\, Spare, Spare

.new_ships


.new_adder

 EQUS "ADDER    "

.new_price

IF _SOURCE_DISC

 EQUD 270000

 EQUS "GECKO    "
 EQUD 325000

 EQUS "MORAY    "
 EQUD 360000

 EQUS "COBRA MK1"
 EQUD 395000

 EQUS "IGUANA   "
 EQUD 640000

 EQUS "OPHIDIAN "
 EQUD 645000

 EQUS "CHAMELEON"
 EQUD 975000

 EQUS "COBRA MK3"
 EQUD 1000000

 EQUS "GHAVIAL  "
 EQUD 1365000

 EQUS "F", &90, "-DE-L", &9B, &85
 EQUD 1435000

 EQUS "MONITOR  "
 EQUD 1750000

 EQUS "PYTHON   "
 EQUD 2050000

 EQUS "BOA      "
 EQUD 2400000

 EQUS "ANACONDA "
 EQUD 4000000

 EQUS "ASP MK2  "
 EQUD 8950000

ELIF _RELEASED

 EQUD 310000

 EQUS "GECKO    "
 EQUD 400000

 EQUS "MORAY    "
 EQUD 565000

 EQUS "COBRA MK1"
 EQUD 750000

 EQUS "IGUANA   "
 EQUD 1315000

 EQUS "OPHIDIAN "
 EQUD 1470000

 EQUS "CHAMELEON"
 EQUD 2250000

 EQUS "COBRA MK3"
 EQUD 2870000

 EQUS "F", &90, "-DE-L", &9B, &85
 EQUD 3595000

 EQUS "GHAVIAL  "
 EQUD 3795000

 EQUS "MONITOR  "
 EQUD 5855000

 EQUS "PYTHON   "
 EQUD 7620000

 EQUS "BOA      "
 EQUD 9600000

 EQUS "ASP MK2  "
 EQUD 10120000

 EQUS "ANACONDA "
 EQUD 18695000

ENDIF

.new_details

 EQUB &0E, &8E, &92, &19, &02, &02	\ adder
 EQUB &04, &01,  36, &09,  60, &1A
 EQUB &DF	\, &21, &05, &00

 EQUB &0E, &8F, &93, &19, &04, &03	\ gecko
 EQUB &05, &01,  45, &0A,  70, &1A
 EQUB &EF	\, &11, &06, &00

 EQUB &10, &8F, &96, &19, &04, &03	\ moray
 EQUB &06, &01,  38, &0C,  80, &68
 EQUB &EF	\, &11, &07, &00

 EQUB &0E, &8E, &94, &19, &04, &04	\ cobra 1
 EQUB &05, &01,  39, &0F,  60, &1A
 EQUB &CF	\, &31, &08, &00

 EQUB &0E, &8E, &94, &19, &04, &04	\ iguana
 EQUB &07, &01,  50, &16,  75, &00
 EQUB &DF	\, &21, &08, &00

 EQUB &0D, &8D, &90, &0C, &01, &03	\ ophidian
 EQUB &04, &01,  51, &19,  70, &68
 EQUB &FF	\, &01, &06, &00

 EQUB &10, &8F, &97, &32, &02, &04	\ chameleon
 EQUB &08, &01,  43, &24,  80, &68
 EQUB &DF	\, &21, &05, &00

 EQUB &12, &8F, &98, &32, &04, &05	\ cobra 3
 EQUB &07, &01,  42, &2B,  70, &00
 EQUB &EF	\, &11, &0A, &00

IF _SOURCE_DISC

 EQUB &11, &90, &99, &32, &04, &04	\ ghavial
 EQUB &09, &01,  37, &38,  80, &00
 EQUB &CF	\, &31, &09, &00

 EQUB &12, &92, &9C, &32, &04, &04	\ fer-de-lance
 EQUB &08, &02,  45, &0A,  85, &34
 EQUB &DF	\, &21, &09, &00

ELIF _RELEASED

 EQUB &12, &92, &9C, &32, &04, &04	\ fer-de-lance
 EQUB &08, &02,  45, &0A,  85, &34
 EQUB &DF	\, &21, &09, &00

 EQUB &11, &90, &99, &32, &04, &04	\ ghavial
 EQUB &09, &01,  37, &38,  80, &00
 EQUB &CF	\, &31, &09, &00

ENDIF

 EQUB &18, &93, &9C, &32, &04, &09	\ monitor
 EQUB &0A, &01,  24, &52, 110, &4E
 EQUB &BF	\, &41, &0C, &00

 EQUB &18, &92, &9B, &32, &04, &05	\ python
 EQUB &0B, &01,  30, &6B,  80, &1A
 EQUB &AF	\, &51, &09, &00

 EQUB &14, &8E, &98, &32, &02, &07	\ boa
 EQUB &0A, &01,  36, &85,  90, &00
 EQUB &BF	\, &41, &0A, &00

IF _SOURCE_DISC

 EQUB &1C, &90, &7F, &32, &04, &11	\ anaconda
 EQUB &0D, &01,  21, &FE, 100, &4E
 EQUB &AF	\, &51, &0C, &00

 EQUB &10, &91, &9F, &0C, &01, &02	\ asp 2
 EQUB &0A, &01,  60, &07, 125, &34
 EQUB &DF	\, &21, &07, &00

ELIF _RELEASED

 EQUB &10, &91, &9F, &0C, &01, &02	\ asp 2
 EQUB &0A, &01,  60, &07, 125, &34
 EQUB &DF	\, &21, &07, &00

 EQUB &1C, &90, &7F, &32, &04, &11	\ anaconda
 EQUB &0D, &01,  21, &FE, 100, &4E
 EQUB &AF	\, &51, &0C, &00

ENDIF

\ a.qcode_3

.TKN1

 EQUB &00
 EQUS &09, &0B, &01, &08, " ", &F1, "SK AC", &E9, "SS ME", &E1, &D7, &0A, &02, "1. ", &95, &D7, "2. SA", &FA
 EQUS " ", &9A, " ", &04, &D7, "3. C", &F5, "A", &E0, "GUE", &D7, "4. DEL", &DD, "E", &D0, "FI", &E5, &D7, "5. E"
 EQUS "X", &DB, &D7
 EQUB &00
 EQUS &0C, "WHICH ", &97, "?"
 EQUB &00
 \	EQUA "ARE YOU SURE?"
 EQUS &EE, "E ", &B3, " SU", &F2, "?"
 EQUB &00
 EQUS &96, &97, " ", &10, &98, &D7
 EQUB &00
 EQUS &B0, "m", &CA, "n", &B1
 EQUB &00
 EQUS "  ", &95, " ", &01, "(Y/N)?", &02, &0C, &0C
 EQUB &00
 EQUS "P", &F2, "SS SPA", &E9, " ", &FD, " FI", &F2, ",", &9A, ".", &0C, &0C
 EQUB &00
 EQUS &9A, "'S", &C8
 EQUB &00
 EQUS &15, "FI", &E5, &C9, "DEL", &DD, "E?"
 EQUB &00
 EQUS &17, &0E, &02, "G", &F2, &DD, &F0, "GS", &D5, &B2, &13, "I ", &F7, "G", &D0, "MOM", &F6, "T OF ", &B3, "R V", &E4
 EQUS "U", &D8, &E5, " ", &FB, "ME", &CC, "WE W", &D9, "LD LIKE ", &B3, &C9, "DO", &D0, "L", &DB, "T", &E5, " JO"
 EQUS "B F", &FD, " ", &EC, &CC, &93, &CF, " ", &B3, " ", &DA, "E HE", &F2, &CA, "A", &D2, "MODEL, ", &93
 EQUS &13, "C", &DF, &DE, "RICT", &FD, ", E", &FE, "IP", &C4, "WI", &E2, &D0, "TOP ", &DA, "CR", &DD, &D2, "SHI"
 EQUS "ELD G", &F6, &F4, &F5, &FD, &CC, "UNF", &FD, "TUN", &F5, "ELY ", &DB, "'S ", &F7, &F6, " ", &DE, "O"
 EQUS "L", &F6, &CC, &16, &DB, " W", &F6, "T MISS", &C3, "FROM ", &D9, "R ", &CF, " Y", &EE, "D ", &DF, " ", &13, &E6
 EQUS &F4, " FI", &FA, " M", &DF, &E2, "S AGO", &B2, &1C, &CC, &B3, "R MISSI", &DF, ", SH", &D9, "LD "
 EQUS &B3, " DECIDE", &C9, "AC", &E9, "PT ", &DB, ", IS", &C9, &DA, "EK", &B2, "D", &ED, "TROY ", &94, &CF
 EQUS &CC, &B3, " A", &F2, " CAU", &FB, &DF, &C4, &E2, &F5, " ", &DF, "LY ", &06, "u", &05, "S W", &DC, "L P", &F6
 EQUS &DD, &F8, "TE ", &93, "NEW SHIELDS", &B2, &E2, &F5, " ", &93, &13, "C", &DF, &DE, "RICT", &FD
 EQUS &CA, "F", &DB, "T", &C4, "WI", &E2, " ", &FF, " ", &06, "l", &05, &B1, &02, &08, "GOOD LUCK, ", &9A, &D4, &16
 EQUB &00
 EQUS &19, &09, &17, &0E, &02, "  ", &F5, "T", &F6, &FB, &DF, &D5, ". ", &13, "WE HA", &FA, " NE", &C4, "OF ", &B3, "R"
 EQUS " ", &DA, "RVIC", &ED, " AGA", &F0, &CC, "IF ", &B3, " W", &D9, "LD ", &F7, " ", &EB, " GOOD AS", &C9
 EQUS "GO", &C9, &13, &E9, &F4, &F1, " ", &B3, " W", &DC, "L ", &F7, " BRIEF", &FC, &CC, "IF SUC", &E9, "S"
 EQUS "SFUL, ", &B3, " W", &DC, "L ", &F7, " WELL ", &F2, "W", &EE, "D", &FC, &D4, &18
 EQUB &00
 EQUS "(", &13, "C) AC", &FD, "N", &EB, "FT 1984"
 EQUB &00
 EQUS "BY D.B", &F8, &F7, "N & I.", &F7, "LL"
 EQUB &00
 EQUS &15, &91, &C8, &1A
 EQUB &00
 EQUS &19, &09, &17, &0E, &02, "  C", &DF, "G", &F8, "TU", &F9, &FB, &DF, "S ", &9A, "!", &0C, &0C, &E2, &F4, "E", &0D, " W"
 EQUS &DC, "L ", &E4, "WAYS ", &F7, &D0, "P", &F9, &E9, " F", &FD, " ", &B3, " ", &F0, &D3, &CC, &FF, "D ", &EF
 EQUS "Y", &F7, " ", &EB, &DF, &F4, " ", &E2, &FF, " ", &B3, " ", &E2, &F0, "K..", &D4, &18
 EQUB &00
 EQUS "F", &D8, &E5, "D"
 EQUB &00
 EQUS &E3, "T", &D8, &E5
 EQUB &00
 EQUS "WELL K", &E3, "WN"
 EQUB &00
 EQUS "FAMO", &EC
 EQUB &00
 EQUS &E3, "T", &FC
 EQUB &00
 EQUS &FA, "RY"
 EQUB &00
 EQUS "M", &DC, "DLY"
 EQUB &00
 EQUS "MO", &DE
 EQUB &00
 EQUS &F2, "AS", &DF, &D8, "LY"
 EQUB &00
 EQUB &00
 EQUS &A5
 EQUB &00
 EQUS "r"
 EQUB &00
 EQUS "G", &F2, &F5
 EQUB &00
 EQUS "VA", &DE
 EQUB &00
 EQUS "P", &F0, "K"
 EQUB &00
 EQUS &02, "w v", &0D, " ", &B9, "A", &FB, &DF, "S"
 EQUB &00
 EQUS &9C, "S"
 EQUB &00
 EQUS "u"
 EQUB &00
 EQUS &80, " F", &FD, &ED, "TS"
 EQUB &00
 EQUS "O", &E9, &FF, "S"
 EQUB &00
 EQUS "SHYN", &ED, "S"
 EQUB &00
 EQUS "S", &DC, "L", &F0, &ED, "S"
 EQUB &00
 EQUS &EF, "T", &C3, "T", &F8, &F1, &FB, &DF, "S"
 EQUB &00
 EQUS &E0, &F5, "H", &C3, "OF d"
 EQUB &00
 EQUS &E0, &FA, " F", &FD, " d"
 EQUB &00
 EQUS "FOOD B", &E5, "ND", &F4, "S"
 EQUB &00
 EQUS "T", &D9, "RI", &DE, "S"
 EQUB &00
 EQUS "PO", &DD, "RY"
 EQUB &00
 EQUS &F1, "SCOS"
 EQUB &00
 EQUS "l"
 EQUB &00
 EQUS "W", &E4, "K", &C3, &9E
 EQUB &00
 EQUS "C", &F8, "B"
 EQUB &00
 EQUS "B", &F5
 EQUB &00
 EQUS &E0, "B", &DE
 EQUB &00
 EQUS &12
 EQUB &00
 EQUS &F7, "S", &DD
 EQUB &00
 EQUS "P", &F9, "GU", &FC
 EQUB &00
 EQUS &F8, "VAG", &FC
 EQUB &00
 EQUS "CURS", &FC
 EQUB &00
 EQUS "SC", &D9, "RG", &FC
 EQUB &00
 EQUS "q CIV", &DC, " W", &EE
 EQUB &00
 EQUS "h _ `S"
 EQUB &00
 EQUS "A h ", &F1, &DA, "A", &DA
 EQUB &00
 EQUS "q E", &EE, &E2, &FE, "AK", &ED
 EQUB &00
 EQUS "q ", &EB, &F9, "R AC", &FB, "V", &DB, "Y"
 EQUB &00
 EQUS &AF, "] ^"
 EQUB &00
 EQUS &93, &11, " _ `"
 EQUB &00
 EQUS &AF, &C1, "S' b c"
 EQUB &00
 EQUS &02, "z", &0D
 EQUB &00
 EQUS &AF, "k l"
 EQUB &00
 EQUS "JUI", &E9
 EQUB &00
 EQUS "B", &F8, "NDY"
 EQUB &00
 EQUS "W", &F5, &F4
 EQUB &00
 EQUS "B", &F2, "W"
 EQUB &00
 EQUS "G", &EE, "G", &E5, " B", &F9, &DE, &F4, "S"
 EQUB &00
 EQUS &12
 EQUB &00
 EQUS &11, " `"
 EQUB &00
 EQUS &11, " ", &12
 EQUB &00
 EQUS &11, " h"
 EQUB &00
 EQUS "h ", &12
 EQUB &00
 EQUS "F", &D8, "U", &E0, &EC
 EQUB &00
 EQUS "EXO", &FB, "C"
 EQUB &00
 EQUS "HOOPY"
 EQUB &00
 EQUS "U", &E1, "SU", &E4
 EQUB &00
 EQUS "EXC", &DB, &F0, "G"
 EQUB &00
 EQUS "CUIS", &F0, "E"
 EQUB &00
 EQUS "NIGHT LIFE"
 EQUB &00
 EQUS "CASI", &E3, "S"
 EQUB &00
 EQUS "S", &DB, " COMS"
 EQUB &00
 EQUS &02, "z", &0D
 EQUB &00
 EQUS &03
 EQUB &00
 EQUS &93, &91, " ", &03
 EQUB &00
 EQUS &93, &92, " ", &03
 EQUB &00
 EQUS &94, &91
 EQUB &00
 EQUS &94, &92
 EQUB &00
 EQUS "S", &DF, " OF", &D0, "B", &DB, "CH"
 EQUB &00
 EQUS "SC", &D9, "ND", &F2, "L"
 EQUB &00
 EQUS "B", &F9, "CKGU", &EE, "D"
 EQUB &00
 EQUS "ROGUE"
 EQUB &00
 EQUS "WH", &FD, &ED, &DF, " ", &F7, &DD, &E5, " HEAD", &C6, "F", &F9, "P E", &EE, "'D KNA", &FA
 EQUB &00
 EQUS "N UN", &F2, &EF, "RK", &D8, &E5
 EQUB &00
 EQUS " B", &FD, &F0, "G"
 EQUB &00
 EQUS " DULL"
 EQUB &00
 EQUS " TE", &F1, "O", &EC
 EQUB &00
 EQUS " ", &F2, "VOLT", &F0, "G"
 EQUB &00
 EQUS &91
 EQUB &00
 EQUS &92
 EQUB &00
 EQUS "P", &F9, &E9
 EQUB &00
 EQUS "L", &DB, "T", &E5, " ", &91
 EQUB &00
 EQUS "DUMP"
 EQUB &00
 EQUS "I HE", &EE, &D0, "r ", &E0, "OK", &C3, &CF, " APPE", &EE, &C4, &F5, &D1
 EQUB &00
 EQUS "YEAH, I HE", &EE, &D0, "r ", &CF, " ", &E5, "FT", &D1, &D0, " WHI", &E5, " BACK"
 EQUB &00
 EQUS "G", &DD, " ", &B3, "R IR", &DF, " ASS OV", &F4, " TO", &D1
 EQUB &00
 EQUS &EB, "ME s", &D2, &CF, " WAS ", &DA, &F6, " ", &F5, &D1
 EQUB &00
 EQUS "TRY", &D1
 EQUB &00
 EQUS &01, "SPECI", &E4, " C", &EE, "GO"
 EQUB &00
 EQUB &00
 EQUS "C", &EE, "GO V", &E4, "UE:"
 EQUB &00
 EQUS " MO", &F1, "FI", &FC, " BY A.J.C.DUGG", &FF
 EQUB &00
 EQUS "WASP"
 EQUB &00
 EQUS "MO", &E2
 EQUB &00
 EQUS "GRUB"
 EQUB &00
 EQUS &FF, "T"
 EQUB &00
 EQUS &12
 EQUB &00
 EQUS "PO", &DD
 EQUB &00
 EQUS &EE, "TS G", &F8, "DU", &F5, "E"
 EQUB &00
 EQUS "YAK"
 EQUB &00
 EQUS "SNA", &DC
 EQUB &00
 EQUS "SLUG"
 EQUB &00
 EQUS "TROPIC", &E4
 EQUB &00
 EQUS "D", &F6, &DA
 EQUB &00
 EQUS &F8, &F0
 EQUB &00
 EQUS "IMP", &F6, &DD, &F8, "B", &E5
 EQUB &00
 EQUS "EXU", &F7, &F8, "NT"
 EQUB &00
 EQUS "FUNNY"
 EQUB &00
 EQUS "WI", &F4, "D"
 EQUB &00
 EQUS "U", &E1, "SU", &E4
 EQUB &00
 EQUS &DE, &F8, "N", &E7
 EQUB &00
 EQUS "PECULI", &EE
 EQUB &00
 EQUS "F", &F2, &FE, &F6, "T"
 EQUB &00
 EQUS "OCCASI", &DF, &E4
 EQUB &00
 EQUS "UNP", &F2, &F1, "CT", &D8, &E5
 EQUB &00
 EQUS "D", &F2, "ADFUL"
 EQUB &00
 EQUS &AB
 EQUB &00
 EQUS "\ [ F", &FD, " e"
 EQUB &00
 EQUS &8C, &B2, "e"
 EQUB &00
 EQUS "f BY g"
 EQUB &00
 EQUS &8C, " BUT ", &8E
 EQUB &00
 EQUS " Ao p"
 EQUB &00
 EQUS "PL", &FF, &DD
 EQUB &00
 EQUS "W", &FD, "LD"
 EQUB &00
 EQUS &E2, "E "
 EQUB &00
 EQUS &E2, "IS "
 EQUB &00
 EQUS &E0, "AD", &D2, &9A
 EQUB &00
 EQUS &09, &0B, &01, &08
 EQUB &00
 EQUS "DRI", &FA
 EQUB &00
 EQUS " C", &F5, "A", &E0, "GUE"
 EQUB &00
 EQUS "I", &FF
 EQUB &00
 EQUS &13, "COMM", &FF, "D", &F4
 EQUB &00
 EQUS "h"
 EQUB &00
 EQUS "M", &D9, "NTA", &F0
 EQUB &00
 EQUS &FC, "IB", &E5
 EQUB &00
 EQUS "T", &F2, "E"
 EQUB &00
 EQUS "SPOTT", &FC
 EQUB &00
 EQUS "x"
 EQUB &00
 EQUS "y"
 EQUB &00
 EQUS "aOID"
 EQUB &00
 EQUS &7F
 EQUB &00
 EQUS "~"
 EQUB &00
 EQUS &FF, "CI", &F6, "T"
 EQUB &00
 EQUS "EX", &E9, "P", &FB, &DF, &E4
 EQUB &00
 EQUS "EC", &E9, "NTRIC"
 EQUB &00
 EQUS &F0, "G", &F8, &F0, &FC
 EQUB &00
 EQUS "r"
 EQUB &00
 EQUS "K", &DC, "L", &F4
 EQUB &00
 EQUS "DEADLY"
 EQUB &00
 EQUS "EV", &DC
 EQUB &00
 EQUS &E5, &E2, &E4
 EQUB &00
 EQUS "VICIO", &EC
 EQUB &00
 EQUS &DB, "S "
 EQUB &00
 EQUS &0D, &0E, &13
 EQUB &00
 EQUS ".", &0C, &0F
 EQUB &00
 EQUS " ", &FF, "D "
 EQUB &00
 EQUS "Y", &D9
 EQUB &00
 EQUS "P", &EE, "K", &C3, "M", &DD, &F4, "S"
 EQUB &00
 EQUS "D", &EC, "T C", &E0, "UDS"
 EQUB &00
 EQUS "I", &E9, " ", &F7, "RGS"
 EQUB &00
 EQUS "ROCK F", &FD, &EF, &FB, &DF, "S"
 EQUB &00
 EQUS "VOLCA", &E3, &ED
 EQUB &00
 EQUS "PL", &FF, "T"
 EQUB &00
 EQUS "TULIP"
 EQUB &00
 EQUS "B", &FF, &FF, "A"
 EQUB &00
 EQUS "C", &FD, "N"
 EQUB &00
 EQUS &12, "WE", &FC
 EQUB &00
 EQUS &12
 EQUB &00
 EQUS &11, " ", &12
 EQUB &00
 EQUS &11, " h"
 EQUB &00
 EQUS &F0, "HA", &EA, "T", &FF, "T"
 EQUB &00
 EQUS &BF
 EQUB &00
 EQUS &F0, "G "
 EQUB &00
 EQUS &FC, " "
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUS " NAME? "
 EQUB &00
 EQUS " TO "
 EQUB &00
 EQUS " IS "
 EQUB &00
 EQUS "WAS ", &F9, &DE, " ", &DA, &F6, " ", &F5, " ", &13
 EQUB &00
 EQUS ".", &0C, " ", &13
 EQUB &00
 EQUS "DOCK", &FC
 EQUB &00
 EQUS &01, "(Y/N)?"
 EQUB &00
 EQUS "SHIP"
 EQUB &00
 EQUS " A "
 EQUB &00
 EQUS " ", &F4, "RI", &EC
 EQUB &00
 EQUS " NEW "
 EQUB &00
 EQUS &02, " H", &F4, " ", &EF, "J", &ED, "TY'S SPA", &E9, " NAVY", &0D
 EQUB &00
 EQUS &B1, &08, &01, "  M", &ED, "SA", &E7, " ", &F6, "DS"
 EQUB &00
 EQUS " ", &9A, " ", &04, ", I ", &0D, "AM", &02, " CAPTA", &F0, " ", &1B, " ", &0D, "OF", &D3
 EQUB &00
 EQUB &00
 EQUS &0F, " UNK", &E3, "WN ", &91
 EQUB &00
 EQUS &09, &08, &17, &01, &F0, "COM", &C3, "M", &ED, "SA", &E7
 EQUB &00
 EQUS "CURRU", &E2, &F4, "S"
 EQUB &00
 EQUS "FOSDYKE SMY", &E2, "E"
 EQUB &00
 EQUS "F", &FD, "T", &ED, &FE, "E"
 EQUB &00
 EQUS &CB, &F2, &ED, &F1, &E9
 EQUB &00
 EQUS "IS ", &F7, "LIEV", &FC, &C9, "HA", &FA, " JUMP", &FC, &C9, &94, "G", &E4, "AXY"
 EQUB &00
 EQUS &19, &09, &1D, &0E, &02, "GOOD DAY ", &9A, " ", &04, &CC, "I", &0D, " AM ", &13, "AG", &F6, "T ", &13, "B", &F9, "KE"
 EQUS " OF ", &13, "NAV", &E4, " ", &13, &F0, "TEL", &E5, "G", &F6, &E9, &CC, "AS ", &B3, " K", &E3, "W, ", &93, &13
 EQUS "NAVY HA", &FA, " ", &F7, &F6, " KEEP", &C3, &93, &13, &E2, &EE, "GOIDS OFF ", &B3, "R A"
 EQUS "SS ", &D9, "T ", &F0, " DEEP SPA", &E9, " F", &FD, " ", &EF, "NY YE", &EE, "S ", &E3, "W. ", &13, "WEL"
 EQUS "L ", &93, "S", &DB, "UA", &FB, &DF, " HAS CH", &FF, "G", &FC, &CC, &D9, "R BOYS ", &EE, "E ", &F2
 EQUS "ADY F", &FD, &D0, "P", &EC, "H RIGHT", &C9, &93, "HOME SY", &DE, "EM OF ", &E2, "O", &DA, " MO"
 EQUS &E2, &F4, "S", &CC, &18, &09, &1D, "I", &0D, " HA", &FA, " OBTA", &F0, &C4, &93, "DEF", &F6, &E9, " P", &F9
 EQUS "NS F", &FD, " ", &E2, "EIR ", &13, "HI", &FA, " ", &13, "W", &FD, "LDS", &CC, &93, &F7, &DD, &E5, "S K", &E3
 EQUS "W WE'", &FA, " GOT ", &EB, "ME", &E2, &C3, "BUT ", &E3, "T WH", &F5, &CC, "IF ", &13, "I T", &F8, "N"
 EQUS "SM", &DB, " ", &93, "P", &F9, "NS", &C9, &D9, "R BA", &DA, " ", &DF, " ", &13, &EA, &F2, &F8, " ", &E2, "EY'L"
 EQUS "L ", &F0, "T", &F4, &E9, "PT ", &93, "TR", &FF, "SMISSI", &DF, ". ", &13, "I NE", &FC, &D0, &CF, &C9
 EQUS &EF, "KE ", &93, "RUN", &CC, &B3, "'", &F2, " E", &E5, "CT", &FC, &CC, &93, "P", &F9, "NS A", &F2, " "
 EQUS "UNIPUL", &DA, " COD", &C4, "WI", &E2, &F0, " ", &94, "TR", &FF, "SMISSI", &DF, &CC, &08, &B3, " "
 EQUS "W", &DC, "L ", &F7, " PAID", &CC, "    ", &13, "GOOD LUCK ", &9A, &D4, &18
 EQUB &00
 EQUS &19, &09, &1D, &08, &0E, &0D, &13, "WELL D", &DF, "E ", &9A, &CC, &B3, " HA", &FA, " ", &DA, "RV", &C4, &EC, " "
 EQUS "WELL", &B2, "WE SH", &E4, "L ", &F2, "MEMB", &F4, &CC, "WE ", &F1, "D ", &E3, "T EXPECT ", &93
 EQUS &13, &E2, &EE, "GOIDS", &C9, "F", &F0, "D ", &D9, "T ", &D8, &D9, "T ", &B3, &CC, "F", &FD, " ", &93, "MOM", &F6
 EQUS "T P", &E5, "A", &DA, " AC", &E9, "PT ", &94, &13, "NAVY ", &06, "r", &05, " AS PAYM", &F6, "T", &D4, &18
 EQUB &00
 EQUB &00
 EQUS "SH", &F2, "W"
 EQUB &00
 EQUS &F7, "A", &DE
 EQUB &00
 EQUS &EA, "S", &DF
 EQUB &00
 EQUS "SNAKE"
 EQUB &00
 EQUS "WOLF"
 EQUB &00
 EQUS &E5, "OP", &EE, "D"
 EQUB &00
 EQUS "C", &F5
 EQUB &00
 EQUS "M", &DF, "KEY"
 EQUB &00
 EQUS "GO", &F5
 EQUB &00
 EQUS "FISH"
 EQUB &00
 EQUS "j i"
 EQUB &00
 EQUS &11, " x {"
 EQUB &00
 EQUS &AF, "k y {"
 EQUB &00
 EQUS &7C, " }"
 EQUB &00
 EQUS "j i"
 EQUB &00
 EQUS "ME", &F5
 EQUB &00
 EQUS "CUTL", &DD
 EQUB &00
 EQUS &DE, "EAK"
 EQUB &00
 EQUS "BURG", &F4, "S"
 EQUB &00
 EQUS &EB, "UP"
 EQUB &00
 EQUS "I", &E9
 EQUB &00
 EQUS "MUD"
 EQUB &00
 EQUS "Z", &F4, "O-", &13, "G"
 EQUB &00
 EQUS "VACUUM"
 EQUB &00
 EQUS &11, " ULT", &F8
 EQUB &00
 EQUS "HOCKEY"
 EQUB &00
 EQUS "CRICK", &DD
 EQUB &00
 EQUS "K", &EE, &F5, "E"
 EQUB &00
 EQUS "PO", &E0
 EQUB &00
 EQUS "T", &F6, "NIS"
 EQUB &00

.l_5338

 EQUB &00

.RUPLA

 EQUB &D3, &96, &24, &1C, &FD, &4F, &35, &76, &64, &20, &44, &A4
 EQUB &DC, &6A, &10, &A2, &03, &6B, &1A, &C0, &B8, &05, &65, &C1
 EQUB &29

.RUGAL

 EQUB &80, &00, &00, &00, &01, &01, &01, &01, &82, &01, &01
 EQUB &01, &01, &01, &01, &01, &01, &01, &01, &01, &01, &01, &02
 EQUB &01, &82

.RUTOK

 EQUB &00
 EQUS &93, "CO", &E0, "NI", &DE, "S HE", &F2, " HA", &FA, " VIOL", &F5, &FC, &02, " ", &F0, "T", &F4, "G", &E4
 EQUS "AC", &FB, "C C", &E0, "N", &C3, "PROTOCOL", &0D, &B2, "SH", &D9, "LD ", &F7, " AVOID", &FC
 EQUB &00
 EQUS &93, "C", &DF, &DE, "RICT", &FD, " ", &CB, &F2, &ED, &F1, &E9, ", ", &9A
 EQUB &00
 EQUS "A r ", &E0, "OK", &C3, &CF, " ", &E5, "FT HE", &F2, &D0, "WHI", &E5, " BACK. ", &E0, "OK", &C4, "B", &D9
 EQUS "ND F", &FD, " ", &EE, "E", &E6
 EQUB &00
 EQUS "YEP,", &D0, "r", &D2, &CF, " HAD", &D0, "G", &E4, "AC", &FB, "C HYP", &F4, "DRI", &FA, " F", &DB, "T", &C4
 EQUS "HE", &F2, ". ", &EC, &C4, &DB, " TOO"
 EQUB &00
 EQUS &94, " r ", &CF, " DEHYP", &C4, "HE", &F2, " FROM ", &E3, "WHE", &F2, ", SUN SKIMM", &FC
 EQUS &B2, "JUMP", &FC, ". I HE", &EE, " ", &DB, " W", &F6, "T", &C9, &F0, &EA, &F7
 EQUB &00
 EQUS "s ", &CF, " W", &F6, "T F", &FD, " ME ", &F5, " A", &EC, &EE, ". MY ", &F9, "S", &F4, "S ", &F1, "DN'T E"
 EQUS "V", &F6, " SC", &F8, "TCH ", &93, "s"
 EQUB &00
 EQUS "OH DE", &EE, " ME Y", &ED, ".", &D0, "FRIGHTFUL ROGUE WI", &E2, " WH", &F5, " I ", &F7
 EQUS "LIE", &FA, " ", &B3, " PEOP", &E5, " C", &E4, "L", &D0, &E5, "AD PO", &DE, &F4, "I", &FD, " SHOT UP"
 EQUS " ", &E0, "TS OF ", &E2, "O", &DA, " ", &F7, "A", &DE, "LY PI", &F8, "T", &ED, &B2, "W", &F6, "T", &C9, &EC, &E5
 EQUS "RI"
 EQUB &00
 EQUS &B3, " C", &FF, " TACK", &E5, " ", &93, "h s IF ", &B3, " LIKE. HE'S ", &F5, " ", &FD, &EE
 EQUS &F8
 EQUB &00
 EQUS &01, "COM", &C3, &EB, &DF, ": EL", &DB, "E III"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "t"
 EQUB &00
 EQUS "BOY A", &F2, " ", &B3, " ", &F0, " ", &93, "WR", &DF, "G G", &E4, "AXY!"
 EQUB &00
 EQUS &E2, &F4, "E'S", &D0, &F2, &E4, " s PI", &F8, "TE ", &D9, "T ", &E2, &F4, "E"
 EQUB &00
 EQUS &93, &C1, "S OF m A", &F2, " ", &EB, " A", &EF, "Z", &F0, "GLY PRIMI", &FB, &FA, " ", &E2, &F5
 EQUS " ", &E2, "EY ", &DE, &DC, "L ", &E2, &F0, "K ", &13, "EL", &DB, "E", &CA, "A P", &F2, "TTY NE", &F5, " GAME"
 EQUB &00

.MTIN

 EQUB &10, &15, &1A, &1F, &9B, &A0, &2E, &A5, &24, &29, &3D, &33
 EQUB &38, &AA, &42, &47, &4C, &51, &56, &8C, &60, &65, &87, &82
 EQUB &5B, &6A, &B4, &B9, &BE, &E1, &E6, &EB, &F0, &F5, &FA, &73
 EQUB &78, &7D


.msg_3

 EQUB &00
 EQUS &F6, "CYC", &E0, "P", &FC, "IA G", &E4, "AC", &FB, "CA"
 EQUB &00
 EQUS &CF, "S ", &01, "A-G", &02
 EQUB &00
 EQUS &CF, "S ", &01, "I-W", &02
 EQUB &00
 EQUS "E", &FE, "IPM", &F6, "T"
 EQUB &00
 EQUS "C", &DF, "TROLS"
 EQUB &00
 EQUS &F0, "F", &FD, &EF, &FB, &DF
 EQUB &00
 EQUS "ADD", &F4
 EQUB &00
 EQUS &FF, "AC", &DF, "DA"
 EQUB &00
 EQUS "ASP MK2"
 EQUB &00
 EQUS "BOA"
 EQUB &00
 EQUS "BUSHMASTER"
 EQUB &00
 EQUS "CHAMELEON"
 EQUB &00
 EQUS "COB", &F8, " MK1"
 EQUB &00
 EQUS "COB", &F8, " MK3"
 EQUB &00
 EQUS "C", &FD, "IOLIS ", &DE, &F5, "I", &DF
 EQUB &00
 EQUS "DODECAG", &DF, " ", &DE, &F5, "I", &DF
 EQUB &00
 EQUS &ED, "CAPE CAPSU", &E5
 EQUB &00
 EQUS "F", &F4, "-DE-", &13, &F9, "N", &E9
 EQUB &00
 EQUS &E7, "CKO"
 EQUB &00
 EQUS "GHAVI", &E4
 EQUB &00
 EQUS "IGUANA"
 EQUB &00
 EQUS "K", &F8, &DB
 EQUB &00
 EQUS &EF, "MBA"
 EQUB &00
 EQUS "M", &DF, &DB, &FD
 EQUB &00
 EQUS "MO", &F8, "Y"
 EQUB &00
 EQUS "OPHI", &F1, &FF
 EQUB &00
 EQUS "PY", &E2, &DF
 EQUB &00
 EQUS "SHUTT", &E5
 EQUB &00
 EQUS "SIDEW", &F0, "D", &F4
 EQUB &00
 EQUS &E2, &EE, "GOID"
 EQUB &00
 EQUS &E2, &EE, "G", &DF
 EQUB &00
 EQUS "T", &F8, "NSP", &FD, "T", &F4
 EQUB &00
 EQUS "VIP", &F4
 EQUB &00
 EQUS "W", &FD, "M"
 EQUB &00
 EQUS &EE, &EF, "M", &F6, "TS:"
 EQUB &00
 EQUS "SPE", &FC, ":"
 EQUB &00
 EQUS &F0, &DA, "RVI", &E9, " D", &F5, "E:"
 EQUB &00
 EQUS "COMB", &F5
 EQUB &00
 EQUS "C", &F2, "W:"
 EQUB &00
 EQUS &97, " MOT", &FD, "S:"
 EQUB &00
 EQUS &F8, "N", &E7, ":"
 EQUB &00
 EQUS "FT"
 EQUB &00
 EQUS &F1, "M", &F6, "SI", &DF, "S:"
 EQUB &00
 EQUS "HULL:"	\EQUA "", &F0, "T", &F4, "N", &E4
 EQUB &00
 EQUS "SPA", &E9, ":"
 EQUB &00
 EQUS " MISS", &DC, &ED
 EQUB &00
 EQUS "FACT", &FD, ":"
 EQUB &00
 EQUS &E7, "R", &DD, " ", &DE, &EE, &DA, "EK", &F4
 EQUB &00
 EQUS " ", &F9, &DA, "R"
 EQUB &00
 EQUS " PUL", &DA
 EQUB &00
 EQUS " SY", &DE, "EM"
 EQUB &00
 EQUS &F4, "G", &DF
 EQUB &00
 EQUS &97
 EQUB &00
 EQUS &DA, "EK"
 EQUB &00
 EQUS "LIGHT"
 EQUB &00
 EQUS &F0, "G", &F8, "M"
 EQUB &00
 EQUS &F9, "N", &E9, " & F", &F4, &EF, "N"
 EQUB &00
 EQUS &13, "KRU", &E7, "R "
 EQUB &00
 EQUS "HASS", &DF, "I"
 EQUB &00
 EQUS "VOLTAI", &F2
 EQUB &00
 EQUS "C", &EE, "GO"
 EQUB &00
 EQUS &01, "TC", &02
 EQUB &00
 EQUS &01, "LY", &02
 EQUB &00
 EQUS &01, "LM", &02
 EQUB &00
 EQUS "CF"
 EQUB &00
 EQUS &E2, "RU", &DE
 EQUB &00
 EQUS " ", &CF
 EQUB &00
 EQUS &F0, "V", &F6, &FB, &DF
 EQUB &00
 EQUS &D9, "TW", &FD, "LD"
 EQUB &00
 EQUS "Z", &FD, "G", &DF, " P", &DD, "T", &F4, "S", &DF, ")"
 EQUB &00
 EQUS "DE", &13, &F9, "CY"
 EQUB &00
 EQUS &01, "4*C40KV", &02, " AM", &ED, " ", &97
 EQUB &00
 EQUS "V & K "
 EQUB &00
 EQUS "B", &F9, &DE
 EQUB &00
 EQUS " (", &13, "GA", &DA, "C L", &D8, "S, ", &FA, &FB, &FB, &E9, ")"
 EQUB &00
 EQUS "F", &FC, "E", &F8, &FB, &DF
 EQUB &00
 EQUS "SPA", &E9
 EQUB &00
 EQUS &13, "I", &DF, "IC"
 EQUB &00
 EQUS "HUNT"
 EQUB &00
 EQUS "PROS", &DA, "T "
 EQUB &00
 EQUS " W", &FD, "KSHOPS)"
 EQUB &00
 EQUS &01, "/1L", &02
 EQUB &00
 EQUS &01, "/2L", &02
 EQUB &00
 EQUS &01, "/4L", &02
 EQUB &00
 EQUS " (", &13
 EQUB &00
 EQUS &01, "IFS", &02, " "
 EQUB &00
 EQUS &0C, "FLIGHT C", &DF, "TROLS", &D7
 EQUS "<", &08, &FF, &FB, "-C", &E0, "CKWI", &DA, " ROLL", &0C
 EQUS ">", &08, "C", &E0, "CKWI", &DA, " ROLL", &0C
 EQUS "S", &08, &F1, &FA, &0C
 EQUS "X", &08, "CLIMB", &0C
 EQUS &01, "SPC", &02, &08, &F0, "C", &F2, "A", &DA, " SPE", &FC, &0C
 EQUS "?", &08, "DEC", &F2, "A", &DA, " SPE", &FC, &0C
 EQUS &01, "T", &D8, &02, &08, "HYP", &F4, "SPA", &E9, " ", &ED, "CAPE", &0C
 EQUS &01, &ED, "C", &02, &08, &ED, "CAPE CAPSU", &E5, &0C
 EQUS "F", &08, "TOGG", &E5, " COMPASS", &0C
 EQUS "V", &08, "DOCK", &C3, "COMPUT", &F4, "S ", &DF, &0C	\EQUA "V", &08, &04, "s", &05, " ", &DF, &0C
 EQUS "P", &08, "DOCK", &C3, "COMPUT", &F4, "S OFF", &0C	\EQUA "P", &08, &04, "s", &05, " OFF", &0C
 EQUS "J", &08, "MICROJUMP", &0C
 EQUS &0D, "F0", &02, &08, "FR", &DF, "T VIEW", &0C
 EQUS &0D, "F1", &02, &08, &F2, &EE, " VIEW", &0C
 EQUS &0D, "F2", &02, &08, &E5, "FT VIEW", &0C
 EQUS &0D, "F3", &02, &08, "RIGHT VIEW", &0C
 EQUB &00
 EQUS &0C, "COMB", &F5, " C", &DF, "TROLS", &D7
 EQUS "A", &08, "FI", &F2, " ", &F9, &DA, "R", &0C
 EQUS "T", &08, "T", &EE, "G", &DD, " MISS", &DC, &ED, &0C
 EQUS "M", &08, "FI", &F2, " MISS", &DC, &ED, &0C
 EQUS "U", &08, "UN", &EE, "M MISS", &DC, &ED, &0C
 EQUS "E", &08, "TRIG", &E7, "R E.C.M.", &0C
 EQUS &0C, "I.F.F. COL", &D9, "R COD", &ED, &D7
 EQUS "WH", &DB, "E      OFFICI", &E4, " ", &CF, &0C
 EQUS "BLUE       ", &E5, "G", &E4, " ", &CF, &0C
 EQUS "BLUE/", &13, "WH", &DB, "E DEBRIS", &0C
 EQUS "BLUE/", &13, &F2, "D   N", &DF, "-R", &ED, "P", &DF, "D", &F6, "T", &0C
 EQUS "WH", &DB, "E/", &13, &F2, "D  MISS", &DC, &ED, &0C
 EQUB &00
 EQUS &0C, "NAVIG", &F5, "I", &DF, " C", &DF, "TROLS", &D7
 EQUS "H", &08, "HYP", &F4, "SPA", &E9, " JUMP", &0C
 EQUS "C-", &13, "H", &08, "G", &E4, "AC", &FB, "C HYP", &F4, "SPA", &E9, " JUMP", &0C
 EQUS "CUR", &EB, "R KEYS", &0C, &08, "HYP", &F4, "SPA", &E9, " CUR", &EB, "R C", &DF, "TROL", &0C
 EQUS "D", &08, &F1, &DE, &FF, &E9, &C9, "SY", &DE, "EM", &0C
 EQUS "O", &08, "HOME CUR", &EB, "R", &0C
 EQUS "F", &08, "F", &F0, "D SY", &DE, "EM (", &13, &CD, ")", &0C
 EQUS "W", &08, "F", &F0, "D DE", &DE, &F0, &F5, "I", &DF, " SY", &DE, "EM", &0C
 EQUS &0D, "F4", &02, &08, "G", &E4, "AC", &FB, "C ", &EF, "P", &0C
 EQUS &0D, "F5", &02, &08, "SH", &FD, "T ", &F8, "N", &E7, " ", &EF, "P", &0C
 EQUS &0D, "F6", &02, &08, "D", &F5, "A ", &DF, " ", &91, &0C
 EQUB &00
 EQUS &0C, "T", &F8, "D", &C3, "C", &DF, "TROLS", &D7
 EQUS &0D, "F0", &02, &08, &F9, "UNCH FROM ", &DE, &F5, "I", &DF, &0C
 EQUS "C-F0", &02, &08, &F2, &EF, &F0, " ", &CD, &0C
 EQUS &0D, "F1", &02, &08, "BUY C", &EE, "GO", &0C
 EQUS "C-F1", &08, "BUY SPECI", &E4, " C", &EE, "GO", &0C
 EQUS &0D, "F2", &02, &08, &DA, "LL C", &EE, "GO", &0C
 EQUS "C-F2", &08, &DA, "LL EQUIPMENT", &0C
 EQUS &0D, "F3", &02, &08, "EQUIP ", &CF, &0C
 EQUS "C-F3", &08, "BUY ", &CF, &0C
 EQUS "C-F6", &08, &F6, "CYC", &E0, "P", &FC, "IA", &0C
 EQUS &0D, "F7", &02, &08, "M", &EE, "K", &DD, " PRI", &E9, "S", &0C
 EQUS &0D, "F8", &02, &08, &DE, &F5, &EC, " PA", &E7, &0C
 EQUS &0D, "F9", &02, &08, &F0, "V", &F6, "T", &FD, "Y", &0C
 EQUB &00
 EQUS "FLIGHT"
 EQUB &00
 EQUS "COMB", &F5
 EQUB &00
 EQUS "NAVIG", &F5, "I", &DF
 EQUB &00
 EQUS "T", &F8, "D", &F0, "G"
 EQUB &00
 EQUS "MISS", &DC, &ED	\EQUA "", &04, "j", &05
 EQUB &00
 EQUS &01, "I.F.F.", &0D, " SY", &DE, "EM"	\EQUA "", &04, "k", &05
 EQUB &00
 EQUS &01, "E.C.M.", &0D, " SY", &DE, "EM"	\EQUA "", &04, "l", &05
 EQUB &00
 EQUS "PUL", &DA, " ", &F9, &DA, "RS"	\EQUA "", &04, "g", &05
 EQUB &00
 EQUS &F7, "AM ", &F9, &DA, "RS"	\EQUA "", &04, "h", &05
 EQUB &00
 EQUS "FUEL SCOOPS"	\EQUA "", &04, "o", &05
 EQUB &00
 EQUS &ED, "CAPE POD"	\EQUA "", &04, "p", &05
 EQUB &00
 EQUS "HYP", &F4, "SPA", &E9, " UN", &DB	\EQUA "", &04, "q", &05
 EQUB &00
 EQUS &F6, &F4, "GY UN", &DB	\EQUA "", &04, "r", &05
 EQUB &00
 EQUS "DOCK", &C3, "COMPUT", &F4, "S"	\EQUA "", &04, "s", &05
 EQUB &00
 EQUS "G", &E4, "AC", &FB, "C HYP", &F4, &97	\EQUA "", &04, "t", &05
 EQUB &00
 EQUS "M", &DC, &DB, &EE, "Y ", &F9, &DA, "RS"	\EQUA "", &04, "u", &05
 EQUB &00
 EQUS "M", &F0, &C3, &F9, &DA, "RS"	\EQUA "", &04, "v", &05
 EQUB &00
 EQUS &0E, &13, &DA, "LF HOM", &C3, "MISS", &DC, &ED, " ", &EF, "Y ", &F7, " "
 EQUS "B", &D9, "GHT ", &F5, " ", &FF, "Y SY", &DE, "EM.", &D7
 EQUS &13, &F7, "FO", &F2, &D0, "MISS", &DC, "E C", &FF, " ", &F7, " FIR", &C4
 EQUS &DB, " MU", &DE, " ", &F7, " ", &E0, "CK", &C4, &DF, "TO "
 EQUS "A T", &EE, "G", &DD, ".", &D7, &13, "WH", &F6, " FI", &F2, "D, ", &DB, " W", &DC, "L"
 EQUS " HOME ", &F0, &C9, &93, "T", &EE, "G", &DD, " "
 EQUS "UN", &E5, "SS ", &93, "T", &EE, "G", &DD, " C", &FF, " ", &D9, "T", &EF, &E3, "EUV"
 EQUS &F2, " ", &93, "MISS", &DC, "E, "
 EQUS "SHOOT ", &DB, ", ", &FD, " U", &DA, " E", &E5, "CTR", &DF, "IC C", &D9, "NT"
 EQUS &F4, " MEASUR", &ED, " ", &DF, " ", &DB, &B1
 EQUB &00
 EQUS &0E, &13, &FF, " ID", &F6, &FB, "FIC", &F5, "I", &DF, " FRI", &F6, "D ", &FD
 EQUS " FOE SY", &DE, "EM C", &FF, " ", &F7, " OBTA", &F0, &C4
 EQUS &F5, " TECH ", &E5, &FA, "L 2 ", &FD, " ", &D8, "O", &FA, ".", &D7, &13, &FF
 EQUS " ", &01, "I.F.F.", &0D, " SY", &DE, "EM W", &DC, "L ", &F1, "SP", &F9, "Y "
 EQUS &F1, "FFE", &F2, "NT TYP", &ED, " OF OBJECT ", &F0, " ", &F1, "FFE"
 EQUS &F2, "NT COL", &D9, "RS ", &DF, " ", &93
 EQUS &F8, "D", &EE, " ", &F1, "SP", &F9, "Y.", &D7, &13, &DA, "E ", &13, "C", &DF, "TROLS (", &13, "COMB", &F5, ")", &B1
 EQUB &00
 EQUS &0E, &13, &FF, " E", &E5, "CTR", &DF, "IC C", &D9, "NT", &F4, " MEASUR", &ED
 EQUS " SY", &DE, "EM ", &EF, "Y ", &F7, " B", &D9, "GHT ", &F5, " "
 EQUS &FF, "Y SY", &DE, "EM OF TECH ", &E5, &FA, "L 3 ", &FD, " HIGH"
 EQUS &F4, ".", &D7, &13, "WH", &F6, " AC", &FB, "V", &F5, &FC, ", ", &93
 EQUS &01, "E.C.M.", &0D, " SY", &DE, "EM W", &DC, "L ", &F1, "SRUPT ", &93, "GUID"
 EQUS &FF, &E9, " SY", &DE, "EMS OF ", &E4, "L "
 EQUS "MISS", &DC, &ED, " ", &F0, " ", &93, "VIC", &F0, &DB, "Y, ", &EF, "K", &C3, &E2, "EM ", &DA, "LF DE", &DE, "RUCT", &B1
 EQUB &00
 EQUS &0E, &13, "PUL", &DA, " ", &F9, &DA, "RS ", &EE, "E F", &FD, " S", &E4, "E ", &F5
 EQUS " TECH ", &E5, &FA, "L 4 ", &FD, " ", &D8, "O", &FA, ".", &D7
 EQUS &13, "PUL", &DA, " ", &F9, &DA, "RS FI", &F2, " ", &F0, "T", &F4, "M", &DB, "T", &F6, "T ", &F9, &DA, "R ", &F7, "AMS", &B1
 EQUB &00
 EQUS &0E, &13, &F7, "AM ", &F9, &DA, "RS ", &EE, "E AVA", &DC, &D8, &E5, " ", &F5
 EQUS " SY", &DE, "EMS OF TECH ", &E5, &FA, "L 5 ", &FD, " "
 EQUS "HIGH", &F4, ".", &D7, &13, &F7, "AM ", &F9, &DA, "RS FI", &F2, " C", &DF, &FB
 EQUS &E1, &D9, "S ", &F9, &DA, "R ", &DE, &F8, "NDS, W", &DB, "H "
 EQUS &EF, "NY ", &DE, &F8, "NDS ", &F0, " P", &EE, &E4, &E5, "L.", &D7, &13, &F7, "AM"
 EQUS " ", &F9, &DA, "RS OV", &F4, "HE", &F5, " MO", &F2, " "
 EQUS &F8, "PIDLY ", &E2, &FF, " PUL", &DA, " ", &F9, &DA, "RS", &B1
 EQUB &00
 EQUS &0E, &13, "FUEL SCOOPS ", &F6, &D8, &E5, &D0, &CF, &C9, "OBTA", &F0, " "
 EQUS "F", &F2, "E HYP", &F4, "SPA", &E9, " FUEL "
 EQUS "BY 'SUN-SKIMM", &F0, "G' - FLY", &C3, "C", &E0, &DA, &C9, &93, "SUN"
 EQUS ".", &D7, &13, "FUEL SCOOPS "
 EQUS "C", &FF, " ", &E4, &EB, " ", &F7, " ", &EC, &C4, "TO PICK UP SPA", &E9, " DEBRIS,"
 EQUS " SUCH AS C", &EE, "GO "
 EQUS "B", &EE, &F2, "LS ", &FD, " A", &DE, &F4, "OID F", &F8, "GM", &F6, "TS.", &D7, &13, "FUEL"
 EQUS " SCOOPS ", &EE, "E AVA", &DC, &D8, &E5, " "
 EQUS "FROM SY", &DE, "EMS OF TECH ", &E5, &FA, "L 6 ", &FD, " ", &D8, "O", &FA, &B1
 EQUB &00
 EQUS &0E, &13, &FF, " ", &ED, "CAPE POD", &CA, &FF, " ", &ED, &DA, "N", &FB, &E4
 EQUS " PIE", &E9, " OF EQUIPM", &F6, "T F", &FD, " "
 EQUS "MO", &DE, " SPA", &E9, &CF, "S.", &D7, &13, "WH", &F6, " EJECT", &FC, ","
 EQUS " ", &93, "CAPSU", &E5, " W", &DC, "L ", &F7, " T", &F8, "CK", &C4
 EQUS "TO ", &93, "NE", &EE, "E", &DE, " SPA", &E9, " ", &DE, &F5, "I", &DF, ".", &D7, &13
 EQUS "MO", &DE, " ", &ED, "CAPE PODS COME W", &DB, "H "
 EQUS &F0, "SU", &F8, "N", &E9, " POLICI", &ED, &C9, &F2, "P", &F9, &E9, " ", &93
 EQUS &CF, &B2, "EQUIPM", &F6, "T.", &D7
 EQUS &13, "P", &F6, &E4, &FB, &ED, " F", &FD, " ", &F0, "T", &F4, "F", &F4, &C3, "W", &DB, "H"
 EQUS " ", &ED, "CAPE PODS ", &EE, "E ", &DA, &FA, &F2, " "
 EQUS &F0, " MO", &DE, " ", &91, &EE, "Y SY", &DE, "EMS.", &D7, &13, &ED, "CAPE"
 EQUS " PODS ", &EF, "Y ", &F7, " B", &D9, "GHT ", &F5, " "
 EQUS "SY", &DE, "EMS OF TECH ", &E5, &FA, "L 7 ", &FD, " HIGH", &F4, &B1
 EQUB &00
 EQUS &0E, &13, "A ", &F2, &E9, "NT ", &F0, "V", &F6, &FB, &DF, ", ", &93, "HYP", &F4
 EQUS "SPA", &E9, " UN", &DB, &CA, &FF, " ", &E4, "T", &F4, "N", &F5, "I", &FA, " "
 EQUS "TO ", &93, &ED, "CAPE POD F", &FD, " ", &EF, "NY T", &F8, "D", &F4, "S."
 EQUS &D7, &13, "WH", &F6, " TRIG", &E7, &F2, "D, ", &93
 EQUS "HYP", &F4, "SPA", &E9, " UN", &DB, " W", &DC, "L U", &DA, " ", &DB, "S POW", &F4
 EQUS " ", &F0, " E", &E6, "CUT", &C3, "A HYP", &F4, "JUMP "
 EQUS "AWAY FROM ", &93, "CUR", &F2, "NT POS", &DB, "I", &DF, ".", &D7, &13, "UN"
 EQUS "F", &FD, "TUN", &F5, "ELY, ", &F7, "CAU", &DA, " ", &93
 EQUS "HYP", &F4, "JUMP", &CA, &F0, &DE, &FF, "T", &FF, "E", &D9, "S, ", &E2, "E", &F2
 EQUS &CA, &E3, " C", &DF, "TROL OF ", &93
 EQUS "DE", &DE, &F0, &F5, "I", &DF, " POS", &DB, "I", &DF, ".", &D7, &13, "A HYP", &F4, "SPA"
 EQUS &E9, " UN", &DB, &CA, "AVA", &DC, &D8, &E5, " ", &F5, " "
 EQUS "TECH ", &E5, &FA, "L 8 ", &FD, " ", &D8, "O", &FA, &B1
 EQUB &00
 EQUS &0E, &13, &FF, " ", &F6, &F4, "GY UN", &DB, " ", &F0, "C", &F2, "A", &DA, "S ", &93, "R", &F5, "E"
 EQUS " OF ", &F2, "CH", &EE, "G", &C3, "OF ", &93
 EQUS &F6, &F4, "GY B", &FF, "KS FROM SURFA", &E9, " ", &F8, &F1, &F5, "I", &DF
 EQUS " ", &D8, &EB, "RP", &FB, &DF, "."
 EQUS &D7, &13, &F6, &F4, "GY UN", &DB, "S ", &EE, "E AVA", &DC, &D8, &E5, " FROM"
 EQUS " TECH ", &E5, &FA, "L 9 UPW", &EE, "DS", &B1
 EQUB &00
 EQUS &0E, &13, "DOCK", &C3, "COMPUT", &F4, "S ", &EE, "E ", &F2, "COMM", &F6, "D", &C4, "BY ", &E4, "L ", &91, &EE, "Y "
 EQUS "GOV", &F4, "NM", &F6, "TS AS", &D0, "SAFE WAY OF ", &F2, "DUC", &C3, &93
 EQUS &E1, "MB", &F4, " OF DOCK", &C3
 EQUS "ACCID", &F6, "TS.", &D7, &13, "DOCK", &C3, "COMPUT", &F4, "S W", &DC, "L"
 EQUS " AUTO", &EF, &FB, "C", &E4, "LY DOCK", &D0, &CF, " "
 EQUS "WH", &F6, " TURN", &C4, &DF, ".", &D7, &13, "DOCK", &C3, "COMPUT", &F4, "S"
 EQUS " C", &FF, " ", &F7, " B", &D9, "GHT ", &F5, " SY", &DE, "EMS "
 EQUS "OF TECH ", &E5, &FA, "L 10 ", &FD, " MO", &F2, &B1
 EQUB &00
 EQUS &0E, &13, "G", &E4, "AC", &FB, "C HYP", &F4, "SPA", &E9, " ", &97, "S ", &EE, "E "
 EQUS "OBTA", &F0, &D8, &E5, " FROM ", &91, "S OF "
 EQUS "TECH ", &E5, &FA, "L 11 UPW", &EE, "DS.", &D7, &13, "WH", &F6, " "
 EQUS &93, &F0, "T", &F4, "G", &E4, "AC", &FB, "C HYP", &F4, &97, " "
 EQUS "IS ", &F6, "GA", &E7, "D, ", &93, &CF, &CA, "HYP", &F4, "JUMP", &C4, &F0, "TO"
 EQUS " ", &93, "P", &F2, "-PROG", &F8, "MM", &C4
 EQUS "G", &E4, "AXY", &B1
 EQUB &00
 EQUS &0E, &13, "M", &DC, &DB, &EE, "Y ", &F9, &DA, "RS ", &EE, "E ", &93, "HEIGHT"
 EQUS " OF ", &F9, &DA, "R ", &EB, "PHI", &DE, "IC", &F5, "I", &DF, ".", &D7
 EQUS &13, &E2, "EY U", &DA, " HIGH ", &F6, &F4, "GY ", &F9, &DA, "RS FIR", &C3, "C"
 EQUS &DF, &FB, &E1, &D9, "SLY", &C9, "PRODU", &E9, " "
 EQUS "DEVA", &DE, &F5, &C3, "EFFECTS, BUT ", &EE, "E PR", &DF, "E", &C9, "OV", &F4, "HE", &F5, &F0, "G.", &D7
 EQUS &13, "M", &DC, &DB, &EE, "Y ", &F9, &DA, "RS ", &EE, "E AVA", &DC, &D8, &E5, " "
 EQUS "FROM ", &91, "S OF TECH ", &E5, &FA, "L "
 EQUS "12 ", &FD, " MO", &F2, &B1
 EQUB &00
 EQUS &0E, &13, "M", &F0, &C3, &F9, &DA, "RS ", &EE, "E HIGHLY POWE", &F2, "D, "
 EQUS "S", &E0, "W FIR", &C3, "PUL", &DA, " ", &F9, &DA, "RS "
 EQUS "WHICH ", &EE, "E TUN", &C4, "TO F", &F8, "GM", &F6, "T A", &DE, &F4, "OIDS."
 EQUS &D7, &13, "M", &F0, &C3, &F9, &DA, "RS ", &EE, "E "
 EQUS "AVA", &DC, &D8, &E5, " FROM TECH ", &E5, &FA, "L 12 UPW", &EE, "DS", &B1
 EQUB &00


.QQ18

 EQUB &4C, &32, &24, &00, &03, &60, &6B, &A9, &77, &00, &64, &6C
 EQUB &B5, &71, &6D, &6E, &B1, &77, &00, &67, &B2, &62, &32, &20
 EQUB &00, &AF, &B5, &6D, &77, &BA, &7A, &2F, &00, &70, &7A, &70
 EQUB &BF, &6E, &00, &73, &BD, &A6, &00, &21, &03, &A8, &71, &68
 EQUB &66, &77, &03, &85, &70, &00, &AF, &67, &AB, &77, &BD, &A3
 EQUB &00, &62, &64, &BD, &60, &76, &6F, &77, &76, &B7, &6F, &00
 EQUB &BD, &60, &6B, &03, &00, &62, &B5, &B7, &A0, &03, &00, &73
 EQUB &6C, &BA, &03, &00, &A8, &AF, &6F, &7A, &03, &00, &76, &6D
 EQUB &6A, &77, &00, &75, &6A, &66, &74, &03, &00, &B9, &B8, &B4
 EQUB &77, &7A, &00, &B8, &A9, &60, &6B, &7A, &00, &65, &66, &76
 EQUB &67, &A3, &00, &6E, &76, &6F, &B4, &0E, &81, &00, &AE, &60
 EQUB &77, &B2, &BA, &9A, &00, &D8, &6E, &76, &6D, &BE, &77, &00
 EQUB &60, &BC, &65, &BB, &B3, &62, &60, &7A, &00, &67, &66, &6E
 EQUB &6C, &60, &B7, &60, &7A, &00, &60, &BA, &73, &BA, &B2, &66
 EQUB &03, &E8, &B2, &66, &00, &70, &6B, &6A, &73, &00, &73, &DD
 EQUB &67, &76, &60, &77, &00, &03, &B6, &70, &B3, &00, &6B, &76
 EQUB &6E, &B8, &03, &60, &6C, &6F, &BC, &6A, &A3, &00, &6B, &7A
 EQUB &73, &B3, &2D, &03, &00, &70, &6B, &BA, &77, &03, &E9, &82
 EQUB &00, &AE, &E8, &B8, &A6, &00, &73, &6C, &73, &76, &6F, &B2
 EQUB &6A, &BC, &00, &64, &DD, &70, &70, &03, &99, &6A, &75, &6A
 EQUB &77, &7A, &00, &66, &60, &BC, &6C, &6E, &7A, &00, &03, &6F
 EQUB &6A, &64, &6B, &77, &03, &7A, &66, &A9, &70, &00, &BF, &60
 EQUB &6B, &0D, &A2, &B5, &6F, &00, &60, &62, &70, &6B, &00, &03
 EQUB &A5, &2C, &6A, &BC, &00, &59, &82, &22, &00, &77, &A9, &A0
 EQUB &77, &03, &6F, &6C, &E8, &00, &49, &03, &69, &62, &6E, &6E
 EQUB &BB, &00, &71, &B8, &A0, &00, &70, &77, &00, &93, &03, &6C
 EQUB &65, &03, &00, &70, &66, &2C, &00, &03, &60, &A9, &64, &6C
 EQUB &25, &00, &66, &B9, &6A, &73, &00, &65, &6C, &6C, &67, &00
 EQUB &BF, &7B, &B4, &6F, &AA, &00, &B7, &AE, &6C, &62, &60, &B4
 EQUB &B5, &70, &00, &70, &B6, &B5, &70, &00, &6F, &6A, &B9, &BA
 EQUB &0C, &74, &AF, &AA, &00, &6F, &76, &7B, &76, &BD, &AA, &00
 EQUB &6D, &A9, &60, &6C, &B4, &60, &70, &00, &D8, &73, &76, &77
 EQUB &B3, &70, &00, &A8, &60, &6B, &AF, &B3, &7A, &00, &62, &2C
 EQUB &6C, &7A, &70, &00, &65, &6A, &AD, &A9, &6E, &70, &00, &65
 EQUB &76, &71, &70, &00, &6E, &AF, &B3, &A3, &70, &00, &64, &6C
 EQUB &6F, &67, &00, &73, &6F, &B2, &AF, &76, &6E, &00, &A0, &6E
 EQUB &0E, &E8, &BC, &AA, &00, &A3, &6A, &B1, &03, &5C, &70, &00
 EQUB &2F, &12, &13, &23, &16, &23, &00, &03, &60, &71, &00, &6F
 EQUB &A9, &A0, &00, &65, &6A, &B3, &A6, &00, &70, &A8, &2C, &00
 EQUB &64, &AD, &B1, &00, &71, &BB, &00, &7A, &66, &2C, &6C, &74
 EQUB &00, &61, &6F, &76, &66, &00, &61, &B6, &60, &68, &00, &35
 EQUB &00, &70, &6F, &6A, &6E, &7A, &00, &61, &76, &64, &0E, &66
 EQUB &7A, &BB, &00, &6B, &BA, &6D, &BB, &00, &61, &BC, &7A, &00
 EQUB &65, &B2, &00, &65, &76, &71, &71, &7A, &00, &DD, &67, &B1
 EQUB &77, &00, &65, &DD, &64, &00, &6F, &6A, &A7, &71, &67, &00
 EQUB &6F, &6C, &61, &E8, &B3, &00, &A5, &71, &67, &00, &6B, &76
 EQUB &6E, &B8, &6C, &6A, &67, &00, &65, &66, &6F, &AF, &66, &00
 EQUB &AF, &70, &66, &60, &77, &00, &88, &B7, &AE, &AB, &00, &60
 EQUB &6C, &6E, &00, &D8, &6E, &B8, &67, &B3, &00, &03, &67, &AA
 EQUB &77, &DD, &7A, &BB, &00, &71, &6C, &00, &8D, &03, &03, &93
 EQUB &2F, &03, &99, &03, &03, &03, &8D, &03, &85, &03, &65, &BA
 EQUB &03, &70, &62, &A2, &2F, &29, &00, &65, &71, &BC, &77, &00
 EQUB &AD, &A9, &00, &A2, &65, &77, &00, &BD, &64, &6B, &77, &00
 EQUB &5A, &6F, &6C, &74, &24, &00, &40, &32, &DF, &02, &00, &66
 EQUB &7B, &77, &B7, &03, &00, &73, &76, &6F, &70, &66, &98, &00
 EQUB &B0, &62, &6E, &98, &00, &65, &76, &66, &6F, &00, &6E, &BE
 EQUB &70, &6A, &A2, &00, &6A, &0D, &65, &0D, &65, &0D, &86, &00
 EQUB &66, &0D, &60, &0D, &6E, &0D, &86, &00, &45, &44, &70, &00
 EQUB &45, &4B, &70, &00, &4A, &03, &70, &60, &6C, &6C, &73, &70
 EQUB &00, &AA, &60, &62, &73, &66, &03, &73, &6C, &67, &00, &9E
 EQUB &8D, &00, &5A, &8D, &00, &67, &6C, &60, &68, &AF, &64, &03
 EQUB &F4, &00, &59, &03, &9E, &00, &6E, &6A, &6F, &6A, &77, &A9
 EQUB &7A, &98, &00, &6E, &AF, &AF, &64, &98, &00, &E6
 EQUB &19, &23, &00, &AF, &D8, &AF, &64, &03, &49, &00, &B1, &B3
 EQUB &64, &7A, &03, &00, &64, &62, &B6, &60, &B4, &60, &00, &50
 EQUB &03, &BC, &00, &62, &2C, &00, &26, &A2, &64, &A3, &03, &E8
 EQUB &B2, &AB, &19, &00, &DF, &03, &27, &2F, &2F, &2F, &25, &3C
 EQUB &03, &86, &2A, &21, &2F, &9E, &86, &2A, &20, &2F, &60, &BC
 EQUB &AE, &B4, &BC, &2A, &00, &6A, &BF, &6E, &00, &70, &73, &62
 EQUB &A6, &00, &6F, &6F, &00, &B7, &B4, &6D, &64, &19, &00, &03
 EQUB &BC, &03, &00, &2F, &9A, &19, &03

.new_name

 EQUB &03, &03, &03, &03, &03, &03, &03, &03, &03
 EQUB &00, &60, &A2, &B8, &00, &6C, &65, &65
 EQUB &B1, &67, &B3, &00, &65, &76, &64, &6A, &B4, &B5, &00, &6B
 EQUB &A9, &6E, &A2, &70, &70, &00, &6E, &6C, &E8, &6F, &7A, &03
 EQUB &35, &00, &8F, &00, &88, &00, &62, &61, &6C, &B5, &03, &88
 EQUB &00, &D8, &73, &66, &77, &B1, &77, &00, &67, &B8, &A0, &DD
 EQUB &AB, &00, &67, &66, &62, &67, &6F, &7A, &00, &0E, &0E, &0E
 EQUB &0E, &03, &66, &03, &6F, &03, &6A, &03, &77, &03, &66, &03
 EQUB &0E, &0E, &0E, &0E, &00, &73, &AD, &70, &B1, &77, &00, &2B
 EQUB &64, &62, &6E, &66, &03, &6C, &B5, &71, &00, &00, &00, &00
 EQUB &00, &00

.SNE

 EQUB &00, &19, &32, &4A, &62, &79, &8E, &A2, &B5, &C6, &D5, &E2
 EQUB &ED, &F5, &FB, &FF, &FF, &FF, &FB, &F5, &ED, &E2, &D5, &C6
 EQUB &B5, &A2, &8E, &79, &62, &4A, &32, &19

.ACT

 EQUB &00, &01, &03, &04, &05, &06, &08, &09, &0A, &0B, &0C, &0D
 EQUB &0F, &10, &11, &12, &13, &14, &15, &16, &17, &18, &19, &19
 EQUB &1A, &1B, &1C, &1D, &1D, &1E, &1F, &1F


\ a.qcode_4

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

 \	JSR dn2
 \	JMP BAY
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
 JMP d_1220

.dont_quit

 \	CPX #&37
 \	BNE dont_dump
 \	JSR printer
 \dont_dump
 CPX #&59
 BNE freeze_loop

.i_release

 JSR RDKEY
 BNE i_release
 LDX #0	\ no key was pressed

.not_freeze

 RTS


.write_card

 ASL A
 TAY
 LDA card_addr,Y
 STA &22
 LDA card_addr+1,Y
 STA &23

.card_repeat

 JSR MT1
 LDY #&00
 LDA (&22),Y
 TAX
 BEQ quit_card
 BNE card_check

.card_find

 INY
 INY
 INY
 LDA card_pattern-1,Y
 BNE card_find

.card_check

 DEX
 BNE card_find

.card_found

 LDA card_pattern,Y
 STA XC
 LDA card_pattern+1,Y
 STA YC
 LDA card_pattern+2,Y
 BEQ card_details
 JSR write_msg3
 INY
 INY
 INY
 BNE card_found

.card_details

 JSR MT2
 LDY #&00

.card_loop

 INY
 LDA (&22),Y
 BEQ card_end
 BMI card_msg
 CMP #&20
 BCC card_macro
 JSR DTS
 JMP card_loop

.card_macro

 JSR DT3
 JMP card_loop

.card_msg

 CMP #&D7
 BCS card_pairs
 AND #&7F
 JSR write_msg3
 JMP card_loop

.card_pairs

 JSR msg_pairs
 JMP card_loop

.card_end

 TYA
 SEC
 ADC &22
 STA &22
 BCC card_repeat
 INC &23
 BCS card_repeat

.quit_card

 RTS


.ship_posn

 EQUB 20, 13, 23, 12, 33, 37, 22
 EQUB 10,  1,  0,  2, 24, 21, 32
 EQUB 35, 19, 18, 30, 25, 31, 11
 EQUB  8, 17, 26, 27,  9, 16, 14


.ship_dist

 EQUB &01, &02, &01, &02, &01, &01, &01
 EQUB &02, &04, &04, &01, &01, &01, &02
 EQUB &01, &02, &01, &02, &01, &01, &02
 EQUB &01, &01, &03, &01, &01, &01, &01


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


.menu_title

 EQUB &01, &02, &03, &05, &04

.menu_titlex

 EQUB &05, &0C, &0C, &0C, &0B

.menu_offset

 EQUB &02, &07, &15, &5B, &5F

.menu_entry

 EQUB &04, &0E, &0E, &04, &0D

.menu_query

 EQUB &06, &43, &43, &05, &04


.ship_centre

 EQUB &0D, &0C, &0C, &0B, &0D, &0C, &0B
 EQUB &0B, &08, &07, &09, &0A, &0D, &0C
 EQUB &0D, &0D, &0D, &0C, &0D, &0C, &0D
 EQUB &0C, &0B, &0C, &0C, &0A, &0D, &0E


.card_pattern

 EQUB  1,  3, &25	\ inservice date
 EQUB  1,  4, &00
 EQUB 24,  6, &26	\ combat factor
 EQUB 24,  7, &2F
 EQUB 24,  8, &41
 EQUB 26,  8, &00
 EQUB  1,  6, &2B	\ dimensions
 EQUB  1,  7, &00
 EQUB  1,  9, &24	\ speed
 EQUB  1, 10, &00
 EQUB 24, 10, &27	\ crew
 EQUB 24, 11, &00
 EQUB 24, 13, &29	\ range
 EQUB 24, 14, &00
 EQUB  1, 12, &3D	\ cargo space
 EQUB  1, 13, &2D
 EQUB  1, 14, &00
 EQUB  1, 16, &23	\ armaments
 EQUB  1, 17, &00
 EQUB 23, 20, &2C	\ hull
 EQUB 23, 21, &00
 EQUB  1, 20, &28	\ drive motors
 EQUB  1, 21, &00
 EQUB  1, 20, &2D	\ space
 EQUB  1, 21, &00


.card_addr

 EQUW adder, anaconda, asp_2, boa, bushmaster, chameleon, cobra_1
 EQUW cobra_3, coriolis, dodecagon, escape_pod
 EQUW fer_de_lance, gecko, ghavial
 EQUW iguana, krait, mamba, monitor, moray, ophidian, python
 EQUW shuttle, sidewinder, thargoid, thargon
 EQUW transporter, viper, worm


.adder

 EQUB 1
 EQUS "2914", &D5, &C5, &D1
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "45/8/30", &AA
 EQUB 0, 4
 EQUS "0.24", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 6
 EQUS "6", &BF
 EQUB 0, 7
 EQUS "4", &BE
 EQUB 0, 8
 EQUS &B8, " 1928 AZ ", &F7, "am", &B1, &0C, &B0, &AE
 EQUB 0, 9
 EQUS "D4-18", &D3
 EQUB 0, 10
 EQUS "AM 18 ", &EA, " ", &C2
 EQUB 0, 0

.anaconda

 EQUB 1
 EQUS "2856", &D5, "Riml", &F0, &F4, " G", &E4, "ac", &FB, "c)"
 EQUB 0, 2
 EQUS "3"
 EQUB 0, 3
 EQUS "170/60/75", &AA
 EQUB 0, 4
 EQUS "0.14", &C0
 EQUB 0, 5
 EQUS "2-10"
 EQUB 0, 6
 EQUS "10", &BF
 EQUB 0, 7
 EQUS "245", &BE
 EQUB 0, 8
 EQUS &BB, " Hi-", &F8, "d", &B2, &B1, &0C, &B0, &AE
 EQUB 0, 9
 EQUS "M8-**", &D4
 EQUB 0, 10
 EQUS &C9, "32.24", &0C, &F4, "g", &EF, &DE, &F4, "s"
 EQUB 0, 0

.asp_2

 EQUB 1
 EQUS "2878", &D5, "G", &E4, "cop", &D1
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "70/20/65", &AA
 EQUB 0, 4
 EQUS "0.40", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 6
 EQUS "12.5", &BF
 EQUB 0, 7
 EQUS "0", &BE
 EQUB 0, 8
 EQUS &BB, "-", &BA, "Bur", &DE, &B1, &0C, &B0, &AE
 EQUB 0, 9
 EQUS "J6-31", &D2
 EQUB 0, 10
 EQUS &BC, " Whip", &F9, "sh", &0C, &01, "HK", &02, " ", &B2, &B5
 EQUB 0, 0

.boa

 EQUB 1
 EQUS "3017", &D5, &E7, &F2, &E7, " ", &CC, ")"
 EQUB 0, 2
 EQUS "4"
 EQUB 0, 3
 EQUS "115/60/65", &AA
 EQUB 0, 4
 EQUS "0.24", &C0
 EQUB 0, 5
 EQUS "2-6"
 EQUB 0, 6
 EQUS "9", &BF
 EQUB 0, 7
 EQUS "125", &BE
 EQUB 0, 8
 EQUS &B4, &B1, &B3, &0C, &D6, &B6, " & ", &CF, &AE
 EQUB 0, 9
 EQUS "J7-24", &D3
 EQUB 0, 10
 EQUS &C8, &0C, &B6, &B7, " ", &C2, &F4, "s"
 EQUB 0, 0

.bushmaster

 EQUB 1
 EQUS "3001", &D5, &DF, "ri", &F8, " ", &FD, "b", &DB, &E4, ")"
 EQUB 0, 2
 EQUS "8"
 EQUB 0, 3
 EQUS "50/20/50", &AA
 EQUB 0, 4
 EQUS "0.35", &C0
 EQUB 0, 5
 EQUS "1-2"
 EQUB 0, 8
 EQUS "Du", &E4, " 22-18", &B1, &0C, &B0, &AE
 \	EQUB 0, 9
 \	EQUA "3|!R"
 EQUB 0, 10
 EQUS &BC, " Whip", &F9, "sh", &0C, &01, "HT", &02, " ", &B2, &B5
 EQUB 0, 0

.chameleon

 EQUB 1
 EQUS "3122", &D5, &EE, "d", &F6, " Co-op", &F4, "a", &FB, &FA, ")"
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "75/24/40", &AA
 EQUB 0, 4
 EQUS "0.29", &C0
 EQUB 0, 5
 EQUS "1-4"
 EQUB 0, 6
 EQUS "8", &BF
 EQUB 0, 7
 EQUS "30", &BE
 EQUB 0, 8
 EQUS &B8, " Mega", &CA, &B2, &B1, &0C, &B6, &F4, " X3", &AE
 EQUB 0, 9
 EQUS "H5-23", &D3
 EQUB 0, 10
 EQUS &BC, " ", &DE, &F0, "g", &F4, &0C, "Pul", &DA, &B5
 EQUB 0, 0

.cobra_1

 EQUB 1
 EQUS "2855", &D5, "Payn", &D9, ", ", &D0, "& S", &E4, "em)"
 EQUB 0, 2
 EQUS "5"
 EQUB 0, 3
 EQUS "55/15/70", &AA
 EQUB 0, 4
 EQUS "0.26", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 6
 EQUS "6", &BF
 EQUB 0, 7
 EQUS "10", &BE
 EQUB 0, 8
 EQUS &BB, " V", &EE, "isc", &FF, &B1, &0C, &B9, &AE
 EQUB 0, 9
 EQUS "E4-20", &D4
 EQUB 0, 10
 EQUS &D0, &B5
 EQUB 0, 0

.cobra_3

 EQUB 1
 EQUS "3100", &D5, "Cowell & Mg", &13, &F8, &E2, ", ", &F9, &FA, ")"
 EQUB 0, 2
 EQUS "7"
 EQUB 0, 3
 EQUS "65/30/130", &AA
 EQUB 0, 4
 EQUS "0.28", &C0
 EQUB 0, 5
 EQUS "1-3"
 EQUB 0, 6
 EQUS "7", &BF
 EQUB 0, 7
 EQUS "35", &BE
 EQUB 0, 8
 EQUS &B8, &B1, &B3, &0C, &B9, &AE
 EQUB 0, 9
 EQUS "G7-24", &D4
 EQUB 0, 10
 EQUS &BA, &B7, "fa", &DE, &0C, "Irrik", &FF, " Thru", &CD
 EQUB 0, 0

.coriolis

 EQUB 1
 EQUS "2752", &CB
 EQUB 0, 3
 EQUS "1/1/1km"
 EQUB 0, 11
 EQUS "2000", &C3, "s"
 EQUB 0, 0

.dodecagon

 EQUB 1
 EQUS "3152", &CB
 EQUB 0, 3
 EQUS "1/1/1km"
 EQUB 0, 11
 EQUS "2700", &C3, "s"
 EQUB 0, 0

.escape_pod

 EQUB 1
 EQUS "p", &F2, "-2500"
 EQUB 0, 3
 EQUS "10/5/5", &AA
 EQUB 0, 4
 EQUS "0.08", &C0
 EQUB 0, 5
 EQUS "1-2"
 EQUB 0, 0

.fer_de_lance

 EQUB 1
 EQUS "3100", &D5, &C6
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "85/20/45", &AA
 EQUB 0, 4
 EQUS "0.30", &C0
 EQUB 0, 5
 EQUS "1-3"
 EQUB 0, 6
 EQUS "8.5", &BF
 EQUB 0, 7
 EQUS "2", &BE
 EQUB 0, 8
 EQUS &B4, &B1, &B3, &0C, &D6, &B6, " & ", &CF, &AE
 EQUB 0, 9
 EQUS "H7-28", &D4
 EQUB 0, 10
 EQUS "T", &DB, "r", &DF, "ix ", &F0, "t", &F4, "sun", &0C, &01, "LT", &02, " ", &CE
 EQUB 0, 0

.gecko

 EQUB 1
 EQUS "2852", &D5, "A", &E9, " & F", &D8, &F4, ", ", &E5, &F2, &F9, &E9, ")"
 EQUB 0, 2
 EQUS "7"
 EQUB 0, 3
 EQUS "40/12/65", &AA
 EQUB 0, 4
 EQUS "0.30", &C0
 EQUB 0, 5
 EQUS "1-2"
 EQUB 0, 6
 EQUS "7", &BF
 EQUB 0, 7
 EQUS "3", &BE
 EQUB 0, 8
 EQUS &B8, " 1919 A4", &B1, &0C, &C0, " Hom", &F0, "g", &AE
 EQUB 0, 9
 EQUS "E6-19", &D3
 EQUB 0, 10
 EQUS "B", &F2, "am", &B2, &B7, " ", &01, "XL", &02
 EQUB 0, 0

.ghavial

 EQUB 1
 EQUS "3077", &D5, &EE, "d", &F6, " Co-op", &F4, "a", &FB, &FA, ")"
 EQUB 0, 2
 EQUS "5"
 EQUB 0, 3
 EQUS "80/30/60", &AA
 EQUB 0, 4
 EQUS "0.25", &C0
 EQUB 0, 5
 EQUS "2-7"
 EQUB 0, 6
 EQUS "8", &BF
 EQUB 0, 7
 EQUS "50", &BE
 EQUB 0, 8
 EQUS "Fai", &F2, "y", &B2, &B1, &0C, &B9, &AE
 EQUB 0, 9
 EQUS "I5-25", &D4
 EQUB 0, 10
 EQUS "Sp", &E4, "d", &F4, " & Prime ", &01, "TT1", &02
 EQUB 0, 0

.iguana

 EQUB 1
 EQUS "3095", &D5, "Faulc", &DF, " ", &EF, "n", &CD, ")"
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "65/20/40", &AA
 EQUB 0, 4
 EQUS "0.33", &C0
 EQUB 0, 5
 EQUS "1-3"
 EQUB 0, 6
 EQUS "7.5", &BF
 EQUB 0, 7
 EQUS "15", &BE
 EQUB 0, 8
 EQUS &B9, &B1, &0C, &B6, &F4, " X1", &AE
 EQUB 0, 9
 EQUS "G6-20", &D4
 EQUB 0, 10
 EQUS &C7, " Sup", &F4, " ", &C2, &0C, &01, "VC", &02, "9"
 EQUB 0, 0

.krait

 EQUB 1
 EQUS "3027", &D5, &C7, &C3, "W", &FD, "ks, ", &F0, &F0, &ED, ")"
 EQUB 0, 2
 EQUS "7"
 EQUB 0, 3
 EQUS "80/20/90", &AA
 EQUB 0, 4
 EQUS "0.30", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 7
 EQUS "10", &BE
 EQUB 0, 8
 EQUS &B4, &B1, &B3
 \	EQUB 0, 9
 \	EQUA "8|!S"
 EQUB 0, 10
 EQUS &C7, " Sp", &F0, &CE, " ZX14"
 EQUB 0, 0

.mamba

 EQUB 1
 EQUS "3110", &D5, &F2, &FD, "te", &C3, " ", &CC, ")"
 EQUB 0, 2
 EQUS "8"
 EQUB 0, 3
 EQUS "55/12/65", &AA
 EQUB 0, 4
 EQUS "0.30", &C0
 EQUB 0, 5
 EQUS "1-2"
 EQUB 0, 7
 EQUS "10", &BE
 EQUB 0, 8
 EQUS &B4, &B1, &B3, &0C, &D6, &B6, " & ", &CF, &AE
 \	EQUB 0, 9
 \	EQUA "7|!R"
 EQUB 0, 10
 EQUS &B6, &B7, " ", &01, "HV", &02, " ", &C2
 EQUB 0, 0

.monitor

 EQUB 1
 EQUS "3112", &D5, &C6
 EQUB 0, 2
 EQUS "4"
 EQUB 0, 3
 EQUS "100/40/50", &AA
 EQUB 0, 4
 EQUS "0.16", &C0
 EQUB 0, 5
 EQUS "7-19"
 EQUB 0, 6
 EQUS "11", &BF
 EQUB 0, 7
 EQUS "75", &BE
 EQUB 0, 8
 EQUS &BA, &01, "HMB", &02, &B1, &0C, &B0, &AE
 EQUB 0, 9
 EQUS "J6-28", &D4
 EQUB 0, 10
 EQUS &C9, "29.01", &0C, &B7, " ", &CA, &F4, "s"
 EQUB 0, 0

.moray

 EQUB 1
 EQUS "3028", &D5, "M", &EE, &F0, "e T", &F2, "nch Co.)"
 EQUB 0, 2
 EQUS "7"
 EQUB 0, 3
 EQUS "60/25/60", &AA
 EQUB 0, 4
 EQUS "0.25", &C0
 EQUB 0, 5
 EQUS "1-4"
 EQUB 0, 6
 EQUS "8", &BF
 EQUB 0, 7
 EQUS "7", &BE
 EQUB 0, 8
 EQUS &B8, &B1, &B3, &0C, &B0, &AE
 EQUB 0, 9
 EQUS "F4-22", &D4
 EQUB 0, 10
 EQUS "Turbul", &F6, " ", &FE, &EE, "k", &0C, &F2, "-ch", &EE, "g", &F4, " 1287"
 EQUB 0, 0

.ophidian

 EQUB 1
 EQUS "2981", &D5, &C5, &D1
 EQUB 0, 2
 EQUS "8"
 EQUB 0, 3
 EQUS "65/15/30", &AA
 EQUB 0, 4
 EQUS "0.34", &C0
 EQUB 0, 5
 EQUS "1-3"
 EQUB 0, 6
 EQUS "7", &BF
 EQUB 0, 7
 EQUS "20", &BE
 EQUB 0, 8
 EQUS &B9, &B1, &0C, &B6, &F4, " X1", &AE
 EQUB 0, 9
 EQUS "D4-16", &D2
 EQUB 0, 10
 EQUS &BC, " ", &DE, &F0, "g", &F4, &0C, "Pul", &DA, &B5
 EQUB 0, 0

.python

 EQUB 1
 EQUS "2700", &D5, "Wh", &F5, "t & Pr", &DB, "ney SC)"
 EQUB 0, 2
 EQUS "3"
 EQUB 0, 3
 EQUS "130/40/80", &AA
 EQUB 0, 4
 EQUS "0.20", &C0
 EQUB 0, 5
 EQUS "2-9"
 EQUB 0, 6
 EQUS "8", &BF
 EQUB 0, 7
 EQUS "100", &BE
 EQUB 0, 8
 EQUS "Volt-", &13, "V", &EE, "isc", &FF, &B2, &B1
 EQUB 0, 9
 EQUS "K6-27", &D4
 EQUB 0, 10
 EQUS &C8, &0C, "Exl", &DF, " 76NN Model"
 EQUB 0, 0

.shuttle

 EQUB 1
 EQUS "2856", &D5, "Saud-", &BA, "A", &DE, "ro)"
 EQUB 0, 2
 EQUS "4"
 EQUB 0, 3
 EQUS "35/20/20", &AA
 EQUB 0, 4
 EQUS "0.08", &C0
 EQUB 0, 5
 EQUS "2"
 EQUB 0, 7
 EQUS "60", &BE
 EQUB 0, 10
 EQUS &C9, "20.20", &0C, &DE, &EE, &EF, "t ", &B5
 EQUB 0, 0

.sidewinder

 EQUB 1
 EQUS "2982", &D5, &DF, "ri", &F8, " ", &FD, "b", &DB, &E4, ")"
 EQUB 0, 2
 EQUS "9"
 EQUB 0, 3
 EQUS "35/15/65", &AA
 EQUB 0, 4
 EQUS "0.37", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 8
 EQUS "Du", &E4, " 22-18", &B1
 \	EQUB 0, 9
 \	EQUA "3|!R"
 EQUB 0, 10
 EQUS &C7, " Sp", &F0, &CE, " ", &01, "MV", &02
 EQUB 0, 0

.thargoid

 EQUB 2
 EQUS "6"
 EQUB 0, 3
 EQUS "180/40/180", &AA
 EQUB 0, 4
 EQUS "0.39", &C0
 EQUB 0, 5
 EQUS "50"
 EQUB 0, 6
 EQUS "Unk", &E3, "wn"
 EQUB 0, 8
 EQUS "Widely v", &EE, "y", &F0, "g"
 \	EQUB 0, 9
 \	EQUA "Unk|!cwn"
 EQUB 0, 10
 EQUS &9E, " ", &C4
 EQUB 0, 0

.thargon

 EQUB 2
 EQUS "6"
 EQUB 0, 3
 EQUS "40/10/35", &AA
 EQUB 0, 4
 EQUS "0.30", &C0
 EQUB 0, 5
 EQUS &E3, "ne"
 EQUB 0, 8
 EQUS &9E, &B1
 \	EQUB 0, 9
 \	EQUA "|!cne"
 EQUB 0, 10
 EQUS &9E, " ", &C4
 EQUB 0, 0

.transporter

 EQUB 1
 EQUS "p", &F2, "-2500", &D5, &CD, "L", &F0, "k", &C3, "y", &EE, "ds)"
 EQUB 0, 3
 EQUS "35/10/30", &AA
 EQUB 0, 4
 EQUS "0.10", &C0
 EQUB 0, 5
 EQUS "5"
 EQUB 0, 7
 EQUS "10", &BE
 EQUB 0, 0

.viper

 EQUB 1
 EQUS "2762", &D5, "Faulc", &DF, " ", &EF, "n", &CD, ")"
 EQUB 0, 2
 EQUS "7"
 EQUB 0, 3
 EQUS "55/20/50", &AA
 EQUB 0, 4
 EQUS "0.32", &C0
 EQUB 0, 5
 EQUS "1-10"
 EQUB 0, 8
 EQUS &B8, " Mega", &CA, &B2, &B1, &0C, &B6, &F4, " X3", &AE
 \	EQUB 0, 9
 \	EQUA "9|!R"
 EQUB 0, 10
 EQUS &C7, " Sup", &F4, " ", &C2, &0C, &01, "VC", &02, "10"
 EQUB 0, 0

.worm

 EQUB 1
 EQUS "3101"
 EQUB 0, 2
 EQUS "6"
 EQUB 0, 3
 EQUS "35/12/35", &AA
 EQUB 0, 4
 EQUS "0.23", &C0
 EQUB 0, 5
 EQUS "1"
 EQUB 0, 8
 EQUS &B8, &B2, &B1
 \	EQUB 0, 9
 \	EQUA "3|!R"
 EQUB 0, 10
 EQUS &B6, &B7, " ", &01, "HV", &02, " ", &C2
 EQUB 0, 0


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
 \	TXA
 \	PHA
 \	LDA #&9C
 \	JSR tube_write
 \	JSR tube_read
 \	PLA
 \	TAX
 \	RTS


\ a.qcode_5

.run_tcode

 JSR RES2
 JMP DOENTRY

.d_1220

 JSR RES2
 JMP dead_in

.d_1228

 LDA &0900
 STA &00
 LDX JSTX
 CPX new_max
 BCC n_highx
 LDX new_max

.n_highx

 CPX new_min
 BCS n_lowx
 LDX new_min

.n_lowx

 JSR cntr
 JSR cntr
 TXA
 EOR #&80
 TAY
 AND #&80
 STA &32
 STX JSTX
 EOR #&80
 STA &33
 TYA
 BPL d_124d
 EOR #&FF
 CLC
 ADC #&01

.d_124d

 LSR A
 LSR A
 CMP #&08
 BCS d_1254
 LSR A

.d_1254

 STA &31
 ORA &32
 STA &8D
 LDX JSTY
 CPX new_max
 BCC n_highy
 LDX new_max

.n_highy

 CPX new_min
 BCS n_lowy
 LDX new_min

.n_lowy

 JSR cntr
 TXA
 EOR #&80
 TAY
 AND #&80
 STX JSTY
 STA &7C
 EOR #&80
 STA &7B
 TYA
 BPL d_1274
 EOR #&FF

.d_1274

 ADC #&04
 LSR A
 LSR A
 LSR A
 LSR A
 CMP #&03
 BCS d_127f
 LSR A

.d_127f

 STA &2B
 ORA &7B
 STA &2A
 LDA &0302
 BEQ d_12ab
 LDA &7D
 CMP new_speed
 BCC speed_up

.d_12ab

 LDA &0301
 BEQ d_12b6
 DEC &7D
 BNE d_12b6

.speed_up

 INC &7D

.d_12b6

 LDA &030B
 AND NOMSL
 BEQ d_12cd
 LDY #&EE
 JSR ABORT
 JSR d_439f
 LDA #&00
 STA MSAR

.d_12cd

 LDA &45
 BPL d_12e3
 LDA &030A
 BEQ d_12e3
 LDX NOMSL
 BEQ d_12e3
 STA MSAR
 LDY #&E0
 DEX
 JSR MSBAR2

.d_12e3

 LDA &030C
 BEQ d_12ef
 LDA &45
 BMI d_1326
 JSR d_252e

.d_12ef

 LDA &0308
 AND BOMB
 BEQ d_12f7
 INC BOMB
 INC new_hold	\***
 JSR DORND
 STA QQ9	\QQ0
 STX QQ10	\QQ1
 JSR TT111
 JSR hyper_snap

.d_12f7

 LDA &030F
 AND DKCMP
 BNE dock_toggle
 LDA &0310
 BEQ d_1301
 LDA #&00

.dock_toggle

 STA &033F

.d_1301

 LDA &0309
 AND ESCP
 BEQ d_130c
 JMP ESCAPE

.d_130c

 LDA &030E
 BEQ d_1314
 JSR d_434e

.d_1314

 LDA &030D
 AND ECM
 BEQ d_1326
 LDA &30
 BNE d_1326
 DEC &0340
 JSR d_3813

.d_1326

 LDA #&00
 STA &44
 STA &7E
 LDA &7D
 LSR A
 ROR &7E
 LSR A
 ROR &7E
 STA &7F
 JSR read_0346
 BNE d_1374
 LDA &0307
 BEQ d_1374
 LDA GNTMP
 CMP #&F2
 BCS d_1374
 LDX VIEW
 LDA LASER,X
 BEQ d_1374
 PHA
 AND #&7F
 STA &0343
 STA &44
 LDA #&00
 JSR NOISE
 JSR LASLI
 PLA
 BPL d_136f
 LDA #&00

.d_136f

 JSR write_0346

.d_1374

 LDX #&00

.d_1376

 STX &84
 LDA FRIN,X
 BNE aaaargh
 JMP d_153f

.aaaargh

 STA &8C
 JSR GINF
 LDY #&24

.d_1387

 LDA (&20),Y
 STA &46,Y
 DEY
 BPL d_1387
 LDA &8C
 BMI d_13b6
 ASL A
 TAY
 LDA XX21-2,Y
 STA &1E
 LDA XX21-1,Y
 STA &1F

.d_13b6

 JSR MVEIT_FLIGHT
 LDY #&24

.d_13bb

 LDA &46,Y
 STA (&20),Y
 DEY
 BPL d_13bb
 LDA &65
 AND #&A0
 JSR d_41bf
 BNE d_141d
 LDA &46
 ORA &49
 ORA &4C
 BMI d_141d
 LDX &8C
 BMI d_141d
 CPX #&02
 BEQ d_1420
 AND #&C0
 BNE d_141d
 CPX #&01
 BEQ d_141d
 LDA BST
 AND &4B
 BPL d_1464
 CPX #&05
 BEQ d_13fd
 LDY #&00
 LDA (&1E),Y
 LSR A
 LSR A
 LSR A
 LSR A
 BEQ d_1464
 ADC #&01
 BNE d_1402

.d_13fd

 JSR DORND
 \	AND #&07
 AND #&0F

.d_1402

 TAX
 JSR d_2aec
 BCS d_1464
 INC QQ20,X
 TXA
 ADC #&D0
 JSR MESS
 JSR top_6a

.d_141d

 JMP d_1473

.d_1420

 LDA &0949
 AND #&04
 BNE d_1449
 LDA &54
 CMP #&D6
 BCC d_1449
 LDY #&25
 JSR d_42ae
 LDA &36
 CMP #&56
 BCC d_1449
 LDA &56
 AND #&7F
 CMP #&50
 BCC d_1449

.GOIN

 JSR RES2
 LDA #&08
 JSR d_263d
 JMP run_tcode
 \d_1452
 \	JSR EXNO3
 \	JSR d_2160
 \	BNE d_1473

.d_1449

 LDA &7D
 CMP #&05
 BCS n_crunch
 LDA &033F
 AND #&04
 EOR #&05
 BNE d_146d

.d_1464

 LDA #&40
 JSR n_hit
 JSR anger_8c

.n_crunch

 LDA #&80

.d_146d

 JSR n_through
 JSR EXNO3

.d_1473

 LDA &6A
 BPL d_147a
 JSR SCAN

.d_147a

 LDA &87
 BNE d_14f0
 LDX VIEW
 BEQ d_1486
 JSR PU1

.d_1486

 JSR d_24c7
 BCC d_14ed
 LDA MSAR
 BEQ d_149a
 JSR BEEP
 LDX &84
 LDY #&0E
 JSR ABORT2

.d_149a

 LDA &44
 BEQ d_14ed
 LDX #&0F
 JSR EXNO
 LDA &44
 LDY &8C
 CPY #&02
 BEQ d_14e8
 CPY #&1F
 BNE d_14b7
 LSR A

.d_14b7

 LSR A
 JSR n_hit	\ hit enemy
 BCS d_14e6
 LDA &8C
 CMP #&07
 BNE d_14d9
 LDA &44
 CMP new_mining
 BNE d_14d9
 JSR DORND
 LDX #&08
 AND #&03
 JSR d_1687

.d_14d9

 LDY #&04
 JSR d_1678
 LDY #&05
 JSR d_1678
 JSR EXNO2

.d_14e6


.d_14e8

 JSR anger_8c

.d_14ed

 JSR LL9_FLIGHT

.d_14f0

 LDY #&23
 LDA &69
 STA (&20),Y
 LDA &6A
 BMI d_1527
 LDA &65
 BPL d_152a
 AND #&20
 BEQ d_152a
 BIT &6A	\ A=&20
 BVS n_badboy
 BEQ n_goodboy
 LDA #&80

.n_badboy

 ASL A
 ROL A

.n_bitlegal

 LSR A
 BIT FIST
 BNE n_bitlegal
 ADC FIST
 BCS d_1527
 STA FIST
 BCC d_1527

.n_goodboy

 LDA &034A
 ORA &0341
 BNE d_1527
 LDY #&0A
 LDA (&1E),Y
 TAX
 INY
 LDA (&1E),Y
 TAY
 JSR MCASH
 LDA #&00
 JSR MESS

.d_1527

 JMP d_3d7f

.n_hit

 \ hit opponent
 STA &D1
 SEC
 LDY #&0E	\ opponent shield
 LDA (&1E),Y
 AND #&07
 SBC &D1
 BCS n_kill
 \	BCC n_defense
 \	LDA #0
 \n_defense
 CLC
 ADC &69
 STA &69
 BCS n_kill
 JSR d_2160

.n_kill

 \ C clear if dead
 RTS

.d_152a

 LDA &8C
 BMI d_1533
 JSR d_41b2
 BCC d_1527

.d_1533

 LDY #&1F
 LDA &65
 STA (&20),Y
 LDX &84
 INX
 JMP d_1376

.d_153f

 LDA &8A
 AND #&07
 BNE d_15c2
 LDX ENERGY
 BPL d_156c
 LDX ASH
 JSR SHD
 STX ASH
 LDX FSH
 JSR SHD
 STX FSH

.d_156c

 SEC
 LDA ENGY
 ADC ENERGY
 BCS d_1578
 STA ENERGY

.d_1578

 LDA &0341
 BNE d_15bf
 LDA &8A
 AND #&1F
 BNE d_15cb
 LDA &0320
 BNE d_15bf
 TAY
 JSR MAS2
 BNE d_15bf
 LDX #&1C

.d_1590

 LDA &0900,X
 STA &46,X
 DEX
 BPL d_1590
 INX
 LDY #&09
 JSR MAS1
 BNE d_15bf
 LDX #&03
 LDY #&0B
 JSR MAS1
 BNE d_15bf
 LDX #&06
 LDY #&0D
 JSR MAS1
 BNE d_15bf
 LDA #&C0
 JSR d_41b4
 BCC d_15bf
 JSR WPLS
 JSR NWSPS

.d_15bf

 JMP d_1648

.d_15c2

 LDA &0341
 BNE d_15bf
 LDA &8A
 AND #&1F

.d_15cb

 CMP #&0A
 BNE d_15fd
 LDA #&32
 CMP ENERGY
 BCC d_15da
 ASL A
 JSR MESS

.d_15da

 LDY #&FF
 STY ALTIT
 INY
 JSR m
 BNE d_1648
 JSR MAS3
 BCS d_1648
 SBC #&24
 BCC d_15fa
 STA &82
 JSR LL5
 LDA &81
 STA ALTIT
 BNE d_1648

.d_15fa

 JMP d_41c6

.d_15fd

 CMP #&0F
 BNE d_160a
 LDA &033F
 BEQ d_1648
 LDA #&7B
 BNE d_1645

.d_160a

 CMP #&14
 BNE d_1648
 LDA #&1E
 STA CABTMP
 LDA &0320
 BNE d_1648
 LDY #&25
 JSR MAS2
 BNE d_1648
 JSR MAS3
 EOR #&FF
 ADC #&1E
 STA CABTMP
 BCS d_15fa
 CMP #&E0
 BCC d_1648
 LDA BST
 BEQ d_1648
 LDA &7F
 LSR A
 ADC QQ14
 CMP new_range
 BCC d_1640
 LDA new_range

.d_1640

 STA QQ14
 LDA #&A0

.d_1645

 JSR MESS

.d_1648

 LDA &0343
 BEQ d_165c
 JSR read_0346	\LDA &0346
 CMP #&08
 BCS d_165c
 JSR LASLI2
 LDA #&00
 STA &0343

.d_165c

 LDA &0340
 BEQ d_1666
 JSR DENGY
 BEQ d_166e

.d_1666

 LDA &30
 BEQ d_1671
 DEC &30
 BNE d_1671

.d_166e

 JSR ECMOF

.d_1671

 LDA &87
 BNE d_1694
 JMP STARS

.d_1678

 JSR DORND
 BPL d_1694
 PHA
 TYA
 TAX
 PLA
 LDY #&00
 AND (&1E),Y
 AND #&0F

.d_1687

 STA &93
 BEQ d_1694

.d_168b

 LDA #&00
 JSR d_2592
 DEC &93
 BNE d_168b

.d_1694

 RTS

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

.TA34

 LDA #&00
 JSR d_41bf
 BEQ d_210c
 JMP d_21c5

.d_210c

 JSR d_2160
 JSR EXNO3
 LDA #&FA
 JMP d_36e4

.d_2117

 LDA &30
 BNE d_2150
 LDA &66
 ASL A
 BMI TA34
 LSR A
 TAX
 LDA UNIV,X
 STA &22
 LDA UNIV+&01,X
 JSR d_2409
 LDA &D4
 ORA &D7
 ORA &DA
 AND #&7F
 ORA &D3
 ORA &D6
 ORA &D9
 BNE d_2166
 LDA &66
 CMP #&82
 BEQ d_2150
 LDY #&23	\ missile damage
 SEC
 LDA (&22),Y
 SBC #&40
 BCS n_misshit
 LDY #&1F
 LDA (&22),Y
 BIT d_216d+&01
 BNE d_2150
 ORA #&80	\ missile hits

.n_misshit

 STA (&22),Y

.d_2150

 LDA &46
 ORA &49
 ORA &4C
 BNE d_215d
 LDA #&50
 JSR d_36e4

.d_215d

 JSR EXNO2

.d_2160

 ASL &65
 SEC
 ROR &65

.d_2165

 RTS

.d_2166

 JSR DORND
 CMP #&10
 BCS d_2174

.d_216d

 LDY #&20
 LDA (&22),Y
 LSR A
 BCS d_2177

.d_2174

 JMP d_221a

.d_2177

 JMP d_3813

.TACTICS

 LDY #&03
 STY &99
 INY
 STY &9A
 LDA #&16
 STA &94
 CPX #&01
 BEQ d_2117
 CPX #&02
 BNE d_21bb
 LDA &6A
 AND #&04
 BNE d_21a6
 LDA &0328
 ORA &033F	\ no shuttles if docking computer on
 BNE d_2165
 JSR DORND
 CMP #&FD
 BCC d_2165
 AND #&01
 ADC #&08
 TAX
 BNE d_21b6	\ BRA

.d_21a6

 JSR DORND
 CMP #&F0
 BCC d_2165
 LDA &032E
 CMP #&07	\ viper hordes
 BCS d_21d4
 LDX #&10

.d_21b6

 LDA #&F1
 JMP d_2592

.d_21bb

 LDY #&0E
 LDA &69
 CMP (&1E),Y
 BCS d_21c5
 INC &69

.d_21c5

 CPX #&1E
 BNE d_21d5
 LDA &033B
 BNE d_21d5
 LSR &66
 ASL &66
 LSR &61

.d_21d4

 RTS

.d_21d5

 JSR DORND
 LDA &6A
 LSR A
 BCC d_21e1
 CPX #&64
 BCS d_21d4

.d_21e1

 LSR A
 BCC d_21f3
 LDX FIST
 CPX #&28
 BCC d_21f3
 LDA &6A
 ORA #&04
 STA &6A
 LSR A
 LSR A

.d_21f3

 LSR A
 BCS d_2203
 LSR A
 LSR A
 BCC d_21fd
 JMP d_2346

.d_21fd

 LDY #&00
 JSR d_42ae
 JMP d_2324

.d_2203

 LSR A
 BCC d_2211
 LDA &0320
 BEQ d_2211
 LDA &66
 AND #&81
 STA &66

.d_2211

 LDX #&08

.d_2213

 LDA &46,X
 STA &D2,X
 DEX
 BPL d_2213

.d_221a

 JSR d_42bd
 JSR d_28de
 STA &93
 LDA &8C
 CMP #&01
 BNE d_222b
 JMP d_22dd

.d_222b

 CMP #&0E
 BNE d_223b
 JSR DORND
 CMP #&C8
 BCC d_223b
 LDX #&0F
 JMP d_21b6

.d_223b

 JSR DORND
 CMP #&FA
 BCC d_2249
 JSR DORND
 ORA #&68
 STA &63

.d_2249

 LDY #&0E
 LDA (&1E),Y
 LSR A
 CMP &69
 BCC d_2294
 LSR A
 LSR A
 CMP &69
 BCC d_226d
 JSR DORND
 CMP #&E6
 BCC d_226d
 LDX &8C
 LDA ship_flags,X
 BPL d_226d
 LDA #&00
 STA &66
 JMP d_258e

.d_226d

 LDA &65
 AND #&07
 BEQ d_2294
 STA &D1
 JSR DORND
 \	AND #&1F
 AND #&0F
 CMP &D1
 BCS d_2294
 LDA &30
 BNE d_2294
 DEC &65
 LDA &8C
 CMP #&1D
 BNE d_2291
 LDX #&1E
 LDA &66
 JMP d_2592

.d_2291

 JMP d_43be

.d_2294

 LDA #&00
 JSR d_41bf
 AND #&E0
 BNE d_22c6
 LDX &93
 CPX #&A0
 BCC d_22c6
 LDY #&13
 LDA (&1E),Y
 AND #&F8
 BEQ d_22c6
 LDA &65
 ORA #&40
 STA &65
 CPX #&A3
 BCC d_22c6
 LDA (&1E),Y
 LSR A
 JSR d_36e4
 DEC &62
 LDA &30
 BNE d_2311
 LDA #&08
 JMP NOISE

.d_22c6

 LDA &4D
 CMP #&03
 BCS d_22d4
 LDA &47
 ORA &4A
 AND #&FE
 BEQ d_22e6

.d_22d4

 JSR DORND
 ORA #&80
 CMP &66
 BCS d_22e6

.d_22dd

 JSR d_245d
 LDA &93
 EOR #&80

.d_22e4

 STA &93

.d_22e6

 LDY #&10
 JSR TAS4
 TAX
 JSR d_2332
 STA &64
 LDA &63
 ASL A
 CMP #&20
 BCS d_2305
 LDY #&16
 JSR TAS4
 TAX
 EOR &64
 JSR d_2332
 STA &63

.d_2305

 LDA &93
 BMI d_2312
 CMP &94
 BCC d_2312
 LDA #&03
 STA &62

.d_2311

 RTS

.d_2312

 AND #&7F
 CMP #&12
 BCC d_2323
 LDA #&FF
 LDX &8C
 CPX #&01
 BNE d_2321
 ASL A

.d_2321

 STA &62

.d_2323

 RTS

.d_2324

 JSR d_28de
 CMP #&98
 BCC d_232f
 LDX #&00
 STX &9A

.d_232f

 JMP d_22e4

.d_2332

 EOR #&80
 AND #&80
 STA &D1
 TXA
 ASL A
 CMP &9A
 BCC d_2343
 LDA &99
 ORA &D1
 RTS

.d_2343

 LDA &D1
 RTS

.d_2346

 LDA #&06
 STA &9A
 LSR A
 STA &99
 LDA #&1D
 STA &94
 LDA &0320
 BNE d_2359

.d_2356

 JMP d_21fd

.d_2359

 JSR d_2403
 LDA &D4
 ORA &D7
 ORA &DA
 AND #&7F
 BNE d_2356
 JSR d_42e0
 LDA &81
 STA &40
 JSR d_42bd
 LDY #&0A
 JSR d_243b
 BMI d_239a
 CMP #&23
 BCC d_239a
 JSR d_28de
 CMP #&A2
 BCS d_23b4
 LDA &40
 CMP #&9D
 BCC d_238c
 LDA &8C
 BMI d_23b4

.d_238c

 JSR d_245d
 JSR d_2324

.d_2392

 LDX #&00
 STX &62
 INX
 STX &61
 RTS

.d_239a

 JSR d_2403
 JSR d_2470
 JSR d_2470
 JSR d_42bd
 JSR d_245d
 JMP d_2324

.d_23ac

 INC &62
 LDA #&7F
 STA &63
 BNE d_23f9

.d_23b4

 LDX #&00
 STX &9A
 STX &64
 LDA &8C
 BPL d_23de
 EOR &34
 EOR &35
 ASL A
 LDA #&02
 ROR A
 STA &63
 LDA &34
 ASL A
 CMP #&0C
 BCS d_2392
 LDA &35
 ASL A
 LDA #&02
 ROR A
 STA &64
 LDA &35
 ASL A
 CMP #&0C
 BCS d_2392

.d_23de

 STX &63
 LDA &5C
 STA &34
 LDA &5E
 STA &35
 LDA &60
 STA &36
 LDY #&10
 JSR d_243b
 ASL A
 CMP #&42
 BCS d_23ac
 JSR d_2392

.d_23f9

 LDA &DC
 BNE d_2402

.top_6a

 ASL &6A
 SEC
 ROR &6A

.d_2402

 RTS

.d_2403

 LDA #&25
 STA &22
 LDA #&09

.d_2409

 STA &23
 LDY #&02
 JSR d_2417
 LDY #&05
 JSR d_2417
 LDY #&08

.d_2417

 LDA (&22),Y
 EOR #&80
 STA &43
 DEY
 LDA (&22),Y
 STA &42
 DEY
 LDA (&22),Y
 STA &41
 STY &80
 LDX &80
 JSR MVT3
 LDY &80
 STA &D4,X
 LDA &42
 STA &D3,X
 LDA &41
 STA &D2,X
 RTS

.d_243b

 LDX &0925,Y
 STX &81
 LDA &34
 JSR MULT12
 LDX &0927,Y
 STX &81
 LDA &35
 JSR MAD
 STA &83
 STX &82
 LDX &0929,Y
 STX &81
 LDA &36
 JMP MAD

.d_245d

 LDA &34
 EOR #&80
 STA &34
 LDA &35
 EOR #&80
 STA &35
 LDA &36
 EOR #&80
 STA &36
 RTS

.d_2470

 JSR d_2473

.d_2473

 LDA &092F
 LDX #&00
 JSR d_2488
 LDA &0931
 LDX #&03
 JSR d_2488
 LDA &0933
 LDX #&06

.d_2488

 ASL A
 STA &82
 LDA #&00
 ROR A
 EOR #&80
 EOR &D4,X
 BMI d_249f
 LDA &82
 ADC &D2,X
 STA &D2,X
 BCC d_249e
 INC &D3,X

.d_249e

 RTS

.d_249f

 LDA &D2,X
 SEC
 SBC &82
 STA &D2,X
 LDA &D3,X
 SBC #&00
 STA &D3,X
 BCS d_249e
 LDA &D2,X
 EOR #&FF
 ADC #&01
 STA &D2,X
 LDA &D3,X
 EOR #&FF
 ADC #&00
 STA &D3,X
 LDA &D4,X
 EOR #&80
 STA &D4,X
 JMP d_249e

.d_24c7

 CLC
 LDA &4E
 BNE d_2505
 LDA &8C
 BMI d_2505
 LDA &65
 AND #&20
 ORA &47
 ORA &4A
 BNE d_2505
 LDA &46
 JSR SQUA2
 STA &83
 LDA &1B
 STA &82
 LDA &49
 JSR SQUA2
 TAX
 LDA &1B
 ADC &82
 STA &82
 TXA
 ADC &83
 BCS d_2506
 STA &83
 LDY #&02
 LDA (&1E),Y
 CMP &83
 BNE d_2505
 DEY
 LDA (&1E),Y
 CMP &82

.d_2505

 RTS

.d_2506

 CLC
 RTS

.FRS1

 JSR ZINF
 LDA #&1C
 STA &49
 LSR A
 STA &4C
 LDA #&80
 STA &4B
 LDA &45
 ASL A
 ORA #&80
 STA &66

.d_251d

 LDA #&60
 STA &54
 ORA #&80
 STA &5C
 LDA &7D
 ROL A
 STA &61
 TXA
 JMP NWSHP

.d_252e

 LDX #&01
 JSR FRS1
 BCC d_2589
 LDX &45
 JSR GINF
 LDA FRIN,X
 JSR d_254d
 DEC NOMSL
 JSR msblob	\ redraw missiles
 STY MSAR
 STX &45
 JMP n_sound30

.anger_8c

 LDA &8C

.d_254d

 CMP #&02
 BEQ d_2580
 LDY #&24
 LDA (&20),Y
 AND #&20
 BEQ d_255c
 JSR d_2580

.d_255c

 LDY #&20
 LDA (&20),Y
 BEQ d_2505
 ORA #&80
 STA (&20),Y
 LDY #&1C
 LDA #&02
 STA (&20),Y
 ASL A
 LDY #&1E
 STA (&20),Y
 LDA &8C
 CMP #&0B
 BCC d_257f
 LDY #&24
 LDA (&20),Y
 ORA #&04
 STA (&20),Y

.d_257f

 RTS

.d_2580

 LDA &0949
 ORA #&04
 STA &0949
 RTS

.d_2589

 LDA #&C9
 JMP MESS

.d_258e

 LDX #&03

.d_2590

 LDA #&FE

.d_2592

 STA &06
 TXA
 PHA
 LDA &1E
 PHA
 LDA &1F
 PHA
 LDA &20
 PHA
 LDA &21
 PHA
 LDY #&24

.d_25a4

 LDA &46,Y
 STA &0100,Y
 LDA (&20),Y
 STA &46,Y
 DEY
 BPL d_25a4
 LDA &6A
 AND #&1C
 STA &6A
 LDA &8C
 CMP #&02
 BNE d_25db
 TXA
 PHA
 LDA #&20
 STA &61
 LDX #&00
 LDA &50
 JSR d_261a
 LDX #&03
 LDA &52
 JSR d_261a
 LDX #&06
 LDA &54
 JSR d_261a
 PLA
 TAX

.d_25db

 LDA &06
 STA &66
 LSR &63
 ASL &63
 TXA
 CMP #&09
 BCS d_25fe
 CMP #&04
 BCC d_25fe
 PHA
 JSR DORND
 ASL A
 STA &64
 TXA
 AND #&0F
 STA &61
 LDA #&FF
 ROR A
 STA &63
 PLA

.d_25fe

 JSR NWSHP
 PLA
 STA &21
 PLA
 STA &20
 LDX #&24

.d_2609

 LDA &0100,X
 STA &46,X
 DEX
 BPL d_2609
 PLA
 STA &1F
 PLA
 STA &1E
 PLA
 TAX
 RTS

.d_261a

 ASL A
 STA &82
 LDA #&00
 ROR A
 JMP MVT1

.LL164

 LDA #&38
 JSR NOISE
 LDA #&01
 STA &0348
 JSR update_pod
 LDA #&04
 JSR d_263d
 DEC &0348
 JMP update_pod

.LAUN

 JSR n_sound30
 LDA #&08

.d_263d

 STA &95
 JSR TTX66
 JMP HFS1

.STARS2

 LDA #&00
 CPX #&02
 ROR A
 STA &99
 EOR #&80
 STA &9A
 JSR d_272d
 LDY &03C3

.d_268a

 LDA &0FA8,Y
 STA &88
 LSR A
 LSR A
 LSR A
 JSR DV41
 LDA &1B
 EOR &9A
 STA &83
 LDA &0F6F,Y
 STA &1B
 LDA &0F5C,Y
 STA &34
 JSR ADD
 STA &83
 STX &82
 LDA &0F82,Y
 STA &35
 EOR &7B
 LDX &2B
 JSR MULTS-2
 JSR ADD
 STX &24
 STA &25
 LDX &0F95,Y
 STX &82
 LDX &35
 STX &83
 LDX &2B
 EOR &7C
 JSR MULTS-2
 JSR ADD
 STX &26
 STA &27
 LDX &31
 EOR &32
 JSR MULTS-2
 STA &81
 LDA &24
 STA &82
 LDA &25
 STA &83
 EOR #&80
 JSR MAD
 STA &25
 TXA
 STA &0F6F,Y
 LDA &26
 STA &82
 LDA &27
 STA &83
 JSR MAD
 STA &83
 STX &82
 LDA #&00
 STA &1B
 LDA &8D
 JSR PIX1
 LDA &25
 STA &0F5C,Y
 STA &34
 AND #&7F
 CMP #&74
 BCS d_2748
 LDA &27
 STA &0F82,Y
 STA &35
 AND #&7F
 CMP #&74
 BCS d_275b

.d_2724

 JSR PIXEL2
 DEY
 BEQ d_272d
 JMP d_268a

.d_272d

 LDA &8D
 EOR &99
 STA &8D
 LDA &32
 EOR &99
 STA &32
 EOR #&80
 STA &33
 LDA &7B
 EOR &99
 STA &7B
 EOR #&80
 STA &7C
 RTS

.d_2748

 JSR DORND
 STA &35
 STA &0F82,Y
 LDA #&73
 ORA &99
 STA &34
 STA &0F5C,Y
 BNE d_276c

.d_275b

 JSR DORND
 STA &34
 STA &0F5C,Y
 LDA #&6E
 ORA &33
 STA &35
 STA &0F82,Y

.d_276c

 JSR DORND
 ORA #&08
 STA &88
 STA &0FA8,Y
 BNE d_2724

.d_2778

 STA &40

.n_store

 STA &41
 STA &42
 STA &43
 CLC
 RTS

.MULT3

 STA &82
 AND #&7F
 STA &42
 LDA &81
 AND #&7F
 BEQ d_2778
 SEC
 SBC #&01
 STA &D1
 LDA &1C
 LSR &42
 ROR A
 STA &41
 LDA &1B
 ROR A
 STA &40
 LDA #&00
 LDX #&18

.d_27a3

 BCC d_27a7
 ADC &D1

.d_27a7

 ROR A
 ROR &42
 ROR &41
 ROR &40
 DEX
 BNE d_27a3
 STA &D1
 LDA &82
 EOR &81
 AND #&80
 ORA &D1
 STA &43
 RTS

.MLS2

 LDX &24
 STX &82
 LDX &25
 STX &83

.MLS1

 LDX &31

 STX &1B

.MULTS

 TAX
 AND #&80
 STA &D1
 TXA
 AND #&7F
 BEQ d_2838
 TAX
 DEX
 STX &06
 LDA #&00
 LSR &1B
 BCC d_27e0
 ADC &06

.d_27e0

 ROR A
 ROR &1B
 BCC d_27e7
 ADC &06

.d_27e7

 ROR A
 ROR &1B
 BCC d_27ee
 ADC &06

.d_27ee

 ROR A
 ROR &1B
 BCC d_27f5
 ADC &06

.d_27f5

 ROR A
 ROR &1B
 BCC d_27fc
 ADC &06

.d_27fc

 ROR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 LSR A
 ROR &1B
 ORA &D1
 RTS

INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"

 JMP MULTU

.d_2838

 STA &1C
 STA &1B
 RTS

.d_286c

 BCC d_2870
 ADC &D1

.d_2870

 ROR A
 ROR &1B
 DEX
 BNE d_286c
 RTS

INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"


.d_28de

 LDY #&0A

.TAS4

 LDX &46,Y
 STX &81
 LDA &34
 JSR MULT12
 LDX &48,Y
 STX &81
 LDA &35
 JSR MAD
 STA &83
 STX &82
 LDX &4A,Y
 STX &81
 LDA &36
 JMP MAD

INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"

.d_2aec

 CPX #&10
 BEQ n_aliens
 CPX #&0D
 BCS d_2b04

.n_aliens

 LDY #&0C
 SEC
 LDA QQ20+&10

.d_2af9

 ADC QQ20,Y
 BCS n_cargo
 DEY
 BPL d_2af9
 CMP new_hold

.n_cargo

 RTS

.d_2b04

 LDA QQ20,X
 ADC #&00
 RTS

INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/common/main/subroutine/ghy.asm"
INCLUDE "library/common/main/subroutine/ee3.asm"
INCLUDE "library/common/main/subroutine/tt147.asm"

.hyp1_flight                 \ duplicate of hyp1

 JSR jmp
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

\ a.qcode_6

.EX2

 LDA &65
 ORA #&A0
 STA &65

.d_3468

 RTS

.DOEXP

 LDA &65
 AND #&40
 BEQ d_3479
 JSR d_34d3

.d_3479

 LDA &4C
 STA &D1
 LDA &4D
 CMP #&20
 BCC d_3487
 LDA #&FE
 BNE d_348f

.d_3487

 ASL &D1
 ROL A
 ASL &D1
 ROL A
 SEC
 ROL A

.d_348f

 STA &81
 LDY #&01
 LDA (&67),Y
 ADC #&04
 BCS EX2
 STA (&67),Y
 JSR DVID4
 LDA &1B
 CMP #&1C
 BCC d_34a8
 LDA #&FE
 BNE d_34b1

.d_34a8

 ASL &82
 ROL A
 ASL &82
 ROL A
 ASL &82
 ROL A

.d_34b1

 DEY
 STA (&67),Y
 LDA &65
 AND #&BF
 STA &65
 AND #&08
 BEQ d_3468
 LDY #&02
 LDA (&67),Y
 TAY

.d_34c3

 LDA &F9,Y
 STA (&67),Y
 DEY
 CPY #&06
 BNE d_34c3
 LDA &65
 ORA #&40
 STA &65

.d_34d3

 LDY #&00
 LDA (&67),Y
 STA &81
 INY
 LDA (&67),Y
 BPL d_34e0
 EOR #&FF

.d_34e0

 LSR A
 LSR A
 LSR A
 ORA #&01
 STA &80
 INY
 LDA (&67),Y
 STA &8F
 LDA &01
 PHA
 LDY #&06

.d_34f1

 LDX #&03

.d_34f3

 INY
 LDA (&67),Y
 STA &D2,X
 DEX
 BPL d_34f3
 STY &93
 LDY #&02

.d_34ff

 INY
 LDA (&67),Y
 EOR &93
 STA &FFFD,Y
 CPY #&06
 BNE d_34ff
 LDY &80

.d_350d

 JSR d_3f85
 STA &88
 LDA &D3
 STA &82
 LDA &D2
 JSR d_354b
 BNE d_3545
 CPX #&BF
 BCS d_3545
 STX &35
 LDA &D5
 STA &82
 LDA &D4
 JSR d_354b
 BNE d_3533
 LDA &35
 JSR PIXEL

.d_3533

 DEY
 BPL d_350d
 LDY &93
 CPY &8F
 BCC d_34f1
 PLA
 STA &01
 LDA &0906
 STA &03
 RTS

.d_3545

 JSR d_3f85
 JMP d_3533

.d_354b

 STA &83
 JSR d_3f85
 ROL A
 BCS d_355e
 JSR FMLTU
 ADC &82
 TAX
 LDA &83
 ADC #&00
 RTS

.d_355e

 JSR FMLTU
 STA &D1
 LDA &82
 SBC &D1
 TAX
 LDA &83
 SBC #&00
 RTS

.SOS1

 JSR msblob
 LDA #&7F
 STA &63
 STA &64
 LDA tek
 AND #&02
 ORA #&80
 JMP NWSHP

.SOLAR

 \	LDA FIST
 \	BEQ legal_over
 \legal_next
 \	DEC FIST
 \	LSR a
 \	BNE legal_next
 \legal_over
 \\	LSR FIST
 LDA QQ8
 LDY #3

.legal_div

 LSR QQ8+1
 ROR A
 DEY
 BNE legal_div
 SEC
 SBC FIST
 BCC legal_over
 LDA #&FF

.legal_over

 EOR #&FF
 STA FIST
 JSR ZINF
 LDA &6D
 AND #&03
 ADC #&03
 STA &4E
 ROR A
 STA &48
 STA &4B
 JSR SOS1
 LDA &6F
 AND #&07
 ORA #&81
 STA &4E
 LDA &71
 AND #&03
 STA &48
 STA &47
 LDA #&00
 STA &63
 STA &64
 LDA #&81
 JSR NWSHP

.NWSTARS

 LDA &87
 BNE WPSHPS2

.d_35b5

 LDY &03C3

.d_35b8

 JSR DORND
 ORA #&08
 STA &0FA8,Y
 STA &88
 JSR DORND
 STA &0F5C,Y
 STA &34
 JSR DORND
 STA &0F82,Y
 STA &35
 JSR PIXEL2
 DEY
 BNE d_35b8

.WPSHPS2

 JMP WPSHPS

.d_3619

 LDA #&95
 JSR tube_write
 TXA
 JMP tube_write

INCLUDE "library/common/main/subroutine/shd.asm"
INCLUDE "library/common/main/subroutine/dengy.asm"
INCLUDE "library/common/main/subroutine/sps2.asm"


.COMPAS

 JSR DOT
 LDY #&25
 LDA &0320
 BNE d_station
 LDY &9F	\ finder

.d_station

 JSR d_42ae
 LDA &34
 JSR SPS2
 TXA
 ADC #&C3
 STA &03A8
 LDA &35
 JSR SPS2
 STX &D1
 LDA #&CC
 SBC &D1
 STA &03A9
 LDA #&F0
 LDX &36
 BPL d_3691
 LDA #&FF

.d_3691

 STA &03C5

.DOT

 LDA &03A9
 STA &35
 LDA &03A8
 STA &34
 LDA &03C5
 STA &91
 CMP #&F0
 BNE d_36ac
 \d_36a7:
 JSR d_36ac
 DEC &35

.d_36ac

 LDA #&90
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &91
 JMP tube_write

.d_36e4

 SEC	\ reduce damage
 SBC new_shields
 BCC n_shok

.n_through

 STA &D1
 LDX #&00
 LDY #&08
 LDA (&20),Y
 BMI d_36fe
 LDA FSH
 SBC &D1
 BCC d_36f9
 STA FSH

.n_shok

 RTS

.d_36f9

 STX FSH
 BCC d_370c

.d_36fe

 LDA ASH
 SBC &D1
 BCC d_3709
 STA ASH
 RTS

.d_3709

 STX ASH

.d_370c

 ADC ENERGY
 STA ENERGY
 BEQ d_3716
 BCS d_3719

.d_3716

 JMP d_41c6

.d_3719

 JSR EXNO3
 JMP d_45ea

.d_371f

 LDA &0901,Y
 STA &D2,X
 LDA &0902,Y
 PHA
 AND #&7F
 STA &D3,X
 PLA
 AND #&80
 STA &D4,X
 INY
 INY
 INY
 INX
 INX
 INX
 RTS

.UNIV

 EQUW &0900, &0925, &094A, &096F, &0994, &09B9, &09DE, &0A03
 EQUW &0A28, &0A4D, &0A72, &0A97, &0ABC

INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"

.d_3813

 LDA #&20
 STA &30
 ASL A
 JSR NOISE

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

.PROJ

 LDA &46
 STA &1B
 LDA &47
 STA &1C
 LDA &48
 JSR d_3cfa
 BCS d_388d
 LDA &40
 ADC #&80
 STA &D2
 TXA
 ADC #&00
 STA &D3
 LDA &49
 STA &1B
 LDA &4A
 STA &1C
 LDA &4B
 EOR #&80
 JSR d_3cfa
 BCS d_388d
 LDA &40
 ADC #&60
 STA &E0
 TXA
 ADC #&00
 STA &E1
 CLC

.d_388d

 RTS

.d_388e

 LDA &8C
 LSR A
 BCS d_3896
 JMP WPLS2

.d_3896

 JMP WPLS

.d_3899

 LDA &4E
 BMI d_388e
 CMP #&30
 BCS d_388e
 ORA &4D
 BEQ d_388e
 JSR PROJ
 BCS d_388e
 LDA #&60
 STA &1C
 LDA #&00
 STA &1B
 JSR DVID3B2
 LDA &41
 BEQ d_38bd
 LDA #&F8
 STA &40

.d_38bd

 LDA &8C
 LSR A
 BCC d_38c5
 JMP SUN

.d_38c5

 JSR WPLS2
 JSR d_3b76
 BCS d_38d1
 LDA &41
 BEQ d_38d2

.d_38d1

 RTS

.d_38d2

 LDA &8C
 CMP #&80
 BNE d_3914
 LDA &40
 CMP #&06
 BCC d_38d1
 LDA &54
 EOR #&80
 STA &1B
 LDA &5A
 JSR d_3cdb
 LDX #&09
 JSR d_3969
 STA &9B
 STY &09
 JSR d_3969
 STA &9C
 STY &0A
 LDX #&0F
 JSR d_3ceb
 JSR d_3987
 LDA &54
 EOR #&80
 STA &1B
 LDA &60
 JSR d_3cdb
 LDX #&15
 JSR d_3ceb
 JMP d_3987

.d_3914

 LDA &5A
 BMI d_38d1
 LDX #&0F
 JSR d_3cba
 CLC
 ADC &D2
 STA &D2
 TYA
 ADC &D3
 STA &D3
 JSR d_3cba
 STA &1B
 LDA &E0
 SEC
 SBC &1B
 STA &E0
 STY &1B
 LDA &E1
 SBC &1B
 STA &E1
 LDX #&09
 JSR d_3969
 LSR A
 STA &9B
 STY &09
 JSR d_3969
 LSR A
 STA &9C
 STY &0A
 LDX #&15
 JSR d_3969
 LSR A
 STA &9D
 STY &0B
 JSR d_3969
 LSR A
 STA &9E
 STY &0C
 LDA #&40
 STA &8F
 LDA #&00
 STA &94
 BEQ d_398b

.d_3969

 LDA &46,X
 STA &1B
 LDA &47,X
 AND #&7F
 STA &1C
 LDA &47,X
 AND #&80
 JSR DVID3B2
 LDA &40
 LDY &41
 BEQ d_3982
 LDA #&FE

.d_3982

 LDY &43
 INX
 INX
 RTS

.d_3987

 LDA #&1F
 STA &8F

.d_398b

 LDX #&00
 STX &93
 DEX
 STX &92

.d_3992

 LDA &94
 AND #&1F
 TAX
 LDA SNE,X
 STA &81
 LDA &9D
 JSR FMLTU
 STA &82
 LDA &9E
 JSR FMLTU
 STA &40
 LDX &94
 CPX #&21
 LDA #&00
 ROR A
 STA &0E
 LDA &94
 CLC
 ADC #&10
 AND #&1F
 TAX
 LDA SNE,X
 STA &81
 LDA &9C
 JSR FMLTU
 STA &42
 LDA &9B
 JSR FMLTU
 STA &1B
 LDA &94
 ADC #&0F
 AND #&3F
 CMP #&21
 LDA #&00
 ROR A
 STA &0D
 LDA &0E
 EOR &0B
 STA &83
 LDA &0D
 EOR &09
 JSR ADD
 STA &D1
 BPL d_39fb
 TXA
 EOR #&FF
 CLC
 ADC #&01
 TAX
 LDA &D1
 EOR #&7F
 ADC #&00
 STA &D1

.d_39fb

 TXA
 ADC &D2
 STA &76
 LDA &D1
 ADC &D3
 STA &77
 LDA &40
 STA &82
 LDA &0E
 EOR &0C
 STA &83
 LDA &42
 STA &1B
 LDA &0D
 EOR &0A
 JSR ADD
 EOR #&80
 STA &D1
 BPL d_3a30
 TXA
 EOR #&FF
 CLC
 ADC #&01
 TAX
 LDA &D1
 EOR #&7F
 ADC #&00
 STA &D1

.d_3a30

 JSR BLINE
 CMP &8F
 BEQ d_3a39
 BCS d_3a45

.d_3a39

 LDA &94
 CLC
 ADC &95
 AND #&3F
 STA &94
 JMP d_3992

.d_3a45

 RTS

.d_3b76

 JSR CHKON
 BCS d_3a45
 LDA #&00
 STA &0EC0
 LDX &40
 LDA #&08
 CPX #&08
 BCC d_3b8e
 LSR A
 CPX #&3C
 BCC d_3b8e
 LSR A

.d_3b8e

 STA &95
 JMP CIRCLE2

.WPLS2

 LDY &0EC0
 BNE WP1

.d_3bf2

 CPY &6B
 BCS WP1
 LDA &0F0E,Y
 CMP #&FF
 BEQ d_3c17
 STA &37
 LDA &0EC0,Y
 STA &36
 JSR LOIN
 INY
 \	LDA &90
 \	BNE d_3bf2
 LDA &36
 STA &34
 LDA &37
 STA &35
 JMP d_3bf2

.d_3c17

 INY
 LDA &0EC0,Y
 STA &34
 LDA &0F0E,Y
 STA &35
 INY
 JMP d_3bf2

.WP1

 LDA #&01
 STA &6B
 LDA #&FF
 STA &0EC0

.d_3c2f

 RTS

.WPLS

 LDA &0E00
 BMI d_3c2f
 LDA &28
 STA &26
 LDA &29
 STA &27
 LDY #&BF

.d_3c3f

 LDA &0E00,Y
 BEQ d_3c47
 JSR HLOIN2

.d_3c47

 DEY
 BNE d_3c3f
 DEY
 STY &0E00
 RTS

.d_3cba

 JSR d_3969
 STA &1B
 LDA #&DE
 STA &81
 STX &80
 JSR MULTU
 LDX &80
 LDY &43
 BPL d_3cd8
 EOR #&FF
 CLC
 ADC #&01
 BEQ d_3cd8
 LDY #&FF
 RTS

.d_3cd8

 LDY #&00
 RTS

.d_3cdb

 STA &81
 JSR ARCTAN
 LDX &54
 BMI d_3ce6
 EOR #&80

.d_3ce6

 LSR A
 LSR A
 STA &94
 RTS

.d_3ceb

 JSR d_3969
 STA &9D
 STY &0B
 JSR d_3969
 STA &9E
 STY &0C
 RTS

.d_3cfa

 JSR DVID3B2
 LDA &43
 AND #&7F
 ORA &42
 BNE d_3cb8
 LDX &41
 CPX #&04
 BCS d_3d1e
 LDA &43
 BPL d_3d1e
 LDA &40
 EOR #&FF
 ADC #&01
 STA &40
 TXA
 EOR #&FF
 ADC #&00
 TAX
 CLC

.d_3d1e

 RTS

.d_3cb8

 SEC
 RTS

.d_3d74

 LDA &1B
 STA &03B0
 LDA &1C
 STA &03B1
 RTS

.d_3d7f

 LDX &84
 JSR d_3dd8
 LDX &84
 JMP d_1376

.d_3d89

 JSR ZINF
 JSR FLFLLS
 STA FRIN+&01
 STA &0320
 JSR SPBLB
 LDA #&06
 STA &4B
 LDA #&81
 JMP NWSHP

.d_3da1

 LDX #&FF

.d_3da3

 INX
 LDA FRIN,X
 BEQ d_3d74
 CMP #&01
 BNE d_3da3
 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+&01,Y
 STA SC+&01
 LDY #&20
 LDA (SC),Y
 BPL d_3da3
 AND #&7F
 LSR A
 CMP &96
 BCC d_3da3
 BEQ d_3dd2
 SBC #&01
 ASL A
 ORA #&80
 STA (SC),Y
 BNE d_3da3

.d_3dd2

 LDA #&00
 STA (SC),Y
 BEQ d_3da3

.d_3dd8

 STX &96
 CPX &45
 BNE d_3de8
 LDY #&EE
 JSR ABORT
 LDA #&C8
 JSR MESS

.d_3de8

 LDY &96
 LDX FRIN,Y
 CPX #&02
 BEQ d_3d89
 CPX #&1F
 BNE d_3dfd
 LDA TP
 ORA #&02
 STA TP

.d_3dfd

 CPX #&03
 BCC d_3e08
 CPX #&0B
 BCS d_3e08
 DEC &033E

.d_3e08

 DEC &031E,X
 LDX &96
 LDY #&05
 LDA (&1E),Y
 LDY #&21
 CLC
 ADC (&20),Y
 STA &1B
 INY
 LDA (&20),Y
 ADC #&00
 STA &1C

.d_3e1f

 INX
 LDA FRIN,X
 STA &0310,X
 BNE d_3e2b
 JMP d_3da1

.d_3e2b

 ASL A
 TAY
 LDA XX21-2,Y
 STA SC
 LDA XX21-1,Y
 STA SC+&01
 LDY #&05
 LDA (SC),Y
 STA &D1
 LDA &1B
 SEC
 SBC &D1
 STA &1B
 LDA &1C
 SBC #&00
 STA &1C
 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+&01,Y
 STA SC+&01
 LDY #&24
 LDA (SC),Y
 STA (&20),Y
 DEY
 LDA (SC),Y
 STA (&20),Y
 DEY
 LDA (SC),Y
 STA &41
 LDA &1C
 STA (&20),Y
 DEY
 LDA (SC),Y
 STA &40
 LDA &1B
 STA (&20),Y
 DEY

.d_3e75

 LDA (SC),Y
 STA (&20),Y
 DEY
 BPL d_3e75
 LDA SC
 STA &20
 LDA SC+&01
 STA &21
 LDY &D1

.d_3e86

 DEY
 LDA (&40),Y
 STA (&1B),Y
 TYA
 BNE d_3e86
 BEQ d_3e1f

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

.d_3eb8

 LDX GCNT
 DEX
 BNE d_3ecc
 LDA QQ0
 CMP #&90
 BNE d_3ecc
 LDA QQ1
 CMP #&21
 BEQ d_3ecd

.d_3ecc

 CLC

.d_3ecd

 RTS

.Ze

 JSR rand_posn	\ IN
 CMP #&F5
 ROL A
 ORA #&C0
 STA &66

.d_3f85

 CLC
 JMP DORND

.d_3f9a

 JSR DORND
 LSR A
 STA &66
 STA &63
 ROL &65
 AND #&0F
 STA &61
 JSR DORND
 BMI d_3fb9
 LDA &66
 ORA #&C0
 STA &66
 LDX #&10
 STX &6A

.d_3fb9

 LDA #&0B
 LDX #&03
 JMP hordes

.d_3fc0

 JSR d_1228
 DEC &034A
 BEQ d_3f54
 BPL d_3fcd
 INC &034A

.d_3fcd

 DEC &8A
 BEQ d_3fd4

.d_3fd1

 JMP d_40db

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
 CMP #&33	\ trader fraction
 BCS d_402e
 LDA &033E
 CMP #&03
 BCS d_402e
 JSR rand_posn	\ IN
 BVS d_3f9a
 ORA #&6F
 STA &63
 LDA &0320
 BNE d_4033
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

.d_402e

 LDA &0320
 BEQ d_4036

.d_4033

 JMP d_40db

.d_4036

 JSR BAD
 ASL A
 LDX &032E
 BEQ d_4042
 ORA FIST

.d_4042

 STA &D1
 JSR Ze
 CMP &D1
 BCS d_4050
 LDA #&10

.horde_plain

 LDX #&00
 BEQ hordes

.d_4050

 LDA &032E
 BNE d_4033
 DEC &0349
 BPL d_4033
 INC &0349
 LDA TP
 AND #&0C
 CMP #&08
 BNE d_4070
 JSR DORND
 CMP #&C8
 BCC d_4070
 JSR GTHG

.d_4070

 JSR DORND
 LDY gov
 BEQ d_4083
 CMP #&78
 BCS d_4033
 AND #&07
 CMP gov
 BCC d_4033

.d_4083

 CPX #&64
 BCS d_40b2
 INC &0349
 AND #&03
 ADC #&19
 TAY
 JSR d_3eb8
 BCC d_40a8
 LDA #&F9
 STA &66
 LDA TP
 AND #&03
 LSR A
 BCC d_40a8
 ORA &033D
 BEQ d_40aa

.d_40a8

 TYA
 EQUB &2C

.d_40aa

 LDA #&1F
 JSR NWSHP
 JMP d_40db

.d_40b2

 LDA #&11
 LDX #&07

.hordes

 STA horde_base+1
 STX horde_mask+1
 JSR DORND
 CMP #&F8
 BCS horde_large
 STA &89
 TXA
 AND &89
 AND #&03

.horde_large

 AND #&07
 STA &0349
 STA &89

.d_40b9

 JSR DORND
 STA &D1
 TXA
 AND &D1

.horde_mask

 AND #&FF
 STA &0FD2

.d_40c8

 LDA &0FD2
 CLC

.horde_base

 ADC #&00
 INC &61	\ space out horde
 INC &47
 INC &4A
 JSR NWSHP
 CMP #&18
 BCS d_40d7
 DEC &0FD2
 BPL d_40c8

.d_40d7

 DEC &89
 BPL d_40b9

.d_40db

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
 \	AND PATG
 \	LSR A
 \	BCS d_40f8
 LDY #&02
 JSR DELAY
 \	JSR WSCAN

.d_40f8

 JSR d_44af
 JSR chk_dirn

.d_40fb

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

.d_41b2

 LDA #&E0

.d_41b4

 CMP &47
 BCC d_41be
 CMP &4A
 BCC d_41be
 CMP &4D

.d_41be

 RTS

.d_41bf

 ORA &47
 ORA &4A
 ORA &4D
 RTS

.d_41c6

 JSR EXNO3
 JSR RES2
 ASL &7D
 ASL &7D
 LDX #&18
 JSR d_3619
 JSR TT66
 JSR d_54eb
 JSR d_35b5
 LDA #&0C
 STA YC
 STA XC
 LDA #&92
 JSR ex

.d_41e9

 JSR Ze
 LSR A
 LSR A
 STA &46
 LDY #&00
 STY &87
 STY &47
 STY &4A
 STY &4D
 STY &66
 DEY
 STY &8A
 \	STY &0346
 EOR #&2A
 STA &49
 ORA #&50
 STA &4C
 TYA
 JSR write_0346
 TXA
 AND #&8F
 STA &63
 ROR A
 AND #&87
 STA &64
 LDX #&05
 \LDA &5607
 \BEQ d_421e
 BCC d_421e
 DEX

.d_421e

 JSR d_251d
 JSR DORND
 AND #&80
 LDY #&1F
 STA (&20),Y
 LDA FRIN+&04
 BEQ d_41e9
 JSR U%
 STA &7D

.d_4234

 JSR d_1228
 JSR read_0346
 BNE d_4234
 LDX #&1F
 JSR d_3619
 JMP d_1220

.RSHIPS

 JSR LSHIPS
 JSR RESET
 LDA #&FF
 STA &8E
 STA &87
 STA dockedp
 LDA #&20
 JMP d_40fb

.LSHIPS

 LDA #0
 STA &9F	\ reset finder

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
 CMP #ship_total	\ # POSSIBLE SHIPS
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
 INX	\24-28

.mix_byte3

 INX	\16-23

.mix_byte2

 INX	\8-15
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
 CPX #52		\ ANACONDA?
 BEQ mix_anaconda
 CPX #116	\ DRAGON?
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

.d_42ae

 LDX #&00
 JSR d_371f
 JSR d_371f
 JSR d_371f

.d_42bd

 LDA &D2
 ORA &D5
 ORA &D8
 ORA #&01
 STA &DB
 LDA &D3
 ORA &D6
 ORA &D9

.d_42cd

 ASL &DB
 ROL A
 BCS d_42e0
 ASL &D2
 ROL &D3
 ASL &D5
 ROL &D6
 ASL &D8
 ROL &D9
 BCC d_42cd

.d_42e0

 LDA &D3
 LSR A
 ORA &D4
 STA &34
 LDA &D6
 LSR A
 ORA &D7
 STA &35
 LDA &D9
 LSR A
 ORA &DA
 STA &36
 JMP NORM

.d_434e

 LDX &033E
 LDA FRIN+&02,X
 ORA &033E	\ no jump if any ship
 ORA &0320
 ORA &0341
 BNE d_439f
 LDY &0908
 BMI d_4368
 TAY
 JSR MAS2
 LSR A
 BEQ d_439f

.d_4368

 LDY &092D
 BMI d_4375
 LDY #&25
 JSR m
 LSR A
 BEQ d_439f

.d_4375

 LDA #&81
 STA &83
 STA &82
 STA &1B
 LDA &0908
 JSR ADD
 STA &0908
 LDA &092D
 JSR ADD
 STA &092D
 LDA #&01
 STA &87
 STA &8A
 LSR A
 STA &0349
 LDX VIEW
 JMP LOOK1

.d_439f

 LDA #&28
 JMP NOISE

INCLUDE "library/common/main/subroutine/exno3.asm"


.d_43be

 LDX #&01
 JSR d_2590
 BCC d_4418
 LDA #&78
 JSR MESS

.n_sound30

 LDA #&30
 JMP NOISE

.d_4418

 RTS

INCLUDE "library/common/main/subroutine/exno2.asm"
INCLUDE "library/common/main/subroutine/exno.asm"

.d_4429

 LDA #&96
 JSR tube_write
 TYA
 JSR tube_write
 LDA b_flag
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
 JSR d_4429
 INY
 JSR d_4429
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

 JSR d_4429
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
 LDA &7D	\ ? Too Fast
 STA &61
 JSR d_2346
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
 JMP d_1220

.d_4586

 \	CPX #&37
 \	BNE dont_dump
 \	JSR printer
 \dont_dump
 CPX #&59
 BNE d_455f

.d_459c

 LDA &87
 BNE d_45b4
 LDY #&10

.d_45a4

 JSR d_4429
 DEY
 CPY #&07
 BNE d_45a4

.d_45b4

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
 BCC d_45b4
 LDA #&FD
 JMP TT27

.d_45ea

 JSR DORND
 BMI d_45b4
 \	CPX #&17
 CPX #&18
 BCS d_45b4
 \	LDA QQ20,X
 LDA CRGO,X
 BEQ d_45b4
 LDA &034A
 BNE d_45b4
 LDY #&03
 STY &034B
 \	STA QQ20,X
 STA CRGO,X
 DEX
 BMI d_45c1
 CPX #&11
 BEQ d_45c1
 TXA
 BCC cargo_mtok

.d_460e

 CMP #&12
 BNE equip_mtok	\BEQ l_45c4
 \l_45c4
 LDA #&6F-&6B-1
 \	EQUB &2C

.d_45c1

 \	LDA #&6C
 ADC #&6B-&5D
 \	EQUB &2C

.equip_mtok

 ADC #&5D
 INC new_hold	\**
 BNE MESS

.d_4889

 JMP d_3899

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

 EQUB &00, &00, &0F	\, &FF, &F0 overlap

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
 LDX CRGO	\ iff code
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
 INX	\ X=4

.iff_missle

 INX	\ X=3

.iff_aster

 INX	\ X=2

.iff_cop

 INX	\ X=1

.iff_trade

 INX	\ X=0

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

 EQUW	s_dodo,	s_coriolis,	s_escape,	s_alloys
 EQUW	s_barrel,	s_boulder,	s_asteroid,	s_minerals
 EQUW	s_shuttle1,	s_transporter,	s_cobra3,	s_python
 EQUW	s_boa,	s_anaconda,	s_worm,	s_missile
 EQUW	s_viper,	s_sidewinder,	s_mamba,	s_krait
 EQUW	s_adder,	s_gecko,	s_cobra1,	s_asp
 EQUW	s_ferdelance,	s_moray,	s_thargoid,	s_thargon
 EQUW	s_constrictor,	s_dragon,	s_monitor,	s_ophidian
 EQUW	s_ghavial,	s_bushmaster,	s_rattler,	s_iguana
 EQUW	s_shuttle2,	s_chameleon

 EQUW &0000


.ship_data

 EQUW	0

.XX21

 EQUW	s_missile,	0,	s_escape
 EQUW	s_alloys,	s_barrel,	s_boulder,	s_asteroid
 EQUW	s_minerals,	0,	s_transporter,	0
 EQUW	0,	0,	0,	0
 EQUW	s_viper,	0,	0,	0
 EQUW 0,	0,	0,	0
 EQUW	0,	0,	0,	0
 EQUW	0,	s_thargoid,	s_thargon,	s_constrictor
 	

.ship_flags

 EQUB	&00

.E%
 EQUB	&00,	&40,	&41
 EQUB	&00,	&00,	&00,	&00
 EQUB	&00,	&21,	&61,	&20
 EQUB	&21,	&20,	&A1,	&0C
 EQUB	&C2,	&0C,	&0C,	&04
 EQUB	&0C,	&04,	&0C,	&04
 EQUB	&0C,	&02,	&22,	&02
 EQUB	&22,	&0C,	&04,	&8C


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