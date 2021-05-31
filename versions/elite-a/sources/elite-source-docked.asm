\ ******************************************************************************
\
\ ELITE-A DOCKED SOURCE
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
\   * output/1.D.bin
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
_ELITE_A_DOCKED         = TRUE
_ELITE_A_FLIGHT         = FALSE
_ELITE_A_ENCYCLOPEDIA   = FALSE
_ELITE_A_6502SP_IO      = FALSE
_ELITE_A_6502SP_PARA    = FALSE
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

QQ18 = &0400            \ The address of the text token table, as set in
                        \ elite-loader3.asm

SNE = &07C0             \ The address of the sine lookup table, as set in
                        \ elite-loader3.asm

ACT = &07E0             \ The address of the arctan lookup table, as set in
                        \ elite-loader3.asm

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

NA% = &1181             \ The address of the data block for the last saved
                        \ commander, as set in elite-loader3.asm

CHK2 = &11D3            \ The address of the second checksum byte for the saved
                        \ commander data file, as set in elite-loader3.asm

CHK = &11D4             \ The address of the first checksum byte for the saved
                        \ commander data file, as set in elite-loader3.asm

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

CODE% = &11E3
LOAD% = &11E3

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "versions/elite-a/sources/a.global.asm"

INCLUDE "library/disc/docked/workspace/s_per_cent.asm"

.INBAY

 JSR BRKBK
 JMP icode_set
 EQUB 0
 \ dead entry
 LDA #0
 JSR scramble
 JSR RES2
 JMP TT170

INCLUDE "library/disc/docked/subroutine/dobegin.asm"
INCLUDE "library/enhanced/main/subroutine/doentry.asm"

.scramble

 STA save_lock

INCLUDE "library/enhanced/main/subroutine/brkbk.asm"
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
INCLUDE "library/common/main/variable/univ.asm"

\ ******************************************************************************
\
\ Save output/ELTA.bin
\
\ ******************************************************************************

PRINT "ELITE A"
PRINT "Assembled at ", ~CODE%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_A%

PRINT "S.ELTA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
\SAVE "versions/elite-a/output/T.ELTA.bin", CODE%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ ******************************************************************************

CODE_B% = P%
LOAD_B% = LOAD% + P% - CODE%

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
INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/original/main/subroutine/px3.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
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
INCLUDE "library/common/main/subroutine/dil2.asm"
INCLUDE "library/enhanced/main/subroutine/hme2.asm"

\ ******************************************************************************
\
\ Save output/ELTB.bin
\
\ ******************************************************************************

PRINT "ELITE B"
PRINT "Assembled at ", ~CODE_B%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_B%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_B%

PRINT "S.ELTB ", ~CODE_B%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_B%
\SAVE "elite-a/T.ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/enhanced/main/subroutine/hanger.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"
INCLUDE "library/enhanced/main/subroutine/unwise.asm"
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
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/original/main/subroutine/lyn.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"

\ ******************************************************************************
\
\ Save output/ELTC.bin
\
\ ******************************************************************************

PRINT "ELITE C"
PRINT "Assembled at ", ~CODE_C%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_C%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_C%

PRINT "S.ELTC ", ~CODE_C%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_C%
\SAVE "versions/elite-a/output/T.ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

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

.encyclopedia

 LDA #'E'
 STA RDLI+4

INCLUDE "library/common/main/subroutine/tt110.asm"
INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"
INCLUDE "library/enhanced/main/variable/rdli.asm"
INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
INCLUDE "library/common/main/subroutine/hm.asm"

\ ******************************************************************************
\
\ Save output/ELTD.bin
\
\ ******************************************************************************

PRINT "ELITE D"
PRINT "Assembled at ", ~CODE_D%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_D%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_D%

PRINT "S.ELTD ", ~CODE_D%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_D%
\SAVE "versions/elite-a/output/T.ELTD.bin", CODE_D%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE E FILE
\
\ ******************************************************************************

CODE_E% = P%
LOAD_E% = LOAD% + P% - CODE%

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
INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"
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

\ ******************************************************************************
\
\ Save output/ELTE.bin
\
\ ******************************************************************************

PRINT "ELITE E"
PRINT "Assembled at ", ~CODE_E%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_E%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_E%

