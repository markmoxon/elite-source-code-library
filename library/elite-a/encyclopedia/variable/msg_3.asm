\ ******************************************************************************
\
\       Name: msg_3
\       Type: Variable
\   Category: Text
\    Summary: The second extended token table for recursive tokens 0-255
\             (write_msg3)
\
\ ******************************************************************************

.msg_3

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 ETWO 'E', 'N'          \ Token 1:      "ENCYCLOPEDIA GALACTICA"
 ECHR 'C'               \
 ECHR 'Y'               \ Encoded as:   "<246>CYC<224>P<252>IA G<228>AC<251>CA"
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'P'
 ETWO 'E', 'D'
 ECHR 'I'
 ECHR 'A'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
 ECHR 'A'
 EQUB VE

 ETOK 207               \ Token 2:      "SHIPS {all caps}A-G{sentence case}"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "[207]S {1}A-G{2}"
 EJMP 1
 ECHR 'A'
 ECHR '-'
 ECHR 'G'
 EJMP 2
 EQUB VE

 ETOK 207               \ Token 3:      "SHIPS {all caps}I-W{sentence case}"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "[207]S {1}I-W{2}"
 EJMP 1
 ECHR 'I'
 ECHR '-'
 ECHR 'W'
 EJMP 2
 EQUB VE

 ECHR 'E'               \ Token 4:      "EQUIPMENT"
 ETWO 'Q', 'U'          \
 ECHR 'I'               \ Encoded as:   "E<254>IPM<246>T"
 ECHR 'P'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'C'               \ Token 5:      "CONTROLS"
 ETWO 'O', 'N'          \
 ECHR 'T'               \ Encoded as:   "C<223>TROLS"
 ECHR 'R'
 ECHR 'O'
 ECHR 'L'
 ECHR 'S'
 EQUB VE

 ETWO 'I', 'N'          \ Token 6:      "INFORMATION"
 ECHR 'F'               \
 ETWO 'O', 'R'          \ Encoded as:   "<240>F<253><239><251><223>"
 ETWO 'M', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'A'               \ Token 7:      "ADDER"
 ECHR 'D'               \
 ECHR 'D'               \ Encoded as:   "ADD<244>"
 ETWO 'E', 'R'
 EQUB VE

 ETWO 'A', 'N'          \ Token 8:      "ANACONDA"
 ECHR 'A'               \
 ECHR 'C'               \ Encoded as:   "<255>AC<223>DA"
 ETWO 'O', 'N'
 ECHR 'D'
 ECHR 'A'
 EQUB VE

 ECHR 'A'               \ Token 9:      "ASP MK2"
 ECHR 'S'               \
 ECHR 'P'               \ Encoded as:   "ASP MK2"
 ECHR ' '
 ECHR 'M'
 ECHR 'K'
 ECHR '2'
 EQUB VE

 ECHR 'B'               \ Token 10:     "BOA"
 ECHR 'O'               \
 ECHR 'A'               \ Encoded as:   "BOA"
 EQUB VE

 ECHR 'B'               \ Token 11:     "BUSHMASTER"
 ECHR 'U'               \
 ECHR 'S'               \ Encoded as:   "BUSHMASTER"
 ECHR 'H'
 ECHR 'M'
 ECHR 'A'
 ECHR 'S'
 ECHR 'T'
 ECHR 'E'
 ECHR 'R'
 EQUB VE

 ECHR 'C'               \ Token 12:     "CHAMELEON"
 ECHR 'H'               \
 ECHR 'A'               \ Encoded as:   "CHAMELEON"
 ECHR 'M'
 ECHR 'E'
 ECHR 'L'
 ECHR 'E'
 ECHR 'O'
 ECHR 'N'
 EQUB VE

 ECHR 'C'               \ Token 13:     "COBRA MK1"
 ECHR 'O'               \
 ECHR 'B'               \ Encoded as:   "COB<248> MK1"
 ETWO 'R', 'A'
 ECHR ' '
 ECHR 'M'
 ECHR 'K'
 ECHR '1'
 EQUB VE

 ECHR 'C'               \ Token 14:     "COBRA MK3"
 ECHR 'O'               \
 ECHR 'B'               \ Encoded as:   "COB<248> MK3"
 ETWO 'R', 'A'
 ECHR ' '
 ECHR 'M'
 ECHR 'K'
 ECHR '3'
 EQUB VE

 ECHR 'C'               \ Token 15:     "CORIOLIS STATION"
 ETWO 'O', 'R'          \
 ECHR 'I'               \ Encoded as:   "C<253>IOLIS <222><245>I<223>"
 ECHR 'O'
 ECHR 'L'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'D'               \ Token 16:     "DODECAGON STATION"
 ECHR 'O'               \
 ECHR 'D'               \ Encoded as:   "DODECAG<223> <222><245>I<223>"
 ECHR 'E'
 ECHR 'C'
 ECHR 'A'
 ECHR 'G'
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 EQUB VE

 ETWO 'E', 'S'          \ Token 17:     "ESCAPE CAPSULE"
 ECHR 'C'               \
 ECHR 'A'               \ Encoded as:   "<237>CAPE CAPSU<229>"
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'S'
 ECHR 'U'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'F'               \ Token 18:     "FER-DE-{single cap}LANCE"
 ETWO 'E', 'R'          \
 ECHR '-'               \ Encoded as:   "F<244>-DE-{19}<249>N<233>"
 ECHR 'D'
 ECHR 'E'
 ECHR '-'
 EJMP 19
 ETWO 'L', 'A'
 ECHR 'N'
 ETWO 'C', 'E'
 EQUB VE

 ETWO 'G', 'E'          \ Token 19:     "GECKO"
 ECHR 'C'               \
 ECHR 'K'               \ Encoded as:   "<231>CKO"
 ECHR 'O'
 EQUB VE

 ECHR 'G'               \ Token 20:     "GHAVIAL"
 ECHR 'H'               \
 ECHR 'A'               \ Encoded as:   "GHAVI<228>"
 ECHR 'V'
 ECHR 'I'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'I'               \ Token 21:     "IGUANA"
 ECHR 'G'               \
 ECHR 'U'               \ Encoded as:   "IGUANA"
 ECHR 'A'
 ECHR 'N'
 ECHR 'A'
 EQUB VE

 ECHR 'K'               \ Token 22:     "KRAIT"
 ETWO 'R', 'A'          \
 ETWO 'I', 'T'          \ Encoded as:   "K<248><219>"
 EQUB VE

 ETWO 'M', 'A'          \ Token 23:     "MAMBA"
 ECHR 'M'               \
 ECHR 'B'               \ Encoded as:   "<239>MBA"
 ECHR 'A'
 EQUB VE

 ECHR 'M'               \ Token 24:     "MONITOR"
 ETWO 'O', 'N'          \
 ETWO 'I', 'T'          \ Encoded as:   "M<223><219><253>"
 ETWO 'O', 'R'
 EQUB VE

 ECHR 'M'               \ Token 25:     "MORAY"
 ECHR 'O'               \
 ETWO 'R', 'A'          \ Encoded as:   "MO<248>Y"
 ECHR 'Y'
 EQUB VE

 ECHR 'O'               \ Token 26:     "OPHIDIAN"
 ECHR 'P'               \
 ECHR 'H'               \ Encoded as:   "OPHI<241><255>"
 ECHR 'I'
 ETWO 'D', 'I'
 ETWO 'A', 'N'
 EQUB VE

 ECHR 'P'               \ Token 27:     "PYTHON"
 ECHR 'Y'               \
 ETWO 'T', 'H'          \ Encoded as:   "PY<226><223>"
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'S'               \ Token 28:     "SHUTTLE"
 ECHR 'H'               \
 ECHR 'U'               \ Encoded as:   "SHUTT<229>"
 ECHR 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'S'               \ Token 29:     "SIDEWINDER"
 ECHR 'I'               \
 ECHR 'D'               \ Encoded as:   "SIDEW<240>D<244>"
 ECHR 'E'
 ECHR 'W'
 ETWO 'I', 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

 ETWO 'T', 'H'          \ Token 30:     "THARGOID"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "<226><238>GOID"
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 EQUB VE

 ETWO 'T', 'H'          \ Token 31:     "THARGON"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "<226><238>G<223>"
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'T'               \ Token 32:     "TRANSPORTER"
 ETWO 'R', 'A'          \
 ECHR 'N'               \ Encoded as:   "T<248>NSP<253>T<244>"
 ECHR 'S'
 ECHR 'P'
 ETWO 'O', 'R'
 ECHR 'T'
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'V'               \ Token 33:     "VIPER"
 ECHR 'I'               \
 ECHR 'P'               \ Encoded as:   "VIP<244>"
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'W'               \ Token 34:     "WORM"
 ETWO 'O', 'R'          \
 ECHR 'M'               \ Encoded as:   "W<253>M"
 EQUB VE

 ETWO 'A', 'R'          \ Token 35:     "ARMAMENTS:"
 ETWO 'M', 'A'          \
 ECHR 'M'               \ Encoded as:   "<238><239>M<246>TS:"
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR 'S'
 ECHR ':'
 EQUB VE

 ECHR 'S'               \ Token 36:     "SPEED:"
 ECHR 'P'               \
 ECHR 'E'               \ Encoded as:   "SPE<252>:"
 ETWO 'E', 'D'
 ECHR ':'
 EQUB VE

 ETWO 'I', 'N'          \ Token 37:     "INSERVICE DATE:"
 ETWO 'S', 'E'          \
 ECHR 'R'               \ Encoded as:   "<240><218>RVI<233> D<245>E:"
 ECHR 'V'
 ECHR 'I'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'D'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR ':'
 EQUB VE

 ECHR 'C'               \ Token 38:     "COMBAT"
 ECHR 'O'               \
 ECHR 'M'               \ Encoded as:   "COMB<245>"
 ECHR 'B'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'C'               \ Token 39:     "CREW:"
 ETWO 'R', 'E'          \
 ECHR 'W'               \ Encoded as:   "C<242>W:"
 ECHR ':'
 EQUB VE

 ETOK 151               \ Token 40:     "DRIVE MOTORS:"
 ECHR ' '               \
 ECHR 'M'               \ Encoded as:   "[151] MOT<253>S:"
 ECHR 'O'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR 'S'
 ECHR ':'
 EQUB VE

 ETWO 'R', 'A'          \ Token 41:     "RANGE:"
 ECHR 'N'               \
 ETWO 'G', 'E'          \ Encoded as:   "<248>N<231>:"
 ECHR ':'
 EQUB VE

 ECHR 'F'               \ Token 42:     "FT"
 ECHR 'T'               \
 EQUB VE                \ Encoded as:   "FT"

 ETWO 'D', 'I'          \ Token 43:     "DIMENSIONS:"
 ECHR 'M'               \
 ETWO 'E', 'N'          \ Encoded as:   "<241>M<246>SI<223>S:"
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR ':'
 EQUB VE

 ECHR 'H'               \ Token 44:     "HULL:"
 ECHR 'U'               \
 ECHR 'L'               \ Encoded as:   "HULL:"
 ECHR 'L'
 ECHR ':'
 EQUB VE

 ECHR 'S'               \ Token 45:     "SPACE:"
 ECHR 'P'               \
 ECHR 'A'               \ Encoded as:   "SPA<233>:"
 ETWO 'C', 'E'
 ECHR ':'
 EQUB VE

 ECHR ' '               \ Token 46:     " MISSILES"
 ECHR 'M'               \
 ECHR 'I'               \ Encoded as:   " MISS<220><237>"
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
 EQUB VE

 ECHR 'F'               \ Token 47:     "FACTOR:"
 ECHR 'A'               \
 ECHR 'C'               \ Encoded as:   "FACT<253>:"
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ':'
 EQUB VE

 ETWO 'G', 'E'          \ Token 48:     "GERET STARSEEKER"
 ECHR 'R'               \
 ETWO 'E', 'T'          \ Encoded as:   "<231>R<221> <222><238><218>EK<244>"
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'A', 'R'
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR 'K'
 ETWO 'E', 'R'
 EQUB VE

 ECHR ' '               \ Token 49:     " LASER"
 ETWO 'L', 'A'          \
 ETWO 'S', 'E'          \ Encoded as:   "<249><218>R"
 ECHR 'R'
 EQUB VE

 ECHR ' '               \ Token 50:     " PULSE"
 ECHR 'P'               \
 ECHR 'U'               \ Encoded as:   "PUL<218>"
 ECHR 'L'
 ETWO 'S', 'E'
 EQUB VE

 ECHR ' '               \ Token 51:     " SYSTEM"
 ECHR 'S'               \
 ECHR 'Y'               \ Encoded as:   " SY<222>EM"
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 EQUB VE

 ETWO 'E', 'R'          \ Token 52:     "ERGON"
 ECHR 'G'               \
 ETWO 'O', 'N'          \ Encoded as:   "<244>G<223>"
 EQUB VE

 ETOK 151               \ Token 53:     "DRIVE"
 EQUB VE                \
                        \ Encoded as:   "[151]"

 ETWO 'S', 'E'          \ Token 54:     "SEEK"
 ECHR 'E'               \
 ECHR 'K'               \ Encoded as:   "<218>EK"
 EQUB VE

 ECHR 'L'               \ Token 55:     "LIGHT"
 ECHR 'I'               \
 ECHR 'G'               \ Encoded as:   "LIGHT"
 ECHR 'H'
 ECHR 'T'
 EQUB VE

 ETWO 'I', 'N'          \ Token 56:     "INGRAM"
 ECHR 'G'               \
 ETWO 'R', 'A'          \ Encoded as:   "<240>G<248>M"
 ECHR 'M'
 EQUB VE

 ETWO 'L', 'A'          \ Token 57:     "LANCE & FERMAN"
 ECHR 'N'               \
 ETWO 'C', 'E'          \ Encoded as:   "<249>N<233> & F<244><239>N"
 ECHR ' '
 ECHR '&'
 ECHR ' '
 ECHR 'F'
 ETWO 'E', 'R'
 ETWO 'M', 'A'
 ECHR 'N'
 EQUB VE

 EJMP 19                \ Token 58:     "{single cap}KRUGER "
 ECHR 'K'               \
 ECHR 'R'               \ Encoded as:   "{19}KRU<231>R "
 ECHR 'U'
 ETWO 'G', 'E'
 ECHR 'R'
 ECHR ' '
 EQUB VE

 ECHR 'H'               \ Token 59:     "HASSONI"
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "HASS<223>I"
 ECHR 'S'
 ETWO 'O', 'N'
 ECHR 'I'
 EQUB VE

 ECHR 'V'               \ Token 60:     "VOLTAIRE"
 ECHR 'O'               \
 ECHR 'L'               \ Encoded as:   "VOLTAI<242>"
 ECHR 'T'
 ECHR 'A'
 ECHR 'I'
 ETWO 'R', 'E'
 EQUB VE

 ECHR 'C'               \ Token 61:     "CARGO"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "C<238>GO"
 ECHR 'O'
 EQUB VE

 EJMP 1                 \ Token 62:     "{all caps}TC{sentence case}"
 ECHR 'T'               \
 ECHR 'C'               \ Encoded as:   "{1}TC{2}"
 EJMP 2
 EQUB VE

 EJMP 1                 \ Token 63:     "{all caps}LY{sentence case}"
 ECHR 'L'               \
 ECHR 'Y'               \ Encoded as:   "{1}LY{2}"
 EJMP 2
 EQUB VE

 EJMP 1                 \ Token 64:     "{all caps}LM{sentence case}"
 ECHR 'L'               \
 ECHR 'M'               \ Encoded as:   "{1}LM{2}"
 EJMP 2
 EQUB VE

 ECHR 'C'               \ Token 65:     "CF"
 ECHR 'F'               \
 EQUB VE                \ Encoded as:   "CF"

 ETWO 'T', 'H'          \ Token 66:     "THRUST"
 ECHR 'R'               \
 ECHR 'U'               \ Encoded as:   "<226>RU<222>"
 ETWO 'S', 'T'
 EQUB VE

 ECHR ' '               \ Token 67:     " SHIP"
 ETOK 207               \
 EQUB VE                \ Encoded as:   " [207]"

 ETWO 'I', 'N'          \ Token 68:     "INVENTION"
 ECHR 'V'               \
 ETWO 'E', 'N'          \ Encoded as:   "<240>V<246><251><223>"
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 EQUB VE

 ETWO 'O', 'U'          \ Token 69:     "OUTWORLD"
 ECHR 'T'               \
 ECHR 'W'               \ Encoded as:   "<217>TW<253>LD"
 ETWO 'O', 'R'
 ECHR 'L'
 ECHR 'D'
 EQUB VE

 ECHR 'Z'               \ Token 70:     "ZORGON PETTERSON)"
 ETWO 'O', 'R'          \
 ECHR 'G'               \ Encoded as:   "Z<253>G<223> P<221>T<244>S<223>)"
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'P'
 ETWO 'E', 'T'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 ETWO 'O', 'N'
 ECHR ')'
 EQUB VE

 ECHR 'D'               \ Token 71:     "DE{single cap}LACY"
 ECHR 'E'               \
 EJMP 19                \ Encoded as:   "DE{19}<249>CY"
 ETWO 'L', 'A'
 ECHR 'C'
 ECHR 'Y'
 EQUB VE

 EJMP 1                 \ Token 72:     "{all caps}4*C40KV{sentence case} AMES
 ECHR '4'               \                DRIVE"
 ECHR '*'               \ Encoded as:   "{1}4*C40KV{2} AM<237> [151]"
 ECHR 'C'
 ECHR '4'
 ECHR '0'
 ECHR 'K'
 ECHR 'V'
 EJMP 2
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR ' '
 ETOK 151
 EQUB VE

 ECHR 'V'               \ Token 73:     "V & K "
 ECHR ' '               \
 ECHR '&'               \ Encoded as:   "V & K "
 ECHR ' '
 ECHR 'K'
 ECHR ' '
 EQUB VE

 ECHR 'B'               \ Token 74:     "BLAST"
 ETWO 'L', 'A'          \
 ETWO 'S', 'T'          \ Encoded as:   "B<249><222>"
 EQUB VE

 ECHR ' '               \ Token 75:     " ({single cap}GASEC LABS, VETITICE)"
 ECHR '('               \
 EJMP 19                \ Encoded as:   "({19}GA<218>C L<216>S, <250><251><251>
 ECHR 'G'               \                <233>)"
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR 'C'
 ECHR ' '
 ECHR 'L'
 ETWO 'A', 'B'
 ECHR 'S'
 ECHR ','
 ECHR ' '
 ETWO 'V', 'E'
 ETWO 'T', 'I'
 ETWO 'T', 'I'
 ETWO 'C', 'E'
 ECHR ')'
 EQUB VE

 ECHR 'F'               \ Token 76:     "FEDERATION"
 ETWO 'E', 'D'          \
 ECHR 'E'               \ Encoded as:   "F<252>E<248><251><223>"
 ETWO 'R', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'S'               \ Token 77:     "SPACE"
 ECHR 'P'               \
 ECHR 'A'               \ Encoded as:   "SPA<233>"
 ETWO 'C', 'E'
 EQUB VE

 EJMP 19                \ Token 78:     "{single cap}IONIC"
 ECHR 'I'               \
 ETWO 'O', 'N'          \ Encoded as:   "{19}I<223>IC"
 ECHR 'I'
 ECHR 'C'
 EQUB VE

 ECHR 'H'               \ Token 79:     "HUNT"
 ECHR 'U'               \
 ECHR 'N'               \ Encoded as:   "HUNT"
 ECHR 'T'
 EQUB VE

 ECHR 'P'               \ Token 80:     "PROSSET "
 ECHR 'R'               \
 ECHR 'O'               \ Encoded as:   "PROS<218>T "
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'T'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 81:     " WORKSHOPS)"
 ECHR 'W'               \
 ETWO 'O', 'R'          \ Encoded as:   " W<253>KSHOPS)"
 ECHR 'K'
 ECHR 'S'
 ECHR 'H'
 ECHR 'O'
 ECHR 'P'
 ECHR 'S'
 ECHR ')'
 EQUB VE

 EJMP 1                 \ Token 82:     "{all caps}/1L{sentence case}"
 ECHR '/'               \
 ECHR '1'               \ Encoded as:   "{1}/1L{2}"
 ECHR 'L'
 EJMP 2
 EQUB VE

 EJMP 1                 \ Token 83:     "{all caps}/2L{sentence case}"
 ECHR '/'               \
 ECHR '2'               \ Encoded as:   "{1}/2L{2}"
 ECHR 'L'
 EJMP 2
 EQUB VE

 EJMP 1                 \ Token 84:     "{all caps}/4L{sentence case}"
 ECHR '/'               \
 ECHR '4'               \ Encoded as:   "{1}/4L{2}"
 ECHR 'L'
 EJMP 2
 EQUB VE

 ECHR ' '               \ Token 85:     " ({single cap}"
 ECHR '('               \
 EJMP 19                \ Encoded as:   " ({19}"
 EQUB VE

 EJMP 1                 \ Token 86:     "{all caps}IFS{sentence case} "
 ECHR 'I'               \
 ECHR 'F'               \ Encoded as:   "{1}IFS{2} "
 ECHR 'S'
 EJMP 2
 ECHR ' '
 EQUB VE

 EJMP 12                \ Token 87:     "{cr}
 ECHR 'F'               \                FLIGHT CONTROLS{crlf}
 ECHR 'L'               \                <{tab 6}ANTI-CLOCKWISE ROLL{cr}
 ECHR 'I'               \                >{tab 6}CLOCKWISE ROLL{cr}
 ECHR 'G'               \                S{tab 6}DIVE{cr}
 ECHR 'H'               \                X{tab 6}CLIMB{cr}
 ECHR 'T'               \                {all caps}SPC{sentence case}{tab 6}
 ECHR ' '               \                INCREASE SPEED{cr}
 ECHR 'C'               \                ?{tab 6}DECREASE SPEED{cr}
 ETWO 'O', 'N'          \                {all caps}TAB{sentence case}{tab 6}
 ECHR 'T'               \                HYPERSPACE ESCAPE{cr}
 ECHR 'R'               \                {all caps}ESC{sentence case}{tab 6}
 ECHR 'O'               \                ESCAPE CAPSULE{cr}
 ECHR 'L'               \                F{tab 6}TOGGLE COMPASS{cr}
