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

 RTOK 111               \ Token 0:      "FUEL SCOOPS ON {beep}"
 RTOK 131               \ Encoded as:   "[111][131]{7}"
 CTRL 7
 EQUB 0

 CHAR ' '               \ Token 1:      " CHART"
 CHAR 'C'               \ Encoded as:   " CH<138>T"
 CHAR 'H'
 TWOK 'A', 'R'
 CHAR 'T'
 EQUB 0

 CHAR 'G'               \ Token 2:      "GOVERNMENT"
 CHAR 'O'               \ Encoded as:   "GO<150>RNM<146>T"
 TWOK 'V', 'E'
 CHAR 'R'
 CHAR 'N'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'D'               \ Token 3:      "DATA ON {selected system name}"
 TWOK 'A', 'T'          \ Encoded as:   "D<145>A[131]{3}"
 CHAR 'A'
 RTOK 131
 CTRL 3
 EQUB 0

IF _CASSETTE_VERSION

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{crlf}"
 TWOK 'V', 'E'          \ Encoded as:   "<140><150>NT<153>Y{13}"
 CHAR 'N'
 CHAR 'T'
 TWOK 'O', 'R'
 CHAR 'Y'
 CTRL 13
 EQUB 0

ELIF _6502SP_VERSION

 TWOK 'I', 'N'          \ Token 4:      "INVENTORY{crlf}"
 TWOK 'V', 'E'          \ Encoded as:   "<140><150>NT<153>Y{12}"
 CHAR 'N'
 CHAR 'T'
 TWOK 'O', 'R'
 CHAR 'Y'
 CTRL 12
 EQUB 0

ENDIF

 CHAR 'S'               \ Token 5:      "SYSTEM"
 CHAR 'Y'               \ Encoded as:   "SYS<156>M"
 CHAR 'S'
 TWOK 'T', 'E'
 CHAR 'M'
 EQUB 0

 CHAR 'P'               \ Token 6:      "PRICE"
 TWOK 'R', 'I'          \ Encoded as:   "P<158><133>"
 TWOK 'C', 'E'
 EQUB 0

 CTRL 2                 \ Token 7:      "{current system name} MARKET PRICES"
 CHAR ' '               \ Encoded as:   "{2} <139>RKET [6]S"
 TWOK 'M', 'A'
 CHAR 'R'
 CHAR 'K'
 CHAR 'E'
 CHAR 'T'
 CHAR ' '
 RTOK 6
 CHAR 'S'
 EQUB 0

 TWOK 'I', 'N'          \ Token 8:      "INDUSTRIAL"
 CHAR 'D'               \ Encoded as:   "<140>D<136>T<158><128>"
 TWOK 'U', 'S'
 CHAR 'T'
 TWOK 'R', 'I'
 TWOK 'A', 'L'
 EQUB 0

 CHAR 'A'               \ Token 9:      "AGRICULTURAL"
 CHAR 'G'               \ Encoded as:   "AG<158>CULTU<148>L"
 TWOK 'R', 'I'
 CHAR 'C'
 CHAR 'U'
 CHAR 'L'
 CHAR 'T'
 CHAR 'U'
 TWOK 'R', 'A'
 CHAR 'L'
 EQUB 0

 TWOK 'R', 'I'          \ Token 10:     "RICH "
 CHAR 'C'               \ Encoded as:   "<158>CH "
 CHAR 'H'
 CHAR ' '
 EQUB 0

 CHAR 'A'               \ Token 11:     "AVERAGE "
 TWOK 'V', 'E'          \ Encoded as:   "A<150><148><131> "
 TWOK 'R', 'A'
 TWOK 'G', 'E'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 12:     "POOR "
 CHAR 'O'               \ Encoded as:   "PO<153> "
 TWOK 'O', 'R'
 CHAR ' '
 EQUB 0                 \ Encoded as:   "PO<153> "

 TWOK 'M', 'A'          \ Token 13:     "MAINLY "
 TWOK 'I', 'N'          \ Encoded as:   "<139><140>LY "
 CHAR 'L'
 CHAR 'Y'
 CHAR ' '
 EQUB 0

 CHAR 'U'               \ Token 14:     "UNIT"
 CHAR 'N'               \ Encoded as:   "UNIT"
 CHAR 'I'
 CHAR 'T'
 EQUB 0

 CHAR 'V'               \ Token 15:     "VIEW "
 CHAR 'I'               \ Encoded as:   "VIEW "
 CHAR 'E'
 CHAR 'W'
 CHAR ' '
 EQUB 0

 TWOK 'Q', 'U'          \ Token 16:     "QUANTITY"
 TWOK 'A', 'N'          \ Encoded as:   "<154><155><151>TY"
 TWOK 'T', 'I'
 CHAR 'T'
 CHAR 'Y'
 EQUB 0

 TWOK 'A', 'N'          \ Token 17:     "ANARCHY"
 TWOK 'A', 'R'          \ Encoded as:   "<155><138>CHY"
 CHAR 'C'
 CHAR 'H'
 CHAR 'Y'
 EQUB 0

 CHAR 'F'               \ Token 18:     "FEUDAL"
 CHAR 'E'               \ Encoded as:   "FEUD<128>"
 CHAR 'U'
 CHAR 'D'
 TWOK 'A', 'L'
 EQUB 0

 CHAR 'M'               \ Token 19:     "MULTI-GOVERNMENT"
 CHAR 'U'               \ Encoded as:   "MUL<151>-[2]"
 CHAR 'L'
 TWOK 'T', 'I'
 CHAR '-'
 RTOK 2
 EQUB 0

 TWOK 'D', 'I'          \ Token 20:     "DICTATORSHIP"
 CHAR 'C'               \ Encoded as:   "<141>CT<145><153>[25]"
 CHAR 'T'
 TWOK 'A', 'T'
 TWOK 'O', 'R'
 RTOK 25
 EQUB 0

 RTOK 91                \ Token 21:     "COMMUNIST"
 CHAR 'M'               \ Encoded as:   "[91]MUN<157>T"
 CHAR 'U'
 CHAR 'N'
 TWOK 'I', 'S'
 CHAR 'T'
 EQUB 0

 CHAR 'C'               \ Token 22:     "CONFEDERACY"
 TWOK 'O', 'N'          \ Encoded as:   "C<159>F<152><144>ACY"
 CHAR 'F'
 TWOK 'E', 'D'
 TWOK 'E', 'R'
 CHAR 'A'
 CHAR 'C'
 CHAR 'Y'
 EQUB 0

 CHAR 'D'               \ Token 23:     "DEMOCRACY"
 CHAR 'E'               \ Encoded as:   "DEMOC<148>CY"
 CHAR 'M'
 CHAR 'O'
 CHAR 'C'
 TWOK 'R', 'A'
 CHAR 'C'
 CHAR 'Y'
 EQUB 0

 CHAR 'C'               \ Token 24:     "CORPORATE STATE"
 TWOK 'O', 'R'          \ Encoded as:   "C<153>P<153><145>E [43]<145>E"
 CHAR 'P'
 TWOK 'O', 'R'
 TWOK 'A', 'T'
 CHAR 'E'
 CHAR ' '
 RTOK 43
 TWOK 'A', 'T'
 CHAR 'E'
 EQUB 0

 CHAR 'S'               \ Token 25:     "SHIP"
 CHAR 'H'               \ Encoded as:   "SHIP"
 CHAR 'I'
 CHAR 'P'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'P'               \ Token 26:     "PRODUCT"
 CHAR 'R'               \ Encoded as:   "PRODUCT"
 CHAR 'O'
 CHAR 'D'
 CHAR 'U'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'P'               \ Token 26:     "PRODUCT"
 RTOK 94                \ Encoded as:   "P[94]]DUCT"
 CHAR 'D'
 CHAR 'U'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

