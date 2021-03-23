\ ******************************************************************************
\
\ BBC MASTER ELITE GAME SOURCE
\
\ BBC Master Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1986
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
\   * output/BCODE.bin
\
\ ******************************************************************************

INCLUDE "versions/master/sources/elite-header.h.asm"

CPU 1                   \ Switch to 65SC12 assembly, as this code runs on a
                        \ BBC Master

_CASSETTE_VERSION = (_VERSION = 1)
_DISC_VERSION = (_VERSION = 2)
_6502SP_VERSION = (_VERSION = 3)
_MASTER_VERSION = (_VERSION = 4)
_DISC_DOCKED = FALSE
_DISC_FLIGHT = FALSE

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

BRKV = &202             \ The break vector that we intercept to enable us to
                        \ handle and display system errors

NOST = 20               \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 34                \ The number of different ship types

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
COU = 32                \ Ship type for a Cougar
DOD = 33                \ Ship type for a Dodecahedron ("Dodo") space station

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

OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

WRCHV = &20E            \ The WRCHV vector that we intercept to implement our
                        \ own custom OSWRCH commands for communicating over the
                        \ Tube

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &80                \ Internal key number for red key f0 (Launch, Front)
f1 = &81                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &82                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &83                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &84                \ Internal key number for red key f4 (Long-range Chart)
f5 = &85                \ Internal key number for red key f5 (Short-range Chart)
f6 = &86                \ Internal key number for red key f6 (Data on System)
f7 = &87                \ Internal key number for red key f7 (Market Price)
f8 = &88                \ Internal key number for red key f8 (Status Mode)
f9 = &89                \ Internal key number for red key f9 (Inventory)

YELLOW  = %00001111     \ Four mode 1 pixels of colour 1 (yellow)
RED     = %11110000     \ Four mode 1 pixels of colour 2 (red, magenta or white)
CYAN    = %11111111     \ Four mode 1 pixels of colour 3 (cyan or white)
GREEN   = %10101111     \ Four mode 1 pixels of colour 3, 1, 3, 1 (cyan/yellow)
WHITE   = %11111010     \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)
MAGENTA = RED           \ Four mode 1 pixels of colour 2 (red, magenta or white)
DUST    = WHITE         \ Four mode 1 pixels of colour 3, 2, 3, 2 (cyan/red)

RED2    = %00000011     \ Two mode 2 pixels of colour 1    (red)
GREEN2  = %00001100     \ Two mode 2 pixels of colour 2    (green)
YELLOW2 = %00001111     \ Two mode 2 pixels of colour 3    (yellow)
BLUE2   = %00110000     \ Two mode 2 pixels of colour 4    (blue)
MAG2    = %00110011     \ Two mode 2 pixels of colour 5    (magenta)
CYAN2   = %00111100     \ Two mode 2 pixels of colour 6    (cyan)
WHITE2  = %00111111     \ Two mode 2 pixels of colour 7    (white)
STRIPE  = %00100011     \ Two mode 2 pixels of colour 5, 1 (magenta/red)

NRU% = 0                \ The number of planetary systems with extended system
                        \ description overrides in the RUTOK table. The value of
                        \ this variable is 0 in the original source, but this
                        \ appears to be a bug, as it should really be 26

VE = &57                \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

LL = 30                 \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

\ New vars: L0098, L0099, L009B, L00FC
\ KL vars: L00C9, L00CB, L00D0, L00D1
\ Save block? L0791
\ L1229: distance for ship in TITLE?
\ L1264 - L1266
\ L12A6 - L12A9 (see IRQ1)

ZP = &0000
RAND = &0002
T1 = &0006
SC = &000A
SCH = &000B
P = &000C
XC = &0010
COL = &0011
YC = &0012
QQ17 = &0013
K3 = &0014
XX2 = &0014
K4 = &0022
XX16 = &0024
XX0 = &0036
INF = &0038
V = &003A
XX = &003C
YY = &003E
SUNX = &0040
BETA = &0042
BET1 = &0043
QQ22 = &0044
ECMA = &0046
ALP1 = &0047
ALP2 = &0048
XX15 = &004A
X1 = &004A
Y1 = &004B
X2 = &004C
Y2 = &004D
XX12 = &0050
K = &0056
LAS = &005A
MSTG = &005B
DL = &005C
LSP = &005D
QQ15 = &005E
XX18 = &0064
K5 = &0064
K6 = &0068
QQ19 = &006D
BET2 = &0073
DELTA   = &0075
DELT4   = &0076
U = &0078
Q = &0079
R = &007A
S = &007B
T = &007C
XSAV = &007D
YSAV = &007E
XX17 = &007F
W  = &0080
QQ11 = &0081
ZZ = &0082
XX13 = &0083
MCNT = &0084
TYPE = &0085
ALPHA   = &0086
QQ12 = &0087
TGT = &0088
FLAG = &0089
CNT = &008A
CNT2 = &008B
STP = &008C
XX4 = &008D
XX20 = &008E
XX14 = &008F
RAT = &0091
RAT2 = &0092
K2 = &0093
widget  = &0097
L0098   = &0098
L0099   = &0099
messXC  = &009A
L009B   = &009B
INWK = &009C
XX1 = &009C
XX19 = &00BD
NEWB = &00C0
JSTX = &00C1
JSTY = &00C2
KL = &00C3
KY17 = &00C4
KY14 = &00C5
KY15 = &00C6
KY20 = &00C7
KY7 = &00C8
L00C9   = &00C9
KY18 = &00CA
L00CB   = &00CB
KY19 = &00CC
KY12 = &00CD
KY2 = &00CE
KY16 = &00CF
L00D0   = &00D0
L00D1   = &00D1
KY1 = &00D2
KY13 = &00D3
LSX = &00D4
FSH = &00D5
ASH = &00D6
ENERGY  = &00D7
QQ3 = &00D8
QQ4 = &00D9
QQ5 = &00DA
QQ6 = &00DB
QQ7 = &00DD
QQ8 = &00DF
QQ9 = &00E1
QQ10 = &00E2
NOSTM   = &00E3
L00FC   = &00FC
XX3 = &0100
K% = &0400
L0401   = &0401
L0402   = &0402
L0404   = &0404
L0405   = &0405
L0406   = &0406
L0407   = &0407
L0408   = &0408
L0425   = &0425
L0427   = &0427
L0429   = &0429
L042D   = &042D
L042F   = &042F
L0431   = &0431
L0433   = &0433
L0449   = &0449
L06A9   = &06A9
L0791   = &0791

WP = &0801

FRIN = &0E41
MANY = &0E4E
SSPR = &0E50
L0E58   = &0E58
L0E5E   = &0E5E
L0E6B   = &0E6B
L0E6D   = &0E6D
JUNK = &0E70
auto = &0E71
ECMP = &0E72
MJ = &0E73
CABTMP  = &0E74
LAS2 = &0E75
MSAR = &0E76
VIEW = &0E77
LASCT   = &0E78
GNTMP   = &0E79
HFX = &0E7A
EV = &0E7B
DLY = &0E7C
de = &0E7D
LSX2 = &0E7E
LSY2 = &0F7E
LSO = &107E
BUF = &1146
SX = &11A0
SXL = &11B5
SY = &11CA
SYL = &11DF
L11ED   = &11ED
SZ = &11F4
SZL = &1209
LASX = &121E
LASY = &121F
ALTIT   = &1221
SWAP = &1222
L1229   = &1229
NAME = &122C
TP = &1234
QQ0 = &1235
QQ1 = &1236
QQ21 = &1237
CASH = &123D
QQ14 = &1241
COK = &1242
GCNT = &1243
LASER   = &1244
CRGO = &124A
QQ20 = &124B
ECM = &125C
BST = &125D
BOMB = &125E
ENGY = &125F
DKCMP   = &1260
GHYP = &1261
ESCP = &1262
L1264   = &1264
L1265   = &1265
L1266   = &1266
NOMSL   = &1267
FIST = &1268
AVL = &1269
QQ26 = &127A
TALLY   = &127B
SVC = &127D
MCH = &1281
COMX = &1282
COMY = &1283
QQ24 = &1292
QQ25 = &1293
QQ28 = &1294
QQ29 = &1295
gov = &1296
tek = &1297
SLSP = &1298
QQ2 = &129A
safehouse = &12A0
L12A6   = &12A6
L12A7   = &12A7
L12A8   = &12A8
L12A9   = &12A9
XX21 = &8000
L8002   = &8002
L8003   = &8003
L8007   = &8007
L8040   = &8040
L8041   = &8041
E% = &8042
L8062   = &8062
TALLYFRAC = &8063
L8083   = &8083
TALLYINT = &8084
QQ18 = &A000
SNE = &A3C0
ACT = &A3E0
TKN1 = &A400
RUPLA   = &AF48
RUGAL   = &AF62
RUTOK   = &AF7C