IF _ELITE_A_ENCYCLOPEDIA
 ECHR 'S'               \                V{tab 6}{standard tokens, sentence
 ETWO '-', '-'          \                case} DOCKING COMPUTERS{extended
 ECHR '<'               \                tokens}ON{cr}
 EJMP 8                 \                P{tab 6}{standard tokens, sentence
 ETWO 'A', 'N'          \                case} DOCKING COMPUTERS{extended
 ETWO 'T', 'I'          \                tokens} OFF{cr}
 ECHR '-'               \                J{tab 6}MICROJUMP{cr}
 ECHR 'C'               \                {lower case}F0{sentence case}{tab 6}
 ETWO 'L', 'O'          \                FRONT VIEW{cr}
 ECHR 'C'               \                {lower case}F1{sentence case}{tab 6}
 ECHR 'K'               \                REAR VIEW{cr}
 ECHR 'W'               \                {lower case}F2{sentence case}{tab 6}
 ECHR 'I'               \                LEFT VIEW{cr}
 ETWO 'S', 'E'          \                {lower case}F3{sentence case}{tab 6}
 ECHR ' '               \                RIGHT VIEW{cr}"
 ECHR 'R'               \
 ECHR 'O'               \ Encoded as:   "{12}FLIGHT C<223>TROLS<215><{8}<255>
 ECHR 'L'               \                <251>-C<224>CKWI<218> ROLL{12}>{8}C
 ECHR 'L'               \                <224>CKWI<218> ROLL{12}S{8}<241><250>
 EJMP 12                \                {12}X{8}CLIMB{12}{1}SPC{2}{8}<240>C
 ECHR '>'               \                <242>A<218> SPE<252>{12}?{8}DEC<242>A
 EJMP 8                 \                <218> SPE<252>{12}{1}T<216>{2}{8}HYP
 ECHR 'C'               \                <244>SPA<233> <237>CAPE{12}{1}<237>C{2}
 ETWO 'L', 'O'          \                {8}<237>CAPE CAPSU<229>{12}F{8}TOGG
 ECHR 'C'               \                <229> COMPASS{12}V{8}{4}[115]{5} <223>
 ECHR 'K'               \                {12}P{8}{4}[115]{5} OFF{12}J{8}MICROJUM
 ECHR 'W'               \                P{12}{13}F0{2}{8}FR<223>T VIEW{12}{13}
 ECHR 'I'               \                F1{2}{8}<242><238> VIEW{12}{13}F2{2}{8}
 ETWO 'S', 'E'          \                <229>FT VIEW{12}{13}F3{2}{8}RIGHT VIEW
 ECHR ' '               \                {12}"
