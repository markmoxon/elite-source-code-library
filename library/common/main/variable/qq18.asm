\ ******************************************************************************
\
\       Name: QQ18
\       Type: Variable
\   Category: Text
\    Summary: The recursive token table for tokens 0-148
\  Deep dive: Printing text tokens
\
IF _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   new_name            This part of token 132 is updated with our current
\                       ship's type by routine n_load, so printing token 132
\                       will always show the correct type of our ship
\
ENDIF
\ ******************************************************************************

.QQ18

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Electron: The Electron doesn't support fuel scooping (as there are no suns), so the text token for "FUEL SCOOPS ON" isn't included

 RTOK 111               \ Token 0:      "FUEL SCOOPS ON {beep}"
 RTOK 131               \
 CONT 7                 \ Encoded as:   "[111][131]{7}"
 EQUB 0

ELIF _ELECTRON_VERSION

 EQUB &FF EOR RE        \ Token 0 is unused in the Electron version of Elite,
 EQUB 0                 \ and it just contains &FF (plus the standard token
                        \ obfuscation EOR) as filler

ENDIF

 CHAR ' '               \ Token 1:      " CHART"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   " CH<138>T"
 TWOK 'A', 'R'
 CHAR 'T'
 EQUB 0

IF NOT(_NES_VERSION)
 CHAR 'G'               \ Token 2:      "GOVERNMENT"
 CHAR 'O'               \
 TWOK 'V', 'E'          \ Encoded as:   "GO<150>RNM<146>T"
 CHAR 'R'
ELIF _NES_VERSION
 CHAR 'G'               \ Token 2:      "GOVERNMENT"
 CHAR 'O'               \
 CHAR 'V'               \ Encoded as:   "GOV<144>NM<146>T"
 TWOK 'E', 'R'
ENDIF
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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{crlf}
 TWOK 'V', 'E'          \               "
 CHAR 'N'               \
 CHAR 'T'               \ Encoded as:   "<140><150>NT<153>Y{13}"
 TWOK 'O', 'R'
 CHAR 'Y'
 CONT 13
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{cr}
 TWOK 'V', 'E'          \               "
 CHAR 'N'               \
 CHAR 'T'               \ Encoded as:   "<140><150>NT<153>Y{12}"
 TWOK 'O', 'R'
 CHAR 'Y'
 CONT 12
 EQUB 0

ELIF _NES_VERSION

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{cr}
 CHAR 'V'               \               "
 TWOK 'E', 'N'          \
 CHAR 'T'               \ Encoded as:   "<140>V<146>T<153>Y{12}"
 TWOK 'O', 'R'
 CHAR 'Y'
 CONT 12
 EQUB 0

ENDIF

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
IF NOT(_NES_VERSION)
 TWOK 'M', 'A'          \ Encoded as:   "{2} <139>RKET [6]S"
 CHAR 'R'
ELIF _NES_VERSION
 CHAR 'M'               \ Encoded as:   "{2} M<138>RKET [6]S"
 TWOK 'A', 'R'
ENDIF
 CHAR 'K'
 CHAR 'E'
 CHAR 'T'
 CHAR ' '
 RTOK 6
 CHAR 'S'
 EQUB 0

 TWOK 'I', 'N'          \ Token 8:      "INDUSTRIAL"
 CHAR 'D'               \
IF NOT(_NES_VERSION)
 TWOK 'U', 'S'          \ Encoded as:   "<140>D<136>T<158><128>"
 CHAR 'T'
 TWOK 'R', 'I'
 TWOK 'A', 'L'
ELIF _NES_VERSION
 TWOK 'U', 'S'          \ Encoded as:   "<140>D<136>T<158>AL"
 CHAR 'T'
 TWOK 'R', 'I'
 CHAR 'A'
 CHAR 'L'
ENDIF
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

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 RTOK 139               \ Token 11:     "AVERAGE "
 CHAR ' '               \
 EQUB 0                 \ Encoded as:   "[139]"

 RTOK 138               \ Token 12:     "POOR "
 CHAR ' '               \
 EQUB 0                 \ Encoded as:   "[138]"

ENDIF

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

IF NOT(_NES_VERSION)

 TWOK 'Q', 'U'          \ Token 16:     "QUANTITY"
 TWOK 'A', 'N'          \
 TWOK 'T', 'I'          \ Encoded as:   "<154><155><151>TY"
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

ELIF _NES_VERSION

 EQUB 0                 \ Token 16:     ""
                        \
                        \ Encoded as:   ""

ENDIF

 TWOK 'A', 'N'          \ Token 17:     "ANARCHY"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "<155><138>CHY"
 CHAR 'H'
 CHAR 'Y'
 EQUB 0

IF NOT(_NES_VERSION)

 CHAR 'F'               \ Token 18:     "FEUDAL"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "FEUD<128>"
 CHAR 'D'
 TWOK 'A', 'L'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'F'               \ Token 18:     "FEUDAL"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "FEUDAL"
 CHAR 'D'
 CHAR 'A'
 CHAR 'L'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

 CHAR 'M'               \ Token 19:     "MULTI-GOVERNMENT"
 CHAR 'U'               \
 CHAR 'L'               \ Encoded as:   "MUL<151>-[2]"
 TWOK 'T', 'I'
 CHAR '-'
 RTOK 2
 EQUB 0

ELIF _NES_VERSION

 CHAR 'M'               \ Token 19:     "MULTI-{sentence case}GOVERNMENT"
 CHAR 'U'               \
 CHAR 'L'               \ Encoded as:   "MUL<151>-{6}[2]"
 TWOK 'T', 'I'
 CHAR '-'
 CONT 6
 RTOK 2
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR 'P'               \ Token 26:     "PRODUCT"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "PRODUCT"
 CHAR 'D'
 CHAR 'U'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CHAR 'P'               \ Token 26:     "PRODUCT"
 RTOK 94                \
 CHAR 'D'               \ Encoded as:   "P[94]]DUCT"
 CHAR 'U'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

