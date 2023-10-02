\ ******************************************************************************
\
\       Name: RUTOK_FR
\       Type: Variable
\   Category: Text
\    Summary: The second extended token table for recursive tokens 0-26 (DETOK3)
\             (French)
\  Deep dive: Extended system descriptions
\             Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ Contains the tokens for extended description overrides of systems that match
\ the system number in RUPLA_FR and the conditions in RUGAL_FR.
\
\ The three variables work as follows:
\
\   * The RUPLA_FR table contains the system numbers
\
\   * The RUGAL_FR table contains the galaxy numbers and mission criteria
\
\   * The RUTOK_FR table contains the extended token to display instead of the
\     normal extended description if the criteria in RUPLA_FR and RUGAL_FR are
\     met
\
\ See the PDESC routine for details of how extended system descriptions work.
\
\ ******************************************************************************

.RUTOK_FR

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 1:      "{single cap}LES COLONISATEURS ONT VIOLÉ
 ETWO 'L', 'E'          \                LE {single cap}PROTOCOLE {single cap}
 ECHR 'S'               \                INTERGALACTIQUE, IL FAUT LES ÉVITER"
 ECHR ' '               \
 ECHR 'C'               \ Encoded as:   "{19}<229>S COL<223>IS<245>EURS <223>T V
 ECHR 'O'               \                IOL< <229>{26}PROTOCO<229>{26}<240>T
 ECHR 'L'               \                <244>G<228>AC<251><254>E, <220> FAUT
 ETWO 'O', 'N'          \                 <229>S <V<219><244>"
 ECHR 'I'
 ECHR 'S'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR 'U'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'O'
 ECHR 'L'
 ECHR '<'
 ECHR ' '
 ETWO 'L', 'E'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'T'
 ECHR 'O'
 ECHR 'C'
 ECHR 'O'
 ETWO 'L', 'E'
 EJMP 26
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ETWO 'Q', 'U'
 ECHR 'E'
 ECHR ','
 ECHR ' '
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'F'
 ECHR 'A'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR '<'
 ECHR 'V'
 ETWO 'I', 'T'
 ETWO 'E', 'R'
 EQUB VE

 EJMP 19                \ Token 2:      "{single cap}LE CONSTRICTOR PERDU DE VUE
 ETWO 'L', 'E'          \                À {single cap}{single cap}REESDICE,
 ECHR ' '               \                {single cap}COMMANDANT"
 ECHR 'C'               \
 ETWO 'O', 'N'          \ Encoded as:   "{19}<229> C<223><222>RICT<253> [203]
 ETWO 'S', 'T'          \                {19}<242><237><241><233>, [154]"
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 203
 EJMP 19
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 ECHR ','
 ECHR ' '
 ETOK 154
 EQUB VE

 EJMP 19                \ Token 3:      "{single cap}UN NAVIRE REDOUTABLE EST
 ECHR 'U'               \                PARTI D'ICI. {single cap}IL SEMBLAIT
 ECHR 'N'               \                ALLER À {single cap}AREXE"
 ECHR ' '               \
 ECHR 'N'               \ Encoded as:   "{19}UN NAVI<242> <242>D<217>T<216><229>
 ECHR 'A'               \                 E<222> P<238><251> D'ICI.{26}<220>
 ECHR 'V'               \                 <218>MB<249><219> <228><229>R "{26}
 ECHR 'I'               \                <238>E<230>"
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'D'
 ETWO 'O', 'U'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'P'
 ETWO 'A', 'R'
 ETWO 'T', 'I'
 ECHR ' '
 ECHR 'D'
 ECHR '`'
 ECHR 'I'
 ECHR 'C'
 ECHR 'I'
 ECHR '.'
 EJMP 26
 ETWO 'I', 'L'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'M'
 ECHR 'B'
 ETWO 'L', 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR '"'
 EJMP 26
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'X', 'E'
 EQUB VE

 EJMP 19                \ Token 4:      "{single cap}OUI, CE PUISSANT NAVIRE
 ETWO 'O', 'U'          \                AVAIT UN PROPULSEUR {single cap}
 ECHR 'I'               \                GALACTIQUE INCORPORÉ"
 ECHR ','               \
 ECHR ' '               \ Encoded as:   "{19}<217>I, <233> PUISS<255>T NAVI<242>
 ETWO 'C', 'E'          \                 AVA<219> UN PROPUL<218>UR{26}G<228>AC
 ECHR ' '               \                <251><254>E <240>C<253>P<253><"
 ECHR 'P'
 ECHR 'U'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETWO 'A', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR 'U'
 ECHR 'R'
 EJMP 26
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ETWO 'Q', 'U'
 ECHR 'E'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'C'
 ETWO 'O', 'R'
 ECHR 'P'
 ETWO 'O', 'R'
 ECHR '<'
 EQUB VE

 EJMP 19                \ Token 5:      "{single cap}OUI, UN NAVIRE REDOUTABLE A
 ETWO 'O', 'U'          \                SURGI DE NULLE PART. {single cap}JE
 ECHR 'I'               \                CROIS QU'IL ALLAIT À {single cap}
 ECHR ','               \                INBIBE"
 ECHR ' '               \
 ECHR 'U'               \ Encoded as:   "{19}<217>I, UN NAVI<242> <242>D<217>T
 ECHR 'N'               \                <216><229> A SURGI DE <225>L<229> P
 ECHR ' '               \                <238>T.{26}JE CROIS <254>'<220> <228>
 ECHR 'N'               \                <249><219> "{26}<240><234><247>"
 ECHR 'A'
 ECHR 'V'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'D'
 ETWO 'O', 'U'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ECHR 'G'
 ECHR 'I'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ETWO 'N', 'U'
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'T'
 ECHR '.'
 EJMP 26
 ECHR 'J'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'R'
 ECHR 'O'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ETWO 'Q', 'U'
 ECHR '`'
 ETWO 'I', 'L'
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'L', 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR '"'
 EJMP 26
 ETWO 'I', 'N'
 ETWO 'B', 'I'
 ETWO 'B', 'E'
 EQUB VE

 EJMP 19                \ Token 6:      "{single cap}UN NAVIRE [91-95] M'A
 ECHR 'U'               \                CHERCHÉ À {single cap}AUSAR. {single
 ECHR 'N'               \                cap}MES LASERS N'ONT RIEN PU FAIRE
 ECHR ' '               \                CONTRE CE VAURIEN"
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   "{19}UN NAVI<242> [24?] M'A CH<244>CH<
 ECHR 'V'               \                 "{26}A<236><238>.{26}M<237> <249><218>
 ECHR 'I'               \                RS N'<223>T RI<246> PU FAI<242> C<223>T
 ETWO 'R', 'E'          \                <242> <233> VAURI<246>"
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'M'
 ECHR '`'
 ECHR 'A'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR 'C'
 ECHR 'H'
 ECHR '<'
 ECHR ' '
 ECHR '"'
 EJMP 26
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'A', 'R'
 ECHR '.'
 EJMP 26
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'N'
 ECHR '`'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'R'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'U'
 ECHR ' '
 ECHR 'F'
 ECHR 'A'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'V'
 ECHR 'A'
 ECHR 'U'
 ECHR 'R'
 ECHR 'I'
 ETWO 'E', 'N'
 EQUB VE

 EJMP 19                \ Token 7:      "{single cap}UN NAVIRE REDOUTABLE A TIRÉ
 ECHR 'U'               \                SUR BEAUCOUP DE PIRATES, PUIS IL EST
 ECHR 'N'               \                PARTI VERS {single cap}USLERI"
 ECHR ' '               \
 ECHR 'N'               \ Encoded as:   "{19}UN NAVI<242> <242>D<217>T<216><229>
 ECHR 'A'               \                 A <251>R< SUR <247>AUC<217>P DE PIR
 ECHR 'V'               \                <245><237>, PUIS <220> E<222> P<238>
 ECHR 'I'               \                <251> V<244>S{26}<236><229>RI"
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'D'
 ETWO 'O', 'U'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR ' '
 ETWO 'T', 'I'
 ECHR 'R'
 ECHR '<'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'A'
 ECHR 'U'
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'P'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ECHR 'R'
 ETWO 'A', 'T'
 ETWO 'E', 'S'
 ECHR ','
 ECHR ' '
 ECHR 'P'
 ECHR 'U'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'P'
 ETWO 'A', 'R'
 ETWO 'T', 'I'
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'S'
 EJMP 26
 ETWO 'U', 'S'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR 'I'
 EQUB VE

 EJMP 19                \ Token 8:      "{single cap}VOUS POUVEZ ALLER VOIR CE
 ECHR 'V'               \                VAURIEN. {single cap}IL EST À {single
 ETWO 'O', 'U'          \                cap}ORARRA"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{19}V<217>S P<217><250>Z <228><229>R VO
 ECHR 'P'               \                IR <233> VAURI<246>.{26}<220> E<222> "
 ETWO 'O', 'U'          \                {26}<253><238><248>"
 ETWO 'V', 'E'
 ECHR 'Z'
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'V'
 ECHR 'O'
 ECHR 'I'
 ECHR 'R'
 ECHR ' '
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'V'
 ECHR 'A'
 ECHR 'U'
 ECHR 'R'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR '.'
 EJMP 26
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR '"'
 EJMP 26
 ETWO 'O', 'R'
 ETWO 'A', 'R'
 ETWO 'R', 'A'
 EQUB VE

 ERND 25                \ Token 9:      "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 10:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 11:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 12:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 13:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 14:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 15:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 16:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 17:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 18:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 19:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 20:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ERND 25                \ Token 21:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 EJMP 19                \ Token 22:     "{single cap}CE N'EST PAS LA BONNE
 ETWO 'C', 'E'          \                GALAXIE!"
 ECHR ' '               \
 ECHR 'N'               \ Encoded as:   "{19}<233> N'E<222> PAS [182]B<223>NE G
 ECHR '`'               \                <228>AXIE!"
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETOK 182
 ECHR 'B'
 ETWO 'O', 'N'
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'I'
 ECHR 'E'
 ECHR '!'
 EQUB VE

 EJMP 19                \ Token 23:     "{single cap}IL Y A UN PIRATE [91-95]
 ETWO 'I', 'L'          \                CRUEL LÀ-BAS"
 ECHR ' '               \
 ECHR 'Y'               \ Encoded as:   "{19}<220> Y A UN PIR<245>E [24?] CRUEL
 ECHR ' '               \                 L"-BAS"
 ECHR 'A'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ECHR 'R'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'C'
 ECHR 'R'
 ECHR 'U'
 ECHR 'E'
 ECHR 'L'
 ECHR ' '
 ECHR 'L'
 ECHR '"'
 ECHR '-'
 ECHR 'B'
 ECHR 'A'
 ECHR 'S'
 EQUB VE

