\ ******************************************************************************
\
\ ELECTRON ELITE GAME SOURCE
\
\ Electron Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
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
\ This source file produces the following binary files:
\
\   * output/ELTA.bin
\   * output/ELTB.bin
\   * output/ELTC.bin
\   * output/ELTD.bin
\   * output/ELTE.bin
\   * output/ELTF.bin
\   * output/ELTG.bin
\   * output/SHIPS.bin
\   * output/WORDS9.bin
\
\ ******************************************************************************

INCLUDE "versions/electron/sources/elite-header.h.asm"

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

NOST = 10               \ The number of stardust particles in normal space

NOSH = 12               \ The maximum number of ships in our local bubble of
                        \ universe

NTY = 11                \ The number of different ship types

COPS = 2                \ Ship type for a Viper
CYL = 6                 \ Ship type for a Cobra Mk III (trader)
SST = 7                 \ Ship type for the space station
MSL = 8                 \ Ship type for a missile
AST = 9                \ Ship type for an asteroid
OIL = 10                \ Ship type for a cargo canister
ESC = 11                \ Ship type for an escape pod

POW = 15                \ Pulse laser power

NI% = 36                \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

OSBYTE = &FFF4          \ The address for the OSBYTE routine

OSWORD = &FFF1          \ The address for the OSWORD routine

OSRDCH  = $FFE0         \ The address for the OSRDCH routine

OSFILE = &FFDD          \ The address for the OSFILE routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

X = 128                 \ The centre x-coordinate of the 256 x 192 space view
Y = 96                  \ The centre y-coordinate of the 256 x 192 space view

f0 = &B0                \ Internal key number for red key f0 (Launch, Front)
f1 = &B1                \ Internal key number for red key f1 (Buy Cargo, Rear)
f2 = &91                \ Internal key number for red key f2 (Sell Cargo, Left)
f3 = &92                \ Internal key number for red key f3 (Equip Ship, Right)
f4 = &93                \ Internal key number for red key f4 (Long-range Chart)
f5 = &B4                \ Internal key number for red key f5 (Short-range Chart)
f6 = &A4                \ Internal key number for red key f6 (Data on System)
f7 = &95                \ Internal key number for red key f7 (Market Price)
f8 = &A6                \ Internal key number for red key f8 (Status Mode)
f9 = &A7                \ Internal key number for red key f9 (Inventory)

RAND    = $0000
T1      = $0006
SC      = $0007
SCH     = $0008
XX16    = $0009
P       = $001B
XX0     = $001E
INF     = $0020
V       = $0022
XX      = $0024
YY      = $0026
BETA    = $002A
BET1    = $002B
XC      = $002C
YC      = $002D
QQ22    = $002E
ECMA    = $0030
XX15    = $0031
Y1      = $0032
X2      = $0033
Y2      = $0034
XX12    = $0037
K       = $003D
KL      = $0041
KY1     = $0042
KY2     = $0043
KY3     = $0044
KY4     = $0045
KY5     = $0046
KY6     = $0047
KY7     = $0048
KY12    = $0049
KY13    = $004A
KY14    = $004B
KY15    = $004C
KY16    = $004D
KY17    = $004E
KY18    = $004F
KY19    = $0050
LAS     = $0051
MSTG    = $0052
INWK    = $0053
XX19    = $0074
LSP     = $0077
QQ15    = $0078
QQ17    = $007E
QQ19    = $007F
K6      = $0082
L0085   = $0085
L0086   = $0086
ALP1    = $0087
ALP2    = $0088
BET2    = $008A
DELTA   = $008C
DELT4   = $008D
U       = $008F
Q       = $00A0
R       = $00A1
S       = $00A2
XSAV    = $00A3
YSAV    = $00A4
XX17    = $00A5
QQ11    = $00A6
ZZ      = $00A7
XX13    = $00A8
MCNT    = $00A9
TYPE    = $00AB
JSTX    = $00AC
JSTY    = $00AD
ALPHA   = $00AE
QQ12    = $00AF
TGT     = $00B0
SWAP    = $00B1
FLAG    = $00B3
CNT     = $00B4
STP     = $00B6
XX4     = $00B7
XX20    = $00B8
RAT     = $00BA
RAT2    = $00BB
K2      = $00BC
T       = $00D1
K3      = $00D2
K4      = $00E0
XX3     = $0100
TP      = $0300
QQ0     = $0301
QQ1     = $0302
QQ21    = $0303
CASH    = $0309
QQ14    = $030D
COK     = $030E
GCNT    = $030F
LASER   = $0310
CRGO    = $0316
QQ20    = $0317
ECM     = $0328
BST     = $0329
BOMB    = $032A
ENGY    = $032B
DKCMP   = $032C
GHYP    = $032D
ESCP    = $032E
NOMSL   = $0333
FIST    = $0334
AVL     = $0335
QQ26    = $0346
TALLY   = $0347
SVC     = $0349
SX      = $034C
SXL     = $0357
SY      = $0362
K%      = $0900
FRIN    = $0BE0
MANY    = $0BED
SSPR    = $0BF4
L0BFB   = $0BFB
L0BFD   = $0BFD
ECMP    = $0BFF
MSAR    = $0C00
VIEW    = $0C01
LASCT   = $0C02
GNTMP   = $0C03
HFX     = $0C04
EV      = $0C05
DLY     = $0C06
de      = $0C07
LSO     = $0C08
LSX2    = $0C5E
LSY2    = $0C86
SYL     = $0CAE
SZ      = $0CB9
SZL     = $0CC4
XSAV2   = $0CCF
YSAV2   = $0CD0
MCH     = $0CD1
FSH     = $0CD2
ASH     = $0CD3
ENERGY  = $0CD4
LASX    = $0CD5
LASY    = $0CD6
COMX    = $0CD7
COMY    = $0CD8
QQ24    = $0CD9
QQ25    = $0CDA
QQ28    = $0CDB
QQ29    = $0CDC
gov     = $0CDD
tek     = $0CDE
SLSP    = $0CDF
ALTIT   = $0CE2
QQ2     = $0CE3
QQ3     = $0CE9
QQ4     = $0CEA
QQ5     = $0CEB
QQ6     = $0CEC
QQ7     = $0CEE
QQ8     = $0CF0
QQ9     = $0CF2
QQ10    = $0CF3

\ ******************************************************************************
\
\ ELITE RECURSIVE TEXT TOKEN FILE
\
\ Produces the binary file WORDS9.bin that gets loaded by elite-loader.asm.
\
\ The recursive token table is loaded at &1100 and is moved down to &0400 as
\ part of elite-loader.asm, so it ends up at &0400 to &07FF.
\
\ ******************************************************************************

CODE_WORDS% = &0400
LOAD_WORDS% = &1100

ORG CODE_WORDS%

\ ******************************************************************************
\
\       Name: CHAR
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for characters in the recursive token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   CHAR 'x'            Insert ASCII character "x"
\
\ To include an apostrophe, use a backtick character, as in i.e. CHAR '`'.
\
\ See the deep dive on "Printing text tokens" for details on how characters are
\ stored in the recursive token table.
\
\ Arguments:
\
\   'x'                 The character to insert into the table
\
\ ******************************************************************************

MACRO CHAR x

  IF x = '`'
    EQUB 39 EOR 35
  ELSE
    EQUB x EOR 35
  ENDIF

ENDMACRO

\ ******************************************************************************
\
\       Name: TWOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for two-letter tokens in the token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   TWOK 'x', 'y'       Insert two-letter token "xy"
\
\ See the deep dive on "Printing text tokens" for details on how two-letter
\ tokens are stored in the recursive token table.
\
\ Arguments:
\
\   'x'                 The first letter of the two-letter token to insert into
\                       the table
\
\   'y'                 The second letter of the two-letter token to insert into
\                       the table
\
\ ******************************************************************************

MACRO TWOK t, k

  IF t = 'A' AND k = 'L' : EQUB 128 EOR 35 : ENDIF
  IF t = 'L' AND k = 'E' : EQUB 129 EOR 35 : ENDIF
  IF t = 'X' AND k = 'E' : EQUB 130 EOR 35 : ENDIF
  IF t = 'G' AND k = 'E' : EQUB 131 EOR 35 : ENDIF
  IF t = 'Z' AND k = 'A' : EQUB 132 EOR 35 : ENDIF
  IF t = 'C' AND k = 'E' : EQUB 133 EOR 35 : ENDIF
  IF t = 'B' AND k = 'I' : EQUB 134 EOR 35 : ENDIF
  IF t = 'S' AND k = 'O' : EQUB 135 EOR 35 : ENDIF
  IF t = 'U' AND k = 'S' : EQUB 136 EOR 35 : ENDIF
  IF t = 'E' AND k = 'S' : EQUB 137 EOR 35 : ENDIF
  IF t = 'A' AND k = 'R' : EQUB 138 EOR 35 : ENDIF
  IF t = 'M' AND k = 'A' : EQUB 139 EOR 35 : ENDIF
  IF t = 'I' AND k = 'N' : EQUB 140 EOR 35 : ENDIF
  IF t = 'D' AND k = 'I' : EQUB 141 EOR 35 : ENDIF
  IF t = 'R' AND k = 'E' : EQUB 142 EOR 35 : ENDIF
  IF t = 'A' AND k = '?' : EQUB 143 EOR 35 : ENDIF
  IF t = 'E' AND k = 'R' : EQUB 144 EOR 35 : ENDIF
  IF t = 'A' AND k = 'T' : EQUB 145 EOR 35 : ENDIF
  IF t = 'E' AND k = 'N' : EQUB 146 EOR 35 : ENDIF
  IF t = 'B' AND k = 'E' : EQUB 147 EOR 35 : ENDIF
  IF t = 'R' AND k = 'A' : EQUB 148 EOR 35 : ENDIF
  IF t = 'L' AND k = 'A' : EQUB 149 EOR 35 : ENDIF
  IF t = 'V' AND k = 'E' : EQUB 150 EOR 35 : ENDIF
  IF t = 'T' AND k = 'I' : EQUB 151 EOR 35 : ENDIF
  IF t = 'E' AND k = 'D' : EQUB 152 EOR 35 : ENDIF
  IF t = 'O' AND k = 'R' : EQUB 153 EOR 35 : ENDIF
  IF t = 'Q' AND k = 'U' : EQUB 154 EOR 35 : ENDIF
  IF t = 'A' AND k = 'N' : EQUB 155 EOR 35 : ENDIF
  IF t = 'T' AND k = 'E' : EQUB 156 EOR 35 : ENDIF
  IF t = 'I' AND k = 'S' : EQUB 157 EOR 35 : ENDIF
  IF t = 'R' AND k = 'I' : EQUB 158 EOR 35 : ENDIF
  IF t = 'O' AND k = 'N' : EQUB 159 EOR 35 : ENDIF

ENDMACRO

\ ******************************************************************************
\
\       Name: CONT
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for control codes in the recursive token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   CONT n              Insert control code token {n}
\
\ See the deep dive on "Printing text tokens" for details on how characters are
\ stored in the recursive token table.
\
\ Arguments:
\
\   n                   The control code to insert into the table
\
\ ******************************************************************************

MACRO CONT n

  EQUB n EOR 35

ENDMACRO

\ ******************************************************************************
\
\       Name: RTOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for recursive tokens in the recursive token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   RTOK n              Insert recursive token [n]
\
\                         * Tokens 0-95 get stored as n + 160
\
\                         * Tokens 128-145 get stored as n - 114
\
\                         * Tokens 96-127 get stored as n
\
\ See the deep dive on "Printing text tokens" for details on how recursive
\ tokens are stored in the recursive token table.
\
\ Arguments:
\
\   n                   The number of the recursive token to insert into the
\                       table, in the range 0 to 145
\
\ ******************************************************************************

MACRO RTOK n

  IF n >= 0 AND n <= 95
    t = n + 160
  ELIF n >= 128
    t = n - 114
  ELSE
    t = n
  ENDIF

  EQUB t EOR 35

ENDMACRO

\ ******************************************************************************
\
\       Name: QQ18
\       Type: Variable
\   Category: Text
\    Summary: The recursive token table for tokens 0-148
\  Deep dive: Printing text tokens
\
\ ******************************************************************************