ENDIF

 CHAR ' '               \ Token 27:     " LASER"
 TWOK 'L', 'A'          \
 CHAR 'S'               \ Encoded as:   " <149>S<144>"
 TWOK 'E', 'R'
 EQUB 0

IF NOT(_NES_VERSION)
 CHAR 'H'               \ Token 28:     "HUMAN COLONIAL"
 CHAR 'U'               \
 CHAR 'M'               \ Encoded as:   "HUM<155> COL<159>I<128>"
 TWOK 'A', 'N'
ELIF _NES_VERSION
 CHAR 'H'               \ Token 28:     "HUMAN COLONIALS"
 CHAR 'U'               \
 TWOK 'M', 'A'          \ Encoded as:   "HU<139>N COL<159>IALS"
 CHAR 'N'
ENDIF
 CHAR ' '
 CHAR 'C'
 CHAR 'O'
 CHAR 'L'
 TWOK 'O', 'N'
 CHAR 'I'
IF NOT(_NES_VERSION)
 TWOK 'A', 'L'
ELIF _NES_VERSION
 CHAR 'A'
 CHAR 'L'
 CHAR 'S'
ENDIF
 EQUB 0

IF NOT(_ELITE_A_VERSION)

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

ELIF _ELITE_A_VERSION

 CHAR 'H'               \ Token 29:     "HYPERSPACE "
 CHAR 'Y'               \
 CHAR 'P'               \ Encoded as:   "HYP<144>[128] "
 TWOK 'E', 'R'
 RTOK 128
 CHAR ' '
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'G'               \ Token 33:     "GROSS PRODUCTIVITY"
 RTOK 94                \
 CHAR 'S'               \ Encoded as:   "G[94]SS [26]IVITY"
 CHAR 'S'
 CHAR ' '
 RTOK 26
 CHAR 'I'
 CHAR 'V'
 CHAR 'I'
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'T'               \ Token 33:     "TURNOVER"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "TUENOV<144>"
 CHAR 'N'
 CHAR 'O'
 CHAR 'V'
 TWOK 'E', 'R'
 EQUB 0

ENDIF

 CHAR 'E'               \ Token 34:     "ECONOMY"
 CHAR 'C'               \
 TWOK 'O', 'N'          \ Encoded as:   "EC<159>OMY"
 CHAR 'O'
 CHAR 'M'
 CHAR 'Y'
 EQUB 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ 6502SP: The Executive version displays distances in the Status and galaxy charts as "L.Y." rather than "LIGHT YEARS" (this saves space in the token table so "SIR" can be added to the tokens for low low and incoming missiles)

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

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

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

ELIF _EXECUTIVE

 CHAR ' '               \ Token 35:     " L.Y."
 CHAR 'L'               \
 CHAR '.'               \ Encoded as:   " L.Y."
 CHAR 'Y'
 CHAR '.'
 EQUB 0

ENDIF

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \
 RTOK 118               \ Encoded as:   " <134>[118]I<159>"
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \
 RTOK 129               \ Encoded as:   " <134>[129]I<159>"
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

ELIF _NES_VERSION

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \
 CHAR 'L'               \ Encoded as:   " <134>LLI<159>"
 CHAR 'L'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

ENDIF

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

IF NOT(_NES_VERSION)

 CHAR 'R'               \ Token 42:     "RANGE"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "R<155><131>"
 EQUB 0

ELIF _NES_VERSION

 TWOK 'R', 'A'          \ Token 42:     "RANGE"
 CHAR 'N'               \
 TWOK 'G', 'E'          \ Encoded as:   "<148>N<131>"
 EQUB 0

ENDIF

 CHAR 'S'               \ Token 43:     "ST"
 CHAR 'T'               \
 EQUB 0                 \ Encoded as:   "ST"

IF NOT(_NES_VERSION)

 RTOK 16                \ Token 44:     "QUANTITY OF "
 CHAR ' '               \
 CHAR 'O'               \ Encoded as:   "[16] OF "
 CHAR 'F'
 CHAR ' '
 EQUB 0

ELIF _NES_VERSION

 EQUB 0                 \ Token 44:     ""
                        \
                        \ Encoded as:   ""

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \
 RTOK 118               \ Encoded as:   "SE[118]"
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \
 RTOK 129               \ Encoded as:   "SE[129]"
 EQUB 0

ELIF _NES_VERSION

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "SELL"
 CHAR 'L'
 EQUB 0

ENDIF

 CHAR ' '               \ Token 46:     " CARGO{sentence case}"
 CHAR 'C'               \
 TWOK 'A', 'R'          \ Encoded as:   " C<138>GO{6}"
 CHAR 'G'
 CHAR 'O'
 CONT 6
 EQUB 0

IF NOT(_NES_VERSION)

 CHAR 'E'               \ Token 47:     "EQUIP"
 TWOK 'Q', 'U'          \
 CHAR 'I'               \ Encoded as:   "E<154>IP"
 CHAR 'P'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'E'               \ Token 47:     "EQUIP SHIP"
 TWOK 'Q', 'U'          \
 CHAR 'I'               \ Encoded as:   "E<154>IP [25]"
 CHAR 'P'
 CHAR ' '
 RTOK 25
 EQUB 0

ENDIF

 CHAR 'F'               \ Token 48:     "FOOD"
 CHAR 'O'               \
 CHAR 'O'               \ Encoded as:   "FOOD"
 CHAR 'D'
 EQUB 0

IF NOT(_NES_VERSION)

 TWOK 'T', 'E'          \ Token 49:     "TEXTILES"
 CHAR 'X'               \
 TWOK 'T', 'I'          \ Encoded as:   "<156>X<151>L<137>"
 CHAR 'L'
 TWOK 'E', 'S'
 EQUB 0