ELIF _ELITE_A_6502SP_PARA
 ECHR 'S'               \                V{tab 6} DOCKING COMPUTERS ON{cr}
 ETWO '-', '-'          \                P{tab 6} DOCKING COMPUTERS OFF{cr}
 ECHR '<'               \                J{tab 6}MICROJUMP{cr}
 EJMP 8                 \                {lower case}F0{sentence case}{tab 6}
 ETWO 'A', 'N'          \                FRONT VIEW{cr}
 ETWO 'T', 'I'          \                {lower case}F1{sentence case}{tab 6}
 ECHR '-'               \                REAR VIEW{cr}
 ECHR 'C'               \                {lower case}F2{sentence case}{tab 6}
 ETWO 'L', 'O'          \                LEFT VIEW{cr}
 ECHR 'C'               \                {lower case}F3{sentence case}{tab 6}
 ECHR 'K'               \                RIGHT VIEW{cr}"
 ECHR 'W'               \
 ECHR 'I'               \ Encoded as:   "{12}FLIGHT C<223>TROLS<215><{8}<255>
 ETWO 'S', 'E'          \                <251>-C<224>CKWI<218> ROLL{12}>{8}C
 ECHR ' '               \                <224>CKWI<218> ROLL{12}S{8}<241><250>
 ECHR 'R'               \                {12}X{8}CLIMB{12}{1}SPC{2}{8}<240>C
 ECHR 'O'               \                <242>A<218> SPE<252>{12}?{8}DEC<242>A
 ECHR 'L'               \                <218> SPE<252>{12}{1}T<216>{2}{8}HYP
 ECHR 'L'               \                <244>SPA<233> <237>CAPE{12}{1}<237>C{2}
 EJMP 12                \                {8}<237>CAPE CAPSU<229>{12}F{8}TOGG
 ECHR '>'               \                <229> COMPASS{12}V{8}DOCK[195]COMPUT
 EJMP 8                 \                <244>S <223>{12}P{8}DOCK[195]COMPUT
 ECHR 'C'               \                <244>S OFF{12}J{8}MICROJUMP{12}{13}F0
 ETWO 'L', 'O'          \                {2}{8}FR<223>T VIEW{12}{13}F1{2}{8}
 ECHR 'C'               \                <242><238> VIEW{12}{13}F2{2}{8}<229>FT
 ECHR 'K'               \                 VIEW{12}{13}F3{2}{8}RIGHT VIEW{12}"
 ECHR 'W'
 ECHR 'I'
 ETWO 'S', 'E'
 ECHR ' '
ENDIF
 ECHR 'R'
 ECHR 'O'
 ECHR 'L'
 ECHR 'L'
 EJMP 12
 ECHR 'S'
 EJMP 8
 ETWO 'D', 'I'
 ETWO 'V', 'E'
 EJMP 12
 ECHR 'X'
 EJMP 8
 ECHR 'C'
 ECHR 'L'
 ECHR 'I'
 ECHR 'M'
 ECHR 'B'
 EJMP 12
 EJMP 1
 ECHR 'S'
 ECHR 'P'
 ECHR 'C'
 EJMP 2
 EJMP 8
 ETWO 'I', 'N'
 ECHR 'C'
 ETWO 'R', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'E'
 ETWO 'E', 'D'
 EJMP 12
 ECHR '?'
 EJMP 8
 ECHR 'D'
 ECHR 'E'
 ECHR 'C'
 ETWO 'R', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'E'
 ETWO 'E', 'D'
 EJMP 12
 EJMP 1
 ECHR 'T'
 ETWO 'A', 'B'
 EJMP 2
 EJMP 8
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 EJMP 12
 EJMP 1
 ETWO 'E', 'S'
 ECHR 'C'
 EJMP 2
 EJMP 8
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'S'
 ECHR 'U'
 ETWO 'L', 'E'
 EJMP 12
 ECHR 'F'
 EJMP 8
 ECHR 'T'
 ECHR 'O'
 ECHR 'G'
 ECHR 'G'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
 EJMP 12
 ECHR 'V'
 EJMP 8
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 4
 TOKN 115
 EJMP 5
 ECHR ' '
ELIF _ELITE_A_6502SP_PARA
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 195
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR ' '
ENDIF
 ETWO 'O', 'N'
 EJMP 12
 ECHR 'P'
 EJMP 8
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 4
 TOKN 115
 EJMP 5
ELIF _ELITE_A_6502SP_PARA
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 195
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
ENDIF
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 EJMP 12
 ECHR 'J'
 EJMP 8
 ECHR 'M'
 ECHR 'I'
 ECHR 'C'
 ECHR 'R'
 ECHR 'O'
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '0'
 EJMP 2
 EJMP 8
 ECHR 'F'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'W'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '1'
 EJMP 2
 EJMP 8
 ETWO 'R', 'E'
 ETWO 'A', 'R'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'W'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '2'
 EJMP 2
 EJMP 8
 ETWO 'L', 'E'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'W'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '3'
 EJMP 2
 EJMP 8
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'W'
 EJMP 12
 EQUB VE

 EJMP 12                \ Token 88:     "{cr}
 ECHR 'C'               \                COMBAT CONTROLS{crlf}
 ECHR 'O'               \                A{tab 6}FIRE LASER{cr}
IF _ELITE_A_ENCYCLOPEDIA
 ECHR 'M'               \                T{tab 6}TARGET {standard tokens,
 ECHR 'B'               \                sentence case} MISSILE{extended
 ETWO 'A', 'T'          \                tokens}{cr}
 ECHR ' '               \                M{tab 6}FIRE {standard tokens, sentence
 ECHR 'C'               \                case} MISSILE{extended tokens}{cr}
 ETWO 'O', 'N'          \                U{tab 6}UNARM {standard tokens,
 ECHR 'T'               \                sentence case} MISSILE{extended
 ECHR 'R'               \                tokens}{cr}
 ECHR 'O'               \                E{tab 6}TRIGGER E.C.M.{cr}
 ECHR 'L'               \                {cr}
 ECHR 'S'               \                I.F.F. COLOUR CODES{crlf}
 ETWO '-', '-'          \                WHITE{tab 16}OFFICIAL SHIP{cr}
 ECHR 'A'               \                BLUE{tab 16}LEGAL SHIP{cr}
 EJMP 8                 \                BLUE/{single cap}WHITE{tab 16}DEBRIS
 ECHR 'F'               \                {cr}
 ECHR 'I'               \                BLUE/{single cap}RED{tab 16}
 ETWO 'R', 'E'          \                NON-RESPONDENT{cr}
 ECHR ' '               \                WHITE/{single cap}RED{tab 16}{standard
 ETWO 'L', 'A'          \                tokens, sentence case} MISSILE{extended
 ETWO 'S', 'E'          \                tokens}{cr}"
 ECHR 'R'               \
 EJMP 12                \ Encoded as:   "{12}COMB<245> C<223>TROLS<215>A{8}FI
 ECHR 'T'               \                <242> <249><218>R{12}T{8}T<238>G<221>
 EJMP 8                 \                 {4}[106]{5}{12}M{8}FI<242> {4}[106]{5}
 ECHR 'T'               \                {12}U{8}UN<238>M {4}[106]{5}{12}E{8}TRI
 ETWO 'A', 'R'          \                G<231>R E.C.M.{12}{12}I.F.F. COL<217>R
 ECHR 'G'               \                 COD<237><215>WH<219>E{22}OFFICI<228>
 ETWO 'E', 'T'          \                 [207]{12}BLUE{22}<229>G<228> [207]{12}
 ECHR ' '               \                BLUE/{19}WH<219>E{22}DEBRIS{12}BLUE/
 EJMP 4                 \                {19}<242>D{22}N<223>-R<237>P<223>D<246>
 TOKN 106               \                T{12}WH<219>E/{19}<242>D{22}{4}[106]{5}
 EJMP 5                 \                {12}"
ELIF _ELITE_A_6502SP_PARA
 ECHR 'M'               \                T{tab 6}TARGET MISSILES{cr}
 ECHR 'B'               \                M{tab 6}FIRE MISSILES{cr}
 ETWO 'A', 'T'          \                U{tab 6}UNARM MISSILES{cr}
 ECHR ' '               \                E{tab 6}TRIGGER E.C.M.{cr}
 ECHR 'C'               \                {cr}
 ETWO 'O', 'N'          \                I.F.F. COLOUR CODES{crlf}
 ECHR 'T'               \                WHITE      OFFICIAL SHIP{cr}
 ECHR 'R'               \                BLUE       LEGAL SHIP{cr}
 ECHR 'O'               \                BLUE/{single cap}WHITE DEBRIS{cr}
 ECHR 'L'               \                WHITE/{single cap}RED  MISSILES{cr}"
 ECHR 'S'               \
 ETWO '-', '-'          \ Encoded as:   "{12}COMB<245> C<223>TROLS<215>A{8}FI
 ECHR 'A'               \                <242> <249><218>R{12}ENDIFT{8}T<238>G
 EJMP 8                 \                <221> MISS<220><237>{12}M{8}FI<242> MIS
 ECHR 'F'               \                S<220><237>{12}U{8}UN<238>M MISS<220>
 ECHR 'I'               \                <237>{12}E{8}TRIG<231>R E.C.M.{12}{12}I
 ETWO 'R', 'E'          \                .F.F. COL<217>R COD<237><215>WH<219>E
 ECHR ' '               \                      OFFICI<228> [207]{12}BLUE
 ETWO 'L', 'A'          \                       <229>G<228> [207]{12}BLUE/{19}
 ETWO 'S', 'E'          \                WH<219>E DEBRIS{12}BLUE/{19}<242>D
 ECHR 'R'               \                   N<223>-R<237>P<223>D<246>T{12}WH
 EJMP 12                \                <219>E/{19}<242>D  MISS<220><237>{12}"
 ECHR 'T'
 EJMP 8
 ECHR 'T'
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
ENDIF
 EJMP 12
 ECHR 'M'
 EJMP 8
 ECHR 'F'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 4
 TOKN 106
 EJMP 5