.QQ18

 RTOK 95                \ Token 0:      
 EQUB 0                 \ ELECTRON_VERSION

 CHAR ' '               \ Token 1:      " CHART"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   " CH<138>T"
 TWOK 'A', 'R'
 CHAR 'T'
 EQUB 0

 CHAR 'G'               \ Token 2:      "GOVERNMENT"
 CHAR 'O'               \
 TWOK 'V', 'E'          \ Encoded as:   "GO<150>RNM<146>T"
 CHAR 'R'
 CHAR 'N'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'D'               \ Token 3:      "DATA ON {selected system name}"
 TWOK 'A', 'T'          \
 CHAR 'A'               \ Encoded as:   "D<145>A[131]{3}"
 RTOK 131
 CONT 3
 EQUB 0

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{crlf}
 TWOK 'V', 'E'          \               "
 CHAR 'N'               \
 CHAR 'T'               \ Encoded as:   "<140><150>NT<153>Y{13}"
 TWOK 'O', 'R'
 CHAR 'Y'
 CONT 13
 EQUB 0

 CHAR 'S'               \ Token 5:      "SYSTEM"
 CHAR 'Y'               \
 CHAR 'S'               \ Encoded as:   "SYS<156>M"
 TWOK 'T', 'E'
 CHAR 'M'
 EQUB 0

 CHAR 'P'               \ Token 6:      "PRICE"
 TWOK 'R', 'I'          \
 TWOK 'C', 'E'          \ Encoded as:   "P<158><133>"
 EQUB 0

 CONT 2                 \ Token 7:      "{current system name} MARKET PRICES"
 CHAR ' '               \
 TWOK 'M', 'A'          \ Encoded as:   "{2} <139>RKET [6]S"
 CHAR 'R'
 CHAR 'K'
 CHAR 'E'
 CHAR 'T'
 CHAR ' '
 RTOK 6
 CHAR 'S'
 EQUB 0

 TWOK 'I', 'N'          \ Token 8:      "INDUSTRIAL"
 CHAR 'D'               \
 TWOK 'U', 'S'          \ Encoded as:   "<140>D<136>T<158><128>"
 CHAR 'T'
 TWOK 'R', 'I'
 TWOK 'A', 'L'
 EQUB 0

 CHAR 'A'               \ Token 9:      "AGRICULTURAL"
 CHAR 'G'               \
 TWOK 'R', 'I'          \ Encoded as:   "AG<158>CULTU<148>L"
 CHAR 'C'
 CHAR 'U'
 CHAR 'L'
 CHAR 'T'
 CHAR 'U'
 TWOK 'R', 'A'
 CHAR 'L'
 EQUB 0

 TWOK 'R', 'I'          \ Token 10:     "RICH "
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<158>CH "
 CHAR ' '
 EQUB 0

 CHAR 'A'               \ Token 11:     "AVERAGE "
 TWOK 'V', 'E'          \
 TWOK 'R', 'A'          \ Encoded as:   "A<150><148><131> "
 TWOK 'G', 'E'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 12:     "POOR "
 CHAR 'O'               \
 TWOK 'O', 'R'          \ Encoded as:   "PO<153> "
 CHAR ' '
 EQUB 0

 TWOK 'M', 'A'          \ Token 13:     "MAINLY "
 TWOK 'I', 'N'          \
 CHAR 'L'               \ Encoded as:   "<139><140>LY "
 CHAR 'Y'
 CHAR ' '
 EQUB 0

 CHAR 'U'               \ Token 14:     "UNIT"
 CHAR 'N'               \
 CHAR 'I'               \ Encoded as:   "UNIT"
 CHAR 'T'
 EQUB 0

 CHAR 'V'               \ Token 15:     "VIEW "
 CHAR 'I'               \
 CHAR 'E'               \ Encoded as:   "VIEW "
 CHAR 'W'
 CHAR ' '
 EQUB 0

 TWOK 'Q', 'U'          \ Token 16:     "QUANTITY"
 TWOK 'A', 'N'          \
 TWOK 'T', 'I'          \ Encoded as:   "<154><155><151>TY"
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

 TWOK 'A', 'N'          \ Token 17:     "ANARCHY"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "<155><138>CHY"
 CHAR 'H'
 CHAR 'Y'
 EQUB 0

 CHAR 'F'               \ Token 18:     "FEUDAL"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "FEUD<128>"
 CHAR 'D'
 TWOK 'A', 'L'
 EQUB 0

 CHAR 'M'               \ Token 19:     "MULTI-GOVERNMENT"
 CHAR 'U'               \
 CHAR 'L'               \ Encoded as:   "MUL<151>-[2]"
 TWOK 'T', 'I'
 CHAR '-'
 RTOK 2
 EQUB 0

 TWOK 'D', 'I'          \ Token 20:     "DICTATORSHIP"
 CHAR 'C'               \
 CHAR 'T'               \ Encoded as:   "<141>CT<145><153>[25]"
 TWOK 'A', 'T'
 TWOK 'O', 'R'
 RTOK 25
 EQUB 0

 RTOK 91                \ Token 21:     "COMMUNIST"
 CHAR 'M'               \
 CHAR 'U'               \ Encoded as:   "[91]MUN<157>T"
 CHAR 'N'
 TWOK 'I', 'S'
 CHAR 'T'
 EQUB 0

 CHAR 'C'               \ Token 22:     "CONFEDERACY"
 TWOK 'O', 'N'          \
 CHAR 'F'               \ Encoded as:   "C<159>F<152><144>ACY"
 TWOK 'E', 'D'
 TWOK 'E', 'R'
 CHAR 'A'
 CHAR 'C'
 CHAR 'Y'
 EQUB 0

 CHAR 'D'               \ Token 23:     "DEMOCRACY"
 CHAR 'E'               \
 CHAR 'M'               \ Encoded as:   "DEMOC<148>CY"
 CHAR 'O'
 CHAR 'C'
 TWOK 'R', 'A'
 CHAR 'C'
 CHAR 'Y'
 EQUB 0

 CHAR 'C'               \ Token 24:     "CORPORATE STATE"
 TWOK 'O', 'R'          \
 CHAR 'P'               \ Encoded as:   "C<153>P<153><145>E [43]<145>E"
 TWOK 'O', 'R'
 TWOK 'A', 'T'
 CHAR 'E'
 CHAR ' '
 RTOK 43
 TWOK 'A', 'T'
 CHAR 'E'
 EQUB 0

 CHAR 'S'               \ Token 25:     "SHIP"
 CHAR 'H'               \
 CHAR 'I'               \ Encoded as:   "SHIP"
 CHAR 'P'
 EQUB 0

 CHAR 'P'               \ Token 26:     "PRODUCT"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "PRODUCT"
 CHAR 'D'
 CHAR 'U'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 27:     " LASER"
 TWOK 'L', 'A'          \
 CHAR 'S'               \ Encoded as:   " <149>S<144>"
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'H'               \ Token 28:     "HUMAN COLONIAL"
 CHAR 'U'               \
 CHAR 'M'               \ Encoded as:   "HUM<155> COL<159>I<128>"
 TWOK 'A', 'N'
 CHAR ' '
 CHAR 'C'
 CHAR 'O'
 CHAR 'L'
 TWOK 'O', 'N'
 CHAR 'I'
 TWOK 'A', 'L'
 EQUB 0

 CHAR 'H'               \ Token 29:     "HYPERSPACE "
 CHAR 'Y'               \
 CHAR 'P'               \ Encoded as:   "HYP<144>SPA<133> "
 TWOK 'E', 'R'
 CHAR 'S'
 CHAR 'P'
 CHAR 'A'
 TWOK 'C', 'E'
 CHAR ' '
 EQUB 0

 CHAR 'S'               \ Token 30:     "SHORT RANGE CHART"
 CHAR 'H'               \
 TWOK 'O', 'R'          \ Encoded as:   "SH<153>T [42][1]"
 CHAR 'T'
 CHAR ' '
 RTOK 42
 RTOK 1
 EQUB 0

 TWOK 'D', 'I'          \ Token 31:     "DISTANCE"
 RTOK 43                \
 TWOK 'A', 'N'          \ Encoded as:   "<141>[43]<155><133>"
 TWOK 'C', 'E'
 EQUB 0

 CHAR 'P'               \ Token 32:     "POPULATION"
 CHAR 'O'               \
 CHAR 'P'               \ Encoded as:   "POPUL<145>I<159>"
 CHAR 'U'
 CHAR 'L'
 TWOK 'A', 'T'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 CHAR 'G'               \ Token 33:     "GROSS PRODUCTIVITY"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "GROSS [26]IVITY"
 CHAR 'S'
 CHAR 'S'
 CHAR ' '
 RTOK 26
 CHAR 'I'
 CHAR 'V'
 CHAR 'I'
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

 CHAR 'E'               \ Token 34:     "ECONOMY"
 CHAR 'C'               \
 TWOK 'O', 'N'          \ Encoded as:   "EC<159>OMY"
 CHAR 'O'
 CHAR 'M'
 CHAR 'Y'
 EQUB 0

 CHAR ' '               \ Token 35:     " LIGHT YEARS"
 CHAR 'L'               \
 CHAR 'I'               \ Encoded as:   " LIGHT YE<138>S"
 CHAR 'G'
 CHAR 'H'
 CHAR 'T'
 CHAR ' '
 CHAR 'Y'
 CHAR 'E'
 TWOK 'A', 'R'
 CHAR 'S'
 EQUB 0

 TWOK 'T', 'E'          \ Token 36:     "TECH.LEVEL"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<156>CH.<129><150>L"
 CHAR '.'
 TWOK 'L', 'E'
 TWOK 'V', 'E'
 CHAR 'L'
 EQUB 0

 CHAR 'C'               \ Token 37:     "CASH"
 CHAR 'A'               \
 CHAR 'S'               \ Encoded as:   "CASH"
 CHAR 'H'
 EQUB 0

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \
 RTOK 118               \ Encoded as:   " <134>[118]I<159>"
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 RTOK 122               \ Token 39:     "GALACTIC CHART{galaxy number}"
 RTOK 1                 \
 CONT 1                 \ Encoded as:   "[122][1]{1}"
 EQUB 0

 CHAR 'T'               \ Token 40:     "TARGET LOST"
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "T<138><131>T LO[43]"
 CHAR 'T'
 CHAR ' '
 CHAR 'L'
 CHAR 'O'
 RTOK 43
 EQUB 0

 RTOK 106               \ Token 41:     "MISSILE JAMMED"
 CHAR ' '               \
 CHAR 'J'               \ Encoded as:   "[106] JAMM<152>"
 CHAR 'A'
 CHAR 'M'
 CHAR 'M'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'R'               \ Token 42:     "RANGE"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "R<155><131>"
 EQUB 0

 CHAR 'S'               \ Token 43:     "ST"
 CHAR 'T'               \
 EQUB 0                 \ Encoded as:   "ST"

 RTOK 16                \ Token 44:     "QUANTITY OF "
 CHAR ' '               \
 CHAR 'O'               \ Encoded as:   "[16] OF "
 CHAR 'F'
 CHAR ' '
 EQUB 0

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \
 RTOK 118               \ Encoded as:   "SE[118]"
 EQUB 0

 CHAR ' '               \ Token 46:     " CARGO{sentence case}"
 CHAR 'C'               \
 TWOK 'A', 'R'          \ Encoded as:   " C<138>GO{6}"
 CHAR 'G'
 CHAR 'O'
 CONT 6
 EQUB 0

 CHAR 'E'               \ Token 47:     "EQUIP"
 TWOK 'Q', 'U'          \
 CHAR 'I'               \ Encoded as:   "E<154>IP"
 CHAR 'P'
 EQUB 0

 CHAR 'F'               \ Token 48:     "FOOD"
 CHAR 'O'               \
 CHAR 'O'               \ Encoded as:   "FOOD"
 CHAR 'D'
 EQUB 0

 TWOK 'T', 'E'          \ Token 49:     "TEXTILES"
 CHAR 'X'               \
 TWOK 'T', 'I'          \ Encoded as:   "<156>X<151>L<137>"
 CHAR 'L'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'R', 'A'          \ Token 50:     "RADIOACTIVES"
 TWOK 'D', 'I'          \
 CHAR 'O'               \ Encoded as:   "<148><141>OAC<151><150>S"
 CHAR 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 TWOK 'V', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'S'               \ Token 51:     "SLAVES"
 TWOK 'L', 'A'          \
 TWOK 'V', 'E'          \ Encoded as:   "S<149><150>S"
 CHAR 'S'
 EQUB 0

 CHAR 'L'               \ Token 52:     "LIQUOR/WINES"
 CHAR 'I'               \
 TWOK 'Q', 'U'          \ Encoded as:   "LI<154><153>/W<140><137>"
 TWOK 'O', 'R'
 CHAR '/'
 CHAR 'W'
 TWOK 'I', 'N'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'L'               \ Token 53:     "LUXURIES"
 CHAR 'U'               \
 CHAR 'X'               \ Encoded as:   "LUXU<158><137>"
 CHAR 'U'
 TWOK 'R', 'I'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'N'               \ Token 54:     "NARCOTICS"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "N<138>CO<151>CS"
 CHAR 'O'
 TWOK 'T', 'I'
 CHAR 'C'
 CHAR 'S'
 EQUB 0

 RTOK 91                \ Token 55:     "COMPUTERS"
 CHAR 'P'               \
 CHAR 'U'               \ Encoded as:   "[91]PUT<144>S"
 CHAR 'T'
 TWOK 'E', 'R'
 CHAR 'S'
 EQUB 0

 TWOK 'M', 'A'          \ Token 56:     "MACHINERY"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<139>CH<140><144>Y"
 TWOK 'I', 'N'
 TWOK 'E', 'R'
 CHAR 'Y'
 EQUB 0

 RTOK 117               \ Token 57:     "ALLOYS"
 CHAR 'O'               \
 CHAR 'Y'               \ Encoded as:   "[117]OYS"
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 58:     "FIREARMS"
 CHAR 'I'               \
 TWOK 'R', 'E'          \ Encoded as:   "FI<142><138>MS"
 TWOK 'A', 'R'
 CHAR 'M'
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 59:     "FURS"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "FURS"
 CHAR 'S'
 EQUB 0

 CHAR 'M'               \ Token 60:     "MINERALS"
 TWOK 'I', 'N'          \
 TWOK 'E', 'R'          \ Encoded as:   "M<140><144><128>S"
 TWOK 'A', 'L'
 CHAR 'S'
 EQUB 0

 CHAR 'G'               \ Token 61:     "GOLD"
 CHAR 'O'               \
 CHAR 'L'               \ Encoded as:   "GOLD"
 CHAR 'D'
 EQUB 0

 CHAR 'P'               \ Token 62:     "PLATINUM"
 CHAR 'L'               \
 TWOK 'A', 'T'          \ Encoded as:   "PL<145><140>UM"
 TWOK 'I', 'N'
 CHAR 'U'
 CHAR 'M'
 EQUB 0

 TWOK 'G', 'E'          \ Token 63:     "GEM-STONES"
 CHAR 'M'               \
 CHAR '-'               \ Encoded as:   "<131>M-[43]<159><137>"
 RTOK 43
 TWOK 'O', 'N'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'A', 'L'          \ Token 64:     "ALIEN ITEMS"
 CHAR 'I'               \
 TWOK 'E', 'N'          \ Encoded as:   "<128>I<146> [127]S"
 CHAR ' '
 RTOK 127
 CHAR 'S'
 EQUB 0

 CHAR '('               \ Token 65:     "(Y/N)?"
 CHAR 'Y'               \
 CHAR '/'               \ Encoded as:   "(Y/N)?"
 CHAR 'N'
 CHAR ')'
 CHAR '?'
 EQUB 0

 CHAR ' '               \ Token 66:     " CR"
 CHAR 'C'               \
 CHAR 'R'               \ Encoded as:   " CR"
 EQUB 0

 CHAR 'L'               \ Token 67:     "LARGE"
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "L<138><131>"
 EQUB 0

 CHAR 'F'               \ Token 68:     "FIERCE"
 CHAR 'I'               \
 TWOK 'E', 'R'          \ Encoded as:   "FI<144><133>"
 TWOK 'C', 'E'
 EQUB 0

 CHAR 'S'               \ Token 69:     "SMALL"
 TWOK 'M', 'A'          \
 RTOK 118               \ Encoded as:   "S<139>[118]"
 EQUB 0

 CHAR 'G'               \ Token 70:     "GREEN"
 TWOK 'R', 'E'          \
 TWOK 'E', 'N'          \ Encoded as:   "G<142><146>"
 EQUB 0

 CHAR 'R'               \ Token 71:     "RED"
 TWOK 'E', 'D'          \
 EQUB 0                 \ Encoded as:   "R<152>"

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \
 RTOK 118               \ Encoded as:   "YE[118]OW"
 CHAR 'O'
 CHAR 'W'
 EQUB 0

 CHAR 'B'               \ Token 73:     "BLUE"
 CHAR 'L'               \
 CHAR 'U'               \ Encoded as:   "BLUE"
 CHAR 'E'
 EQUB 0

 CHAR 'B'               \ Token 74:     "BLACK"
 TWOK 'L', 'A'          \
 CHAR 'C'               \ Encoded as:   "B<149>CK"
 CHAR 'K'
 EQUB 0

 RTOK 136               \ Token 75:     "HARMLESS"
 EQUB 0                 \
                        \ Encoded as:   "[136]"

 CHAR 'S'               \ Token 76:     "SLIMY"
 CHAR 'L'               \
 CHAR 'I'               \ Encoded as:   "SLIMY"
 CHAR 'M'
 CHAR 'Y'
 EQUB 0

 CHAR 'B'               \ Token 77:     "BUG-EYED"
 CHAR 'U'               \
 CHAR 'G'               \ Encoded as:   "BUG-EY<152>"
 CHAR '-'
 CHAR 'E'
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'H'               \ Token 78:     "HORNED"
 TWOK 'O', 'R'          \
 CHAR 'N'               \ Encoded as:   "H<153>N<152>"
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'B'               \ Token 79:     "BONY"
 TWOK 'O', 'N'          \
 CHAR 'Y'               \ Encoded as:   "B<159>Y"
 EQUB 0

 CHAR 'F'               \ Token 80:     "FAT"
 TWOK 'A', 'T'          \
 EQUB 0                 \ Encoded as:   "F<145>"

 CHAR 'F'               \ Token 81:     "FURRY"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "FURRY"
 CHAR 'R'
 CHAR 'Y'
 EQUB 0

 CHAR 'R'               \ Token 82:     "RODENT"
 CHAR 'O'               \
 CHAR 'D'               \ Encoded as:   "ROD<146>T"
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'F'               \ Token 83:     "FROG"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "FROG"
 CHAR 'G'
 EQUB 0

 CHAR 'L'               \ Token 84:     "LIZARD"
 CHAR 'I'               \
 TWOK 'Z', 'A'          \ Encoded as:   "LI<132>RD"
 CHAR 'R'
 CHAR 'D'
 EQUB 0

 CHAR 'L'               \ Token 85:     "LOBSTER"
 CHAR 'O'               \
 CHAR 'B'               \ Encoded as:   "LOB[43]<144>"
 RTOK 43
 TWOK 'E', 'R'
 EQUB 0

 TWOK 'B', 'I'          \ Token 86:     "BIRD"
 CHAR 'R'               \
 CHAR 'D'               \ Encoded as:   "<134>RD"
 EQUB 0

 CHAR 'H'               \ Token 87:     "HUMANOID"
 CHAR 'U'               \
 CHAR 'M'               \ Encoded as:   "HUM<155>OID"
 TWOK 'A', 'N'
 CHAR 'O'
 CHAR 'I'
 CHAR 'D'
 EQUB 0

 CHAR 'F'               \ Token 88:     "FELINE"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "FEL<140>E"
 TWOK 'I', 'N'
 CHAR 'E'
 EQUB 0

 TWOK 'I', 'N'          \ Token 89:     "INSECT"
 CHAR 'S'               \
 CHAR 'E'               \ Encoded as:   "<140>SECT"
 CHAR 'C'
 CHAR 'T'
 EQUB 0

 RTOK 11                \ Token 90:     "AVERAGE RADIUS"
 TWOK 'R', 'A'          \
 TWOK 'D', 'I'          \ Encoded as:   "[11]<148><141><136>"
 TWOK 'U', 'S'
 EQUB 0

 CHAR 'C'               \ Token 91:     "COM"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "COM"
 EQUB 0

 RTOK 91                \ Token 92:     "COMMANDER"
 CHAR 'M'               \
 TWOK 'A', 'N'          \ Encoded as:   "[91]M<155>D<144>"
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

 CHAR ' '               \ Token 93:     " DESTROYED"
 CHAR 'D'               \
 TWOK 'E', 'S'          \ Encoded as:   " D<137>TROY<152>"
 CHAR 'T'
 CHAR 'R'
 CHAR 'O'
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'B'               \ Token 94:     "BY D.BRABEN & I.BELL"
 CHAR 'Y'               \
 CHAR ' '               \ Encoded as:   "BY D.B<148><147>N & I.<147>[118]"
 CHAR 'D'
 CHAR '.'
 CHAR 'B'
 TWOK 'R', 'A'
 TWOK 'B', 'E'
 CHAR 'N'
 CHAR ' '
 CHAR '&'
 CHAR ' '
 CHAR 'I'
 CHAR '.'
 TWOK 'B', 'E'
 RTOK 118
 EQUB 0

 RTOK 14                \ Token 95:     "UNIT  QUANTITY{crlf}
 CHAR ' '               \                 PRODUCT   UNIT PRICE FOR SALE{crlf}
 CHAR ' '               \                                              {lf}"
 RTOK 16                \
 CONT 13                \ Encoded as:   "[14]  [16]{13} [26]   [14] [6] F<153>
 CHAR ' '               \                 SA<129>{13}{10}"
 RTOK 26
 CHAR ' '
 CHAR ' '
 CHAR ' '
 RTOK 14
 CHAR ' '
 RTOK 6
 CHAR ' '
 CHAR 'F'
 TWOK 'O', 'R'
 CHAR ' '
 CHAR 'S'
 CHAR 'A'
 TWOK 'L', 'E'
 CONT 13
 CONT 10
 EQUB 0

 CHAR 'F'               \ Token 96:     "FRONT"
 CHAR 'R'               \
 TWOK 'O', 'N'          \ Encoded as:   "FR<159>T"
 CHAR 'T'
 EQUB 0

 TWOK 'R', 'E'          \ Token 97:     "REAR"
 TWOK 'A', 'R'          \
 EQUB 0                 \ Encoded as:   "<142><138>"

 TWOK 'L', 'E'          \ Token 98:     "LEFT"
 CHAR 'F'               \
 CHAR 'T'               \ Encoded as:   "<129>FT"
 EQUB 0

 TWOK 'R', 'I'          \ Token 99:     "RIGHT"
 CHAR 'G'               \
 CHAR 'H'               \ Encoded as:   "<158>GHT"
 CHAR 'T'
 EQUB 0

 RTOK 121               \ Token 100:    "ENERGY LOW{beep}"
 CHAR 'L'               \
 CHAR 'O'               \ Encoded as:   "[121]LOW{7}"
 CHAR 'W'
 CONT 7
 EQUB 0

 RTOK 99                \ Token 101:    "RIGHT ON COMMANDER!"
 RTOK 131               \
 RTOK 92                \ Encoded as:   "[99][131][92]!"
 CHAR '!'
 EQUB 0

 CHAR 'E'               \ Token 102:    "EXTRA "
 CHAR 'X'               \
 CHAR 'T'               \ Encoded as:   "EXT<148> "
 TWOK 'R', 'A'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 103:    "PULSE LASER"
 CHAR 'U'               \
 CHAR 'L'               \ Encoded as:   "PULSE[27]"
 CHAR 'S'
 CHAR 'E'
 RTOK 27
 EQUB 0

 TWOK 'B', 'E'          \ Token 104:    "BEAM LASER"
 CHAR 'A'               \
 CHAR 'M'               \ Encoded as:   "<147>AM[27]"
 RTOK 27
 EQUB 0

 CHAR 'F'               \ Token 105:    "FUEL"
 CHAR 'U'               \
 CHAR 'E'               \ Encoded as:   "FUEL"
 CHAR 'L'
 EQUB 0

 CHAR 'M'               \ Token 106:    "MISSILE"
 TWOK 'I', 'S'          \
 CHAR 'S'               \ Encoded as:   "M<157>SI<129>"
 CHAR 'I'
 TWOK 'L', 'E'
 EQUB 0

 RTOK 67                \ Token 107:    "LARGE CARGO{sentence case} BAY"
 RTOK 46                \
 CHAR ' '               \ Encoded as:   "[67][46] BAY"
 CHAR 'B'
 CHAR 'A'
 CHAR 'Y'
 EQUB 0

 CHAR 'E'               \ Token 108:    "E.C.M.SYSTEM"
 CHAR '.'               \
 CHAR 'C'               \ Encoded as:   "E.C.M.[5]"
 CHAR '.'
 CHAR 'M'
 CHAR '.'
 RTOK 5
 EQUB 0

 RTOK 102               \ Token 109:    "EXTRA PULSE LASERS"
 RTOK 103               \
 CHAR 'S'               \ Encoded as:   "[102][103]S"
 EQUB 0

 RTOK 102               \ Token 110:    "EXTRA BEAM LASERS"
 RTOK 104               \
 CHAR 'S'               \ Encoded as:   "[102][104]S"
 EQUB 0

 RTOK 105               \ Token 111:    "FUEL SCOOPS"
 CHAR ' '               \
 CHAR 'S'               \ Encoded as:   "[105] SCOOPS"
 CHAR 'C'
 CHAR 'O'
 CHAR 'O'
 CHAR 'P'
 CHAR 'S'
 EQUB 0

 TWOK 'E', 'S'          \ Token 112:    "ESCAPE POD"
 CHAR 'C'               \
 CHAR 'A'               \ Encoded as:   "<137>CAPE POD"
 CHAR 'P'
 CHAR 'E'
 CHAR ' '
 CHAR 'C'               \ ELECTRON_VERSION
 CHAR 'A'
 CHAR 'P'
 CHAR 'S'
 CHAR 'U'
 TWOK 'L', 'E'

 EQUB 0

 RTOK 121               \ Token 113:    "ENERGY BOMB"
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "[121]BOMB"
 CHAR 'M'
 CHAR 'B'
 EQUB 0

 RTOK 121               \ Token 114:    "ENERGY UNIT"
 RTOK 14                \
 EQUB 0                 \ Encoded as:   "[121][14]"

 RTOK 124               \ Token 115:    "DOCKING COMPUTERS"
 TWOK 'I', 'N'          \
 CHAR 'G'               \ Encoded as:   "[124]<140>G [55]"
 CHAR ' '
 RTOK 55
 EQUB 0

 RTOK 122               \ Token 116:    "GALACTIC HYPERSPACE "
 CHAR ' '               \
 RTOK 29                \ Encoded as:   "[122] [29]"
 EQUB 0

 CHAR 'A'               \ Token 117:    "ALL"
 RTOK 118               \
 EQUB 0                 \ Encoded as:   "A[118]"

 CHAR 'L'               \ Token 118:    "LL"
 CHAR 'L'               \
 EQUB 0                 \ Encoded as:   "LL"

 RTOK 37                \ Token 119:    "CASH:{cash} CR{crlf}
 CHAR ':'               \               "
 CONT 0                 \
 EQUB 0                 \ Encoded as:   "[37]:{0}"

 TWOK 'I', 'N'          \ Token 120:    "INCOMING MISSILE"
 RTOK 91                \
 TWOK 'I', 'N'          \ Encoded as:   "<140>[91]<140>G [106]"
 CHAR 'G'
 CHAR ' '
 RTOK 106
 EQUB 0

 TWOK 'E', 'N'          \ Token 121:    "ENERGY "
 TWOK 'E', 'R'          \
 CHAR 'G'               \ Encoded as:   "<146><144>GY "
 CHAR 'Y'
 CHAR ' '
 EQUB 0

 CHAR 'G'               \ Token 122:    "GALACTIC"
 CHAR 'A'               \
 TWOK 'L', 'A'          \ Encoded as:   "GA<149>C<151>C"
 CHAR 'C'
 TWOK 'T', 'I'
 CHAR 'C'
 EQUB 0

 CONT 13                \ Token 123:    "{crlf}
 RTOK 92                \                COMMANDER'S NAME? "
 CHAR '`'               \
 CHAR 'S'               \ Encoded as:   "{13}[92]'S NAME? "
 CHAR ' '
 CHAR 'N'
 CHAR 'A'
 CHAR 'M'
 CHAR 'E'
 CHAR '?'
 CHAR ' '
 EQUB 0

 CHAR 'D'               \ Token 124:    "DOCK"
 CHAR 'O'               \
 CHAR 'C'               \ Encoded as:   "DOCK"
 CHAR 'K'
 EQUB 0

 CONT 5                 \ Token 125:    "FUEL: {fuel level} LIGHT YEARS{crlf}
 TWOK 'L', 'E'          \                CASH:{cash} CR{crlf}
 CHAR 'G'               \                LEGAL STATUS:"
 TWOK 'A', 'L'          \
 CHAR ' '               \ Encoded as:   "{5}<129>G<128> [43]<145><136>:"
 RTOK 43
 TWOK 'A', 'T'
 TWOK 'U', 'S'
 CHAR ':'
 EQUB 0

 RTOK 92                \ Token 126:    "COMMANDER {commander name}{crlf}
 CHAR ' '               \                {crlf}
 CONT 4                 \                {crlf}
 CONT 13                \                {sentence case}PRESENT SYSTEM{tab to
 CONT 13                \                column 21}:{current system name}{crlf}
 CONT 13                \                HYPERSPACE SYSTEM{tab to column 21}:
 CONT 6                 \                {selected system name}{crlf}
 RTOK 145               \                CONDITION{tab to column 21}:"
 CHAR ' '               \
 RTOK 5                 \ Encoded as:   "[92] {4}{13}{13}{13}{6}[145] [5]{9}{2}
 CONT 9                 \                {13}[29][5]{9}{3}{13}C<159><141><151>
 CONT 2                 \                <159>{9}"
 CONT 13
 RTOK 29
 RTOK 5
 CONT 9
 CONT 3
 CONT 13
 CHAR 'C'
 TWOK 'O', 'N'
 TWOK 'D', 'I'
 TWOK 'T', 'I'
 TWOK 'O', 'N'
 CONT 9
 EQUB 0

 CHAR 'I'               \ Token 127:    "ITEM"
 TWOK 'T', 'E'          \
 CHAR 'M'               \ Encoded as:   "I<156>M"
 EQUB 0

 CHAR ' '               \ Token 128:    "  LOAD NEW COMMANDER (Y/N)?{crlf}
 CHAR ' '               \                {crlf}
 CHAR 'L'               \               "
 CHAR 'O'               \
 CHAR 'A'               \ Encoded as:   "  LOAD NEW [92] [65]{13}{13}"
 CHAR 'D'
 CHAR ' '
 CHAR 'N'
 CHAR 'E'
 CHAR 'W'
 CHAR ' '
 RTOK 92
 CHAR ' '
 RTOK 65
 CONT 13
 CONT 13
 EQUB 0

 CONT 6                 \ Token 129:    "{sentence case}DOCKED"
 RTOK 124               \
 TWOK 'E', 'D'          \ Encoded as:   "{6}[124]<152>"
 EQUB 0

 TWOK 'R', 'A'          \ Token 130:    "RATING:"
 TWOK 'T', 'I'          \
 CHAR 'N'               \ Encoded as:   "<148><151>NG:"
 CHAR 'G'
 CHAR ':'
 EQUB 0

 CHAR ' '               \ Token 131:    " ON "
 TWOK 'O', 'N'          \
 CHAR ' '               \ Encoded as:   " <159> "
 EQUB 0

 CONT 13                \ Token 132:    "{crlf}
 CONT 8                 \                {all caps}EQUIPMENT: {sentence case}"
 RTOK 47                \
 CHAR 'M'               \ Encoded as:   "{13}{8}[47]M<146>T:{6}"
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 CONT 6
 EQUB 0

 CHAR 'C'               \ Token 133:    "CLEAN"
 TWOK 'L', 'E'          \
 TWOK 'A', 'N'          \ Encoded as:   "C<129><155>"
 EQUB 0

 CHAR 'O'               \ Token 134:    "OFFENDER"
 CHAR 'F'               \
 CHAR 'F'               \ Encoded as:   "OFF<146>D<144>"
 TWOK 'E', 'N'
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'F'               \ Token 135:    "FUGITIVE"
 CHAR 'U'               \
 CHAR 'G'               \ Encoded as:   "FUGI<151><150>"
 CHAR 'I'
 TWOK 'T', 'I'
 TWOK 'V', 'E'
 EQUB 0

 CHAR 'H'               \ Token 136:    "HARMLESS"
 TWOK 'A', 'R'          \
 CHAR 'M'               \ Encoded as:   "H<138>M<129>SS"
 TWOK 'L', 'E'
 CHAR 'S'
 CHAR 'S'
 EQUB 0

 CHAR 'M'               \ Token 137:    "MOSTLY HARMLESS"
 CHAR 'O'               \
 RTOK 43                \ Encoded as:   "MO[43]LY [136]"
 CHAR 'L'
 CHAR 'Y'
 CHAR ' '
 RTOK 136
 EQUB 0

 RTOK 12                \ Token 138:    "POOR "
 EQUB 0                 \
                        \ Encoded as:   "[12]"

 RTOK 11                \ Token 139:    "AVERAGE "
 EQUB 0                 \
                        \ Encoded as:   "[11]"

 CHAR 'A'               \ Token 140:    "ABOVE AVERAGE "
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "ABO<150> [11]"
 TWOK 'V', 'E'
 CHAR ' '
 RTOK 11
 EQUB 0

 RTOK 91                \ Token 141:    "COMPETENT"
 CHAR 'P'               \
 CHAR 'E'               \ Encoded as:   "[91]PET<146>T"
 CHAR 'T'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'D'               \ Token 142:    "DANGEROUS"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "D<155><131>RO<136>"
 CHAR 'R'
 CHAR 'O'
 TWOK 'U', 'S'
 EQUB 0

 CHAR 'D'               \ Token 143:    "DEADLY"
 CHAR 'E'               \
 CHAR 'A'               \ Encoded as:   "DEADLY"
 CHAR 'D'
 CHAR 'L'
 CHAR 'Y'
 EQUB 0

 CHAR '-'               \ Token 144:    "---- E L I T E ----"
 CHAR '-'               \
 CHAR '-'               \ Encoded as:   "---- E L I T E ----"
 CHAR '-'
 CHAR ' '
 CHAR 'E'
 CHAR ' '
 CHAR 'L'
 CHAR ' '
 CHAR 'I'
 CHAR ' '
 CHAR 'T'
 CHAR ' '
 CHAR 'E'
 CHAR ' '
 CHAR '-'
 CHAR '-'
 CHAR '-'
 CHAR '-'
 EQUB 0

 CHAR 'P'               \ Token 145:    "PRESENT"
 TWOK 'R', 'E'          \
 CHAR 'S'               \ Encoded as:   "P<142>S<146>T"
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CONT 8                 \ Token 146:    "{all caps}GAME OVER"
 CHAR 'G'               \
 CHAR 'A'               \ Encoded as:   "{8}GAME O<150>R"
 CHAR 'M'
 CHAR 'E'
 CHAR ' '
 CHAR 'O'
 TWOK 'V', 'E'
 CHAR 'R'
 EQUB 0

 CHAR 'P'               \ Token 147:    "PRESS FIRE OR SPACE,COMMANDER.{crlf}
 CHAR 'R'               \                {crlf}
 TWOK 'E', 'S'          \               "
 CHAR 'S'               \
 CHAR ' '               \ Encoded as:   "PR<137>S FI<142> <153> SPA<133>,[92].
 CHAR 'F'               \                {13}{13}"
 CHAR 'I'
 TWOK 'R', 'E'
 CHAR ' '
 TWOK 'O', 'R'
 CHAR ' '
 CHAR 'S'
 CHAR 'P'
 CHAR 'A'
 TWOK 'C', 'E'
 CHAR ','
 RTOK 92
 CHAR '.'
 CONT 13
 CONT 13
 EQUB 0

 CHAR '('               \ Token 148:    "(C) ACORNSOFT 1984"
 CHAR 'C'               \
 CHAR ')'               \ Encoded as:   "(C) AC<153>N<135>FT 1984"
 CHAR ' '
 CHAR 'A'
 CHAR 'C'
 TWOK 'O', 'R'
 CHAR 'N'
 TWOK 'S', 'O'
 CHAR 'F'
 CHAR 'T'
 CHAR ' '
 CHAR '1'
 CHAR '9'
 CHAR '8'
 CHAR '4'
 EQUB 0

\ ******************************************************************************
\
\ Save output/WORDS9.bin
\
\ ******************************************************************************

PRINT "WORDS9"
PRINT "Assembled at ", ~CODE_WORDS%
PRINT "Ends at ", ~P%
PRINT "Code size is ", ~(P% - CODE_WORDS%)
PRINT "Execute at ", ~LOAD_WORDS%
PRINT "Reload at ", ~LOAD_WORDS%

PRINT "S.WORDS9 ",~CODE_WORDS%," ",~P%," ",~LOAD_WORDS%," ",~LOAD_WORDS%
SAVE "versions/electron/output/WORDS9.bin", CODE_WORDS%, P%, LOAD_WORDS%


CODE% = &0D00
LOAD% = &2000


 org &0D00
 EQUB &40

.L0D01

 EQUB &00

.L0D02

 EQUB &00, &00

.L0D04

 EQUB &00, &00

.L0D06

 EQUB &00, &00, &B6, &3F, &F8, &1C, &25, &0D
 EQUB &B9, &3F, &08, &2C, &01, &0D, &30, &02
 EQUB &28, &60, &28, &6C, &04, &0D

.COMC

 EQUB &00

.DNOIZ

 EQUB &00

.DAMP

 EQUB &00

.DJD

 EQUB &00

.PATG

 EQUB &00, &00, &00

.L0D23

 EQUB &00

.JSTK

 EQUB &00

 EQUB &AD

.L0D26

 ASL XX16+4
 EOR #&FF
 STA L0D06
 ORA L0D01
 BMI L0D3D

 LDA VIA+&05
 ORA #&20
 STA VIA+&05
 LDA &00FC
 RTI

.L0D3D

 JMP (L0D02)

.M%

 LDA K%
 STA RAND
 LDA #&00
 LDX #&01

.L0D49

 DEC L0BFD,X
 BPL L0D54

 STA L0BFD,X
 STA L0BFB,X

.L0D54

 DEX
 BPL L0D49

 LDX JSTX
 JSR cntr

 JSR cntr

 TXA
 EOR #&80
 TAY
 AND #&80
 JMP L0D70

 EQUB &A1

 EQUB &BB, &80, &00, &90, &01, &D6

.L0D6F

 SBC (L0085),Y
L0D70 = L0D6F+1
 DEY
 STX JSTX
 EOR #&80
 STA ALP2+1
 TYA
 BPL L0D80

 EOR #&FF
 CLC
 ADC #&01

.L0D80

 LSR A
 LSR A
 CMP #&08
 BCS L0D88

 LSR A
 CLC

.L0D88

 STA ALP1
 ORA ALP2
 STA ALPHA
 LDX JSTY
 JSR cntr

 TXA
 EOR #&80
 TAY
 AND #&80
 STX JSTY
 STA BET2+1
 EOR #&80
 STA BET2
 TYA
 BPL L0DA6

 EOR #&FF

.L0DA6

 ADC #&04
 LSR A
 LSR A
 LSR A
 LSR A
 CMP #&03
 BCS L0DB1

 LSR A