ELIF _NES_VERSION

 TWOK 'T', 'E'          \ Token 49:     "TEXTILES"
 CHAR 'X'               \
 TWOK 'T', 'I'          \ Encoded as:   "<156>X<151><129>S"
 TWOK 'L', 'E'
 CHAR 'S'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

 TWOK 'R', 'A'          \ Token 50:     "RADIOACTIVES"
 TWOK 'D', 'I'          \
 CHAR 'O'               \ Encoded as:   "<148><141>OAC<151><150>S"
 CHAR 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 TWOK 'V', 'E'
 CHAR 'S'
 EQUB 0

ELIF _NES_VERSION

 TWOK 'R', 'A'          \ Token 50:     "RADIOACTIVES"
 TWOK 'D', 'I'          \
 CHAR 'O'               \ Encoded as:   "<148><141>OAC<151>V<137>"
 CHAR 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 CHAR 'V'
 TWOK 'E', 'S'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 RTOK 94                \ Token 51:     "ROBOT SLAVES"
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "[94]BOT S<149>V<137>"
 CHAR 'T'
 CHAR ' '
 CHAR 'S'
 TWOK 'L', 'A'
 CHAR 'V'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'B', 'E'          \ Token 52:     "BEVERAGES"
 CHAR 'V'               \
 TWOK 'E', 'R'          \ Encoded as:   "<147>V<144>A<131>S"
 CHAR 'A'
 TWOK 'G', 'E'
 CHAR 'S'
 EQUB 0

ENDIF

 CHAR 'L'               \ Token 53:     "LUXURIES"
 CHAR 'U'               \
 CHAR 'X'               \ Encoded as:   "LUXU<158><137>"
 CHAR 'U'
 TWOK 'R', 'I'
 TWOK 'E', 'S'
 EQUB 0

IF NOT(_NES_VERSION)

 CHAR 'N'               \ Token 54:     "NARCOTICS"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "N<138>CO<151>CS"
 CHAR 'O'
 TWOK 'T', 'I'
 CHAR 'C'
 CHAR 'S'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'R'               \ Token 54:     "RARE SPECIES"
 TWOK 'A', 'R'          \
 CHAR 'E'               \ Encoded as:   "R<138>E SPECI<137>"
 CHAR ' '
 CHAR 'S'
 CHAR 'P'
 CHAR 'E'
 CHAR 'C'
 CHAR 'I'
 TWOK 'E', 'S'
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 RTOK 117               \ Token 57:     "ALLOYS"
 CHAR 'O'               \
 CHAR 'Y'               \ Encoded as:   "[117]OYS"
 CHAR 'S'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'A'               \ Token 57:     "ALLOYS"
 CHAR 'L'               \
 CHAR 'L'               \ Encoded as:   "ALLOYS"
 CHAR 'O'
 CHAR 'Y'
 CHAR 'S'
 EQUB 0

ELIF _ELITE_A_VERSION

 CHAR 'A'               \ Token 57:     "ALLOYS"
 RTOK 129               \
 CHAR 'O'               \ Encoded as:   "A[129]OYS"
 CHAR 'Y'
 CHAR 'S'
 EQUB 0

ELIF _NES_VERSION

 RTOK 124               \ Token 57:     "ALLOYS"
 CHAR 'O'               \
 CHAR 'Y'               \ Encoded as:   "[124]OYS"
 CHAR 'S'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

 CHAR 'F'               \ Token 58:     "FIREARMS"
 CHAR 'I'               \
 TWOK 'R', 'E'          \ Encoded as:   "FI<142><138>MS"
 TWOK 'A', 'R'
 CHAR 'M'
 CHAR 'S'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'F'               \ Token 58:     "FIREARMS"
 CHAR 'I'               \
 RTOK 97                \ Encoded as:   "FI[97]MS"
 CHAR 'M'
 CHAR 'S'
 EQUB 0

ENDIF

 CHAR 'F'               \ Token 59:     "FURS"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "FURS"
 CHAR 'S'
 EQUB 0

 CHAR 'M'               \ Token 60:     "MINERALS"
 TWOK 'I', 'N'          \
IF NOT(_NES_VERSION)
 TWOK 'E', 'R'          \ Encoded as:   "M<140><144><128>S"
 TWOK 'A', 'L'
ELIF _NES_VERSION
 TWOK 'E', 'R'          \ Encoded as:   "M<140><144>ALS"
 CHAR 'A'
 CHAR 'L'
ENDIF
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

IF NOT(_NES_VERSION)
 TWOK 'A', 'L'          \ Token 64:     "ALIEN ITEMS"
 CHAR 'I'               \
 TWOK 'E', 'N'          \ Encoded as:   "<128>I<146> [127]S"
ELIF _NES_VERSION
 CHAR 'A'               \ Token 64:     "ALIEN ITEMS"
 CHAR 'L'               \
 CHAR 'I'               \ Encoded as:   "ALI<146> [127]S"
 TWOK 'E', 'N'
ENDIF
 CHAR ' '
 RTOK 127
 CHAR 'S'
 EQUB 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The enhanced versions contain a strange text token 65 that displays your credit balance as "10{cash} CR5{cash} CR" - it isn't used anywhere and doesn't make a whole lot of sense

 CHAR '('               \ Token 65:     "(Y/N)?"
 CHAR 'Y'               \
 CHAR '/'               \ Encoded as:   "(Y/N)?"
 CHAR 'N'
 CHAR ')'
 CHAR '?'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CONT 12                \ Token 65:     "{cr}
 CHAR '1'               \                10{cash} CR{cr}
 CHAR '0'               \                5{cash} CR{cr}
 CONT 0                 \               "
 CHAR '5'               \
 CONT 0                 \ Encoded as:   "{12}10{0}5{0}"
 EQUB 0

ELIF _NES_VERSION

 EQUB 0                 \ Token 65:     ""
                        \
                        \ Encoded as:   ""