NT% = SVC + 2 - TP

\ ******************************************************************************
\
\ ELITE A FILE
\
\ ******************************************************************************

CODE% = &1300
LOAD% = &1300

ORG CODE%

LOAD_A% = LOAD%

INCLUDE "library/6502sp/io/variable/tvt3.asm"
INCLUDE "library/common/main/variable/vec.asm"
INCLUDE "library/common/main/subroutine/wscan.asm"
INCLUDE "library/common/main/subroutine/delay.asm"

.BEEP_LONG_LOW

 LDY #&00
 BRA NOISE

INCLUDE "library/common/main/subroutine/beep.asm"

.L1358

 EQUB &C0

 EQUB &A0,&80

.L135B

 EQUB &FF,&BF,&9F,&DF,&EF

.MASTER_DKSn

 LDX #&FF
 STX VIA+&43
 STA VIA+&4F
 LDA #&00
 STA VIA+&40
 PHA
 PLA
 PHA
 PLA
 LDA #&08
 STA VIA+&40

.L1376

 RTS

.L1377

 LDY #&03
 LDA #&00

.L137B

 STA L144C,Y
 DEY
 BNE L137B

 SEI

.L1382

 LDA L135B,Y
 JSR MASTER_DKSn

 INY
 CPY #&05
 BNE L1382

 CLI
 RTS

.BEING_HIT_NOISE

 LDY #&09
 JSR NOISE

 LDY #&05
 BRA NOISE

.LASER_NOISE

 LDY #&03
 JSR NOISE

 LDY #&05

.NOISE

 LDA L2C55
 BNE L1376

 LDA L146E,Y
 LSR A
 CLV
 LDX #&00
 BCS L13B7

 INX
 LDA L145A
 CMP L145B
 BCC L13B7

 INX

.L13B7

 LDA L1462,Y
 CMP L1459,X
 BCC L1376

 SEI
 STA L1459,X
 LSR A
 AND #&07
 STA L1453,X
 LDA L1486,Y
 STA L1456,X
 LDA L146E,Y
 STA L1450,X
 AND #&0F
 LSR A
 STA L145C,X
 LDA L147A,Y
 BVC L13E1

 ASL A

.L13E1

 STA L145F,X
 LDA #&80
 STA L144D,X
 CLI
 SEC
 RTS

.L13EC

 LDY #&02

.L13EE

 LDA L144D,Y
 BEQ L1449

 BMI L13FB

 LDA L145C,Y
 BEQ L1416

 EQUB &2C

.L13FB

 LDA #&00
 CLC
 CLD
 ADC L145F,Y
 STA L145F,Y
 PHA
 ASL A
 ASL A
 AND #&0F
 ORA L1358,Y
 JSR MASTER_DKSn

 PLA
 LSR A
 LSR A
 JSR MASTER_DKSn

.L1416

 TYA
 TAX
 LDA L144D,Y
 BMI L1439

 DEC L1450,X
 BEQ L142F

 LDA L1450,X
 AND L1456,X
 BNE L1449

 DEC L1453,X
 BNE L143C

.L142F

 LDA #&00
 STA L144D,Y
 STA L1459,Y
 BEQ L1443

.L1439

 LSR L144D,X

.L143C

 LDA L1453,Y
 CLC
 ADC L2C61

.L1443

 EOR L135B,Y
 JSR MASTER_DKSn

.L1449

 DEY
 BPL L13EE

.L144C

 RTS

.L144D

 EQUB &00

 EQUB &00,&00

.L1450

 EQUB &00,&00,&00

.L1453

 EQUB &00,&00,&00

.L1456

 EQUB &00,&00,&00

.L1459

 EQUB &00

.L145A

 EQUB &00

.L145B

 EQUB &00

.L145C

 EQUB &00,&00,&00

.L145F

 EQUB &00,&00,&00

.L1462

 EQUB &4B,&5B,&3F,&EB,&FF,&09,&FF,&8B
 EQUB &CF,&E7,&FF,&EF

.L146E

 EQUB &40,&10,&01,&FC,&F3,&19,&F9,&7C
 EQUB &F1,&FA,&FE,&FE

.L147A

 EQUB &F0,&20,&10,&30,&03,&01,&08,&80
 EQUB &16,&38,&00,&80

.L1486

 EQUB &FF,&FF,&00,&03,&1F,&01,&07,&07
 EQUB &0F,&03,&0F,&0F

INCLUDE "library/6502sp/io/subroutine/startup.asm"
INCLUDE "library/6502sp/io/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"

\ ******************************************************************************
\
\       Name: VSCAN
\       Type: Variable
\   Category: Screen mode
\    Summary: Defines the split position in the split-screen mode
\
\ ******************************************************************************

.VSCAN

 EQUB 57

\ ******************************************************************************
\
\       Name: DLCNT
\       Type: Variable
\   Category: Screen mode
\    Summary: The line scan counter in DL gets reset to this value at each
\             vertical sync, before decrementing with each line scan
\
\ ******************************************************************************

.DLCNT

 EQUB 30

INCLUDE "library/6502sp/io/subroutine/setvdu19.asm"

.MASTER_MOVE_ZP_3000

 LDA #&0F
 STA VIA+&34
 LDX #&90

.L1547

 LDA ZP,X
 STA &3000,X
 INX
 BNE L1547

 LDA #&09
 STA VIA+&34
 RTS

.MASTER_SWAP_ZP_3000

 LDA #&0F
 STA VIA+&34
 LDX #&90

.L155C

 LDA ZP,X
 LDY &3000,X
 STY ZP,X
 STA &3000,X
 INX
 CPX #&F0
 BNE L155C

 LDA #&09
 STA VIA+&34
 LDA #&06
 STA VIA+&30
 RTS

INCLUDE "library/6502sp/io/variable/ylookup.asm"
INCLUDE "library/common/main/subroutine/scan.asm"
INCLUDE "library/6502sp/main/subroutine/ll30.asm"
INCLUDE "library/6502sp/io/variable/twos.asm"
INCLUDE "library/6502sp/io/variable/twos2.asm"
INCLUDE "library/6502sp/io/variable/ctwos.asm"
INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_7_of_7.asm"
INCLUDE "library/common/main/subroutine/hloin.asm"
INCLUDE "library/6502sp/io/variable/twfl.asm"
INCLUDE "library/6502sp/io/variable/twfr.asm"
INCLUDE "library/6502sp/io/variable/orange.asm"
INCLUDE "library/common/main/subroutine/pix1.asm"
INCLUDE "library/common/main/subroutine/pixel2.asm"
INCLUDE "library/common/main/subroutine/pixel.asm"
INCLUDE "library/6502sp/io/variable/pxcl.asm"
INCLUDE "library/common/main/subroutine/dot.asm"
INCLUDE "library/common/main/subroutine/cpix2.asm"
INCLUDE "library/common/main/subroutine/ecblb2.asm"
INCLUDE "library/common/main/subroutine/ecblb.asm"
INCLUDE "library/common/main/subroutine/spblb-dobulb.asm"
INCLUDE "library/common/main/variable/spbt.asm"
INCLUDE "library/common/main/variable/ecbt.asm"
INCLUDE "library/common/main/subroutine/msbar.asm"

\ ******************************************************************************
\
\       Name: HCNT
\       Type: Variable
\   Category: Ship hanger
\    Summary: The number of ships being displayed in the ship hanger
\
\ ******************************************************************************

.HCNT

 EQUB 0