.L0DB1

 STA BET1
 ORA BET2
 STA BETA
 LDA KY2
 BEQ MA17

 LDA DELTA
 CMP #&28
 BCS MA17

 INC DELTA

.MA17

 LDA KY1
 BEQ MA4

 DEC DELTA
 BNE MA4

 INC DELTA

.MA4

 LDA KY15
 AND NOMSL
 BEQ MA20

 JSR L3903

 LDA #&28
 JSR NOISE

 LDA #&00
 STA MSAR

.MA20

 LDA MSTG
 BPL MA25

 LDA KY14
 BEQ MA25

 LDX NOMSL
 BEQ MA25

 STA MSAR
 LDY #&0D
 JSR MSBAR

.MA25

 LDA KY16
 BEQ MA24

 LDA MSTG
 BMI MA64

 JSR FRMIS

.MA24

 LDA KY12
 BEQ MA76

 ASL BOMB

.MA76

 LDA KY13
 AND ESCP
 BEQ L0E12

 JMP ESCAPE

.L0E12

 LDA KY18
 BEQ L0E19

 JSR WARP

.L0E19

 LDA KY17
 AND ECM
 BEQ MA64

 LDA ECMA
 BNE MA64

 DEC ECMP
 JSR ECBLB2

.MA64

 LDA KY19
 AND DKCMP
 AND SSPR
 BEQ MA68

 LDA K%+&44
 BMI MA68

 JMP GOIN

.MA68

 LDA #&00
 STA LAS
 STA DELT4
 LDA DELTA
 LSR A
 ROR DELT4
 LSR A
 ROR DELT4
 STA DELT4+1
 LDA LASCT
 BNE MA3

 LDA KY7
 BEQ MA3

 LDA GNTMP
 CMP #&F2
 BCS MA3

 LDX VIEW
 LDA LASER,X
 BEQ MA3

 PHA
 AND #&7F
 STA LAS
 STA MANY
 LDA #&00
 JSR NOISE

 JSR LASLI

 PLA
 BPL ma1

 LDA #&00

.ma1

 AND #&FA
 STA LASCT

.MA3

 LDX #&00

.MAL1

 STX XSAV
 LDA FRIN,X
 BNE L0E8A

 JMP MA18

.L0E8A

 STA TYPE
 JSR GINF

 LDY #&23

.MAL2

 LDA (INF),Y
 STA INWK,Y
 DEY
 BPL MAL2

 LDA TYPE
 BMI MA21

 ASL A
 TAY
 LDA L4ED2,Y
 STA XX0
 LDA L4ED3,Y
 STA XX0+1
 LDA BOMB
 BPL MA21

 CPY #&0E
 BEQ MA21

 LDA INWK+31
 AND #&20
 BNE MA21

 LDA INWK+31
 ORA #&80
 STA INWK+31
 JSR EXNO2

.MA21

 JSR MVEIT

 LDY #&23

.MAL3

 LDA INWK,Y
 STA (INF),Y
 DEY
 BPL MAL3

 LDA INWK+31
 AND #&A0
 JSR MAS4

 BNE MA65

 LDA INWK
 ORA INWK+3
 ORA INWK+6
 BMI MA65

 LDX TYPE
 BMI MA65

 CPX #&07
 BEQ ISDK

 AND #&C0
 BNE MA65

 CPX #&08
 BEQ MA65

 CPX #&0A
 BCS MA58

 JMP L0F73

.MA58

 LDA BST
 AND INWK+5
 BPL L0F73

 LDA #&03
 CPX #&0B
 BNE oily

 BEQ slvy2

.oily

 JSR DORND

 AND #&07

.slvy2

 STA QQ29
 LDA #&01
 JSR tnpr

 LDY #&4E
 BCS MA59

 LDY QQ29
 ADC QQ20,Y
 STA QQ20,Y
 TYA
 ADC #&D0
 JSR MESS

 JMP MA60

.MA65

 JMP MA26

.ISDK

 LDA K%+&44
 BMI MA62

 LDA INWK+14
 CMP #&D6
 BCC MA62

 JSR SPS4

 LDA X2
 BMI MA62

 CMP #&59
 BCC MA62

 LDA INWK+16
 AND #&7F
 CMP #&50
 BCC MA62

.GOIN

 LDA #&00
 STA QQ22+1
 LDA #&08
 JSR LAUN

 JSR RES4

 JMP BAY

.MA62

 LDA DELTA
 CMP #&05
 BCC MA67

 JMP DEATH

.MA59

 JSR EXNO3

.MA60

 ASL INWK+31
 SEC
 ROR INWK+31
 BNE MA26

.MA67

 LDA #&01
 STA DELTA
 LDA #&05
 BNE MA63

.L0F73

 ASL INWK+31
 SEC
 ROR INWK+31
 LDA INWK+35
 SEC
 ROR A

.MA63

 JSR OOPS

 JSR EXNO3

.MA26

 LDA QQ11
 BNE MA15

 JSR PLUT

 JSR HITCH

 BCC MA8

 LDA MSAR
 BEQ MA47

 JSR BEEP

 LDX XSAV
 LDY #&11
 JSR ABORT2

.MA47

 LDA LAS
 BEQ MA8

 LDX #&0F
 JSR EXNO

 LDA INWK+35
 SEC
 SBC LAS
 BCS MA14

 LDA TYPE
 CMP #&07
 BEQ L0FD8

 LDA INWK+31
 ORA #&80
 STA INWK+31
 BCS MA8

 JSR DORND

 BPL oh

 LDY #&00
 AND (XX0),Y
 STA CNT

.um

 BEQ oh

 LDX #&0A
 LDA #&00
 JSR SFS1

 DEC CNT
 BPL um

.oh

 JSR EXNO2

.MA14

 STA INWK+35

.L0FD8

 LDA TYPE
 JSR ANGRY

.MA8

 JSR LL9

.MA15

 LDY #&23
 LDA INWK+35
 STA (INF),Y
 LDA INWK+31
 BPL MAC1

 AND #&20
 BEQ MAC1

 LDA TYPE
 CMP #&02
 BNE q2

 LDA FIST
 ORA #&40
 STA FIST

.q2

 LDA DLY
 BNE KS1S

 LDY #&0A
 LDA (XX0),Y
 BEQ KS1S

 TAX
 INY
 LDA (XX0),Y
 TAY
 JSR MCASH

 LDA #&00
 JSR MESS

.KS1S

 JMP KS1

.MAC1

 LDA TYPE
 BMI MA27

 JSR FAROF

 BCC KS1S

.MA27

 LDY #&1F
 LDA INWK+31
 STA (INF),Y
 LDX XSAV
 INX
 JMP MAL1

.MA18

 LDA BOMB
 BPL MA77

 ASL BOMB

.MA77

 LDA MCNT
 AND #&07
 BNE MA22

 LDX ENERGY
 BPL b

 LDX ASH
 JSR SHD

 STX ASH
 LDX FSH
 JSR SHD

 STX FSH

.b

 SEC
 LDA ENGY
 ADC ENERGY
 BCS L105D

 STA ENERGY

.L105D

 LDA MCNT
 AND #&1F
 BNE MA93

 LDA SSPR
 BNE MA23S

 TAY
 JSR MAS2

 BNE MA23S

 LDX #&1C

.MAL4

 LDA K%,X
 STA INWK,X
 DEX
 BPL MAL4

 INX
 LDY #&09
 JSR MAS1

 BNE MA23S

 LDX #&03
 LDY #&0B
 JSR MAS1

 BNE MA23S

 LDX #&06
 LDY #&0D
 JSR MAS1

 BNE MA23S

 LDA #&C0
 JSR FAROF2

 BCC MA23S

 JSR NWSPS

.MA23S

 JMP MA23

.MA22

 LDA MCNT
 AND #&1F

.MA93

 CMP #&0A
 BNE MA23

 LDA #&32
 CMP ENERGY
 BCC L10B2

 ASL A
 JSR MESS

.L10B2

 LDY #&FF
 STY ALTIT
 INY
 JSR m

 BNE MA23

 JSR MAS3

 BCS MA23

 SBC #&24
 BCC MA28

 STA R
 JSR LL5

 LDA Q
 STA ALTIT
 BNE MA23

.MA28

 JMP DEATH

.MA23

 LDA MANY
 BEQ MA16

 LDA LASCT
 CMP #&08
 BCS MA16

 JSR LASLI2

 LDA #&00
 STA MANY

.MA16

 LDA ECMP
 BEQ MA69

 JSR DENGY

 BEQ MA70

.MA69

 LDA ECMA
 BEQ MA66

 DEC ECMA
 DEC ECMA
 BNE MA66

.MA70

 JSR ECMOF

.MA66

 LDA QQ11
 BNE MA9

 JMP STARS

.MAS1

 LDA INWK,Y
 ASL A
 STA K+1
 LDA INWK+1,Y
 ROL A
 STA K+2
 LDA #&00
 ROR A
 STA K+3
 JSR MVT3

 STA INWK+2,X
 LDY K+1
 STY INWK,X
 LDY K+2
 STY INWK+1,X
 AND #&7F

.MA9

 RTS

.m

 LDA #&00

.MAS2

 ORA K%+2,Y
 ORA K%+5,Y
 ORA K%+8,Y
 AND #&7F
 RTS

.MAS3

 LDA K%+1,Y
 JSR SQUA2

 STA R
 LDA K%+4,Y
 JSR SQUA2

 ADC R
 BCS MA30

 STA R
 LDA K%+7,Y
 JSR SQUA2

 ADC R
 BCC L1156

.MA30

 LDA #&FF

.L1156

 RTS

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
 BPL L116F

 JMP MV40

.L116F

 LDA INWK+32
 BPL MV30

 CPX #&08
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
 JSR L12F8

 LDA INWK+12
 AND #&7F
 JSR FMLTU

 STA R
 LDA INWK+12
 LDX #&03
 JSR L12F8

 LDA INWK+14
 AND #&7F
 JSR FMLTU

 STA R
 LDA INWK+14
 LDX #&06
 JSR L12F8

 LDA INWK+27
 CLC
 ADC INWK+28
 BPL L11C4

 LDA #&00

.L11C4

 LDY #&0F
 CMP (XX0),Y
 BCC L11CC

 LDA (XX0),Y

.L11CC

 STA INWK+27
 LDA #&00
 STA INWK+28
 LDX ALP1
 LDA INWK
 EOR #&FF
 STA P
 LDA INWK+1
 JSR L245A

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
 JSR L245A

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
 JSR L245A

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

.L12F8

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

.MVT3

 LDA K+3
 STA S
 AND #&80
 STA T
 EOR INWK+2,X
 BMI MV13

 LDA K+1
 CLC
 ADC INWK,X
 STA K+1
 LDA K+2
 ADC INWK+1,X
 STA K+2
 LDA K+3
 ADC INWK+2,X
 AND #&7F
 ORA T
 STA K+3
 RTS

.MV13

 LDA S
 AND #&7F
 STA S
 LDA INWK,X
 SEC
 SBC K+1
 STA K+1
 LDA INWK+1,X
 SBC K+2
 STA K+2
 LDA INWK+2,X
 AND #&7F
 SBC S
 ORA #&80
 EOR T
 STA K+3
 BCS MV14

 LDA #&01
 SBC K+1
 STA K+1
 LDA #&00
 SBC K+2
 STA K+2
 LDA #&00
 SBC K+3
 AND #&7F
 ORA T
 STA K+3

.MV14

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

.MVS5

 LDA INWK+1,X
 AND #&7F
 LSR A
 STA T
 LDA INWK,X
 SEC
 SBC T
 STA R
 LDA INWK+1,X
 SBC #&00
 STA S
 LDA INWK,Y
 STA P
 LDA INWK+1,Y
 AND #&80
 STA T
 LDA INWK+1,Y
 AND #&7F
 LSR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 ORA T
 EOR RAT2
 STX Q
 JSR ADD

 STA K+1
 STX K
 LDX Q
 LDA INWK+1,Y
 AND #&7F
 LSR A
 STA T
 LDA INWK,Y
 SEC
 SBC T
 STA R
 LDA INWK+1,Y
 SBC #&00
 STA S
 LDA INWK,X
 STA P
 LDA INWK+1,X
 AND #&80
 STA T
 LDA INWK+1,X
 AND #&7F
 LSR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 ORA T
 EOR #&80
 EOR RAT2
 STX Q
 JSR ADD

 STA INWK+1,Y
 STX INWK,Y
 LDX Q
 LDA K
 STA INWK,X
 LDA K+1
 STA INWK+1,X
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

.L14D2

 RTS

.MV40

 TXA
 LSR A
 BCS L14D2

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

.L159D

 EQUB &4A

 EQUB &41, &4D, &45, &53, &4F, &4E

.L15A4

 EQUB &0D

.L15A5

 EQUB &00, &14, &AD, &4A, &5A, &48, &02, &53
 EQUB &B7, &00, &00, &03, &E8, &46, &00, &00
 EQUB &0F, &00, &00, &00, &00, &00, &16, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &03, &00, &10, &0F, &11
 EQUB &00, &03, &1C, &0E, &00, &00, &0A, &00
 EQUB &11, &3A, &07, &09, &08, &00, &00, &00
 EQUB &00, &80

.CHK2

 EQUB &AA

.CHK

 EQUB &03

.UNIV

 EQUB &00

.L15F2

 EQUB &09, &24, &09, &48, &09, &6C, &09, &90
 EQUB &09, &B4, &09, &D8, &09, &FC, &09, &20
 EQUB &0A, &44, &0A, &68, &0A, &8C, &0A, &B0
 EQUB &0A

.TWOS

 EQUB &80, &40, &20, &10, &08, &04, &02, &01
 EQUB &80, &40

.CTWOS

 EQUB &C0, &30, &0C, &03

.TWOS2

 EQUB &C0, &C0, &60, &30, &18, &0C, &06, &03

.LL30

 STY YSAV
 LDA #&80
 STA S
 STA SC
 ASL A
 STA SWAP
 LDA X2
 SBC XX15
 BCS LI1

 EOR #&FF
 ADC #&01

.LI1

 STA P
 SEC
 LDA Y2
 SBC Y1
 BCS LI2

 EOR #&FF
 ADC #&01

.LI2

 STA Q
 CMP P
 BCC STPX

 JMP STPY

.STPX

 LDX XX15
 CPX X2
 BCC LI3

 DEC SWAP
 LDA X2
 STA XX15
 STX X2
 TAX
 LDA Y2
 LDY Y1
 STA Y1
 STY Y2

.LI3

 LDA Y1
 LSR A
 LSR A
 LSR A
 STA SCH
 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC SCH
 ADC #&58
 STA SCH
 TXA
 AND #&F8
 ADC SC
 STA SC
 BCC L1681

 INC SCH

.L1681

 LDA Y1
 AND #&07
 TAY
 TXA
 AND #&07
 TAX
 LDA TWOS,X
 STA R
 LDA Q
 LDX #&FE
 STX Q

.LIL1

 ASL A
 BCS LI4

 CMP P
 BCC LI5

.LI4

 SBC P
 SEC

.LI5

 ROL Q
 BCS LIL1

 LDX P
 INX
 LDA Y2
 SBC Y1
 BCS DOWN

 LDA SWAP
 BNE LI6

 DEX

.LIL2

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI6

 LSR R
 BCC LI7

 ROR R
 LDA SC
 ADC #&08
 STA SC
 BCC LI7

 INC SCH

.LI7

 LDA S
 ADC Q
 STA S
 BCC LIC2

 DEY
 BPL LIC2

 LDA SC
 SBC #&40
 STA SC
 LDA SCH
 SBC #&01
 STA SCH
 LDY #&07

.LIC2

 DEX
 BNE LIL2

 LDY YSAV
 RTS

.DOWN

 LDA SWAP
 BEQ LI9

 DEX

.LIL3

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI9

 LSR R
 BCC LI10

 ROR R
 LDA SC
 ADC #&08
 STA SC
 BCC LI10

 INC SCH

.LI10

 LDA S
 ADC Q
 STA S
 BCC LIC3

 INY
 CPY #&08
 BNE LIC3

 LDA SC
 ADC #&3F
 STA SC
 LDA SCH
 ADC #&01
 STA SCH
 LDY #&00

.LIC3

 DEX
 BNE LIL3

 LDY YSAV
 RTS

.STPY

 LDY Y1
 TYA
 LDX XX15
 CPY Y2
 BCS LI15

 DEC SWAP
 LDA X2
 STA XX15
 STX X2
 TAX
 LDA Y2
 STA Y1
 STY Y2
 TAY

.LI15

 LSR A
 LSR A
 LSR A
 STA SCH
 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC SCH
 ADC #&58
 STA SCH
 TXA
 AND #&F8
 ADC SC
 STA SC
 BCC L1757

 INC SCH

.L1757

 LDA Y1
 AND #&07
 TAY
 TXA
 AND #&07
 TAX
 LDA TWOS,X
 STA R
 LDA P
 LDX #&01
 STX P

.LIL4

 ASL A
 BCS LI13

 CMP Q
 BCC LI14

.LI13

 SBC Q
 SEC

.LI14

 ROL P
 BCC LIL4

 LDX Q
 INX
 LDA X2
 SBC XX15
 BCC LFT

 CLC
 LDA SWAP
 BEQ LI17

 DEX

.LIL5

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI17

 DEY
 BPL LI16

 LDA SC
 SBC #&3F
 STA SC
 LDA SCH
 SBC #&01
 STA SCH
 LDY #&07

.LI16

 LDA S
 ADC P
 STA S
 BCC LIC5

 LSR R
 BCC LIC5

 ROR R
 LDA SC
 ADC #&08
 STA SC
 BCC LIC5

 INC SCH
 CLC

.LIC5

 DEX
 BNE LIL5

 LDY YSAV
 RTS

.LFT

 LDA SWAP
 BEQ LI18

 DEX

.LIL6

 LDA R
 EOR (SC),Y
 STA (SC),Y

.LI18

 DEY
 BPL LI19

 LDA SC
 SBC #&3F
 STA SC
 LDA SCH
 SBC #&01
 STA SCH
 LDY #&07

.LI19

 LDA S
 ADC P
 STA S
 BCC LIC6

 ASL R
 BCC LIC6

 ROL R
 LDA SC
 SBC #&07
 STA SC
 BCS L17F2

 DEC SCH

.L17F2

 CLC

.LIC6

 DEX
 BNE LIL6

 LDY YSAV
 RTS

 LDA #&0F
 TAX
 JMP OSBYTE

.NLIN3

 JSR TT27

.NLIN4

 LDA #&13
 BNE NLIN2

.NLIN

 LDA #&17
 INC YC

.NLIN2

 STA Y1
 LDX #&02
 STX XX15
 LDX #&FE
 STX X2

.HLOIN

 LDX Y1
 STX Y2
 JMP LL30

.PIX1

 JSR ADD

 STA YY+1
 TXA
 STA SYL,Y

.PIXEL2

 LDA XX15
 BPL PX1

 EOR #&7F
 CLC
 ADC #&01

.PX1

 EOR #&80
 TAX
 LDA Y1
 AND #&7F
 CMP #&60
 BCS PX4

 LDA Y1
 BPL PX2

 EOR #&7F
 ADC #&01

.PX2

 STA T
 LDA #&61
 SBC T

.PIXEL

 STY T1
 LDY #&80
 STY SC
 TAY
 LSR A
 LSR A
 LSR A
 STA SCH
 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC SCH
 ADC #&58
 STA SCH
 TXA
 AND #&F8
 ADC SC
 STA SC
 BCC L1869

 INC SCH

.L1869

 TYA
 AND #&07
 TAY
 TXA
 AND #&07
 TAX
 LDA ZZ
 CMP #&90
 BCS PX3

 LDA TWOS2,X
 EOR (SC),Y
 STA (SC),Y
 LDA ZZ
 CMP #&50
 BCS PX13

 DEY
 BPL PX3

 LDY #&01

.PX3

 LDA TWOS2,X
 EOR (SC),Y
 STA (SC),Y

.PX13

 LDY T1

.PX4

 RTS

.BLINE

 TXA
 ADC K4
 STA QQ19+5
 LDA K4+1
 ADC T
 STA L0085
 LDA FLAG
 BEQ BL1

 INC FLAG

.BL5

 LDY LSP
 LDA #&FF
 CMP LSY2-1,Y
 BEQ BL7

 STA LSY2,Y
 INC LSP
 BNE BL7

.BL1

 LDA QQ17
 STA XX15
 LDA QQ19
 STA Y1
 LDA QQ19+1
 STA X2
 LDA QQ19+2
 STA Y2
 LDA K6
 STA XX15+4
 LDA QQ19+4
 STA XX15+5
 LDA QQ19+5
 STA XX12
 LDA L0085
 STA XX12+1
 JSR LL145

 BCS BL5

 LDA SWAP
 BEQ BL9

 LDA XX15
 LDY X2
 STA X2
 STY XX15
 LDA Y1
 LDY Y2
 STA Y2
 STY Y1

.BL9

 LDY LSP
 LDA LSY2-1,Y
 CMP #&FF
 BNE BL8

 LDA XX15
 STA LSX2,Y
 LDA Y1
 STA LSY2,Y
 INY

.BL8

 LDA X2
 STA LSX2,Y
 LDA Y2
 STA LSY2,Y
 INY
 STY LSP
 JSR LL30

 LDA XX13
 BNE BL5

.BL7

 LDA K6
 STA QQ17
 LDA QQ19+4
 STA QQ19
 LDA QQ19+5
 STA QQ19+1
 LDA L0085
 STA QQ19+2
 LDA CNT
 CLC
 ADC STP
 STA CNT
 RTS

.FLIP

 LDY #&0A

.FLL1

 LDX SY,Y
 LDA SX,Y
 STA Y1
 STA SY,Y
 TXA
 STA XX15
 STA SX,Y
 LDA SZ,Y
 STA ZZ
 JSR PIXEL2

 DEY
 BNE FLL1

 RTS

.STARS

 LDX VIEW
 BEQ STARS1

 DEX
 BNE ST11

 JMP STARS6

.ST11

 JMP STARS2

.STARS1

 LDY #&0A

.STL1

 JSR DV42

 LDA R
 LSR P
 ROR A
 LSR P
 ROR A
 ORA #&01
 STA Q
 LDA SZL,Y
 SBC DELT4
 STA SZL,Y
 LDA SZ,Y
 STA ZZ
 SBC DELT4+1
 STA SZ,Y
 JSR MLU1

 STA YY+1
 LDA P
 ADC SYL,Y
 STA YY
 STA R
 LDA Y1
 ADC YY+1
 STA YY+1
 STA S
 LDA SX,Y
 STA XX15
 JSR MLU2

 STA XX+1
 LDA P
 ADC SXL,Y
 STA XX
 LDA XX15
 ADC XX+1
 STA XX+1
 EOR ALP2+1
 JSR MLS1

 JSR ADD

 STA YY+1
 STX YY
 EOR ALP2
 JSR MLS2

 JSR ADD

 STA XX+1
 STX XX
 LDX BET1
 LDA YY+1
 EOR BET2+1
 JSR L23AB

 STA Q
 JSR MUT2

 ASL P
 ROL A
 STA T
 LDA #&00
 ROR A
 ORA T
 JSR ADD

 STA XX+1
 TXA
 STA SXL,Y
 LDA YY
 STA R
 LDA YY+1
 STA S
 LDA #&00
 STA P
 LDA BETA
 EOR #&80
 JSR PIX1

 LDA XX+1
 STA XX15
 STA SX,Y
 AND #&7F
 CMP #&78
 BCS KILL1

 LDA YY+1
 STA SY,Y
 STA Y1
 AND #&7F
 CMP #&78
 BCS KILL1

 LDA SZ,Y
 CMP #&10
 BCC KILL1

 STA ZZ

.STC1

 JSR PIXEL2

 DEY
 BEQ L1A22

 JMP STL1

.L1A22

 RTS

.KILL1

 JSR DORND

 ORA #&04
 STA Y1
 STA SY,Y
 JSR DORND

 ORA #&08
 STA XX15
 STA SX,Y
 JSR DORND

 ORA #&90
 STA SZ,Y
 STA ZZ
 LDA Y1
 JMP STC1

.STARS6

 LDY #&0A

.STL6

 JSR DV42

 LDA R
 LSR P
 ROR A
 LSR P
 ROR A
 ORA #&01
 STA Q
 LDA SX,Y
 STA XX15
 JSR MLU2

 STA XX+1
 LDA SXL,Y
 SBC P
 STA XX
 LDA XX15
 SBC XX+1
 STA XX+1
 JSR MLU1

 STA YY+1
 LDA SYL,Y
 SBC P
 STA YY
 STA R
 LDA Y1
 SBC YY+1
 STA YY+1
 STA S
 LDA SZL,Y
 ADC DELT4
 STA SZL,Y
 LDA SZ,Y
 STA ZZ
 ADC DELT4+1
 STA SZ,Y
 LDA XX+1
 EOR ALP2
 JSR MLS1

 JSR ADD

 STA YY+1
 STX YY
 EOR ALP2+1
 JSR MLS2

 JSR ADD

 STA XX+1
 STX XX
 LDA YY+1
 EOR BET2+1
 LDX BET1
 JSR L23AB

 STA Q
 LDA XX+1
 STA S
 EOR #&80
 JSR MUT1

 ASL P
 ROL A
 STA T
 LDA #&00
 ROR A
 ORA T
 JSR ADD

 STA XX+1
 TXA
 STA SXL,Y
 LDA YY
 STA R
 LDA YY+1
 STA S
 LDA #&00
 STA P
 LDA BETA
 JSR PIX1

 LDA XX+1
 STA XX15
 STA SX,Y
 LDA YY+1
 STA SY,Y
 STA Y1
 AND #&7F
 CMP #&6E
 BCS KILL6

 LDA SZ,Y
 CMP #&A0
 BCS KILL6

 STA ZZ

.STC6

 JSR PIXEL2

 DEY
 BEQ ST3

 JMP STL6

.ST3

 RTS

