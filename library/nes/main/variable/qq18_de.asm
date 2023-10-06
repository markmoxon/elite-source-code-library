\ ******************************************************************************
\
\       Name: QQ18_DE
\       Type: Variable
\   Category: Text
\    Summary: The recursive token table for tokens 0-148 (German)
\  Deep dive: Printing text tokens
\
\ ******************************************************************************

.QQ18_DE

 RTOK 105               \ Token 0:      "TREIBSTOFFSCHAUFEL AN {beep}"
 CHAR 'S'               \
 CHAR 'C'               \ Encoded as:   "[105]SCHAUFEL[131]{7}"
 CHAR 'H'
 CHAR 'A'
 CHAR 'U'
 CHAR 'F'
 CHAR 'E'
 CHAR 'L'
 RTOK 131
 CONT 7
 EQUB 0

 CHAR ' '               \ Token 1:      " KARTE"
 CHAR 'K'               \
 TWOK 'A', 'R'          \ Encoded as:   " K<138><156>"
 TWOK 'T', 'E'
 EQUB 0

 TWOK 'R', 'E'          \ Token 2:      "REGIERUNG"
 CHAR 'G'               \
 CHAR 'I'               \ Encoded as:   "<142>GI<144>UNG"
 TWOK 'E', 'R'
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 EQUB 0

 CHAR 'D'               \ Token 3:      "DATEN EIN {selected system name}"
 TWOK 'A', 'T'          \
 TWOK 'E', 'N'          \ Encoded as:   "D<145><146> E<140> {3}"
 CHAR ' '
 CHAR 'E'
 TWOK 'I', 'N'
 CHAR ' '
 CONT 3
 EQUB 0

 TWOK 'I', 'N'          \ Token 4:      "INHALT{cr}
 CHAR 'H'               \               "
 CHAR 'A'               \
 CHAR 'L'               \ Encoded as:   "<140>HALT{12}"
 CHAR 'T'
 CONT 12
 EQUB 0

 CONT 6                 \ Token 5:      "{sentence case}SYSTEM"
 CHAR 'S'               \
 CHAR 'Y'               \ Encoded as:   "{6}SYS<156>M"
 CHAR 'S'
 TWOK 'T', 'E'
 CHAR 'M'
 EQUB 0

 CONT 6                 \ Token 6:      "{sentence case}PREIS"
 CHAR 'P'               \
 TWOK 'R', 'E'          \ Encoded as:   "{6}P<142><157>"
 TWOK 'I', 'S'
 EQUB 0

 CONT 2                 \ Token 7:      "{current system name} BÖRSENPREISE "
 CHAR ' '               \
 CHAR 'B'               \ Encoded as:   "{2} B\RS<146>P<142><157>E "
 CHAR '\'
 CHAR 'R'
 CHAR 'S'
 TWOK 'E', 'N'
 CHAR 'P'
 TWOK 'R', 'E'
 TWOK 'I', 'S'
 CHAR 'E'
 CHAR ' '
 EQUB 0

 TWOK 'I', 'N'          \ Token 8:      "INDUSTRIE"
 CHAR 'D'               \
 TWOK 'U', 'S'          \ Encoded as:   "<140>D<136>T<158>E"
 CHAR 'T'
 TWOK 'R', 'I'
 CHAR 'E'
 EQUB 0

 CHAR 'A'               \ Token 9:      "AGRIKULTUR"
 CHAR 'G'               \
 TWOK 'R', 'I'          \ Encoded as:   "AG<158>KULTUR"
 CHAR 'K'
 CHAR 'U'
 CHAR 'L'
 CHAR 'T'
 CHAR 'U'
 CHAR 'R'
 EQUB 0

 TWOK 'R', 'E'          \ Token 10:     "REICHE "
 CHAR 'I'               \
 CHAR 'C'               \ Encoded as:   "<142>ICHE "
 CHAR 'H'
 CHAR 'E'
 CHAR ' '
 EQUB 0

 CHAR 'M'               \ Token 11:     "MITTELM "
 CHAR 'I'               \
 CHAR 'T'               \ Encoded as:   "MIT<156>LM "
 TWOK 'T', 'E'
 CHAR 'L'
 CHAR 'M'
 CHAR ' '
 EQUB 0

 RTOK 138               \ Token 12:     "ARME "
 CHAR 'E'               \
 CHAR ' '               \ Encoded as:   "[138]E "
 EQUB 0

 CHAR 'H'               \ Token 13:     "HAUPTS "
 CHAR 'A'               \
 CHAR 'U'               \ Encoded as:   "HAUPTS "
 CHAR 'P'
 CHAR 'T'
 CHAR 'S'
 CHAR ' '
 EQUB 0

 CHAR 'E'               \ Token 14:     "EINHEIT"
 TWOK 'I', 'N'          \
 CHAR 'H'               \ Encoded as:   "E<140>HEIT"
 CHAR 'E'
 CHAR 'I'
 CHAR 'T'
 EQUB 0

 TWOK 'A', 'N'          \ Token 15:     "ANSICHT"
 CHAR 'S'               \
 CHAR 'I'               \ Encoded as:   "<155>SICHT"
 CHAR 'C'
 CHAR 'H'
 CHAR 'T'
 EQUB 0

 RTOK 44                \ Token 16:     "MENGE SEHEN "
 CHAR ' '               \
 CHAR 'S'               \ Encoded as:   "[44] SEH<146> "
 CHAR 'E'
 CHAR 'H'
 TWOK 'E', 'N'
 CHAR ' '
 EQUB 0

 TWOK 'A', 'N'          \ Token 17:     "ANARCHIE"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "<155><138>CHIE"
 CHAR 'H'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR 'F'               \ Token 18:     "FEUDALSTAAT"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "FEUDAL[43]A<145>"
 CHAR 'D'
 CHAR 'A'
 CHAR 'L'
 RTOK 43
 CHAR 'A'
 TWOK 'A', 'T'
 EQUB 0

 CHAR 'M'               \ Token 19:     "MEHRFACHREGIERUNG"
 CHAR 'E'               \
 CHAR 'H'               \ Encoded as:   "MEHRFACH[2]"
 CHAR 'R'
 CHAR 'F'
 CHAR 'A'
 CHAR 'C'
 CHAR 'H'
 RTOK 2
 EQUB 0

 TWOK 'D', 'I'          \ Token 20:     "DIKTATUR"
 CHAR 'K'               \
 CHAR 'T'               \ Encoded as:   "<141>KT<145>UR"
 TWOK 'A', 'T'
 CHAR 'U'
 CHAR 'R'
 EQUB 0

 CHAR 'K'               \ Token 21:     "KOMMUNISTEN"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "KOMMUN<157>T<146>"
 CHAR 'M'
 CHAR 'U'
 CHAR 'N'
 TWOK 'I', 'S'
 CHAR 'T'
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'K'               \ Token 22:     "KONFÖDERATION"
 TWOK 'O', 'N'          \
 CHAR 'F'               \ Encoded as:   "K<159>F\D<144><145>I<159>"
 CHAR '\'
 CHAR 'D'
 TWOK 'E', 'R'
 TWOK 'A', 'T'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 CHAR 'D'               \ Token 23:     "DEMOKRATIE"
 CHAR 'E'               \
 CHAR 'M'               \ Encoded as:   "DEMOKR<145>IE"
 CHAR 'O'
 CHAR 'K'
 CHAR 'R'
 TWOK 'A', 'T'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR 'K'               \ Token 24:     "KORPORATIVSTAAT"
 TWOK 'O', 'R'          \
 CHAR 'P'               \ Encoded as:   "K<153>P<153><145>IV[43]A<145>"
 TWOK 'O', 'R'
 TWOK 'A', 'T'
 CHAR 'I'
 CHAR 'V'
 RTOK 43
 CHAR 'A'
 TWOK 'A', 'T'
 EQUB 0

 CHAR 'S'               \ Token 25:     "SCHIFF"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "SCHIFF"
 CHAR 'I'
 CHAR 'F'
 CHAR 'F'
 EQUB 0

 CHAR 'P'               \ Token 26:     "PRODUKT"
 RTOK 94                \
 CHAR 'D'               \ Encoded as:   "P[94]DUKT"
 CHAR 'U'
 CHAR 'K'
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 27:     " LASER"
 TWOK 'L', 'A'          \
 CHAR 'S'               \ Encoded as:   " <149>S<144>"
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'M'               \ Token 28:     "MENSCHL. KOLONIST"
 TWOK 'E', 'N'          \
 CHAR 'S'               \ Encoded as:   "M<146>SCHL. KOL<159><157>T"
 CHAR 'C'
 CHAR 'H'
 CHAR 'L'
 CHAR '.'
 CHAR ' '
 CHAR 'K'
 CHAR 'O'
 CHAR 'L'
 TWOK 'O', 'N'
 TWOK 'I', 'S'
 CHAR 'T'
 EQUB 0

 CHAR 'H'               \ Token 29:     "HYPERRAUM "
 CHAR 'Y'               \
 CHAR 'P'               \ Encoded as:   "HYP<144><148>UM "
 TWOK 'E', 'R'
 TWOK 'R', 'A'
 CHAR 'U'
 CHAR 'M'
 CHAR ' '
 EQUB 0

 CHAR '\'               \ Token 30:     "ÖRTLICHE KARTE"
 CHAR 'R'               \
 CHAR 'T'               \ Encoded as:   "\RTLICHE[1]"
 CHAR 'L'
 CHAR 'I'
 CHAR 'C'
 CHAR 'H'
 CHAR 'E'
 RTOK 1
 EQUB 0

 TWOK 'E', 'N'          \ Token 31:     "ENTFERNUNG"
 CHAR 'T'               \
 CHAR 'F'               \ Encoded as:   "<146>TF<144>NUNG"
 TWOK 'E', 'R'
 CHAR 'N'
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 EQUB 0

 TWOK 'B', 'E'          \ Token 32:     "BEVÖLKERUNG"
 CHAR 'V'               \
 CHAR '\'               \ Encoded as:   "<147>V\LK<144>UNG"
 CHAR 'L'
 CHAR 'K'
 TWOK 'E', 'R'
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 EQUB 0

 CHAR 'U'               \ Token 33:     "UMSATZ"
 CHAR 'M'               \
 CHAR 'S'               \ Encoded as:   "UMS<145>Z"
 TWOK 'A', 'T'
 CHAR 'Z'
 EQUB 0

 CHAR 'W'               \ Token 34:     "WIRTSCHAFT"
 CHAR 'I'               \
 CHAR 'R'               \ Encoded as:   "WIRTSCHAFT"
 CHAR 'T'
 CHAR 'S'
 CHAR 'C'
 CHAR 'H'
 CHAR 'A'
 CHAR 'F'
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 35:     " LICHTJ"
 CHAR 'L'               \
 CHAR 'I'               \ Encoded as:   " LICHTJ"
 CHAR 'C'
 CHAR 'H'
 CHAR 'T'
 CHAR 'J'
 EQUB 0

 TWOK 'T', 'E'          \ Token 36:     "TECH.NIVEAU"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<156>CH.NI<150>AU"
 CHAR '.'
 CHAR 'N'
 CHAR 'I'
 TWOK 'V', 'E'
 CHAR 'A'
 CHAR 'U'
 EQUB 0

 CHAR 'B'               \ Token 37:     "BARGELD"
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "B<138><131>LD"
 CHAR 'L'
 CHAR 'D'
 EQUB 0

 CHAR ' '               \ Token 38:     " BILL."
 TWOK 'B', 'I'          \
 CHAR 'L'               \ Encoded as:   " <134>LL."
 CHAR 'L'
 CHAR '.'
 EQUB 0

 RTOK 122               \ Token 39:     "GALAKTISCHE KARTE{galaxy number}"
 CHAR 'E'               \
 RTOK 1                 \ Encoded as:   "[122]E[1]{1}"
 CONT 1
 EQUB 0

 CHAR 'Z'               \ Token 40:     "ZIEL VERLOREN "
 CHAR 'I'               \
 CHAR 'E'               \ Encoded as:   "ZIEL V<144>LO<142>N "
 CHAR 'L'
 CHAR ' '
 CHAR 'V'
 TWOK 'E', 'R'
 CHAR 'L'
 CHAR 'O'
 TWOK 'R', 'E'
 CHAR 'N'
 CHAR ' '
 EQUB 0

 RTOK 106               \ Token 41:     "RAKETE KLEMMT "
 CHAR ' '               \
 CHAR 'K'               \ Encoded as:   "[106] K<129>MMT "
 TWOK 'L', 'E'
 CHAR 'M'
 CHAR 'M'
 CHAR 'T'
 CHAR ' '
 EQUB 0

 RTOK 31                \ Token 42:     "ENTFERNUNG"
 EQUB 0                 \
                        \ Encoded as:   "[31]"

 CHAR 'S'               \ Token 43:     "ST"
 CHAR 'T'               \
 EQUB 0                 \ Encoded as:   "ST"

 CHAR 'M'               \ Token 44:     "MENGE"
 TWOK 'E', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "M<146><131>"
 EQUB 0

 CHAR 'V'               \ Token 45:     "VERKAUFEN À"
 TWOK 'E', 'R'          \
 CHAR 'K'               \ Encoded as:   "V<144>KAUF<146> ""
 CHAR 'A'
 CHAR 'U'
 CHAR 'F'
 TWOK 'E', 'N'
 CHAR ' '
 CHAR '"'
 EQUB 0

 CHAR 'K'               \ Token 46:     "KARGO{sentence case}"
 TWOK 'A', 'R'          \
 CHAR 'G'               \ Encoded as:   "K<138>GO{6}"
 CHAR 'O'
 CONT 6
 EQUB 0

 RTOK 25                \ Token 47:     "SCHIFF AUSRÜSTEN"
 CHAR ' '               \
 CHAR 'A'               \ Encoded as:   "[25] A<136>R][43]<146>"
 TWOK 'U', 'S'
 CHAR 'R'
 CHAR ']'
 RTOK 43
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'N'               \ Token 48:     "NAHRUNG"
 CHAR 'A'               \
 CHAR 'H'               \ Encoded as:   "NAHRUNG"
 CHAR 'R'
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 EQUB 0

 TWOK 'T', 'E'          \ Token 49:     "TEXTILIEN"
 CHAR 'X'               \
 TWOK 'T', 'I'          \ Encoded as:   "<156>X<151>LI<146>"
 CHAR 'L'
 CHAR 'I'
 TWOK 'E', 'N'
 EQUB 0

 TWOK 'R', 'A'          \ Token 50:     "RADIOAKTIVES"
 TWOK 'D', 'I'          \
 CHAR 'O'               \ Encoded as:   "<148><141>OAK<151>V<137>"
 CHAR 'A'
 CHAR 'K'
 TWOK 'T', 'I'
 CHAR 'V'
 TWOK 'E', 'S'
 EQUB 0

 RTOK 94                \ Token 51:     "ROBOTSKLAVEN"
 CHAR 'B'               \
 CHAR 'O'               \ Encoded as:   "[94]BOTSK<149>V<146>"
 CHAR 'T'
 CHAR 'S'
 CHAR 'K'
 TWOK 'L', 'A'
 CHAR 'V'
 TWOK 'E', 'N'
 EQUB 0

 TWOK 'G', 'E'          \ Token 52:     "GETRÄNKE"
 CHAR 'T'               \
 CHAR 'R'               \ Encoded as:   "<131>TR[NKE"
 CHAR '['
 CHAR 'N'
 CHAR 'K'
 CHAR 'E'
 EQUB 0

 CHAR 'L'               \ Token 53:     "LUXUSGÜTER"
 CHAR 'U'               \
 CHAR 'X'               \ Encoded as:   "LUX<136>G]T<144>"
 TWOK 'U', 'S'
 CHAR 'G'
 CHAR ']'
 CHAR 'T'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'S'               \ Token 54:     "SELTENES"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "SELT<146><137>"
 CHAR 'T'
 TWOK 'E', 'N'
 TWOK 'E', 'S'
 EQUB 0

 RTOK 91                \ Token 55:     "COMPUTER"
 CHAR 'P'               \
 CHAR 'U'               \ Encoded as:   "[91]PUT<144>"
 CHAR 'T'
 TWOK 'E', 'R'
 EQUB 0

 TWOK 'M', 'A'          \ Token 56:     "MASCHINEN"
 CHAR 'S'               \
 CHAR 'C'               \ Encoded as:   "<139>SCH<140><146>"
 CHAR 'H'
 TWOK 'I', 'N'
 TWOK 'E', 'N'
 EQUB 0

 TWOK 'L', 'E'          \ Token 57:     "LEGIERUNGEN"
 CHAR 'G'               \
 CHAR 'I'               \ Encoded as:   "<129>GI<144>UN<131>N"
 TWOK 'E', 'R'
 CHAR 'U'
 CHAR 'N'
 TWOK 'G', 'E'
 CHAR 'N'
 EQUB 0

 CHAR 'F'               \ Token 58:     "FEUERWAFFEN"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "FEU<144>WAFF<146>"
 TWOK 'E', 'R'
 CHAR 'W'
 CHAR 'A'
 CHAR 'F'
 CHAR 'F'
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'P'               \ Token 59:     "PELZE"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "PELZE"
 CHAR 'Z'
 CHAR 'E'
 EQUB 0

 CHAR 'M'               \ Token 60:     "MINERALIEN"
 TWOK 'I', 'N'          \
 TWOK 'E', 'R'          \ Encoded as:   "M<140><144>ALI<146>"
 CHAR 'A'
 CHAR 'L'
 CHAR 'I'
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'G'               \ Token 61:     "GOLD"
 CHAR 'O'               \
 CHAR 'L'               \ Encoded as:   "GOLD"
 CHAR 'D'
 EQUB 0

 CHAR 'P'               \ Token 62:     "PLATIN"
 CHAR 'L'               \
 TWOK 'A', 'T'          \ Encoded as:   "PL<145><140>"
 TWOK 'I', 'N'
 EQUB 0

 TWOK 'E', 'D'          \ Token 63:     "EDELSTEINE"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "<152>ELS<156><140>E"
 CHAR 'S'
 TWOK 'T', 'E'
 TWOK 'I', 'N'
 CHAR 'E'
 EQUB 0

 CHAR 'F'               \ Token 64:     "FREMDWAREN"
 TWOK 'R', 'E'          \
 CHAR 'M'               \ Encoded as:   "F<142>MDW<138><146>"
 CHAR 'D'
 CHAR 'W'
 TWOK 'A', 'R'
 TWOK 'E', 'N'
 EQUB 0

 EQUB 0                 \ Token 65:     ""
                        \
                        \ Encoded as:   ""

 CHAR ' '               \ Token 66:     " CR"
 CHAR 'C'               \
 CHAR 'R'               \ Encoded as:   " CR"
 EQUB 0

 CHAR 'G'               \ Token 67:     "GROßE"
 RTOK 94                \
 CHAR '^'               \ Encoded as:   "G[94]^E"
 CHAR 'E'
 EQUB 0

 RTOK 142               \ Token 68:     "GEFÄHRLICHE"
 CHAR 'E'               \
 EQUB 0                 \ Encoded as:   "[142]E"

 CHAR 'K'               \ Token 69:     "KLEINE"
 TWOK 'L', 'E'          \
 TWOK 'I', 'N'          \ Encoded as:   "K<129><140>E"
 CHAR 'E'
 EQUB 0

 CHAR 'G'               \ Token 70:     "GRÜNE"
 CHAR 'R'               \
 CHAR ']'               \ Encoded as:   "GR]NE"
 CHAR 'N'
 CHAR 'E'
 EQUB 0

 RTOK 94                \ Token 71:     "ROTE"
 TWOK 'T', 'E'          \
 EQUB 0                 \ Encoded as:   "[94]<156>"

 TWOK 'G', 'E'          \ Token 72:     "GELBE"
 CHAR 'L'               \
 TWOK 'B', 'E'          \ Encoded as:   "<131>L<147>"
 EQUB 0

 CHAR 'B'               \ Token 73:     "BLAUE"
 TWOK 'L', 'A'          \
 CHAR 'U'               \ Encoded as:   "B<149>UE"
 CHAR 'E'
 EQUB 0

 CHAR 'S'               \ Token 74:     "SCHWARZE"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "SCHW<138>ZE"
 CHAR 'W'
 TWOK 'A', 'R'
 CHAR 'Z'
 CHAR 'E'
 EQUB 0

 RTOK 136               \ Token 75:     "HARMLOSE"
 CHAR 'E'               \
 EQUB 0                 \ Encoded as:   "[136]E"

 CHAR 'G'               \ Token 76:     "GLITSCHIGE"
 CHAR 'L'               \
 CHAR 'I'               \ Encoded as:   "GLITSCHI<131>"
 CHAR 'T'
 CHAR 'S'
 CHAR 'C'
 CHAR 'H'
 CHAR 'I'
 TWOK 'G', 'E'
 EQUB 0

 CHAR 'W'               \ Token 77:     "WANZENÄUGIGE"
 TWOK 'A', 'N'          \
 CHAR 'Z'               \ Encoded as:   "W<155>Z<146>[UGI<131>"
 TWOK 'E', 'N'
 CHAR '['
 CHAR 'U'
 CHAR 'G'
 CHAR 'I'
 TWOK 'G', 'E'
 EQUB 0

 TWOK 'G', 'E'          \ Token 78:     "GEHÖRNTE"
 CHAR 'H'               \
 CHAR '\'               \ Encoded as:   "<131>H\RN<156>"
 CHAR 'R'
 CHAR 'N'
 TWOK 'T', 'E'
 EQUB 0

 CHAR 'K'               \ Token 79:     "KNOCHIGE"
 CHAR 'N'               \
 CHAR 'O'               \ Encoded as:   "KNOCHI<131>"
 CHAR 'C'
 CHAR 'H'
 CHAR 'I'
 TWOK 'G', 'E'
 EQUB 0

 TWOK 'D', 'I'          \ Token 80:     "DICKE"
 CHAR 'C'               \
 CHAR 'K'               \ Encoded as:   "<141>CKE"
 CHAR 'E'
 EQUB 0

 CHAR 'P'               \ Token 81:     "PELZIGE"
 CHAR 'E'               \
 CHAR 'L'               \ Encoded as:   "PELZI<131>"
 CHAR 'Z'
 CHAR 'I'
 TWOK 'G', 'E'
 EQUB 0

 CONT 6                 \ Token 82:     "{sentence case}NAGETIERE"
 CHAR 'N'               \
 CHAR 'A'               \ Encoded as:   "{6}NA<131><151>E<142>"
 TWOK 'G', 'E'
 TWOK 'T', 'I'
 CHAR 'E'
 TWOK 'R', 'E'
 EQUB 0

 CONT 6                 \ Token 83:     "{sentence case}FRÖSCHE"
 CHAR 'F'               \
 CHAR 'R'               \ Encoded as:   "{6}FR\SCHE)
 CHAR '\'
 CHAR 'S'
 CHAR 'C'
 CHAR 'H'
 CHAR 'E'
 EQUB 0

 CONT 6                 \ Token 84:     "{sentence case}ECHSEN"
 CHAR 'E'               \
 CHAR 'C'               \ Encoded as:   "{6}ECHS<146>)
 CHAR 'H'
 CHAR 'S'
 TWOK 'E', 'N'
 EQUB 0

 CONT 6                 \ Token 85:     "{sentence case}HUMMER"
 CHAR 'H'               \
 CHAR 'U'               \ Encoded as:   "{6}HUMM<144>"
 CHAR 'M'
 CHAR 'M'
 TWOK 'E', 'R'
 EQUB 0

 CONT 6                 \ Token 86:     "{sentence case}VÖGEL"
 CHAR 'V'               \
 CHAR '\'               \ Encoded as:   "{6}V\<131>L"
 TWOK 'G', 'E'
 CHAR 'L'
 EQUB 0

 CONT 6                 \ Token 87:     "{sentence case}HUMANOIDS"
 CHAR 'H'               \
 CHAR 'U'               \ Encoded as:   "{6}HU<139>NOIDS"
 TWOK 'M', 'A'
 CHAR 'N'
 CHAR 'O'
 CHAR 'I'
 CHAR 'D'
 CHAR 'S'
 EQUB 0

 CONT 6                 \ Token 88:     "{sentence case}KATZEN"
 CHAR 'K'               \
 TWOK 'A', 'T'          \ Encoded as:   "{6}K<145>Z<146>"
 CHAR 'Z'
 TWOK 'E', 'N'
 EQUB 0

 CONT 6                 \ Token 89:     "{sentence case}INSEKTEN"
 TWOK 'I', 'N'          \
 CHAR 'S'               \ Encoded as:   "{6}<140>SEKT<146>"
 CHAR 'E'
 CHAR 'K'
 CHAR 'T'
 TWOK 'E', 'N'
 EQUB 0

 TWOK 'R', 'A'          \ Token 90:     "RADIUS"
 TWOK 'D', 'I'          \
 TWOK 'U', 'S'          \ Encoded as:   "<148><141><136>"
 EQUB 0

 CHAR 'C'               \ Token 91:     "COM"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "COM"
 EQUB 0

 CHAR 'K'               \ Token 92:     "KOMMANDANT"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "KOM<139>ND<155>T"
 TWOK 'M', 'A'
 CHAR 'N'
 CHAR 'D'
 TWOK 'A', 'N'
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 93:     " VERNICHTET"
 CHAR 'V'               \
 TWOK 'E', 'R'          \ Encoded as:   " V<144>NICH<156>T"
 CHAR 'N'
 CHAR 'I'
 CHAR 'C'
 CHAR 'H'
 TWOK 'T', 'E'
 CHAR 'T'
 EQUB 0

 CHAR 'R'               \ Token 94:     "RO"
 CHAR 'O'               \
 EQUB 0                 \ Encoded as:   "RO"

 RTOK 26                \ Token 95:     "PRODUKT        PREIS-
 CHAR ' '               \                  MENGE                 EINHEIT"
 CHAR ' '               \
 CHAR ' '               \ Encoded as:   "[26]        P<142><157>-  [44]
 CHAR ' '               \                                 [14]"
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR 'P'
 TWOK 'R', 'E'
 TWOK 'I', 'S'
 CHAR '-'
 CHAR ' '
 CHAR ' '
 RTOK 44
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR ' '
 RTOK 14
 EQUB 0

 CHAR 'V'               \ Token 96:     "VORN"
 TWOK 'O', 'R'          \
 CHAR 'N'               \ Encoded as:   "V<153>N"
 EQUB 0

 CHAR 'H'               \ Token 97:     "HINTEN"
 TWOK 'I', 'N'          \
 CHAR 'T'               \ Encoded as:   "H<140>T<146>"
 TWOK 'E', 'N'
 EQUB 0

 CHAR 'L'               \ Token 98:     "LINKS"
 TWOK 'I', 'N'          \
 CHAR 'K'               \ Encoded as:   "L<140>KS"
 CHAR 'S'
 EQUB 0

 TWOK 'R', 'E'          \ Token 99:     "RECHTS"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<142>CHTS"
 CHAR 'T'
 CHAR 'S'
 EQUB 0

 RTOK 121               \ Token 100:    "ENERGIE NIEDRIG {beep}"
 CHAR 'N'               \
 CHAR 'I'               \ Encoded as:   "[121]NI<152><158>G {7}"
 TWOK 'E', 'D'
 TWOK 'R', 'I'
 CHAR 'G'
 CHAR ' '
 CONT 7
 EQUB 0

 CHAR 'B'               \ Token 101:    "BRAVO KOMMANDANT!"
 TWOK 'R', 'A'          \
 CHAR 'V'               \ Encoded as:   "B<148>VO [92]!"
 CHAR 'O'
 CHAR ' '
 RTOK 92
 CHAR '!'
 EQUB 0

 CHAR 'E'               \ Token 102:    "EXTRA "
 CHAR 'X'               \
 CHAR 'T'               \ Encoded as:   "EXT<148> "
 TWOK 'R', 'A'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 103:    "PULSLASER"
 CHAR 'U'               \
 CHAR 'L'               \ Encoded as:   "PULS<149>S<144>"
 CHAR 'S'
 TWOK 'L', 'A'
 CHAR 'S'
 TWOK 'E', 'R'
 EQUB 0

 RTOK 43                \ Token 104:    "STRAHLENLASER"
 TWOK 'R', 'A'          \
 CHAR 'H'               \ Encoded as:   "[43]<148>H<129>N<149>S<144>"
 TWOK 'L', 'E'
 CHAR 'N'
 TWOK 'L', 'A'
 CHAR 'S'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'T'               \ Token 105:    "TREIBSTOFF"
 TWOK 'R', 'E'          \
 CHAR 'I'               \ Encoded as:   "T<142>IB[43]OFF"
 CHAR 'B'
 RTOK 43
 CHAR 'O'
 CHAR 'F'
 CHAR 'F'
 EQUB 0

 TWOK 'R', 'A'          \ Token 106:    "RAKETE"
 CHAR 'K'               \
 CHAR 'E'               \ Encoded as:   "<148>KE<156>"
 TWOK 'T', 'E'
 EQUB 0

 CHAR 'G'               \ Token 107:    "GROßER KARGORAUM"
 RTOK 94                \
 CHAR '^'               \ Encoded as:   "G[94]^<144> K<138>GO<148>UM"
 TWOK 'E', 'R'
 CHAR ' '
 CHAR 'K'
 TWOK 'A', 'R'
 CHAR 'G'
 CHAR 'O'
 TWOK 'R', 'A'
 CHAR 'U'
 CHAR 'M'
 EQUB 0

 CHAR 'E'               \ Token 108:    "E.C.M.SYSTEM"
 CHAR '.'               \
 CHAR 'C'               \ Encoded as:   "E.C.M.SYS<156>M"
 CHAR '.'
 CHAR 'M'
 CHAR '.'
 CHAR 'S'
 CHAR 'Y'
 CHAR 'S'
 TWOK 'T', 'E'
 CHAR 'M'
 EQUB 0

 RTOK 102               \ Token 109:    "EXTRA PULSLASER"
 RTOK 103               \
 EQUB 0                 \ Encoded as:   "[102][103]"

 RTOK 102               \ Token 110:    "EXTRA STRAHLENLASER"
 RTOK 104               \
 EQUB 0                 \ Encoded as:   "[102][104]"

 RTOK 105               \ Token 111:    "TREIBSTOFFSCHAUFELN"
 CHAR 'S'               \
 CHAR 'C'               \ Encoded as:   "[105]SCHAUFELN"
 CHAR 'H'
 CHAR 'A'
 CHAR 'U'
 CHAR 'F'
 CHAR 'E'
 CHAR 'L'
 CHAR 'N'
 EQUB 0

 CHAR 'F'               \ Token 112:    "FLUCHTKAPSEL"
 CHAR 'L'               \
 CHAR 'U'               \ Encoded as:   "FLUCHTKAPSEL"
 CHAR 'C'
 CHAR 'H'
 CHAR 'T'
 CHAR 'K'
 CHAR 'A'
 CHAR 'P'
 CHAR 'S'
 CHAR 'E'
 CHAR 'L'
 EQUB 0

 TWOK 'E', 'N'          \ Token 113:    "ENERGIEBOMBE"
 TWOK 'E', 'R'          \
 CHAR 'G'               \ Encoded as:   "<146><144>GIEBOM<147>"
 CHAR 'I'
 CHAR 'E'
 CHAR 'B'
 CHAR 'O'
 CHAR 'M'
 TWOK 'B', 'E'
 EQUB 0

 TWOK 'E', 'N'          \ Token 114:    "ENERGIE-EINHEIT"
 TWOK 'E', 'R'          \
 CHAR 'G'               \ Encoded as:   "<146><144>GIE-[14]"
 CHAR 'I'
 CHAR 'E'
 CHAR '-'
 RTOK 14
 EQUB 0

 CHAR 'D'               \ Token 115:    "DOCK COMPUTER"
 CHAR 'O'               \
 CHAR 'C'               \ Encoded as:   "DOCK [55]"
 CHAR 'K'
 CHAR ' '
 RTOK 55
 EQUB 0

 CHAR 'G'               \ Token 116:    "GALAKT. HYPERRAUM"
 CHAR 'A'               \
 TWOK 'L', 'A'          \ Encoded as:   "GA<149>KT. HYP<144><148>UM"
 CHAR 'K'
 CHAR 'T'
 CHAR '.'
 CHAR ' '
 CHAR 'H'
 CHAR 'Y'
 CHAR 'P'
 TWOK 'E', 'R'
 TWOK 'R', 'A'
 CHAR 'U'
 CHAR 'M'
 EQUB 0

 CHAR 'M'               \ Token 117:    "MILIT. LASER"
 CHAR 'I'               \
 CHAR 'L'               \ Encoded as:   "MILIT.[27]"
 CHAR 'I'
 CHAR 'T'
 CHAR '.'
 RTOK 27
 EQUB 0

 CHAR 'G'               \ Token 118:    "GRUBENLASER "
 CHAR 'R'               \
 CHAR 'U'               \ Encoded as:   "GRUB<146><149>S<144> "
 CHAR 'B'
 TWOK 'E', 'N'
 TWOK 'L', 'A'
 CHAR 'S'
 TWOK 'E', 'R'
 CHAR ' '
 EQUB 0

 CONT 6                 \ Token 119:    "{sentence case}BARGELD:{cash} CR{cr}
 RTOK 37                \               "
 CHAR ':'               \
 CONT 0                 \ Encoded as:   "{6}[37]:{0}"
 EQUB 0

 TWOK 'A', 'N'          \ Token 120:    "ANKOMMENDE RAKETE"
 CHAR 'K'               \
 CHAR 'O'               \ Encoded as:   "<155>KOMM<146>DE [106]"
 CHAR 'M'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 RTOK 106
 EQUB 0

 TWOK 'E', 'N'          \ Token 121:    "ENERGIE "
 TWOK 'E', 'R'          \
 CHAR 'G'               \ Encoded as:   "<146><144>GIE "
 CHAR 'I'
 CHAR 'E'
 CHAR ' '
 EQUB 0

 CHAR 'G'               \ Token 122:    "GALAKTISCH"
 CHAR 'A'               \
 TWOK 'L', 'A'          \ Encoded as:   "GA<149>K<151>SCH"
 CHAR 'K'
 TWOK 'T', 'I'
 CHAR 'S'
 CHAR 'C'
 CHAR 'H'
 EQUB 0

 RTOK 115               \ Token 123:    "DOCK COMPUTER AN"
 CHAR ' '               \
 TWOK 'A', 'N'          \ Encoded as:   "[115] <155>"
 EQUB 0

 CHAR 'A'               \ Token 124:    "ALLE"
 CHAR 'L'               \
 TWOK 'L', 'E'          \ Encoded as:   "AL<129>"
 EQUB 0

 TWOK 'L', 'E'          \ Token 125:    "LEGALSTATUS:"
 CHAR 'G'               \
 CHAR 'A'               \ Encoded as:   "<129>GAL[43]<145><136>:"
 CHAR 'L'
 RTOK 43
 TWOK 'A', 'T'
 TWOK 'U', 'S'
 CHAR ':'
 EQUB 0

 RTOK 92                \ Token 126:    "KOMMANDANT {commander name}{cr}
 CHAR ' '               \                {cr}
 CONT 4                 \                {cr}
 CONT 12                \                {sentence case}{sentence case}
 CONT 12                \                GEGENWÄRTIGES {sentence case}SYSTEM{tab
 CONT 12                \                to column 23}:{current system name}{cr}
 CONT 6                 \                {sentence case}HYPERRAUMSYSTEM{tab to
 CONT 6                 \                column 23}:{selected system name}{cr}
 TWOK 'G', 'E'          \                ZUSTAND{tab to column 23}:"
 TWOK 'G', 'E'          \
 CHAR 'N'               \ Encoded as:   "[92] {4}{12}{12}{12}{6}{6}<131><131>NW[
 CHAR 'W'               \                R<151><131>S [5]{9}{2}{12}{6}HYP<144>
 CHAR '['               \                <148>UMSYS<156>M{9}{3}{12}Z<136>T<155>D
 CHAR 'R'               \                {9}"
 TWOK 'T', 'I'
 TWOK 'G', 'E'
 CHAR 'S'
 CHAR ' '
 RTOK 5
 CONT 9
 CONT 2
 CONT 12
 CONT 6
 CHAR 'H'
 CHAR 'Y'
 CHAR 'P'
 TWOK 'E', 'R'
 TWOK 'R', 'A'
 CHAR 'U'
 CHAR 'M'
 CHAR 'S'
 CHAR 'Y'
 CHAR 'S'
 TWOK 'T', 'E'
 CHAR 'M'
 CONT 9
 CONT 3
 CONT 12
 CHAR 'Z'
 TWOK 'U', 'S'
 CHAR 'T'
 TWOK 'A', 'N'
 CHAR 'D'
 CONT 9
 EQUB 0

 CHAR 'W'               \ Token 127:    "WARE"
 TWOK 'A', 'R'          \
 CHAR 'E'               \ Encoded as:   "W<138>E
 EQUB 0

 EQUB 0                 \ Token 128:    ""
                        \
                        \ Encoded as:   ""

 CHAR 'I'               \ Token 129:    "IE"
 CHAR 'E'               \
 EQUB 0                 \ Encoded as:   "IE"

 CHAR 'W'               \ Token 130:    "WERTUNG"
 TWOK 'E', 'R'          \
 CHAR 'T'               \ Encoded as:   "W<144>TUNG"
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 EQUB 0

 CHAR ' '               \ Token 131:    " AN "
 TWOK 'A', 'N'          \
 CHAR ' '               \ Encoded as:   " <155> "
 EQUB 0

 CONT 12                \ Token 132:    "{cr}{all caps}{sentence case}
 CONT 8                 \                AUSRÜSTUNG:{sentence case}
 CONT 6                 \
 CHAR 'A'               \ Encoded as:   "{12}{8}{6}A<136>R][43]UNG:{6}"
 TWOK 'U', 'S'
 CHAR 'R'
 CHAR ']'
 RTOK 43
 CHAR 'U'
 CHAR 'N'
 CHAR 'G'
 CHAR ':'
 CONT 6
 EQUB 0

 CHAR 'S'               \ Token 133:    "SAUBER"
 CHAR 'A'               \
 CHAR 'U'               \ Encoded as:   "SAUB<144>"
 CHAR 'B'
 TWOK 'E', 'R'
 EQUB 0

 RTOK 43                \ Token 134:    "STRAFTÄTER"
 TWOK 'R', 'A'          \
 CHAR 'F'               \ Encoded as:   "[43]<148>FT[T<144>"
 CHAR 'T'
 CHAR '['
 CHAR 'T'
 TWOK 'E', 'R'
 EQUB 0

 CHAR 'F'               \ Token 135:    "FLÜCHTLING"
 CHAR 'L'               \
 CHAR ']'               \ Encoded as:   "FL]CHTL<140>G"
 CHAR 'C'
 CHAR 'H'
 CHAR 'T'
 CHAR 'L'
 TWOK 'I', 'N'
 CHAR 'G'
 EQUB 0

 CHAR 'H'               \ Token 136:    "HARMLOS"
 RTOK 138               \
 CHAR 'L'               \ Encoded as:   "H[138]LOS"
 CHAR 'O'
 CHAR 'S'
 EQUB 0

 CHAR ']'               \ Token 137:    "ÜBERWIEGEND HARMLOS"
 CHAR 'B'               \
 TWOK 'E', 'R'          \ Encoded as:   "]B<144>WIE<131>ND [136]"
 CHAR 'W'
 CHAR 'I'
 CHAR 'E'
 TWOK 'G', 'E'
 CHAR 'N'
 CHAR 'D'
 CHAR ' '
 RTOK 136
 EQUB 0

 TWOK 'A', 'R'          \ Token 138:    "ARM"
 CHAR 'M'               \
 EQUB 0                 \ Encoded as:   "<138>M"

 CHAR 'D'               \ Token 139:    "DURCHSCHNITTLICH"
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "DURCHSCHNITTLICH"
 CHAR 'C'
 CHAR 'H'
 CHAR 'S'
 CHAR 'C'
 CHAR 'H'
 CHAR 'N'
 CHAR 'I'
 CHAR 'T'
 CHAR 'T'
 CHAR 'L'
 CHAR 'I'
 CHAR 'C'
 CHAR 'H'
 EQUB 0

 CHAR ']'               \ Token 140:    "ÜBERDURCHSCHNITTLICH "
 CHAR 'B'               \
 TWOK 'E', 'R'          \ Encoded as:   "]B<144>[139] "
 RTOK 139
 CHAR ' '
 EQUB 0

 CHAR 'K'               \ Token 141:    "KOMPETENT"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "KOMPET<146>T"
 CHAR 'P'
 CHAR 'E'
 CHAR 'T'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 TWOK 'G', 'E'          \ Token 142:    "GEFÄHRLICH"
 CHAR 'F'               \
 CHAR '['               \ Encoded as:   "<131>F[HRLICH"
 CHAR 'H'
 CHAR 'R'
 CHAR 'L'
 CHAR 'I'
 CHAR 'C'
 CHAR 'H'
 EQUB 0

 CHAR 'T'               \ Token 143:    "TÖDLICH"
 CHAR '\'               \
 CHAR 'D'               \ Encoded as:   "T\DLICH"
 CHAR 'L'
 CHAR 'I'
 CHAR 'C'
 CHAR 'H'
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

 TWOK 'A', 'N'          \ Token 145:    "ANWESEND"
 CHAR 'W'               \
 TWOK 'E', 'S'          \ Encoded as:   "<155>W<137><146>D"
 TWOK 'E', 'N'
 CHAR 'D'
 EQUB 0

 CONT 8                 \ Token 146:    "{all caps}SPIEL ZU ENDE"
 CHAR 'S'               \
 CHAR 'P'               \ Encoded as:   "{8}SPIEL ZU <146>DE"
 CHAR 'I'
 CHAR 'E'
 CHAR 'L'
 CHAR ' '
 CHAR 'Z'
 CHAR 'U'
 CHAR ' '
 TWOK 'E', 'N'
 CHAR 'D'
 CHAR 'E'
 EQUB 0

 CHAR '6'               \ Token 147:    "60 STRAFSEKUNDEN"
 CHAR '0'               \
 CHAR ' '               \ Encoded as:   "60 [43]<148>FSEKUND<146>"
 RTOK 43
 TWOK 'R', 'A'
 CHAR 'F'
 CHAR 'S'
 CHAR 'E'
 CHAR 'K'
 CHAR 'U'
 CHAR 'N'
 CHAR 'D'
 TWOK 'E', 'N'
 EQUB 0

 EQUB 0                 \ Token 148:    ""
                        \
                        \ Encoded as:   ""