ENDIF

 CHAR ' '               \ Token 66:     " CR"
 CHAR 'C'               \
 CHAR 'R'               \ Encoded as:   " CR"
 EQUB 0

IF NOT(_NES_VERSION)

 CHAR 'L'               \ Token 67:     "LARGE"
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "L<138><131>"
 EQUB 0

 CHAR 'F'               \ Token 68:     "FIERCE"
 CHAR 'I'               \
 TWOK 'E', 'R'          \ Encoded as:   "FI<144><133>"
 TWOK 'C', 'E'
 EQUB 0

ELIF _NES_VERSION

 EQUB 0                 \ Token 67:     ""
                        \
                        \ Encoded as:   ""

 EQUB 0                 \ Token 68:     ""
                        \
                        \ Encoded as:   ""

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR 'S'               \ Token 69:     "SMALL"
 TWOK 'M', 'A'          \
 RTOK 118               \ Encoded as:   "S<139>[118]"
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'S'               \ Token 69:     "SMALL"
 TWOK 'M', 'A'          \
 RTOK 129               \ Encoded as:   "S<139>[129]"
 EQUB 0

ELIF _NES_VERSION

 EQUB 0                 \ Token 69:     ""
                        \
                        \ Encoded as:   ""

ENDIF

 CHAR 'G'               \ Token 70:     "GREEN"
 TWOK 'R', 'E'          \
 TWOK 'E', 'N'          \ Encoded as:   "G<142><146>"
 EQUB 0

IF NOT(_NES_VERSION)

 CHAR 'R'               \ Token 71:     "RED"
 TWOK 'E', 'D'          \
 EQUB 0                 \ Encoded as:   "R<152>"

ELIF _NES_VERSION

 TWOK 'R', 'E'          \ Token 71:     "RED"
 CHAR 'D'
 EQUB 0                 \ Encoded as:   "<142>D"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \
 RTOK 118               \ Encoded as:   "YE[118]OW"
 CHAR 'O'
 CHAR 'W'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \
 RTOK 129               \ Encoded as:   "YE[129]OW"
 CHAR 'O'
 CHAR 'W'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "YELLOW"
 CHAR 'L'
 CHAR 'O'
 CHAR 'W'
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTOK 94                \ Token 82:     "RODENT"
 CHAR 'D'               \
 TWOK 'E', 'N'          \ Encoded as:   "[94]D<146>T"
 CHAR 'T'
 EQUB 0

 CHAR 'F'               \ Token 83:     "FROG"
 RTOK 94                \
 CHAR 'G'               \ Encoded as:   "F[94]G"
 EQUB 0

ELIF _NES_VERSION

 RTOK 94                \ Token 82:     "RODENTS"
 CHAR 'D'               \
 TWOK 'E', 'N'          \ Encoded as:   "[94]D<146>TS"
 CHAR 'T'
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 83:     "FROGS"
 RTOK 94                \
 CHAR 'G'               \ Encoded as:   "F[94]GS"
 CHAR 'S'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 CHAR 'L'               \ Token 84:     "LIZARDS"
 CHAR 'I'               \
 TWOK 'Z', 'A'          \ Encoded as:   "LI<132>RDS"
 CHAR 'R'
 CHAR 'D'
 CHAR 'S'
 EQUB 0

 CHAR 'L'               \ Token 85:     "LOBSTERS"
 CHAR 'O'               \
 CHAR 'B'               \ Encoded as:   "LOB[43]<144>S"
 RTOK 43
 TWOK 'E', 'R'
 CHAR 'S'
 EQUB 0

 TWOK 'B', 'I'          \ Token 86:     "BIRDS"
 CHAR 'R'               \
 CHAR 'D'               \ Encoded as:   "<134>RDS"
 CHAR 'S'
 EQUB 0

 CHAR 'H'               \ Token 87:     "HUMANOIDS"
 CHAR 'U'               \
 TWOK 'M', 'A'          \ Encoded as:   "HU<139>NOIDS"
 CHAR 'N'
 CHAR 'O'
 CHAR 'I'
 CHAR 'D'
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 88:     "FELINES"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "FEL<140><137>"
 TWOK 'I', 'N'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'I', 'N'          \ Token 89:     "INSECTS"
 CHAR 'S'               \
 CHAR 'E'               \ Encoded as:   "<140>SECTS"
 CHAR 'C'
 CHAR 'T'
 CHAR 'S'
 EQUB 0

 TWOK 'R', 'A'          \ Token 90:     "RADIUS"
 TWOK 'D', 'I'          \
 TWOK 'U', 'S'          \ Encoded as:   "<148><141><136>"
 EQUB 0

ENDIF

 CHAR 'C'               \ Token 91:     "COM"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "COM"
 EQUB 0

IF NOT(_NES_VERSION)

 RTOK 91                \ Token 92:     "COMMANDER"
 CHAR 'M'               \
 TWOK 'A', 'N'          \ Encoded as:   "[91]M<155>D<144>"
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

ELIF _NES_VERSION

 RTOK 91                \ Token 92:     "COMMANDER"
 TWOK 'M', 'A'          \
 CHAR 'N'               \ Encoded as:   "[91]<139>ND<144>"
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR ' '               \ Token 93:     " DESTROYED"
 CHAR 'D'               \
 TWOK 'E', 'S'          \ Encoded as:   " D<137>TROY<152>"
 CHAR 'T'
 CHAR 'R'
 CHAR 'O'
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CHAR ' '               \ Token 93:     " DESTROYED"
 CHAR 'D'               \
 TWOK 'E', 'S'          \ Encoded as:   " D<137>T[94]Y<152>"
 CHAR 'T'
 RTOK 94
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The enhanced versions encode an extra two-letter token ("RO") in the standard text token table, replacing the author credits, which are moved into the extended token table

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CHAR 'R'               \ Token 94:     "RO"
 CHAR 'O'               \
 EQUB 0                 \ Encoded as:   "RO"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTOK 14                \ Token 95:     "UNIT  QUANTITY{cr}
 CHAR ' '               \                 PRODUCT   UNIT PRICE FOR SALE{cr}{lf}
 CHAR ' '               \               "
 RTOK 16                \
 CONT 12                \ Encoded as:   "[14]  [16]{13} [26]   [14] [6] F<153>
 CHAR ' '               \                 SA<129>{12}{10}"
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
 CONT 12
 CONT 10
 EQUB 0