PRINT "S.ELTE ", ~CODE_E%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_E%
\SAVE "versions/elite-a/output/T.ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ ******************************************************************************

CODE_F% = P%
LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/sfx.asm"
INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"

.TT100

 DEC &034A
 BEQ me2
 BPL me3
 INC &034A

.me3

 DEC &8A

INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"
INCLUDE "library/enhanced/main/subroutine/brbr.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/enhanced/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
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
INCLUDE "library/common/main/subroutine/rdkey.asm"
INCLUDE "library/common/main/subroutine/ecmof.asm"
INCLUDE "library/common/main/subroutine/beep.asm"
INCLUDE "library/common/main/subroutine/noise.asm"
INCLUDE "library/common/main/subroutine/no3.asm"
INCLUDE "library/common/main/subroutine/nos1.asm"
INCLUDE "library/common/main/subroutine/ctrl.asm"
INCLUDE "library/common/main/subroutine/dks4.asm"
INCLUDE "library/common/main/subroutine/dks2.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"
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
\ Save output/ELTF.bin
\
\ ******************************************************************************

PRINT "ELITE F"
PRINT "Assembled at ", ~CODE_F%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_F%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_F%

PRINT "S.ELTF ", ~CODE_F%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_F%
\SAVE "versions/elite-a/output/T.ELTF.bin", CODE_F%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE G FILE
\
\ ******************************************************************************

CODE_G% = P%
LOAD_G% = LOAD% + P% - CODE%

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
\ Save output/ELTG.bin
\
\ ******************************************************************************

PRINT "ELITE G"
PRINT "Assembled at ", ~CODE_G%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_G%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_G%

PRINT "S.ELTG ", ~CODE_G%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_G%
\SAVE "versions/elite-a/output/T.ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ ******************************************************************************

CODE_H% = P%
LOAD_H% = LOAD% + P% - CODE%

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
 \	LDA #&80
 \	STA QQ17
 JSR vdu_80
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
 LDX #&00
 STX &96

.d_31d8

 LDA QQ23+&01,X
 STA &74
 JSR var
 LDA QQ23+&03,X
 AND QQ26
 CLC
 ADC QQ23+&02,X
 LDY &74
 BMI d_31f4
 SEC
 SBC &76
 JMP d_31f7

.d_31f4

 CLC
 ADC &76

.d_31f7

 BPL d_31fb
 LDA #&00

.d_31fb

 LDY &96
 AND #&3F
 STA AVL,Y
 INY
 TYA
 STA &96
 ASL A
 ASL A
 TAX
 CMP #&3F
 BCC d_31d8

.stay_quit

 JMP BAY


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

\ ******************************************************************************
\
\ Save output/ELTH.bin
\
\ ******************************************************************************

PRINT "ELITE H"
PRINT "Assembled at ", ~CODE_H%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_H%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_H%

PRINT "S.ELTH ", ~CODE_H%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_H%
\SAVE "versions/elite-a/output/T.ELTH.bin", CODE_H%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE I FILE
\
\ ******************************************************************************

CODE_I% = P%
LOAD_I% = LOAD% + P% - CODE%

INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"

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

IF _RELEASED
 INCBIN "versions/elite-a/extracted/released/workspaces/1.D.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/elite-a/extracted/source-disc/workspaces/1.D.bin"
ENDIF

\ ******************************************************************************
\
\ Save output/ELTI.bin
\
\ ******************************************************************************

PRINT "ELITE I"
PRINT "Assembled at ", ~CODE_I%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_I%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_I%

PRINT "S.ELTI ", ~CODE_I%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_I%
\SAVE "versions/elite-a/output/T.ELTI.bin", CODE_I%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE SHIP HANGER BLUEPRINTS FILE
\
\ ******************************************************************************

ORG &5600

CODE_SHIPS% = P%
LOAD_SHIPS% = LOAD% + P% - CODE%

.XX21

IF _RELEASED
 INCBIN "versions/elite-a/extracted/released/S.T.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/elite-a/extracted/source-disc/S.T.bin"
ENDIF

\ ******************************************************************************
\
\ Save output/1.D.bin
\
\ ******************************************************************************

PRINT "S.1.D ", ~CODE%, " &6000 ", ~LOAD%, " ", ~LOAD%
SAVE "versions/elite-a/output/1.D.bin", CODE%, &6000