ENDIF

 CHAR ' '               \ Token 27:     " LASER"
 TWOK 'L', 'A'          \ Encoded as:   " <149>S<144>"
 CHAR 'S'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'H'               \ Token 28:     "HUMAN COLONIAL"
 CHAR 'U'               \ Encoded as:   "HUM<155> COL<159>I<128>"
 CHAR 'M'
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
 CHAR 'Y'               \ Encoded as:   "HYP<144>SPA<133> "
 CHAR 'P'
 TWOK 'E', 'R'
 CHAR 'S'
 CHAR 'P'
 CHAR 'A'
 TWOK 'C', 'E'
 CHAR ' '
 EQUB 0

 CHAR 'S'               \ Token 30:     "SHORT RANGE CHART"
 CHAR 'H'               \ Encoded as:   "SH<153>T [42][1]"
 TWOK 'O', 'R'
 CHAR 'T'
 CHAR ' '
 RTOK 42
 RTOK 1
 EQUB 0

 TWOK 'D', 'I'          \ Token 31:     "DISTANCE"
 RTOK 43                \ Encoded as:   "<141>[43]<155><133>"
 TWOK 'A', 'N'
 TWOK 'C', 'E'
 EQUB 0

 CHAR 'P'               \ Token 32:     "POPULATION"
 CHAR 'O'               \ Encoded as:   "POPUL<145>I<159>"
 CHAR 'P'
 CHAR 'U'
 CHAR 'L'
 TWOK 'A', 'T'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'G'               \ Token 33:     "GROSS PRODUCTIVITY"
 CHAR 'R'               \ Encoded as:   "GROSS [26]IVITY"
 CHAR 'O'
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

ELIF _6502SP_VERSION

 CHAR 'G'               \ Token 33:     "GROSS PRODUCTIVITY"
 RTOK 94                \ Encoded as:   "G[94]SS [26]IVITY"
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

ENDIF

 CHAR 'E'               \ Token 34:     "ECONOMY"
 CHAR 'C'               \ Encoded as:   "EC<159>OMY"
 TWOK 'O', 'N'
 CHAR 'O'
 CHAR 'M'
 CHAR 'Y'
 EQUB 0

 CHAR ' '               \ Token 35:     " LIGHT YEARS"
 CHAR 'L'               \ Encoded as:   " LIGHT YE<138>S"
 CHAR 'I'
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
 CHAR 'C'               \ Encoded as:   "<156>CH.<129><150>L"
 CHAR 'H'
 CHAR '.'
 TWOK 'L', 'E'
 TWOK 'V', 'E'
 CHAR 'L'
 EQUB 0

 CHAR 'C'               \ Token 37:     "CASH"
 CHAR 'A'               \ Encoded as:   "CASH"
 CHAR 'S'
 CHAR 'H'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \ Encoded as:   " <134>[118]I<159>"
 RTOK 118
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

ELIF _6502SP_VERSION

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \ Encoded as:   " <134>[129]I<159>"
 RTOK 129
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