.KILL6

 JSR DORND

 AND #&7F
 ADC #&0A
 STA SZ,Y
 STA ZZ
 LSR A
 BCS ST4

 LSR A
 LDA #&FC
 ROR A
 STA XX15
 STA SX,Y
 JSR DORND

 STA Y1
 STA SY,Y
 JMP STC6

.ST4

 JSR DORND

 STA XX15
 STA SX,Y
 LSR A
 LDA #&E6
 ROR A
 STA Y1
 STA SY,Y
 BNE STC6

.L1B45

 EQUB &01

.L1B46

 EQUB &00, &2C, &01, &A0, &0F, &70, &17, &A0
 EQUB &0F, &10, &27, &82, &14, &10, &27, &28
 EQUB &23, &98, &3A, &10, &27, &50, &C3

.L1B5D

 LDX #&09
 CMP #&19
 BCS st3_lc

 DEX
 CMP #&0A
 BCS st3_lc

 DEX
 CMP #&02
 BCS st3_lc

 DEX
 BNE st3_lc

.STATUS

 LDA #&08
 JSR TT66

 JSR TT111

 LDA #&07
 STA XC
 LDA #&7E
 JSR NLIN3

 LDA #&0F
 LDY QQ12
 BNE st6

 LDA #&E6
 LDY MANY+9
 LDX FRIN+2,Y
 BEQ st6

 LDY ENERGY
 CPY #&80
 ADC #&01

.st6

 JSR plf

 LDA #&7D
 JSR spc

 LDA #&13
 LDY FIST
 BEQ st5

 CPY #&32
 ADC #&01

.st5

 JSR plf

 LDA #&10
 JSR spc

 LDA TALLY+1
 BNE L1B5D

 TAX
 LDA TALLY
 LSR A
 LSR A

.st5L

 INX
 LSR A
 BNE st5L

.st3_lc

 TXA
 CLC
 ADC #&15
 JSR plf

 LDA #&12
 JSR plf2

 LDA ESCP
 BEQ L1BD8

 LDA #&70
 JSR plf2

.L1BD8

 LDA BST
 BEQ L1BE2

 LDA #&6F
 JSR plf2

.L1BE2

 LDA ECM
 BEQ L1BEC

 LDA #&6C
 JSR plf2

.L1BEC

 LDA #&71
 STA XX4

.stqv

 TAY
 LDX BOMB-113,Y
 BEQ L1BF9

 JSR plf2

.L1BF9

 INC XX4
 LDA XX4
 CMP #&75
 BCC stqv

 LDX #&00

.st

 STX CNT
 LDY LASER,X
 BEQ st1

 TXA
 CLC
 ADC #&60
 JSR spc

 LDA #&67
 LDX CNT
 LDY LASER,X
 BPL L1C1C

 LDA #&68

.L1C1C

 JSR plf2

.st1

 LDX CNT
 INX
 CPX #&04
 BCC st

 RTS

.plf2

 JSR plf

 LDX #&06
 STX XC
 RTS

.L1C2F

 EQUB &48

 EQUB &76, &E8, &00

.pr2

 LDA #&03

.L1C35

 LDY #&00

.TT11

 STA U
 LDA #&00
 STA K
 STA K+1
 STY K+2
 STX K+3

.BPRNT

 LDX #&0B
 STX T
 PHP
 BCC TT30

 DEC T
 DEC U

.TT30

 LDA #&0B
 SEC
 STA XX17
 SBC U
 STA U
 INC U
 LDY #&00
 STY S
 JMP TT36

.TT35

 ASL K+3
 ROL K+2
 ROL K+1
 ROL K
 ROL S
 LDX #&03

.tt35_lc

 LDA K,X
 STA XX15,X
 DEX
 BPL tt35_lc

 LDA S
 STA XX15+4
 ASL K+3
 ROL K+2
 ROL K+1
 ROL K
 ROL S
 ASL K+3
 ROL K+2
 ROL K+1
 ROL K
 ROL S
 CLC
 LDX #&03

.tt36_lc

 LDA K,X
 ADC XX15,X
 STA K,X
 DEX
 BPL tt36_lc

 LDA XX15+4
 ADC S
 STA S
 LDY #&00

.TT36

 LDX #&03
 SEC

.tt37_lc

 LDA K,X
 SBC L1C2F,X
 STA XX15,X
 DEX
 BPL tt37_lc

 LDA S
 SBC #&17
 STA XX15+4
 BCC TT37

 LDX #&03

.tt38_lc

 LDA XX15,X
 STA K,X
 DEX
 BPL tt38_lc

 LDA XX15+4
 STA S
 INY
 JMP TT36

.TT37

 TYA
 BNE TT32

 LDA T
 BEQ TT32

 DEC U
 BPL TT34

 LDA #&20
 BNE tt34_lc

.TT32

 LDY #&00
 STY T
 CLC
 ADC #&30

.tt34_lc

 JSR TT26

.TT34

 DEC T
 BPL L1CE4

 INC T

.L1CE4

 DEC XX17
 BMI L1CF5

 BNE L1CF2

 PLP
 BCC L1CF2

 LDA #&2E
 JSR TT26

.L1CF2

 JMP TT35

.L1CF5

 RTS

.BELL

 LDA #&07

.TT26

 STA K3
 STY YSAV2
 STX XSAV2
 LDY QQ17
 CPY #&FF
 BEQ RR4

 CMP #&07
 BEQ R5

 CMP #&20
 BCS RR1

 CMP #&0A
 BEQ RRX1

 LDX #&01
 STX XC

.RRX1

 INC YC
 BNE RR4

.RR1

 TAY
 LDX #&BF
 ASL A
 ASL A
 BCC L1D23

 LDX #&C1

.L1D23

 ASL A
 BCC L1D27

 INX

.L1D27

 STA P+1
 STX P+2
 LDA #&80
 STA SC
 LDA YC
 CMP #&18
 BCC L1D3B

 JSR TTX66

 JMP RR4

.L1D3B

 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC YC
 ADC #&58
 STA SCH
 LDA XC
 ASL A
 ASL A
 ASL A
 ADC SC
 STA SC
 BCC L1D54

 INC SCH

.L1D54

 CPY #&7F
 BNE RR2

 DEC XC
 DEC SCH
 LDY #&F8
 JSR ZES2

 BEQ RR4

.RR2

 INC XC
 EQUB &2C

.RREN

 STA SCH
 LDY #&07

.RRL1

 LDA (P+1),Y
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL RRL1

.RR4

 LDY YSAV2
 LDX XSAV2
 LDA K3
 CLC

.rT9

 RTS

.R5

 JSR BEEP

 JMP RR4

.DIALS

 LDA #&F0
 STA SC
 LDA #&76
 STA SCH
 LDA DELTA
 JSR DIL

 LDA #&00
 STA R
 STA P
 LDA #&08
 STA S
 LDA ALP1
 LSR A
 LSR A
 ORA ALP2
 EOR #&80
 JSR ADD

 JSR DIL2

 LDA BETA
 LDX BET1
 BEQ L1DB0

 SBC #&01

.L1DB0

 JSR ADD

 JSR DIL2

 LDA MCNT
 AND #&03
 BNE rT9

 LDY #&00
 LDX #&03

.DLL23

 STY XX12,X
 DEX
 BPL DLL23

 LDX #&03
 LDA ENERGY
 LSR A
 STA Q

.DLL24

 SEC
 SBC #&20
 BCC DLL26

 STA Q
 LDA #&20
 STA XX12,X
 LDA Q
 DEX
 BPL DLL24

 BMI DLL9

.DLL26

 LDA Q
 STA XX12,X

.DLL9

 LDA XX12,Y
 STY P
 JSR DIL

 LDY P
 INY
 CPY #&04
 BNE DLL9

 LDA #&76
 STA SCH
 LDA #&30
 STA SC
 LDA FSH
 JSR DILX

 LDA ASH
 JSR DILX

 LDA QQ14
 JSR L1E27

 SEC
 JSR L293D

 LDA GNTMP
 JSR DILX

 LDA #&F0
 STA T1
 STA K+1
 LDA ALTIT
 JSR DILX

 JMP COMPAS

.DILX

 LSR A
 LSR A

.L1E27

 LSR A

.DIL

 STA Q
 LDX #&FF
 STX R
 LDY #&02
 LDX #&03

.DL1

 LDA Q
 CMP #&08
 BCC DL2

 SBC #&08
 STA Q
 LDA R

.DL5

 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 TYA
 CLC
 ADC #&06
 BCC L1E4E

 INC SCH

.L1E4E

 TAY
 DEX
 BMI DL6

 BPL DL1

.DL2

 EOR #&07
 STA Q
 LDA R

.DL3

 ASL A
 DEC Q
 BPL DL3

 PHA
 LDA #&00
 STA R
 LDA #&63
 STA Q
 PLA
 JMP DL5

.DL6

 SEC
 JMP L293D

.DIL2

 LDY #&01
 STA Q

.DLL10

 SEC
 LDA Q
 SBC #&04
 BCS DLL11

 LDA #&FF
 LDX Q
 STA Q
 LDA CTWOS,X
 BNE DLL12

.DLL11

 STA Q
 LDA #&00

.DLL12

 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 INY
 STA (SC),Y
 TYA
 CLC
 ADC #&05
 TAY
 CPY #&1E
 BCC DLL10

 JMP L293D

.ESCAPE

 JSR RES2

 JSR RESET

 LDA #&00
 LDX #&10

.ESL2

 STA QQ20,X
 DEX
 BPL ESL2

 STA FIST
 STA ESCP
 LDA #&46
 STA QQ14
 JMP BAY

.TA34

 LDA #&00
 JSR MAS4

 BEQ L1EC9

 JMP TA21

.L1EC9

 JSR L1F2B

 JSR EXNO3

 LDA #&FA
 JMP OOPS

.TA18

 LDA ECMA
 BNE TA35

 LDA INWK+32
 ASL A
 BMI TA34

 LSR A
 TAX
 LDA UNIV,X
 STA V
 LDA L15F2,X
 STA V+1
 LDY #&02
 JSR TAS1

 LDY #&05
 JSR TAS1

 LDY #&08
 JSR TAS1

 LDA K3+2
 ORA K3+5
 ORA K3+8
 AND #&7F
 ORA K3+1
 ORA K3+4
 ORA K3+7
 BNE TA64

 LDA INWK+32
 CMP #&82
 BEQ TA35

 LDY #&1F
 LDA (V),Y
 BIT L1F39
 BNE TA35

 ORA #&80
 STA (V),Y

.TA35

 LDA INWK
 ORA INWK+3
 ORA INWK+6
 BNE TA87

 LDA #&50
 JSR OOPS

.TA87

 JSR EXNO2

.L1F2B

 ASL INWK+31
 SEC
 ROR INWK+31

.TA1

 RTS

.TA64

 JSR DORND

 CMP #&10
 BCS TA19

.M32

 LDY #&20
L1F39 = M32+1
 LDA (V),Y
 LSR A
 BCC TA19

 JMP ECBLB2

.TACTICS

 CPX #&08
 BEQ TA18

 CPX #&0B
 BNE L1F50

 JSR SPS1

 JMP TA15

.L1F50

 CPX #&07
 BNE TA13

 JSR DORND

 CMP #&8C
 BCC TA1

 LDA MANY+2
 CMP #&03
 BCS TA1

 LDX #&02
 LDA #&E1
 JMP SFS1

.TA13

 CPX #&06
 BCS TA62

 CPX #&02
 BEQ TA62

 LDA SSPR
 BEQ TA62

 LDA INWK+32
 AND #&81
 STA INWK+32

.TA62

 LDY #&0E
 LDA INWK+35
 CMP (XX0),Y
 BCS TA21

 INC INWK+35

.TA21

 LDX #&08

.TAL1

 LDA INWK,X
 STA K3,X
 DEX
 BPL TAL1

.TA19

 JSR TAS2

 LDY #&0A
 JSR TAS3

 STA CNT
 LDA TYPE
 CMP #&08
 BNE L1FA2

 JMP TA20

.L1FA2

 JSR DORND

 CMP #&FA
 BCC TA7

 JSR DORND

 ORA #&68
 STA INWK+29

.TA7

 LDY #&0E
 LDA (XX0),Y
 LSR A
 CMP INWK+35
 BCC TA3

 LSR A
 LSR A
 CMP INWK+35
 BCC ta3_lc

 JSR DORND

 CMP #&E6
 BCC ta3_lc

 LDA #&00
 STA INWK+32
 JMP SESCP

.ta3_lc

 LDA INWK+31
 AND #&07
 BEQ TA3

 STA T
 JSR DORND

 AND #&1F
 CMP T
 BCS TA3

 LDA ECMA
 BNE TA3

 DEC INWK+31
 LDA TYPE
 JMP SFRMIS

.TA3

 LDA #&00
 JSR MAS4

 AND #&E0
 BNE TA4

 LDX CNT
 CPX #&A0
 BCC TA4

 LDA INWK+31
 ORA #&40
 STA INWK+31
 CPX #&A3
 BCC TA4

 LDY #&13
 LDA (XX0),Y
 LSR A
 JSR OOPS

 DEC INWK+28
 LDA ECMA
 BNE TA10

 LDA #&08
 JMP NOISE

.TA4

 LDA INWK+7
 CMP #&03
 BCS TA5

 LDA INWK+1
 ORA INWK+4
 AND #&FE
 BEQ TA15

.TA5

 JSR DORND

 ORA #&80
 CMP INWK+32
 BCS TA15

.TA20

 LDA XX15
 EOR #&80
 STA XX15
 LDA Y1
 EOR #&80
 STA Y1
 LDA X2
 EOR #&80
 STA X2
 LDA CNT
 EOR #&80
 STA CNT

.TA15

 LDY #&10
 JSR TAS3

 EOR #&80
 AND #&80
 ORA #&03
 STA INWK+30
 LDA INWK+29
 AND #&7F
 CMP #&10
 BCS TA6

 LDY #&16
 JSR TAS3

 EOR INWK+30
 AND #&80
 EOR #&85
 STA INWK+29

.TA6

 LDA CNT
 BMI TA9

 CMP #&16
 BCC TA9

 LDA #&03
 STA INWK+28
 RTS

.TA9

 AND #&7F
 CMP #&12
 BCC TA10

 LDA #&FF
 LDX TYPE
 CPX #&08
 BNE L2082

 ASL A

.L2082

 STA INWK+28

.TA10

 RTS

.TAS1

 LDA (V),Y
 EOR #&80
 STA K+3
 DEY
 LDA (V),Y
 STA K+2
 DEY
 LDA (V),Y
 STA K+1
 STY U
 LDX U
 JSR MVT3

 LDY U
 STA K3+2,X
 LDA K+2
 STA K3+1,X
 LDA K+1
 STA K3,X
 RTS

.HITCH

 CLC
 LDA INWK+8
 BNE HI1

 LDA TYPE
 BMI HI1

 LDA INWK+31
 AND #&20
 ORA INWK+1
 ORA INWK+4
 BNE HI1

 LDA INWK
 JSR SQUA2

 STA S
 LDA P
 STA R
 LDA INWK+3
 JSR SQUA2

 TAX
 LDA P
 ADC R
 STA R
 TXA
 ADC S
 BCS L2157

 STA S
 LDY #&02
 LDA (XX0),Y
 CMP S
 BNE HI1

 DEY
 LDA (XX0),Y
 CMP R

.HI1

 RTS

.FRS1

 JSR ZINF

 LDA #&1C
 STA INWK+3
 LSR A
 STA INWK+6
 LDA #&80
 STA INWK+5
 LDA MSTG
 ASL A
 ORA #&80
 STA INWK+32

.fq1

 LDA #&60
 STA INWK+14
 ORA #&80
 STA INWK+22
 LDA DELTA
 ROL A
 STA INWK+27
 TXA
 JMP NWSHP

.FRMIS

 LDX #&08
 JSR FRS1

 BCC FR1

 LDX MSTG
 JSR GINF

 LDA FRIN,X
 JSR ANGRY

 LDY #&04
 JSR ABORT

 DEC NOMSL
 LDA #&30
 JMP NOISE

.ANGRY

 CMP #&07
 BEQ AN2

 BCS HI1

 CMP #&06
 BNE L213A

 JSR AN2

.L213A

 LDY #&20
 LDA (INF),Y
 BEQ HI1

 ORA #&80
 STA (INF),Y
 LDY #&1C
 LDA #&02
 STA (INF),Y
 ASL A
 LDY #&1E
 STA (INF),Y
 RTS

.AN2

 ASL K%+&44
 SEC
 ROR K%+&44

.L2157

 CLC
 RTS

.FR1

 LDA #&C9
 JMP MESS

.SESCP

 LDX #&0B

.L2160

 LDA #&FE

.SFS1

 STA T1
 LDA XX0
 PHA
 LDA XX0+1
 PHA
 LDA INF
 PHA
 LDA INF+1
 PHA
 LDY #&23

.FRL2

 LDA INWK,Y
 STA XX3,Y
 LDA (INF),Y
 STA INWK,Y
 DEY
 BPL FRL2

 LDA TYPE
 CMP #&07
 BNE rx

 TXA
 PHA
 LDA #&20
 STA INWK+27
 LDX #&00
 LDA INWK+10
 JSR SFS2

 LDX #&03
 LDA INWK+12
 JSR SFS2

 LDX #&06
 LDA INWK+14
 JSR SFS2

 PLA
 TAX

.rx

 LDA T1
 STA INWK+32
 LSR INWK+29
 ASL INWK+29
 TXA
 CMP #&0A
 BNE NOIL

 JSR DORND

 ASL A
 STA INWK+30
 TXA
 AND #&0F
 STA INWK+27
 LDA #&FF
 ROR A
 STA INWK+29
 LDA #&0A

.NOIL

 JSR NWSHP

 PLA
 STA INF+1
 PLA
 STA INF
 LDX #&23

.FRL3

 LDA XX3,X
 STA INWK,X
 DEX
 BPL FRL3

 PLA
 STA XX0+1
 PLA
 STA XX0
 RTS

.SFS2

 ASL A
 STA R
 LDA #&00
 ROR A
 JMP MVT1

.LL164

 LDA #&38
 JSR NOISE

 LDA #&01
 STA HFX
 LDA #&04
 JSR HFS2

 DEC HFX
 RTS

.LAUN

 LDA #&30
 JSR NOISE

 LDA #&08

.HFS2

 STA STP
 JSR TTX66

 JSR HFS1

.HFS1

 LDA #&80
 STA K3
 LDX #&60
 STX K4
 ASL A
 STA XX4
 STA K3+1
 STA K4+1

.HFL5

 JSR HFL1

 INC XX4
 LDX XX4
 CPX #&08
 BNE HFL5

 RTS

.HFL1

 LDA XX4
 AND #&07
 CLC
 ADC #&08
 STA K

.HFL2

 LDA #&01
 STA LSP
 JSR CIRCLE2

 ASL K
 BCS HF8

 LDA K
 CMP #&A0
 BCC HFL2

.HF8

 RTS

.STARS2

 LDA #&00
 CPX #&02
 ROR A
 STA RAT
 EOR #&80
 STA RAT2
 JSR ST2

 LDY #&0A

.STL2

 LDA SZ,Y
 STA ZZ
 LSR A
 LSR A
 LSR A
 JSR DV41

 LDA P
 EOR RAT2
 STA S
 LDA SXL,Y
 STA P
 LDA SX,Y
 STA XX15
 JSR ADD

 STA S
 STX R
 LDA SY,Y
 STA Y1
 EOR BET2
 LDX BET1
 JSR L23AB

 JSR ADD

 STX XX
 STA XX+1
 LDX SYL,Y
 STX R
 LDX Y1
 STX S
 LDX BET1
 EOR BET2+1
 JSR L23AB

 JSR ADD

 STX YY
 STA YY+1
 LDX ALP1
 EOR ALP2
 JSR L23AB

 STA Q
 LDA XX
 STA R
 LDA XX+1
 STA S
 EOR #&80
 JSR MAD

 STA XX+1
 TXA
 STA SXL,Y
 LDA YY
 STA R
 LDA YY+1
 STA S
 JSR MAD

 STA S
 STX R
 LDA #&00
 STA P
 LDA ALPHA
 JSR PIX1

 LDA XX+1
 STA SX,Y
 STA XX15
 AND #&7F
 CMP #&74
 BCS KILL2

 LDA YY+1
 STA SY,Y
 STA Y1
 AND #&7F
 CMP #&74
 BCS L231E

.STC2

 JSR PIXEL2

 DEY
 BEQ ST2

 JMP STL2

.ST2

 LDA ALPHA
 EOR RAT
 STA ALPHA
 LDA ALP2
 EOR RAT
 STA ALP2
 EOR #&80
 STA ALP2+1
 LDA BET2
 EOR RAT
 STA BET2
 EOR #&80
 STA BET2+1
 RTS

.KILL2

 JSR DORND

 STA Y1
 STA SY,Y
 LDA #&73
 ORA RAT
 STA XX15
 STA SX,Y
 BNE STF1

.L231E

 JSR DORND

 STA XX15
 STA SX,Y
 LDA #&6E
 ORA ALP2+1
 STA Y1
 STA SY,Y

.STF1

 JSR DORND

 ORA #&08
 STA ZZ
 STA SZ,Y
 BNE STC2

.L233B

 EQUB &00

 EQUB &19, &32, &4A, &62, &79, &8E, &A2, &B5
 EQUB &C6, &D5, &E2, &ED, &F5, &FB, &FF, &FF
 EQUB &FF, &FB, &F5, &ED, &E2, &D5, &C6, &B5
 EQUB &A2, &8E, &79, &62, &4A, &32, &19

.MU5

 STA K
 STA K+1
 STA K+2
 STA K+3
 CLC
 RTS

.MULT3

 STA R
 AND #&7F
 STA K+2
 LDA Q
 AND #&7F
 BEQ MU5

 SEC
 SBC #&01
 STA T
 LDA P+1
 LSR K+2
 ROR A
 STA K+1
 LDA P
 ROR A
 STA K
 LDA #&00
 LDX #&18

.MUL2

 BCC L238A

 ADC T

.L238A

 ROR A
 ROR K+2
 ROR K+1
 ROR K
 DEX
 BNE MUL2

 STA T
 LDA R
 EOR Q
 AND #&80
 ORA T
 STA K+3
 RTS

.MLS2

 LDX XX
 STX R
 LDX XX+1
 STX S

.MLS1

 LDX ALP1

.L23AB

 STX P
 TAX
 AND #&80
 STA T
 TXA
 AND #&7F
 BEQ MU6

 TAX
 DEX
 STX T1
 LDA #&00
 LSR P
 BCC L23C3

 ADC T1

.L23C3

 ROR A
 ROR P
 BCC L23CA

 ADC T1

.L23CA

 ROR A
 ROR P
 BCC L23D1

 ADC T1

.L23D1

 ROR A
 ROR P
 BCC L23D8

 ADC T1

.L23D8

 ROR A
 ROR P
 BCC L23DF

 ADC T1

.L23DF

 ROR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 LSR A
 ROR P
 ORA T
 RTS

.SQUA

 AND #&7F

.SQUA2

 STA P
 TAX
 BNE MU11

.MU1

 CLC
 STX P
 TXA
 RTS

.MLU1

 LDA SY,Y
 STA Y1

.MLU2

 AND #&7F
 STA P

.MULTU

 LDX Q
 BEQ MU1

.MU11

 DEX
 STX T
 LDA #&00
 LDX #&08
 LSR P

.MUL6

 BCC L2414

 ADC T

.L2414

 ROR A
 ROR P
 DEX
 BNE MUL6

 RTS

.MU6

 STA P+1
 STA P
 RTS

.FMLTU2

 AND #&1F
 TAX
 LDA L233B,X
 STA Q
 LDA K

.FMLTU

 EOR #&FF
 SEC
 ROR A
 STA P
 LDA #&00

.MUL3

 BCS MU7

 ADC Q
 ROR A
 LSR P
 BNE MUL3

 RTS

.MU7

 LSR A
 LSR P
 BNE MUL3

 RTS

 LDX Q
 BEQ MU1

 DEX
 STX T
 LDA #&00
 LDX #&08
 LSR P

.L244F

 BCC L2453

 ADC T

.L2453

 ROR A
 ROR P
 DEX
 BNE L244F

 RTS

.L245A

 STX Q

.MLTU2

 EOR #&FF
 LSR A
 STA P+1
 LDA #&00
 LDX #&10
 ROR P

.MUL7

 BCS MU21

 ADC Q
 ROR A
 ROR P+1
 ROR P
 DEX
 BNE MUL7

 RTS

.MU21

 LSR A
 ROR P+1
 ROR P
 DEX
 BNE MUL7

 RTS

 LDX ALP1
 STX P

.MUT2

 LDX XX+1
 STX S

.MUT1

 LDX XX
 STX R

.MULT1

 TAX
 AND #&7F
 LSR A
 STA P
 TXA
 EOR Q
 AND #&80
 STA T
 LDA Q
 AND #&7F
 BEQ mu10

 TAX
 DEX
 STX T1
 LDA #&00
 LDX #&07

.MUL4

 BCC L24A8

 ADC T1

.L24A8

 ROR A
 ROR P
 DEX
 BNE MUL4

 LSR A
 ROR P
 ORA T
 RTS

.mu10

 STA P
 RTS

.MULT12

 JSR MULT1

 STA S
 LDA P
 STA R
 RTS

.TAS3

 LDX INWK,Y
 STX Q
 LDA XX15
 JSR MULT12

 LDX INWK+2,Y
 STX Q
 LDA Y1
 JSR MAD

 STA S
 STX R
 LDX INWK+4,Y
 STX Q
 LDA X2

.MAD

 JSR MULT1

.ADD

 STA T1
 AND #&80
 STA T
 EOR S
 BMI MU8

 LDA R
 CLC
 ADC P
 TAX
 LDA S
 ADC T1
 ORA T
 RTS

.MU8

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
 BCS MU9

 STA U
 TXA
 EOR #&FF
 ADC #&01
 TAX
 LDA #&00
 SBC U
 ORA #&80

.MU9

 EOR T
 RTS