ELIF _NES_VERSION

 RTOK 26                \ Token 95:     "PRODUCT   UNIT PRICE QUANTITY"
 CHAR ' '               \
 CHAR ' '               \ Encoded as:   "[26]   [14] [6] <154><155><151>TY"
 CHAR ' '
 RTOK 14
 CHAR ' '
 RTOK 6
 CHAR ' '
 TWOK 'Q', 'U'
 TWOK 'A', 'N'
 TWOK 'T', 'I'
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION\ 6502SP: When energy is low in the Executive version, it shows the in-flight message "ENERGY LOW,SIR", rather than just showing "ENERGY LOW"

 RTOK 121               \ Token 100:    "ENERGY LOW{beep}"
 CHAR 'L'               \
 CHAR 'O'               \ Encoded as:   "[121]LOW{7}"
 CHAR 'W'
 CONT 7
 EQUB 0

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 RTOK 121               \ Token 100:    "ENERGY LOW{beep}"
 CHAR 'L'               \
 CHAR 'O'               \ Encoded as:   "[121]LOW{7}"
 CHAR 'W'
 CONT 7
 EQUB 0

ELIF _EXECUTIVE

 RTOK 121               \ Token 100:    "ENERGY LOW,SIR{beep}"
 CHAR 'L'               \
 CHAR 'O'               \ Encoded as:   "[121]LOW,SIR{7}"
 CHAR 'W'
 CHAR ','
 CHAR 'S'
 CHAR 'I'
 CHAR 'R'
 CONT 7
 EQUB 0

ENDIF

ENDIF

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

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 RTOK 67                \ Token 107:    "LARGE CARGO{sentence case} BAY"
 RTOK 46                \
 CHAR ' '               \ Encoded as:   "[67][46] BAY"
 CHAR 'B'
 CHAR 'A'
 CHAR 'Y'
 EQUB 0

ELIF _ELITE_A_VERSION

 CHAR 'I'               \ Token 107:    "I.F.F.SYSTEM"
 CHAR '.'               \
 CHAR 'F'               \ Encoded as:   "I.F.F.[5]"
 CHAR '.'
 CHAR 'F'
 CHAR '.'
 RTOK 5
 EQUB 0

ELIF _NES_VERSION

 CHAR 'L'               \ Token 107:    "LARGE CARGO BAY""
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "L<138><131> C<138>GO BAY
 CHAR ' '
 CHAR 'C'
 TWOK 'A', 'R'
 CHAR 'G'
 CHAR 'O'
 CHAR ' '
 CHAR 'B'
 CHAR 'A'
 CHAR 'Y'
 EQUB 0

ENDIF

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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Electron: In the Electron version you can buy an "Escape Capsule", while all the other versions call it an "Escape Pod"

 TWOK 'E', 'S'          \ Token 112:    "ESCAPE POD"
 CHAR 'C'               \
 CHAR 'A'               \ Encoded as:   "<137>CAPE POD"
 CHAR 'P'
 CHAR 'E'
 CHAR ' '
 CHAR 'P'
 CHAR 'O'
 CHAR 'D'
 EQUB 0

ELIF _ELECTRON_VERSION OR _NES_VERSION

 TWOK 'E', 'S'          \ Token 112:    "ESCAPE CAPSULE"
 CHAR 'C'               \
 CHAR 'A'               \ Encoded as:   "<137>CAPE CAPSULE"
 CHAR 'P'
 CHAR 'E'
 CHAR ' '
 CHAR 'C'
 CHAR 'A'
 CHAR 'P'
 CHAR 'S'
 CHAR 'U'
 TWOK 'L', 'E'
 EQUB 0

ENDIF

IF NOT(_ELITE_A_VERSION)

 RTOK 121               \ Token 113:    "ENERGY BOMB"
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "[121]BOMB"
 CHAR 'M'
 CHAR 'B'
 EQUB 0