INCLUDE "library/enhanced/main/subroutine/hanger.asm"
INCLUDE "library/enhanced/main/subroutine/has2.asm"
INCLUDE "library/enhanced/main/subroutine/has3.asm"
INCLUDE "library/common/main/subroutine/dvid4.asm"
INCLUDE "library/6502sp/io/subroutine/cls.asm"
INCLUDE "library/6502sp/io/subroutine/tt67.asm"
INCLUDE "library/common/main/subroutine/tt26-chpr.asm"
INCLUDE "library/6502sp/io/subroutine/ttx66.asm"
INCLUDE "library/common/main/subroutine/zes1.asm"
INCLUDE "library/common/main/subroutine/zes2.asm"
INCLUDE "library/common/main/subroutine/clyns.asm"
INCLUDE "library/common/main/subroutine/dials_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/dials_part_4_of_4.asm"
INCLUDE "library/6502sp/io/subroutine/pzw2.asm"
INCLUDE "library/common/main/subroutine/pzw.asm"
INCLUDE "library/common/main/subroutine/dilx.asm"
INCLUDE "library/common/main/subroutine/dil2.asm"


.ADD_DUPLICATE

 STA T1
 AND #&80
 STA T
 EOR S
 BMI MU8_DUPLICATE

 LDA R
 CLC
 ADC P
 TAX
 LDA S
 ADC T1
 ORA T
 RTS

.MU8_DUPLICATE

 LDA S
 AND #&7F
 STA U
 LDA P
 SEC
 SBC R
 TAX
 LDA T1
 AND #&7F
 SBC U
 BCS MU9_DUPLICATE

 STA U
 TXA
 EOR #&FF
 ADC #&01
 TAX
 LDA #&00
 SBC U
 ORA #&80

.MU9_DUPLICATE

 EOR T
 RTS

 EQUB &41,&23,&6D,&65,&6D,&3A,&53,&54
 EQUB &41,&6C,&61,&74,&63,&68,&3A,&52
 EQUB &54,&53,&0D,&13,&74,&09,&5C,&2E
 EQUB &2E,&2E,&2E,&0D,&18,&60,&05,&20
 EQUB &0D,&1A,&F4,&21,&5C,&2E,&2E,&2E
 EQUB &2E,&2E,&2E,&2E,&2E,&2E,&2E,&42
 EQUB &61,&79,&20,&56,&69,&65,&77,&2E
 EQUB &2E,&2E,&2E,&2E,&2E,&2E,&2E,&2E
 EQUB &2E,&0D,&1A,&FE,&05,&20,&0D,&1B
 EQUB &08,&11,&2E,&48,&41

 EQUB &00,&00,&00,&00,&00,&00,&00,&00
 EQUB &18,&18,&18,&18,&18,&00,&18,&00
 EQUB &6C,&6C,&6C,&00,&00,&00,&00,&00
 EQUB &36,&36,&7F,&36,&7F,&36,&36,&00
 EQUB &0C,&3F,&68,&3E,&0B,&7E,&18,&00
 EQUB &60,&66,&0C,&18,&30,&66,&06,&00
 EQUB &38,&6C,&6C,&38,&6D,&66,&3B,&00
 EQUB &0C,&18,&30,&00,&00,&00,&00,&00
 EQUB &0C,&18,&30,&30,&30,&18,&0C,&00
 EQUB &30,&18,&0C,&0C,&0C,&18,&30,&00
 EQUB &00,&18,&7E,&3C,&7E,&18,&00,&00
 EQUB &00,&18,&18,&7E,&18,&18,&00,&00
 EQUB &00,&00,&00,&00,&00,&18,&18,&30
 EQUB &00,&00,&00,&7E,&00,&00,&00,&00
 EQUB &00,&00,&00,&00,&00,&18,&18,&00
 EQUB &00,&06,&0C,&18,&30,&60,&00,&00
 EQUB &3C,&66,&6E,&7E,&76,&66,&3C,&00
 EQUB &18,&38,&18,&18,&18,&18,&7E,&00
 EQUB &3C,&66,&06,&0C,&18,&30,&7E,&00
 EQUB &3C,&66,&06,&1C,&06,&66,&3C,&00
 EQUB &0C,&1C,&3C,&6C,&7E,&0C,&0C,&00
 EQUB &7E,&60,&7C,&06,&06,&66,&3C,&00
 EQUB &1C,&30,&60,&7C,&66,&66,&3C,&00
 EQUB &7E,&06,&0C,&18,&30,&30,&30,&00
 EQUB &3C,&66,&66,&3C,&66,&66,&3C,&00
 EQUB &3C,&66,&66,&3E,&06,&0C,&38,&00
 EQUB &00,&00,&18,&18,&00,&18,&18,&00
 EQUB &00,&00,&18,&18,&00,&18,&18,&30
 EQUB &0C,&18,&30,&60,&30,&18,&0C,&00
 EQUB &00,&00,&7E,&00,&7E,&00,&00,&00
 EQUB &30,&18,&0C,&06,&0C,&18,&30,&00
 EQUB &3C,&66,&0C,&18,&18,&00,&18,&00
 EQUB &3C,&66,&6E,&6A,&6E,&60,&3C,&00
 EQUB &3C,&66,&66,&7E,&66,&66,&66,&00
 EQUB &7C,&66,&66,&7C,&66,&66,&7C,&00
 EQUB &3C,&66,&60,&60,&60,&66,&3C,&00
 EQUB &78,&6C,&66,&66,&66,&6C,&78,&00
 EQUB &7E,&60,&60,&7C,&60,&60,&7E,&00
 EQUB &7E,&60,&60,&7C,&60,&60,&60,&00
 EQUB &3C,&66,&60,&6E,&66,&66,&3C,&00
 EQUB &66,&66,&66,&7E,&66,&66,&66,&00
 EQUB &7E,&18,&18,&18,&18,&18,&7E,&00
 EQUB &3E,&0C,&0C,&0C,&0C,&6C,&38,&00
 EQUB &66,&6C,&78,&70,&78,&6C,&66,&00
 EQUB &60,&60,&60,&60,&60,&60,&7E,&00
 EQUB &63,&77,&7F,&6B,&6B,&63,&63,&00
 EQUB &66,&66,&76,&7E,&6E,&66,&66,&00
 EQUB &3C,&66,&66,&66,&66,&66,&3C,&00
 EQUB &7C,&66,&66,&7C,&60,&60,&60,&00
 EQUB &3C,&66,&66,&66,&6A,&6C,&36,&00
 EQUB &7C,&66,&66,&7C,&6C,&66,&66,&00
 EQUB &3C,&66,&60,&3C,&06,&66,&3C,&00
 EQUB &7E,&18,&18,&18,&18,&18,&18,&00
 EQUB &66,&66,&66,&66,&66,&66,&3C,&00
 EQUB &66,&66,&66,&66,&66,&3C,&18,&00
 EQUB &63,&63,&6B,&6B,&7F,&77,&63,&00
 EQUB &66,&66,&3C,&18,&3C,&66,&66,&00
 EQUB &66,&66,&66,&3C,&18,&18,&18,&00
 EQUB &7E,&06,&0C,&18,&30,&60,&7E,&00
 EQUB &7C,&60,&60,&60,&60,&60,&7C,&00
 EQUB &00,&60,&30,&18,&0C,&06,&00,&00
 EQUB &3E,&06,&06,&06,&06,&06,&3E,&00
 EQUB &18,&3C,&66,&42,&00,&00,&00,&00
 EQUB &00,&00,&00,&00,&00,&00,&00,&FF
 EQUB &1C,&36,&30,&7C,&30,&30,&7E,&00
 EQUB &00,&00,&3C,&06,&3E,&66,&3E,&00
 EQUB &60,&60,&7C,&66,&66,&66,&7C,&00
 EQUB &00,&00,&3C,&66,&60,&66,&3C,&00
 EQUB &06,&06,&3E,&66,&66,&66,&3E,&00
 EQUB &00,&00,&3C,&66,&7E,&60,&3C,&00
 EQUB &1C,&30,&30,&7C,&30,&30,&30,&00
 EQUB &00,&00,&3E,&66,&66,&3E,&06,&3C
 EQUB &60,&60,&7C,&66,&66,&66,&66,&00
 EQUB &18,&00,&38,&18,&18,&18,&3C,&00
 EQUB &18,&00,&38,&18,&18,&18,&18,&70
 EQUB &60,&60,&66,&6C,&78,&6C,&66,&00
 EQUB &38,&18,&18,&18,&18,&18,&3C,&00
 EQUB &00,&00,&36,&7F,&6B,&6B,&63,&00
 EQUB &00,&00,&7C,&66,&66,&66,&66,&00
 EQUB &00,&00,&3C,&66,&66,&66,&3C,&00
 EQUB &00,&00,&7C,&66,&66,&7C,&60,&60
 EQUB &00,&00,&3E,&66,&66,&3E,&06,&07
 EQUB &00,&00,&6C,&76,&60,&60,&60,&00
 EQUB &00,&00,&3E,&60,&3C,&06,&7C,&00
 EQUB &30,&30,&7C,&30,&30,&30,&1C,&00
 EQUB &00,&00,&66,&66,&66,&66,&3E,&00
 EQUB &00,&00,&66,&66,&66,&3C,&18,&00
 EQUB &00,&00,&63,&6B,&6B,&7F,&36,&00
 EQUB &00,&00,&66,&3C,&18,&3C,&66,&00
 EQUB &00,&00,&66,&66,&66,&3E,&06,&3C
 EQUB &00,&00,&7E,&0C,&18,&30,&7E,&00
 EQUB &0C,&18,&18,&70,&18,&18,&0C,&00
 EQUB &18,&18,&18,&00,&18,&18,&18,&00
 EQUB &30,&18,&18,&0E,&18,&18,&30,&00
 EQUB &31,&6B,&46,&00,&00,&00,&00,&00
 EQUB &FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF

.log

 EQUB &00,&00,&20,&32,&40,&4A,&52,&59
 EQUB &60,&65,&6A,&6E,&72,&76,&79,&7D
 EQUB &80,&82,&85,&87,&8A,&8C,&8E,&90
 EQUB &92,&94,&96,&98,&99,&9B,&9D,&9E
 EQUB &A0,&A1,&A2,&A4,&A5,&A6,&A7,&A9
 EQUB &AA,&AB,&AC,&AD,&AE,&AF,&B0,&B1
 EQUB &B2,&B3,&B4,&B5,&B6,&B7,&B8,&B9
 EQUB &B9,&BA,&BB,&BC,&BD,&BD,&BE,&BF
 EQUB &C0,&C0,&C1,&C2,&C2,&C3,&C4,&C4
 EQUB &C5,&C6,&C6,&C7,&C7,&C8,&C9,&C9
 EQUB &CA,&CA,&CB,&CC,&CC,&CD,&CD,&CE
 EQUB &CE,&CF,&CF,&D0,&D0,&D1,&D1,&D2
 EQUB &D2,&D3,&D3,&D4,&D4,&D5,&D5,&D5
 EQUB &D6,&D6,&D7,&D7,&D8,&D8,&D9,&D9
 EQUB &D9,&DA,&DA,&DB,&DB,&DB,&DC,&DC
 EQUB &DD,&DD,&DD,&DE,&DE,&DE,&DF,&DF
 EQUB &E0,&E0,&E0,&E1,&E1,&E1,&E2,&E2
 EQUB &E2,&E3,&E3,&E3,&E4,&E4,&E4,&E5
 EQUB &E5,&E5,&E6,&E6,&E6,&E7,&E7,&E7
 EQUB &E7,&E8,&E8,&E8,&E9,&E9,&E9,&EA
 EQUB &EA,&EA,&EA,&EB,&EB,&EB,&EC,&EC
 EQUB &EC,&EC,&ED,&ED,&ED,&ED,&EE,&EE
 EQUB &EE,&EE,&EF,&EF,&EF,&EF,&F0,&F0
 EQUB &F0,&F1,&F1,&F1,&F1,&F1,&F2,&F2
 EQUB &F2,&F2,&F3,&F3,&F3,&F3,&F4,&F4
 EQUB &F4,&F4,&F5,&F5,&F5,&F5,&F5,&F6
 EQUB &F6,&F6,&F6,&F7,&F7,&F7,&F7,&F7
 EQUB &F8,&F8,&F8,&F8,&F9,&F9,&F9,&F9
 EQUB &F9,&FA,&FA,&FA,&FA,&FA,&FB,&FB
 EQUB &FB,&FB,&FB,&FC,&FC,&FC,&FC,&FC
 EQUB &FD,&FD,&FD,&FD,&FD,&FD,&FE,&FE
 EQUB &FE,&FE,&FE,&FF,&FF,&FF,&FF,&FF

.logL

 EQUB &60,&00,&00,&B8,&00,&4D,&B8,&D6
 EQUB &00,&70,&4D,&B4,&B8,&6A,&D6,&05
 EQUB &00,&CC,&70,&EF,&4D,&8E,&B4,&C1
 EQUB &B8,&9A,&6A,&28,&D6,&75,&05,&89
 EQUB &00,&6C,&CC,&23,&70,&B4,&EF,&22
 EQUB &4D,&71,&8E,&A4,&B4,&BD,&C1,&BF
 EQUB &B8,&AC,&9A,&85,&6A,&4B,&28,&01
 EQUB &D6,&A7,&75,&3F,&05,&C9,&89,&46
 EQUB &00,&B7,&6C,&1D,&CC,&79,&23,&CB
 EQUB &70,&13,&B4,&52,&EF,&8A,&22,&B9
 EQUB &4D,&E0,&71,&00,&8E,&1A,&A4,&2D
 EQUB &B4,&39,&BD,&40,&C1,&41,&BF,&3C
 EQUB &B8,&32,&AC,&24,&9A,&10,&85,&F8
 EQUB &6A,&DB,&4B,&BA,&28,&95,&01,&6C
 EQUB &D6,&3F,&A7,&0E,&75,&DA,&3F,&A2
 EQUB &05,&67,&C9,&29,&89,&E8,&46,&A3
 EQUB &00,&5C,&B7,&12,&6C,&C5,&1D,&75
 EQUB &CC,&23,&79,&CE,&23,&77,&CB,&1E
 EQUB &70,&C2,&13,&64,&B4,&03,&52,&A1
 EQUB &EF,&3D,&8A,&D6,&22,&6E,&B9,&03
 EQUB &4D,&97,&E0,&29,&71,&B9,&00,&47
 EQUB &8E,&D4,&1A,&5F,&A4,&E8,&2D,&70
 EQUB &B4,&F7,&39,&7B,&BD,&FF,&40,&81
 EQUB &C1,&01,&41,&80,&BF,&FE,&3C,&7A
 EQUB &B8,&F5,&32,&6F,&AC,&E8,&24,&5F
 EQUB &9A,&D5,&10,&4A,&85,&BE,&F8,&31
 EQUB &6A,&A3,&DB,&13,&4B,&83,&BA,&F1
 EQUB &28,&5F,&95,&CB,&01,&36,&6C,&A1
 EQUB &D6,&0A,&3F,&73,&A7,&DB,&0E,&42
 EQUB &75,&A7,&DA,&0C,&3F,&71,&A2,&D4
 EQUB &05,&36,&67,&98,&C9,&F9,&29,&59
 EQUB &89,&B8,&E8,&17,&46,&75,&A3,&D2