.TIS1

 STX Q
 EOR #&80
 JSR MAD

 TAX
 AND #&80
 STA T
 TXA
 AND #&7F
 LDX #&FE
 STX T1

.DVL3

 ASL A
 CMP #&60
 BCC DV4

 SBC #&60

.DV4

 ROL T1
 BCS DVL3

 LDA T1
 ORA T
 RTS

.DV42

 LDA SZ,Y

.DV41

 STA Q
 LDA DELTA

.DVID4

 LDX #&08
 ASL A
 STA P
 LDA #&00

.DVL4

 ROL A
 BCS DV8

 CMP Q
 BCC DV5

.DV8

 SBC Q
 SEC

.DV5

 ROL P
 DEX
 BNE DVL4

 JMP L4630

.DVID3B2

 STA P+2
 LDA INWK+6
 STA Q
 LDA INWK+7
 STA R
 LDA INWK+8
 STA S
 LDA P
 ORA #&01
 STA P
 LDA P+2
 EOR S
 AND #&80
 STA T
 LDY #&00
 LDA P+2
 AND #&7F

.DVL9

 CMP #&40
 BCS DV14

 ASL P
 ROL P+1
 ROL A
 INY
 BNE DVL9

.DV14

 STA P+2
 LDA S
 AND #&7F
 BMI DV9

.DVL6

 DEY
 ASL Q
 ROL R
 ROL A
 BPL DVL6

.DV9

 STA Q
 LDA #&FE
 STA R
 LDA P+2
 JSR LL31

 LDA #&00
 STA K+1
 STA K+2
 STA K+3
 TYA
 BPL DV12

 LDA R

.DVL8

 ASL A
 ROL K+1
 ROL K+2
 ROL K+3
 INY
 BNE DVL8

 STA K
 LDA K+3
 ORA T
 STA K+3
 RTS

.DV13

 LDA R
 STA K
 LDA T
 STA K+3
 RTS

.DV12

 BEQ DV13

 LDA R

.DVL10

 LSR A
 DEY
 BNE DVL10

 STA K
 LDA T
 STA K+3
 RTS

.cntr

 LDA DAMP
 BNE RE1

 TXA
 BPL BUMP

 DEX
 BMI RE1

.BUMP

 INX
 BNE RE1

 DEX
 BEQ BUMP

.RE1

 RTS

.BUMP2

 STA T
 TXA
 CLC
 ADC T
 TAX
 BCC RE2

 LDX #&FF

.RE2

 BPL L260F

.L25FF

 LDA T
 RTS

.REDU2

 STA T
 TXA
 SEC
 SBC T
 TAX
 BCS RE3

 LDX #&01

.RE3

 BPL L25FF

.L260F

 LDA DJD
 BNE L25FF

 LDX #&80
 BMI L25FF

 LDA P
 EOR Q
 STA T1
 LDA Q
 BEQ AR2

 ASL A
 STA Q
 LDA P
 ASL A
 CMP Q
 BCS AR1

 JSR ARS1

 SEC

.AR4

 LDX T1
 BMI AR3

 RTS

.AR1

 LDX Q
 STA Q
 STX P
 TXA
 JSR ARS1

 STA T
 LDA #&40
 SBC T
 BCS AR4

.AR2

 LDA #&3F
 RTS

.AR3

 STA T
 LDA #&80
 SBC T
 RTS

.ARS1

 JSR LL28

 LDA R
 LSR A
 LSR A
 LSR A
 TAX
 LDA L265E,X
 RTS

.L265E

 EQUB &00

 EQUB &01, &03, &04, &05, &06, &08, &09, &0A
 EQUB &0B, &0C, &0D, &0F, &10, &11, &12, &13
 EQUB &14, &15, &16, &17, &18, &19, &19, &1A
 EQUB &1B, &1C, &1D, &1D, &1E, &1F, &1F

.WARP

 LDA MANY+9
 CLC
 ADC MANY+11
 CLC
 ADC MANY+10
 TAX
 LDA FRIN+2,X
 ORA SSPR
 BNE WA1

 LDY K%+8
 BMI WA3

 TAY
 JSR MAS2

 CMP #&02
 BCC WA1

.WA3

 LDY K%+&2C
 BMI WA2

 LDY #&24
 JSR m

 CMP #&02
 BCC WA1

.WA2

 LDA #&81
 STA S
 STA R
 STA P
 LDA K%+8
 JSR ADD

 STA K%+8
 LDA K%+&2C
 JSR ADD

 STA K%+&2C
 LDA #&01
 STA QQ11
 STA MCNT
 LSR A
 STA EV
 LDX VIEW
 JMP LOOK1

.WA1

 LDA #&28
 JMP NOISE

.LASLI

 JSR DORND

 AND #&07
 ADC #&5C
 STA LASY
 JSR DORND

 AND #&07
 ADC #&7C
 STA LASX
 LDA GNTMP
 ADC #&08
 STA GNTMP
 JSR DENGY

.LASLI2

 LDA QQ11
 BNE L2735

 LDA #&20
 LDY #&E0
 JSR L270A

 LDA #&30
 LDY #&D0

.L270A

 STA X2
 LDA LASX
 STA XX15
 LDA LASY
 STA Y1
 LDA #&BF
 STA Y2
 JSR LL30

 LDA LASX
 STA XX15
 LDA LASY
 STA Y1
 STY X2
 LDA #&BF
 STA Y2
 JMP LL30

.PLUT

 LDX VIEW
 BNE PU1

.L2735

 RTS

.PU1

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

 JMP NWSTARS

.LOOK1

 LDA #&00
 LDY QQ11
 BNE LQ

 CPX VIEW
 BEQ LO2

 STX VIEW
 JSR TT66

 JSR FLIP

 JSR WPSHPS

.SIGHT

 LDY VIEW
 LDA LASER,Y
 BEQ LO2

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

.L27FA

 LDA #&01

.TT66

 STA QQ11

.TTX66

 LDA #&80
 STA QQ17
 ASL A
 STA MANY
 STA DLY
 STA de
 LDX #&58
 JSR LYN

 LDX QQ22+1
 BEQ BOX

 JSR L304B

.BOX

 LDY #&01
 STY YC
 LDA QQ11
 BNE tt66_lc

 LDY #&0B
 STY XC
 LDA VIEW
 ORA #&60
 JSR TT27

 JSR TT162

 LDA #&AF
 JSR TT27

.tt66_lc

 LDX #&00
 STX QQ17

.L2838

 LDX #&00
 STX XX15
 STX Y1
 DEX
 STX X2
 JSR HLOIN

 LDA #&02
 STA XX15
 STA X2
 JSR BOS2

.BOS2

 JSR BOS1

.BOS1

 LDA #&00
 STA Y1
 LDA #&BF
 STA Y2
 DEC XX15
 DEC X2
 JMP LL30

.L285F

 LDY #&01
 EQUB &2C

.DEL8

 LDY #&1E

.DELAY

 TXA
 LDX #&00

.L2867

 EQUB &2C

.L2868

 BNE L2867

 EQUB &2C

.L286B

 BNE L2868

 DEX
 BNE L286B

 TAX
 DEY
 BNE DELAY

 RTS

.hm

 JSR TT103

 JSR TT111

 JSR TT103

 LDA QQ11
 BEQ SC5

.CLYNS

 JSR L2838

 LDX #&71
 JSR LYN

 JSR L2838

 LDA #&14
 STA YC
 JSR TT67

 LDY #&01
 STY XC
 DEY
 TYA

.SC5

 RTS

.LYN

 JSR ZES1

 INX
 CPX #&76
 BNE LYN

 RTS

.SCAN

 LDA INWK+31
 AND #&10
 BEQ SC5

 LDA TYPE
 BMI SC5

 LDA INWK+1
 ORA INWK+4
 ORA INWK+7
 AND #&C0
 BNE SC5

 LDA INWK+1
 CLC
 LDX INWK+2
 BPL SC2

 EOR #&FF
 ADC #&01

.SC2

 ADC #&7B
 STA XX15
 LDA INWK+7
 LSR A
 LSR A
 CLC
 LDX INWK+8
 BPL SC3

 EOR #&FF
 SEC

.SC3

 ADC #&23
 EOR #&FF
 STA SC
 LDA INWK+4
 LSR A
 CLC
 LDX INWK+5
 BMI SCD6

 EOR #&FF
 SEC

.SCD6

 ADC SC
 BPL ld246

 CMP #&C2
 BCS L28EE

 LDA #&C2

.L28EE

 CMP #&F7
 BCC L28F4

.ld246

 LDA #&F6

.L28F4

 STA Y1
 SEC
 SBC SC
 PHP
 PHA
 JSR CPIX4

 LDA TWOS,X
 STA XX15
 PLA
 PLP
 TAX
 BEQ RTS

 BCC L2926

.VLL1

 DEY
 BPL VL1

 LDY #&07
 LDA SC
 SEC
 SBC #&40
 STA SC
 LDA SCH
 SBC #&01
 STA SCH

.VL1

 LDA XX15
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS

.L2926

 JSR L2936

.L2929

 JSR L2936

 LDA XX15
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE L2929

 RTS

.L2936

 INY
 CPY #&08
 BNE RTS

 LDY #&00

.L293D

 LDA SC
 ADC #&3F
 STA SC
 LDA SCH
 ADC #&01
 STA SCH
 RTS

.tnpr

 PHA
 LDX #&0C
 CPX QQ29
 BCC kg

.Tml

 ADC QQ20,X
 DEX
 BPL Tml

 CMP CRGO
 PLA
 RTS

.kg

 LDY QQ29
 ADC QQ20,Y
 CMP #&C8
 PLA
 RTS

.TT20

 JSR L296A

.L296A

 JSR TT54

.TT54

 LDA QQ15
 CLC
 ADC QQ15+2
 TAX
 LDA QQ15+1
 ADC QQ15+3
 TAY
 LDA QQ15+2
 STA QQ15
 LDA QQ15+3
 STA QQ15+1
 LDA QQ15+5
 STA QQ15+3
 LDA QQ15+4
 STA QQ15+2
 CLC
 TXA
 ADC QQ15+2
 STA QQ15+4
 TYA
 ADC QQ15+3
 STA QQ15+5
 RTS

.TT146

 LDA QQ8
 ORA QQ8+1
 BNE TT63

 INC YC
 RTS

.TT63

 LDA #&BF
 JSR TT68

 LDX QQ8
 LDY QQ8+1
 SEC
 JSR pr5

 LDA #&C3

.TT60

 JSR TT27

.TTX69

 INC YC

.TT69

 LDA #&80
 STA QQ17

.TT67

 LDA #&0D
 JMP TT27

.TT70

 LDA #&AD
 JSR TT27

 JMP TT72

.spc

 JSR TT27

 JMP TT162

.TT25

 JSR L27FA

 LDA #&09
 STA XC
 LDA #&A3
 JSR TT27

 JSR NLIN

 JSR TTX69

 INC YC
 JSR TT146

 LDA #&C2
 JSR TT68

 LDA QQ3
 CLC
 ADC #&01
 LSR A
 CMP #&02
 BEQ TT70

 LDA QQ3
 BCC TT71

 SBC #&05
 CLC

.TT71

 ADC #&AA
 JSR TT27

.TT72

 LDA QQ3
 LSR A
 LSR A
 CLC
 ADC #&A8
 JSR TT60

 LDA #&A2
 JSR TT68

 LDA QQ4
 CLC
 ADC #&B1
 JSR TT60

 LDA #&C4
 JSR TT68

 LDX QQ5
 INX
 CLC
 JSR pr2

 JSR TTX69

 LDA #&C0
 JSR TT68

 SEC
 LDX QQ6
 JSR pr2

 LDA #&C6
 JSR TT60

 LDA #&28
 JSR TT27

 LDA QQ15+4
 BMI TT75

 LDA #&BC
 JSR TT27

 JMP TT76

.TT75

 LDA QQ15+5
 LSR A
 LSR A
 PHA
 AND #&07
 CMP #&03
 BCS TT205

 ADC #&E3
 JSR spc

.TT205

 PLA
 LSR A
 LSR A
 LSR A
 CMP #&06
 BCS TT206

 ADC #&E6
 JSR spc

.TT206

 LDA QQ15+3
 EOR QQ15+1
 AND #&07
 STA QQ19
 CMP #&06
 BCS TT207

 ADC #&EC
 JSR spc

.TT207

 LDA QQ15+5
 AND #&03
 CLC
 ADC QQ19
 AND #&07
 ADC #&F2
 JSR TT27

.TT76

 LDA #&53
 JSR TT27

 LDA #&29
 JSR TT60

 LDA #&C1
 JSR TT68

 LDX QQ7
 LDY QQ7+1
 JSR pr6

 JSR TT162

 LDA #&00
 STA QQ17
 LDA #&4D
 JSR TT27

 LDA #&E2
 JSR TT60

 LDA #&FA
 JSR TT68

 LDA QQ15+5
 LDX QQ15+3
 AND #&0F
 CLC
 ADC #&0B
 TAY
 JSR pr5

 JSR TT162

 LDA #&6B
 JSR TT26

 LDA #&6D
 JMP TT26

.TT24

 LDA QQ15+1
 AND #&07
 STA QQ3
 LDA QQ15+2
 LSR A
 LSR A
 LSR A
 AND #&07
 STA QQ4
 LSR A
 BNE TT77

 LDA QQ3
 ORA #&02
 STA QQ3

.TT77

 LDA QQ3
 EOR #&07
 CLC
 STA QQ5
 LDA QQ15+3
 AND #&03
 ADC QQ5
 STA QQ5
 LDA QQ4
 LSR A
 ADC QQ5
 STA QQ5
 ASL A
 ASL A
 ADC QQ3
 ADC QQ4
 ADC #&01
 STA QQ6
 LDA QQ3
 EOR #&07
 ADC #&03
 STA P
 LDA QQ4
 ADC #&04
 STA Q
 JSR MULTU

 LDA QQ6
 STA Q
 JSR MULTU

 ASL P
 ROL A
 ASL P
 ROL A
 ASL P
 ROL A
 STA QQ7+1
 LDA P
 STA QQ7
 RTS

.TT22

 LDA #&40
 JSR TT66

 LDA #&07
 STA XC
 JSR TT81

 LDA #&C7
 JSR TT27

 JSR NLIN

 LDA #&98
 JSR NLIN2

 JSR TT14

 LDX #&00

.TT83

 STX XSAV
 LDX QQ15+3
 LDY QQ15+4
 TYA
 ORA #&50
 STA ZZ
 LDA QQ15+1
 LSR A
 CLC
 ADC #&18
 STA Y1
 JSR PIXEL

 JSR TT20

 LDX XSAV
 INX
 BNE TT83

 LDA QQ9
 STA QQ19
 LDA QQ10
 LSR A
 STA QQ19+1
 LDA #&04
 STA QQ19+2

.TT15

 LDA #&18
 LDX QQ11
 BPL L2B95

 LDA #&00

.L2B95

 STA QQ19+5
 LDA QQ19
 SEC
 SBC QQ19+2
 BCS TT84

 LDA #&00

.TT84

 STA XX15
 LDA QQ19
 CLC
 ADC QQ19+2
 BCC L2BAB

 LDA #&FF

.L2BAB

 STA X2
 LDA QQ19+1
 CLC
 ADC QQ19+5
 STA Y1
 JSR HLOIN

 LDA QQ19+1
 SEC
 SBC QQ19+2
 BCS TT86

 LDA #&00

.TT86

 CLC
 ADC QQ19+5
 STA Y1
 LDA QQ19+1
 CLC
 ADC QQ19+2
 ADC QQ19+5
 CMP #&98
 BCC TT87

 LDX QQ11
 BMI TT87

 LDA #&97

.TT87

 STA Y2
 LDA QQ19
 STA XX15
 STA X2
 JMP LL30

.TT126

 LDA #&68
 STA QQ19
 LDA #&5A
 STA QQ19+1
 LDA #&10
 STA QQ19+2
 JSR TT15

 LDA QQ14
 STA K
 JMP TT128

.TT14

 LDA QQ11
 BMI TT126

 LDA QQ14
 LSR A
 LSR A
 STA K
 LDA QQ0
 STA QQ19
 LDA QQ1
 LSR A
 STA QQ19+1
 LDA #&07
 STA QQ19+2
 JSR TT15

 LDA QQ19+1
 CLC
 ADC #&18
 STA QQ19+1

.TT128

 LDA QQ19
 STA K3
 LDA QQ19+1
 STA K4
 LDX #&00
 STX K4+1
 STX K3+1
 INX
 STX LSP
 LDX #&02
 STX STP
 JSR CIRCLE2

 RTS

.TT219

 JSR L27FA

 JSR TT163

 LDA #&80
 STA QQ17
 LDA #&00
 STA QQ29

.L2C44

 JSR TT151

 LDA QQ25
 BNE TT224

 JMP TT222

.TQ4

 LDY #&B0

.Tc

 JSR TT162

 TYA
 JSR prq

 JSR dn2

.TT224

 JSR CLYNS

 LDA #&CC
 JSR TT27

 LDA QQ29
 CLC
 ADC #&D0
 JSR TT27

 LDA #&2F
 JSR TT27

 JSR TT152

 LDA #&3F
 JSR TT27

 JSR TT67

 LDX #&00
 STX R
 LDX #&0C
 STX T1
 JSR gnum

 BCS TQ4

 STA P
 JSR tnpr

 LDY #&CE
 BCS Tc

 LDA QQ24
 STA Q
 JSR GCASH

 JSR LCASH

 LDY #&C5
 BCC Tc

 LDY QQ29
 LDA R
 PHA
 CLC
 ADC QQ20,Y
 STA QQ20,Y
 LDA AVL,Y
 SEC
 SBC R
 STA AVL,Y
 PLA
 BEQ TT222

 JSR dn

.TT222

 LDA QQ29
 CLC
 ADC #&05
 STA YC
 LDA #&00
 STA XC
 INC QQ29
 LDA QQ29
 CMP #&11
 BCS BAY2

 JMP L2C44

.BAY2

 LDA #&A7
 JMP FRCE

.gnum

 LDX #&00
 STX R
 LDX #&0C
 STX T1

.TT223

 JSR TT217

 STA Q
 SEC
 SBC #&30
 BCC OUT

 CMP #&0A
 BCS BAY2

 STA S
 LDA R
 CMP #&1A
 BCS OUT

 ASL A
 STA T
 ASL A
 ASL A
 ADC T
 ADC S
 STA R
 CMP QQ25
 BEQ TT226

 BCS OUT

.TT226

 LDA Q
 JSR TT26

 DEC T1
 BNE TT223

.OUT

 LDA R
 RTS

.TT208

 LDA #&04
 JSR TT66

 LDA #&04
 STA YC
 STA XC
 LDA #&CD
 JSR TT27

 LDA #&CE
 JSR TT68

.TT210

 LDY #&00

.TT211

 STY QQ29
 LDX QQ20,Y
 BEQ TT212

 TYA
 ASL A
 ASL A
 TAY
 LDA L4457,Y
 STA QQ19+1
 TXA
 PHA
 JSR TT69

 CLC
 LDA QQ29
 ADC #&D0
 JSR TT27

 LDA #&0E
 STA XC
 PLA
 TAX
 CLC
 JSR pr2

 JSR TT152

 LDA QQ11
 CMP #&04
 BNE TT212

 LDA #&CD
 JSR TT214

 BCC TT212

 LDA QQ29
 LDX #&FF
 STX QQ17
 JSR TT151

 LDY QQ29
 LDA QQ20,Y
 STA P
 LDA QQ24
 STA Q
 JSR GCASH

 JSR MCASH

 LDA #&00
 LDY QQ29
 STA QQ20,Y
 STA QQ17

.TT212

 LDY QQ29
 INY
 CPY #&11
 BCS L2D99

 JMP TT211

.L2D99

 LDA QQ11
 CMP #&04
 BNE L2DA5

 JSR dn2

 JMP BAY2

.L2DA5

 RTS

.TT213

 LDA #&08
 JSR TT66

 LDA #&0B
 STA XC
 LDA #&A4
 JSR TT60

 JSR NLIN4

 JSR fwl

 LDA CRGO
 CMP #&1A
 BCC L2DC6

 LDA #&6B
 JSR TT27

.L2DC6

 JMP TT210

.TT214

 PHA
 JSR TT162

 PLA
 JSR TT27

 LDA #&E1
 JSR TT27

 JSR TT217

 ORA #&20
 CMP #&79
 BEQ TT218

 LDA #&6E
 JMP TT26

.TT218

 JSR TT26

 SEC
 RTS

.TT16

 TXA
 PHA
 DEY
 TYA
 EOR #&FF
 PHA
 JSR TT103

 PLA
 STA K6
 LDA QQ10
 JSR TT123

 LDA QQ19+4
 STA QQ10
 STA QQ19+1
 PLA
 STA K6
 LDA QQ9
 JSR TT123

 LDA QQ19+4
 STA QQ9
 STA QQ19

.TT103

 LDA QQ11
 BEQ TT180

 BMI TT105

 LDA QQ9
 STA QQ19
 LDA QQ10
 LSR A
 STA QQ19+1
 LDA #&04
 STA QQ19+2
 JMP TT15

.TT123

 STA QQ19+4
 CLC
 ADC K6
 LDX K6
 BMI TT124

 BCC TT125

 RTS

.TT124

 BCC TT180

.TT125

 STA QQ19+4

.TT180

 RTS

.TT105

 LDA QQ9
 SEC
 SBC QQ0
 CMP #&26
 BCC TT179

 CMP #&E6
 BCC TT180

.TT179

 ASL A
 ASL A
 CLC
 ADC #&68
 STA QQ19
 LDA QQ10
 SEC
 SBC QQ1
 CMP #&26
 BCC L2E61

 CMP #&DC
 BCC TT180

.L2E61

 ASL A
 CLC
 ADC #&5A
 STA QQ19+1
 LDA #&08
 STA QQ19+2
 JMP TT15

.TT23

 LDA #&80
 JSR TT66

 LDA #&07
 STA XC
 LDA #&BE
 JSR NLIN3

 JSR TT14

 JSR TT103

 JSR TT81

 LDA #&00
 STA XX20
 LDX #&18

.EE3

 STA INWK,X
 DEX
 BPL EE3

.TT182

 LDA QQ15+3
 SEC
 SBC QQ0
 BCS TT184

 EOR #&FF
 ADC #&01

.TT184

 CMP #&14
 BCS TT187

 LDA QQ15+1
 SEC
 SBC QQ1
 BCS TT186

 EOR #&FF
 ADC #&01

.TT186

 CMP #&26
 BCS TT187

 LDA QQ15+3
 SEC
 SBC QQ0
 ASL A
 ASL A
 ADC #&68
 STA XX12
 LSR A
 LSR A
 LSR A
 STA XC
 INC XC
 LDA QQ15+1
 SEC
 SBC QQ1
 ASL A
 ADC #&5A
 STA Y1
 LSR A
 LSR A
 LSR A
 TAY
 LDX INWK,Y
 BEQ EE4

 INY
 LDX INWK,Y
 BEQ EE4

 DEY
 DEY
 LDX INWK,Y
 BNE ee1

.EE4

 STY YC
 CPY #&03
 BCC TT187

 DEX
 STX INWK,Y
 LDA #&80
 STA QQ17
 JSR cpl

.ee1

 LDA XX12
 STA XX15
 JSR CPIX4

.TT187

 JSR TT20

 INC XX20
 BEQ L2F0C

 JMP TT182

.TT81

 LDX #&05

.L2F04

 LDA QQ21,X
 STA QQ15,X
 DEX
 BPL L2F04

.L2F0C

 RTS

.TT111

 JSR TT81

 LDY #&7F
 STY T
 LDA #&00
 STA U

.TT130

 LDA QQ15+3
 SEC
 SBC QQ9
 BCS TT132

 EOR #&FF
 ADC #&01

.TT132

 LSR A
 STA S
 LDA QQ15+1
 SEC
 SBC QQ10
 BCS TT134

 EOR #&FF
 ADC #&01

.TT134

 LSR A
 CLC
 ADC S
 CMP T
 BCS TT135

 STA T
 LDX #&05

.TT136

 LDA QQ15,X
 STA QQ19,X
 DEX
 BPL TT136

.TT135

 JSR TT20

 INC U
 BNE TT130

 LDX #&05

.TT137

 LDA QQ19,X
 STA QQ15,X
 DEX
 BPL TT137

 LDA QQ15+1
 STA QQ10
 LDA QQ15+3
 STA QQ9
 SEC
 SBC QQ0
 BCS TT139

 EOR #&FF
 ADC #&01

.TT139

 JSR SQUA2

 STA K+1
 LDA P
 STA K
 LDA QQ10
 SEC
 SBC QQ1
 BCS TT141

 EOR #&FF
 ADC #&01

.TT141

 LSR A
 JSR SQUA2

 PHA
 LDA P
 CLC
 ADC K
 STA Q
 PLA
 ADC K+1
 STA R
 JSR LL5

 LDA Q
 ASL A
 LDX #&00
 STX QQ8+1
 ROL QQ8+1
 ASL A
 ROL QQ8+1
 STA QQ8
 JMP TT24

.hy6

 JSR CLYNS

 LDA #&0F
 STA XC
 JMP TT27

.hyp

 LDA QQ12
 BNE hy6

 LDA QQ22+1
 BNE hy5

 LDX #&01
 JSR CTRL

 BMI Ghy

 JSR hm

 LDA QQ8
 ORA QQ8+1
 BEQ hy5

 LDA #&07
 STA XC
 LDA #&17
 STA YC
 LDA #&00
 STA QQ17
 LDA #&BD
 JSR TT27

 LDA QQ8+1
 BNE TT147

 LDA QQ14
 CMP QQ8
 BCC TT147

 LDA #&2D
 JSR TT27

 JSR cpl

.wW

 LDA #&0F
 STA QQ22+1
 STA QQ22
 TAX
 JMP L304B

.Ghy

 LDX GHYP
 BEQ hy5

 INX
 STX GHYP
 STX FIST
 JSR wW

 LDX #&05
 INC GCNT
 LDA GCNT
 AND #&07
 STA GCNT