ELIF _ELITE_A_VERSION

 RTOK 29                \ Token 113:    "HYPERSPACE UNIT"
 RTOK 14                \
 EQUB 0                 \ Encoded as:   "[29][14]"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _APPLE_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ 6502SP: If you have bought an energy unit, then most versions will show it on the Inventory screen as "Energy Unit", but in the source disc variant of the 6502SP version, it is shown as "Extra Energy Unit" (though it's still "Energy Unit" in the Acornsoft SNG45 release of the game)

 RTOK 121               \ Token 114:    "ENERGY UNIT"
 RTOK 14                \
 EQUB 0                 \ Encoded as:   "[121][14]"

ELIF _6502SP_VERSION

IF _SNG45 OR _EXECUTIVE

 RTOK 121               \ Token 114:    "ENERGY UNIT"
 RTOK 14                \
 EQUB 0                 \ Encoded as:   "[121][14]"

ELIF _SOURCE_DISC

 RTOK 102               \ Token 114:    "EXTRA ENERGY UNIT"
 RTOK 121               \
 RTOK 14                \ Encoded as:   "[102][121][14]"
 EQUB 0

ENDIF

ELIF _C64_VERSION

IF _GMA_RELEASE OR _SOURCE_DISK_FILES

 RTOK 102               \ Token 114:    "EXTRA ENERGY UNIT"
 RTOK 121               \
 RTOK 14                \ Encoded as:   "[102][121][14]"
 EQUB 0

ELIF _SOURCE_DISK_BUILD

 RTOK 121               \ Token 114:    "ENERGY UNIT"
 RTOK 14                \
 EQUB 0                 \ Encoded as:   "[121][14]"

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 RTOK 124               \ Token 115:    "DOCKING COMPUTERS"
 TWOK 'I', 'N'          \
 CHAR 'G'               \ Encoded as:   "[124]<140>G [55]"
 CHAR ' '
 RTOK 55
 EQUB 0

ELIF _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _6502SP_VERSION OR _NES_VERSION

 CHAR 'D'               \ Token 115:    "DOCKING COMPUTERS"
 CHAR 'O'               \
 CHAR 'C'               \ Encoded as:   "DOCK<140>G [55]"
 CHAR 'K'
 TWOK 'I', 'N'
 CHAR 'G'
 CHAR ' '
 RTOK 55
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

 RTOK 122               \ Token 116:    "GALACTIC HYPERSPACE "
 CHAR ' '               \
 RTOK 29                \ Encoded as:   "[122] [29]"
 EQUB 0

ELIF _NES_VERSION

 RTOK 122               \ Token 116:    "GALACTIC HYPERSPACE "
 CHAR ' '               \
 CHAR 'H'               \ Encoded as:   "[122] HYP<144>SPA<133>"
 CHAR 'Y'
 CHAR 'P'
 TWOK 'E', 'R'
 CHAR 'S'
 CHAR 'P'
 CHAR 'A'
 TWOK 'C', 'E'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Group A: There are two new tokens in the text token table for the new laser types in the enhanced versions (token 117 for military lasers and token 118 for mining lasers), and the "ALL" and "LL" tokens that are here in the cassette version move to 124 and 129 respectively

 CHAR 'A'               \ Token 117:    "ALL"
 RTOK 118               \
 EQUB 0                 \ Encoded as:   "A[118]"

 CHAR 'L'               \ Token 118:    "LL"
 CHAR 'L'               \
 EQUB 0                 \ Encoded as:   "LL"

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'M'               \ Token 117:    "MILITARY  LASER"
 CHAR 'I'               \
 CHAR 'L'               \ Encoded as:   "MILIT<138>Y [27]"
 CHAR 'I'
 CHAR 'T'
 TWOK 'A', 'R'
 CHAR 'Y'
 CHAR ' '
 RTOK 27
 EQUB 0

 CHAR 'M'               \ Token 118:    "MINING  LASER"
 TWOK 'I', 'N'          \
 TWOK 'I', 'N'          \ Encoded as:   "M<140><140>G [27]"
 CHAR 'G'
 CHAR ' '
 RTOK 27
 EQUB 0

ELIF _ELITE_A_VERSION OR _NES_VERSION

 CHAR 'M'               \ Token 117:    "MILITARY LASER"
 CHAR 'I'               \
 CHAR 'L'               \ Encoded as:   "MILIT<138>Y[27]"
 CHAR 'I'
 CHAR 'T'
 TWOK 'A', 'R'
 CHAR 'Y'
 RTOK 27
 EQUB 0

 CHAR 'M'               \ Token 118:    "MINING LASER"
 TWOK 'I', 'N'          \
 TWOK 'I', 'N'          \ Encoded as:   "M<140><140>G[27]"
 CHAR 'G'
 RTOK 27
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 RTOK 37                \ Token 119:    "CASH:{cash} CR{crlf}
 CHAR ':'               \               "
 CONT 0                 \
 EQUB 0                 \ Encoded as:   "[37]:{0}"

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 RTOK 37                \ Token 119:    "CASH:{cash} CR{cr}
 CHAR ':'               \               "
 CONT 0                 \
 EQUB 0                 \ Encoded as:   "[37]:{0}"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ 6502SP: When missiles are being fired at us in the Executive version, it shows the in-flight message "INCOMING MISSILE,SIR", rather than just showing "INCOMING MISSILE"

 TWOK 'I', 'N'          \ Token 120:    "INCOMING MISSILE"
 RTOK 91                \
 TWOK 'I', 'N'          \ Encoded as:   "<140>[91]<140>G [106]"
 CHAR 'G'
 CHAR ' '
 RTOK 106
 EQUB 0

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 TWOK 'I', 'N'          \ Token 120:    "INCOMING MISSILE"
 RTOK 91                \
 TWOK 'I', 'N'          \ Encoded as:   "<140>[91]<140>G [106]"
 CHAR 'G'
 CHAR ' '
 RTOK 106
 EQUB 0

ELIF _EXECUTIVE

 TWOK 'I', 'N'          \ Token 120:    "INCOMING MISSILE,SIR"
 RTOK 91                \
 TWOK 'I', 'N'          \ Encoded as:   "<140>[91]<140>G [106],SIR"
 CHAR 'G'
 CHAR ' '
 RTOK 106
 CHAR ','
 CHAR 'S'
 CHAR 'I'
 CHAR 'R'
 EQUB 0

ENDIF

ENDIF

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: There's a new token in the enhanced versions for showing that the docking computers are currently switched on. It replaces the request for a commander's name, which isn't required as the disc access menu implements that functionality using extended text tokens

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTOK 115               \ Token 123:    "DOCKING COMPUTERS ON"
 CHAR ' '               \
 CHAR 'O'               \ Encoded as:   "[115] ON"
 CHAR 'N'
 EQUB 0

ELIF _ELITE_A_VERSION

 RTOK 115               \ Token 123:    "DOCKING COMPUTERS ON"
 CHAR ' '               \
 TWOK 'O', 'N'          \ Encoded as:   "[115] <159>"
 EQUB 0

ELIF _NES_VERSION

 RTOK 115               \ Token 123:    "DOCKING COMPUTERS ON "
 RTOK 131               \
 EQUB 0                 \ Encoded as:   "[115][131]"

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: The enhanced versions drop token 124 ("DOCK") and replace it with the "ALL" token that was displaced by the new military laser token; instead, "DOCK" is spelled out manually rather than using this token

 CHAR 'D'               \ Token 124:    "DOCK"
 CHAR 'O'               \
 CHAR 'C'               \ Encoded as:   "DOCK"
 CHAR 'K'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CHAR 'A'               \ Token 124:    "ALL"
 RTOK 129               \
 EQUB 0                 \ Encoded as:   "A[129]"

ELIF _NES_VERSION

 CHAR 'A'               \ Token 124:    "ALL"
 CHAR 'L'               \
 CHAR 'L'               \ Encoded as:   "ALL"
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CONT 5                 \ Token 125:    "FUEL: {fuel level} LIGHT YEARS{cr}
 TWOK 'L', 'E'          \                CASH:{cash} CR{cr}
 CHAR 'G'               \                LEGAL STATUS:"
 TWOK 'A', 'L'          \
 CHAR ' '               \ Encoded as:   "{5}<129>G<128> [43]<145><136>:"
 RTOK 43
 TWOK 'A', 'T'
 TWOK 'U', 'S'
 CHAR ':'
 EQUB 0

ELIF _NES_VERSION

 TWOK 'L', 'E'          \ Token 125:    "LEGAL STATUS:"
 CHAR 'G'               \
 CHAR 'A'               \ Encoded as:   "<129>GAL [43]<145><136>:"
 CHAR 'L'
 CHAR ' '
 RTOK 43
 TWOK 'A', 'T'
 TWOK 'U', 'S'
 CHAR ':'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 RTOK 92                \ Token 126:    "COMMANDER {commander name}{cr}
 CHAR ' '               \                {cr}
 CONT 4                 \                {cr}
 CONT 12                \                {sentence case}PRESENT SYSTEM{tab to
 CONT 12                \                column 21}:{current system name}{cr}
 CONT 12                \                HYPERSPACE SYSTEM{tab to column 21}:
 CONT 6                 \                {selected system name}{cr}
 RTOK 145               \                CONDITION{tab to column 21}:"
 CHAR ' '               \
 RTOK 5                 \ Encoded as:   "[92] {4}{12}{12}{12}{6}[145] [5]{9}{2}
 CONT 9                 \                {12}[29][5]{9}{3}{13}C<159><141><151>
 CONT 2                 \                <159>{9}"
 CONT 12
 RTOK 29
 RTOK 5
 CONT 9
 CONT 3
 CONT 12
 CHAR 'C'
 TWOK 'O', 'N'
 TWOK 'D', 'I'
 TWOK 'T', 'I'
 TWOK 'O', 'N'
 CONT 9
 EQUB 0

ELIF _NES_VERSION

 RTOK 92                \ Token 126:    "COMMANDER {commander name}{cr}
 CHAR ' '               \                {cr}
 CONT 4                 \                {cr}
 CONT 12                \                {sentence case}PRESENT SYSTEM{tab to
 CONT 12                \                column 22}:{current system name}{cr}
 CONT 12                \                HYPERSPACE SYSTEM{tab to column 22}:
 CONT 6                 \                {selected system name}{cr}
 CHAR 'C'               \                CONDITION{tab to column 22}:"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "[92] {4}{12}{12}{12}{6}CUR<142>NT [5]
 TWOK 'R', 'E'          \                {9}{2}{12}[29][5]{9}{3}{13}C<159><141>
 CHAR 'N'               \                <151><159>{9}"
 CHAR 'T'
 CHAR ' '
 RTOK 5
 CONT 9
 CONT 2
 CONT 12
 RTOK 29
 RTOK 5
 CONT 9
 CONT 3
 CONT 12
 CHAR 'C'
 TWOK 'O', 'N'
 TWOK 'D', 'I'
 TWOK 'T', 'I'
 TWOK 'O', 'N'
 CONT 9
 EQUB 0

ENDIF

 CHAR 'I'               \ Token 127:    "ITEM"
 TWOK 'T', 'E'          \
 CHAR 'M'               \ Encoded as:   "I<156>M"
 EQUB 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

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

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 EQUB 0                 \ Token 128:    ""
                        \
                        \ Encoded as:   ""

ELIF _ELITE_A_VERSION

 CHAR 'S'               \ Token 128:    "SPACE"
 CHAR 'P'               \
 CHAR 'A'               \ Encoded as:   "SPA<133>"
 TWOK 'C', 'E'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 CONT 6                 \ Token 129:    "{sentence case}DOCKED"
 RTOK 124               \
 TWOK 'E', 'D'          \ Encoded as:   "{6}[124]<152>"
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CHAR 'L'               \ Token 129:    "LL"
 CHAR 'L'               \
 EQUB 0                 \ Encoded as:   "LL"

ENDIF

IF NOT(_NES_VERSION)

 TWOK 'R', 'A'          \ Token 130:    "RATING:"
 TWOK 'T', 'I'          \
 CHAR 'N'               \ Encoded as:   "<148><151>NG:"
 CHAR 'G'
 CHAR ':'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'R'               \ Token 130:    "RATING"
 TWOK 'A', 'T'          \
 TWOK 'I', 'N'          \ Encoded as:   "R<145><140>G"
 CHAR 'G'
 EQUB 0

ENDIF

 CHAR ' '               \ Token 131:    " ON "
 TWOK 'O', 'N'          \
 CHAR ' '               \ Encoded as:   " <159> "
 EQUB 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 CONT 13                \ Token 132:    "{crlf}
 CONT 8                 \                {all caps}EQUIPMENT: {sentence case}"
 RTOK 47                \
 CHAR 'M'               \ Encoded as:   "{13}{8}[47]M<146>T:{6}"
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 CONT 6
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 CONT 12                \ Token 132:    "{cr}
 CONT 8                 \                {all caps}EQUIPMENT: {sentence case}"
 RTOK 47                \
 CHAR 'M'               \ Encoded as:   "{12}{8}[47]M<146>T:{6}"
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 CONT 6
 EQUB 0

ELIF _NES_VERSION

 CONT 12                \ Token 132:    "{all caps}EQUIPMENT: "
 CHAR 'E'               \
 TWOK 'Q', 'U'          \ Encoded as:   "{12}E<154>IPM<146>T:"
 CHAR 'I'
 CHAR 'P'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 EQUB 0

ELIF _ELITE_A_VERSION

 CONT 12                \ Token 132:    "{cr}
 RTOK 25                \                SHIP:          "
 CHAR ':'               \
 CHAR ' '               \ Encoded as:   "{12}[25]:          "

.new_name

 CHAR ' '               \ This part is updated with our current ship's type in
 CHAR ' '               \ the n_load routine, so printing token 132 will always
 CHAR ' '               \ show the correct type of our ship
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 EQUB 0

ENDIF

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

IF NOT(_NES_VERSION)

 RTOK 12                \ Token 138:    "POOR "
 EQUB 0                 \
                        \ Encoded as:   "[12]"

 RTOK 11                \ Token 139:    "AVERAGE "
 EQUB 0                 \
                        \ Encoded as:   "[11]"

ELIF _NES_VERSION

 CHAR 'P'               \ Token 138:     "POOR"
 CHAR 'O'               \
 TWOK 'O', 'R'          \ Encoded as:   "PO<153>"
 EQUB 0

 CHAR 'A'               \ Token 139:    "AVERAGE"
 CHAR 'V'               \
 TWOK 'E', 'R'          \
 CHAR 'A'               \ Encoded as:   "AV<144>A<131>"
 TWOK 'G', 'E'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

 CHAR 'A'               \ Token 140:    "ABOVE AVERAGE "
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "ABO<150> [11]"
 TWOK 'V', 'E'
 CHAR ' '
 RTOK 11
 EQUB 0

ELIF _NES_VERSION

 CHAR 'A'               \ Token 140:    "ABOVE AVERAGE "
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "ABO<150> [139]"
 TWOK 'V', 'E'
 CHAR ' '
 RTOK 139
 EQUB 0

ENDIF

 RTOK 91                \ Token 141:    "COMPETENT"
 CHAR 'P'               \
 CHAR 'E'               \ Encoded as:   "[91]PET<146>T"
 CHAR 'T'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CHAR 'D'               \ Token 142:    "DANGEROUS"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "D<155><131>RO<136>"
 CHAR 'R'
 CHAR 'O'
 TWOK 'U', 'S'
 EQUB 0

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 CHAR 'D'               \ Token 142:    "DANGEROUS"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "D<155><131>[94]<136>"
 RTOK 94
 TWOK 'U', 'S'
 EQUB 0

ENDIF

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

IF NOT(_NES_VERSION)

 CHAR 'P'               \ Token 145:    "PRESENT"
 TWOK 'R', 'E'          \
 CHAR 'S'               \ Encoded as:   "P<142>S<146>T"
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

ELIF _NES_VERSION

 CHAR 'P'               \ Token 145:    "PRESENT"
 CHAR 'R'               \
 TWOK 'E', 'S'          \ Encoded as:   "PR<137><146>T"
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

ENDIF

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 CONT 8                 \ Token 146:    "{all caps}GAME OVER"
 CHAR 'G'               \
 CHAR 'A'               \ Encoded as:   "{8}GAME OV<144>"
 CHAR 'M'
 CHAR 'E'
 CHAR ' '
 CHAR 'O'
 CHAR 'V'
 TWOK 'E', 'R'
 EQUB 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: To make room for the new laser tokens, the enhanced versions drop tokens 147 ("PRESS FIRE OR SPACE,COMMANDER.") and 148 ("(C) ACORNSOFT 1984"), moving them instead to the extended token table

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

ELIF _NES_VERSION

 CHAR '6'               \ Token 147:    "60 SECOND PENALTY"
 CHAR '0'               \
 CHAR ' '               \ Encoded as:   "60 SEC<159>D P<146>ALTY"
 CHAR 'S'
 CHAR 'E'
 CHAR 'C'
 TWOK 'O', 'N'
 CHAR 'D'
 CHAR ' '
 CHAR 'P'
 TWOK 'E', 'N'
 CHAR 'A'
 CHAR 'L'
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

 EQUB 0                 \ Token 148:    ""
                        \
                        \ Encoded as:   ""

ELIF _DISC_VERSION OR _ELITE_A_VERSION

 SKIP 5                 \ These bytes appear to be unused

ELIF _6502SP_VERSION

IF _SNG45

 EQUB &00, &00          \ These bytes appear to be unused and just contain
 EQUB &E4, &63          \ random workspace noise left over from the BBC Micro
 EQUB &A5               \ assembly process

ELIF _EXECUTIVE

 EQUB &00, &00          \ These bytes appear to be unused and just contain
 EQUB &A5               \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISC

 SKIP 4                 \ These bytes appear to be unused

ENDIF

ELIF _MASTER_VERSION

 EQUB &00, &00          \ These bytes appear to be unused and just contain
 EQUB &19, &03          \ random workspace noise left over from the BBC Micro
 EQUB &16               \ assembly process

ELIF _C64_VERSION

IF _GMA_RELEASE OR _SOURCE_DISK_FILES

 SKIP 4                 \ These bytes appear to be unused

ELIF _SOURCE_DISK_BUILD

 SKIP 5                 \ These bytes appear to be unused

ENDIF

ELIF _APPLE_VERSION

IF _IB_DISK OR _SOURCE_DISK_CODE_FILES OR _SOURCE_DISK_ELT_FILES

 EQUB &00, &00          \ These bytes appear to be unused and just contain
 EQUB &32, &37          \ random workspace noise left over from the BBC Micro
 EQUB &3E               \ assembly process

ELIF _SOURCE_DISK_BUILD

 SKIP 5                 \ These bytes appear to be unused

ENDIF

ENDIF