ELIF _ELITE_A_6502SP_PARA
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
ENDIF
 EJMP 12
 ECHR 'U'
 EJMP 8
 ECHR 'U'
 ECHR 'N'
 ETWO 'A', 'R'
 ECHR 'M'
 ECHR ' '
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 4
 TOKN 106
 EJMP 5
ELIF _ELITE_A_6502SP_PARA
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
ENDIF
 EJMP 12
 ECHR 'E'
 EJMP 8
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ETWO 'G', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'E'
 ECHR '.'
 ECHR 'C'
 ECHR '.'
 ECHR 'M'
 ECHR '.'
 EJMP 12
 EJMP 12
 ECHR 'I'
 ECHR '.'
 ECHR 'F'
 ECHR '.'
 ECHR 'F'
 ECHR '.'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'D'
 ETWO 'E', 'S'
 ETWO '-', '-'
 ECHR 'W'
 ECHR 'H'
 ETWO 'I', 'T'
 ECHR 'E'
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 22
ELIF _ELITE_A_6502SP_PARA
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
ENDIF
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ECHR 'I'
 ECHR 'C'
 ECHR 'I'
 ETWO 'A', 'L'
 ECHR ' '
 ETOK 207
 EJMP 12
 ECHR 'B'
 ECHR 'L'
 ECHR 'U'
 ECHR 'E'
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 22
ELIF _ELITE_A_6502SP_PARA
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
 ECHR ' '
ENDIF
 ETWO 'L', 'E'
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR ' '
 ETOK 207
 EJMP 12
 ECHR 'B'
 ECHR 'L'
 ECHR 'U'
 ECHR 'E'
 ECHR '/'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'I', 'T'
 ECHR 'E'
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 22
ELIF _ELITE_A_6502SP_PARA
 ECHR ' '
ENDIF
 ECHR 'D'
 ECHR 'E'
 ECHR 'B'
 ECHR 'R'
 ECHR 'I'
 ECHR 'S'
 EJMP 12
 ECHR 'B'
 ECHR 'L'
 ECHR 'U'
 ECHR 'E'
 ECHR '/'
 EJMP 19
 ETWO 'R', 'E'
 ECHR 'D'
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 22
ELIF _ELITE_A_6502SP_PARA
 ECHR ' '
 ECHR ' '
 ECHR ' '
ENDIF
 ECHR 'N'
 ETWO 'O', 'N'
 ECHR '-'
 ECHR 'R'
 ETWO 'E', 'S'
 ECHR 'P'
 ETWO 'O', 'N'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR 'T'
 EJMP 12
 ECHR 'W'
 ECHR 'H'
 ETWO 'I', 'T'
 ECHR 'E'
 ECHR '/'
 EJMP 19
 ETWO 'R', 'E'
 ECHR 'D'
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 22
 EJMP 4
 TOKN 106
 EJMP 5
ELIF _ELITE_A_6502SP_PARA
 ECHR ' '
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
ENDIF
 EJMP 12
 EQUB VE

 EJMP 12                \ Token 89:     "{cr}
 ECHR 'N'               \                NAVIGATION CONTROLS{crlf}
 ECHR 'A'               \                H{tab 6}HYPERSPACE JUMP{cr}
IF _ELITE_A_ENCYCLOPEDIA
 ECHR 'V'               \                C-{single cap}H{tab 6}{standard tokens,
 ECHR 'I'               \                sentence case} GALACTIC HYPERSPACE
 ECHR 'G'               \                {extended tokens}{cr}
 ETWO 'A', 'T'          \                CURSOR KEYS{cr}
 ECHR 'I'               \                {tab 6}HYPERSPACE CURSOR CONTROL{cr}
 ETWO 'O', 'N'          \                D{tab 6}DISTANCE TO SYSTEM{cr}
 ECHR ' '               \                O{tab 6}HOME CURSOR{cr}
 ECHR 'C'               \                F{tab 6}FIND SYSTEM ({single cap}DOCKED
 ETWO 'O', 'N'          \                ){cr}
 ECHR 'T'               \                W{tab 6}FIND DESTINATION SYSTEM{cr}
 ECHR 'R'               \                {lower case}F4{sentence case}{tab 6}
 ECHR 'O'               \                GALACTIC MAP{cr}
 ECHR 'L'               \                {lower case}F5{sentence case}{tab 6}
 ECHR 'S'               \                SHORT RANGE MAP{cr}
 ETWO '-', '-'          \                {lower case}F6{sentence case}{tab 6}
 ECHR 'H'               \                DATA ON PLANET{cr}"
 EJMP 8                 \
 ECHR 'H'               \ Encoded as:   "{12}NAVIG<245>I<223> C<223>TROLS<215>H
 ECHR 'Y'               \                {8}HYP<244>SPA<233> JUMP{12}C-{19}H{8}
 ECHR 'P'               \                {4}[116]{5}{12}CUR<235>R KEYS{12}{8}HYP
 ETWO 'E', 'R'          \                <244>SPA<233> CUR<235>R C<223>TROL{12}D
 ECHR 'S'               \                {8}<241><222><255><233>[201]SY<222>EM
 ECHR 'P'               \                {12}O{8}HOME CUR<235>R{12}F{8}F<240>D S
 ECHR 'A'               \                Y<222>EM ({19}[205]){12}W{8}F<240>D DE
 ETWO 'C', 'E'          \                <222><240><245>I<223> SY<222>EM{12}{13}
 ECHR ' '               \                F4{2}{8}G<228>AC<251>C <239>P{12}{13}F5
 ECHR 'J'               \                {2}{8}SH<253>T <248>N<231> <239>P{12}
 ECHR 'U'               \                {13}F6{2}{8}D<245>A <223> [145]{12}"
 ECHR 'M'
 ECHR 'P'
 EJMP 12
ELIF _ELITE_A_6502SP_PARA
 ECHR 'V'               \                C-{single cap}H{tab 6}GALACTIC
 ECHR 'I'               \                HYPERSPACE JUMP
 ECHR 'G'               \                CURSOR KEYS{cr}
 ETWO 'A', 'T'          \                {tab 6}HYPERSPACE CURSOR CONTROL{cr}
 ECHR 'I'               \                D{tab 6}DISTANCE TO SYSTEM{cr}
 ETWO 'O', 'N'          \                O{tab 6}HOME CURSOR{cr}
 ECHR ' '               \                F{tab 6}FIND SYSTEM ({single cap}DOCKED
 ECHR 'C'               \                ){cr}
 ETWO 'O', 'N'          \                W{tab 6}FIND DESTINATION SYSTEM{cr}
 ECHR 'T'               \                {lower case}F4{sentence case}{tab 6}
 ECHR 'R'               \                GALACTIC MAP{cr}
 ECHR 'O'               \                {lower case}F5{sentence case}{tab 6}
 ECHR 'L'               \                SHORT RANGE MAP{cr}
 ECHR 'S'               \                {lower case}F6{sentence case}{tab 6}
 ETWO '-', '-'          \                DATA ON PLANET{cr}"
 ECHR 'H'               \
 EJMP 8                 \ Encoded as:   "{12}NAVIG<245>I<223> C<223>TROLS<215>H
 ECHR 'H'               \                {8}HYP<244>SPA<233> JUMP{12}C-{19}H{8}G
 ECHR 'Y'               \                <228>AC<251>C HYP<244>SPA<233> JUMP{12}
 ECHR 'P'               \                CUR<235>R KEYS{12}{8}HYP<244>SPA<233> C
 ETWO 'E', 'R'          \                UR<235>R C<223>TROL{12}D{8}<241><222>
 ECHR 'S'               \                <255><233>[201]SY<222>EM{12}O{8}HOME CU
 ECHR 'P'               \                R<235>R{12}F{8}F<240>D SY<222>EM ({19}
 ECHR 'A'               \                [205]){12}W{8}F<240>D DE<222><240><245>
 ETWO 'C', 'E'          \                I<223> SY<222>EM{12}{13}F4{2}{8}G<228>A
 ECHR ' '               \                C<251>C <239>P{12}{13}F5{2}{8}SH<253>T
 ECHR 'J'               \                 <248>N<231> <239>P{12}{13}F6{2}{8}D
 ECHR 'U'               \                <245>A <223> [145]{12}"
 ECHR 'M'
 ECHR 'P'
 EJMP 12
ENDIF
 ECHR 'C'
 ECHR '-'
 EJMP 19
 ECHR 'H'
 EJMP 8
IF _ELITE_A_ENCYCLOPEDIA
 EJMP 4
 TOKN 116
 EJMP 5