ENDIF

 RTOK 122               \ Token 39:     "GALACTIC CHART{galaxy number
 RTOK 1                 \                right-aligned to width 3}"
 CTRL 1                 \ Encoded as:   "[122][1]{1}"
 EQUB 0

 CHAR 'T'               \ Token 40:     "TARGET LOST"
 TWOK 'A', 'R'          \ Encoded as:   "T<138><131>T LO[43]"
 TWOK 'G', 'E'
 CHAR 'T'
 CHAR ' '
 CHAR 'L'
 CHAR 'O'
 RTOK 43
 EQUB 0

 RTOK 106               \ Token 41:     "MISSILE JAMMED"
 CHAR ' '               \ Encoded as:   "[106] JAMM<152>"
 CHAR 'J'
 CHAR 'A'
 CHAR 'M'
 CHAR 'M'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'R'               \ Token 42:     "RANGE"
 TWOK 'A', 'N'          \ Encoded as:   "R<155><131>"
 TWOK 'G', 'E'
 EQUB 0

 CHAR 'S'               \ Token 43:     "ST"
 CHAR 'T'               \ Encoded as:   "ST"
 EQUB 0

 RTOK 16                \ Token 44:     "QUANTITY OF "
 CHAR ' '               \ Encoded as:   "[16] OF "
 CHAR 'O'
 CHAR 'F'
 CHAR ' '
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \ Encoded as:   "SE[118]"
 RTOK 118
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'S'               \ Token 45:     "SELL"
 CHAR 'E'               \ Encoded as:   "SE[129]"
 RTOK 129
 EQUB 0

ENDIF

 CHAR ' '               \ Token 46:     " CARGO{switch to sentence case}"
 CHAR 'C'               \ Encoded as:   " C<138>GO{6}"
 TWOK 'A', 'R'
 CHAR 'G'
 CHAR 'O'
 CTRL 6
 EQUB 0

 CHAR 'E'               \ Token 47:     "EQUIP"
 TWOK 'Q', 'U'          \ Encoded as:   "E<154>IP"
 CHAR 'I'
 CHAR 'P'
 EQUB 0

 CHAR 'F'               \ Token 48:     "FOOD"
 CHAR 'O'               \ Encoded as:   "FOOD"
 CHAR 'O'
 CHAR 'D'
 EQUB 0

 TWOK 'T', 'E'          \ Token 49:     "TEXTILES"
 CHAR 'X'               \ Encoded as:   "<156>X<151>L<137>"
 TWOK 'T', 'I'
 CHAR 'L'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'R', 'A'          \ Token 50:     "RADIOACTIVES"
 TWOK 'D', 'I'          \ Encoded as:   "<148><141>OAC<151><150>S"
 CHAR 'O'
 CHAR 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 TWOK 'V', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'S'               \ Token 51:     "SLAVES"
 TWOK 'L', 'A'          \ Encoded as:   "S<149><150>S"
 TWOK 'V', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'L'               \ Token 52:     "LIQUOR/WINES"
 CHAR 'I'               \ Encoded as:   "LI<154><153>/W<140><137>"
 TWOK 'Q', 'U'
 TWOK 'O', 'R'
 CHAR '/'
 CHAR 'W'
 TWOK 'I', 'N'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'L'               \ Token 53:     "LUXURIES"
 CHAR 'U'               \ Encoded as:   "LUXU<158><137>"
 CHAR 'X'
 CHAR 'U'
 TWOK 'R', 'I'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'N'               \ Token 54:     "NARCOTICS"
 TWOK 'A', 'R'          \ Encoded as:   "N<138>CO<151>CS"
 CHAR 'C'
 CHAR 'O'
 TWOK 'T', 'I'
 CHAR 'C'
 CHAR 'S'
 EQUB 0

 RTOK 91                \ Token 55:     "COMPUTERS"
 CHAR 'P'               \ Encoded as:   "[91]PUT<144>S"
 CHAR 'U'
 CHAR 'T'
 TWOK 'E', 'R'
 CHAR 'S'
 EQUB 0

 TWOK 'M', 'A'          \ Token 56:     "MACHINERY"
 CHAR 'C'               \ Encoded as:   "<139>CH<140><144>Y"
 CHAR 'H'
 TWOK 'I', 'N'
 TWOK 'E', 'R'
 CHAR 'Y'
 EQUB 0

IF _CASSETTE_VERSION

 RTOK 117               \ Token 57:     "ALLOYS"
 CHAR 'O'               \ Encoded as:   "[117]OYS"
 CHAR 'Y'
 CHAR 'S'
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'A'               \ Token 57:     "ALLOYS"
 CHAR 'L'               \ Encoded as:   "ALLOYS"
 CHAR 'L'
 CHAR 'O'
 CHAR 'Y'
 CHAR 'S'
 EQUB 0