.antilog

 EQUB &01,&01,&01,&01,&01,&01,&01,&01
 EQUB &01,&01,&01,&01,&01,&01,&01,&01
 EQUB &01,&01,&01,&01,&01,&01,&01,&01
 EQUB &01,&01,&01,&01,&01,&01,&01,&01
 EQUB &02,&02,&02,&02,&02,&02,&02,&02
 EQUB &02,&02,&02,&02,&02,&02,&02,&02
 EQUB &02,&02,&02,&03,&03,&03,&03,&03
 EQUB &03,&03,&03,&03,&03,&03,&03,&03
 EQUB &04,&04,&04,&04,&04,&04,&04,&04
 EQUB &04,&04,&04,&05,&05,&05,&05,&05
 EQUB &05,&05,&05,&06,&06,&06,&06,&06
 EQUB &06,&06,&07,&07,&07,&07,&07,&07
 EQUB &08,&08,&08,&08,&08,&08,&09,&09
 EQUB &09,&09,&09,&0A,&0A,&0A,&0A,&0B
 EQUB &0B,&0B,&0B,&0C,&0C,&0C,&0C,&0D
 EQUB &0D,&0D,&0E,&0E,&0E,&0E,&0F,&0F
 EQUB &10,&10,&10,&11,&11,&11,&12,&12
 EQUB &13,&13,&13,&14,&14,&15,&15,&16
 EQUB &16,&17,&17,&18,&18,&19,&19,&1A
 EQUB &1A,&1B,&1C,&1C,&1D,&1D,&1E,&1F
 EQUB &20,&20,&21,&22,&22,&23,&24,&25
 EQUB &26,&26,&27,&28,&29,&2A,&2B,&2C
 EQUB &2D,&2E,&2F,&30,&31,&32,&33,&34
 EQUB &35,&36,&38,&39,&3A,&3B,&3D,&3E
 EQUB &40,&41,&42,&44,&45,&47,&48,&4A
 EQUB &4C,&4D,&4F,&51,&52,&54,&56,&58
 EQUB &5A,&5C,&5E,&60,&62,&64,&67,&69
 EQUB &6B,&6D,&70,&72,&75,&77,&7A,&7D
 EQUB &80,&82,&85,&88,&8B,&8E,&91,&94
 EQUB &98,&9B,&9E,&A2,&A5,&A9,&AD,&B1
 EQUB &B5,&B8,&BD,&C1,&C5,&C9,&CE,&D2
 EQUB &D7,&DB,&E0,&E5,&EA,&EF,&F5,&FA

 EQUB &01,&02,&03,&04,&05,&06,&00,&01
 EQUB &02,&03,&04,&05,&06,&00,&01,&02
 EQUB &03,&04,&05,&06,&00,&01,&02,&03
 EQUB &04,&05,&06,&00,&01,&02,&03,&04
 EQUB &05,&06,&00,&01,&02,&03,&04,&05
 EQUB &06,&00,&01,&02,&03,&04,&05,&06
 EQUB &00,&01,&02,&03,&04,&05,&06,&00
 EQUB &01,&02,&03,&04,&05,&06,&00,&01
 EQUB &02,&03,&04,&05,&06,&00,&01,&02
 EQUB &03,&04,&05,&06,&00,&01,&02,&03
 EQUB &04,&05,&06,&00,&01,&02,&03,&04
 EQUB &05,&06,&00,&01,&02,&03,&04,&05
 EQUB &06,&00,&01,&02,&03,&04,&05,&06
 EQUB &00,&01,&02,&03,&04,&05,&06,&00
 EQUB &01,&02,&03,&04,&05,&06,&00,&01
 EQUB &02,&03,&04,&05,&06,&00,&01,&02
 EQUB &03,&04,&05,&06,&00,&01,&02,&03
 EQUB &04,&05,&06,&00,&01,&02,&03,&04
 EQUB &05,&06,&00,&01,&02,&03,&04,&05
 EQUB &06,&00,&01,&02,&03,&04,&05,&06
 EQUB &00,&01,&02,&03,&04,&05,&06,&00
 EQUB &01,&02,&03,&04,&05,&06,&00,&01
 EQUB &02,&03,&04,&05,&06,&00,&01,&02
 EQUB &03,&04,&05,&06,&00,&01,&02,&03
 EQUB &04,&05,&06,&00,&01,&02,&03,&04
 EQUB &05,&06,&00,&01,&02,&03,&04,&05
 EQUB &06,&00,&01,&02,&03,&04,&05,&06
 EQUB &00,&01,&02,&03,&04,&05,&06,&00
 EQUB &01,&02,&03,&04,&05,&06,&00,&01
 EQUB &02,&03,&04,&05,&06,&00,&01,&02
 EQUB &03,&04,&05,&06,&00,&01,&02,&03
 EQUB &04,&05,&06,&00,&01,&02,&03,&04
 EQUB &01,&01,&01,&01,&01,&01,&02,&02
 EQUB &02,&02,&02,&02,&02,&03,&03,&03
 EQUB &03,&03,&03,&03,&04,&04,&04,&04
 EQUB &04,&04,&04,&05,&05,&05,&05,&05
 EQUB &05,&05,&06,&06,&06,&06,&06,&06
 EQUB &06,&07,&07,&07,&07,&07,&07,&07
 EQUB &08,&08,&08,&08,&08,&08,&08,&09
 EQUB &09,&09,&09,&09,&09,&09,&0A,&0A
 EQUB &0A,&0A,&0A,&0A,&0A,&0B,&0B,&0B
 EQUB &0B,&0B,&0B,&0B,&0C,&0C,&0C,&0C
 EQUB &0C,&0C,&0C,&0D,&0D,&0D,&0D,&0D
 EQUB &0D,&0D,&0E,&0E,&0E,&0E,&0E,&0E
 EQUB &0E,&0F,&0F,&0F,&0F,&0F,&0F,&0F
 EQUB &10,&10,&10,&10,&10,&10,&10,&11
 EQUB &11,&11,&11,&11,&11,&11,&12,&12
 EQUB &12,&12,&12,&12,&12,&13,&13,&13
 EQUB &13,&13,&13,&13,&14,&14,&14,&14
 EQUB &14,&14,&14,&15,&15,&15,&15,&15
 EQUB &15,&15,&16,&16,&16,&16,&16,&16
 EQUB &16,&17,&17,&17,&17,&17,&17,&17
 EQUB &18,&18,&18,&18,&18,&18,&18,&19
 EQUB &19,&19,&19,&19,&19,&19,&1A,&1A
 EQUB &1A,&1A,&1A,&1A,&1A,&1B,&1B,&1B
 EQUB &1B,&1B,&1B,&1B,&1C,&1C,&1C,&1C
 EQUB &1C,&1C,&1C,&1D,&1D,&1D,&1D,&1D
 EQUB &1D,&1D,&1E,&1E,&1E,&1E,&1E,&1E
 EQUB &1E,&1F,&1F,&1F,&1F,&1F,&1F,&1F
 EQUB &20,&20,&20,&20,&20,&20,&20,&21
 EQUB &21,&21,&21,&21,&21,&21,&22,&22
 EQUB &22,&22,&22,&22,&22,&23,&23,&23
 EQUB &23,&23,&23,&23,&24,&24,&24,&24
 EQUB &24,&24,&24,&25,&25,&25,&25,&25
 EQUB &96,&97,&9A,&9B,&9D,&9E,&9F,&A6
 EQUB &A7,&AB,&AC,&AD,&AE,&AF,&B2,&B3
 EQUB &B4,&B5,&B6,&B7,&B9,&BA,&BB,&BC
 EQUB &BD,&BE,&BF,&CB,&CD,&CE,&CF,&D3
 EQUB &D6,&D7,&D9,&DA,&DB,&DC,&DD,&DE
 EQUB &DF,&E5,&E6,&E7,&E9,&EA,&EB,&EC
 EQUB &ED,&EE,&EF,&F2,&F3,&F4,&F5,&F6
 EQUB &F7,&F9,&FA,&FB,&FC,&FD,&FE,&FF

.COMC

 EQUB &00

 EQUB &00,&00,&00,&00,&00,&00,&00
 EQUB &00,&00,&00,&00,&00,&00,&00,&00
 EQUB &00,&00,&00

.CATF

 EQUB &00,&00

.L2C55

 EQUB &00

.DAMP

 EQUB &00

.DJD

 EQUB &00

.PATG

 EQUB &00

.FLH

 EQUB &00

.L2C5A

 EQUB &00

.JSTE

 EQUB &00

.JSTK

 EQUB &00,&00

.L2C5E

 EQUB &00

.BSTK

 EQUB &00,&00

.L2C61

 EQUB &07

.L2C62

 EQUB &01,&41,&58,&46,&59,&4A,&4B,&55
 EQUB &54,&60

.S%

 CLD
 JSR MOVE_CODE

 JSR BRKBK

 JMP BEGIN

.MOVE_CODE

 LDA #&C0
 STA FRIN
 LDA #&2C
 STA FRIN+1
 LDA #&7F
 LDY #&47
 LDX #&19
 JSR MOVE_CODE_L1

 LDA #&FF
 STA FRIN
 LDA #&7F
 STA FRIN+1
 LDA #&B1
 LDY #&FF
 LDX #&62