.G1

 LDA QQ21,X
 ASL A
 ROL QQ21,X
 DEX
 BPL G1

.L3023

 LDA #&60
hy5 = L3023+1
 STA QQ9
 STA QQ10
 JSR TT110

 JSR TT111

 LDX #&00
 STX QQ8
 STX QQ8+1
 LDA #&74
 JSR MESS

.jmp

 LDA QQ9
 STA QQ0
 LDA QQ10
 STA QQ1
 RTS

.L304B

 LDY #&01
 STY YC
 DEY
 STY XC

.pr6

 CLC

.pr5

 LDA #&05
 JMP TT11

.TT147

 LDA #&CA

.prq

 JSR TT27

 LDA #&3F
 JMP TT27

.TT151

 PHA
 STA QQ19+4
 ASL A
 ASL A
 STA QQ19
 LDA #&01
 STA XC
 PLA
 ADC #&D0
 JSR TT27

 LDA #&0E
 STA XC
 LDX QQ19
 LDA L4457,X
 STA QQ19+1
 LDA QQ26
 AND L4459,X
 CLC
 ADC QQ23,X
 STA QQ24
 JSR TT152

 JSR var

 LDA QQ19+1
 BMI TT155

 LDA QQ24
 ADC K6
 JMP TT156

.TT155

 LDA QQ24
 SEC
 SBC K6

.TT156

 STA QQ24
 STA P
 LDA #&00
 JSR GC2

 SEC
 JSR pr5

 LDY QQ19+4
 LDA #&05
 LDX AVL,Y
 STX QQ25
 CLC
 BEQ TT172

 JSR L1C35

 JMP TT152

.TT172

 LDA XC
 ADC #&04
 STA XC
 LDA #&2D
 BNE L30DD

.TT152

 LDA QQ19+1
 AND #&60
 BEQ TT160

 CMP #&20
 BEQ TT161

 JSR TT16a

.TT162

 LDA #&20

.L30DD

 JMP TT27

.TT160

 LDA #&74
 JSR TT26

 BCC TT162

.TT161

 LDA #&6B
 JSR TT26

.TT16a

 LDA #&67
 JMP TT26

.TT163

 LDA #&11
 STA XC
 LDA #&FF
 BNE L30DD

.TT167

 LDA #&10
 JSR TT66

 LDA #&05
 STA XC
 LDA #&A7
 JSR NLIN3

 LDA #&03
 STA YC
 JSR TT163

 LDA #&00
 STA QQ29

.TT168

 LDX #&80
 STX QQ17
 JSR TT151

 INC YC
 INC QQ29
 LDA QQ29
 CMP #&11
 BCC TT168

 RTS

.var

 LDA QQ19+1
 AND #&1F
 LDY QQ28
 STA QQ19+2
 CLC
 LDA #&00
 STA AVL+16

.TT153

 DEY
 BMI TT154

 ADC QQ19+2
 JMP TT153

.TT154

 STA K6
 RTS

.hyp1

 JSR TT111

 JSR jmp

 LDX #&05

.TT112

 LDA QQ15,X
 STA QQ2,X
 DEX
 BPL TT112

 INX
 STX EV
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov
 RTS

.GVL

 JSR DORND

 STA QQ26
 LDX #&00
 STX XX4

.hy9

 LDA L4457,X
 STA QQ19+1
 JSR var

 LDA L4459,X
 AND QQ26
 CLC
 ADC L4458,X
 LDY QQ19+1
 BMI TT157

 SEC
 SBC K6
 JMP TT158

.TT157

 CLC
 ADC K6

.TT158

 BPL TT159

 LDA #&00

.TT159

 LDY XX4
 AND #&3F
 STA AVL,Y
 INY
 TYA
 STA XX4
 ASL A
 ASL A
 TAX
 CMP #&3F
 BCC hy9

.hyR

 RTS

.TT18

 LDA QQ14
 SEC
 SBC QQ8
 STA QQ14
 LDA QQ11
 BNE ee5

 JSR TT66

 JSR LL164

.ee5

 JSR hyp1

 JSR GVL

 JSR RES2

 JSR SOLAR

 LDA QQ11
 AND #&3F
 BNE hyR

 JSR TTX66

 LDA QQ11
 BNE TT114

 INC QQ11

.TT110

 LDX QQ12
 BEQ NLUNCH

 JSR LAUN

 JSR RES2

 JSR TT111

 INC INWK+8
 JSR SOS1

 LDA #&80
 STA INWK+8
 INC INWK+7
 JSR NWSPS

 LDA #&0C
 STA DELTA
 JSR BAD

 ORA FIST
 STA FIST

.NLUNCH

 LDX #&00
 STX QQ12
 JMP LOOK1

.TT114

 BMI TT115

 JMP TT22

.TT115

 JMP TT23

.LCASH

 STX T1
 LDA CASH+3
 SEC
 SBC T1
 STA CASH+3
 STY T1
 LDA CASH+2
 SBC T1
 STA CASH+2
 LDA CASH+1
 SBC #&00
 STA CASH+1
 LDA CASH
 SBC #&00
 STA CASH
 BCS TT113

.MCASH

 TXA
 CLC
 ADC CASH+3
 STA CASH+3
 TYA
 ADC CASH+2
 STA CASH+2
 LDA CASH+1
 ADC #&00
 STA CASH+1
 LDA CASH
 ADC #&00
 STA CASH
 CLC

.TT113

 RTS

.GCASH

 JSR MULTU

.GC2

 ASL P
 ROL A
 ASL P
 ROL A
 TAY
 LDX P
 RTS

.bay_lc

 JMP BAY

.EQSHP

 JSR DIALS

 LDA #&20
 JSR TT66

 LDA #&0C
 STA XC
 LDA #&CF
 JSR spc

 LDA #&B9
 JSR NLIN3

 LDA #&80
 STA QQ17
 INC YC
 LDA tek
 CLC
 ADC #&03
 CMP #&0C
 BCC L328E

 LDA #&0C

.L328E

 STA Q
 STA QQ25
 INC Q
 LDA #&46
 SEC
 SBC QQ14
 ASL A
 STA L1B45
 LDX #&01

.EQL1

 STX XX13
 JSR TT67

 LDX XX13
 CLC
 JSR pr2

 JSR TT162

 LDA XX13
 CLC
 ADC #&68
 JSR TT27

 LDA XX13
 JSR L33EC

 SEC
 LDA #&19
 STA XC
 LDA #&06
 JSR TT11

 LDX XX13
 INX
 CPX Q
 BCC EQL1

 JSR CLYNS

 LDA #&7F
 JSR prq

 JSR gnum

 BEQ bay_lc

 BCS bay_lc

 SBC #&00
 LDX #&02
 STX XC
 INC YC
 PHA
 JSR eq

 PLA
 BNE et0

 STA MCNT
 LDX #&46
 STX QQ14

.et0

 CMP #&01
 BNE et1

 LDX NOMSL
 INX
 LDY #&75
 CPX #&05
 BCS pres

 STX NOMSL
 JSR msblob

.et1

 LDY #&6B
 CMP #&02
 BNE et2

 LDX #&25
 CPX CRGO
 BEQ pres

 STX CRGO

.et2

 CMP #&03
 BNE et3

 INY
 LDX ECM
 BNE pres

 DEC ECM

.et3

 CMP #&04
 BNE et4

 JSR qv

 LDA #&04
 LDY LASER,X
 BEQ ed4

.ed7

 LDY #&BB
 BNE pres

.ed4

 LDA #&0F
 STA LASER,X
 LDA #&04

.et4

 CMP #&05
 BNE et5

 JSR qv

 STX T1
 LDA #&05
 LDY LASER,X
 BEQ ed5

 BMI ed7

 LDA #&04
 JSR prx

 JSR MCASH

.ed5

 LDA #&8F
 LDX T1
 STA LASER,X

.et5

 LDY #&6F
 CMP #&06
 BNE et6

 LDX BST
 BEQ ed9

.pres

 STY K
 JSR prx

 JSR MCASH

 LDA K
 JSR spc

 LDA #&1F
 JSR TT27

.err

 JSR dn2

 JMP BAY

.ed9

 DEC BST

.et6

 INY
 CMP #&07
 BNE et7

 LDX ESCP
 BNE pres

 DEC ESCP

.et7

 INY
 CMP #&08
 BNE et8

 LDX BOMB
 BNE pres

 LDX #&7F
 STX BOMB

.et8

 INY
 CMP #&09
 BNE etA

 LDX ENGY
 BNE pres

 INC ENGY

.etA

 INY
 CMP #&0A
 BNE etB

 LDX DKCMP
 BNE pres

 DEC DKCMP

.etB

 INY
 CMP #&0B
 BNE et9

 LDX GHYP
 BNE pres

 DEC GHYP

.et9

 JSR dn

 JMP EQSHP

.dn

 JSR TT162

 LDA #&77
 JSR spc

.dn2

 JSR BEEP

 LDY #&C8
 JMP DELAY

.eq

 JSR prx

 JSR LCASH

 BCS c

 LDA #&C5
 JSR prq

 JMP err

.L33EC

 SEC
 SBC #&01

.prx

 ASL A
 TAY
 LDX L1B45,Y
 LDA L1B46,Y
 TAY

.c

 RTS

.qv

 LDY #&10
 STY YC

.qv1

 LDX #&0C
 STX XC
 TYA
 CLC
 ADC #&20
 JSR spc

 LDA YC
 CLC
 ADC #&50
 JSR TT27

 INC YC
 LDY YC
 CPY #&14
 BCC qv1

.qv3

 JSR CLYNS

 LDA #&AF
 JSR prq

 JSR TT217

 SEC
 SBC #&30
 CMP #&04
 BCS qv3

 TAX
 RTS

 EQUB &8C

 EQUB &E7, &8D, &E6, &C1, &C8, &C8, &E6, &D6
 EQUB &C5, &C6, &C1, &CA, &83, &9C, &90

.cpl

 LDX #&05

.TT53

 LDA QQ15,X
 STA QQ19,X
 DEX
 BPL TT53

 LDY #&03
 BIT QQ15
 BVS L344C

 DEY

.L344C

 STY T

.TT55

 LDA QQ15+5
 AND #&1F
 BEQ L3459

 ORA #&80
 JSR TT27

.L3459

 JSR TT54

 DEC T
 BPL TT55

 LDX #&05

.TT56

 LDA QQ19,X
 STA QQ15,X
 DEX
 BPL TT56

 RTS

.cmn

 LDY #&00

.QUL4

 LDA L159D,Y
 CMP #&0D
 BEQ L3479

 JSR TT26

 INY
 BNE QUL4

.L3479

 RTS

.ypl

 JSR TT62

 JSR cpl

.TT62

 LDX #&05

.TT78

 LDA QQ15,X
 LDY QQ2,X
 STA QQ2,X
 STY QQ15,X
 DEX
 BPL TT78

 RTS

.tal

 CLC
 LDX GCNT
 INX
 JMP pr2

.fwl

 LDA #&69
 JSR TT68

 LDX QQ14
 SEC
 JSR pr2

 LDA #&C3
 JSR plf

 LDA #&77
 BNE TT27

.csh

 LDX #&03

.pc1

 LDA CASH,X
 STA K,X
 DEX
 BPL pc1

 LDA #&09
 STA U
 SEC
 JSR BPRNT

 LDA #&E2

.plf

 JSR TT27

 JMP TT67

.TT68

 JSR TT27

.TT73

 LDA #&3A

.TT27

 TAX
 BEQ csh

 BMI TT43

 DEX
 BEQ tal

 DEX
 BEQ ypl

 DEX
 BNE L34DD

 JMP cpl

.L34DD

 DEX
 BEQ cmn

 DEX
 BEQ fwl

 DEX
 BNE L34EB

 LDA #&80
 STA QQ17
 RTS

.L34EB

 DEX
 DEX
 BNE L34F2

 STX QQ17
 RTS

.L34F2

 DEX
 BEQ crlf

 CMP #&60
 BCS ex

 CMP #&0E
 BCC L3501

 CMP #&20
 BCC qw

.L3501

 LDX QQ17
 BEQ TT74

 BMI TT41

 BIT QQ17
 BVS TT46

.TT42

 CMP #&41
 BCC TT44

 CMP #&5B
 BCS TT44

 ADC #&20

.TT44

 JMP TT26

.TT41

 BIT QQ17
 BVS TT45

 CMP #&41
 BCC TT74

 PHA
 TXA
 ORA #&40
 STA QQ17
 PLA
 BNE TT44

.qw

 ADC #&72
 BNE ex

.crlf

 LDA #&15
 STA XC
 BNE TT73

.TT45

 CPX #&FF
 BEQ TT48

 CMP #&41
 BCS TT42

.TT46

 PHA
 TXA
 AND #&BF
 STA QQ17
 PLA

.TT74

 JMP TT26

.TT43

 CMP #&A0
 BCS TT47

 AND #&7F
 ASL A
 TAY
 LDA L4416,Y
 JSR TT27

 LDA L4417,Y
 CMP #&3F
 BEQ TT48

 JMP TT27

.TT47

 SBC #&A0

.ex

 TAX
 LDA #&00
 STA V
 LDA #&04
 STA V+1
 LDY #&00
 TXA
 BEQ TT50

.TT51

 LDA (V),Y
 BEQ TT49

 INY
 BNE TT51

 INC V+1
 BNE TT51

.TT49

 INY
 BNE TT59

 INC V+1

.TT59

 DEX
 BNE TT51

.TT50

 TYA
 PHA
 LDA V+1
 PHA
 LDA (V),Y
 EOR #&23
 JSR TT27

 PLA
 STA V+1
 PLA
 TAY
 INY
 BNE L3596

 INC V+1

.L3596

 LDA (V),Y
 BNE TT50

.TT48

 RTS

.EX2

 LDA INWK+31
 ORA #&A0
 STA INWK+31
 RTS

.DOEXP

 LDA INWK+31
 AND #&40
 BEQ L35AB

 JSR PTCLS

.L35AB

 LDA INWK+6
 STA T
 LDA INWK+7
 CMP #&20
 BCC L35B9

 LDA #&FE
 BNE L35C1

.L35B9

 ASL T
 ROL A
 ASL T
 ROL A
 SEC
 ROL A

.L35C1

 STA Q
 LDY #&01
 LDA (XX19),Y
 ADC #&04
 BCS EX2

 STA (XX19),Y
 JSR DVID4

 LDA P
 CMP #&1C
 BCC L35DA

 LDA #&FE
 BNE LABEL_1

.L35DA

 ASL R
 ROL A
 ASL R
 ROL A
 ASL R
 ROL A

.LABEL_1

 DEY
 STA (XX19),Y
 LDA INWK+31
 AND #&BF
 STA INWK+31
 AND #&08
 BEQ TT48

 LDY #&02
 LDA (XX19),Y
 TAY

.EXL1

 LDA XX3-7,Y
 STA (XX19),Y
 DEY
 CPY #&06
 BNE EXL1

 LDA INWK+31
 ORA #&40
 STA INWK+31

.PTCLS

 LDY #&00
 LDA (XX19),Y
 STA Q
 INY
 LDA (XX19),Y
 BPL L3612

 EOR #&FF

.L3612

 LSR A
 LSR A
 LSR A
 LSR A
 ORA #&01
 STA U
 INY
 LDA (XX19),Y
 STA TGT
 LDA RAND+1
 PHA
 LDY #&06

.EXL5

 LDX #&03

.EXL3

 INY
 LDA (XX19),Y
 STA K3,X
 DEX
 BPL EXL3

 STY CNT
 LDY #&02

.EXL2

 INY
 LDA (XX19),Y
 EOR CNT
 STA &FFFD,Y
 CPY #&06
 BNE EXL2

 LDY U

.EXL4

 JSR DORND2

 STA ZZ
 LDA K3+1
 STA R
 LDA K3
 JSR EXS1

 BNE EX11

 CPX #&BF
 BCS EX11

 STX Y1
 LDA K3+3
 STA R
 LDA K3+2
 JSR EXS1

 BNE EX4

 LDA Y1
 JSR PIXEL

.EX4

 DEY
 BPL EXL4

 LDY CNT
 CPY TGT
 BCC EXL5

 PLA
 STA RAND+1
 LDA K%+6
 STA RAND+3
 RTS

.EX11

 JSR DORND2

 JMP EX4

.EXS1

 STA S
 JSR DORND2

 ROL A
 BCS EX5

 JSR FMLTU

 ADC R
 TAX
 LDA S
 ADC #&00
 RTS

.EX5

 JSR FMLTU

 STA T
 LDA R
 SBC T
 TAX
 LDA S
 SBC #&00
 RTS

.SOS1

 JSR msblob

 LDA #&7F
 STA INWK+29
 STA INWK+30
 LDA tek
 AND #&02
 ORA #&80
 JMP NWSHP

.SOLAR

 LSR FIST
 JSR ZINF

 LDA QQ15+1
 AND #&07
 ADC #&06
 LSR A
 STA INWK+8
 ROR A
 STA INWK+2
 STA INWK+5
 JSR SOS1

 LDA #&81
 JSR NWSHP

.NWSTARS

 LDA QQ11
 BNE WPSHPS

.nWq

 LDY #&0A

.SAL4

 JSR DORND

 ORA #&08
 STA SZ,Y
 STA ZZ
 JSR DORND

 STA SX,Y
 STA XX15
 JSR DORND

 STA SY,Y
 STA Y1
 JSR PIXEL2

 DEY
 BNE SAL4

.WPSHPS

 LDX #&00

.WSL1

 LDA FRIN,X
 BEQ WS2

 BMI WS1

 STA TYPE
 JSR GINF

 LDY #&1F

.WAL2

 LDA (INF),Y
 STA INWK,Y
 DEY
 BPL WAL2

 STX XSAV
 JSR SCAN

 LDX XSAV
 LDY #&1F
 LDA (INF),Y
 AND #&A7
 STA (INF),Y

.WS1

 INX
 BNE WSL1

.WS2

 LDX #&FF
 STX LSX2
 STX LSY2

.L3727

 DEX
 RTS

.SHD

 INX
 BEQ L3727

.DENGY

 DEC ENERGY
 PHP
 BNE L3735

 INC ENERGY

.L3735

 PLP
 RTS

.COMPAS

 JSR DOT

 LDA SSPR
 BNE SP1

 JSR SPS1

 JMP SP2

.SPS2

 ASL A
 TAX
 LDA #&00
 ROR A
 TAY
 LDA #&14
 STA Q
 TXA
 JSR DVID4

 LDX P
 TYA
 BMI LL163

 LDY #&00
 RTS

.LL163

 LDY #&FF
 TXA
 EOR #&FF
 TAX
 INX
 RTS

.SPS4

 LDX #&08

.SPL1

 LDA K%+&24,X
 STA K3,X
 DEX
 BPL SPL1

 JMP TAS2

.SP1

 JSR SPS4

.SP2

 LDA XX15
 JSR SPS2

 TXA
 ADC #&C1
 STA COMX
 LDA Y1
 JSR SPS2

 STX T
 LDA #&CC
 SBC T
 STA COMY
 LDA #&F0
 LDX X2
 BPL L3794

 LDA #&FF

.L3794

 STA COMC

.DOT

 LDA COMY
 STA Y1
 LDA COMX
 STA XX15
 LDA COMC
 CMP #&F0
 BNE CPIX2

.CPIX4

 JSR CPIX2

 DEC Y1

.CPIX2

 LDY #&80
 STY SC
 LDA Y1
 LSR A
 LSR A
 LSR A
 STA SCH
 LSR A
 ROR SC
 LSR A
 ROR SC
 ADC SCH
 ADC #&58
 STA SCH
 LDA XX15
 AND #&F8
 ADC SC
 STA SC
 BCC L37D0

 INC SCH

.L37D0

 LDA Y1
 AND #&07
 TAY
 LDA XX15
 AND #&07
 TAX
 LDA TWOS,X
 EOR (SC),Y
 STA (SC),Y
 JSR L37E4

.L37E4

 INX
 LDA TWOS,X
 BPL CP1

 LDA SC
 CLC
 ADC #&08
 STA SC
 BCC L37F5

 INC SCH

.L37F5

 LDA TWOS,X

.CP1

 EOR (SC),Y
 STA (SC),Y
 RTS

.OOPS

 STA T
 LDY #&08
 LDX #&00
 LDA (INF),Y
 BMI OO1

 LDA FSH
 SBC T
 BCC OO2

 STA FSH
 RTS

.OO2

 STX FSH
 BCC OO3

.OO1

 LDA ASH
 SBC T
 BCC OO5

 STA ASH
 RTS

.OO5

 STX ASH

.OO3

 ADC ENERGY
 STA ENERGY
 BEQ L382F

 BCS L3832

.L382F

 JMP DEATH

.L3832

 JSR EXNO3

 JMP OUCH

.SPS3

 LDA K%+1,X
 STA K3,X
 LDA K%+2,X
 TAY
 AND #&7F
 STA K3+1,X
 TYA
 AND #&80
 STA K3+2,X
 RTS

.GINF

 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA INF
 LDA L15F2,Y
 STA INF+1
 RTS

.NWSPS

 JSR SPBLB

 LDX #&01
 STX INWK+32
 DEX
 STX INWK+30
 STX FRIN+1
 DEX
 STX INWK+29
 LDX #&0A
 JSR NwS1

 JSR NwS1

 JSR NwS1

 LDA #&08
 STA XX19
 LDA #&0C
 STA INWK+34
 LDA #&07

.NWSHP

 STA T
 LDX #&00

.NWL1

 LDA FRIN,X
 BEQ NW1

 INX
 CPX #&0C
 BCC NWL1

 CLC

.L388D

 RTS

.NW1

 JSR GINF

 LDA T
 BMI NW2

 ASL A
 TAY
 LDA L4ED2,Y
 STA XX0
 LDA L4ED3,Y
 STA XX0+1
 CPY #&0E
 BEQ NW6

 LDY #&05
 LDA (XX0),Y
 STA T1
 LDA SLSP
 SEC
 SBC T1
 STA XX19
 LDA SLSP+1
 SBC #&00
 STA INWK+34
 LDA XX19
 SBC INF
 TAY
 LDA INWK+34
 SBC INF+1
 BCC L388D

 BNE NW4

 CPY #&24
 BCC L388D

.NW4

 LDA XX19
 STA SLSP
 LDA INWK+34
 STA SLSP+1

.NW6

 LDY #&0E
 LDA (XX0),Y
 STA INWK+35
 LDY #&13
 LDA (XX0),Y
 AND #&07
 STA INWK+31
 LDA T

.NW2

 STA FRIN,X
 TAX
 BMI L38EE

 INC MANY,X

.L38EE

 LDY #&23

.NWL3

 LDA INWK,Y
 STA (INF),Y
 DEY
 BPL NWL3

 SEC
 RTS

.NwS1

 LDA INWK,X
 EOR #&80
 STA INWK,X
 INX
 INX
 RTS

.L3903

 LDY #&09

.ABORT

 LDX #&FF

.ABORT2

 STX MSTG
 LDX NOMSL
 JSR MSBAR

 STY MSAR
 RTS

.ECBLB2

 LDA #&20
 STA ECMA
 ASL A
 JSR NOISE

.ECBLB

 LDA #&98
 LDX #&35
 LDY #&7C
 BNE BULB

.SPBLB

 LDA #&20
 LDX #&38
 LDY #&7D

.BULB

 STA SC
 STX P+1
 LDX #&39
 STX P+2
 TYA
 JMP RREN

.L3935

 EQUB &FE

 EQUB &FE, &E0

 EQUB &FE, &FE, &E0, &FE, &FE, &0E, &FE, &FE

.MSBAR

 TXA
 PHA
 ASL A
 ASL A
 ASL A
 STA T
 LDA #&D1
 SBC T
 STA SC
 LDA #&7D
 STA SCH
 TYA
 TAX
 LDY #&05

.MBL1

 LDA L3961,X
 STA (SC),Y
 DEX
 DEY
 BNE MBL1

 PLA
 TAX
 RTS

.L3961

 EQUB &00

 EQUB &00, &00, &00, &00, &FC, &FC, &FC, &FC
 EQUB &FC, &84, &B4, &84, &FC, &C4, &EC, &EC
 EQUB &FC

.PROJ

 LDA INWK
 STA P
 LDA INWK+1
 STA P+1
 LDA INWK+2
 JSR PLS6

 BCS RTS2

 LDA K
 ADC #&80
 STA K3
 TXA
 ADC #&00
 STA K3+1
 LDA INWK+3
 STA P
 LDA INWK+4
 STA P+1
 LDA INWK+5
 EOR #&80
 JSR PLS6

 BCS RTS2

 LDA K
 ADC #&60
 STA K4
 TXA
 ADC #&00
 STA K4+1
 CLC

.RTS2

 RTS

.PL2

 JMP WPLS2

.PLANET

 LDA TYPE
 LSR A
 BCS RTS2

 LDA INWK+8
 BMI PL2

 CMP #&30
 BCS PL2

 ORA INWK+7
 BEQ PL2

 JSR PROJ

 BCS PL2

 LDA #&60
 STA P+1
 LDA #&00
 STA P
 JSR DVID3B2

 LDA K+1
 BEQ PL82

 LDA #&F8
 STA K

.PL82

 JSR WPLS2

 JMP CIRCLE

.CIRCLE

 JSR CHKON

 BCS RTS2

 LDA #&00
 STA LSX2
 LDX K
 LDA #&08
 CPX #&09
 BCC PL89

 LSR A

.PL89

 STA STP

.CIRCLE2

 LDX #&FF
 STX FLAG
 INX
 STX CNT

.PLL3

 LDA CNT
 JSR FMLTU2

 LDX #&00
 STX T
 LDX CNT
 CPX #&21
 BCC PL37

 EOR #&FF
 ADC #&00
 TAX
 LDA #&FF
 ADC #&00
 STA T
 TXA
 CLC