ENDIF

 CHAR 'F'               \ Token 58:     "FIREARMS"
 CHAR 'I'               \ Encoded as:   "FI<142><138>MS"
 TWOK 'R', 'E'
 TWOK 'A', 'R'
 CHAR 'M'
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 59:     "FURS"
 CHAR 'U'               \ Encoded as:   "FURS"
 CHAR 'R'
 CHAR 'S'
 EQUB 0

 CHAR 'M'               \ Token 60:     "MINERALS"
 TWOK 'I', 'N'          \ Encoded as:   "M<140><144><128>S"
 TWOK 'E', 'R'
 TWOK 'A', 'L'
 CHAR 'S'
 EQUB 0

 CHAR 'G'               \ Token 61:     "GOLD"
 CHAR 'O'               \ Encoded as:   "GOLD"
 CHAR 'L'
 CHAR 'D'
 EQUB 0

 CHAR 'P'               \ Token 62:     "PLATINUM"
 CHAR 'L'               \ Encoded as:   "PL<145><140>UM"
 TWOK 'A', 'T'
 TWOK 'I', 'N'
 CHAR 'U'
 CHAR 'M'
 EQUB 0

 TWOK 'G', 'E'          \ Token 63:     "GEM-STONES"
 CHAR 'M'               \ Encoded as:   "<131>M-[43]<159><137>"
 CHAR '-'
 RTOK 43
 TWOK 'O', 'N'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'A', 'L'          \ Token 64:     "ALIEN ITEMS"
 CHAR 'I'               \ Encoded as:   "<128>I<146> [127]S"
 TWOK 'E', 'N'
 CHAR ' '
 RTOK 127
 CHAR 'S'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR '('               \ Token 65:     "(Y/N)?"
 CHAR 'Y'               \ Encoded as:   "(Y/N)?"
 CHAR '/'
 CHAR 'N'
 CHAR ')'
 CHAR '?'
 EQUB 0

ELIF _6502SP_VERSION

 CTRL 12                \ Token 65:     "{crlf}10{cash right-aligned to width 9}
 CHAR '1'               \                 CR5{cash right-aligned to width 9} CR"
 CHAR '0'               \ Encoded as:   "{12}10{0}5{0}"
 CTRL 0
 CHAR '5'
 CTRL 0
 EQUB 0

ENDIF

 CHAR ' '               \ Token 66:     " CR"
 CHAR 'C'               \ Encoded as:   " CR"
 CHAR 'R'
 EQUB 0

 CHAR 'L'               \ Token 67:     "LARGE"
 TWOK 'A', 'R'          \ Encoded as:   "L<138><131>"
 TWOK 'G', 'E'
 EQUB 0

 CHAR 'F'               \ Token 68:     "FIERCE"
 CHAR 'I'               \ Encoded as:   "FI<144><133>"
 TWOK 'E', 'R'
 TWOK 'C', 'E'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'S'               \ Token 69:     "SMALL"
 TWOK 'M', 'A'          \ Encoded as:   "S<139>[118]"
 RTOK 118
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'S'               \ Token 69:     "SMALL"
 TWOK 'M', 'A'          \ Encoded as:   "S<139>[129]"
 RTOK 129
 EQUB 0

ENDIF

 CHAR 'G'               \ Token 70:     "GREEN"
 TWOK 'R', 'E'          \ Encoded as:   "G<142><146>"
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'R'               \ Token 71:     "RED"
 TWOK 'E', 'D'          \ Encoded as:   "R<152>"
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \ Encoded as:   "YE[118]OW"
 RTOK 118
 CHAR 'O'
 CHAR 'W'
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'Y'               \ Token 72:     "YELLOW"
 CHAR 'E'               \ Encoded as:   "YE[129]OW"
 RTOK 129
 CHAR 'O'
 CHAR 'W'
 EQUB 0

ENDIF

 CHAR 'B'               \ Token 73:     "BLUE"
 CHAR 'L'               \ Encoded as:   "BLUE"
 CHAR 'U'
 CHAR 'E'
 EQUB 0

 CHAR 'B'               \ Token 74:     "BLACK"
 TWOK 'L', 'A'          \ Encoded as:   "B<149>CK"
 CHAR 'C'
 CHAR 'K'
 EQUB 0

 RTOK 136               \ Token 75:     "HARMLESS"
 EQUB 0                 \ Encoded as:   "[136]"

 CHAR 'S'               \ Token 76:     "SLIMY"
 CHAR 'L'               \ Encoded as:   "SLIMY"
 CHAR 'I'
 CHAR 'M'
 CHAR 'Y'
 EQUB 0

 CHAR 'B'               \ Token 77:     "BUG-EYED"
 CHAR 'U'               \ Encoded as:   "BUG-EY<152>"
 CHAR 'G'
 CHAR '-'
 CHAR 'E'
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'H'               \ Token 78:     "HORNED"
 TWOK 'O', 'R'          \ Encoded as:   "H<153>N<152>"
 CHAR 'N'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'B'               \ Token 79:     "BONY"
 TWOK 'O', 'N'          \ Encoded as:   "B<159>Y"
 CHAR 'Y'
 EQUB 0

 CHAR 'F'               \ Token 80:     "FAT"
 TWOK 'A', 'T'          \ Encoded as:   "F<145>"
 EQUB 0

 CHAR 'F'               \ Token 81:     "FURRY"
 CHAR 'U'               \ Encoded as:   "FURRY"
 CHAR 'R'
 CHAR 'R'
 CHAR 'Y'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'R'               \ Token 82:     "RODENT"
 CHAR 'O'               \ Encoded as:   "ROD<146>T"
 CHAR 'D'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'F'               \ Token 83:     "FROG"
 CHAR 'R'               \ Encoded as:   "FROG"
 CHAR 'O'
 CHAR 'G'
 EQUB 0

ELIF _6502SP_VERSION

 RTOK 94                \ Token 82:     "RODENT"
 CHAR 'D'               \ Encoded as:   "[94]D<146>T"
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'F'               \ Token 83:     "FROG"
 RTOK 94                \ Encoded as:   "F[94]G"
 CHAR 'G'
 EQUB 0

