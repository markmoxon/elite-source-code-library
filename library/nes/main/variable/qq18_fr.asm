\ ******************************************************************************
\
\       Name: QQ18_FR
\       Type: Variable
\   Category: Text
\    Summary: The recursive token table for tokens 0-148 (French)
\  Deep dive: Printing text tokens
\             Multi-language support in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ The encodings shown for each recursive text token use the following notation:
\
\   {n}           Control code              n = 0 to 13
\   <n>           Two-letter token          n = 128 to 159
\   [n]           Recursive token           n = 0 to 148
\
\ ******************************************************************************

.QQ18_FR

 RTOK 105               \ Token 0:      "LE FUEL {beep}"
 CHAR ' '               \
 CONT 7                 \ Encoded as:   "[105] {7}"
 EQUB 0

 CHAR ' '               \ Token 1:      " CARTE"
 CHAR 'C'               \
 TWOK 'A', 'R'          \ Encoded as:   " C<138><156>"
 TWOK 'T', 'E'
 EQUB 0

 CHAR 'G'               \ Token 2:      "GOUVERNEMENT"
 CHAR 'O'               \
 CHAR 'U'               \ Encoded as:   "GOUV<144>NEM<146>T"
 CHAR 'V'
 TWOK 'E', 'R'
 CHAR 'N'
 CHAR 'E'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'D'               \ Token 3:      "DONNÉES SUR {selected system name}"
 TWOK 'O', 'N'          \
 CHAR 'N'               \ Encoded as:   "D<159>N<<137>[131]{3}"
 CHAR '<'
 TWOK 'E', 'S'
 RTOK 131
 CONT 3
 EQUB 0

 TWOK 'I', 'N'          \ Token 4:      "INVENTAIRE{cr}
 CHAR 'V'               \               "
 TWOK 'E', 'N'          \
 CHAR 'T'               \ Encoded as:   "<140>V<146>TAI<142>{12}"
 CHAR 'A'
 CHAR 'I'
 TWOK 'R', 'E'
 CONT 12
 EQUB 0

 CHAR 'S'               \ Token 5:      "SYSTÈME"
 CHAR 'Y'               \
 RTOK 43                \ Encoded as:   "SY[43]=ME"
 CHAR '='
 CHAR 'M'
 CHAR 'E'
 EQUB 0

 CHAR 'P'               \ Token 6:      "PRIX"
 TWOK 'R', 'I'          \
 CHAR 'X'               \ Encoded as:   "P<158>X"
 EQUB 0

 CONT 2                 \ Token 7:      "{current system name} PRIX DU MARCHÉ "
 CHAR ' '               \
 RTOK 6                 \ Encoded as:   "{2} [6] DU M<138>CH< "
 CHAR ' '
 CHAR 'D'
 CHAR 'U'
 CHAR ' '
 CHAR 'M'
 TWOK 'A', 'R'
 CHAR 'C'
 CHAR 'H'
 CHAR '<'
 CHAR ' '
 EQUB 0

 TWOK 'I', 'N'          \ Token 8:      "INDUSTRIELLE"
 CHAR 'D'               \
 TWOK 'U', 'S'          \ Encoded as:   "<140>D<136>T<158>EL<129>"
 CHAR 'T'
 TWOK 'R', 'I'
 CHAR 'E'
 CHAR 'L'
 TWOK 'L', 'E'
 EQUB 0

 CHAR 'A'               \ Token 9:      "AGRICOLE"
 CHAR 'G'               \
 TWOK 'R', 'I'          \ Encoded as:   "AG<158>CO<129>)
 CHAR 'C'
 CHAR 'O'
 TWOK 'L', 'E'
 EQUB 0

 TWOK 'R', 'I'          \ Token 10:     "RICHE "
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<158>CHE "
 CHAR 'E'
 CHAR ' '
 EQUB 0

 RTOK 139               \ Token 11:     "MOYENNE "
 CHAR 'N'               \
 CHAR 'E'               \ Encoded as:   "[139]NE )
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 12:     "PAUVRE "
 CHAR 'A'               \
 CHAR 'U'               \ Encoded as:   "PAUV<142> "
 CHAR 'V'
 TWOK 'R', 'E'
 CHAR ' '
 EQUB 0

 CHAR 'S'               \ Token 13:     "SURTOUT "
 CHAR 'U'               \
 CHAR 'R'               \ Encoded as:   "SUR[124] "
 RTOK 124
 CHAR ' '
 EQUB 0

 CHAR 'U'               \ Token 14:     "UNITE"
 CHAR 'N'               \
 CHAR 'I'               \ Encoded as:   "UNI<156>"
 TWOK 'T', 'E'
 EQUB 0

 CHAR ' '               \ Token 15:     " "
 EQUB 0                 \
                        \ Encoded as:   " "

 CHAR 'P'               \ Token 16:     "PLEIN"
 TWOK 'L', 'E'          \
 TWOK 'I', 'N'          \ Encoded as:   "P<129><140>"
 EQUB 0

 TWOK 'A', 'N'          \ Token 17:     "ANARCHIE"
 TWOK 'A', 'R'          \
 CHAR 'C'               \ Encoded as:   "<155><138>CHIE"
 CHAR 'H'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR 'F'               \ Token 18:     "FÉODAL"
 CHAR '<'               \
 CHAR 'O'               \ Encoded as:   "F<ODAL"
 CHAR 'D'
 CHAR 'A'
 CHAR 'L'
 EQUB 0

 CHAR 'P'               \ Token 19:     "PLURI-GOUVER."
 CHAR 'L'               \
 CHAR 'U'               \ Encoded as:   "PLU<158>-GOUV<144>."
 TWOK 'R', 'I'
 CHAR '-'
 CHAR 'G'
 CHAR 'O'
 CHAR 'U'
 CHAR 'V'
 TWOK 'E', 'R'
 CHAR '.'
 EQUB 0

 TWOK 'D', 'I'          \ Token 20:     "DICTATURE"
 CHAR 'C'               \
 CHAR 'T'               \ Encoded as:   "<141>CT<145>U<142>"
 TWOK 'A', 'T'
 CHAR 'U'
 TWOK 'R', 'E'
 EQUB 0

 RTOK 91                \ Token 21:     "COMMUNISTE"
 CHAR 'M'               \
 CHAR 'U'               \ Encoded as:   "[91]MUN<157><156>"
 CHAR 'N'
 TWOK 'I', 'S'
 TWOK 'T', 'E'
 EQUB 0

 CHAR 'C'               \ Token 22:     "CONFÉDÉRATION"
 TWOK 'O', 'N'          \
 CHAR 'F'               \ Encoded as:   "C<159>F<D<R<145>I<159>"
 CHAR '<'
 CHAR 'D'
 CHAR '<'
 CHAR 'R'
 TWOK 'A', 'T'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 CHAR 'D'               \ Token 23:     "DÉMOCRATIE"
 CHAR '<'               \
 CHAR 'M'               \ Encoded as:   "D<MOCR<145>IE"
 CHAR 'O'
 CHAR 'C'
 CHAR 'R'
 TWOK 'A', 'T'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR '<'               \ Token 24:     "ÉTAT CORPORATISTE"
 CHAR 'T'               \
 TWOK 'A', 'T'          \ Encoded as:   "<T<145> C<153>P<153><145><157><156>"
 CHAR ' '
 CHAR 'C'
 TWOK 'O', 'R'
 CHAR 'P'
 TWOK 'O', 'R'
 TWOK 'A', 'T'
 TWOK 'I', 'S'
 TWOK 'T', 'E'
 EQUB 0

 CHAR 'N'               \ Token 25:     "NAVIRE"
 CHAR 'A'               \
 CHAR 'V'               \ Encoded as:   "NAVI<142>"
 CHAR 'I'
 TWOK 'R', 'E'
 EQUB 0

 CHAR 'P'               \ Token 26:     "PRODUIT"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "PRODUIT"
 CHAR 'D'
 CHAR 'U'
 CHAR 'I'
 CHAR 'T'
 EQUB 0

 TWOK 'L', 'A'          \ Token 27:     "LASER"
 CHAR 'S'               \
 TWOK 'E', 'R'          \ Encoded as:   "<149>S<144>"
 EQUB 0

 CHAR 'H'               \ Token 28:     "HUMAINS COLONIAUX"
 CHAR 'U'               \
 TWOK 'M', 'A'          \ Encoded as:   "HU<139><140>S COL<159>IAUX"
 TWOK 'I', 'N'
 CHAR 'S'
 CHAR ' '
 CHAR 'C'
 CHAR 'O'
 CHAR 'L'
 TWOK 'O', 'N'
 CHAR 'I'
 CHAR 'A'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 RTOK 116               \ Token 29:     "INTERGALACTIQUE "
 CHAR ' '               \
 EQUB 0                 \ Encoded as:   "[116] "

 CHAR 'C'               \ Token 30:     "CARTE LOCALE"
 TWOK 'A', 'R'          \
 TWOK 'T', 'E'          \ Encoded as:   "C<138><156> LOCA<129>"
 CHAR ' '
 CHAR 'L'
 CHAR 'O'
 CHAR 'C'
 CHAR 'A'
 TWOK 'L', 'E'
 EQUB 0

 TWOK 'D', 'I'          \ Token 31:     "DISTANCE
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

 CONT 6                 \ Token 33:     "{sentence case}C.{sentence case}A."
 CHAR 'C'               \
 CHAR '.'               \ Encoded as:   "{6}C.{6}A."
 CONT 6
 CHAR 'A'
 CHAR '.'
 EQUB 0

 CHAR '<'               \ Token 34:     "ÉCONOMIE"
 CHAR 'C'               \
 TWOK 'O', 'N'          \ Encoded as:   "<C<159>OMIE"
 CHAR 'O'
 CHAR 'M'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR ' '               \ Token 35:     " {sentence case}A.{sentence case}LUM."
 CONT 6                 \
 CHAR 'A'               \ Encoded as:   " {6}A.{6}LUM."
 CHAR '.'
 CONT 6
 CHAR 'L'
 CHAR 'U'
 CHAR 'M'
 CHAR '.'
 EQUB 0

 CHAR 'N'               \ Token 36:     "NIVEAU TECH."
 CHAR 'I'               \
 TWOK 'V', 'E'          \ Encoded as:   "NI<150>AU <156>CH."
 CHAR 'A'
 CHAR 'U'
 CHAR ' '
 TWOK 'T', 'E'
 CHAR 'C'
 CHAR 'H'
 CHAR '.'
 EQUB 0

 TWOK 'A', 'R'          \ Token 37:     "ARGENT"
 TWOK 'G', 'E'          \
 CHAR 'N'               \ Encoded as:   "<138><131>NT"
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 38:     " BILLION"
 TWOK 'B', 'I'          \
 CHAR 'L'               \ Encoded as:   " <134>LLI<159>"
 CHAR 'L'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 CHAR 'C'               \ Token 39:     "CARTE GALACTIQUE{galaxy number}"
 TWOK 'A', 'R'          \
 TWOK 'T', 'E'          \ Encoded as:   "C<138><156> [122]{1}"
 CHAR ' '
 RTOK 122
 CONT 1
 EQUB 0

 CHAR 'C'               \ Token 40:     "CIBLE PERDUE "
 CHAR 'I'               \
 CHAR 'B'               \ Encoded as:   "CIB[94]P<144>DUE "
 RTOK 94
 CHAR 'P'
 TWOK 'E', 'R'
 CHAR 'D'
 CHAR 'U'
 CHAR 'E'
 CHAR ' '
 EQUB 0

 RTOK 106               \ Token 41:     "MISSILE ENVOYEÉ "
 CHAR ' '               \
 TWOK 'E', 'N'          \ Encoded as:   "[106] <146>VOYE< "
 CHAR 'V'
 CHAR 'O'
 CHAR 'Y'
 CHAR 'E'
 CHAR '<'
 CHAR ' '
 EQUB 0

 CHAR 'P'               \ Token 42:     "PORTÉE"
 TWOK 'O', 'R'          \
 CHAR 'T'               \ Encoded as:   "P<153>T<E"
 CHAR '<'
 CHAR 'E'
 EQUB 0

 CHAR 'S'               \ Token 43:     "ST"
 CHAR 'T'               \
 EQUB 0                 \ Encoded as:   "ST"

 RTOK 16                \ Token 44:     "PLEIN DE "
 CHAR ' '               \
 CHAR 'D'               \ Encoded as:   "[16] DE "
 CHAR 'E'
 CHAR ' '
 EQUB 0

 CHAR 'S'               \ Token 45:     "SE"
 CHAR 'E'               \
 EQUB 0                 \ Encoded as:   "SE"

 CHAR ' '               \ Token 46:     " CARGAISON{sentence case}"
 CHAR 'C'               \
 TWOK 'A', 'R'          \ Encoded as:   " C<138>GAI<135>N{6}"
 CHAR 'G'
 CHAR 'A'
 CHAR 'I'
 TWOK 'S', 'O'
 CHAR 'N'
 CONT 6
 EQUB 0

 CHAR 'E'               \ Token 47:     "EQUIPEMENT"
 TWOK 'Q', 'U'          \
 CHAR 'I'               \ Encoded as:   "E<154>IPEM<146>T"
 CHAR 'P'
 CHAR 'E'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'N'               \ Token 48:     "NOURRITURE"
 CHAR 'O'               \
 CHAR 'U'               \ Encoded as:   "NOUR<158>TU<142>"
 CHAR 'R'
 TWOK 'R', 'I'
 CHAR 'T'
 CHAR 'U'
 TWOK 'R', 'E'
 EQUB 0

 TWOK 'T', 'E'          \ Token 49:     "TEXTILES"
 CHAR 'X'               \
 TWOK 'T', 'I'          \ Encoded as:   "<156>X<151><129>S"
 TWOK 'L', 'E'
 CHAR 'S'
 EQUB 0

 TWOK 'R', 'A'          \ Token 50:     "RADIOACTIFS"
 TWOK 'D', 'I'          \
 CHAR 'O'               \ Encoded as:   "<148><141>OAC<151>FS"
 CHAR 'A'
 CHAR 'C'
 TWOK 'T', 'I'
 CHAR 'F'
 CHAR 'S'
 EQUB 0

 TWOK 'E', 'S'          \ Token 51:     "ESCLAVE-ROBT"
 CHAR 'C'               \
 TWOK 'L', 'A'          \ Encoded as:   "<137>C<149><150>-ROBT"
 TWOK 'V', 'E'
 CHAR '-'
 CHAR 'R'
 CHAR 'O'
 CHAR 'B'
 CHAR 'T'
 EQUB 0

 CHAR 'B'               \ Token 52:     "BOISSONS"
 CHAR 'O'               \
 TWOK 'I', 'S'          \ Encoded as:   "BO<157><135>NS"
 TWOK 'S', 'O'
 CHAR 'N'
 CHAR 'S'
 EQUB 0

 CHAR 'P'               \ Token 53:     "PDTS DE LUXE"
 CHAR 'D'               \
 CHAR 'T'               \ Encoded as:   "PDTS DE LU<130>"
 CHAR 'S'
 CHAR ' '
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 CHAR 'L'
 CHAR 'U'
 TWOK 'X', 'E'
 EQUB 0

 TWOK 'E', 'S'          \ Token 54:     "ESPÈCE RARE"
 CHAR 'P'               \
 CHAR '='               \ Encoded as:   "<137>P=<133> R<138>E"
 TWOK 'C', 'E'
 CHAR ' '
 CHAR 'R'
 TWOK 'A', 'R'
 CHAR 'E'
 EQUB 0

 TWOK 'O', 'R'          \ Token 55:     "ORDINATEUR"
 CHAR 'D'               \
 TWOK 'I', 'N'          \ Encoded as:   "<153>D<140><145>EUR"
 TWOK 'A', 'T'
 CHAR 'E'
 CHAR 'U'
 CHAR 'R'
 EQUB 0

 TWOK 'M', 'A'          \ Token 56:     "MACHINES"
 CHAR 'C'               \
 CHAR 'H'               \ Encoded as:   "<139>CH<140><137>"
 TWOK 'I', 'N'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'A'               \ Token 57:     "ALLIAGES"
 CHAR 'L'               \
 CHAR 'L'               \ Encoded as:   "ALLIA<131>S"
 CHAR 'I'
 CHAR 'A'
 TWOK 'G', 'E'
 CHAR 'S'
 EQUB 0

 TWOK 'A', 'R'          \ Token 58:     "ARMES"
 CHAR 'M'               \
 TWOK 'E', 'S'          \ Encoded as:   "<138>M<137>"
 EQUB 0

 CHAR 'F'               \ Token 59:     "FOURRURES"
 CHAR 'O'               \
 CHAR 'U'               \ Encoded as:   "FOURRUR<137>"
 CHAR 'R'
 CHAR 'R'
 CHAR 'U'
 CHAR 'R'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'M'               \ Token 60:     "MINÉRAUX"
 TWOK 'I', 'N'          \
 CHAR '<'               \ Encoded as:   "M<140><<148>UX"
 TWOK 'R', 'A'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 TWOK 'O', 'R'          \ Token 61:     "OR"
 EQUB 0                 \
                        \ Encoded as:   "<153>"

 CHAR 'P'               \ Token 62:     "PLATINE"
 CHAR 'L'               \
 TWOK 'A', 'T'          \ Encoded as:   "PL<145><140>E"
 TWOK 'I', 'N'
 CHAR 'E'
 EQUB 0

 TWOK 'G', 'E'          \ Token 63:     "GEMMES"
 CHAR 'M'               \
 CHAR 'M'               \ Encoded as:   "<131>MM<137>"
 TWOK 'E', 'S'
 EQUB 0

 RTOK 127               \ Token 64:     "OBJET E.T."
 CHAR ' '               \
 CHAR 'E'               \ Encoded as:   "[127] E.T."
 CHAR '.'
 CHAR 'T'
 CHAR '.'
 EQUB 0

 EQUB 0                 \ Token 65:     ""
                        \
                        \ Encoded as:   ""

 CHAR ' '               \ Token 66:     " CR"
 CHAR 'C'               \
 CHAR 'R'               \ Encoded as:   " CR"
 EQUB 0

 CHAR 'L'               \ Token 67:     "LARGES"
 TWOK 'A', 'R'          \
 TWOK 'G', 'E'          \ Encoded as:   "L<138><131>S"
 CHAR 'S'
 EQUB 0

 CHAR 'F'               \ Token 68:     "FÉROCES"
 CHAR '<'               \
 CHAR 'R'               \ Encoded as:   "F<RO<133>S"
 CHAR 'O'
 TWOK 'C', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'P'               \ Token 69:     "PETITS"
 CHAR 'E'               \
 TWOK 'T', 'I'          \ Encoded as:   "PE<151>TS"
 CHAR 'T'
 CHAR 'S'
 EQUB 0

 CHAR 'V'               \ Token 70:     "VERTS"
 TWOK 'E', 'R'          \
 CHAR 'T'               \ Encoded as:   "V<144>TS"
 CHAR 'S'
 EQUB 0

 CHAR 'R'               \ Token 71:     "ROUGES"
 CHAR 'O'               \
 CHAR 'U'               \ Encoded as:   "ROU<131>S"
 TWOK 'G', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'J'               \ Token 72:     "JAUNES"
 CHAR 'A'               \
 CHAR 'U'               \ Encoded as:   "JAUN<137>"
 CHAR 'N'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'B'               \ Token 73:     "BLEUS"
 TWOK 'L', 'E'          \
 TWOK 'U', 'S'          \ Encoded as:   "B<129><136>"
 EQUB 0

 CHAR 'N'               \ Token 74:     "NOIRS"
 CHAR 'O'               \
 CHAR 'I'               \ Encoded as:   "NOIRS"
 CHAR 'R'
 CHAR 'S'
 EQUB 0

 RTOK 136               \ Token 75:     "INOFFENSIFS"
 CHAR 'S'               \
 EQUB 0                 \ Encoded as:   "[136]S"

 CHAR 'V'               \ Token 76:     "VISQUEUX"
 TWOK 'I', 'S'          \
 TWOK 'Q', 'U'          \ Encoded as:   "V<157><154>EUX"
 CHAR 'E'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 CHAR 'Y'               \ Token 77:     "YEUX EXORBITÉS"
 CHAR 'E'               \
 CHAR 'U'               \ Encoded as:   "YEUX EX<153><134>T<S"
 CHAR 'X'
 CHAR ' '
 CHAR 'E'
 CHAR 'X'
 TWOK 'O', 'R'
 TWOK 'B', 'I'
 CHAR 'T'
 CHAR '<'
 CHAR 'S'
 EQUB 0

 CHAR '"'               \ Token 78:     "À CORNES"
 CHAR ' '               \
 CHAR 'C'               \ Encoded as:   "" C<153>N<137>"
 TWOK 'O', 'R'
 CHAR 'N'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'A', 'N'          \ Token 79:     "ANGULEUX"
 CHAR 'G'               \
 CHAR 'U'               \ Encoded as:   "<155>GU<129>UX"
 TWOK 'L', 'E'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 CHAR 'G'               \ Token 80:     "GRAS"
 TWOK 'R', 'A'          \
 CHAR 'S'               \ Encoded as:   "G<148>S"
 EQUB 0

 CHAR '"'               \ Token 81:     "À FOURRURE"
 CHAR ' '               \
 CHAR 'F'               \ Encoded as:   "" FOURRU<142>"
 CHAR 'O'
 CHAR 'U'
 CHAR 'R'
 CHAR 'R'
 CHAR 'U'
 TWOK 'R', 'E'
 EQUB 0

 CHAR 'R'               \ Token 82:     "RONGEURS"
 TWOK 'O', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "R<159><131>URS)
 CHAR 'U'
 CHAR 'R'
 CHAR 'S'
 EQUB 0

 CHAR 'G'               \ Token 83:     "GRENOUILLES"
 TWOK 'R', 'E'          \
 CHAR 'N'               \ Encoded as:   "G<142>NOUIL<129>S"
 CHAR 'O'
 CHAR 'U'
 CHAR 'I'
 CHAR 'L'
 TWOK 'L', 'E'
 CHAR 'S'
 EQUB 0

 CHAR 'L'               \ Token 84:     "LÉZARDS"
 CHAR '<'               \
 TWOK 'Z', 'A'          \ Encoded as:   "L<<132>RDS"
 CHAR 'R'
 CHAR 'D'
 CHAR 'S'
 EQUB 0

 CHAR 'H'               \ Token 85:     "HOMARDS"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "HOM<138>DS"
 TWOK 'A', 'R'
 CHAR 'D'
 CHAR 'S'
 EQUB 0

 CHAR 'O'               \ Token 86:     "OISEAUX"
 TWOK 'I', 'S'          \
 CHAR 'E'               \ Encoded as:   "O<157>EAUX"
 CHAR 'A'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 CHAR 'H'               \ Token 87:     "HUMANOIDES"
 CHAR 'U'               \
 TWOK 'M', 'A'          \ Encoded as:   "HU<139>NOID<137>"
 CHAR 'N'
 CHAR 'O'
 CHAR 'I'
 CHAR 'D'
 TWOK 'E', 'S'
 EQUB 0

 CHAR 'F'               \ Token 88:     "FÉLINS"
 CHAR '<'               \
 CHAR 'L'               \ Encoded as:   "F<L<140>S"
 TWOK 'I', 'N'
 CHAR 'S'
 EQUB 0

 TWOK 'I', 'N'          \ Token 89:     "INSECTES"
 RTOK 45                \
 CHAR 'C'               \ Encoded as:   "<140>[45]CT<137>"
 CHAR 'T'
 TWOK 'E', 'S'
 EQUB 0

 TWOK 'R', 'A'          \ Token 90:     "RAYON"
 CHAR 'Y'               \
 TWOK 'O', 'N'          \ Encoded as:   "<148>Y<159>"
 EQUB 0

 CHAR 'C'               \ Token 91:     "COM"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "COM"
 EQUB 0

 RTOK 91                \ Token 92:     "COMMANDANT"
 TWOK 'M', 'A'          \
 CHAR 'N'               \ Encoded as:   "[91]<139>ND<155>T"
 CHAR 'D'
 TWOK 'A', 'N'
 CHAR 'T'
 EQUB 0

 CHAR ' '               \ Token 93:     " DÉTRUIT"
 CHAR 'D'               \
 CHAR '<'               \ Encoded as:   " DÉTRUIT"
 CHAR 'T'
 CHAR 'R'
 CHAR 'U'
 CHAR 'I'
 CHAR 'T'
 EQUB 0

 TWOK 'L', 'E'          \ Token 94:     "LE "
 CHAR ' '               \
 EQUB 0                 \ Encoded as:   "LE "

 RTOK 26                \ Token 95:     "PRODUIT     QTÉ PRIX UNITAIRE"
 CHAR ' '               \
 CHAR ' '               \ Encoded as:   "[26]     QT< [6] UNITAI<142>"
 CHAR ' '
 CHAR ' '
 CHAR ' '
 CHAR 'Q'
 CHAR 'T'
 CHAR '<'
 CHAR ' '
 RTOK 6
 CHAR ' '
 CHAR 'U'
 CHAR 'N'
 CHAR 'I'
 CHAR 'T'
 CHAR 'A'
 CHAR 'I'
 TWOK 'R', 'E'
 EQUB 0

 CHAR 'A'               \ Token 96:     "AVANT"
 CHAR 'V'               \
 TWOK 'A', 'N'          \ Encoded as:   "AV<155>T"
 CHAR 'T'
 EQUB 0

 TWOK 'A', 'R'          \ Token 97:     "ARRIÈRE"
 TWOK 'R', 'I'          \
 CHAR '='               \ Encoded as:   "<138><158>=<142>"
 TWOK 'R', 'E'
 EQUB 0

 CHAR 'G'               \ Token 98:     "GAUCHE"
 CHAR 'A'               \
 CHAR 'U'               \ Encoded as:   "GAUCHE"
 CHAR 'C'
 CHAR 'H'
 CHAR 'E'
 EQUB 0

 CHAR 'D'               \ Token 99:     "DROITE"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "DROI<156>"
 CHAR 'I'
 TWOK 'T', 'E'
 EQUB 0

 RTOK 121               \ Token 100:    "ÉNERGIEFAIBLE{beep}"
 RTOK 138               \
 CONT 7                 \ Encoded as:   "[121][138]{7}"
 EQUB 0

 CHAR 'B'               \ Token 101:    "BRAVO COMMANDANT!"
 TWOK 'R', 'A'          \
 CHAR 'V'               \ Encoded as:   "B<148>VO [92]!"
 CHAR 'O'
 CHAR ' '
 RTOK 92
 CHAR '!'
 EQUB 0

 TWOK 'E', 'N'          \ Token 102:    "EN PLUS "
 CHAR ' '               \
 CHAR 'P'               \ Encoded as:   "<146> PL<136> "
 CHAR 'L'
 TWOK 'U', 'S'
 CHAR ' '
 EQUB 0

 CHAR 'C'               \ Token 103:    "CANNON LASER"
 TWOK 'A', 'N'          \
 CHAR 'N'               \ Encoded as:   "C<155>N<159> [27]"
 TWOK 'O', 'N'
 CHAR ' '
 RTOK 27
 EQUB 0

 RTOK 90                \ Token 104:    "RAYON LASER"
 CHAR ' '               \
 RTOK 27                \ Encoded as:   "[90] [27]"
 EQUB 0

 RTOK 94                \ Token 105:    "LE FUEL"
 CHAR 'F'               \
 CHAR 'U'               \ Encoded as:   "[94]FUEL"
 CHAR 'E'
 CHAR 'L'
 EQUB 0

 CHAR 'M'               \ Token 106:    "MISSILE"
 TWOK 'I', 'S'          \
 CHAR 'S'               \ Encoded as:   "M<157>SI<129>"
 CHAR 'I'
 TWOK 'L', 'E'
 EQUB 0

 CHAR 'G'               \ Token 107:    "GRANDE SOUTE"
 TWOK 'R', 'A'          \
 CHAR 'N'               \ Encoded as:   "G<148>NDE <135>U<156>"
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 TWOK 'S', 'O'
 CHAR 'U'
 TWOK 'T', 'E'
 EQUB 0

 RTOK 5                 \ Token 108:    "SYSTÈME E.C.M."
 CHAR ' '               \
 CHAR 'E'               \ Encoded as:   "[5] E.C.M."
 CHAR '.'
 CHAR 'C'
 CHAR '.'
 CHAR 'M'
 CHAR '.'
 EQUB 0

 CHAR 'C'               \ Token 109:    "CANON LASER"
 TWOK 'A', 'N'          \
 TWOK 'O', 'N'          \ Encoded as:   "C<155><159> [27]"
 CHAR ' '
 RTOK 27
 EQUB 0

 RTOK 104               \ Token 110:    "RAYON LASER"
 EQUB 0                 \
                        \ Encoded as:   "[104]"

 CHAR 'R'               \ Token 111:    "RÉCOLTEUR DE FUEL"
 CHAR '<'               \
 CHAR 'C'               \ Encoded as:   "R<COL<156>UR DE FUEL"
 CHAR 'O'
 CHAR 'L'
 TWOK 'T', 'E'
 CHAR 'U'
 CHAR 'R'
 CHAR ' '
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 CHAR 'F'
 CHAR 'U'
 CHAR 'E'
 CHAR 'L'
 EQUB 0

 CHAR 'C'               \ Token 112:    "CAPSULE DE SAUVETAGE"
 CHAR 'A'               \
 CHAR 'P'               \ Encoded as:   "CAPSU[94]DE SAU<150>TA<131>"
 CHAR 'S'
 CHAR 'U'
 RTOK 94
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 CHAR 'S'
 CHAR 'A'
 CHAR 'U'
 TWOK 'V', 'E'
 CHAR 'T'
 CHAR 'A'
 TWOK 'G', 'E'
 EQUB 0

 CHAR 'B'               \ Token 113:    "BOMBE D'ÉNERGIE"
 CHAR 'O'               \
 CHAR 'M'               \ Encoded as:   "BOM<147> D'<N<144>GIE"
 TWOK 'B', 'E'
 CHAR ' '
 CHAR 'D'
 CHAR '`'
 CHAR '<'
 CHAR 'N'
 TWOK 'E', 'R'
 CHAR 'G'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 CHAR 'U'               \ Token 114:    "UNITÉ D'ÉNERGIE"
 CHAR 'N'               \
 CHAR 'I'               \ Encoded as:   "UNIT< D'<N<144>GIE"
 CHAR 'T'
 CHAR '<'
 CHAR ' '
 CHAR 'D'
 CHAR '`'
 CHAR '<'
 CHAR 'N'
 TWOK 'E', 'R'
 CHAR 'G'
 CHAR 'I'
 CHAR 'E'
 EQUB 0

 TWOK 'O', 'R'          \ Token 115:    "ORD. D'ARRIMAGE"
 CHAR 'D'               \
 CHAR '.'               \ Encoded as:   "<153>D. D'<138><158><139><131>"
 CHAR ' '
 CHAR 'D'
 CHAR '`'
 TWOK 'A', 'R'
 TWOK 'R', 'I'
 TWOK 'M', 'A'
 TWOK 'G', 'E'
 EQUB 0

 TWOK 'I', 'N'          \ Token 116:    "INTERGALACTIQUE"
 CHAR 'T'               \
 TWOK 'E', 'R'          \ Encoded as:   "<140>T<144>[122]"
 RTOK 122
 EQUB 0

 RTOK 27                \ Token 117:    "LASER MILITAIRE"
 CHAR ' '               \
 CHAR 'M'               \ Encoded as:   "[27] MILITAI<142>"
 CHAR 'I'
 CHAR 'L'
 CHAR 'I'
 CHAR 'T'
 CHAR 'A'
 CHAR 'I'
 TWOK 'R', 'E'
 EQUB 0

 RTOK 27                \ Token 118:    "LASER {sentence case}MINEUR"
 CHAR ' '               \
 CONT 6                 \ Encoded as:   "[27] {6}M<140>EUR"
 CHAR 'M'
 TWOK 'I', 'N'
 CHAR 'E'
 CHAR 'U'
 CHAR 'R'
 EQUB 0

 RTOK 37                \ Token 119:    "ARGENT:{cash} CR{cr})
 CHAR ':'               \
 CONT 0                 \ Encoded as:   "[37]:{0}"
 EQUB 0

 RTOK 106               \ Token 120:    "MISSILE EN VUE"
 CHAR ' '               \
 TWOK 'E', 'N'          \ Encoded as:   "[106] <146> VUE"
 CHAR ' '
 CHAR 'V'
 CHAR 'U'
 CHAR 'E'
 EQUB 0

 CHAR '<'               \ Token 121:    "ÉNERGIE "
 CHAR 'N'               \
 TWOK 'E', 'R'          \ Encoded as:   "<N<144>GIE "
 CHAR 'G'
 CHAR 'I'
 CHAR 'E'
 CHAR ' '
 EQUB 0

 CHAR 'G'               \ Token 122:    "GALACTIQUE"
 CHAR 'A'               \
 TWOK 'L', 'A'          \ Encoded as:   "GA<149>C<151><154>E"
 CHAR 'C'
 TWOK 'T', 'I'
 TWOK 'Q', 'U'
 CHAR 'E'
 EQUB 0

 RTOK 115               \ Token 123:    "ORD. D'ARRIMAGE EN MARCHE"
 CHAR ' '               \
 TWOK 'E', 'N'          \ Encoded as:   "[115] <146> M<138>CHE"
 CHAR ' '
 CHAR 'M'
 TWOK 'A', 'R'
 CHAR 'C'
 CHAR 'H'
 CHAR 'E'
 EQUB 0

 CHAR 'T'               \ Token 124:    "TOUT"
 CHAR 'O'               \
 CHAR 'U'               \ Encoded as:   "TOUT"
 CHAR 'T'
 EQUB 0

 RTOK 43                \ Token 125:    "STATUT LÉGAL:"
 TWOK 'A', 'T'          \
 CHAR 'U'               \ Encoded as:   "[43]<145>UT L<GAL:"
 CHAR 'T'
 CHAR ' '
 CHAR 'L'
 CHAR '<'
 CHAR 'G'
 CHAR 'A'
 CHAR 'L'
 CHAR ':'
 EQUB 0

 RTOK 92                \ Token 126:    "COMMANDANT {commander name}{cr}
 CHAR ' '               \                {cr}
 CONT 4                 \                {cr}
 CONT 12                \                {sentence case}SYSTÈME ACTUEL{tab
 CONT 12                \                to column 22}:{current system name}{cr}
 CONT 12                \                SYSTÈME INTERGALACT{tab to column 22}:
 CONT 6                 \                {selected system name}{cr}CONDITION{tab
 RTOK 5                 \                to column 22}:"
 CHAR ' '               \
 CHAR 'A'               \ Encoded as:   "[92] {4}{12}{12}{12}{6}[5] ACTUEL{9}{2}
 CHAR 'C'               \                {12}[5] <140>T<144>GA<149>CT{9}{3}{12}C
 CHAR 'T'               \                <159><141><151><159>{9}"
 CHAR 'U'
 CHAR 'E'
 CHAR 'L'
 CONT 9
 CONT 2
 CONT 12
 RTOK 5
 CHAR ' '
 TWOK 'I', 'N'
 CHAR 'T'
 TWOK 'E', 'R'
 CHAR 'G'
 CHAR 'A'
 TWOK 'L', 'A'
 CHAR 'C'
 CHAR 'T'
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

 CHAR 'O'               \ Token 127:    "OBJET"
 CHAR 'B'               \
 CHAR 'J'               \ Encoded as:   "OBJET"
 CHAR 'E'
 CHAR 'T'
 EQUB 0

 EQUB 0                 \ Token 128:    ""
                        \
                        \ Encoded as:   ""

 CHAR '"'               \ Token 129:    "À "
 CHAR ' '               \
 EQUB 0                 \ Encoded as:   "" "

 CHAR '<'               \ Token 130:    "ÉVALUATION"
 CHAR 'V'               \
 CHAR 'A'               \ Encoded as:   "<VALU<145>I<159>"
 CHAR 'L'
 CHAR 'U'
 TWOK 'A', 'T'
 CHAR 'I'
 TWOK 'O', 'N'
 EQUB 0

 CHAR ' '               \ Token 131:    " SUR "
 CHAR 'S'               \
 CHAR 'U'               \ Encoded as:   " SUR "
 CHAR 'R'
 CHAR ' '
 EQUB 0

 CONT 12                \ Token 132:    "{cr}ÉQUIPEMENT:"
 CHAR '<'               \
 TWOK 'Q', 'U'          \ Encoded as:   "{12}<<154>IPEM<146>T:"
 CHAR 'I'
 CHAR 'P'
 CHAR 'E'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 CHAR ':'
 EQUB 0

 CHAR 'P'               \ Token 133:    "PROPRE"
 CHAR 'R'               \
 CHAR 'O'               \ Encoded as:   "PROP<142>"
 CHAR 'P'
 TWOK 'R', 'E'
 EQUB 0

 CHAR 'D'               \ Token 134:    "DÉLINQUANT"
 CHAR '<'               \
 CHAR 'L'               \ Encoded as:   "D<L<140><154><155>T"
 TWOK 'I', 'N'
 TWOK 'Q', 'U'
 TWOK 'A', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'F'               \ Token 135:    "FUGITIF"
 CHAR 'U'               \
 CHAR 'G'               \ Encoded as:   "FUGI<151>F"
 CHAR 'I'
 TWOK 'T', 'I'
 CHAR 'F'
 EQUB 0

 TWOK 'I', 'N'          \ Token 136:    "INOFFENSIF"
 CHAR 'O'               \
 CHAR 'F'               \ Encoded as:   "<140>OFF<146>SIF"
 CHAR 'F'
 TWOK 'E', 'N'
 CHAR 'S'
 CHAR 'I'
 CHAR 'F'
 EQUB 0

 TWOK 'Q', 'U'          \ Token 137:    "QUASI INOFFENSIF"
 CHAR 'A'               \
 CHAR 'S'               \ Encoded as:   "<154>ASI [136]"
 CHAR 'I'
 CHAR ' '
 RTOK 136
 EQUB 0

 CHAR 'F'               \ Token 138:    "FAIBLE"
 CHAR 'A'               \
 CHAR 'I'               \ Encoded as:   "FAIB<129>"
 CHAR 'B'
 TWOK 'L', 'E'
 EQUB 0

 CHAR 'M'               \ Token 139:    "MOYEN"
 CHAR 'O'               \
 CHAR 'Y'               \ Encoded as:   "MOY<146>"
 TWOK 'E', 'N'
 EQUB 0

 TWOK 'I', 'N'          \ Token 140:    "INTERMÉDIAIRE"
 CHAR 'T'               \
 TWOK 'E', 'R'          \ Encoded as:   "<140>T<144>M<<141>AI<142>"
 CHAR 'M'
 CHAR '<'
 TWOK 'D', 'I'
 CHAR 'A'
 CHAR 'I'
 TWOK 'R', 'E'
 EQUB 0

 RTOK 91                \ Token 141:    "COMPÉTENT"
 CHAR 'P'               \
 CHAR '<'               \ Encoded as:   "[91]P<T<146>T"
 CHAR 'T'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR 'D'               \ Token 142:    "DANGEREUX"
 TWOK 'A', 'N'          \
 TWOK 'G', 'E'          \ Encoded as:   "D<155><131><142>UX"
 TWOK 'R', 'E'
 CHAR 'U'
 CHAR 'X'
 EQUB 0

 CHAR 'M'               \ Token 143:    "MORTELLEMENT"
 TWOK 'O', 'R'          \
 TWOK 'T', 'E'          \ Encoded as:   "M<153><156>L<129>M<146>T"
 CHAR 'L'
 TWOK 'L', 'E'
 CHAR 'M'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CHAR '-'               \ Token 144:    "--- E L I T E ---"
 CHAR '-'               \
 CHAR '-'               \ Encoded as:   "--- E L I T E ---"
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
 EQUB 0

 CHAR 'P'               \ Token 145:    "PRÉSENT"
 CHAR 'R'               \
 CHAR '<'               \ Encoded as:   "PR<S<146>T"
 CHAR 'S'
 TWOK 'E', 'N'
 CHAR 'T'
 EQUB 0

 CONT 8                 \ Token 146:    "{all caps}JEU TERMINÉ"
 CHAR 'J'               \
 CHAR 'E'               \ Encoded as:   "{8}JEU T<144>M<140><"
 CHAR 'U'
 CHAR ' '
 CHAR 'T'
 TWOK 'E', 'R'
 CHAR 'M'
 TWOK 'I', 'N'
 CHAR '<'
 EQUB 0

 CHAR 'P'               \ Token 147:    "PÉNALITÉ DE 60 SEC"
 CHAR '<'               \
 CHAR 'N'               \ Encoded as:   "P<NALIT< DE 60 [45]C"
 CHAR 'A'
 CHAR 'L'
 CHAR 'I'
 CHAR 'T'
 CHAR '<'
 CHAR ' '
 CHAR 'D'
 CHAR 'E'
 CHAR ' '
 CHAR '6'
 CHAR '0'
 CHAR ' '
 RTOK 45
 CHAR 'C'
 EQUB 0

 EQUB 0                 \ Token 148:    ""
                        \
                        \ Encoded as:   ""

 EQUB &00, &00, &00     \ These bytes appear to be unused
 EQUB &00, &00, &00
 EQUB &00