ELIF _ELITE_A_6502SP_PARA
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
ENDIF
 EJMP 12
 ECHR 'C'
 ECHR 'U'
 ECHR 'R'
 ETWO 'S', 'O'
 ECHR 'R'
 ECHR ' '
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 ECHR 'S'
 EJMP 12
 EJMP 8
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'U'
 ECHR 'R'
 ETWO 'S', 'O'
 ECHR 'R'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'L'
 EJMP 12
 ECHR 'D'
 EJMP 8
 ETWO 'D', 'I'
 ETWO 'S', 'T'
 ETWO 'A', 'N'
 ETWO 'C', 'E'
 ETOK 201
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 EJMP 12
 ECHR 'O'
 EJMP 8
 ECHR 'H'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'U'
 ECHR 'R'
 ETWO 'S', 'O'
 ECHR 'R'
 EJMP 12
 ECHR 'F'
 EJMP 8
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR '('
 EJMP 19
 ETOK 205
 ECHR ')'
 EJMP 12
 ECHR 'W'
 EJMP 8
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ETWO 'S', 'T'
 ETWO 'I', 'N'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '4'
 EJMP 2
 EJMP 8
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'P'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '5'
 EJMP 2
 EJMP 8
 ECHR 'S'
 ECHR 'H'
 ETWO 'O', 'R'
 ECHR 'T'
 ECHR ' '
 ETWO 'R', 'A'
 ECHR 'N'
 ETWO 'G', 'E'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'P'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '6'
 EJMP 2
 EJMP 8
 ECHR 'D'
 ETWO 'A', 'T'
 ECHR 'A'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR ' '
 ETOK 145
 EJMP 12
 EQUB VE

 EJMP 12                \ Token 90:     "{cr}
 ECHR 'T'               \                TRADING CONTROLS{crlf}
 ETWO 'R', 'A'          \                {lower case}F0{sentence case}{tab 6}
 ECHR 'D'               \                LAUNCH FROM STATION{cr}
 ETOK 195               \                C-F0{sentence case}{tab 6}REMAIN DOCKED
 ECHR 'C'               \                {cr}
 ETWO 'O', 'N'          \                {lower case}F1{sentence case}{tab 6}BUY
 ECHR 'T'               \                CARGO{cr}
 ECHR 'R'               \                C-F1{tab 6}BUY SPECIAL CARGO{cr}
 ECHR 'O'               \                {lower case}F2{sentence case}{tab 6}
 ECHR 'L'               \                SELL CARGO{cr}
 ECHR 'S'               \                C-F2{tab 6}SELL EQUIPMENT{cr}
 ETWO '-', '-'          \                {lower case}F3{sentence case}{tab 6}
 EJMP 13                \                EQUIP SHIP{cr}
 ECHR 'F'               \                C-F3{tab 6}BUY SHIP{cr}
 ECHR '0'               \                C-F6{tab 6}ENCYCLOPEDIA{cr}
 EJMP 2                 \                {lower case}F7{sentence case}{tab 6}
 EJMP 8                 \                MARKET PRICES{cr}
 ETWO 'L', 'A'          \                {lower case}F8{sentence case}{tab 6}
 ECHR 'U'               \                STATUS PAGE{cr}
 ECHR 'N'               \                {lower case}F9{sentence case}{tab 6}
 ECHR 'C'               \                INVENTORY{cr}"
 ECHR 'H'               \
 ECHR ' '               \ Encoded as:   "{12}T<248>D[195]C<223>TROLS<215>{13}F0
 ECHR 'F'               \                {2}{8}<249>UNCH FROM <222><245>I<223>
 ECHR 'R'               \                {12}C-F0{2}{8}<242><239><240> [205]{12}
 ECHR 'O'               \                {13}F1{2}{8}BUY C<238>GO{12}C-F1{8}BUY
 ECHR 'M'               \                 SPECI<228> C<238>GO{12}{13}F2{2}{8}
 ECHR ' '               \                <218>LL C<238>GO{12}C-F2{8}<218>LL EQUI
 ETWO 'S', 'T'          \                PMENT{12}{13}F3{2}{8}EQUIP [207]{12}C-F
 ETWO 'A', 'T'          \                3{8}BUY [207]{12}C-F6{8}<246>CYC<224>P
 ECHR 'I'               \                <252>IA{12}{13}F7{2}{8}M<238>K<221> PRI
 ETWO 'O', 'N'          \                <233>S{12}{13}F8{2}{8}<222><245><236> P
 EJMP 12                \                A<231>{12}{13}F9{2}{8}<240>V<246>T<253>
 ECHR 'C'               \                Y{12}"
 ECHR '-'
 ECHR 'F'
 ECHR '0'
 EJMP 2
 EJMP 8
 ETWO 'R', 'E'
 ETWO 'M', 'A'
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 205
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '1'
 EJMP 2
 EJMP 8
 ECHR 'B'
 ECHR 'U'
 ECHR 'Y'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 EJMP 12
 ECHR 'C'
 ECHR '-'
 ECHR 'F'
 ECHR '1'
 EJMP 8
 ECHR 'B'
 ECHR 'U'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'E'
 ECHR 'C'
 ECHR 'I'
 ETWO 'A', 'L'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '2'
 EJMP 2
 EJMP 8
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 EJMP 12
 ECHR 'C'
 ECHR '-'
 ECHR 'F'
 ECHR '2'
 EJMP 8
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'E'
 ECHR 'Q'
 ECHR 'U'
 ECHR 'I'
 ECHR 'P'
 ECHR 'M'
 ECHR 'E'
 ECHR 'N'
 ECHR 'T'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '3'
 EJMP 2
 EJMP 8
 ECHR 'E'
 ECHR 'Q'
 ECHR 'U'
 ECHR 'I'
 ECHR 'P'
 ECHR ' '
 ETOK 207
 EJMP 12
 ECHR 'C'
 ECHR '-'
 ECHR 'F'
 ECHR '3'
 EJMP 8
 ECHR 'B'
 ECHR 'U'
 ECHR 'Y'
 ECHR ' '
 ETOK 207
 EJMP 12
 ECHR 'C'
 ECHR '-'
 ECHR 'F'
 ECHR '6'
 EJMP 8
 ETWO 'E', 'N'
 ECHR 'C'
 ECHR 'Y'
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'P'
 ETWO 'E', 'D'
 ECHR 'I'
 ECHR 'A'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '7'
 EJMP 2
 EJMP 8
 ECHR 'M'
 ETWO 'A', 'R'
 ECHR 'K'
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ECHR 'I'
 ETWO 'C', 'E'
 ECHR 'S'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '8'
 EJMP 2
 EJMP 8
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ETWO 'U', 'S'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ETWO 'G', 'E'
 EJMP 12
 EJMP 13
 ECHR 'F'
 ECHR '9'
 EJMP 2
 EJMP 8
 ETWO 'I', 'N'
 ECHR 'V'
 ETWO 'E', 'N'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR 'Y'
 EJMP 12
 EQUB VE

 ECHR 'F'               \ Token 91:     "FLIGHT"
 ECHR 'L'               \
 ECHR 'I'               \ Encoded as:   "FLIGHT"
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 EQUB VE

 ECHR 'C'               \ Token 92:     "COMBAT"
 ECHR 'O'               \
 ECHR 'M'               \ Encoded as:   "COMB<245>"
 ECHR 'B'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'N'               \ Token 93:     "NAVIGATION"
 ECHR 'A'               \
 ECHR 'V'               \ Encoded as:   "NAVIG<245>I<223>"
 ECHR 'I'
 ECHR 'G'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'T'               \ Token 94:     "TRADING"
 ETWO 'R', 'A'          \
 ECHR 'D'               \ Encoded as:   "T<248>D<240>G"
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