ENDIF

 CHAR 'L'               \ Token 84:     "LIZARD"
 CHAR 'I'               \ Encoded as:   "LI<132>RD"
 TWOK 'Z', 'A'
 CHAR 'R'
 CHAR 'D'
 EQUB 0

 CHAR 'L'               \ Token 85:     "LOBSTER"
 CHAR 'O'               \ Encoded as:   "LOB[43]<144>"
 CHAR 'B'
 RTOK 43
 TWOK 'E', 'R'
 EQUB 0

 TWOK 'B', 'I'          \ Token 86:     "BIRD"
 CHAR 'R'               \ Encoded as:   "<134>RD"
 CHAR 'D'
 EQUB 0

 CHAR 'H'               \ Token 87:     "HUMANOID"
 CHAR 'U'               \ Encoded as:   "HUM<155>OID"
 CHAR 'M'
 TWOK 'A', 'N'
 CHAR 'O'
 CHAR 'I'
 CHAR 'D'
 EQUB 0

 CHAR 'F'               \ Token 88:     "FELINE"
 CHAR 'E'               \ Encoded as:   "FEL<140>E"
 CHAR 'L'
 TWOK 'I', 'N'
 CHAR 'E'
 EQUB 0

 TWOK 'I', 'N'          \ Token 89:     "INSECT"
 CHAR 'S'               \ Encoded as:   "<140>SECT"
 CHAR 'E'
 CHAR 'C'
 CHAR 'T'
 EQUB 0

 RTOK 11                \ Token 90:     "AVERAGE RADIUS"
 TWOK 'R', 'A'          \ Encoded as:   "[11]<148><141><136>"
 TWOK 'D', 'I'
 TWOK 'U', 'S'
 EQUB 0

 CHAR 'C'               \ Token 91:     "COM"
 CHAR 'O'               \ Encoded as:   "COM"
 CHAR 'M'
 EQUB 0

 RTOK 91                \ Token 92:     "COMMANDER"
 CHAR 'M'               \ Encoded as:   "[91]M<155>D<144>"
 TWOK 'A', 'N'
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR ' '               \ Token 93:     " DESTROYED"
 CHAR 'D'               \ Encoded as:   " D<137>TROY<152>"
 TWOK 'E', 'S'
 CHAR 'T'
 CHAR 'R'
 CHAR 'O'
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'B'               \ Token 94:     "BY D.BRABEN & I.BELL"
 CHAR 'Y'               \ Encoded as:   "BY D.B<148><147>N & I.<147>[118]"
 CHAR ' '
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

 RTOK 14                \ Token 95:     "UNIT  QUANTITY{crlf} PRODUCT   UNIT
 CHAR ' '               \                 PRICE FOR SALE{crlf}{lf}"
 CHAR ' '               \ Encoded as:   "[14]  [16]{13} [26]   [14] [6] F<153>
 RTOK 16                \                 SA<129>{13}{10}"
 CTRL 13
 CHAR ' '
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
 CTRL 13
 CTRL 10
 EQUB 0

ELIF _6502SP_VERSION

 CHAR ' '               \ Token 93:     " DESTROYED"
 CHAR 'D'               \ Encoded as:   " D<137>T[94]Y<152>"
 TWOK 'E', 'S'
 CHAR 'T'
 RTOK 94
 CHAR 'Y'
 TWOK 'E', 'D'
 EQUB 0

 CHAR 'R'               \ Token 94:     "RO"
 CHAR 'O'               \ Encoded as:   "RO"
 EQUB 0

 RTOK 14                \ Token 95:     "UNIT  QUANTITY{crlf} PRODUCT   UNIT
 CHAR ' '               \                 PRICE FOR SALE{crlf}{lf}"
 CHAR ' '               \ Encoded as:   "[14]  [16]{12} [26]   [14] [6] F<153>
 RTOK 16                \                 SA<129>{12}{10}"
 CTRL 12
 CHAR ' '
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
 CTRL 12
 CTRL 10
 EQUB 0