.MOVE_CODE_L1

 STX T
 STA SC+1
 LDA #&00
 STA SC

.MOVE_CODE_L2

 LDA (SC),Y
 SEC
 SBC T
 STA (SC),Y
 STA T
 TYA
 BNE L2CAF

 DEC SC+1

.L2CAF

 DEY
 CPY FRIN
 BNE MOVE_CODE_L2

 LDA SC+1
 CMP FRIN+1
 BNE MOVE_CODE_L2

 RTS

 EQUB &B7,&AA,&45,&23

INCLUDE "library/enhanced/main/subroutine/doentry.asm"

 EQUB &FB,&04,&F7,&08,&EF,&10,&DF,&20,&BF
 EQUB &40,&7F,&80

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
INCLUDE "library/enhanced/main/subroutine/spin.asm"

.L31AC

 LDA #&FF
 STA COL
 LDA QQ11
 BNE L31DE

 LDY #&01
 LDA L321D
 STA XX12
 LDA L3227
 STA XX12+1

.L31C0

 LDA XX12
 STA XX15
 LDA XX12+1
 STA Y1
 LDA L321D,Y
 STA X2
 STA XX12
 LDA L3227,Y
 STA Y2
 STA XX12+1
 JSR LL30

 INY
 CPY #&0A
 BCC L31C0

.L31DE

 RTS

.WSCAN_DUPLICATE

 JSR L31E2

.L31E2

 JSR L31E5

.L31E5

 LDY #&06
 JSR NOISE

 JSR L31AC

.L31ED

 LDY #&00

.L31EF

 JSR DORND

 AND #&7F
 ADC #&03
 STA L3227,Y
 TXA
 AND #&1F
 CLC
 ADC L3213,Y
 STA L321D,Y
 INY
 CPY #&0A
 BCC L31EF

 LDX #&00
 STX L3226
 DEX
 STX L321D
 BCS L31AC

.L3213

 CPX #&E0
 CPY #&A0
 BRA &3279

 EQUB &40

 EQUB &20,&00,&00

.L321D

 EQUB &00,&00,&00,&00,&00,&00,&00,&00
 EQUB &00

.L3226

 EQUB &00

.L3227

 EQUB &00,&00,&00,&00,&00,&00,&00,&00
 EQUB &00,&00

INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
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
INCLUDE "library/enhanced/main/variable/s1_per_cent.asm"

.NA%

 EQUS "jameson"         \ The current commander name, which defaults to JAMESON
 EQUB 13

 SKIP 53                \ Placeholders for bytes #0 to #52

 EQUB 16                \ AVL+0  = Market availability of Food, #53
 EQUB 15                \ AVL+1  = Market availability of Textiles, #54
 EQUB 17                \ AVL+2  = Market availability of Radioactives, #55
 EQUB 0                 \ AVL+3  = Market availability of Slaves, #56
 EQUB 3                 \ AVL+4  = Market availability of Liquor/Wines, #57
 EQUB 28                \ AVL+5  = Market availability of Luxuries, #58
 EQUB 14                \ AVL+6  = Market availability of Narcotics, #59
 EQUB 0                 \ AVL+7  = Market availability of Computers, #60
 EQUB 0                 \ AVL+8  = Market availability of Machinery, #61
 EQUB 10                \ AVL+9  = Market availability of Alloys, #62
 EQUB 0                 \ AVL+10 = Market availability of Firearms, #63
 EQUB 17                \ AVL+11 = Market availability of Furs, #64
 EQUB 58                \ AVL+12 = Market availability of Minerals, #65
 EQUB 7                 \ AVL+13 = Market availability of Gold, #66
 EQUB 9                 \ AVL+14 = Market availability of Platinum, #67
 EQUB 8                 \ AVL+15 = Market availability of Gem-Stones, #68
 EQUB 0                 \ AVL+16 = Market availability of Alien Items, #69

 SKIP 3                 \ Placeholders for bytes #70 to #72

 EQUB 128               \ SVC = Save count, #73

INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"

 SKIP 12

INCLUDE "library/common/main/variable/na_per_cent.asm"

 SKIP 16

INCLUDE "library/advanced/main/variable/shpcol.asm"
INCLUDE "library/advanced/main/variable/scacol.asm"

\ ******************************************************************************
\
\ Save output/ELTA.bin
\
\ ******************************************************************************

PRINT "ELITE A"
PRINT "Assembled at ", ~S1%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - S1%)
PRINT "Execute at ", ~LOAD%
PRINT "Reload at ", ~LOAD_A%

PRINT "S.ELTA ", ~S1%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD_A%
\SAVE "versions/master/output/ELTA.bin", S1%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE B FILE
\
\ ******************************************************************************

CODE_B% = P%
LOAD_B% = LOAD% + P% - CODE%

INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/enhanced/main/subroutine/flkb.asm"
INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"
INCLUDE "library/common/main/subroutine/hloin2.asm"
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
INCLUDE "library/common/main/subroutine/escape.asm"
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
\SAVE "versions/master/output/ELTB.bin", CODE_B%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE C FILE
\
\ ******************************************************************************

CODE_C% = P%
LOAD_C% = LOAD% +P% - CODE%

INCLUDE "library/enhanced/main/variable/hatb.asm"
INCLUDE "library/enhanced/main/subroutine/hall.asm"
INCLUDE "library/enhanced/main/subroutine/has1.asm"
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
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
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
INCLUDE "library/6502sp/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"
INCLUDE "library/common/main/subroutine/cntr.asm"
INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/arctan.asm"
INCLUDE "library/common/main/subroutine/lasli.asm"
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
\SAVE "versions/master/output/ELTC.bin", CODE_C%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE D FILE
\
\ ******************************************************************************

CODE_D% = P%
LOAD_D% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/ginf.asm"
INCLUDE "library/common/main/subroutine/ping.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"


.L4A42

 LSR A

.L4A43

 RTS

.L4A44

 RTS

.L4A45

 STA XX15
 STA X2
 LDA #&18
 STA Y1
 LDA #&98
 STA Y2
 JMP LL30

INCLUDE "library/enhanced/main/subroutine/tnpr1.asm"
INCLUDE "library/common/main/subroutine/tnpr.asm"
INCLUDE "library/6502sp/io/subroutine/setxc.asm"
INCLUDE "library/6502sp/io/subroutine/setyc.asm"
INCLUDE "library/6502sp/main/subroutine/incyc.asm"
INCLUDE "library/6502sp/main/subroutine/trademode.asm"
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
INCLUDE "library/enhanced/main/subroutine/nwdav4.asm"

.OUTX

 LDA Q
 JSR DASC

 SEC
 JMP OUT

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
INCLUDE "library/common/main/subroutine/hy6-docked.asm"
INCLUDE "library/common/main/subroutine/hyp.asm"
INCLUDE "library/common/main/subroutine/ww.asm"
INCLUDE "library/enhanced/main/subroutine/ttx110.asm"
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
INCLUDE "library/common/main/subroutine/gvl.asm"
INCLUDE "library/common/main/subroutine/gthg.asm"
INCLUDE "library/common/main/subroutine/mjp.asm"
INCLUDE "library/common/main/subroutine/tt18.asm"
INCLUDE "library/common/main/subroutine/tt110.asm"
INCLUDE "library/common/main/subroutine/tt114.asm"
INCLUDE "library/common/main/subroutine/lcash.asm"
INCLUDE "library/common/main/subroutine/mcash.asm"
INCLUDE "library/common/main/subroutine/gcash.asm"
INCLUDE "library/common/main/subroutine/gc2.asm"
INCLUDE "library/common/main/subroutine/eqshp.asm"
INCLUDE "library/common/main/subroutine/dn.asm"
INCLUDE "library/common/main/subroutine/dn2.asm"
INCLUDE "library/common/main/subroutine/eq.asm"
INCLUDE "library/common/main/subroutine/prx.asm"
INCLUDE "library/common/main/subroutine/qv.asm"
INCLUDE "library/common/main/subroutine/hm.asm"
INCLUDE "library/enhanced/main/subroutine/refund.asm"
INCLUDE "library/common/main/variable/prxs.asm"

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
\SAVE "versions/master/output/ELTD.bin", CODE_D%, P%, LOAD%

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

 LDX #&15