.PL37

 ADC K3
 STA K6
 LDA K3+1
 ADC T
 STA QQ19+4
 LDA CNT
 CLC
 ADC #&10
 JSR FMLTU2

 TAX
 LDA #&00
 STA T
 LDA CNT
 ADC #&0F
 AND #&3F
 CMP #&21
 BCC PL38

 TXA
 EOR #&FF
 ADC #&00
 TAX
 LDA #&FF
 ADC #&00
 STA T
 CLC

.PL38

 JSR BLINE

 CMP #&41
 BCS L3A4D

 JMP PLL3

.L3A4D

 CLC
 RTS

.WPLS2

 LDY LSX2
 BNE WP1

.WPL1

 CPY LSP
 BCS WP1

 LDA LSY2,Y
 CMP #&FF
 BEQ WP2

 STA Y2
 LDA LSX2,Y
 STA X2
 JSR LL30

 INY
 LDA SWAP
 BNE WPL1

 LDA X2
 STA XX15
 LDA Y2
 STA Y1
 JMP WPL1

.WP2

 INY
 LDA LSX2,Y
 STA XX15
 LDA LSY2,Y
 STA Y1
 INY
 JMP WPL1

.WP1

 LDA #&01
 STA LSP
 LDA #&FF
 STA LSX2
 RTS

.CHKON

 LDA K3
 CLC
 ADC K
 LDA K3+1
 ADC #&00
 BMI PL21

 LDA K3
 SEC
 SBC K
 LDA K3+1
 SBC #&00
 BMI PL31

 BNE PL21

.PL31

 LDA K4
 CLC
 ADC K
 STA P+1
 LDA K4+1
 ADC #&00
 BMI PL21

 STA P+2
 LDA K4
 SEC
 SBC K
 TAX
 LDA K4+1
 SBC #&00
 BMI PL44

 BNE PL21

 CPX #&BF
 RTS

.PL21

 SEC
 RTS

.PLS6

 JSR DVID3B2

 LDA K+3
 AND #&7F
 ORA K+2
 BNE PL21

 LDX K+1
 CPX #&04
 BCS PL6

 LDA K+3
 BPL PL6

 LDA K
 EOR #&FF
 ADC #&01
 STA K
 TXA
 EOR #&FF
 ADC #&00
 TAX

.PL44

 CLC

.PL6

 RTS

.TT17

 JSR DOKEY

 LDX JSTK
 BEQ TJ1

 LDA JSTX
 EOR #&FF
 JSR TJS1

 TYA
 TAX
 LDA JSTY

.TJS1

 TAY
 LDA #&00
 CPY #&10
 SBC #&00
 CPY #&40
 SBC #&00
 CPY #&C0
 ADC #&00
 CPY #&E0
 ADC #&00
 TAY
 LDA KL
 RTS

.TJ1

 LDA KL
 LDY #&00
 CMP #&18
 BNE L3B24

 DEX

.L3B24

 CMP #&78
 BNE L3B29

 INX

.L3B29

 CMP #&39
 BNE L3B2E

 INY

.L3B2E

 CMP #&28
 BNE L3B33

 DEY

.L3B33

 RTS

.ping

 LDX #&01

.pl1

 LDA QQ0,X
 STA QQ9,X
 DEX
 BPL pl1

 RTS

.KS3

 LDA P
 STA SLSP
 LDA P+1
 STA SLSP+1
 RTS

.KS1

 LDX XSAV
 JSR KILLSHP

 LDX XSAV
 JMP MAL1

.KS4

 JSR ZINF

 LDA #&00
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

 CMP #&08
 BNE KSL4

 TXA
 ASL A
 TAY
 LDA UNIV,Y
 STA SC
 LDA L15F2,Y
 STA SCH
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

 JSR L3903

 LDA #&C8
 JSR MESS

.KS5

 LDY XX4
 LDX FRIN,Y
 CPX #&07
 BEQ KS4

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
 BEQ KS2

 ASL A
 TAY
 LDA L4ED2,Y
 STA SC
 LDA L4ED3,Y
 STA SCH
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
 LDA L15F2,Y
 STA SCH
 LDY #&23
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
 LDA SCH
 STA INF+1
 LDY T

.KSL3

 DEY
 LDA (K),Y
 STA (P),Y
 TYA
 BNE KSL3

 BEQ KSL1

.L3C3C

 EQUB &11

 EQUB &01, &00, &03, &11, &02, &2C, &04, &11
 EQUB &03, &F0, &06, &10, &F1, &04, &05, &01
 EQUB &F1, &BC, &01, &11, &F4, &0C, &08, &10
 EQUB &F1, &04, &06, &10, &02, &60, &10, &11
 EQUB &04, &C2, &FF, &11, &00, &00, &00

.L3C64

 EQUB &70, &24, &56, &56, &42, &28, &C8, &D0
 EQUB &F0, &E0

.RESET

 JSR ZERO

.L3C71

 LDX #&06

.SAL3

 STA BETA,X
 DEX
 BPL SAL3

 STX QQ12

.RES4

 LDA #&FF
 LDX #&02

.REL5

 STA FSH,X
 DEX
 BPL REL5

.RES2

 LDX #&FF
 STX LSX2
 STX LSY2
 STX MSTG
 LDA #&80
 STA JSTY
 STA ALP2
 STA BET2
 ASL A
 STA ALP2+1
 STA BET2+1
 STA MCNT
 LDA #&03
 STA DELTA
 STA ALPHA
 STA ALP1
 LDA SSPR
 BEQ L3CAD

 JSR SPBLB

.L3CAD

 LDA ECMA
 BEQ yu

 JSR ECMOF

.yu

 JSR WPSHPS

 JSR ZERO

 LDA #&DF
 STA SLSP
 LDA #&0B
 STA SLSP+1
 JSR DIALS

.ZINF

 LDY #&23
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

 LDY #&04
 JSR MSBAR

 DEX
 BNE ss

 RTS

.SAL8

 LDY #&09
 JSR MSBAR

 DEX
 BNE SAL8

 RTS

.me2

 LDA MCH
 JSR MESS

 LDA #&00
 STA DLY
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
 LDA #&20
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

 LSR A
 STA INWK+32
 STA INWK+29
 ROL INWK+31
 AND #&1F
 ORA #&10
 STA INWK+27
 LDA #&06
 JSR NWSHP

.TT100

 JSR M%

 DEC DLY
 BEQ me2

 BPL me3

 INC DLY

.me3

 DEC MCNT
 BEQ L3D5F

 JMP MLOOP

.L3D5F

 JSR DORND

 CMP #&23
 BCS MTT1

 LDA MANY+9
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

 CMP #&05
 LDA #&09
 BCS L3DB0

 LDA #&0A

.L3DB0

 JSR NWSHP

.MTT1

 LDA SSPR
 BNE MLOOP

 JSR BAD

 ASL A
 LDX MANY+2
 BEQ L3DC4

 ORA FIST

.L3DC4

 STA T
 JSR Ze

 CMP T
 BCS L3DD2

 LDA #&02
 JSR NWSHP

.L3DD2

 LDA MANY+2
 BNE MLOOP

 DEC EV
 BPL MLOOP

 INC EV
 JSR DORND

 LDY gov
 BEQ LABEL_2

 CMP #&5A
 BCS MLOOP

 AND #&07
 CMP gov
 BCC MLOOP

.LABEL_2

 JSR Ze

 CMP #&C8
 BCS mt1

 INC EV
 AND #&03
 ADC #&03
 TAY
 TXA
 CMP #&C8
 ROL A
 ORA #&C0
 STA INWK+32
 TYA
 JSR NWSHP

 JMP MLOOP

.mt1

 AND #&03
 STA EV
 STA XX13

.mt3

 JSR DORND

 AND #&03
 ORA #&01
 JSR NWSHP

 DEC XX13
 BPL mt3

.MLOOP

 LDA LASCT
 SBC #&04
 BCS L3E2E

 LDA #&00

.L3E2E

 STA LASCT
 LDX #&FF
 TXS
 INX
 STX L0D01
 LDX GNTMP
 BEQ EE20

 DEC GNTMP

.EE20

 JSR DIALS

 LDA QQ11
 BEQ L3E50

 AND PATG
 LSR A
 BCS L3E50

 JSR L285F

.L3E50

 JSR TT17

.FRCE

 JSR TT102

 LDA QQ12
 BNE MLOOP

.L3E5A

 JMP TT100

L3E5C = L3E5A+2
 EQUB &B1

 EQUB &91, &92

.TT102

 CMP #&A6
 BNE L3E67

 JMP STATUS

.L3E67

 CMP #&93
 BNE L3E6E

 JMP TT22

.L3E6E

 CMP #&B4
 BNE L3E75

 JMP TT23

.L3E75

 CMP #&A4
 BNE TT92

 JSR TT111

 JMP TT25

.TT92

 CMP #&A7
 BNE L3E86

 JMP TT213

.L3E86

 CMP #&95
 BNE L3E8D

 JMP TT167

.L3E8D

 CMP #&B0
 BNE fvw

 JMP TT110

.fvw

 BIT QQ12
 BPL INSP

 CMP #&92
 BNE L3E9F

 JMP EQSHP

.L3E9F

 CMP #&B1
 BNE L3EA6

 JMP TT219

.L3EA6

 CMP #&48
 BNE L3EAD

 JMP SVE

.L3EAD

 CMP #&91
 BNE LABEL_3

 JMP TT208

.INSP

 STX T
 LDX #&03

.L3EB8

 CMP L3E5C,X
 BNE L3EC0

 JMP LOOK1

.L3EC0

 DEX
 BNE L3EB8

 LDX T

.LABEL_3

 CMP #&54
 BNE L3ECC

 JMP hyp

.L3ECC

 CMP #&32
 BEQ T95

 STA T1
 LDA QQ11
 AND #&C0
 BEQ TT107

 LDA QQ22+1
 BNE TT107

 LDA T1
 CMP #&36
 BNE ee2

 JSR TT103

 JSR ping

 JSR TT103

.ee2

 JSR TT16

.TT107

 LDA QQ22+1
 BEQ t95_lc

 DEC QQ22
 BNE t95_lc

 LDX QQ22+1
 DEX
 JSR L304B

 LDA #&05
 STA QQ22
 LDX QQ22+1
 JSR L304B

 DEC QQ22+1
 BNE t95_lc

 JMP TT18

.t95_lc

 RTS

.T95

 LDA QQ11
 AND #&C0
 BEQ t95_lc

 JSR hm

 STA QQ17
 JSR cpl

 LDA #&80
 STA QQ17
 LDA #&01
 STA XC
 INC YC
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
 BCC MA34

 CMP INWK+4
 BCC MA34

 CMP INWK+7

.MA34

 RTS

.MAS4

 ORA INWK+1
 ORA INWK+4
 ORA INWK+7
 RTS

.DEATH

 JSR EXNO3

 JSR RES2

 ASL DELTA
 ASL DELTA
 JSR TT66

 LDX #&32
 STX LASCT
 JSR BOX

 JSR nWq

 LDA #&0C
 STA YC
 STA XC
 LDA #&92
 STA MCNT
 JSR ex

.D1

 JSR Ze

 LDA #&20
 STA INWK
 LDY #&00
 STY QQ11
 STY INWK+1
 STY INWK+4
 STY INWK+7
 STY INWK+32
 DEY
 EOR #&2A
 STA INWK+3
 ORA #&50
 STA INWK+6
 TXA
 AND #&8F
 STA INWK+29
 ROR A
 AND #&87
 STA INWK+30
 PHP
 LDX #&0A
 JSR fq1

 PLP
 LDA #&00
 ROR A
 LDY #&1F
 STA (INF),Y
 LDA FRIN+3
 BEQ D1

 JSR U%

 STA DELTA

.D2

 JSR M%

 DEC LASCT
 BNE D2

.DEATH2

 JSR RES2

 LDX #&FF
 TXS
 LDX #&03
 STX XC
 JSR FX200

 LDX #&06
 LDA #&80
 JSR TITLE

 CMP #&44
 BNE QU5

 JSR GTNME

 JSR LOD

 JSR TRNME

 JSR TTX66

.QU5

 LDX #&4B

.QUL1

 LDA L15A4,X
 STA TP-1,X
 DEX
 BNE QUL1

 STX QQ11

.L3FE4

 JSR CHECK

 CMP CHK
 BNE L3FE4

 EOR #&A9
 TAX
 LDA COK
 CPX CHK2
 BEQ tZ

 ORA #&80

.tZ

 ORA #&08
 STA COK
 JSR msblob

 LDA #&93
 LDX #&03
 JSR TITLE

 JSR ping

 JSR hyp1

.BAY

 LDA #&FF
 STA QQ12
 LDA #&A6
 JMP FRCE

.TITLE

 PHA
 STX TYPE
 JSR RESET

 LDA #&01
 JSR TT66

 DEC QQ11
 LDA #&60
 STA INWK+14
 STA INWK+7
 LDX #&7F
 STX INWK+29
 STX INWK+30
 INX
 STX QQ17
 LDA TYPE
 JSR NWSHP

 LDY #&06
 STY XC
 LDA #&1E
 JSR plf

 LDY #&06
 STY XC
 INC YC
 LDA PATG
 BEQ awe

 LDA #&FE
 JSR TT27

.awe

 JSR CLYNS

 STY DELTA
 STY JSTK
 PLA
 JSR ex

 LDA #&94
 LDX #&07
 STX XC
 JSR ex

.TLL2

 LDA INWK+7
 CMP #&01
 BEQ TL1

 DEC INWK+7

.TL1

 JSR MVEIT

 LDA #&80
 STA INWK+6
 ASL A
 STA INWK
 STA INWK+3
 JSR LL9

 DEC MCNT
 JSR RDKEY

 BEQ TLL2

 RTS

.CHECK

 LDX #&49
 CLC
 TXA

.QUL2

 ADC L15A4,X
 EOR L15A5,X
 DEX
 BNE QUL2

 RTS

.TRNME

 LDX #&07

.GTL1

 LDA INWK,X
 STA L159D,X
 DEX
 BPL GTL1

.TR1

 LDX #&07

.GTL2

 LDA L159D,X
 STA INWK,X
 DEX
 BPL GTL2

 RTS

.GTNME

 LDA #&01
 JSR TT66

 LDA #&7B
 JSR TT27

 JSR DEL8

 LDA #&0F
 TAX
 JSR OSBYTE

 LDX #&D2
 LDY #&40
 LDA #&00
 DEC L0D01
 JSR OSWORD

 INC L0D01
 BCS TR1

 TYA
 BEQ TR1

 JMP TT67

.L40D2

 EQUB &53

 EQUB &00, &07, &21, &7A

.ZERO

 LDX #&0B
 JSR ZES1

 DEX
 JSR ZES1

 DEX

.ZES1

 LDY #&00
 STY SC
 STX SCH

.ZES2

 LDA #&00

.ZEL1

 STA (SC),Y
 INY
 BNE ZEL1

 RTS

.SVE

 JSR GTNME

 JSR TRNME

 JSR ZERO

 LSR SVC
 LDX #&4B

.SVL1

 LDA TP,X
 STA K%,X
 STA L15A5,X
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
 JSR BPRNT

 JSR TT67

 JSR TT67

 PLA
 STA K%+&4B
 EOR #&A9
 STA CHK2
 STA K%+&4A
 LDY #&09
 STY &0A0B
 INY
 STY &0A0F
 LDA #&00
 JSR QUS1

 JMP BAY

.QUS1

 LDX #&53
 STX &0A00
 LDX #&FF
 STX L0D01
 INX
 JSR OSFILE

 INC L0D01
 RTS

.LOD

 LDX #&02
 JSR FX200

 JSR ZERO

 LDY #&09
 STY &0A03
 INC &0A0B
 INY
 LDA #&FF
 JSR QUS1

 LDA K%
 BMI L418E

 LDX #&4B

.LOL1

 LDA K%,X
 STA L15A5,X
 DEX
 BPL LOL1

 LDX #&03

.FX200

 LDY #&00
 LDA #&C8
 JMP OSBYTE

 RTS

.SPS1

 LDX #&00
L418E = SPS1+1
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

.RDKEY

 LDX #&10

.Rd1

 JSR CTRL

 BMI Rd2

 INX
 BPL Rd1

 TXA

.Rd2

 EOR #&80
 TAY
 JSR L42D6

 PHP
 TYA
 PLP
 BPL L4236

 ORA #&80

.L4236

 TAX

.NO1

 RTS

.ECMOF

 LDA #&00
 STA ECMA
 STA ECMP
 JSR ECBLB

 LDA #&48
 BNE NOISE

.EXNO3

 LDA #&18
 BNE NOISE

.SFRMIS

 LDX #&08
 JSR L2160

 BCC NO1

 LDA #&78
 JSR MESS

 LDA #&30
 BNE NOISE

.EXNO2

 INC TALLY
 BNE L4267

 INC TALLY+1
 LDA #&65
 JSR MESS

.L4267

 LDX #&07

.EXNO

 STX T
 LDA #&18
 JSR NOS1

 LDA INWK+7
 LSR A
 LSR A
 AND T
 ORA #&F1
 STA XX16+2
 JSR NO3

 LDA #&10
 EQUB &2C

.BEEP

 LDA #&20

.NOISE

 JSR NOS1

.NO3

 LDX DNOIZ
 BNE NO1

 LDA XX16
 AND #&01
 TAX
 LDY XX16+8
 LDA L3C64,Y
 CMP L0BFB,X
 BCC NO1

 STA L0BFB,X
 AND #&0F
 STA L0BFD,X
 LDX #&09
 LDY #&00
 LDA #&07
 JMP OSWORD

.NOS1

 STA XX16+8
 LSR A
 ADC #&03
 TAY
 LDX #&07

.NOL1

 LDA #&00
 STA XX16,X
 DEX
 LDA L3C3C,Y
 STA XX16,X
 DEY
 DEX
 BPL NOL1

.KYTB

 RTS

 EQUB &E8

 EQUB &E2, &E6, &E7, &C2, &D1, &C1, &17, &70
 EQUB &23, &35, &65, &22, &45, &52

.L42D0

 SEC
 CLV
 SEI
 JMP (L0D04)

.L42D6

 LDX #&40

.CTRL

 TYA
 PHA
 TXA
 PHA
 ORA #&80
 TAX
 JSR L42D0

 CLI
 TAX
 PLA
 AND #&7F
 CPX #&80
 BCC L42ED

 ORA #&80

.L42ED

 TAX
 PLA
 TAY
 TXA
 RTS

 LDA #&80
 JSR OSBYTE

 TYA
 EOR L0D23
 RTS

.DKS3

 STY T
 CPX T
 BNE Dk3

 LDA tek,X
 EOR #&FF
 STA tek,X
 JSR BELL

 JSR DELAY

 LDY T

.Dk3

 RTS

.U%

 LDA #&00
 LDY #&0F

.DKL3

 STA KL,Y
 DEY
 BNE DKL3

 RTS

.DOKEY

 JSR U%

 LDY #&07

.DKL2

 LDX KYTB,Y
 JSR CTRL

 BPL L432F

 LDX #&FF
 STX KL,Y

.L432F

 DEY
 BNE DKL2

 LDX JSTX
 LDA #&07
 LDY KY3
 BEQ L433D

 JSR BUMP2

.L433D

 LDY KY4
 BEQ L4344

 JSR REDU2

.L4344

 STX JSTX
 ASL A
 LDX JSTY
 LDY KY5
 BEQ L4350

 JSR REDU2

.L4350

 LDY KY6
 BEQ L4357

 JSR BUMP2

.L4357

 STX JSTY
 JSR RDKEY

 STX KL
 CPX #&38
 BNE DK2

.FREEZE

 JSR DEL8

 JSR RDKEY

 CPX #&51
 BNE DK6

 LDA #&00
 STA DNOIZ

.DK6

 LDY #&40

.DKL4

 JSR DKS3

 INY
 CPY #&47
 BNE DKL4

 CPX #&10
 BNE DK7

 STX DNOIZ

.DK7

 CPX #&70
 BNE L4389

 JMP DEATH2

.L4389

 CPX #&59
 BNE FREEZE

.DK2

 LDA QQ11
 BNE DK5

 LDY #&0F
 LDA #&FF

.DKL1

 LDX KYTB,Y
 CPX KL
 BNE DK1

 STA KL,Y

.DK1

 DEY
 CPY #&07
 BNE DKL1

.DK5

 RTS

.TT217

 STY YSAV
 DEC L0D01
 JSR OSRDCH

 INC L0D01
 TAX

.L43B1

 RTS

.me1

 STX DLY
 PHA
 LDA MCH
 JSR mes9

 PLA
 EQUB &2C

.ou2

 LDA #&6C
 EQUB &2C

.ou3

 LDA #&6F

.MESS

 LDX #&00
 STX QQ17
 LDY #&09
 STY XC
 LDY #&16
 STY YC
 CPX DLY
 BNE me1

 STY DLY
 STA MCH

.mes9

 JSR TT27

 LSR de
 BCC L43B1

 LDA #&FD
 JMP TT27

.OUCH

 JSR DORND

 BMI L43B1

 CPX #&16
 BCS L43B1

 LDA QQ20,X
 BEQ L43B1

 LDA DLY
 BNE L43B1

 LDY #&03
 STY de
 STA QQ20,X
 CPX #&11
 BCS ou1

 TXA
 ADC #&D0
 BNE MESS

.ou1

 BEQ ou2

 CPX #&12
 BEQ ou3

 TXA
 ADC #&5D
 BNE MESS

.L4416

 EQUB &41

.L4417

 EQUB &4C, &4C, &45, &58, &45, &47, &45, &5A
 EQUB &41, &43, &45, &42, &49, &53, &4F, &55
 EQUB &53, &45, &53, &41, &52, &4D, &41, &49
 EQUB &4E, &44, &49, &52, &45, &41, &3F, &45
 EQUB &52, &41, &54, &45, &4E, &42, &45, &52
 EQUB &41, &4C, &41, &56, &45, &54, &49, &45
 EQUB &44, &4F, &52, &51, &55, &41, &4E, &54
 EQUB &45, &49, &53, &52, &49, &4F, &4E

.QQ23

 EQUB &13

.L4457

 EQUB &82

.L4458

 EQUB &06

.L4459

 EQUB &01, &14, &81, &0A, &03, &41, &83, &02
 EQUB &07, &28, &85, &E2, &1F, &53, &85, &FB
 EQUB &0F, &C4, &08, &36, &03, &EB, &1D, &08
 EQUB &78, &9A, &0E, &38, &03, &75, &06, &28
 EQUB &07, &4E, &01, &11, &1F, &7C, &0D, &1D
 EQUB &07, &B0, &89, &DC, &3F, &20, &81, &35
 EQUB &03, &61, &A1, &42, &07, &AB, &A2, &37
 EQUB &1F, &2D, &C1, &FA, &0F, &35, &0F, &C0
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
 BCC L454E

 SBC Q

.L454E

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
 BCC L45A3

 SBC Q

.L45A3

 ROL P
 ROL P+1
 DEX
 BNE DVL2

 LDA P
 ORA T
 RTS

.SHPPT

 JSR EE51

 JSR PROJ

 ORA K3+1
 BNE nono

 LDA K4
 CMP #&BE
 BCS nono

 LDY #&02
 JSR Shpt

 LDY #&06
 LDA K4
 ADC #&01
 JSR Shpt

 LDA #&08
 ORA INWK+31
 STA INWK+31
 LDA #&08
 JMP L4C81

.L45D8

 PLA
 PLA

.nono

 LDA #&F7
 AND INWK+31
 STA INWK+31
 RTS

.Shpt

 STA (XX19),Y
 INY
 INY
 STA (XX19),Y
 LDA K3
 DEY
 STA (XX19),Y
 ADC #&03
 BCS L45D8

 DEY
 DEY
 STA (XX19),Y
 RTS

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

.L4630

 LDX #&FE
 STX R

.LL31

 ASL A
 BCS LL29

 CMP Q
 BCC L463D

 SBC Q

.L463D

 ROL R
 BCS LL31

 RTS

.LL29

 SBC Q
 SEC
 ROL R
 BCS LL31

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
 BCC L4662

 CLC
 RTS

.L4662

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

.ll51_lc

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
 BCC ll51_lc

 RTS

.LL25

 JMP PLANET

.LL9

 LDA TYPE
 BMI LL25

 LDA #&1F
 STA XX4
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
 BEQ L4724

 EOR INWK+31
 STA INWK+31
 JMP LL155

.L4724

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

.ll91_lc

 LDA INWK,X
 STA QQ17,X
 DEX
 BPL ll91_lc

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
 LDA L0085
 TAY
 BEQ LL91

.L47DA

 INX
 LSR K6
 ROR QQ19+2
 LSR QQ19
 ROR QQ17
 LSR A
 ROR QQ19+5
 TAY
 BNE L47DA

.LL91

 STX XX17
 LDA L0086
 STA XX15+5
 LDA QQ17
 STA XX15
 LDA QQ19+1
 STA Y1
 LDA QQ19+2
 STA X2
 LDA QQ19+4
 STA Y2
 LDA QQ19+5
 STA XX15+4
 JSR LL51

 LDA XX12
 STA QQ17
 LDA XX12+1
 STA QQ19+1
 LDA XX12+2
 STA QQ19+2
 LDA XX12+3
 STA QQ19+4
 LDA XX12+4
 STA QQ19+5
 LDA XX12+5
 STA L0086
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

 LDA QQ17
 STA XX15
 LDA QQ19+1
 STA Y1
 LDA QQ19+2
 STA X2
 LDA QQ19+4
 STA Y2
 LDA QQ19+5
 STA XX15+4
 LDA L0086
 STA XX15+5
 JMP LL89

.ovflw

 LSR QQ17
 LSR QQ19+5
 LSR QQ19+2
 LDX #&01

.LL92

 LDA XX12
 STA XX15
 LDA XX12+2
 STA X2
 LDA XX12+4
 DEX
 BMI LL94

.L4897

 LSR XX15
 LSR X2
 LSR A
 DEX
 BPL L4897