ENDIF

 CHAR 'F'               \ Token 96:     "FRONT"
 CHAR 'R'               \ Encoded as:   "FR<159>T"
 TWOK 'O', 'N'
 CHAR 'T'
 EQUB 0

 TWOK 'R', 'E'          \ Token 97:     "REAR"
 TWOK 'A', 'R'          \ Encoded as:   "<142><138>"
 EQUB 0

 TWOK 'L', 'E'          \ Token 98:     "LEFT"
 CHAR 'F'               \ Encoded as:   "<129>FT"
 CHAR 'T'
 EQUB 0

 TWOK 'R', 'I'          \ Token 99:     "RIGHT"
 CHAR 'G'               \ Encoded as:   "<158>GHT"
 CHAR 'H'
 CHAR 'T'
 EQUB 0

 RTOK 121               \ Token 100:    "ENERGY LOW{beep}"
 CHAR 'L'               \ Encoded as:   "[121]LOW{7}"
 CHAR 'O'
 CHAR 'W'
 CTRL 7
 EQUB 0

 RTOK 99                \ Token 101:    "RIGHT ON COMMANDER!"
 RTOK 131               \ Encoded as:   "[99][131][92]!"
 RTOK 92
 CHAR '!'
 EQUB 0

 CHAR 'E'               \ Token 102:    "EXTRA "
 CHAR 'X'               \ Encoded as:   "EXT<148> "
 CHAR 'T'
 TWOK 'R', 'A'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 103:    "PULSE LASER"
 CHAR 'U'               \ Encoded as:   "PULSE[27]"
 CHAR 'L'
 CHAR 'S'
 CHAR 'E'
 RTOK 27
 EQUB 0

 TWOK 'B', 'E'          \ Token 104:    "BEAM LASER"
 CHAR 'A'               \ Encoded as:   "<147>AM[27]"
 CHAR 'M'
 RTOK 27
 EQUB 0

 CHAR 'F'               \ Token 105:    "FUEL"
 CHAR 'U'               \ Encoded as:   "FUEL"
 CHAR 'E'
 CHAR 'L'
 EQUB 0

 CHAR 'M'               \ Token 106:    "MISSILE"
 TWOK 'I', 'S'          \ Encoded as:   "M<157>SI<129>"
 CHAR 'S'
 CHAR 'I'
 TWOK 'L', 'E'
 EQUB 0

 RTOK 67                \ Token 107:    "LARGE CARGO{switch to sentence
 RTOK 46                \                 case} BAY"
 CHAR ' '               \ Encoded as:   "[67][46] BAY"
 CHAR 'B'
 CHAR 'A'
 CHAR 'Y'
 EQUB 0

 CHAR 'E'               \ Token 108:    "E.C.M.SYSTEM"
 CHAR '.'               \ Encoded as:   "E.C.M.[5]"
 CHAR 'C'
 CHAR '.'
 CHAR 'M'
 CHAR '.'
 RTOK 5
 EQUB 0

 RTOK 102               \ Token 109:    "EXTRA PULSE LASERS"
 RTOK 103               \ Encoded as:   "[102][103]S"
 CHAR 'S'
 EQUB 0

 RTOK 102               \ Token 110:    "EXTRA BEAM LASERS"
 RTOK 104               \ Encoded as:   "[102][104]S"
 CHAR 'S'
 EQUB 0

 RTOK 105               \ Token 111:    "FUEL SCOOPS"
 CHAR ' '               \ Encoded as:   "[105] SCOOPS"
 CHAR 'S'
 CHAR 'C'
 CHAR 'O'
 CHAR 'O'
 CHAR 'P'
 CHAR 'S'
 EQUB 0

 TWOK 'E', 'S'          \ Token 112:    "ESCAPE POD"
 CHAR 'C'               \ Encoded as:   "<137>CAPE POD"
 CHAR 'A'
 CHAR 'P'
 CHAR 'E'
 CHAR ' '
 CHAR 'P'
 CHAR 'O'
 CHAR 'D'
 EQUB 0

 RTOK 121               \ Token 113:    "ENERGY BOMB"
 CHAR 'B'               \ Encoded as:   "[121]BOMB"
 CHAR 'O'
 CHAR 'M'
 CHAR 'B'
 EQUB 0

IF _CASSETTE_VERSION

 RTOK 121               \ Token 114:    "ENERGY UNIT"
 RTOK 14                \ Encoded as:   "[121][14]"
 EQUB 0

 RTOK 124               \ Token 115:    "DOCKING COMPUTERS"
 TWOK 'I', 'N'          \ Encoded as:   "[124]<140>G [55]"
 CHAR 'G'
 CHAR ' '
 RTOK 55
 EQUB 0

ELIF _6502SP_VERSION

 RTOK 102               \ Token 114:    "EXTRA ENERGY UNIT"
 RTOK 121                \ Encoded as:   "[102][121][14]"
 RTOK 14
 EQUB 0

 CHAR 'D'               \ Token 115:    "DOCKING COMPUTERS"
 CHAR 'O'               \ Encoded as:   "DOCK<140>G [55]"
 CHAR 'C'
 CHAR 'K'
 TWOK 'I', 'N'
 CHAR 'G'
 CHAR ' '
 RTOK 55
 EQUB 0

ENDIF

 RTOK 122               \ Token 116:    "GALACTIC HYPERSPACE "
 CHAR ' '               \ Encoded as:   "[122] [29]"
 RTOK 29
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'A'               \ Token 117:    "ALL"
 RTOK 118               \ Encoded as:   "A[118]"
 EQUB 0

 CHAR 'L'               \ Token 118:    "LL"
 CHAR 'L'               \ Encoded as:   "LL"
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'M'               \ Token 117:    "MILITARY  LASER"
 CHAR 'I'               \ Encoded as:   "MILIT<138>Y [27]"
 CHAR 'L'
 CHAR 'I'
 CHAR 'T'
 TWOK 'A', 'R'
 CHAR 'Y'
 CHAR ' '
 RTOK 27
 EQUB 0

 CHAR 'M'               \ Token 118:    "MINING  LASER"
 TWOK 'I', 'N'          \ Encoded as:   "M<140><140>G [27]"
 TWOK 'I', 'N'
 CHAR 'G'
 CHAR ' '
 RTOK 27
 EQUB 0

ENDIF

 RTOK 37                \ Token 119:    "CASH:{cash right-aligned to width 9}
 CHAR ':'               \                 CR{crlf}"
 CTRL 0                 \ Encoded as:   "[37]:{0}"
 EQUB 0

 TWOK 'I', 'N'          \ Token 120:    "INCOMING MISSILE"
 RTOK 91                \ Encoded as:   "<140>[91]<140>G [106]"
 TWOK 'I', 'N'
 CHAR 'G'
 CHAR ' '
 RTOK 106
 EQUB 0

 TWOK 'E', 'N'          \ Token 121:    "ENERGY "
 TWOK 'E', 'R'          \ Encoded as:   "<146><144>GY "
 CHAR 'G'
 CHAR 'Y'
 CHAR ' '
 EQUB 0

 CHAR 'G'               \ Token 122:    "GALACTIC"
 CHAR 'A'               \ Encoded as:   "GA<149>C<151>C"
 TWOK 'L', 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 CHAR 'C'
 EQUB 0