.L58B9

 LDA ZP,X
 LDY ZP,X
 STA ZP,X
 STY ZP,X
 INX
 BNE L58B9

 RTS

INCLUDE "library/common/main/subroutine/doexp.asm"
INCLUDE "library/common/main/subroutine/sos1.asm"

.L5A24

 LDA L1264
 BEQ SOLAR

 LDA #&00
 STA QQ20
 STA QQ20+6
 JSR DORND

 AND #&0F
 ADC L1264
 ORA #&04
 ROL A
 STA L1264
 ROL L1265
 BPL SOLAR

 ROR L1265

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
INCLUDE "library/common/main/subroutine/oops.asm"
INCLUDE "library/common/main/subroutine/sps3.asm"
INCLUDE "library/common/main/subroutine/nwsps.asm"
INCLUDE "library/common/main/subroutine/nwshp.asm"
INCLUDE "library/common/main/subroutine/nws1.asm"
INCLUDE "library/common/main/subroutine/abort.asm"
INCLUDE "library/common/main/subroutine/abort2.asm"

 EQUB &04,&00,&00,&00,&00

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
INCLUDE "library/original/main/subroutine/wpls2.asm"
INCLUDE "library/original/main/subroutine/wp1.asm"
INCLUDE "library/common/main/subroutine/wpls.asm"
INCLUDE "library/common/main/subroutine/edges.asm"
INCLUDE "library/common/main/subroutine/chkon.asm"
INCLUDE "library/common/main/subroutine/pl21.asm"
INCLUDE "library/common/main/subroutine/pls3.asm"
INCLUDE "library/common/main/subroutine/pls4.asm"
INCLUDE "library/common/main/subroutine/pls5.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"

.L6174

 JSR t

 CMP #&59
 BEQ PL6

 CMP #&4E
 BNE L6174

 CLC
 RTS

INCLUDE "library/common/main/subroutine/tt17.asm"


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
\SAVE "versions/master/output/ELTE.bin", CODE_E%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE F FILE
\
\ ******************************************************************************

CODE_F% = P%
LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/ks3.asm"
INCLUDE "library/common/main/subroutine/ks1.asm"
INCLUDE "library/common/main/subroutine/ks4.asm"
INCLUDE "library/common/main/subroutine/ks2.asm"
INCLUDE "library/common/main/subroutine/killshp.asm"
INCLUDE "library/enhanced/main/subroutine/there.asm"

 PHA
 LSR A
 LSR A
 LSR A
 LSR A
 JSR L6324

 PLA
 AND #&0F

.L6324

 CMP #&0A
 BCS L632D

 ADC #&30
 JMP CHPR

.L632D

 ADC #&36
 JMP CHPR

INCLUDE "library/common/main/subroutine/reset.asm"
INCLUDE "library/common/main/subroutine/res2.asm"
INCLUDE "library/common/main/subroutine/zinf.asm"
INCLUDE "library/common/main/subroutine/msblob.asm"
INCLUDE "library/common/main/subroutine/me2.asm"
INCLUDE "library/common/main/subroutine/ze.asm"
INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_1_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_2_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_3_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_4_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_5_of_6.asm"
INCLUDE "library/common/main/subroutine/main_game_loop_part_6_of_6.asm"
INCLUDE "library/common/main/subroutine/tt102.asm"
INCLUDE "library/common/main/subroutine/bad.asm"
INCLUDE "library/common/main/subroutine/farof.asm"
INCLUDE "library/common/main/subroutine/farof2.asm"
INCLUDE "library/common/main/subroutine/mas4.asm"
INCLUDE "library/enhanced/main/variable/brkd.asm"
INCLUDE "library/enhanced/main/subroutine/brbr.asm"
INCLUDE "library/common/main/subroutine/death.asm"
INCLUDE "library/6502sp/main/variable/spasto.asm"
INCLUDE "library/enhanced/main/subroutine/begin.asm"
INCLUDE "library/common/main/subroutine/tt170.asm"
INCLUDE "library/common/main/subroutine/death2.asm"
INCLUDE "library/common/main/subroutine/br1_part_1_of_2.asm"
INCLUDE "library/common/main/subroutine/br1_part_2_of_2.asm"
INCLUDE "library/common/main/subroutine/bay.asm"
INCLUDE "library/common/main/subroutine/dfault-qu5.asm"
INCLUDE "library/common/main/subroutine/title.asm"
INCLUDE "library/common/main/subroutine/check.asm"

.L68BB

 LDY #&60               \ Restore default commander

.L68BD

 LDA DEFAULT%,Y
 STA NA%,Y
 DEY
 BPL L68BD

 LDY #&07
 STY L6A8B
 RTS

INCLUDE "library/common/main/subroutine/trnme.asm"
INCLUDE "library/common/main/subroutine/tr1.asm"
INCLUDE "library/common/main/subroutine/gtnme-gtnmew.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/common/main/variable/rline.asm"

.L6960                    \ See JMTB

 LDA #&03
 CLC
 ADC L2C5E
 JMP DETOK

.L6969                    \ See JMTB

 LDA #&02
 SEC
 SBC L2C5E
 JMP DETOK

INCLUDE "library/common/main/subroutine/zero.asm"
INCLUDE "library/enhanced/main/subroutine/cats.asm"
INCLUDE "library/enhanced/main/subroutine/delt.asm"
INCLUDE "library/common/main/subroutine/sve.asm"

.L6A8A

 EQUB &07

.L6A8B

 EQUB &07

INCLUDE "library/enhanced/main/subroutine/gtdrv.asm"
INCLUDE "library/common/main/subroutine/lod.asm"
INCLUDE "library/enhanced/main/variable/ctli.asm"
INCLUDE "library/enhanced/main/variable/deli.asm"

.SVLI

 EQUS "SAVE :1.E.JAMESON  E7E +100 0 0"
 EQUB &0D

.LDLI

 EQUS "LOAD :1.E.JAMESON  E7E"
 EQUB &0D

.L6B16

 LDY #&4C

.L6B18

 LDA NA%+8,Y
 STA LSX2,Y
 DEY
 BPL L6B18

 LDA #&00
 LDY #&4C

.L6B25

 STA LSX2,Y
 INY
 BNE L6B25

 LDY #&00

.L6B2D

 LDA NA%,Y
 CMP #&0D
 BEQ L6B3C

 STA SVLI+10,Y
 INY
 CPY #&07
 BCC L6B2D

.L6B3C

 LDA #&20
 STA SVLI+10,Y
 INY
 CPY #&07
 BCC L6B3C

 JSR MASTER_SWAP_ZP_3000

 LDX #&DF
 LDY #&6A
 JSR OSCLI

 JMP MASTER_SWAP_ZP_3000

.L6B53

 LDY #&00

.L6B55

 LDA INWK+5,Y
 CMP #&0D
 BEQ L6B64

 STA LDLI+10,Y
 INY
 CPY #&07
 BCC L6B55

.L6B64

 LDA #&20
 STA LDLI+10,Y
 INY
 CPY #&07
 BCC L6B64

 JSR MASTER_SWAP_ZP_3000

 LDX #&FF
 LDY #&6A
 JSR OSCLI

 JSR MASTER_SWAP_ZP_3000

 LDY #&4C

.L6B7D

 LDA LSX2,Y
 STA L0791,Y
 DEY
 BPL L6B7D

 RTS

 RTS