IF _ELITE_A_ENCYCLOPEDIA

 EJMP 4                 \ Token 95:     "{standard tokens, sentence case}MISSILE
 TOKN 106               \                {extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[106]{5}"

 EJMP 4                 \ Token 96:     "{standard tokens, sentence case}I.F.F.
 TOKN 107               \                SYSTEM{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[107]{5}"

 EJMP 4                 \ Token 97:     "{standard tokens, sentence case}
 TOKN 108               \                E.C.M.SYSTEM{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[108]{5}"

 EJMP 4                 \ Token 98:     "{standard tokens, sentence case}PULSE
 TOKN 103               \                LASER{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[103]{5}"

 EJMP 4                 \ Token 99:     "{standard tokens, sentence case}BEAM
 TOKN 104               \                LASER{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[104]{5}"

 EJMP 4                 \ Token 100:    "{standard tokens, sentence case}FUEL
 TOKN 111               \                SCOOPS{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[111]{5}"

 EJMP 4                 \ Token 101:    "{standard tokens, sentence case}ESCAPE
 TOKN 112               \                POD{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[112]{5}"

 EJMP 4                 \ Token 102:    "{standard tokens, sentence case}
 TOKN 113               \                HYPERSPACE UNIT{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[113]{5}"

 EJMP 4                 \ Token 103:    "{standard tokens, sentence case}ENERGY
 TOKN 114               \                UNIT{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[114]{5}"

 EJMP 4                 \ Token 104:    "{standard tokens, sentence case}DOCKING
 TOKN 115               \                COMPUTERS{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[115]{5}"

 EJMP 4                 \ Token 105:    "{standard tokens, sentence case}
 TOKN 116               \                GALACTIC HYPERSPACE {extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[116]{5}"

 EJMP 4                 \ Token 106:    "{standard tokens, sentence case}
 TOKN 117               \                MILITARY LASER{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[117]{5}"

 EJMP 4                 \ Token 107:    "{standard tokens, sentence case}
 TOKN 118               \                MINING LASER{extended tokens}"
 EJMP 5                 \
 EQUB VE                \ Encoded as:   "{4}[118]{5}"

ELIF _ELITE_A_6502SP_PARA

 ECHR 'M'               \ Token 95:     "MISSILES"
 ECHR 'I'               \
 ECHR 'S'               \ Encoded as:   "MISS<220><237>"
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
 EQUB VE

 EJMP 1                 \ Token 96:     "{all caps}I.F.F.{lower case} SYSTEM"
 ECHR 'I'               \
 ECHR '.'               \ Encoded as:   "{1}I.F.F.{13} SY<222>EM"
 ECHR 'F'
 ECHR '.'
 ECHR 'F'
 ECHR '.'
 EJMP 13
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 EQUB VE

 EJMP 1                 \ Token 97:     "{all caps}E.C.M.{lower case} SYSTEM"
 ECHR 'E'               \
 ECHR '.'               \ Encoded as:   "{1}E.C.M.{13} SY<222>EM"
 ECHR 'C'
 ECHR '.'
 ECHR 'M'
 ECHR '.'
 EJMP 13
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 EQUB VE

 ECHR 'P'               \ Token 98:     "PULSE LASERS"
 ECHR 'U'               \
 ECHR 'L'               \ Encoded as:   "PUL<218> <249><218>RS"
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

 ETWO 'B', 'E'          \ Token 99:     "BEAM LASERS"
 ECHR 'A'               \
 ECHR 'M'               \ Encoded as:   "<247>AM <249><218>RS"
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'F'               \ Token 100:    "FUEL SCOOPS"
 ECHR 'U'               \
 ECHR 'E'               \ Encoded as:   "FUEL SCOOPS"
 ECHR 'L'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'O'
 ECHR 'O'
 ECHR 'P'
 ECHR 'S'
 EQUB VE

 ETWO 'E', 'S'          \ Token 101:    "ESCAPE POD"
 ECHR 'C'               \
 ECHR 'A'               \ Encoded as:   "<237>CAPE POD"
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'D'
 EQUB VE

 ECHR 'H'               \ Token 102:    "HYPERSPACE UNIT"
 ECHR 'Y'               \
 ECHR 'P'               \ Encoded as:   "HYP<244>SPA<233> UN<219>"
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 EQUB VE

 ETWO 'E', 'N'          \ Token 103:    "ENERGY UNIT"
 ETWO 'E', 'R'          \
 ECHR 'G'               \ Encoded as:   "<246><244>GY UN<219>"
 ECHR 'Y'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 EQUB VE

 ECHR 'D'               \ Token 104:    "DOCKING COMPUTERS"
 ECHR 'O'               \
 ECHR 'C'               \ Encoded as:   "DOCK[195]COMPUT<244>S"
 ECHR 'K'
 ETOK 195
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'G'               \ Token 105:    "GALACTIC HYPERDRIVE"
 ETWO 'A', 'L'          \
 ECHR 'A'               \ Encoded as:   "G<228>AC<251>C HYP<244>[151]"
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ETOK 151
 EQUB VE

 ECHR 'M'               \ Token 106:    "MILITARY LASERS"
 ETWO 'I', 'L'          \
 ETWO 'I', 'T'          \ Encoded as:   "M<220><219><238>Y <249><218>RS"
 ETWO 'A', 'R'
 ECHR 'Y'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'M'               \ Token 107:    "MINING LASERS"
 ETWO 'I', 'N'          \
 ETOK 195               \ Encoded as:   "M<240>[195]<249><218>RS"
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

ENDIF

 EJMP 14                \ Token 108:    "{justify}{single cap}SELF HOMING
 EJMP 19                \                MISSILES MAY BE BOUGHT AT ANY SYSTEM.
 ETWO 'S', 'E'          \                {crlf}
 ECHR 'L'               \                {single cap}BEFORE A MISSILE CAN BE
 ECHR 'F'               \                FIRED IT MUST BE LOCKED ONTO A TARGET.
 ECHR ' '               \                {crlf}
 ECHR 'H'               \                {single cap}WHEN FIRED, IT WILL HOME IN
 ECHR 'O'               \                TO THE TARGET UNLESS THE TARGET CAN
 ECHR 'M'               \                OUTMANOEUVRE THE MISSILE, SHOOT IT, OR
 ETOK 195               \                USE ELECTRONIC COUNTER MEASURES ON IT.
 ECHR 'M'               \                {cr}
 ECHR 'I'               \                {left align}"
 ECHR 'S'               \
 ECHR 'S'               \ Encoded as:   "{14}{19}<218>LF HOM[195]MISS<220><237>
 ETWO 'I', 'L'          \                 <239>Y <247> B<217>GHT <245> <255>Y SY
 ETWO 'E', 'S'          \                <222>EM.<215>{19}<247>FO<242>[208]MISS
 ECHR ' '               \                <220>E C<255> <247> FIR[196]<219> MU
 ETWO 'M', 'A'          \                <222> <247> <224>CK[196]<223>TO A T
 ECHR 'Y'               \                <238>G<221>.<215>{19}WH<246> FI<242>D,
 ECHR ' '               \                 <219> W<220>L HOME <240>[201][147]T
 ETWO 'B', 'E'          \                <238>G<221> UN<229>SS [147]T<238>G<221>
 ECHR ' '               \                 C<255> <217>T<239><227>EUV<242> [147]M
 ECHR 'B'               \                ISS<220>E, SHOOT <219>, <253> U<218> E
 ETWO 'O', 'U'          \                <229>CTR<223>IC C<217>NT<244> MEASUR
 ECHR 'G'               \                <237> <223> <219>[177]"
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'F'
 ECHR 'O'
 ETWO 'R', 'E'
 ETOK 208
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'N'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ECHR 'R'
 ETOK 196
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'M'
 ECHR 'U'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'L', 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 196
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ECHR 'A'
 ECHR ' '
 ECHR 'T'
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR ','
 ECHR ' '
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'H'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ETWO 'I', 'N'
 ETOK 201
 ETOK 147
 ECHR 'T'
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'L', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR ' '
 ETOK 147
 ECHR 'T'
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'N'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ETWO 'M', 'A'
 ETWO 'N', 'O'
 ECHR 'E'
 ECHR 'U'
 ECHR 'V'
 ETWO 'R', 'E'
 ECHR ' '
 ETOK 147
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ECHR 'E'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'O'
 ECHR 'O'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR ','
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'E'
 ETWO 'L', 'E'
 ECHR 'C'
 ECHR 'T'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR 'I'
 ECHR 'C'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ECHR 'A'
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ETWO 'E', 'S'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'I', 'T'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 109:    "{justify}{single cap}AN IDENTIFICATION
 EJMP 19                \                FRIEND OR FOE SYSTEM CAN BE OBTAINED AT
 ETWO 'A', 'N'          \                TECH LEVEL 2 OR ABOVE.{crlf}
 ECHR ' '               \                {single cap}AN {all caps}I.F.F.{lower
 ECHR 'I'               \                case} SYSTEM WILL DISPLAY DIFFERENT
 ECHR 'D'               \                TYPES OF OBJECT IN DIFFERENT COLOURS ON
 ETWO 'E', 'N'          \                THE RADAR DISPLAY.{crlf}
 ETWO 'T', 'I'          \                {single cap}SEE {single cap}CONTROLS
 ECHR 'F'               \                ({single cap}COMBAT).{cr}
 ECHR 'I'               \                {left align}"
 ECHR 'C'               \
 ETWO 'A', 'T'          \ Encoded as:   "{14}{19}<255> ID<246><251>FIC<245>I
 ECHR 'I'               \                <223> FRI<246>D <253> FOE SY<222>EM C
 ETWO 'O', 'N'          \                <255> <247> OBTA<240>[196]<245> TECH
 ECHR ' '               \                 <229><250>L 2 <253> <216>O<250>.<215>
 ECHR 'F'               \                {19}<255> {1}I.F.F.{13} SY<222>EM W
 ECHR 'R'               \                <220>L <241>SP<249>Y <241>FFE<242>NT TY
 ECHR 'I'               \                P<237> OF OBJECT <240> <241>FFE<242>NT
 ETWO 'E', 'N'          \                 COL<217>RS <223> [147]<248>D<238>
 ECHR 'D'               \                 <241>SP<249>Y.<215>{19}<218>E {19}C
 ECHR ' '               \                <223>TROLS ({19}COMB<245>)[177]"
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'F'
 ECHR 'O'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'N'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ETOK 196
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '2'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR 'O'
 ETWO 'V', 'E'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'A', 'N'
 ECHR ' '
 EJMP 1
 ECHR 'I'
 ECHR '.'
 ECHR 'F'
 ECHR '.'
 ECHR 'F'
 ECHR '.'
 EJMP 13
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'S'
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'Y'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'J'
 ECHR 'E'
 ECHR 'C'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR ' '
 ETOK 147
 ETWO 'R', 'A'
 ECHR 'D'
 ETWO 'A', 'R'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'S'
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'Y'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR ' '
 EJMP 19
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'L'
 ECHR 'S'
 ECHR ' '
 ECHR '('
 EJMP 19
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'B'
 ETWO 'A', 'T'
 ECHR ')'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 110:    "{justify}{single cap}AN ELECTRONIC
 EJMP 19                \                COUNTER MEASURES SYSTEM MAY BE BOUGHT
 ETWO 'A', 'N'          \                AT ANY SYSTEM OF TECH LEVEL 3 OR
 ECHR ' '               \                HIGHER.{crlf}
 ECHR 'E'               \                {single cap}WHEN ACTIVATED, THE {all
 ETWO 'L', 'E'          \                caps}E.C.M.{lower case} SYSTEM WILL
 ECHR 'C'               \                DISRUPT THE GUIDANCE SYSTEMS OF ALL
 ECHR 'T'               \                MISSILES IN THE VICINITY, MAKING THEM
 ECHR 'R'               \                SELF DESTRUCT.{cr}
 ETWO 'O', 'N'          \                {left align}"
 ECHR 'I'               \
 ECHR 'C'               \ Encoded as:   "{14}{19}<255> E<229>CTR<223>IC C<217>NT
 ECHR ' '               \                <244> MEASUR<237> SY<222>EM <239>Y
 ECHR 'C'               \                 <247> B<217>GHT <245> <255>Y SY<222>EM
 ETWO 'O', 'U'          \                 OF TECH <229><250>L 3 <253> HIGH<244>.
 ECHR 'N'               \                <215>{19}WH<246> AC<251>V<245><252>,
 ECHR 'T'               \                 [147]{1}E.C.M.{13} SY<222>EM W<220>L
 ETWO 'E', 'R'          \                 <241>SRUPT [147]GUID<255><233> SY<222>
 ECHR ' '               \                EMS OF <228>L MISS<220><237> <240>
 ECHR 'M'               \                 [147]VIC<240><219>Y, <239>K[195]<226>E
 ECHR 'E'               \                M <218>LF DE<222>RUCT[177]"
 ECHR 'A'
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'Y'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '3'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'V'
 ETWO 'A', 'T'
 ETWO 'E', 'D'
 ECHR ','
 ECHR ' '
 ETOK 147
 EJMP 1
 ECHR 'E'
 ECHR '.'
 ECHR 'C'
 ECHR '.'
 ECHR 'M'
 ECHR '.'
 EJMP 13
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'S'
 ECHR 'R'
 ECHR 'U'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETOK 147
 ECHR 'G'
 ECHR 'U'
 ECHR 'I'
 ECHR 'D'
 ETWO 'A', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'L'
 ETWO 'E', 'S'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 147
 ECHR 'V'
 ECHR 'I'
 ECHR 'C'
 ETWO 'I', 'N'
 ETWO 'I', 'T'
 ECHR 'Y'
 ECHR ','
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'K'
 ETOK 195
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'U'
 ECHR 'C'
 ECHR 'T'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 111:    "{justify}{single cap}PULSE LASERS ARE
 EJMP 19                \                FOR SALE AT TECH LEVEL 4 OR ABOVE.
 ECHR 'P'               \                {crlf}
 ECHR 'U'               \                {single cap}PULSE LASERS FIRE
 ECHR 'L'               \                INTERMITTENT LASER BEAMS.{cr}
 ETWO 'S', 'E'          \                {left align}"
 ECHR ' '               \
 ETWO 'L', 'A'          \ Encoded as:   "{14}{19}PUL<218> <249><218>RS <238>E
 ETWO 'S', 'E'          \                 F<253> S<228>E <245> TECH <229><250>L
 ECHR 'R'               \                 4 <253> <216>O<250>.<215>{19}PUL<218>
 ECHR 'S'               \                 <249><218>RS FI<242> <240>T<244>M<219>
 ECHR ' '               \                T<246>T <249><218>R <247>AMS[177]"
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'S'
 ETWO 'A', 'L'
 ECHR 'E'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '4'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR 'O'
 ETWO 'V', 'E'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'A'
 ECHR 'M'
 ECHR 'S'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 112:    "{justify}{single cap}BEAM LASERS ARE
 EJMP 19                \                AVAILABLE AT SYSTEMS OF TECH LEVEL 5 OR
 ETWO 'B', 'E'          \                HIGHER.{crlf}
 ECHR 'A'               \                {single cap}BEAM LASERS FIRE CONTINUOUS
 ECHR 'M'               \                LASER STRANDS, WITH MANY STRANDS IN
 ECHR ' '               \                PARALLEL.{crlf}
 ETWO 'L', 'A'          \                {single cap}BEAM LASERS OVERHEAT MORE
 ETWO 'S', 'E'          \                RAPIDLY THAN PULSE LASERS.{cr}
 ECHR 'R'               \                {left align}"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{14}{19}<247>AM <249><218>RS <238>E AVA
 ETWO 'A', 'R'          \                <220><216><229> <245> SY<222>EMS OF TEC
 ECHR 'E'               \                H <229><250>L 5 <253> HIGH<244>.<215>
 ECHR ' '               \                {19}<247>AM <249><218>RS FI<242> C<223>
 ECHR 'A'               \                <251><225><217>S <249><218>R <222><248>
 ECHR 'V'               \                NDS, W<219>H <239>NY <222><248>NDS
 ECHR 'A'               \                 <240> P<238><228><229>L.<215>{19}<247>
 ETWO 'I', 'L'          \                AM <249><218>RS OV<244>HE<245> MO<242>
 ETWO 'A', 'B'          \                 <248>PIDLY <226><255> PUL<218> <249>  
 ETWO 'L', 'E'          \                <218>RS[177]"
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '5'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'T', 'I'
 ETWO 'N', 'U'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'D'
 ECHR 'S'
 ECHR ','
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'Y'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'P'
 ETWO 'A', 'R'
 ETWO 'A', 'L'
 ETWO 'L', 'E'
 ECHR 'L'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'R', 'A'
 ECHR 'P'
 ECHR 'I'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'A', 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 113:    "{justify}{single cap}FUEL SCOOPS ENABLE
 EJMP 19                \                A SHIP TO OBTAIN FREE HYPERSPACE FUEL
 ECHR 'F'               \                BY 'SUN-SKIMMING' - FLYING CLOSE TO THE
 ECHR 'U'               \                SUN.{crlf}
 ECHR 'E'               \                {single cap}FUEL SCOOPS CAN ALSO BE
 ECHR 'L'               \                USED TO PICK UP SPACE DEBRIS, SUCH AS
 ECHR ' '               \                CARGO BARRELS OR ASTEROID FRAGMENTS.
 ECHR 'S'               \                {crlf}
 ECHR 'C'               \                {single cap}FUEL SCOOPS ARE AVAILABLE
 ECHR 'O'               \                FROM SYSTEMS OF TECH LEVEL 6 OR ABOVE.
 ECHR 'O'               \                {cr}
 ECHR 'P'               \                {left align}"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{14}{19}FUEL SCOOPS <246><216><229>
 ETWO 'E', 'N'          \                [208][207][201]OBTA<240> F<242>E HYP
 ETWO 'A', 'B'          \                <244>SPA<233> FUEL BY 'SUN-SKIMM<240>G'
 ETWO 'L', 'E'          \                 - FLY[195]C<224><218>[201][147]SUN.
 ETOK 208               \                <215>{19}FUEL SCOOPS C<255> <228><235>
 ETOK 207               \                 <247> <236>[196]TO PICK UP SPA<233> DE
 ETOK 201               \                BRIS, SUCH AS C<238>GO B<238><242>LS
 ECHR 'O'               \                 <253> A<222><244>OID F<248>GM<246>TS.
 ECHR 'B'               \                <215>{19}FUEL SCOOPS <238>E AVA<220>
 ECHR 'T'               \                <216><229> FROM SY<222>EMS OF TECH
 ECHR 'A'               \                 <229><250>L 6 <253> <216>O<250>[177]"
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'F'
 ETWO 'R', 'E'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'U'
 ECHR 'E'
 ECHR 'L'
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 ECHR ' '
 ECHR '`'
 ECHR 'S'
 ECHR 'U'
 ECHR 'N'
 ECHR '-'
 ECHR 'S'
 ECHR 'K'
 ECHR 'I'
 ECHR 'M'
 ECHR 'M'
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR '`'
 ECHR ' '
 ECHR '-'
 ECHR ' '
 ECHR 'F'
 ECHR 'L'
 ECHR 'Y'
 ETOK 195
 ECHR 'C'
 ETWO 'L', 'O'
 ETWO 'S', 'E'
 ETOK 201
 ETOK 147
 ECHR 'S'
 ECHR 'U'
 ECHR 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'F'
 ECHR 'U'
 ECHR 'E'
 ECHR 'L'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'O'
 ECHR 'O'
 ECHR 'P'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'N'
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'S', 'O'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'U', 'S'
 ETOK 196
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ECHR 'U'
 ECHR 'P'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'B'
 ECHR 'R'
 ECHR 'I'
 ECHR 'S'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR ' '
 ECHR 'B'
 ETWO 'A', 'R'
 ETWO 'R', 'E'
 ECHR 'L'
 ECHR 'S'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR ' '
 ECHR 'F'
 ETWO 'R', 'A'
 ECHR 'G'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'F'
 ECHR 'U'
 ECHR 'E'
 ECHR 'L'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'O'
 ECHR 'O'
 ECHR 'P'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'L'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '6'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR 'O'
 ETWO 'V', 'E'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 114:    "{justify}{single cap}AN ESCAPE POD IS
 EJMP 19                \                AN ESSENTIAL PIECE OF EQUIPMENT FOR
 ETWO 'A', 'N'          \                MOST SPACESHIPS.{crlf}
 ECHR ' '               \                {single cap}WHEN EJECTED, THE CAPSULE
 ETWO 'E', 'S'          \                WILL BE TRACKED TO THE NEAREST SPACE
 ECHR 'C'               \                STATION.{crlf}
 ECHR 'A'               \                {single cap}MOST ESCAPE PODS COME WITH
 ECHR 'P'               \                INSURANCE POLICIES TO REPLACE THE SHIP
 ECHR 'E'               \                AND EQUIPMENT.{crlf}
 ECHR ' '               \                {single cap}PENALTIES FOR INTERFERING
 ECHR 'P'               \                WITH ESCAPE PODS ARE SEVERE IN MOST
 ECHR 'O'               \                PLANETARY SYSTEMS.{crlf}
 ECHR 'D'               \                {single cap}ESCAPE PODS MAY BE BOUGHT
 ETOK 202               \                AT SYSTEMS OF TECH LEVEL 7 OR HIGHER.
 ETWO 'A', 'N'          \                {cr}
 ECHR ' '               \                {left align}"
 ETWO 'E', 'S'          \
 ETWO 'S', 'E'          \ Encoded as:   "{14}{19}<255> <237>CAPE POD[202]<255>
 ECHR 'N'               \                 <237><218>N<251><228> PIE<233> OF EQUI
 ETWO 'T', 'I'          \                PM<246>T F<253> MO<222> SPA<233>[207]S.
 ETWO 'A', 'L'          \                <215>{19}WH<246> EJECT<252>, [147]CAPSU
 ECHR ' '               \                <229> W<220>L <247> T<248>CK[196]TO
 ECHR 'P'               \                 [147]NE<238>E<222> SPA<233> <222><245>
 ECHR 'I'               \                I<223>.<215>{19}MO<222> <237>CAPE PODS
 ECHR 'E'               \                 COME W<219>H <240>SU<248>N<233> POLICI
 ETWO 'C', 'E'          \                <237>[201]<242>P<249><233> [147][207]
 ECHR ' '               \                [178]EQUIPM<246>T.<215>{19}P<246><228>
 ECHR 'O'               \                <251><237> F<253> <240>T<244>F<244>
 ECHR 'F'               \                [195]W<219>H <237>CAPE PODS <238>E 
 ECHR ' '               \                <218><250><242> <240> MO<222> [145]
 ECHR 'E'               \                <238>Y SY<222>EMS.<215>{19}<237>CAPE PO
 ECHR 'Q'               \                DS <239>Y <247> B<217>GHT <245> SY<222>
 ECHR 'U'               \                EMS OF TECH <229><250>L 7 <253> HIGH
 ECHR 'I'               \                <244>[177]"
 ECHR 'P'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ETOK 207
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'E'
 ECHR 'J'
 ECHR 'E'
 ECHR 'C'
 ECHR 'T'
 ETWO 'E', 'D'
 ECHR ','
 ECHR ' '
 ETOK 147
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'S'
 ECHR 'U'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'C'
 ECHR 'K'
 ETOK 196
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ETOK 147
 ECHR 'N'
 ECHR 'E'
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'A'
 ECHR 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'L'
 ECHR 'I'
 ECHR 'C'
 ECHR 'I'
 ETWO 'E', 'S'
 ETOK 201
 ETWO 'R', 'E'
 ECHR 'P'
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ETOK 147
 ETOK 207
 ETOK 178
 ECHR 'E'
 ECHR 'Q'
 ECHR 'U'
 ECHR 'I'
 ECHR 'P'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'P'
 ETWO 'E', 'N'
 ETWO 'A', 'L'
 ETWO 'T', 'I'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'F'
 ETWO 'E', 'R'
 ETOK 195
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'V', 'E'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ETOK 145
 ETWO 'A', 'R'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'Y'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '7'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ETWO 'E', 'R'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 115:    "{justify}{single cap}A RECENT
 EJMP 19                \                INVENTION, THE HYPERSPACE UNIT IS AN
 ECHR 'A'               \                ALTERNATIVE TO THE ESCAPE POD FOR MANY
 ECHR ' '               \                TRADERS.{crlf}
 ETWO 'R', 'E'          \                {single cap}WHEN TRIGGERED, THE
 ETWO 'C', 'E'          \                HYPERSPACE UNIT WILL USE ITS POWER IN
 ECHR 'N'               \                EXECUTING A HYPERJUMP AWAY FROM THE
 ECHR 'T'               \                CURRENT POSITION.{crlf}
 ECHR ' '               \                {single cap}UNFORTUNATELY, BECAUSE THE
 ETWO 'I', 'N'          \                HYPERJUMP IS INSTANTANEOUS, THERE IS NO
 ECHR 'V'               \                CONTROL OF THE DESTINATION POSITION.
 ETWO 'E', 'N'          \                {crlf}
 ETWO 'T', 'I'          \                {single cap}A HYPERSPACE UNIT IS
 ETWO 'O', 'N'          \                AVAILABLE AT TECH LEVEL 8 OR ABOVE.{cr}
 ECHR ','               \                {left align}"
 ECHR ' '               \
 ETOK 147               \ Encoded as:   "{14}{19}A <242><233>NT <240>V<246><251>
 ECHR 'H'               \                <223>, [147]HYP<244>SPA<233> UN<219>
 ECHR 'Y'               \                [202]<255> <228>T<244>N<245>I<250> TO
 ECHR 'P'               \                 [147]<237>CAPE POD F<253> <239>NY T
 ETWO 'E', 'R'          \                <248>D<244>S.<215>{19}WH<246> TRIG<231>
 ECHR 'S'               \                <242>D, [147]HYP<244>SPA<233> UN<219> W
 ECHR 'P'               \                <220>L U<218> <219>S POW<244> <240> E
 ECHR 'A'               \                <230>CUT[195]A HYP<244>JUMP AWAY FROM
 ETWO 'C', 'E'          \                 [147]CUR<242>NT POS<219>I<223>.<215>
 ECHR ' '               \                {19}UNF<253>TUN<245>ELY, <247>CAU<218>
 ECHR 'U'               \                 [147]HYP<244>JUMP[202]<240><222><255>T
 ECHR 'N'               \                <255>E<217>S, <226>E<242>[202]<227> C
 ETWO 'I', 'T'          \                <223>TROL OF [147]DE<222><240><245>I
 ETOK 202               \                <223> POS<219>I<223>.<215>{19}A HYP
 ETWO 'A', 'N'          \                <244>SPA<233> UN<219>[202]AVA<220><216>
 ECHR ' '               \                <229> <245> TECH <229><250>L 8 <253>
 ETWO 'A', 'L'          \                 <216>O<250>[177]"
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'N'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ETOK 147
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'Y'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ETWO 'G', 'E'
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR ','
 ECHR ' '
 ETOK 147
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'E'
 ETWO 'X', 'E'
 ECHR 'C'
 ECHR 'U'
 ECHR 'T'
 ETOK 195
 ECHR 'A'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ECHR ' '
 ECHR 'A'
 ECHR 'W'
 ECHR 'A'
 ECHR 'Y'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETOK 147
 ECHR 'C'
 ECHR 'U'
 ECHR 'R'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'U'
 ECHR 'N'
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR 'T'
 ECHR 'U'
 ECHR 'N'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR 'L'
 ECHR 'Y'
 ECHR ','
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'C'
 ECHR 'A'
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR ' '
 ETOK 147
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETOK 202
 ETWO 'I', 'N'
 ETWO 'S', 'T'
 ETWO 'A', 'N'
 ECHR 'T'
 ETWO 'A', 'N'
 ECHR 'E'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ','
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ETOK 202
 ETWO 'N', 'O'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'L'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 147
 ECHR 'D'
 ECHR 'E'
 ETWO 'S', 'T'
 ETWO 'I', 'N'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'A'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 ETOK 202
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'L'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '8'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR 'O'
 ETWO 'V', 'E'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 116:    "{justify}{single cap}AN ENERGY UNIT
 EJMP 19                \                INCREASES THE RATE OF RECHARGING OF THE
 ETWO 'A', 'N'          \                ENERGY BANKS FROM SURFACE RADIATION
 ECHR ' '               \                ABSORPTION.{crlf}
 ETWO 'E', 'N'          \                {single cap}ENERGY UNITS ARE AVAILABLE
 ETWO 'E', 'R'          \                FROM TECH LEVEL 9 UPWARDS.{cr}
 ECHR 'G'               \                {left align}"
 ECHR 'Y'               \
 ECHR ' '               \ Encoded as:   "{14}{19}<255> <246><244>GY UN<219>
 ECHR 'U'               \                 <240>C<242>A<218>S [147]R<245>E OF
 ECHR 'N'               \                 <242>CH<238>G[195]OF [147]<246><244>GY
 ETWO 'I', 'T'          \                 B<255>KS FROM SURFA<233> <248><241>
 ECHR ' '               \                <245>I<223> <216><235>RP<251><223>.
 ETWO 'I', 'N'          \                <215>{19}<246><244>GY UN<219>S <238>E
 ECHR 'C'               \                 AVA<220><216><229> FROM TECH <229>
 ETWO 'R', 'E'          \                <250>L 9 UPW<238>DS[177]"
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR 'S'
 ECHR ' '
 ETOK 147
 ECHR 'R'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ETOK 195
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 147
 ETWO 'E', 'N'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'Y'
 ECHR ' '
 ECHR 'B'
 ETWO 'A', 'N'
 ECHR 'K'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ECHR 'F'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ETWO 'R', 'A'
 ETWO 'D', 'I'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'S', 'O'
 ECHR 'R'
 ECHR 'P'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'E', 'N'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'Y'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'L'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '9'
 ECHR ' '
 ECHR 'U'
 ECHR 'P'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'D'
 ECHR 'S'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 117:    "{justify}{single cap}DOCKING COMPUTERS
 EJMP 19                \                ARE RECOMMENDED BY ALL PLANETARY
 ECHR 'D'               \                GOVERNMENTS AS A SAFE WAY OF REDUCING
 ECHR 'O'               \                THE NUMBER OF DOCKING ACCIDENTS.{crlf}
 ECHR 'C'               \                {single cap}DOCKING COMPUTERS WILL
 ECHR 'K'               \                AUTOMATICALLY DOCK A SHIP WHEN TURNED
 ETOK 195               \                ON.{crlf}
 ECHR 'C'               \                {single cap}DOCKING COMPUTERS CAN BE
 ECHR 'O'               \                BOUGHT AT SYSTEMS OF TECH LEVEL 10 OR
 ECHR 'M'               \                MORE.{cr}
 ECHR 'P'               \                {left align}"
 ECHR 'U'               \
 ECHR 'T'               \ Encoded as:   "{14}{19}DOCK[195]COMPUT<244>S <238>E
 ETWO 'E', 'R'          \                 <242>COMM<246>D[196]BY <228>L [145]
 ECHR 'S'               \                <238>Y GOV<244>NM<246>TS AS[208]SAFE WA
 ECHR ' '               \                Y OF <242>DUC[195][147]<225>MB<244> OF
 ETWO 'A', 'R'          \                 DOCK[195]ACCID<246>TS.<215>{19}DOCK
 ECHR 'E'               \                [195]COMPUT<244>S W<220>L AUTO<239>
 ECHR ' '               \                <251>C<228>LY DOCK[208][207] WH<246> TU
 ETWO 'R', 'E'          \                RN[196]<223>.<215>{19}DOCK[195]COMPUT
 ECHR 'C'               \                <244>S C<255> <247> B<217>GHT <245> SY
 ECHR 'O'               \                <222>EMS OF TECH <229><250>L 10 <253> M
 ECHR 'M'               \                O<242>[177]"
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'D'
 ETOK 196
 ECHR 'B'
 ECHR 'Y'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 145
 ETWO 'A', 'R'
 ECHR 'Y'
 ECHR ' '
 ECHR 'G'
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'N'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ETOK 208
 ECHR 'S'
 ECHR 'A'
 ECHR 'F'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'A'
 ECHR 'Y'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR 'U'
 ECHR 'C'
 ETOK 195
 ETOK 147
 ETWO 'N', 'U'
 ECHR 'M'
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 195
 ECHR 'A'
 ECHR 'C'
 ECHR 'C'
 ECHR 'I'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 195
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'T'
 ECHR 'O'
 ETWO 'M', 'A'
 ETWO 'T', 'I'
 ECHR 'C'
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 208
 ETOK 207
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'T'
 ECHR 'U'
 ECHR 'R'
 ECHR 'N'
 ETOK 196
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETOK 195
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'N'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '1'
 ECHR '0'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'R', 'E'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 118:    "{justify}{single cap}GALACTIC
 EJMP 19                \                HYPERSPACE DRIVES ARE OBTAINABLE FROM
 ECHR 'G'               \                PLANETS OF TECH LEVEL 11 UPWARDS.{crlf}
 ETWO 'A', 'L'          \                {single cap}WHEN THE INTERGALACTIC
 ECHR 'A'               \                HYPERDRIVE IS ENGAGED, THE SHIP IS
 ECHR 'C'               \                HYPERJUMPED INTO THE PRE-PROGRAMMED
 ETWO 'T', 'I'          \                GALAXY.{cr}
 ECHR 'C'               \                {left align}"
 ECHR ' '               \
 ECHR 'H'               \ Encoded as:   "{14}{19}G<228>AC<251>C HYP<244>SPA<233>
 ECHR 'Y'               \                 [151]S <238>E OBTA<240><216><229> FROM
 ECHR 'P'               \                 [145]S OF TECH <229><250>L 11 UPW<238>
 ETWO 'E', 'R'          \                DS.<215>{19}WH<246> [147]<240>T<244>G
 ECHR 'S'               \                <228>AC<251>C HYP<244>[151] IS <246>GA
 ECHR 'P'               \                <231>D, [147][207][202]HYP<244>JUMP
 ECHR 'A'               \                [196]<240>TO [147]P<242>-PROG<248>MM
 ETWO 'C', 'E'          \                [196]G<228>AXY[177]"
 ECHR ' '
 ETOK 151
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETOK 145
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '1'
 ECHR '1'
 ECHR ' '
 ECHR 'U'
 ECHR 'P'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'D'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'W'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ' '
 ETOK 147
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
 ECHR ' '
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ETOK 151
 ECHR ' '
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ETWO 'E', 'N'
 ECHR 'G'
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR 'D'
 ECHR ','
 ECHR ' '
 ETOK 147
 ETOK 207
 ETOK 202
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETOK 196
 ETWO 'I', 'N'
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ETOK 147
 ECHR 'P'
 ETWO 'R', 'E'
 ECHR '-'
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'G'
 ETWO 'R', 'A'
 ECHR 'M'
 ECHR 'M'
 ETOK 196
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 119:    "{justify}{single cap}MILITARY LASERS
 EJMP 19                \                ARE THE HEIGHT OF LASER SOPHISTICATION.
 ECHR 'M'               \                {crlf}
 ETWO 'I', 'L'          \                {single cap}THEY USE HIGH ENERGY LASERS
 ETWO 'I', 'T'          \                FIRING CONTINUOUSLY TO PRODUCE
 ETWO 'A', 'R'          \                DEVASTATING EFFECTS, BUT ARE PRONE TO
 ECHR 'Y'               \                OVERHEATING.{crlf}
 ECHR ' '               \                {single cap}MILITARY LASERS ARE
 ETWO 'L', 'A'          \                AVAILABLE FROM PLANETS OF TECH LEVEL 12
 ETWO 'S', 'E'          \                OR MORE.{cr}
 ECHR 'R'               \                {left align}"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{14}{19}M<220><219><238>Y <249><218>RS
 ETWO 'A', 'R'          \                 <238>E [147]HEIGHT OF <249><218>R
 ECHR 'E'               \                 <235>PHI<222>IC<245>I<223>.<215>{19}
 ECHR ' '               \                <226>EY U<218> HIGH <246><244>GY <249>
 ETOK 147               \                <218>RS FIR[195]C<223><251><225><217>SL
 ECHR 'H'               \                Y[201]PRODU<233> DEVA<222><245>[195]EFF
 ECHR 'E'               \                ECTS, BUT <238>E PR<223>E[201]OV<244>HE
 ECHR 'I'               \                <245><240>G.<215>{19}M<220><219><238>Y
 ECHR 'G'               \                 <249><218>RS <238>E AVA<220><216><229>
 ECHR 'H'               \                 FROM [145]S OF TECH <229><250>L 12
 ECHR 'T'               \                 <253> MO<242>[177]"
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'P'
 ECHR 'H'
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR 'I'
 ECHR 'C'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'Y'
 ECHR ' '
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR ' '
 ETWO 'E', 'N'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'Y'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ECHR 'R'
 ETOK 195
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'T', 'I'
 ETWO 'N', 'U'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR 'L'
 ECHR 'Y'
 ETOK 201
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'D'
 ECHR 'U'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'V'
 ECHR 'A'
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ETOK 195
 ECHR 'E'
 ECHR 'F'
 ECHR 'F'
 ECHR 'E'
 ECHR 'C'
 ECHR 'T'
 ECHR 'S'
 ECHR ','
 ECHR ' '
 ECHR 'B'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR 'E'
 ETOK 201
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'M'
 ETWO 'I', 'L'
 ETWO 'I', 'T'
 ETWO 'A', 'R'
 ECHR 'Y'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'L'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETOK 145
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '1'
 ECHR '2'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'R', 'E'
 ETOK 177
 EQUB VE

 EJMP 14                \ Token 120:    "{justify}{single cap}MINING LASERS ARE
 EJMP 19                \                HIGHLY POWERED, SLOW FIRING PULSE
 ECHR 'M'               \                LASERS WHICH ARE TUNED TO FRAGMENT
 ETWO 'I', 'N'          \                ASTEROIDS.{crlf}
 ETOK 195               \                {single cap}MINING LASERS ARE AVAILABLE
 ETWO 'L', 'A'          \                FROM TECH LEVEL 12 UPWARDS.{cr}
 ETWO 'S', 'E'          \                {left align}"
 ECHR 'R'               \
 ECHR 'S'               \ Encoded as:   "{14}{19}M<240>[195]<249><218>RS <238>E
 ECHR ' '               \                 HIGHLY POWE<242>D, S<224>W FIR[195]PUL
 ETWO 'A', 'R'          \                <218> <249><218>RS WHICH <238>E TUN
 ECHR 'E'               \                [196]TO F<248>GM<246>T A<222><244>OIDS.
 ECHR ' '               \                <215>{19}M<240>[195]<249><218>RS <238>E
 ECHR 'H'               \                 AVA<220><216><229> FROM TECH <229>
 ECHR 'I'               \                <250>L 12 UPW<238>DS[177]"
 ECHR 'G'
 ECHR 'H'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'W'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ETWO 'L', 'O'
 ECHR 'W'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ECHR 'R'
 ETOK 195
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'T'
 ECHR 'U'
 ECHR 'N'
 ETOK 196
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ECHR 'F'
 ETWO 'R', 'A'
 ECHR 'G'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR '.'
 ETWO '-', '-'
 EJMP 19
 ECHR 'M'
 ETWO 'I', 'N'
 ETOK 195
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'L'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ECHR 'T'
 ECHR 'E'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETWO 'L', 'E'
 ETWO 'V', 'E'
 ECHR 'L'
 ECHR ' '
 ECHR '1'
 ECHR '2'
 ECHR ' '
 ECHR 'U'
 ECHR 'P'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'D'
 ECHR 'S'
 ETOK 177
 EQUB VE