IF _CASSETTE_VERSION

 CTRL 13                \ Token 123:    "{crlf}COMMANDER'S NAME? "
 RTOK 92                \ Encoded as:   "{13}[92]'S NAME? "
 CHAR 39                \ CHAR 39 is the apostrophe
 CHAR 'S'
 CHAR ' '
 CHAR 'N'
 CHAR 'A'
 CHAR 'M'
 CHAR 'E'
 CHAR '?'
 CHAR ' '
 EQUB 0

 CHAR 'D'               \ Token 124:    "DOCK"
 CHAR 'O'               \ Encoded as:   "DOCK"
 CHAR 'C'
 CHAR 'K'
 EQUB 0

ELIF _6502SP_VERSION

 RTOK 115               \ Token 123:    "DOCKING COMPUTERS ON"
 CHAR ' '               \ Encoded as:   "[115] ON"
 CHAR 'O'
 CHAR 'N'
 EQUB 0

 CHAR 'A'               \ Token 124:    "ALL"
 RTOK 129               \ Encoded as:   "A[129]"
 EQUB 0

ENDIF

 CTRL 5                 \ Token 125:    "FUEL: {fuel level} LIGHT YEARS{crlf}
 TWOK 'L', 'E'          \                CASH:{cash right-aligned to width 9}
 CHAR 'G'               \                 CR{crlf}LEGAL STATUS:"
 TWOK 'A', 'L'          \ Encoded as:   "{5}<129>G<128> [43]<145><136>:"
 CHAR ' '
 RTOK 43
 TWOK 'A', 'T'
 TWOK 'U', 'S'
 CHAR ':'
 EQUB 0

IF _CASSETTE_VERSION

 RTOK 92                \ Token 126:    "COMMANDER {commander name}{crlf}{crlf}
 CHAR ' '               \                {crlf}{switch to sentence case}PRESENT
 CTRL 4                 \                 SYSTEM{tab to column 21}:{current
 CTRL 13                \                system name}{crlf}HYPERSPACE SYSTEM
 CTRL 13                \                {tab to column 21}:{selected system
 CTRL 13                \                name}{crlf}CONDITION{tab to column
 CTRL 6                 \                21}:"
 RTOK 145               \ Encoded as:   "[92] {4}{13}{13}{13}{6}[145] [5]{9}{2}
 CHAR ' '               \                {13}[29][5]{9}{3}{13}C<159><141><151>
 RTOK 5                 \                <159>{9}"
 CTRL 9
 CTRL 2
 CTRL 13
 RTOK 29
 RTOK 5
 CTRL 9
 CTRL 3
 CTRL 13
 CHAR 'C'
 TWOK 'O', 'N'
 TWOK 'D', 'I'
 TWOK 'T', 'I'
 TWOK 'O', 'N'
 CTRL 9
 EQUB 0

ELIF _6502SP_VERSION

 RTOK 92                \ Token 126:    "COMMANDER {commander name}{crlf}{crlf}
 CHAR ' '               \                {crlf}{switch to sentence case}PRESENT
 CTRL 4                 \                 SYSTEM{tab to column 21}:{current
 CTRL 12                \                system name}{crlf}HYPERSPACE SYSTEM
 CTRL 12                \                {tab to column 21}:{selected system
 CTRL 12                \                name}{crlf}CONDITION{tab to column
 CTRL 6                 \                21}:"
 RTOK 145               \ Encoded as:   "[92] {4}{12}{12}{12}{6}[145] [5]{9}{2}
 CHAR ' '               \                {12}[29][5]{9}{3}{12}C<159><141><151>
 RTOK 5                 \                <159>{9}"
 CTRL 9
 CTRL 2
 CTRL 12
 RTOK 29
 RTOK 5
 CTRL 9
 CTRL 3
 CTRL 12
 CHAR 'C'
 TWOK 'O', 'N'
 TWOK 'D', 'I'
 TWOK 'T', 'I'
 TWOK 'O', 'N'
 CTRL 9
 EQUB 0

ENDIF

 CHAR 'I'               \ Token 127:    "ITEM"
 TWOK 'T', 'E'          \ Encoded as:   "I<156>M"
 CHAR 'M'
 EQUB 0

IF _CASSETTE_VERSION


 CHAR ' '               \ Token 128:    "  LOAD NEW COMMANDER (Y/N)?
 CHAR ' '               \                {crlf}{crlf}"
 CHAR 'L'               \ Encoded as:   "  LOAD NEW [92] [65]{13}{13}"
 CHAR 'O'
 CHAR 'A'
 CHAR 'D'
 CHAR ' '
 CHAR 'N'
 CHAR 'E'
 CHAR 'W'
 CHAR ' '
 RTOK 92
 CHAR ' '
 RTOK 65
 CTRL 13
 CTRL 13
 EQUB 0

 CTRL 6                 \ Token 129:    "{switch to sentence case}DOCKED"
 RTOK 124               \ Encoded as:   "{6}[124]<152>"
 TWOK 'E', 'D'
 EQUB 0

ELIF _6502SP_VERSION

 EQUB 0                 \ Token 128:    ""

 CHAR 'L'               \ Token 129:    "LL"
 CHAR 'L'               \ Encoded as:   "LL"
 EQUB 0

