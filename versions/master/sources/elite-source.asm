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

NOST = 18               \ The number of stardust particles in normal space (this
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
LGO = 32                \ Ship type for the Elite logo
COU = 33                \ Ship type for a Cougar
DOD = 34                \ Ship type for a Dodecahedron ("Dodo") space station

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

\ Incorrect?
f0 = &20                \ Internal key number for red key f0 (Launch, Front)
f1 = &71                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &72                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &73                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &14                \ Internal key number for red key f4 (Long-range Chart)
f5 = &74                \ Internal key number for red key f5 (Short-range Chart)
f6 = &75                \ Internal key number for red key f6 (Data on System)
f7 = &16                \ Internal key number for red key f7 (Market Price)
f8 = &76                \ Internal key number for red key f8 (Status Mode)

\ Correct
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
KTRAN   = &129F
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

.L2C5B

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
\ Produces the binary file ELTF.bin that gets loaded by elite-bcfs.asm.
\
\ ******************************************************************************

CODE_F% = P%
LOAD_F% = LOAD% + P% - CODE%

INCLUDE "library/common/main/subroutine/ks3.asm"


.KS1

 LDX XSAV
 JSR KILLSHP

 LDX XSAV
 JMP MAL1

.KS4

 JSR ZINF

 JSR FLFLLS

 STA FRIN+1
 STA SSPR
 JSR SPBLB

 LDA #&06
 STA INWK+5
 LDA #&81
 JMP NWSHP

.KS2

 LDX #&FF

.KSL4

 INX
 LDA FRIN,X
 BEQ KS3

 CMP #&01
 BNE KSL4

 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1
 LDY #&20
 LDA (SC),Y
 BPL KSL4

 AND #&7F
 LSR A
 CMP XX4
 BCC KSL4

 BEQ KS6

 SBC #&01
 ASL A
 ORA #&80
 STA (SC),Y
 BNE KSL4

.KS6

 LDA #&00
 STA (SC),Y
 BEQ KSL4

.KILLSHP

 STX XX4
 LDA MSTG
 CMP XX4
 BNE KS5

 LDY #&0C
 JSR ABORT

 LDA #&C8
 JSR MESS

.KS5

 LDY XX4
 LDX FRIN,Y
 CPX #&02
 BEQ KS4

 CPX #&1F
 BNE lll

 LDA TP
 ORA #&02
 STA TP
 INC TALLY+1

.lll

 CPX #&0F
 BEQ blacksuspenders

 CPX #&03
 BCC KS7

 CPX #&0B
 BCS KS7

.blacksuspenders

 DEC JUNK

.KS7

 DEC MANY,X
 LDX XX4
 LDY #&05
 LDA (XX0),Y
 LDY #&21
 CLC
 ADC (INF),Y
 STA P
 INY
 LDA (INF),Y
 ADC #&00
 STA P+1

.KSL1

 INX
 LDA FRIN,X
 STA FRIN-1,X
 BNE L629E

 JMP KS2

.L629E

 ASL A
 TAY
 LDA XX21-2,Y
 STA SC
 LDA XX21-1,Y
 STA SC+1
 LDY #&05
 LDA (SC),Y
 STA T
 LDA P
 SEC
 SBC T
 STA P
 LDA P+1
 SBC #&00
 STA P+1
 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA UNIV+1,Y
 STA SC+1
 LDY #&24
 LDA (SC),Y
 STA (INF),Y
 DEY
 LDA (SC),Y
 STA (INF),Y
 DEY
 LDA (SC),Y
 STA K+1
 LDA P+1
 STA (INF),Y
 DEY
 LDA (SC),Y
 STA K
 LDA P
 STA (INF),Y
 DEY

.KSL2

 LDA (SC),Y
 STA (INF),Y
 DEY
 BPL KSL2

 LDA SC
 STA INF
 LDA SC+1
 STA INF+1
 LDY T

.KSL3

 DEY
 LDA (K),Y
 STA (P),Y
 TYA
 BNE KSL3

 BEQ KSL1

.THERE

 LDX GCNT
 DEX
 BNE THEX

 LDA QQ0
 CMP #&90
 BNE THEX

 LDA QQ1
 CMP #&21
 BEQ L6318

.THEX

 CLC

.L6318

 RTS

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

.RESET

 JSR ZERO

 LDX #&06

.SAL3

 STA BETA,X
 DEX
 BPL SAL3

 STX L2C5A
 TXA
 STA QQ12
 LDX #&02

.REL5

 STA FSH,X
 DEX
 BPL REL5

.RES2

 LDA #&14
 STA NOSTM
 LDX #&FF
 STX LSX2
 STX LSY2
 STX MSTG
 LDA #&80
 STA JSTY
 STA ALP2
 STA BET2
 ASL A
 STA BETA
 STA BET1
 STA ALP2+1
 STA BET2+1
 STA MCNT
 LDA #&03
 STA DELTA
 STA ALPHA
 STA ALP1
 LDA #&00
 STA L0098
 LDA #&BF
 STA L0099
 LDA SSPR
 BEQ L6382

 JSR SPBLB

.L6382

 LDA ECMA
 BEQ yu

 JSR ECMOF

.yu

 JSR WPSHPS

 JSR ZERO

 LDA #&00
 STA SLSP
 LDA #&08
 STA SLSP+1

.ZINF

 LDY #&24
 LDA #&00

.ZI1

 STA INWK,Y
 DEY
 BPL ZI1

 LDA #&60
 STA INWK+18
 STA INWK+22
 ORA #&80
 STA INWK+14
 RTS

.msblob

 LDX #&04

.ss

 CPX NOMSL
 BEQ SAL8

 LDY #&00
 JSR MSBAR

 DEX
 BNE ss

 RTS

.SAL8

 LDY #&0C
 JSR MSBAR

 DEX
 BNE SAL8

 RTS

.me2

 LDA QQ11
 BNE L63D9

 LDA MCH
 JSR MESS

 LDA #&00
 STA DLY
 JMP me3

.L63D9

 JSR CLYNS

 JMP me3

.Ze

 JSR ZINF

 JSR DORND

 STA T1
 AND #&80
 STA INWK+2
 TXA
 AND #&80
 STA INWK+5
 LDA #&19
 STA INWK+1
 STA INWK+4
 STA INWK+7
 TXA
 CMP #&F5
 ROL A
 ORA #&C0
 STA INWK+32

.DORND2

 CLC

.DORND

 LDA RAND
 ROL A
 TAX
 ADC RAND+2
 STA RAND
 STX RAND+2
 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3
 RTS

.MTT4

 JSR DORND

 LSR A
 STA INWK+32
 STA INWK+29
 ROL INWK+31
 AND #&1F
 ORA #&10
 STA INWK+27
 JSR DORND

 BMI nodo

 LDA INWK+32
 ORA #&C0
 STA INWK+32
 LDX #&10
 STX NEWB

.nodo

 AND #&02
 ADC #&0B
 CMP #&0F
 BEQ TT100

 JSR NWSHP

.TT100

 JSR M%

 DEC DLY
 BEQ me2

 BPL me3

 INC DLY

.me3

 DEC MCNT
 BEQ L6453

.ytq

 JMP MLOOP

.L6453

 LDA MJ
 BNE ytq

 JSR DORND

 CMP #&23
 BCS MTT1

 LDA JUNK
 CMP #&03
 BCS MTT1

 JSR ZINF

 LDA #&26
 STA INWK+7
 JSR DORND

 STA INWK
 STX INWK+3
 AND #&80
 STA INWK+2
 TXA
 AND #&80
 STA INWK+5
 ROL INWK+1
 ROL INWK+1
 JSR DORND

 BVS MTT4

 ORA #&6F
 STA INWK+29
 LDA SSPR
 BNE MTT1

 TXA
 BCS MTT2

 AND #&1F
 ORA #&10
 STA INWK+27
 BCC MTT3

.MTT2

 ORA #&7F
 STA INWK+30

.MTT3

 JSR DORND

 CMP #&FC
 BCC thongs

 LDA #&0F
 STA INWK+32
 BNE whips

.thongs

 CMP #&0A
 AND #&01
 ADC #&05

.whips

 JSR NWSHP

.MTT1

 LDA SSPR
 BEQ L64BC

.MLOOPS

 JMP MLOOP

.L64BC

 JSR BAD

 ASL A
 LDX L0E5E
 BEQ L64C8

 ORA FIST

.L64C8

 STA T
 JSR Ze

 CMP #&88
 BEQ fothg

 CMP T
 BCS L64DA

 LDA #&10
 JSR NWSHP

.L64DA

 LDA L0E5E
 BNE MLOOPS

 DEC EV
 BPL MLOOPS

 INC EV
 LDA TP
 AND #&0C
 CMP #&08
 BNE nopl

 JSR DORND

 CMP #&DC
 BCC nopl

.fothg2

 JSR GTHG

.nopl

 JSR DORND

 LDY gov
 BEQ LABEL_2

 CMP #&5A
 BCS MLOOPS

 AND #&07
 CMP gov
 BCC MLOOPS

.LABEL_2

 JSR Ze

 CMP #&64
 BCS mt1

 INC EV
 AND #&03
 ADC #&18
 TAY
 JSR THERE

 BCC NOCON

 LDA #&F9
 STA INWK+32
 LDA TP
 AND #&03
 LSR A
 BCC NOCON

 ORA L0E6D
 BEQ YESCON

.NOCON

 LDA #&04
 STA NEWB
 JSR DORND

 CMP #&C8
 ROL A
 ORA #&C0
 STA INWK+32
 TYA
 EQUB &2C

.YESCON

 LDA #&1F

.focoug

 JSR NWSHP

 JMP MLOOP

.fothg

 LDA L0406
 AND #&3E
 BNE fothg2

 LDA #&12
 STA INWK+27
 LDA #&79
 STA INWK+32
 LDA #&20
 BNE focoug

.mt1

 AND #&03
 STA EV
 STA XX13

.mt3

 JSR DORND

 STA T
 JSR DORND

 AND T
 AND #&07
 ADC #&11
 JSR NWSHP

 DEC XX13
 BPL mt3

.MLOOP

 LDX #&FF
 TXS
 LDX GNTMP
 BEQ EE20

 DEC GNTMP

.EE20

 LDX LASCT
 BEQ NOLASCT

 DEX
 BEQ L658D

 DEX

.L658D

 STX LASCT

.NOLASCT

 JSR DIALS

 LDA QQ11
 BEQ L65A2

 AND PATG
 LSR A
 BCS L65A2

 LDY #&02
 JSR DELAY

.L65A2

 JSR TT17

.FRCE

 JSR TT102

 LDA QQ12
 BEQ L65AF

 JMP MLOOP

.L65AF

 JMP TT100

.TT102

 CMP #&88
 BNE L65B9

 JMP STATUS

.L65B9

 CMP #&84
 BNE L65C0

 JMP TT22

.L65C0

 CMP #&85
 BNE L65C7

 JMP TT23

.L65C7

 CMP #&86
 BNE TT92

 JSR TT111

 JMP TT25

.TT92

 CMP #&89
 BNE L65D8

 JMP TT213

.L65D8

 CMP #&87
 BNE L65DF

 JMP TT167

.L65DF

 CMP #&80
 BNE fvw

 JMP TT110

.fvw

 BIT QQ12
 BPL INSP

 CMP #&83
 BNE L65F1

 JMP EQSHP

.L65F1

 CMP #&81
 BNE L65F8

 JMP TT219

.L65F8

 CMP #&40
 BNE nosave

 JSR SVE

 BCC L6604

 JMP QU5

.L6604

 JMP BAY

.nosave

 CMP #&82
 BNE LABEL_3

 JMP TT208

.INSP

 CMP #&81
 BEQ L6620

 CMP #&82
 BEQ L661D

 CMP #&83
 BNE LABEL_3

 LDX #&03
 EQUB &2C

.L661D

 LDX #&02
 EQUB &2C

.L6620

 LDX #&01
 JMP LOOK1

.LABEL_3

 LDA KL
 CMP #&48
 BNE NWDAV5

 JMP hyp

.NWDAV5

 CMP #&44
 BEQ T95

 CMP #&46
 BNE HME1

 LDA QQ12
 BEQ t95

 LDA QQ11
 AND #&C0
 BEQ t95

 JMP HME2

.HME1

 STA T1
 LDA QQ11
 AND #&C0
 BEQ TT107

 LDA QQ22+1
 BNE TT107

 LDA T1
 CMP #&4F
 BNE ee2

 JSR TT103

 JSR ping

 JMP TT103

.ee2

 JSR TT16

.TT107

 LDA QQ22+1
 BEQ t95

 DEC QQ22
 BNE t95

 LDX QQ22+1
 DEX
 JSR ee3

 LDA #&05
 STA QQ22
 LDX QQ22+1
 JSR ee3

 DEC QQ22+1
 BNE t95

 JMP TT18

.t95

 RTS

.T95

 LDA QQ11
 AND #&C0
 BEQ t95

 JSR hm

 JSR cpl

 LDA #&80
 STA QQ17
 LDA #&0C
 JSR DASC

 JMP TT146

.BAD

 LDA QQ20+3
 CLC
 ADC QQ20+6
 ASL A
 ADC QQ20+10
 RTS

.FAROF

 LDA #&E0

.FAROF2

 CMP INWK+1
 BCC FA1

 CMP INWK+4
 BCC FA1

 CMP INWK+7

.FA1

 RTS

.MAS4

 ORA INWK+1
 ORA INWK+4
 ORA INWK+7
 RTS

.L66B8

 EQUB &FF

.BRBR

 LDX L66B8
 TXS
 JSR MASTER_SWAP_ZP_3000

 STZ CATF
 LDY #&00
 LDA #&07

.BRBRLOOP

 JSR CHPR

 INY
 LDA (&FD),Y
 BNE BRBRLOOP

 JSR t

 JMP SVE

.DEATH

 LDY #&04
 JSR NOISE

 JSR RES2

 ASL DELTA
 ASL DELTA
 LDX #&18
 JSR DET1

 LDA #&0D
 JSR TT66

 STZ QQ11
 JSR BOX

 JSR nWq

 LDA #&FF
 STA COL
 LDA #&0C
 STA XC
 STA YC
 LDA #&92
 JSR ex

.D1

 JSR Ze

 LSR A
 LSR A
 STA INWK
 LDY #&00
 STY INWK+1
 STY INWK+4
 STY INWK+7
 STY INWK+32
 DEY
 STY MCNT
 EOR #&2A
 STA INWK+3
 ORA #&50
 STA INWK+6
 TXA
 AND #&8F
 STA INWK+29
 LDY #&40
 STY LASCT
 SEC
 ROR A
 AND #&87
 STA INWK+30
 LDX #&05
 LDA L8007
 BEQ D3

 BCC D3

 DEX

.D3

 JSR fq1

 JSR DORND

 AND #&80
 LDY #&1F
 STA (INF),Y
 LDA FRIN+4
 BEQ D1

 LDA #&00
 STA DELTA
 JSR M%

.D2

 JSR M%

 DEC LASCT
 BNE D2

 LDX #&1F
 JSR DET1

 JMP DEATH2

.spasto

 DEY

.L6761

 DEY

.BEGIN

 LDX #&1E
 LDA #&00

.BEL1

 STA COMC,X
 DEX
 BPL BEL1

 LDA L8002
 STA spasto
 LDA L8003
 STA L6761
 JSR L68BB

 LDX #&FF
 TXS
 JSR RESET

.DEATH2

 LDX #&FF
 TXS
 JSR RES2

 JSR U%

 LDA #&03
 STA XC
 LDX #&0B
 LDA #&06
 LDY #&C8
 JSR TITLE

 CPX #&59
 BNE QU5

 JSR DFAULT

 JSR SVE

.QU5

 JSR DFAULT

 JSR msblob

 LDA #&07
 LDX #&20
 LDY #&64
 JSR TITLE

 JSR ping

 JSR TT111

 JSR jmp

 LDX #&05

.likeTT112

 LDA QQ15,X
 STA QQ2,X
 DEX
 BPL likeTT112

 INX
 STX EV
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov

.BAY

 LDA #&FF
 STA QQ12
 LDA #&88
 JMP FRCE

.DFAULT

 LDX #&54

.QUL1

 LDA NA%-1,X
 STA NAME-1,X
 DEX
 BNE QUL1

 STX QQ11

.L67EC

 JSR CHECK

 CMP CHK
 BNE L67EC

 EOR #&A9
 TAX
 LDA COK
 CPX CHK2
 BEQ tZ

 ORA #&80

.tZ

 ORA #&08
 STA COK
 RTS

.TITLE

 STY L1229
 PHA
 STX TYPE
 JSR RESET

 JSR U%

 JSR ZINF

 LDA #&20
 JSR SETVDU19

 LDA #&0D
 JSR TT66

 LDA #&F0
 STA COL
 LDA #&00
 STA QQ11
 LDA #&60
 STA INWK+14
 LDA #&60
 STA INWK+7
 LDX #&7F
 STX INWK+29
 STX INWK+30
 INX
 STX QQ17
 LDA TYPE
 JSR NWSHP

 LDA #&06
 STA XC
 LDA #&1E
 JSR plf

 LDA #&0A
 JSR DASC

 LDA #&06
 STA XC
 LDA PATG
 BEQ awe

 LDA #&0D
 JSR DETOK

.awe

 LDY #&00
 STY DELTA
 STY JSTK
 LDA #&14
 STA YC
 LDA #&01
 STA XC
 PLA
 JSR DETOK

 LDA #&07
 STA XC
 LDA #&0C
 JSR DETOK

 LDA #&0C
 STA CNT2
 LDA #&05
 STA MCNT
 STZ JSTK

.TLL2

 LDA INWK+7
 CMP #&01
 BEQ TL1

 DEC INWK+7

.TL1

 JSR MVEIT

 LDX L1229
 STX INWK+6
 LDA #&00
 STA INWK
 STA INWK+3
 JSR LL9

 DEC MCNT
 LDA VIA+&40
 AND #&10
 BEQ TL2

 JSR RDKEY

 BEQ TLL2

 RTS

.TL2

 DEC JSTK
 RTS

.CHECK

 LDX #&49
 CLC
 TXA

.QUL2

 ADC NA%+7,X            \ Add the X-1-th byte of the data block to A, plus the
                        \ C flag

 EOR NA%+8,X            \ EOR A with the X-th byte of the data block
 DEX
 BNE QUL2

 RTS

.L68BB

 LDY #&60

.L68BD

 LDA DEFAULT%,Y
 STA NA%,Y
 DEY
 BPL L68BD

 LDY #&07
 STY L6A8B
 RTS

.TRNME

 LDX #&07
 LDA L6A8A
 STA L6A8B

.GTL1

 LDA INWK+5,X
 STA NA%,X
 DEX
 BPL GTL1

.TR1

 LDX #&07

.GTL2

 LDA NA%,X
 STA INWK+5,X
 DEX
 BPL GTL2

 RTS

.GTNMEW

 LDX #&04

.GTL3

 LDA S1%,X
 STA INWK,X
 DEX
 BPL GTL3

 LDA #&07
 STA L695D
 LDA #&08
 JSR DETOK

 JSR MT26

 LDA #&09
 STA L695D
 TYA
 BEQ TR1

 STY L6A8A
 RTS

.MT26

 LDA COL
 PHA
 LDA #&F0
 STA COL
 LDY #&08
 JSR DELAY

 JSR FLKB

 LDY #&00

.L691B

 JSR TT217

 CMP #&0D
 BEQ L6945

 CMP #&1B
 BEQ L694E

 CMP #&7F
 BEQ L6953

 CPY L695D
 BCS L693E

 CMP L695E
 BCC L693E

 CMP L695F
 BCS L693E

 STA INWK+5,Y
 INY
 EQUB &2C

.L693E

 LDA #&07

.L6940

 JSR CHPR

 BCC L691B

.L6945

 STA INWK+5,Y
 LDA #&0C
 JSR CHPR

 EQUB &24

.L694E

 SEC
 PLA
 STA COL
 RTS

.L6953

 TYA
 BEQ L693E

 DEY
 LDA #&7F
 BNE L6940

.L695B

 EQUB &A1

 EQUB &00

.L695D

 EQUB &09

.L695E

 EQUB &21

.L695F

 EQUB &7B

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

.ZERO

 LDX #&3C
 LDA #&00

.ZEL2

 STA FRIN,X
 DEX
 BPL ZEL2

 RTS

.CATS

 JSR GTDRV

 BCS L69A5

 STA L6ACB
 STA DTW7
 LDA #&03
 JSR DETOK

 LDA #&01
 STA CATF
 STA XC
 JSR MASTER_SWAP_ZP_3000

 LDX #&C7
 LDY #&6A
 JSR OSCLI

 JSR MASTER_SWAP_ZP_3000

 STZ CATF
 CLC

.L69A5

 RTS

.DELT

 JSR CATS

 BCS SVE

 LDA L6ACB
 STA L6AD5
 LDA #&08
 JSR DETOK

 JSR MT26

 TYA
 BEQ SVE

 LDX #&09

.DELL1

 LDA INWK+4,X
 STA L6AD6,X
 DEX
 BNE DELL1

 JSR MASTER_SWAP_ZP_3000

 LDX #&CD
 LDY #&6A
 JSR OSCLI

 JSR MASTER_SWAP_ZP_3000

 JMP SVE

.SVE

 TSX
 STX L66B8
 JSR TRADE

 LDA #&01
 JSR DETOK

 JSR t

 CMP #&31
 BEQ MASTER_LOAD

 CMP #&32
 BEQ SV1

 CMP #&33
 BEQ CAT

 CMP #&34
 BNE L69FB

 JSR DELT

 JMP SVE

.L69FB

 CMP #&35
 BNE L6A0F

 LDA #&E0
 JSR DETOK

 JSR L6174

 BCC L6A0F

 JSR L68BB

 JMP DFAULT

.L6A0F

 CLC
 RTS

.CAT

 JSR CATS

 JSR t

 JMP SVE

.MASTER_LOAD

 JSR GTNMEW

 JSR GTDRV

 BCS L6A2C

 STA L6B05
 JSR LOD

 JSR TRNME

 SEC

.L6A2C

 RTS

.SV1

 JSR GTNMEW

 JSR TRNME

 LSR SVC
 LDA #&04
 JSR DETOK

 LDX #&4C

.SVL1

 LDA TP,X
 STA NA%+8,X
 DEX
 BPL SVL1

 JSR CHECK

 STA CHK
 PHA
 ORA #&80
 STA K
 EOR COK
 STA K+2
 EOR CASH+2
 STA K+1
 EOR #&5A
 EOR TALLY+1
 STA K+3
 CLC
 JSR TT67

 JSR TT67

 PLA
 EOR #&A9
 STA CHK2
 LDY #&4C

.L6A71

 LDA NA%+8,Y
 STA L0791,Y
 DEY
 BPL L6A71

 JSR GTDRV

 BCS L6A85

 STA L6AE5
 JSR L6B16

.L6A85

 EQUB &20

 EQUB &DF,&67,&18,&60

.L6A8A

 EQUB &07

.L6A8B

 EQUB &07

.GTDRV

 LDA #&02
 JSR DETOK

 JSR t

 ORA #&10
 JSR CHPR

 PHA
 JSR FEED

 PLA
 CMP #&30
 BCC LOR

 CMP #&34
 RTS

.LOD

 JSR ZEBC

 LDA L0791
 BMI L6ABA

 LDY #&4C

.LOL1

 LDA L0791,Y
 STA NA%+8,Y
 DEY
 BPL LOL1

.LOR

 SEC
 RTS

.L6ABA

 LDA #&09
 JSR DETOK

 JSR t

 JMP SVE

 RTS

 RTS

 EQUS "CAT"

 EQUS " "

.L6ACB

 EQUS "1"

 EQUB &0D

 EQUS "DELE"

 EQUS "TE :"

.L6AD5

 EQUS "1"

.L6AD6

 EQUS ".1234567"

 EQUB &0D

 EQUS "SAVE :"

.L6AE5

 EQUS "1.E."

.L6AE9

 EQUS "JAMESON  E7E +100 0 0"

 EQUB &0D

 EQUS "LOAD :"

.L6B05

 EQUS "1.E."

.L6B09

 EQUS "JAMESON  E7E"

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

 STA L6AE9,Y
 INY
 CPY #&07
 BCC L6B2D

.L6B3C

 LDA #&20
 STA L6AE9,Y
 INY
 CPY #&07
 BCC L6B3C

 JSR MASTER_SWAP_ZP_3000

 LDX #&DF
 LDY #&6A
 JSR OSCLI

 JMP MASTER_SWAP_ZP_3000

.ZEBC

 LDY #&00

.L6B55

 LDA INWK+5,Y
 CMP #&0D
 BEQ L6B64

 STA L6B09,Y
 INY
 CPY #&07
 BCC L6B55

.L6B64

 LDA #&20
 STA L6B09,Y
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

.SPS1

 LDX #&00
 JSR SPS3

 LDX #&03
 JSR SPS3

 LDX #&06
 JSR SPS3

.TAS2

 LDA K3
 ORA K3+3
 ORA K3+6
 ORA #&01
 STA K3+9
 LDA K3+1
 ORA K3+4
 ORA K3+7

.TAL2

 ASL K3+9
 ROL A
 BCS TA2

 ASL K3
 ROL K3+1
 ASL K3+3
 ROL K3+4
 ASL K3+6
 ROL K3+7
 BCC TAL2

.TA2

 LDA K3+1
 LSR A
 ORA K3+2
 STA XX15
 LDA K3+4
 LSR A
 ORA K3+5
 STA Y1
 LDA K3+7
 LSR A
 ORA K3+8
 STA X2

.NORM

 LDA XX15
 JSR SQUA

 STA R
 LDA P
 STA Q
 LDA Y1
 JSR SQUA

 STA T
 LDA P
 ADC Q
 STA Q
 LDA T
 ADC R
 STA R
 LDA X2
 JSR SQUA

 STA T
 LDA P
 ADC Q
 STA Q
 LDA T
 ADC R
 STA R
 JSR LL5

 LDA XX15
 JSR TIS2

 STA XX15
 LDA Y1
 JSR TIS2

 STA Y1
 LDA X2
 JSR TIS2

 STA X2
 RTS

.WARP

 LDX JUNK
 LDA FRIN+2,X
 ORA SSPR
 ORA MJ
 BNE WA1

 LDY L0408
 BMI WA3

 TAY
 JSR MAS2

 CMP #&02
 BCC WA1

.WA3

 LDY L042D
 BMI WA2

 LDY #&25
 JSR m

 CMP #&02
 BCC WA1

.WA2

 LDA #&81
 STA S
 STA R
 STA P
 LDA L0408
 JSR ADD

 STA L0408
 LDA L042D
 JSR ADD

 STA L042D
 LDA #&01
 STA QQ11
 STA MCNT
 LSR A
 STA EV
 LDX VIEW
 JMP LOOK1

.WA1

 JMP BEEP_LONG_LOW

 RTS

.DKS3

 TXA
 CMP L2C62,Y
 BNE Dk3

 LDA DAMP,Y
 EOR #&FF
 STA DAMP,Y
 BPL L6C83

 JSR BELL

.L6C83

 JSR BELL

 TYA
 PHA
 LDY #&14
 JSR DELAY

 PLA
 TAY

.Dk3

 RTS

.DOKEY

 JSR L7ED7

 LDA auto
 BEQ L6CF2

 JSR ZINF

 LDA #&60
 STA INWK+14
 ORA #&80
 STA INWK+22
 STA TYPE
 LDA DELTA
 STA INWK+27
 JSR DOCKIT

 LDA INWK+27
 CMP #&16
 BCC L6CB4

 LDA #&16

.L6CB4

 STA DELTA
 LDA #&FF
 LDX #&0F
 LDY INWK+28
 BEQ DK11

 BMI L6CC2

 LDX #&0B

.L6CC2

 STA KL,X

.DK11

 LDA #&80
 LDX #&0D
 ASL INWK+29
 BEQ DK12

 BCC L6CD0

 LDX #&0E

.L6CD0

 BIT INWK+29
 BPL DK14

 LDA #&40
 STA JSTX
 LDA #&00

.DK14

 STA KL,X
 LDA JSTX

.DK12

 STA JSTX
 LDA #&80
 LDX #&06
 ASL INWK+30
 BEQ DK13

 BCS L6CEC

 LDX #&08

.L6CEC

 STA KL,X
 LDA JSTY

.DK13

 STA JSTY

.L6CF2

 LDA JSTK
 BEQ DK15

 LDA L12A7
 EOR L2C5B
 ORA #&01
 STA JSTX
 LDA L12A8
 EOR #&FF
 EOR L2C5B
 EOR L2C5A
 STA JSTY
 LDA VIA+&40
 AND #&10
 BNE DK4

 LDA #&FF
 STA KY7
 BNE DK4

.DK15

 LDX JSTX
 LDA #&07
 LDY L00D0
 BEQ L6D26

 JSR BUMP2

.L6D26

 LDY L00D1
 BEQ L6D2D

 JSR REDU2

.L6D2D

 STX JSTX
 ASL A
 LDX JSTY
 LDY L00C9
 BEQ L6D39

 JSR REDU2

.L6D39

 LDY L00CB
 BEQ L6D40

 JSR BUMP2

.L6D40

 STX JSTY

.DK4

 LDX KL
 CPX #&8B
 BNE DK2

.FREEZE

 JSR WSCAN

 JSR RDKEY

 CPX #&51
 BNE DK6

 LDX #&FF
 STX L2C55
 LDX #&51

.DK6

 LDY #&00

.DKL4

 JSR DKS3

 INY
 CPY #&09
 BNE DKL4

 LDA L2C61
 CPX #&2E
 BEQ L6D70

 CPX #&2C
 BNE L6D83

 DEC A
 EQUB &24

.L6D70

 INC A
 TAY
 AND #&F8
 BNE L6D79

 STY L2C61

.L6D79

 PHX
 JSR BEEP

 LDY #&0A
 JSR DELAY

 PLX

.L6D83

 CPX #&42
 BNE nobit

 LDA BSTK
 EOR #&FF
 STA BSTK
 STA JSTK
 STA L2C5B
 BPL L6D9A

 JSR BELL

.L6D9A

 JSR BELL

.nobit

 CPX #&53
 BNE DK7

 LDA #&00
 STA L2C55

.DK7

 CPX #&1B
 BNE L6DAD

 JMP DEATH2

.L6DAD

 CPX #&7F
 BNE FREEZE

.DK2

 RTS

.TT217

 STY YSAV

.t

 LDY #&02
 JSR DELAY

 JSR RDKEY

 BNE t

.t2

 JSR RDKEY

 BEQ t2

 LDY YSAV
 TAX

.out

 RTS

.me1

 STX DLY
 PHA
 LDA #&0F
 STA COL
 LDA MCH
 JSR mes9

 PLA

.MESS

 PHA
 LDX QQ11
 BEQ L6DDE

 JSR CLYNS

.L6DDE

 LDA #&15
 STA YC
 LDA #&0F
 STA COL
 LDX #&00
 STX QQ17
 LDA messXC
 STA XC
 PLA
 LDY #&14
 CPX DLY
 BNE me1

 STY DLY
 STA MCH
 LDA #&C0
 STA DTW4
 LDA de
 LSR A
 LDA #&00
 BCC L6E0B

 LDA #&0A

.L6E0B

 STA DTW5
 LDA MCH
 JSR TT27

 LDA #&20
 SEC
 SBC DTW5
 LSR A
 STA messXC
 STA XC
 JSR MT15

 LDA MCH

.mes9

 JSR TT27

 LSR de
 BCC out

 LDA #&FD
 JMP TT27

.OUCH

 JSR DORND

 BMI out

 CPX #&16
 BCS out

 LDA QQ20,X
 BEQ out

 LDA DLY
 BNE out

 LDY #&03
 STY de
 STA QQ20,X
 CPX #&11
 BCS ou1

 TXA
 ADC #&D0
 JMP MESS

.ou1

 BEQ ou2

 CPX #&12
 BEQ ou3

 TXA
 ADC #&5D
 JMP MESS

.ou2

 LDA #&6C
 JMP MESS

.ou3

 LDA #&6F
 JMP MESS

.QQ23

 EQUB &13

.L6E6E

 EQUB &82

.L6E6F

 EQUB &06

.L6E70

 EQUB &01,&14,&81,&0A,&03,&41,&83,&02
 EQUB &07,&28,&85,&E2,&1F,&53,&85,&FB
 EQUB &0F,&C4,&08,&36,&03,&EB,&1D,&08
 EQUB &78,&9A,&0E,&38,&03,&75,&06,&28
 EQUB &07,&4E,&01,&11,&1F,&7C,&0D,&1D
 EQUB &07,&B0,&89,&DC,&3F,&20,&81,&35
 EQUB &03,&61,&A1,&42,&07,&AB,&A2,&37
 EQUB &1F,&2D,&C1,&FA,&0F,&35,&0F,&C0
 EQUB &07

.TI2

 TYA
 LDY #&02
 JSR TIS3

 STA INWK+20
 JMP TI3

.TI1

 TAX
 LDA Y1
 AND #&60
 BEQ TI2

 LDA #&02
 JSR TIS3

 STA INWK+18
 JMP TI3

.TIDY

 LDA INWK+10
 STA XX15
 LDA INWK+12
 STA Y1
 LDA INWK+14
 STA X2
 JSR NORM

 LDA XX15
 STA INWK+10
 LDA Y1
 STA INWK+12
 LDA X2
 STA INWK+14
 LDY #&04
 LDA XX15
 AND #&60
 BEQ TI1

 LDX #&02
 LDA #&00
 JSR TIS3

 STA INWK+16

.TI3

 LDA INWK+16
 STA XX15
 LDA INWK+18
 STA Y1
 LDA INWK+20
 STA X2
 JSR NORM

 LDA XX15
 STA INWK+16
 LDA Y1
 STA INWK+18
 LDA X2
 STA INWK+20
 LDA INWK+12
 STA Q
 LDA INWK+20
 JSR MULT12

 LDX INWK+14
 LDA INWK+18
 JSR TIS1

 EOR #&80
 STA INWK+22
 LDA INWK+16
 JSR MULT12

 LDX INWK+10
 LDA INWK+20
 JSR TIS1

 EOR #&80
 STA INWK+24
 LDA INWK+18
 JSR MULT12

 LDX INWK+12
 LDA INWK+16
 JSR TIS1

 EOR #&80
 STA INWK+26
 LDA #&00
 LDX #&0E

.TIL1

 STA INWK+9,X
 DEX
 DEX
 BPL TIL1

 RTS

.TIS2

 TAY
 AND #&7F
 CMP Q
 BCS TI4

 LDX #&FE
 STX T

.TIL2

 ASL A
 CMP Q
 BCC L6F65

 SBC Q

.L6F65

 ROL T
 BCS TIL2

 LDA T
 LSR A
 LSR A
 STA T
 LSR A
 ADC T
 STA T
 TYA
 AND #&80
 ORA T
 RTS

.TI4

 TYA
 AND #&80
 ORA #&60
 RTS

.TIS3

 STA P+2
 LDA INWK+10,X
 STA Q
 LDA INWK+16,X
 JSR MULT12

 LDX INWK+10,Y
 STX Q
 LDA INWK+16,Y
 JSR MAD

 STX P
 LDY P+2
 LDX INWK+10,Y
 STX Q
 EOR #&80
 STA P+1
 EOR Q
 AND #&80
 STA T
 LDA #&00
 LDX #&10
 ASL P
 ROL P+1
 ASL Q
 LSR Q

.DVL2

 ROL A
 CMP Q
 BCC L6FBA

 SBC Q

.L6FBA

 ROL P
 ROL P+1
 DEX
 BNE DVL2

 LDA P
 ORA T
 RTS

 EQUB &02

 EQUB &0F,&31,&32,&33,&34,&35,&36,&37
 EQUB &38,&39,&30,&31,&32,&33,&34,&35
 EQUB &36,&37

.SHPPT

 JSR PROJ

 ORA K3+1
 BNE nono

 LDA K4
 CMP #&BE
 BCS nono

 JSR Shpt

 LDA K4
 CLC
 ADC #&01
 JSR Shpt

 LDA #&08
 ORA INWK+31
 STA INWK+31
 JMP LL155

.nono

 LDA #&F7
 AND INWK+31
 STA INWK+31
 JMP LL155

.Shpt

 STA Y1
 STA Y2
 LDA K3
 STA XX15
 CLC
 ADC #&03
 BCC L7012

 LDA #&FF

.L7012

 STA X2
 JMP L78F8

.LL5

 LDY R
 LDA Q
 STA S
 LDX #&00
 STX Q
 LDA #&08
 STA T

.LL6

 CPX Q
 BCC LL7

 BNE LL8

 CPY #&40
 BCC LL7

.LL8

 TYA
 SBC #&40
 TAY
 TXA
 SBC Q
 TAX

.LL7

 ROL Q
 ASL S
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 ASL S
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 DEC T
 BNE LL6

 RTS

.LL28

 CMP Q
 BCS LL2

 STA widget
 TAX
 BEQ LLfix

 LDA logL,X
 LDX Q
 SEC
 SBC logL,X
 LDX widget
 LDA log,X
 LDX Q
 SBC log,X
 BCS LL2

 TAX
 LDA antilog,X

.LLfix

 STA R
 RTS

 BCS LL2

 LDX #&FE
 STX R

.LL31

 ASL A
 BCS LL29

 CMP Q
 BCC L7082

 SBC Q

.L7082

 ROL R
 BCS LL31

 RTS

.LL29

 SBC Q
 SEC
 ROL R
 BCS LL31

 LDA R
 RTS

.LL2

 LDA #&FF
 STA R
 RTS

.LL38

 EOR S
 BMI LL39

 LDA Q
 CLC
 ADC R
 RTS

.LL39

 LDA R
 SEC
 SBC Q
 BCC L70A9

 CLC
 RTS

.L70A9

 PHA
 LDA S
 EOR #&80
 STA S
 PLA
 EOR #&FF
 ADC #&01
 RTS

.LL51

 LDX #&00
 LDY #&00

.ll51

 LDA XX15
 STA Q
 LDA XX16,X
 JSR FMLTU

 STA T
 LDA Y1
 EOR XX16+1,X
 STA S
 LDA X2
 STA Q
 LDA XX16+2,X
 JSR FMLTU

 STA Q
 LDA T
 STA R
 LDA Y2
 EOR XX16+3,X
 JSR LL38

 STA T
 LDA XX15+4
 STA Q
 LDA XX16+4,X
 JSR FMLTU

 STA Q
 LDA T
 STA R
 LDA XX15+5
 EOR XX16+5,X
 JSR LL38

 STA XX12,Y
 LDA S
 STA XX12+1,Y
 INY
 INY
 TXA
 CLC
 ADC #&06
 TAX
 CMP #&11
 BCC ll51

 RTS

.LL25

 JMP PLANET

.LL9

 LDX TYPE
 BMI LL25

 LDA shpcol,X
 STA COL
 LDA #&1F
 STA XX4
 LDY #&01
 STY XX14
 DEY
 LDA #&08
 BIT INWK+31
 BNE L712B

 LDA #&00
 EQUB &2C

.L712B

 LDA (XX19),Y
 STA XX14+1
 LDA NEWB
 BMI EE51

 LDA #&20
 BIT INWK+31
 BNE EE28

 BPL EE28

 ORA INWK+31
 AND #&3F
 STA INWK+31
 LDA #&00
 LDY #&1C
 STA (INF),Y
 LDY #&1E
 STA (INF),Y
 JSR EE51

 LDY #&01
 LDA #&12
 STA (XX19),Y
 LDY #&07
 LDA (XX0),Y
 LDY #&02
 STA (XX19),Y

.EE55

 INY
 JSR DORND

 STA (XX19),Y
 CPY #&06
 BNE EE55

.EE28

 LDA INWK+8
 BPL LL10

.LL14

 LDA INWK+31
 AND #&20
 BEQ EE51

 LDA INWK+31
 AND #&F7
 STA INWK+31
 JMP DOEXP

.EE51

 LDA #&08
 BIT INWK+31
 BEQ L7186

 EOR INWK+31
 STA INWK+31
 JMP LL155

.L7186

 RTS

.LL10

 LDA INWK+7
 CMP #&C0
 BCS LL14

 LDA INWK
 CMP INWK+6
 LDA INWK+1
 SBC INWK+7
 BCS LL14

 LDA INWK+3
 CMP INWK+6
 LDA INWK+4
 SBC INWK+7
 BCS LL14

 LDY #&06
 LDA (XX0),Y
 TAX
 LDA #&FF
 STA XX3,X
 STA XX3+1,X
 LDA INWK+6
 STA T
 LDA INWK+7
 LSR A
 ROR T
 LSR A
 ROR T
 LSR A
 ROR T
 LSR A
 BNE LL13

 LDA T
 ROR A
 LSR A
 LSR A
 LSR A
 STA XX4
 BPL LL17

.LL13

 LDY #&0D
 LDA (XX0),Y
 CMP INWK+7
 BCS LL17

 LDA #&20
 AND INWK+31
 BNE LL17

 JMP SHPPT

.LL17

 LDX #&05

.LL15

 LDA INWK+21,X
 STA XX16,X
 LDA INWK+15,X
 STA XX16+6,X
 LDA INWK+9,X
 STA XX16+12,X
 DEX
 BPL LL15

 LDA #&C5
 STA Q
 LDY #&10

.LL21

 LDA XX16,Y
 ASL A
 LDA XX16+1,Y
 ROL A
 JSR LL28

 LDX R
 STX XX16,Y
 DEY
 DEY
 BPL LL21

 LDX #&08

.ll91

 LDA INWK,X
 STA XX18,X
 DEX
 BPL ll91

 LDA #&FF
 STA K4+1
 LDY #&0C
 LDA INWK+31
 AND #&20
 BEQ EE29

 LDA (XX0),Y
 LSR A
 LSR A
 TAX
 LDA #&FF

.EE30

 STA K3,X
 DEX
 BPL EE30

 INX
 STX XX4

.LL41

 JMP LL42

.EE29

 LDA (XX0),Y
 BEQ LL41

 STA XX20
 LDY #&12
 LDA (XX0),Y
 TAX
 LDA XX18+7
 TAY
 BEQ LL91

.L723C

 INX
 LSR XX18+4
 ROR XX18+3
 LSR XX18+1
 ROR XX18
 LSR A
 ROR XX18+6
 TAY
 BNE L723C

.LL91

 STX XX17
 LDA XX18+8
 STA XX15+5
 LDA XX18
 STA XX15
 LDA XX18+2
 STA Y1
 LDA XX18+3
 STA X2
 LDA XX18+5
 STA Y2
 LDA XX18+6
 STA XX15+4
 JSR LL51

 LDA XX12
 STA XX18
 LDA XX12+1
 STA XX18+2
 LDA XX12+2
 STA XX18+3
 LDA XX12+3
 STA XX18+5
 LDA XX12+4
 STA XX18+6
 LDA XX12+5
 STA XX18+8
 LDY #&04
 LDA (XX0),Y
 CLC
 ADC XX0
 STA V
 LDY #&11
 LDA (XX0),Y
 ADC XX0+1
 STA V+1
 LDY #&00

.LL86

 LDA (V),Y
 STA XX12+1
 AND #&1F
 CMP XX4
 BCS LL87

 TYA
 LSR A
 LSR A
 TAX
 LDA #&FF
 STA K3,X
 TYA
 ADC #&04
 TAY
 JMP LL88

.LL87

 LDA XX12+1
 ASL A
 STA XX12+3
 ASL A
 STA XX12+5
 INY
 LDA (V),Y
 STA XX12
 INY
 LDA (V),Y
 STA XX12+2
 INY
 LDA (V),Y
 STA XX12+4
 LDX XX17
 CPX #&04
 BCC LL92

 LDA XX18
 STA XX15
 LDA XX18+2
 STA Y1
 LDA XX18+3
 STA X2
 LDA XX18+5
 STA Y2
 LDA XX18+6
 STA XX15+4
 LDA XX18+8
 STA XX15+5
 JMP LL89

.ovflw

 LSR XX18
 LSR XX18+6
 LSR XX18+3
 LDX #&01

.LL92

 LDA XX12
 STA XX15
 LDA XX12+2
 STA X2
 LDA XX12+4
 DEX
 BMI LL94

.L72F9

 LSR XX15
 LSR X2
 LSR A
 DEX
 BPL L72F9

.LL94

 STA R
 LDA XX12+5
 STA S
 LDA XX18+6
 STA Q
 LDA XX18+8
 JSR LL38

 BCS ovflw

 STA XX15+4
 LDA S
 STA XX15+5
 LDA XX15
 STA R
 LDA XX12+1
 STA S
 LDA XX18
 STA Q
 LDA XX18+2
 JSR LL38

 BCS ovflw

 STA XX15
 LDA S
 STA Y1
 LDA X2
 STA R
 LDA XX12+3
 STA S
 LDA XX18+3
 STA Q
 LDA XX18+5
 JSR LL38

 BCS ovflw

 STA X2
 LDA S
 STA Y2

.LL89

 LDA XX12
 STA Q
 LDA XX15
 JSR FMLTU

 STA T
 LDA XX12+1
 EOR Y1
 STA S
 LDA XX12+2
 STA Q
 LDA X2
 JSR FMLTU

 STA Q
 LDA T
 STA R
 LDA XX12+3
 EOR Y2
 JSR LL38

 STA T
 LDA XX12+4
 STA Q
 LDA XX15+4
 JSR FMLTU

 STA Q
 LDA T
 STA R
 LDA XX15+5
 EOR XX12+5
 JSR LL38

 PHA
 TYA
 LSR A
 LSR A
 TAX
 PLA
 BIT S
 BMI L7395

 LDA #&00

.L7395

 STA K3,X
 INY

.LL88

 CPY XX20
 BCS LL42

 JMP LL86

.LL42

 LDY XX16+2
 LDX XX16+3
 LDA XX16+6
 STA XX16+2
 LDA XX16+7
 STA XX16+3
 STY XX16+6
 STX XX16+7
 LDY XX16+4
 LDX XX16+5
 LDA XX16+12
 STA XX16+4
 LDA XX16+13
 STA XX16+5
 STY XX16+12
 STX XX16+13
 LDY XX16+10
 LDX XX16+11
 LDA XX16+14
 STA XX16+10
 LDA XX16+15
 STA XX16+11
 STY XX16+14
 STX XX16+15
 LDY #&08
 LDA (XX0),Y
 STA XX20
 LDA XX0
 CLC
 ADC #&14
 STA V
 LDA XX0+1
 ADC #&00
 STA V+1
 LDY #&00
 STY CNT

.LL48

 STY XX17
 LDA (V),Y
 STA XX15
 INY
 LDA (V),Y
 STA X2
 INY
 LDA (V),Y
 STA XX15+4
 INY
 LDA (V),Y
 STA T
 AND #&1F
 CMP XX4
 BCC L742F

 INY
 LDA (V),Y
 STA P
 AND #&0F
 TAX
 LDA K3,X
 BNE LL49

 LDA P
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA K3,X
 BNE LL49

 INY
 LDA (V),Y
 STA P
 AND #&0F
 TAX
 LDA K3,X
 BNE LL49

 LDA P
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA K3,X
 BNE LL49

.L742F

 JMP LL50

.LL49

 LDA T
 STA Y1
 ASL A
 STA Y2
 ASL A
 STA XX15+5
 JSR LL51

 LDA INWK+2
 STA X2
 EOR XX12+1
 BMI LL52

 CLC
 LDA XX12
 ADC INWK
 STA XX15
 LDA INWK+1
 ADC #&00
 STA Y1
 JMP LL53

.LL52

 LDA INWK
 SEC
 SBC XX12
 STA XX15
 LDA INWK+1
 SBC #&00
 STA Y1
 BCS LL53

 EOR #&FF
 STA Y1
 LDA #&01
 SBC XX15
 STA XX15
 BCC L7474

 INC Y1

.L7474

 LDA X2
 EOR #&80
 STA X2

.LL53

 LDA INWK+5
 STA XX15+5
 EOR XX12+3
 BMI LL54

 CLC
 LDA XX12+2
 ADC INWK+3
 STA Y2
 LDA INWK+4
 ADC #&00
 STA XX15+4
 JMP LL55

.LL54

 LDA INWK+3
 SEC
 SBC XX12+2
 STA Y2
 LDA INWK+4
 SBC #&00
 STA XX15+4
 BCS LL55

 EOR #&FF
 STA XX15+4
 LDA Y2
 EOR #&FF
 ADC #&01
 STA Y2
 LDA XX15+5
 EOR #&80
 STA XX15+5
 BCC LL55

 INC XX15+4

.LL55

 LDA XX12+5
 BMI LL56

 LDA XX12+4
 CLC
 ADC INWK+6
 STA T
 LDA INWK+7
 ADC #&00
 STA U
 JMP LL57

.LL61

 LDX Q
 BEQ LL84

 LDX #&00

.LL63

 LSR A
 INX
 CMP Q
 BCS LL63

 STX S
 JSR LL28

 LDX S
 LDA R

.LL64

 ASL A
 ROL U
 BMI LL84

 DEX
 BNE LL64

 STA R
 RTS

.LL84

 LDA #&32
 STA R
 STA U
 RTS

.LL62

 LDA #&80
 SEC
 SBC R
 STA XX3,X
 INX
 LDA #&00
 SBC U
 STA XX3,X
 JMP LL66

.LL56

 LDA INWK+6
 SEC
 SBC XX12+4
 STA T
 LDA INWK+7
 SBC #&00
 STA U
 BCC LL140

 BNE LL57

 LDA T
 CMP #&04
 BCS LL57

.LL140

 LDA #&00
 STA U
 LDA #&04
 STA T

.LL57

 LDA U
 ORA Y1
 ORA XX15+4
 BEQ LL60

 LSR Y1
 ROR XX15
 LSR XX15+4
 ROR Y2
 LSR U
 ROR T
 JMP LL57

.LL60

 LDA T
 STA Q
 LDA XX15
 CMP Q
 BCC LL69

 JSR LL61

 JMP LL65

.LL69

 JSR LL28

.LL65

 LDX CNT
 LDA X2
 BMI LL62

 LDA R
 CLC
 ADC #&80
 STA XX3,X
 INX
 LDA U
 ADC #&00
 STA XX3,X

.LL66

 TXA
 PHA
 LDA #&00
 STA U
 LDA T
 STA Q
 LDA Y2
 CMP Q
 BCC LL67

 JSR LL61

 JMP LL68

.LL70

 LDA #&60
 CLC
 ADC R
 STA XX3,X
 INX
 LDA #&00
 ADC U
 STA XX3,X
 JMP LL50

.LL67

 JSR LL28

.LL68

 PLA
 TAX
 INX
 LDA XX15+5
 BMI LL70

 LDA #&60
 SEC
 SBC R
 STA XX3,X
 INX
 LDA #&00
 SBC U
 STA XX3,X

.LL50

 CLC
 LDA CNT
 ADC #&04
 STA CNT
 LDA XX17
 ADC #&06
 TAY
 BCS LL72

 CMP XX20
 BCS LL72

 JMP LL48

.LL72

 LDA INWK+31
 AND #&20
 BEQ EE31

 LDA INWK+31
 ORA #&08
 STA INWK+31
 JMP DOEXP

.EE31

 LDY #&09
 LDA (XX0),Y
 STA XX20
 LDA #&08
 ORA INWK+31
 STA INWK+31
 LDY #&00
 STY XX17
 BIT INWK+31
 BVC LL170

 LDA INWK+31
 AND #&BF
 STA INWK+31
 LDY #&06
 LDA (XX0),Y
 TAY
 LDX XX3,Y
 STX XX15
 INX
 BEQ LL170

 LDX XX3+1,Y
 STX Y1
 INX
 BEQ LL170

 LDX XX3+2,Y
 STX X2
 LDX XX3+3,Y
 STX Y2
 LDA #&00
 STA XX15+4
 STA XX15+5
 STA XX12+1
 LDA INWK+6
 STA XX12
 LDA INWK+2
 BPL L7616

 DEC XX15+4

.L7616

 JSR LL145

 BCS LL170

 JSR L78F8

.LL170

 LDY #&03
 CLC
 LDA (XX0),Y
 ADC XX0
 STA V
 LDY #&10
 LDA (XX0),Y
 ADC XX0+1
 STA V+1
 LDY #&05
 LDA (XX0),Y
 STA CNT

.LL75

 LDY #&00
 LDA (V),Y
 CMP XX4
 BCC LL78

 INY
 LDA (V),Y
 STA P
 AND #&0F
 TAX
 LDA K3,X
 BNE LL79

 LDA P
 LSR A
 LSR A
 LSR A
 LSR A
 TAX
 LDA K3,X
 BEQ LL78

.LL79

 INY
 LDA (V),Y
 TAX
 LDA XX3,X
 STA XX15
 LDA XX3+1,X
 STA Y1
 LDA XX3+2,X
 STA X2
 LDA XX3+3,X
 STA Y2
 INY
 LDA (V),Y
 TAX
 LDA XX3,X
 STA XX15+4
 LDA XX3+2,X
 STA XX12
 LDA XX3+3,X
 STA XX12+1
 LDA XX3+1,X
 STA XX15+5
 JSR LL147

 BCS LL78

 JSR L78F8

.LL78

 LDA XX14
 CMP CNT
 BCS LL81

 LDA V
 CLC
 ADC #&04
 STA V
 BCC ll81

 INC V+1

.ll81

 INC XX17
 LDY XX17
 CPY XX20
 BCC LL75

.LL81

 JMP LL155

.LL118

 LDA Y1
 BPL LL119

 STA S
 JSR LL120

 TXA
 CLC
 ADC X2
 STA X2
 TYA
 ADC Y2
 STA Y2
 LDA #&00
 STA XX15
 STA Y1
 TAX

.LL119

 BEQ LL134

 STA S
 DEC S
 JSR LL120

 TXA
 CLC
 ADC X2
 STA X2
 TYA
 ADC Y2
 STA Y2
 LDX #&FF
 STX XX15
 INX
 STX Y1

.LL134

 LDA Y2
 BPL LL135

 STA S
 LDA X2
 STA R
 JSR LL123

 TXA
 CLC
 ADC XX15
 STA XX15
 TYA
 ADC Y1
 STA Y1
 LDA #&00
 STA X2
 STA Y2

.LL135

 LDA X2
 SEC
 SBC #&C0
 STA R
 LDA Y2
 SBC #&00
 STA S
 BCC LL136

 JSR LL123

 TXA
 CLC
 ADC XX15
 STA XX15
 TYA
 ADC Y1
 STA Y1
 LDA #&BF
 STA X2
 LDA #&00
 STA Y2

.LL136

 RTS

.LL120

 LDA XX15
 STA R
 JSR LL129

 PHA
 LDX T
 BNE LL121

.LL122

 LDA #&00
 TAX
 TAY
 LSR S
 ROR R
 ASL Q
 BCC LL126

.LL125

 TXA
 CLC
 ADC R
 TAX
 TYA
 ADC S
 TAY

.LL126

 LSR S
 ROR R
 ASL Q
 BCS LL125

 BNE LL126

 PLA
 BPL LL133

 RTS

.LL123

 JSR LL129

 PHA
 LDX T
 BNE LL122

.LL121

 LDA #&FF
 TAY
 ASL A
 TAX

.LL130

 ASL R
 ROL S
 LDA S
 BCS LL131

 CMP Q
 BCC LL132

.LL131

 SBC Q
 STA S
 LDA R
 SBC #&00
 STA R
 SEC

.LL132

 TXA
 ROL A
 TAX
 TYA
 ROL A
 TAY
 BCS LL130

 PLA
 BMI LL128

.LL133

 TXA
 EOR #&FF
 ADC #&01
 TAX
 TYA
 EOR #&FF
 ADC #&00
 TAY

.LL128

 RTS

.LL129

 LDX XX12+2
 STX Q
 LDA S
 BPL LL127

 LDA #&00
 SEC
 SBC R
 STA R
 LDA S
 PHA
 EOR #&FF
 ADC #&00
 STA S
 PLA

.LL127

 EOR XX12+3
 RTS

.LL145

 LDA #&00
 STA SWAP
 LDA XX15+5

.LL147

 LDX #&BF
 ORA XX12+1
 BNE LL107

 CPX XX12
 BCC LL107

 LDX #&00

.LL107

 STX XX13
 LDA Y1
 ORA Y2
 BNE LL83

 LDA #&BF
 CMP X2
 BCC LL83

 LDA XX13
 BNE LL108

.LL146

 LDA X2
 STA Y1
 LDA XX15+4
 STA X2
 LDA XX12
 STA Y2
 CLC
 RTS

.LL109

 SEC
 RTS

.LL108

 LSR XX13

.LL83

 LDA XX13
 BPL LL115

 LDA Y1
 AND XX15+5
 BMI LL109

 LDA Y2
 AND XX12+1
 BMI LL109

 LDX Y1
 DEX
 TXA
 LDX XX15+5
 DEX
 STX XX12+2
 ORA XX12+2
 BPL LL109

 LDA X2
 CMP #&C0
 LDA Y2
 SBC #&00
 STA XX12+2
 LDA XX12
 CMP #&C0
 LDA XX12+1
 SBC #&00
 ORA XX12+2
 BPL LL109

.LL115

 TYA
 PHA
 LDA XX15+4
 SEC
 SBC XX15
 STA XX12+2
 LDA XX15+5
 SBC Y1
 STA XX12+3
 LDA XX12
 SEC
 SBC X2
 STA XX12+4
 LDA XX12+1
 SBC Y2
 STA XX12+5
 EOR XX12+3
 STA S
 LDA XX12+5
 BPL LL110

 LDA #&00
 SEC
 SBC XX12+4
 STA XX12+4
 LDA #&00
 SBC XX12+5
 STA XX12+5

.LL110

 LDA XX12+3
 BPL LL111

 SEC
 LDA #&00
 SBC XX12+2
 STA XX12+2
 LDA #&00
 SBC XX12+3

.LL111

 TAX
 BNE LL112

 LDX XX12+5
 BEQ LL113

.LL112

 LSR A
 ROR XX12+2
 LSR XX12+5
 ROR XX12+4
 JMP LL111

.LL113

 STX T
 LDA XX12+2
 CMP XX12+4
 BCC LL114

 STA Q
 LDA XX12+4
 JSR LL28

 JMP LL116

.LL114

 LDA XX12+4
 STA Q
 LDA XX12+2
 JSR LL28

 DEC T

.LL116

 LDA R
 STA XX12+2
 LDA S
 STA XX12+3
 LDA XX13
 BEQ LL138

 BPL LLX117

.LL138

 JSR LL118

 LDA XX13
 BPL LL124

 LDA Y1
 ORA Y2
 BNE LL137

 LDA X2
 CMP #&C0
 BCS LL137

.LLX117

 LDX XX15
 LDA XX15+4
 STA XX15
 STX XX15+4
 LDA XX15+5
 LDX Y1
 STX XX15+5
 STA Y1
 LDX X2
 LDA XX12
 STA X2
 STX XX12
 LDA XX12+1
 LDX Y2
 STX XX12+1
 STA Y2
 JSR LL118

 DEC SWAP

.LL124

 PLA
 TAY
 JMP LL146

.LL137

 PLA
 TAY
 SEC
 RTS

.LL155

 LDY XX14

.L78D3

 CPY XX14+1
 BCS L78F1

 LDA (XX19),Y
 INY
 STA XX15
 LDA (XX19),Y
 INY
 STA Y1
 LDA (XX19),Y
 INY
 STA X2
 LDA (XX19),Y
 INY
 STA Y2
 JSR LL30

 JMP L78D3

.L78F1

 LDA XX14
 LDY #&00
 STA (XX19),Y

.L78F7

 RTS

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

.MVEIT

 LDA INWK+31
 AND #&A0
 BNE MV30

 LDA MCNT
 EOR XSAV
 AND #&0F
 BNE MV3

 JSR TIDY

.MV3

 LDX TYPE
 BPL L794D

 JMP MV40

.L794D

 LDA INWK+32
 BPL MV30

 CPX #&01
 BEQ MV26

 LDA MCNT
 EOR XSAV
 AND #&07
 BNE MV30

.MV26

 JSR TACTICS

.MV30

 JSR SCAN

 LDA INWK+27
 ASL A
 ASL A
 STA Q
 LDA INWK+10
 AND #&7F
 JSR FMLTU

 STA R
 LDA INWK+10
 LDX #&00
 JSR L7ADF

 LDA INWK+12
 AND #&7F
 JSR FMLTU

 STA R
 LDA INWK+12
 LDX #&03
 JSR L7ADF

 LDA INWK+14
 AND #&7F
 JSR FMLTU

 STA R
 LDA INWK+14
 LDX #&06
 JSR L7ADF

 LDA INWK+27
 CLC
 ADC INWK+28
 BPL L79A2

 LDA #&00

.L79A2

 LDY #&0F
 CMP (XX0),Y
 BCC L79AA

 LDA (XX0),Y

.L79AA

 STA INWK+27
 LDA #&00
 STA INWK+28
 LDX ALP1
 LDA INWK
 EOR #&FF
 STA P
 LDA INWK+1
 JSR MLTU2-2

 STA P+2
 LDA ALP2+1
 EOR INWK+2
 LDX #&03
 JSR MVT6

 STA K2+3
 LDA P+1
 STA K2+1
 EOR #&FF
 STA P
 LDA P+2
 STA K2+2
 LDX BET1
 JSR MLTU2-2

 STA P+2
 LDA K2+3
 EOR BET2
 LDX #&06
 JSR MVT6

 STA INWK+8
 LDA P+1
 STA INWK+6
 EOR #&FF
 STA P
 LDA P+2
 STA INWK+7
 JSR MLTU2

 STA P+2
 LDA K2+3
 STA INWK+5
 EOR BET2
 EOR INWK+8
 BPL MV43

 LDA P+1
 ADC K2+1
 STA INWK+3
 LDA P+2
 ADC K2+2
 STA INWK+4
 JMP MV44

.MV43

 LDA K2+1
 SBC P+1
 STA INWK+3
 LDA K2+2
 SBC P+2
 STA INWK+4
 BCS MV44

 LDA #&01
 SBC INWK+3
 STA INWK+3
 LDA #&00
 SBC INWK+4
 STA INWK+4
 LDA INWK+5
 EOR #&80
 STA INWK+5

.MV44

 LDX ALP1
 LDA INWK+3
 EOR #&FF
 STA P
 LDA INWK+4
 JSR MLTU2-2

 STA P+2
 LDA ALP2
 EOR INWK+5
 LDX #&00
 JSR MVT6

 STA INWK+2
 LDA P+2
 STA INWK+1
 LDA P+1
 STA INWK

.MV45

 LDA DELTA
 STA R
 LDA #&80
 LDX #&06
 JSR MVT1

 LDA TYPE
 AND #&81
 CMP #&81
 BNE L7A68

 RTS

.L7A68

 LDY #&09
 JSR MVS4

 LDY #&0F
 JSR MVS4

 LDY #&15
 JSR MVS4

 LDA INWK+30
 AND #&80
 STA RAT2
 LDA INWK+30
 AND #&7F
 BEQ MV8

 CMP #&7F
 SBC #&00
 ORA RAT2
 STA INWK+30
 LDX #&0F
 LDY #&09
 JSR MVS5

 LDX #&11
 LDY #&0B
 JSR MVS5

 LDX #&13
 LDY #&0D
 JSR MVS5

.MV8

 LDA INWK+29
 AND #&80
 STA RAT2
 LDA INWK+29
 AND #&7F
 BEQ MV5

 CMP #&7F
 SBC #&00
 ORA RAT2
 STA INWK+29
 LDX #&0F
 LDY #&15
 JSR MVS5

 LDX #&11
 LDY #&17
 JSR MVS5

 LDX #&13
 LDY #&19
 JSR MVS5

.MV5

 LDA INWK+31
 AND #&A0
 BNE MVD1

 LDA INWK+31
 ORA #&10
 STA INWK+31
 JMP SCAN

.MVD1

 LDA INWK+31
 AND #&EF
 STA INWK+31
 RTS

.L7ADF

 AND #&80

.MVT1

 ASL A
 STA S
 LDA #&00
 ROR A
 STA T
 LSR S
 EOR INWK+2,X
 BMI MV10

 LDA R
 ADC INWK,X
 STA INWK,X
 LDA S
 ADC INWK+1,X
 STA INWK+1,X
 LDA INWK+2,X
 ADC #&00
 ORA T
 STA INWK+2,X
 RTS

.MV10

 LDA INWK,X
 SEC
 SBC R
 STA INWK,X
 LDA INWK+1,X
 SBC S
 STA INWK+1,X
 LDA INWK+2,X
 AND #&7F
 SBC #&00
 ORA #&80
 EOR T
 STA INWK+2,X
 BCS MV11

 LDA #&01
 SBC INWK,X
 STA INWK,X
 LDA #&00
 SBC INWK+1,X
 STA INWK+1,X
 LDA #&00
 SBC INWK+2,X
 AND #&7F
 ORA T
 STA INWK+2,X

.MV11

 RTS

.MVS4

 LDA ALPHA
 STA Q
 LDX INWK+2,Y
 STX R
 LDX INWK+3,Y
 STX S
 LDX INWK,Y
 STX P
 LDA INWK+1,Y
 EOR #&80
 JSR MAD

 STA INWK+3,Y
 STX INWK+2,Y
 STX P
 LDX INWK,Y
 STX R
 LDX INWK+1,Y
 STX S
 LDA INWK+3,Y
 JSR MAD

 STA INWK+1,Y
 STX INWK,Y
 STX P
 LDA BETA
 STA Q
 LDX INWK+2,Y
 STX R
 LDX INWK+3,Y
 STX S
 LDX INWK+4,Y
 STX P
 LDA INWK+5,Y
 EOR #&80
 JSR MAD

 STA INWK+3,Y
 STX INWK+2,Y
 STX P
 LDX INWK+4,Y
 STX R
 LDX INWK+5,Y
 STX S
 LDA INWK+3,Y
 JSR MAD

 STA INWK+5,Y
 STX INWK+4,Y
 RTS

.MVT6

 TAY
 EOR INWK+2,X
 BMI MV50

 LDA P+1
 CLC
 ADC INWK,X
 STA P+1
 LDA P+2
 ADC INWK+1,X
 STA P+2
 TYA
 RTS

.MV50

 LDA INWK,X
 SEC
 SBC P+1
 STA P+1
 LDA INWK+1,X
 SBC P+2
 STA P+2
 BCC MV51

 TYA
 EOR #&80
 RTS

.MV51

 LDA #&01
 SBC P+1
 STA P+1
 LDA #&00
 SBC P+2
 STA P+2
 TYA
 RTS

.MV40

 LDA ALPHA
 EOR #&80
 STA Q
 LDA INWK
 STA P
 LDA INWK+1
 STA P+1
 LDA INWK+2
 JSR MULT3

 LDX #&03
 JSR MVT3

 LDA K+1
 STA K2+1
 STA P
 LDA K+2
 STA K2+2
 STA P+1
 LDA BETA
 STA Q
 LDA K+3
 STA K2+3
 JSR MULT3

 LDX #&06
 JSR MVT3

 LDA K+1
 STA P
 STA INWK+6
 LDA K+2
 STA P+1
 STA INWK+7
 LDA K+3
 STA INWK+8
 EOR #&80
 JSR MULT3

 LDA K+3
 AND #&80
 STA T
 EOR K2+3
 BMI MV1

 LDA K
 CLC
 ADC K2
 LDA K+1
 ADC K2+1
 STA INWK+3
 LDA K+2
 ADC K2+2
 STA INWK+4
 LDA K+3
 ADC K2+3
 JMP MV2

.MV1

 LDA K
 SEC
 SBC K2
 LDA K+1
 SBC K2+1
 STA INWK+3
 LDA K+2
 SBC K2+2
 STA INWK+4
 LDA K2+3
 AND #&7F
 STA P
 LDA K+3
 AND #&7F
 SBC P
 STA P
 BCS MV2

 LDA #&01
 SBC INWK+3
 STA INWK+3
 LDA #&00
 SBC INWK+4
 STA INWK+4
 LDA #&00
 SBC P
 ORA #&80

.MV2

 EOR T
 STA INWK+5
 LDA ALPHA
 STA Q
 LDA INWK+3
 STA P
 LDA INWK+4
 STA P+1
 LDA INWK+5
 JSR MULT3

 LDX #&00
 JSR MVT3

 LDA K+1
 STA INWK
 LDA K+2
 STA INWK+1
 LDA K+3
 STA INWK+2
 JMP MV45

.PLUT

 LDX VIEW
 BEQ L7CD1

 DEX
 BNE PU2

 LDA INWK+2
 EOR #&80
 STA INWK+2
 LDA INWK+8
 EOR #&80
 STA INWK+8
 LDA INWK+10
 EOR #&80
 STA INWK+10
 LDA INWK+14
 EOR #&80
 STA INWK+14
 LDA INWK+16
 EOR #&80
 STA INWK+16
 LDA INWK+20
 EOR #&80
 STA INWK+20
 LDA INWK+22
 EOR #&80
 STA INWK+22
 LDA INWK+26
 EOR #&80
 STA INWK+26

.L7CD1

 RTS

.PU2

 LDA #&00
 CPX #&02
 ROR A
 STA RAT2
 EOR #&80
 STA RAT
 LDA INWK
 LDX INWK+6
 STA INWK+6
 STX INWK
 LDA INWK+1
 LDX INWK+7
 STA INWK+7
 STX INWK+1
 LDA INWK+2
 EOR RAT
 TAX
 LDA INWK+8
 EOR RAT2
 STA INWK+2
 STX INWK+8
 LDY #&09
 JSR PUS1

 LDY #&0F
 JSR PUS1

 LDY #&15

.PUS1

 LDA INWK,Y
 LDX INWK+4,Y
 STA INWK+4,Y
 STX INWK,Y
 LDA INWK+1,Y
 EOR RAT
 TAX
 LDA INWK+5,Y
 EOR RAT2
 STA INWK+1,Y
 STX INWK+5,Y

.LO2

 RTS

.LQ

 STX VIEW
 JSR TT66

 JSR SIGHT

 LDA BOMB
 BPL L7D32

 JSR L31AC

.L7D32

 JMP NWSTARS

.LOOK1

 LDA #&00
 JSR SETVDU19

 LDY QQ11
 BNE LQ

 CPX VIEW
 BEQ LO2

 STX VIEW
 JSR TT66

 JSR FLIP

 LDA BOMB
 BPL L7D54

 JSR L31AC

.L7D54

 JSR WPSHPS

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