.LL94

 STA R
 LDA XX12+5
 STA S
 LDA QQ19+5
 STA Q
 LDA L0086
 JSR LL38

 BCS ovflw

 STA XX15+4
 LDA S
 STA XX15+5
 LDA XX15
 STA R
 LDA XX12+1
 STA S
 LDA QQ17
 STA Q
 LDA QQ19+1
 JSR LL38

 BCS ovflw

 STA XX15
 LDA S
 STA Y1
 LDA X2
 STA R
 LDA XX12+3
 STA S
 LDA QQ19+2
 STA Q
 LDA QQ19+4
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
 BMI L4933

 LDA #&00

.L4933

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
 BCC L49CD

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

.L49CD

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
 BCC L4A12

 INC Y1

.L4A12

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

 LDA #&08
 BIT INWK+31
 BEQ LL74

 JSR LL155

 LDA #&08

.LL74

 ORA INWK+31
 STA INWK+31
 LDY #&09
 LDA (XX0),Y
 STA XX20
 LDY #&00
 STY U
 STY XX17
 INC U
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
 BPL L4BC1

 DEC XX15+4

.L4BC1

 JSR LL145

 BCS LL170

 LDY U
 LDA XX15
 STA (XX19),Y
 INY
 LDA Y1
 STA (XX19),Y
 INY
 LDA X2
 STA (XX19),Y
 INY
 LDA Y2
 STA (XX19),Y
 INY
 STY U

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
 STA T1
 LDY XX17

.LL75

 LDA (V),Y
 CMP XX4
 BCC LL78

 INY
 LDA (V),Y
 INY
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

 LDA (V),Y
 TAX
 INY
 LDA (V),Y
 STA Q
 LDA XX3+1,X
 STA Y1
 LDA XX3,X
 STA XX15
 LDA XX3+2,X
 STA X2
 LDA XX3+3,X
 STA Y2
 LDX Q
 LDA XX3,X
 STA XX15+4
 LDA XX3+3,X
 STA XX12+1
 LDA XX3+2,X
 STA XX12
 LDA XX3+1,X
 STA XX15+5
 JSR LL147

 BCS LL78

 LDY U
 LDA XX15
 STA (XX19),Y
 INY
 LDA Y1
 STA (XX19),Y
 INY
 LDA X2
 STA (XX19),Y
 INY
 LDA Y2
 STA (XX19),Y
 INY
 STY U
 CPY T1
 BCS LL81

.LL78

 INC XX17
 LDY XX17
 CPY XX20
 BCS LL81

 LDY #&00
 LDA V
 ADC #&04
 STA V
 BCC ll81_lc

 INC V+1

.ll81_lc

 JMP LL75

.LL81

 LDA U

.L4C81

 LDY #&00
 STA (XX19),Y

.LL155

 LDY #&00
 LDA (XX19),Y
 STA XX20
 CMP #&04
 BCC L4CAB

 INY

.LL27

 LDA (XX19),Y
 STA XX15
 INY
 LDA (XX19),Y
 STA Y1
 INY
 LDA (XX19),Y
 STA X2
 INY
 LDA (XX19),Y
 STA Y2
 JSR LL30

 INY
 CPY XX20
 BCC LL27

.L4CAB

 RTS

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

.L4ED2

 RTS

.L4ED3

 EQUB &67

 EQUB &EA, &4E, &92, &4F, &6C, &50, &9A, &51
 EQUB &8C, &52, &8C, &52, &14, &54, &30, &55
 EQUB &2E, &56, &04, &57, &AC, &57

 EQUB &00, &81, &10, &50, &8C, &3D, &00, &1E
 EQUB &3C, &0F, &32, &00, &1C, &14, &46, &25
 EQUB &00, &00, &02, &10, &20, &00, &24, &9F
 EQUB &10, &54, &20, &00, &24, &1F, &20, &65
 EQUB &40, &00, &1C, &3F, &32, &66, &40, &00
 EQUB &1C, &BF, &31, &44, &00, &10, &1C, &3F
 EQUB &10, &32, &00, &10, &1C, &7F, &43, &65
 EQUB &0C, &06, &1C, &AF, &33, &33, &0C, &06
 EQUB &1C, &2F, &33, &33, &0C, &06, &1C, &6C
 EQUB &33, &33, &0C, &06, &1C, &EC, &33, &33
 EQUB &1F, &50, &00, &04, &1F, &62, &04, &08
 EQUB &1F, &20, &04, &10, &1F, &10, &00, &10
 EQUB &1F, &41, &00, &0C, &1F, &31, &0C, &10
 EQUB &1F, &32, &08, &10, &1F, &43, &0C, &14
 EQUB &1F, &63, &08, &14, &1F, &65, &04, &14
 EQUB &1F, &54, &00, &14, &0F, &33, &18, &1C
 EQUB &0C, &33, &1C, &20, &0C, &33, &18, &24
 EQUB &0C, &33, &20, &24, &1F, &00, &20, &08
 EQUB &9F, &0C, &2F, &06, &1F, &0C, &2F, &06
 EQUB &3F, &00, &00, &70, &DF, &0C, &2F, &06
 EQUB &5F, &00, &20, &08, &5F, &0C, &2F, &06

 EQUB &00, &F9, &15, &6E, &BE, &4D, &00, &2A
 EQUB &5A, &14, &00, &00, &1C, &17, &78, &20
 EQUB &00, &00, &01, &11, &00, &00, &48, &1F
 EQUB &21, &43, &00, &10, &18, &1E, &10, &22
 EQUB &00, &10, &18, &5E, &43, &55, &30, &00
 EQUB &18, &3F, &42, &66, &30, &00, &18, &BF
 EQUB &31, &66, &18, &10, &18, &7E, &54, &66
 EQUB &18, &10, &18, &FE, &35, &66, &18, &10
 EQUB &18, &3F, &20, &66, &18, &10, &18, &BF
 EQUB &10, &66, &20, &00, &18, &B3, &66, &66
 EQUB &20, &00, &18, &33, &66, &66, &08, &08
 EQUB &18, &33, &66, &66, &08, &08, &18, &B3
 EQUB &66, &66, &08, &08, &18, &F2, &66, &66
 EQUB &08, &08, &18, &72, &66, &66, &1F, &42
 EQUB &00, &0C, &1E, &21, &00, &04, &1E, &43
 EQUB &00, &08, &1F, &31, &00, &10, &1E, &20
 EQUB &04, &1C, &1E, &10, &04, &20, &1E, &54
 EQUB &08, &14, &1E, &53, &08, &18, &1F, &60
 EQUB &1C, &20, &1E, &65, &14, &18, &1F, &61
 EQUB &10, &20, &1E, &63, &10, &18, &1F, &62
 EQUB &0C, &1C, &1E, &46, &0C, &14, &13, &66
 EQUB &24, &30, &12, &66, &24, &34, &13, &66
 EQUB &28, &2C, &12, &66, &28, &38, &10, &66
 EQUB &2C, &38, &10, &66, &30, &34, &1F, &00
 EQUB &20, &00, &9F, &16, &21, &0B, &1F, &16
 EQUB &21, &0B, &DF, &16, &21, &0B, &5F, &16
 EQUB &21, &0B, &5F, &00, &20, &00, &3F, &00
 EQUB &00, &30

 EQUB &01, &24, &13, &AA, &1A, &5D, &00, &22
 EQUB &96, &1C, &96, &00, &14, &19, &5A, &1E
 EQUB &00, &01, &02, &12, &00, &00, &40, &1F
 EQUB &10, &32, &40, &08, &20, &FF, &20, &44
 EQUB &20, &08, &20, &BE, &21, &44, &20, &08
 EQUB &20, &3E, &31, &44, &40, &08, &20, &7F
 EQUB &30, &44, &04, &04, &10, &8E, &11, &11
 EQUB &04, &04, &10, &0E, &11, &11, &08, &03
 EQUB &1C, &0D, &11, &11, &08, &03, &1C, &8D
 EQUB &11, &11, &14, &04, &10, &D4, &00, &00
 EQUB &14, &04, &10, &54, &00, &00, &18, &07
 EQUB &14, &F4, &00, &00, &10, &07, &14, &F0
 EQUB &00, &00, &10, &07, &14, &70, &00, &00
 EQUB &18, &07, &14, &74, &00, &00, &08, &04
 EQUB &20, &AD, &44, &44, &08, &04, &20, &2D
 EQUB &44, &44, &08, &04, &20, &6E, &44, &44
 EQUB &08, &04, &20, &EE, &44, &44, &20, &04
 EQUB &20, &A7, &44, &44, &20, &04, &20, &27
 EQUB &44, &44, &24, &04, &20, &67, &44, &44
 EQUB &24, &04, &20, &E7, &44, &44, &26, &00
 EQUB &20, &A5, &44, &44, &26, &00, &20, &25
 EQUB &44, &44, &1F, &20, &00, &04, &1F, &30
 EQUB &00, &10, &1F, &40, &04, &10, &1E, &42
 EQUB &04, &08, &1E, &41, &08, &0C, &1E, &43
 EQUB &0C, &10, &0E, &11, &14, &18, &0C, &11
 EQUB &18, &1C, &0D, &11, &1C, &20, &0C, &11
 EQUB &14, &20, &14, &00, &24, &2C, &10, &00
 EQUB &24, &30, &10, &00, &28, &34, &14, &00
 EQUB &28, &38, &0E, &00, &34, &38, &0E, &00
 EQUB &2C, &30, &0D, &44, &3C, &40, &0E, &44
 EQUB &44, &48, &0C, &44, &3C, &48, &0C, &44
 EQUB &40, &44, &07, &44, &50, &54, &05, &44
 EQUB &50, &60, &05, &44, &54, &60, &07, &44
 EQUB &4C, &58, &05, &44, &4C, &5C, &05, &44
 EQUB &58, &5C, &1E, &21, &00, &08, &1E, &31
 EQUB &00, &0C, &5E, &00, &18, &02, &1E, &00
 EQUB &18, &02, &9E, &20, &40, &10, &1E, &20
 EQUB &40, &10, &3E, &00, &00, &7F

 EQUB &03, &40, &38, &56, &BE, &55, &00, &2E
 EQUB &42, &1A, &C8, &00, &34, &28, &FA, &14
 EQUB &00, &00, &00, &1B, &00, &00, &E0, &1F
 EQUB &10, &32, &00, &30, &30, &1E, &10, &54
 EQUB &60, &00, &10, &3F, &FF, &FF, &60, &00
 EQUB &10, &BF, &FF, &FF, &00, &30, &20, &3E
 EQUB &54, &98, &00, &18, &70, &3F, &89, &CC
 EQUB &30, &00, &70, &BF, &B8, &CC, &30, &00
 EQUB &70, &3F, &A9, &CC, &00, &30, &30, &5E
 EQUB &32, &76, &00, &30, &20, &7E, &76, &BA
 EQUB &00, &18, &70, &7E, &BA, &CC, &1E, &32
 EQUB &00, &20, &1F, &20, &00, &0C, &1F, &31
 EQUB &00, &08, &1E, &10, &00, &04, &1D, &59
 EQUB &08, &10, &1D, &51, &04, &08, &1D, &37
 EQUB &08, &20, &1D, &40, &04, &0C, &1D, &62
 EQUB &0C, &20, &1D, &A7, &08, &24, &1D, &84
 EQUB &0C, &10, &1D, &B6, &0C, &24, &05, &88
 EQUB &0C, &14, &05, &BB, &0C, &28, &05, &99
 EQUB &08, &14, &05, &AA, &08, &28, &1F, &A9
 EQUB &08, &1C, &1F, &B8, &0C, &18, &1F, &C8
 EQUB &14, &18, &1F, &C9, &14, &1C, &1D, &AC
 EQUB &1C, &28, &1D, &CB, &18, &28, &1D, &98
 EQUB &10, &14, &1D, &BA, &24, &28, &1D, &54
 EQUB &04, &10, &1D, &76, &20, &24, &9E, &1B
 EQUB &28, &0B, &1E, &1B, &28, &0B, &DE, &1B
 EQUB &28, &0B, &5E, &1B, &28, &0B, &9E, &13
 EQUB &26, &00, &1E, &13, &26, &00, &DE, &13
 EQUB &26, &00, &5E, &13, &26, &00, &BE, &19
 EQUB &25, &0B, &3E, &19, &25, &0B, &7E, &19
 EQUB &25, &0B, &FE, &19, &25, &0B, &3E, &00
 EQUB &00, &70

 EQUB &03, &41, &23, &BC, &54, &99, &54, &2A
 EQUB &A8, &26, &00, &00, &34, &32, &96, &1C
 EQUB &00, &01, &01, &13, &20, &00, &4C, &1F
 EQUB &FF, &FF, &20, &00, &4C, &9F, &FF, &FF
 EQUB &00, &1A, &18, &1F, &FF, &FF, &78, &03
 EQUB &08, &FF, &73, &AA, &78, &03, &08, &7F
 EQUB &84, &CC, &58, &10, &28, &BF, &FF, &FF
 EQUB &58, &10, &28, &3F, &FF, &FF, &80, &08
 EQUB &28, &7F, &98, &CC, &80, &08, &28, &FF
 EQUB &97, &AA, &00, &1A, &28, &3F, &65, &99
 EQUB &20, &18, &28, &FF, &A9, &BB, &20, &18
 EQUB &28, &7F, &B9, &CC, &24, &08, &28, &B4
 EQUB &99, &99, &08, &0C, &28, &B4, &99, &99
 EQUB &08, &0C, &28, &34, &99, &99, &24, &08
 EQUB &28, &34, &99, &99, &24, &0C, &28, &74
 EQUB &99, &99, &08, &10, &28, &74, &99, &99
 EQUB &08, &10, &28, &F4, &99, &99, &24, &0C
 EQUB &28, &F4, &99, &99, &00, &00, &4C, &06
 EQUB &B0, &BB, &00, &00, &5A, &1F, &B0, &BB
 EQUB &50, &06, &28, &E8, &99, &99, &50, &06
 EQUB &28, &A8, &99, &99, &58, &00, &28, &A6
 EQUB &99, &99, &50, &06, &28, &28, &99, &99
 EQUB &58, &00, &28, &26, &99, &99, &50, &06
 EQUB &28, &68, &99, &99, &1F, &B0, &00, &04
 EQUB &1F, &C4, &00, &10, &1F, &A3, &04, &0C
 EQUB &1F, &A7, &0C, &20, &1F, &C8, &10, &1C
 EQUB &1F, &98, &18, &1C, &1F, &96, &18, &24
 EQUB &1F, &95, &14, &24, &1F, &97, &14, &20
 EQUB &1F, &51, &08, &14, &1F, &62, &08, &18
 EQUB &1F, &73, &0C, &14, &1F, &84, &10, &18
 EQUB &1F, &10, &04, &08, &1F, &20, &00, &08
 EQUB &1F, &A9, &20, &28, &1F, &B9, &28, &2C
 EQUB &1F, &C9, &1C, &2C, &1F, &BA, &04, &28
 EQUB &1F, &CB, &00, &2C, &1D, &31, &04, &14
 EQUB &1D, &42, &00, &18, &06, &B0, &50, &54
 EQUB &14, &99, &30, &34, &14, &99, &48, &4C
 EQUB &14, &99, &38, &3C, &14, &99, &40, &44
 EQUB &13, &99, &3C, &40, &11, &99, &38, &44
 EQUB &13, &99, &34, &48, &13, &99, &30, &4C
 EQUB &1E, &65, &08, &24, &06, &99, &58, &60
 EQUB &06, &99, &5C, &60, &08, &99, &58, &5C
 EQUB &06, &99, &64, &68, &06, &99, &68, &6C
 EQUB &08, &99, &64, &6C, &1F, &00, &3E, &1F
 EQUB &9F, &12, &37, &10, &1F, &12, &37, &10
 EQUB &9F, &10, &34, &0E, &1F, &10, &34, &0E
 EQUB &9F, &0E, &2F, &00, &1F, &0E, &2F, &00
 EQUB &9F, &3D, &66, &00, &1F, &3D, &66, &00
 EQUB &3F, &00, &00, &50, &DF, &07, &2A, &09
 EQUB &5F, &00, &1E, &06, &5F, &07, &2A, &09

 EQUB &00, &00, &64, &74, &E4, &55, &00, &36
 EQUB &60, &1C, &00, &00, &38, &78, &F0, &00
 EQUB &00, &00, &00, &06, &A0, &00, &A0, &1F
 EQUB &10, &62, &00, &A0, &A0, &1F, &20, &83
 EQUB &A0, &00, &A0, &9F, &30, &74, &00, &A0
 EQUB &A0, &5F, &10, &54, &A0, &A0, &00, &5F
 EQUB &51, &A6, &A0, &A0, &00, &1F, &62, &B8
 EQUB &A0, &A0, &00, &9F, &73, &C8, &A0, &A0
 EQUB &00, &DF, &54, &97, &A0, &00, &A0, &3F
 EQUB &A6, &DB, &00, &A0, &A0, &3F, &B8, &DC
 EQUB &A0, &00, &A0, &BF, &97, &DC, &00, &A0
 EQUB &A0, &7F, &95, &DA, &0A, &1E, &A0, &5E
 EQUB &00, &00, &0A, &1E, &A0, &1E, &00, &00
 EQUB &0A, &1E, &A0, &9E, &00, &00, &0A, &1E
 EQUB &A0, &DE, &00, &00, &1F, &10, &00, &0C
 EQUB &1F, &20, &00, &04, &1F, &30, &04, &08
 EQUB &1F, &40, &08, &0C, &1F, &51, &0C, &10
 EQUB &1F, &61, &00, &10, &1F, &62, &00, &14
 EQUB &1F, &82, &14, &04, &1F, &83, &04, &18
 EQUB &1F, &73, &08, &18, &1F, &74, &08, &1C
 EQUB &1F, &54, &0C, &1C, &1F, &DA, &20, &2C
 EQUB &1F, &DB, &20, &24, &1F, &DC, &24, &28
 EQUB &1F, &D9, &28, &2C, &1F, &A5, &10, &2C
 EQUB &1F, &A6, &10, &20, &1F, &B6, &14, &20
 EQUB &1F, &B8, &14, &24, &1F, &C8, &18, &24
 EQUB &1F, &C7, &18, &28, &1F, &97, &1C, &28
 EQUB &1F, &95, &1C, &2C, &1E, &00, &30, &34
 EQUB &1E, &00, &34, &38, &1E, &00, &38, &3C
 EQUB &1E, &00, &3C, &30, &1F, &00, &00, &A0
 EQUB &5F, &6B, &6B, &6B, &1F, &6B, &6B, &6B
 EQUB &9F, &6B, &6B, &6B, &DF, &6B, &6B, &6B
 EQUB &5F, &00, &A0, &00, &1F, &A0, &00, &00
 EQUB &9F, &A0, &00, &00, &1F, &00, &A0, &00
 EQUB &FF, &6B, &6B, &6B, &7F, &6B, &6B, &6B
 EQUB &3F, &6B, &6B, &6B, &BF, &6B, &6B, &6B
 EQUB &3F, &00, &00, &A0

 EQUB &00, &40, &06, &7A, &DA, &51, &00, &0A
 EQUB &66, &18, &00, &00, &24, &0E, &02, &2C
 EQUB &00, &00, &02, &00, &00, &00, &44, &1F
 EQUB &10, &32, &08, &08, &24, &5F, &21, &54
 EQUB &08, &08, &24, &1F, &32, &74, &08, &08
 EQUB &24, &9F, &30, &76, &08, &08, &24, &DF
 EQUB &10, &65, &08, &08, &2C, &3F, &74, &88
 EQUB &08, &08, &2C, &7F, &54, &88, &08, &08
 EQUB &2C, &FF, &65, &88, &08, &08, &2C, &BF
 EQUB &76, &88, &0C, &0C, &2C, &28, &74, &88
 EQUB &0C, &0C, &2C, &68, &54, &88, &0C, &0C
 EQUB &2C, &E8, &65, &88, &0C, &0C, &2C, &A8
 EQUB &76, &88, &08, &08, &0C, &A8, &76, &77
 EQUB &08, &08, &0C, &E8, &65, &66, &08, &08
 EQUB &0C, &28, &74, &77, &08, &08, &0C, &68
 EQUB &54, &55, &1F, &21, &00, &04, &1F, &32
 EQUB &00, &08, &1F, &30, &00, &0C, &1F, &10
 EQUB &00, &10, &1F, &24, &04, &08, &1F, &51
 EQUB &04, &10, &1F, &60, &0C, &10, &1F, &73
 EQUB &08, &0C, &1F, &74, &08, &14, &1F, &54
 EQUB &04, &18, &1F, &65, &10, &1C, &1F, &76
 EQUB &0C, &20, &1F, &86, &1C, &20, &1F, &87
 EQUB &14, &20, &1F, &84, &14, &18, &1F, &85
 EQUB &18, &1C, &08, &85, &18, &28, &08, &87
 EQUB &14, &24, &08, &87, &20, &30, &08, &85
 EQUB &1C, &2C, &08, &74, &24, &3C, &08, &54
 EQUB &28, &40, &08, &76, &30, &34, &08, &65
 EQUB &2C, &38, &9F, &40, &00, &10, &5F, &00
 EQUB &40, &10, &1F, &40, &00, &10, &1F, &00
 EQUB &40, &10, &1F, &20, &00, &00, &5F, &00
 EQUB &20, &00, &9F, &20, &00, &00, &1F, &00
 EQUB &20, &00, &3F, &00, &00, &B0

 EQUB &00, &00, &19, &4A, &9E, &41, &00, &22
 EQUB &36, &15, &05, &00, &38, &32, &3C, &1E
 EQUB &00, &00, &01, &00, &00, &50, &00, &1F
 EQUB &FF, &FF, &50, &0A, &00, &DF, &FF, &FF
 EQUB &00, &50, &00, &5F, &FF, &FF, &46, &28
 EQUB &00, &5F, &FF, &FF, &3C, &32, &00, &1F
 EQUB &65, &DC, &32, &00, &3C, &1F, &FF, &FF
 EQUB &28, &00, &46, &9F, &10, &32, &00, &1E
 EQUB &4B, &3F, &FF, &FF, &00, &32, &3C, &7F
 EQUB &98, &BA, &1F, &72, &00, &04, &1F, &D6
 EQUB &00, &10, &1F, &C5, &0C, &10, &1F, &B4
 EQUB &08, &0C, &1F, &A3, &04, &08, &1F, &32
 EQUB &04, &18, &1F, &31, &08, &18, &1F, &41
 EQUB &08, &14, &1F, &10, &14, &18, &1F, &60
 EQUB &00, &14, &1F, &54, &0C, &14, &1F, &20
 EQUB &00, &18, &1F, &65, &10, &14, &1F, &A8
 EQUB &04, &20, &1F, &87, &04, &1C, &1F, &D7
 EQUB &00, &1C, &1F, &DC, &10, &1C, &1F, &C9
 EQUB &0C, &1C, &1F, &B9, &0C, &20, &1F, &BA
 EQUB &08, &20, &1F, &98, &1C, &20, &1F, &09
 EQUB &42, &51, &5F, &09, &42, &51, &9F, &48
 EQUB &40, &1F, &DF, &40, &49, &2F, &5F, &2D
 EQUB &4F, &41, &1F, &87, &0F, &23, &1F, &26
 EQUB &4C, &46, &BF, &42, &3B, &27, &FF, &43
 EQUB &0F, &50, &7F, &42, &0E, &4B, &FF, &46
 EQUB &50, &28, &7F, &3A, &66, &33, &3F, &51
 EQUB &09, &43, &3F, &2F, &5E, &3F

 EQUB &00, &90, &01, &50, &8C, &31, &00, &12
 EQUB &3C, &0F, &00, &00, &1C, &0C, &11, &0F
 EQUB &00, &00, &02, &00, &18, &10, &00, &1F
 EQUB &10, &55, &18, &05, &0F, &1F, &10, &22
 EQUB &18, &0D, &09, &5F, &20, &33, &18, &0D
 EQUB &09, &7F, &30, &44, &18, &05, &0F, &3F
 EQUB &40, &55, &18, &10, &00, &9F, &51, &66
 EQUB &18, &05, &0F, &9F, &21, &66, &18, &0D
 EQUB &09, &DF, &32, &66, &18, &0D, &09, &FF
 EQUB &43, &66, &18, &05, &0F, &BF, &54, &66
 EQUB &1F, &10, &00, &04, &1F, &20, &04, &08
 EQUB &1F, &30, &08, &0C, &1F, &40, &0C, &10
 EQUB &1F, &50, &00, &10, &1F, &51, &00, &14
 EQUB &1F, &21, &04, &18, &1F, &32, &08, &1C
 EQUB &1F, &43, &0C, &20, &1F, &54, &10, &24
 EQUB &1F, &61, &14, &18, &1F, &62, &18, &1C
 EQUB &1F, &63, &1C, &20, &1F, &64, &20, &24
 EQUB &1F, &65, &24, &14, &1F, &60, &00, &00
 EQUB &1F, &00, &29, &1E, &5F, &00, &12, &30
 EQUB &5F, &00, &33, &00, &7F, &00, &12, &30
 EQUB &3F, &00, &29, &1E, &9F, &60, &00, &00

 EQUB &00, &00, &01, &2C, &44, &19, &00, &16
 EQUB &18, &06, &00, &00, &10, &08, &11, &08
 EQUB &00, &00, &03, &00, &07, &00, &24, &9F
 EQUB &12, &33, &07, &0E, &0C, &FF, &02, &33
 EQUB &07, &0E, &0C, &BF, &01, &33, &15, &00
 EQUB &00, &1F, &01, &22, &1F, &23, &00, &04
 EQUB &1F, &03, &04, &08, &1F, &01, &08, &0C
 EQUB &1F, &12, &0C, &00, &1F, &13, &00, &08
 EQUB &1F, &02, &0C, &04, &3F, &1A, &00, &3D
 EQUB &1F, &13, &33, &0F, &5F, &13, &33, &0F
 EQUB &9F, &38, &00, &00


PRINT "S.ELITECO ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/electron/output/ELITECO.bin", CODE%, P%, LOAD%