ENDIF

 TWOK 'R', 'A'          \ Token 130:    "RATING:"
 TWOK 'T', 'I'          \ Encoded as:   "<148><151>NG:"
 CHAR 'N'
 CHAR 'G'
 CHAR ':'
 EQUB 0

 CHAR ' '               \ Token 131:    " ON "
 TWOK 'O', 'N'          \ Encoded as:   " <159> "
 CHAR ' '
 EQUB 0

IF _CASSETTE_VERSION

 CTRL 13                \ Token 132:    "{crlf}{switch to all caps}EQUIPMENT:
 CTRL 8                 \                {switch to sentence case}"
 RTOK 47                \ Encoded as:   "{13}{8}[47]M<146>T:{6}"
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 CTRL 6
 EQUB 0

ELIF _6502SP_VERSION

 CTRL 12                \ Token 132:    "{crlf}{switch to all caps}EQUIPMENT:
 CTRL 8                 \                {switch to sentence case}"
 RTOK 47                \ Encoded as:   "{12}{8}[47]M<146>T:{6}"
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 CTRL 6
 EQUB 0

ENDIF

 CHAR 'C'               \ Token 133:    "CLEAN"
 TWOK 'L', 'E'          \ Encoded as:   "C<129><155>"
 TWOK 'A', 'N'
 EQUB 0

 CHAR 'O'               \ Token 134:    "OFFENDER"
 CHAR 'F'               \ Encoded as:   "OFF<146>D<144>"
 CHAR 'F'
 TWOK 'E', 'N'
 CHAR 'D'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'F'               \ Token 135:    "FUGITIVE"
 CHAR 'U'               \ Encoded as:   "FUGI<151><150>"
 CHAR 'G'
 CHAR 'I'
 TWOK 'T', 'I'
 TWOK 'V', 'E'
 EQUB 0

 CHAR 'H'               \ Token 136:    "HARMLESS"
 TWOK 'A', 'R'          \ Encoded as:   "H<138>M<129>SS"
 CHAR 'M'
 TWOK 'L', 'E'
 CHAR 'S'
 CHAR 'S'
 EQUB 0

 CHAR 'M'               \ Token 137:    "MOSTLY HARMLESS"
 CHAR 'O'               \ Encoded as:   "MO[43]LY [136]"
 RTOK 43
 CHAR 'L'
 CHAR 'Y'
 CHAR ' '
 RTOK 136
 EQUB 0

 RTOK 12                \ Token 138:    "POOR "
 EQUB 0                 \ Encoded as:   "[12]"

 RTOK 11                \ Token 139:    "AVERAGE "
 EQUB 0                 \ Encoded as:   "[11]"

 CHAR 'A'               \ Token 140:    "ABOVE AVERAGE "
 CHAR 'B'               \ Encoded as:   "ABO<150> [11]"
 CHAR 'O'
 TWOK 'V', 'E'
 CHAR ' '
 RTOK 11
 EQUB 0

 RTOK 91                \ Token 141:    "COMPETENT"
 CHAR 'P'               \ Encoded as:   "[91]PET<146>T"
 CHAR 'E'
 CHAR 'T'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'D'               \ Token 142:    "DANGEROUS"
 TWOK 'A', 'N'          \ Encoded as:   "D<155><131>RO<136>"
 TWOK 'G', 'E'
 CHAR 'R'
 CHAR 'O'
 TWOK 'U', 'S'
 EQUB 0

ELIF _6502SP_VERSION

 CHAR 'D'               \ Token 142:    "DANGEROUS"
 TWOK 'A', 'N'          \ Encoded as:   "D<155><131>[94]<136>"
 TWOK 'G', 'E'
 RTOK 94
 TWOK 'U', 'S'
 EQUB 0

ENDIF

 CHAR 'D'               \ Token 143:    "DEADLY"
 CHAR 'E'               \ Encoded as:   "DEADLY"
 CHAR 'A'
 CHAR 'D'
 CHAR 'L'
 CHAR 'Y'
 EQUB 0

 CHAR '-'               \ Token 144:    "---- E L I T E ----"
 CHAR '-'               \ Encoded as:   "---- E L I T E ----"
 CHAR '-'
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
 TWOK 'R', 'E'          \ Encoded as:   "P<142>S<146>T"
 CHAR 'S'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CTRL 8                 \ Token 146:    "{switch to all caps}GAME OVER"
 CHAR 'G'               \ Encoded as:   "{8}GAME O<150>R"
 CHAR 'A'
 CHAR 'M'
 CHAR 'E'
 CHAR ' '
 CHAR 'O'
 TWOK 'V', 'E'
 CHAR 'R'
 EQUB 0

IF _CASSETTE_VERSION

 CHAR 'P'               \ Token 147:    "PRESS FIRE OR SPACE,COMMANDER.
 CHAR 'R'               \                {crlf}{crlf}"
 TWOK 'E', 'S'          \ Encoded as:   "PR<137>S FI<142> <153> SPA<133>,[92].
 CHAR 'S'               \                {13}{13}"
 CHAR ' '
 CHAR 'F'
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
 CTRL 13
 CTRL 13
 EQUB 0

 CHAR '('               \ Token 148:    "(C) ACORNSOFT 1984"
 CHAR 'C'               \ Encoded as:   "(C) AC<153>N<135>FT 1984"
 CHAR ')'
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

ELIF _6502SP_VERSION

 SKIP 4                 \ These bytes are unused

ENDIF