INCLUDE "library/common/main/subroutine/sps1.asm"
INCLUDE "library/common/main/subroutine/tas2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"
INCLUDE "library/common/main/subroutine/warp.asm"
INCLUDE "library/common/main/subroutine/dks3.asm"
INCLUDE "library/common/main/subroutine/dokey.asm"
INCLUDE "library/common/main/subroutine/dk4.asm"
INCLUDE "library/common/main/subroutine/tt217.asm"
INCLUDE "library/common/main/subroutine/me1.asm"
INCLUDE "library/common/main/subroutine/mess.asm"
INCLUDE "library/common/main/subroutine/mes9.asm"
INCLUDE "library/common/main/subroutine/ouch.asm"
INCLUDE "library/common/main/subroutine/ou2.asm"
INCLUDE "library/common/main/subroutine/ou3.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/variable/qq23.asm"
INCLUDE "library/common/main/subroutine/tidy.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/tis3.asm"
INCLUDE "library/common/main/subroutine/dvidt.asm"
INCLUDE "library/6502sp/main/variable/ktran.asm"

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
\SAVE "versions/master/output/ELTF.bin", CODE_F%, P%, LOAD%

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
INCLUDE "library/common/main/subroutine/ll9_part_11_of_12.asm"
INCLUDE "library/common/main/subroutine/ll118.asm"
INCLUDE "library/common/main/subroutine/ll120.asm"
INCLUDE "library/common/main/subroutine/ll123.asm"
INCLUDE "library/common/main/subroutine/ll129.asm"
INCLUDE "library/common/main/subroutine/ll145_part_1_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_2_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_3_of_4.asm"
INCLUDE "library/common/main/subroutine/ll145_part_4_of_4.asm"
INCLUDE "library/common/main/subroutine/ll9_part_12_of_12.asm"


.L78F8

 LDY XX14
 CPY XX14+1
 PHP
 LDX #&03

.L78FF

 LDA XX15,X
 STA XX12,X
 DEX
 BPL L78FF

 JSR LL30

 LDA (XX19),Y
 STA XX15
 LDA XX12
 STA (XX19),Y
 INY
 LDA (XX19),Y
 STA Y1
 LDA XX12+1
 STA (XX19),Y
 INY
 LDA (XX19),Y
 STA X2
 LDA XX12+2
 STA (XX19),Y
 INY
 LDA (XX19),Y
 STA Y2
 LDA XX12+3
 STA (XX19),Y
 INY
 STY XX14
 PLP
 BCS L78F7

 JMP LL30

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
\SAVE "versions/master/output/ELTG.bin", CODE_G%, P%, LOAD%

\ ******************************************************************************
\
\ ELITE H FILE
\
\ Produces the binary file ELTH.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_H% = P%
LOAD_H% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/mveit_part_1_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_2_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_3_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_4_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_5_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_6_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_7_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_8_of_9.asm"
INCLUDE "library/common/main/subroutine/mveit_part_9_of_9.asm"
INCLUDE "library/common/main/subroutine/mvt1.asm"
INCLUDE "library/common/main/subroutine/mvs4.asm"
INCLUDE "library/common/main/subroutine/mvt6.asm"
INCLUDE "library/common/main/subroutine/mv40.asm"
INCLUDE "library/common/main/subroutine/plut-pu1.asm"
INCLUDE "library/common/main/subroutine/look1.asm"


.SIGHT

 LDY VIEW
 LDA LASER,Y
 BEQ LO2

 LDY #&00
 CMP #&0F
 BEQ L7D70

 INY
 CMP #&8F
 BEQ L7D70

 INY
 CMP #&97
 BEQ L7D70

 INY

.L7D70

 LDA L7D8B,Y
 STA COL
 LDA #&80
 STA QQ19
 LDA #&48
 STA QQ19+1
 LDA #&14
 STA QQ19+2
 JSR TT15

 LDA #&0A
 STA QQ19+2
 JMP TT15

.L7D8B

 EQUB &0F

 EQUB &FF,&FF,&0F

 EQUB &FA

 EQUB &FA,&FA,&FA

.TT66

 STA QQ11
 JSR TTX66

 JSR MT2

 LDA #&00
 STA LSP
 LDA #&80
 STA QQ17
 STA DTW2
 JSR FLFLLS

 LDA #&00
 STA LAS2
 STA DLY
 STA de
 LDX QQ22+1
 BEQ OLDBOX

 JSR ee3

.OLDBOX

 LDA QQ11
 BNE tt66

 LDA #&0B
 STA XC
 LDA #&FF
 STA COL
 LDA VIEW
 ORA #&60
 JSR TT27

 JSR TT162

 LDA #&AF
 JSR TT27

.tt66

 LDX #&00
 STX QQ17
 RTS

.L7DDC

 EQUB &00

 EQUB &40,&FE,&A0,&5F,&8C,&43,&FE,&8E
 EQUB &4F,&FE,&EA,&AE,&4F,&FE,&60,&51
 EQUB &33,&34,&35,&84,&38,&87,&2D,&5E
 EQUB &8C,&36,&37,&BC,&00,&FC,&60,&80
 EQUB &57,&45,&54,&37,&49,&39,&30,&5F
 EQUB &8E,&38,&39,&BC,&00,&FD,&60,&31
 EQUB &32,&44,&52,&36,&55,&4F,&50,&5B
 EQUB &8F,&81,&82,&0D,&4C,&20,&02,&01
 EQUB &41,&58,&46,&59,&4A,&4B,&40,&3A
 EQUB &0D,&83,&7F,&AE,&4C,&FE,&FD,&02
 EQUB &53,&43,&47,&48,&4E,&4C,&3B,&5D
 EQUB &7F,&85,&84,&86,&4C,&FA,&00,&00
 EQUB &5A,&20,&56,&42,&4D,&2C,&2E,&2F
 EQUB &8B,&30,&31,&33,&00,&00,&00,&1B
 EQUB &81,&82,&83,&85,&86,&88,&89,&5C
 EQUB &8D,&34,&35,&32,&2C,&4E,&E3

.KYTB

 EQUB &22,&23,&35,&37,&41,&42,&45,&51
 EQUB &52,&60,&62,&65,&66,&67,&68,&70
 EQUB &F0

.RDKEY_REAL

 JSR U%

 LDA #&10
 CLC

.L7E73

 LDY #&03
 SEI
 STY VIA+&40
 LDY #&7F
 STY VIA+&43
 STA VIA+&4F
 LDY VIA+&4F
 LDA #&0B
 STA VIA+&40
 CLI
 TYA
 BMI DKS1

.L7E8D

 ADC #&01
 BPL L7E73

 CLD
 LDA L00CB
 EOR #&FF
 AND KY19
 STA KY19
 LDA KL
 TAX
 RTS

.DKS1

 EOR #&80
 STA KL

.L7EA2

 CMP KYTB,X
 BCC L7E8D

 BEQ L7EAC

 INX
 BNE L7EA2

.L7EAC

 DEC KY17,X
 INX
 CLC
 BCC L7E8D

.CTRL

 LDA #&01

.DKS4

 LDX #&03
 SEI
 STX VIA+&40
 LDX #&7F
 STX VIA+&43
 STA VIA+&4F
 LDX VIA+&4F
 LDA #&0B
 STA VIA+&40
 CLI
 TXA
 RTS

.U%

 LDA #&00
 LDX #&11

.DKL3

 STA JSTY,X
 DEX
 BNE DKL3

 RTS

.L7ED7

 SED

.RDKEY

 TYA
 PHA
 JSR RDKEY_REAL

 PLA
 TAY
 LDA L7DDC,X
 STA KL
 TAX
 RTS

.L7EE6

 RTS

.ECMOF

 LDA #&00
 STA ECMA
 STA ECMP
 JMP ECBLB

.SFRMIS

 LDX #&01
 JSR SFS1-2

 BCC L7EE6

 LDA #&78
 JSR MESS

 LDY #&08
 JMP NOISE

.EXNO2

 LDA L1266
 CLC
 ADC L8062,X
 STA L1266
 LDA TALLY
 ADC L8083,X
 STA TALLY
 BCC EXNO3

 INC TALLY+1
 LDA #&65
 JSR MESS

.EXNO3

 LDY #&04
 JMP NOISE

.EXNO

 LDY #&06
 JMP NOISE

.BRKBK

 LDA #&B9
 STA BRKV
 LDA #&66
 STA BRKV+1
 LDA #&85
 STA WRCHV
 LDA #&20
 STA WRCHV+1
 JSR MASTER_MOVE_ZP_3000

 JSR STARTUP

 JMP L1377

 CLI
 RTI

.BeebDisEndAddr

\ ******************************************************************************
\
\ Save output/BCODE.unprot.bin
\
\ ******************************************************************************

PRINT "S.BCODE ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/master/output/BCODE.unprot.bin", CODE%, P%, LOAD%

