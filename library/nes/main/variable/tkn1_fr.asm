\ ******************************************************************************
\
\       Name: TKN1_FR
\       Type: Variable
\   Category: Text
\    Summary: The first extended token table for recursive tokens 0-255 (DETOK)
\             (French)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.TKN1_FR

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 1:      "{single cap}OUI"
 ETWO 'O', 'U'          \
 ECHR 'I'               \ Encoded as:   "{19}<217>I"
 EQUB VE

 EJMP 19                \ Token 2:      "{single cap}NON"
 ECHR 'N'               \
 ETWO 'O', 'N'          \ Encoded as:   "{19}N<223>"
 EQUB VE

 EQUB VE                \ Token 3:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 4:      "{single cap}FRANÇAIS"
 ECHR 'F'               \
 ETWO 'R', 'A'          \ Encoded as:   "{19}F<248>N@AIS"
 ECHR 'N'
 ECHR '@'
 ECHR 'A'
 ECHR 'I'
 ECHR 'S'
 EQUB VE

 EQUB VE                \ Token 5:      ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 6:      ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 7:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 8:      "{single cap}NOUVEAU {single cap}NOM: "
 ECHR 'N'               \
 ETWO 'O', 'U'          \ Encoded as:   "{19}N<217><250>AU{26}<227>M: "
 ETWO 'V', 'E'
 ECHR 'A'
 ECHR 'U'
 EJMP 26
 ETWO 'N', 'O'
 ECHR 'M'
 ECHR ':'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 9:      ""
                        \
                        \ Encoded as:   ""

 EJMP 23                \ Token 10:     "{move to row 9, lower case}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}  {single cap}COMMANDANT
 ECHR ' '               \                {commander name}, JE {lower case}SUIS
 ETOK 213               \                LE CAPITAINE {mission captain's name}
 EJMP 26                \                DE LA {single cap}MARINE {single cap}
 ETOK 181               \                SPATIALE DE SA {single cap}MAJESTÉ
 ETOK 190               \                {single cap}JE VOUS PRIE DE M'ACCORDER
 ECHR ' '               \                QUELQUES INSTANTS.{cr}
 ECHR 'P'               \                {cr}
 ECHR 'R'               \                 {single cap}NOUS AIMERIONS VOUS
 ECHR 'I'               \                CONFIER UN PETIT TRAVAIL.{cr}
 ECHR 'E'               \                {cr}
 ETOK 179               \                 {single cap}CE NOUVEAU MODÈLE DE
 ECHR 'M'               \                NAVIRE LE '{single cap}CONSTRICTOR' EST
 ECHR '`'               \                DOTÉ D'UN GÉNÉRATEUR DE BOUCLIERS TOP
 ECHR 'A'               \                SECRET.{cr}
 ECHR 'C'               \                {cr}
 ECHR 'C'               \                 {single cap}{single cap}
 ETWO 'O', 'R'          \                MALHEUREUSEMENT IL A ÉTÉ VOLÉ.{cr}
 ECHR 'D'               \                {cr}
 ETWO 'E', 'R'          \                 {single cap}{display ship, wait for
 ECHR ' '               \                key press}{single cap}IL A DISPARU DU
 ETWO 'Q', 'U'          \                CHANTIER NAVAL À {single cap}XEER IL Y
 ECHR 'E'               \                A CINQ MOIS. {single cap}ON L'A
 ECHR 'L'               \                {mission 1 location hint}.{cr}
 ETWO 'Q', 'U'          \                {cr}
 ETWO 'E', 'S'          \                 {single cap}{single cap}VOTRE MISSION
 ECHR ' '               \                EST DE RETROUVER CE NAVIRE AFIN DE LE
 ETWO 'I', 'N'          \                DÉTRUIRE.{cr}
 ETWO 'S', 'T'          \                {cr}
 ETWO 'A', 'N'          \                 {single cap}{single cap}IL N'Y A QUE
 ECHR 'T'               \                LES LASERS MILITAIRES QUI SONT CAPABLES
 ECHR 'S'               \                DE TRANSPERCER LES BOUCLIERS. {single
 ETOK 204               \                cap}DE PLUS, LE CONSTRICTOR EST DOTÉ
 ECHR 'N'               \                D'UN {standard tokens, sentence case}
 ETWO 'O', 'U'          \                [81-85]{extended tokens}.{cr}
 ECHR 'S'               \                {left align}{tab 6}{single cap}BONNE
 ECHR ' '               \                CHANCE {single cap}COMMANDANT.{cr}
 ECHR 'A'               \                {left align}{cr}{tab 6}{all caps}
 ECHR 'I'               \                  {single cap}FIN DU MESSAGE{display
 ECHR 'M'               \                 ship, wait for key press}"
 ETWO 'E', 'R'          \
 ECHR 'I'               \ Encoded as:   "{23}{14}{13} [213]{26}[181][190] PRIE
 ETWO 'O', 'N'          \                [179]M'ACC<253>D<244> <254>EL<254><237>
 ECHR 'S'               \                 <240><222><255>TS[204]N<217>S AIM<244>
 ECHR ' '               \                I<223>S [190] C<223>FI<244> [186]P<221>
 ETOK 190               \                <219> T<248>VA<220>[204][188]N<217>
 ECHR ' '               \                <250>AU MOD=[178]DE[173][178]'{19}C
 ECHR 'C'               \                <223><222>RICT<253>' [184] DOT< D'[186]
 ETWO 'O', 'N'          \                G<N<R<245>EUR[179]B<217>CLI<244>S TOP
 ECHR 'F'               \                 <218>CR<221>[204]{19}M<228>HEU<242>U
 ECHR 'I'               \                <218>M<246>T <220>[129]<T< VOL<[204]
 ETWO 'E', 'R'          \                {22}{19}<220>[129]<241>SP<238>U DU CH
 ECHR ' '               \                <255><251><244> NAV<228> "{26}<230>
 ETOK 186               \                <244> <220> Y[129]C<240>Q MOIS.{26}
 ECHR 'P'               \                <223> L'A {28}[204]{19}VOT<242> MISSI
 ETWO 'E', 'T'          \                <223> [184][179]R<221>R<217>V<244>
 ETWO 'I', 'T'          \                 <233>[173]AF<240>[179][178]D<TRUI<242>
 ECHR ' '               \                [204]{19}<220> N'Y[129][192][187]<249>
 ECHR 'T'               \                <218>RS M<220><219>AIR<237> <254>I S
 ETWO 'R', 'A'          \                <223>T CAP<216><229>S[179]T<248>NSP
 ECHR 'V'               \                <244><233>R [187]B<217>CLI<244>S.{26}DE
 ECHR 'A'               \                 [196], [178]C<223><222>RICT<253> [184]
 ETWO 'I', 'L'          \                 DOT< D'[186]{6}[17?]{5}[177]{8}{19}B
 ETOK 204               \                <223>NE CH<255>[188][154][212]{22}"
 ETOK 188
 ECHR 'N'
 ETWO 'O', 'U'
 ETWO 'V', 'E'
 ECHR 'A'
 ECHR 'U'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ECHR 'D'
 ECHR '='
 ETOK 178
 ECHR 'D'
 ECHR 'E'
 ETOK 173
 ETOK 178
 ECHR '`'
 EJMP 19
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR '`'
 ECHR ' '
 ETOK 184
 ECHR ' '
 ECHR 'D'
 ECHR 'O'
 ECHR 'T'
 ECHR '<'
 ECHR ' '
 ECHR 'D'
 ECHR '`'
 ETOK 186
 ECHR 'G'
 ECHR '<'
 ECHR 'N'
 ECHR '<'
 ECHR 'R'
 ETWO 'A', 'T'
 ECHR 'E'
 ECHR 'U'
 ECHR 'R'
 ETOK 179
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'C'
 ECHR 'L'
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ECHR 'P'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'C'
 ECHR 'R'
 ETWO 'E', 'T'
 ETOK 204
 EJMP 19
 ECHR 'M'
 ETWO 'A', 'L'
 ECHR 'H'
 ECHR 'E'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'L'
 ETOK 129
 ECHR '<'
 ECHR 'T'
 ECHR '<'
 ECHR ' '
 ECHR 'V'
 ECHR 'O'
 ECHR 'L'
 ECHR '<'
 ETOK 204
 EJMP 22
 EJMP 19
 ETWO 'I', 'L'
 ETOK 129
 ETWO 'D', 'I'
 ECHR 'S'
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'U'
 ECHR ' '
 ECHR 'D'
 ECHR 'U'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETWO 'T', 'I'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ETWO 'A', 'L'
 ECHR ' '
 ECHR '"'
 EJMP 26
 ETWO 'X', 'E'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'Y'
 ETOK 129
 ECHR 'C'
 ETWO 'I', 'N'
 ECHR 'Q'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ECHR 'I'
 ECHR 'S'
 ECHR '.'
 EJMP 26
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'L'
 ECHR '`'
 ECHR 'A'
 ECHR ' '
 EJMP 28
 ETOK 204
 EJMP 19
 ECHR 'V'
 ECHR 'O'
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ETOK 184
 ETOK 179
 ECHR 'R'
 ETWO 'E', 'T'
 ECHR 'R'
 ETWO 'O', 'U'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'C', 'E'
 ETOK 173
 ECHR 'A'
 ECHR 'F'
 ETWO 'I', 'N'
 ETOK 179
 ETOK 178
 ECHR 'D'
 ECHR '<'
 ECHR 'T'
 ECHR 'R'
 ECHR 'U'
 ECHR 'I'
 ETWO 'R', 'E'
 ETOK 204
 EJMP 19
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'N'
 ECHR '`'
 ECHR 'Y'
 ETOK 129
 ETOK 192
 ETOK 187
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'M'
 ETWO 'I', 'L'
 ETWO 'I', 'T'
 ECHR 'A'
 ECHR 'I'
 ECHR 'R'
 ETWO 'E', 'S'
 ECHR ' '
 ETWO 'Q', 'U'
 ECHR 'I'
 ECHR ' '
 ECHR 'S'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR 'S'
 ETOK 179
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'P'
 ETWO 'E', 'R'
 ETWO 'C', 'E'
 ECHR 'R'
 ECHR ' '
 ETOK 187
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'C'
 ECHR 'L'
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR '.'
 EJMP 26
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ETOK 196
 ECHR ','
 ECHR ' '
 ETOK 178
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 184
 ECHR ' '
 ECHR 'D'
 ECHR 'O'
 ECHR 'T'
 ECHR '<'
 ECHR ' '
 ECHR 'D'
 ECHR '`'
 ETOK 186
 EJMP 6
 ERND 17
 EJMP 5
 ETOK 177
 EJMP 8
 EJMP 19
 ECHR 'B'
 ETWO 'O', 'N'
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETOK 188
 ETOK 154
 ETOK 212
 EJMP 22
 EQUB VE

 EJMP 25                \ Token 11:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 23                \                {move to row 9, lower case}{justify}
 EJMP 14                \                {single cap}ATTENTION  {single cap}
 ECHR ' '               \                COMMANDANT {commander name}, JE {lower
 EJMP 26                \                case}SUIS LE CAPITAINE {mission
 ETWO 'A', 'T'          \                captain's name} DE LA {single cap}
 ECHR 'T'               \                MARINE {single cap}SPATIALE DE SA
 ETWO 'E', 'N'          \                {single cap}MAJESTÉ. {single cap}NOUS
 ETWO 'T', 'I'          \                AVONS DE NOUVEAU RECOURS À VOUS.{cr}
 ETWO 'O', 'N'          \                {cr}
 ECHR ' '               \                 {single cap}{single cap}VOUS RECEVREZ
 ETOK 213               \                DES INSTRUCTIONS SI VOUS ALLEZ JUSQU'À
 ECHR '.'               \                {single cap}CEERDI.{cr}
 EJMP 26                \                {cr}
 ECHR 'N'               \                 {single cap}VOUS SEREZ RÉCOMPENSÉ SI
 ETWO 'O', 'U'          \                VOUS RÉUSSISSEZ.{cr}
 ECHR 'S'               \                {left align}{cr}{tab 6}{all caps}
 ECHR ' '               \                {single cap}FIN DU MESSAGE
 ETOK 172               \                {wait for key press}"
 ECHR 'S'               \
 ETOK 179               \ Encoded as:   "{25}{9}{23}{14} {26}<245>T<246><251>
 ECHR 'N'               \                <223> [213].{26}N<217>S [172]S[179]N
 ETWO 'O', 'U'          \                <217><250>AU <242>C<217>RS[183][190]
 ETWO 'V', 'E'          \                [204]{19}[190] <242><233>V<242>Z [195]
 ECHR 'A'               \                <240><222>RUC<251><223>S SI [190] <228>
 ECHR 'U'               \                <229>Z J<236><254>'"{26}<233><244><241>
 ECHR ' '               \                [204][190] <218><242>Z R<COMP<246>S< SI
 ETWO 'R', 'E'          \                 [190] R<<236>SIS<218>Z[212]{24}"
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'S'
 ETOK 183
 ETOK 190
 ETOK 204
 EJMP 19
 ETOK 190
 ECHR ' '
 ETWO 'R', 'E'
 ETWO 'C', 'E'
 ECHR 'V'
 ETWO 'R', 'E'
 ECHR 'Z'
 ECHR ' '
 ETOK 195
 ETWO 'I', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'U'
 ECHR 'C'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'S'
 ECHR 'I'
 ECHR ' '
 ETOK 190
 ECHR ' '
 ETWO 'A', 'L'
 ETWO 'L', 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'J'
 ETWO 'U', 'S'
 ETWO 'Q', 'U'
 ECHR '`'
 ECHR '"'
 EJMP 26
 ETWO 'C', 'E'
 ETWO 'E', 'R'
 ETWO 'D', 'I'
 ETOK 204
 ETOK 190
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'R'
 ECHR '<'
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'N'
 ECHR 'S'
 ECHR '<'
 ECHR ' '
 ECHR 'S'
 ECHR 'I'
 ECHR ' '
 ETOK 190
 ECHR ' '
 ECHR 'R'
 ECHR '<'
 ETWO 'U', 'S'
 ECHR 'S'
 ECHR 'I'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'Z'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 12:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 13:     ""
                        \
                        \ Encoded as:   ""

 EJMP 21                \ Token 14:     "{clear bottom of screen}{single cap}NOM
 EJMP 19                \                {single cap}PLANÉTE? "
 ETWO 'N', 'O'          \
 ECHR 'M'               \ Encoded as:   "{21}{19}<227>M{26}P<249>N<TE? "
 EJMP 26
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR '<'
 ECHR 'T'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

 EJMP 25                \ Token 15:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 23                \                {move to row 9, lower case}{justify}
 EJMP 14                \                {lower case}  {single cap}FÉLICITATIONS
 EJMP 13                \                {single cap}COMMANDANT!{cr}
 ECHR ' '               \                {cr}
 EJMP 26                \                 {single cap}VOUS SEREZ TOUJOURS LE
 ECHR 'F'               \                BIENVENU À  LA {single cap}MARINE
 ECHR '<'               \                {single cap}SPATIALE DE SA {single cap}
 ECHR 'L'               \                MAJESTÉ.{cr}
 ECHR 'I'               \                {cr}
 ECHR 'C'               \                 {single cap}ET PEUT-TRE PLUS TÔT QUE
 ETWO 'I', 'T'          \                PRÉVU...{cr}
 ETWO 'A', 'T'          \                {left align}{cr}
 ECHR 'I'               \                {tab 6}{all caps}  {single cap}FIN DU
 ETWO 'O', 'N'          \                MESSAGE
 ECHR 'S'               \                {wait for key press}"
 ECHR ' '               \
 ETOK 154               \ Encoded as:   "{25}{9}{23}{14}{13} {26}F<LIC<219><245>
 ECHR '!'               \                I<223>S [154]!{12}{12}{26}[190] <218>
 EJMP 12                \                <242>Z T<217>J<217>RS [178]<234><246>
 EJMP 12                \                <250><225>[183][211][204]<221> PEUT-
 EJMP 26                \                [193]<242> [196] T#T [192]PR<VU..[212]
 ETOK 190               \                {24}"
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'T'
 ETWO 'O', 'U'
 ECHR 'J'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETOK 178
 ETWO 'B', 'I'
 ETWO 'E', 'N'
 ETWO 'V', 'E'
 ETWO 'N', 'U'
 ETOK 183
 ETOK 211
 ETOK 204
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'E'
 ECHR 'U'
 ECHR 'T'
 ECHR '-'
 ETOK 193
 ETWO 'R', 'E'
 ECHR ' '
 ETOK 196
 ECHR ' '
 ECHR 'T'
 ECHR '#'
 ECHR 'T'
 ECHR ' '
 ETOK 192
 ECHR 'P'
 ECHR 'R'
 ECHR '<'
 ECHR 'V'
 ECHR 'U'
 ECHR '.'
 ECHR '.'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 16:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 17:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 18:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 19:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 20:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 21:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 22:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 23:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 24:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 25:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 26:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 27:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 28:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 29:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 30:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 31:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 32:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 33:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 34:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 35:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 36:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 37:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 38:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 39:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 40:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 41:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 42:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 43:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 44:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 45:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 46:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 47:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 48:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 49:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 50:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 51:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 52:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 53:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 54:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 55:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 56:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 57:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 58:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 59:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 60:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 61:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 62:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 63:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 64:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 65:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 66:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 67:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 68:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 69:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 70:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 71:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 72:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 73:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 74:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 75:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 76:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 77:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 78:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 79:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 80:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 81:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 82:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 83:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 84:     ""
                        \
                        \ Encoded as:   ""

 EJMP 2                 \ Token 85:     "{sentence case}{lower case}"
 ERND 31                \
 EJMP 13                \ Encoded as:   "{2}[31?]{13}"
 EQUB VE

 EQUB VE                \ Token 86:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 87:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 88:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 89:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 90:     ""
                        \
                        \ Encoded as:   ""

 ECHR 'C'               \ Token 91:     "CRAPULE"
 ETWO 'R', 'A'          \
 ECHR 'P'               \ Encoded as:   "C<248>PU<229>"
 ECHR 'U'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'V'               \ Token 92:     "VAURIEN"
 ECHR 'A'               \
 ECHR 'U'               \ Encoded as:   "VAURI<246>"
 ECHR 'R'
 ECHR 'I'
 ETWO 'E', 'N'
 EQUB VE

 ETWO 'E', 'S'          \ Token 93:     "ESCROC"
 ECHR 'C'               \
 ECHR 'R'               \ Encoded as:   "<237>CROC"
 ECHR 'O'
 ECHR 'C'
 EQUB VE

 ECHR 'G'               \ Token 94:     "GREDIN"
 ETWO 'R', 'E'          \
 ECHR 'D'               \ Encoded as:   "G<242>D<240>"
 ETWO 'I', 'N'
 EQUB VE

 ECHR 'B'               \ Token 95:     "BRIGAND"
 ECHR 'R'               \
 ECHR 'I'               \ Encoded as:   "BRIG<255>D"
 ECHR 'G'
 ETWO 'A', 'N'
 ECHR 'D'
 EQUB VE

 EQUB VE                \ Token 96:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 97:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 98:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 99:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 100:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 101:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 102:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 103:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 104:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 105:    ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 106:    "{single cap}UN NAVIRE REDOUTABLE SERAIT
 ECHR 'U'               \                APPARU À {single cap}ERRIUS "
 ECHR 'N'               \
 ETOK 173               \ Encoded as:   "{19}UN[173]<242>D<217>T<216>[178]<218>
 ETWO 'R', 'E'          \                <248><219> APP<238>U "[209] "
 ECHR 'D'
 ETWO 'O', 'U'
 ECHR 'T'
 ETWO 'A', 'B'
 ETOK 178
 ETWO 'S', 'E'
 ETWO 'R', 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'A'
 ECHR 'P'
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'U'
 ECHR ' '
 ECHR '"'
 ETOK 209
 ECHR ' '
 EQUB VE

 EJMP 19                \ Token 107:    "{single cap}OUAIS, UN NAVIRE AURAIT
 ETWO 'O', 'U'          \                QUITTÉ {single cap}ERRIUS"
 ECHR 'A'               \
 ECHR 'I'               \ Encoded as:   "{19}<217>AIS, UN[173]AU<248><219> <254>
 ECHR 'S'               \                <219>T<[209]"
 ECHR ','
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETOK 173
 ECHR 'A'
 ECHR 'U'
 ETWO 'R', 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ETWO 'Q', 'U'
 ETWO 'I', 'T'
 ECHR 'T'
 ECHR '<'
 ETOK 209
 EQUB VE

 EJMP 19                \ Token 108:    "{single cap}ALLEZ À {single cap}ERRIUS"
 ETWO 'A', 'L'          \
 ETWO 'L', 'E'          \ Encoded as:   "{19}<228><229>Z "[209]"
 ECHR 'Z'
 ECHR ' '
 ECHR '"'
 ETOK 209
 EQUB VE

 EJMP 19                \ Token 109:    "{single cap}ON A VU UN AUTRE NAVIRE À
 ETWO 'O', 'N'          \                {single cap}ERRIUS"
 ETOK 129               \
 ECHR 'V'               \ Encoded as:   "{19}<223>[129]VU [186]AUT<242>[173]"
 ECHR 'U'               \                [209]"
 ECHR ' '
 ETOK 186
 ECHR 'A'
 ECHR 'U'
 ECHR 'T'
 ETWO 'R', 'E'
 ETOK 173
 ECHR '"'
 ETOK 209
 EQUB VE

 EJMP 19                \ Token 110:    "{single cap}ESSAYEZ {single cap}ERRIUS"
 ETWO 'E', 'S'          \
 ECHR 'S'               \ Encoded as:   "{19}<237>SAYEZ[209]"
 ECHR 'A'
 ECHR 'Y'
 ECHR 'E'
 ECHR 'Z'
 ETOK 209
 EQUB VE

 EQUB VE                \ Token 111:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 112:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 113:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 114:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 115:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 116:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 117:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 118:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 119:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 120:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 121:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 122:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 123:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 124:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 125:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 126:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 127:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 128:    ""
                        \
                        \ Encoded as:   ""

 ECHR ' '               \ Token 129:    " A "
 ECHR 'A'               \
 ECHR ' '               \ Encoded as:   " A "
 EQUB VE

 EQUB VE                \ Token 130:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 131:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 132:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 133:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 134:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 135:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 136:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 137:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 138:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 139:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 140:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 141:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 142:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 143:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 144:    ""
                        \
                        \ Encoded as:   ""

 ECHR 'P'               \ Token 145:    "PLANÈTE"
 ETWO 'L', 'A'          \
 ECHR 'N'               \ Encoded as:   "P<249>N=TE"
 ECHR '='
 ECHR 'T'
 ECHR 'E'
 EQUB VE

 ECHR 'M'               \ Token 146:    "MONDE"
 ETWO 'O', 'N'          \
 ECHR 'D'               \ Encoded as:   "M<223>DE"
 ECHR 'E'
 EQUB VE

 ECHR 'E'               \ Token 147:    "EC "
 ECHR 'C'               \
 ECHR ' '               \ Encoded as:   "EC "
 EQUB VE

 ETWO 'C', 'E'          \ Token 148:    "CECI "
 ECHR 'C'               \
 ECHR 'I'               \ Encoded as:   "<233>CI "
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 149:    ""
                        \
                        \ Encoded as:   ""

 EJMP 9                 \ Token 150:    "{clear screen}
 EJMP 11                \                {draw box around title}
 EJMP 1                 \                {all caps}{tab 6}"
 EJMP 8                 \
 EQUB VE                \ Encoded as:   "{9}{11}{1}{8}"

 EQUB VE                \ Token 151:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 152:    ""
                        \
                        \ Encoded as:   ""

 ECHR 'I'               \ Token 153:    "IAN"
 ETWO 'A', 'N'          \
 EQUB VE                \ Encoded as:   "I<255>"

 EJMP 19                \ Token 154:    "{single cap}COMMANDANT"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{19}COM<239>ND<255>T"
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 EQUB VE                \ Token 155:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 156:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 157:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 158:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 159:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 160:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 161:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 162:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 163:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 164:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 165:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 166:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 167:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 168:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 169:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 170:    ""
                        \
                        \ Encoded as:   ""

 ECHR 'S'               \ Token 171:    "SUIS "
 ECHR 'U'               \
 ECHR 'I'               \ Encoded as:   "SUIS "
 ECHR 'S'
 ECHR ' '
 EQUB VE

 ECHR 'A'               \ Token 172:    "AVON"
 ECHR 'V'               \
 ETWO 'O', 'N'          \ Encoded as:   "AV<223>"
 EQUB VE

 ECHR ' '               \ Token 173:    " NAVIRE "
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   " NAVI<242> "
 ECHR 'V'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ' '
 EQUB VE

 ETWO 'A', 'R'          \ Token 174:    "ARINE"
 ETWO 'I', 'N'          \
 ECHR 'E'               \ Encoded as:   "<238><240>E"
 EQUB VE

 ECHR 'P'               \ Token 175:    "POUR"
 ETWO 'O', 'U'          \
 ECHR 'R'               \ Encoded as:   "P<217>R"
 EQUB VE

 EJMP 13                \ Token 176:    "{lower case}{justify}{single cap}"
 EJMP 14                \
 EJMP 19                \ Encoded as:   "{13}{14}{19}"
 EQUB VE

 ECHR '.'               \ Token 177:    ".{cr}
 EJMP 12                \                {left align}"
 EJMP 15                \
 EQUB VE                \ Encoded as:   ".{12}{15}"

 ETWO 'L', 'E'          \ Token 178:    "LE "
 ECHR ' '               \
 EQUB VE                \ Encoded as:   "<229> "

 ECHR ' '               \ Token 179:    " DE "
 ECHR 'D'               \
 ECHR 'E'               \ Encoded as:   " DE "
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 180:    " ET "
 ETWO 'E', 'T'          \
 ECHR ' '               \ Encoded as:   " <221> "
 EQUB VE

 ECHR 'J'               \ Token 181:    "JE "
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "JE "
 EQUB VE

 ETWO 'L', 'A'          \ Token 182:    "LA "
 ECHR ' '               \
 EQUB VE                \ Encoded as:   "<249> "

 ECHR ' '               \ Token 183:    " À "
 ECHR '"'               \
 ECHR ' '               \ Encoded as:   " " "
 EQUB VE

 ECHR 'E'               \ Token 184:    "EST"
 ETWO 'S', 'T'          \
 EQUB VE                \ Encoded as:   "E<222>"

 ETWO 'I', 'L'          \ Token 185:    "IL"
 EQUB VE                \
                        \ Encoded as:   "<220>"

 ECHR 'U'               \ Token 186:    "UN "
 ECHR 'N'               \
 ECHR ' '               \ Encoded as:   "UN "
 EQUB VE

 ETWO 'L', 'E'          \ Token 187:    "LES "
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "<229>S "
 EQUB VE

 ETWO 'C', 'E'          \ Token 188:    "CE "
 ECHR ' '               \
 EQUB VE                \ Encoded as:   "<233> "

 ECHR 'D'               \ Token 189:    "DE LA "
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "DE [182]"
 ETOK 182
 EQUB VE

 ECHR 'V'               \ Token 190:    "VOUS"
 ETWO 'O', 'U'          \
 ECHR 'S'               \ Encoded as:   "V<217>S"
 EQUB VE

 EJMP 26                \ Token 191:    " {single cap}BONJOUR "
 ECHR 'B'               \
 ETWO 'O', 'N'          \ Encoded as:   "{26}B<223>J<217>R "
 ECHR 'J'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 EQUB VE

 ETWO 'Q', 'U'          \ Token 192:    "QUE "
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "<254>E "
 EQUB VE

 ERND 4                 \ Token 193:    "T"
 ECHR 'T'               \
 EQUB VE                \ Encoded as:   "[4?]T"

 EQUB VE                \ Token 194:    ""
                        \
                        \ Encoded as:   ""

 ECHR 'D'               \ Token 195:    "DES "
 ETWO 'E', 'S'          \
 ECHR ' '               \ Encoded as:   "D<237> "
 EQUB VE

 ECHR 'P'               \ Token 196:    "PLUS"
 ECHR 'L'               \
 ETWO 'U', 'S'          \ Encoded as:   "PL<236>"
 EQUB VE

 EQUB VE                \ Token 197:    ""
                        \
                        \ Encoded as:   ""

 EJMP 26                \ Token 198:    " {single cap}SQUEAKY"
 ECHR 'S'               \
 ETWO 'Q', 'U'          \ Encoded as:   "{26}S<254>EAKY"
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 ECHR 'Y'
 EQUB VE

 EJMP 25                \ Token 199:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {move to row 7, lower case}{justify}
 EJMP 14                \                {lower case}  {single cap}BONJOUR
 EJMP 13                \                {single cap}COMMANDANT {commander
 ECHR ' '               \                name}, JE VOUDRAIS ME PRÉSENTER.
 ETOK 191               \                {single cap}JE SUIS LE {single cap}
 ETOK 154               \                PRINCE DE {single cap}THRUN ET JE SUIS
 ECHR ' '               \                OBLIGÉ DE ME SÉPARER DE LA PLUPART DE
 EJMP 4                 \                MES TRÉSORS.{cr}
 ECHR ','               \                {cr}
 ECHR ' '               \                 {single cap}{single cap}POUR LA JOLIE
 ETOK 181               \                SOMME DE 5000{single cap}C{single cap}R
 ECHR 'V'               \                JE VOUS OFFRE L'OBJET LE PLUS RARE DE
 ETWO 'O', 'U'          \                TOUT L'UNIVERS.{cr}
 ECHR 'D'               \                {cr}
 ETWO 'R', 'A'          \                 {single cap}{single cap}VOULEZ-VOUS LE
 ECHR 'I'               \                PRENDRE?{cr}
 ECHR 'S'               \                {left align}{all caps}{tab 6}"
 ECHR ' '               \
 ECHR 'M'               \ Encoded as:   "{25}{9}{29}{14}{13} [191][154] {4},
 ECHR 'E'               \                 [181]V<217>D<248>IS ME PR<<218>NT<244>
 ECHR ' '               \                .{26}[181][171]<229>{26}PR<240>[188]DE
 ECHR 'P'               \                {26}<226>RUN[180][181][171]OBLIG<[179]M
 ECHR 'R'               \                E S<P<238><244>[179][182]PLUP<238>T
 ECHR '<'               \                [179]M<237> TR<<235>RS[204]{19}[175]
 ETWO 'S', 'E'          \                 [182]JOLIE <235>MME[179]5000{19}C{19}R
 ECHR 'N'               \                 [181][190] OFF<242> L'OBJ<221> [178]
 ECHR 'T'               \                [196] R<238>E[179]T<217>T L'UNIV<244>S
 ETWO 'E', 'R'          \                [204]{19}V<217><229>Z-[190] [178]P<242>
 ECHR '.'               \                ND<242>?{12}{15}{1}{8}"
 EJMP 26
 ETOK 181
 ETOK 171
 ETWO 'L', 'E'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ETWO 'I', 'N'
 ETOK 188
 ECHR 'D'
 ECHR 'E'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ETOK 180
 ETOK 181
 ETOK 171
 ECHR 'O'
 ECHR 'B'
 ECHR 'L'
 ECHR 'I'
 ECHR 'G'
 ECHR '<'
 ETOK 179
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR '<'
 ECHR 'P'
 ETWO 'A', 'R'
 ETWO 'E', 'R'
 ETOK 179
 ETOK 182
 ECHR 'P'
 ECHR 'L'
 ECHR 'U'
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'T'
 ETOK 179
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'T'
 ECHR 'R'
 ECHR '<'
 ETWO 'S', 'O'
 ECHR 'R'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ETOK 175
 ECHR ' '
 ETOK 182
 ECHR 'J'
 ECHR 'O'
 ECHR 'L'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'M'
 ECHR 'M'
 ECHR 'E'
 ETOK 179
 ECHR '5'
 ECHR '0'
 ECHR '0'
 ECHR '0'
 EJMP 19
 ECHR 'C'
 EJMP 19
 ECHR 'R'
 ECHR ' '
 ETOK 181
 ETOK 190
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'L'
 ECHR '`'
 ECHR 'O'
 ECHR 'B'
 ECHR 'J'
 ETWO 'E', 'T'
 ECHR ' '
 ETOK 178
 ETOK 196
 ECHR ' '
 ECHR 'R'
 ETWO 'A', 'R'
 ECHR 'E'
 ETOK 179
 ECHR 'T'
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ECHR 'L'
 ECHR '`'
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ECHR 'V'
 ETWO 'O', 'U'
 ETWO 'L', 'E'
 ECHR 'Z'
 ECHR '-'
 ETOK 190
 ECHR ' '
 ETOK 178
 ECHR 'P'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR 'D'
 ETWO 'R', 'E'
 ECHR '?'
 EJMP 12
 EJMP 15
 EJMP 1
 EJMP 8
 EQUB VE

 EJMP 26                \ Token 200:    " {single cap}NOM? "
 ETWO 'N', 'O'          \
 ECHR 'M'               \ Encoded as:   "{26}<227>M? "
 ECHR '?'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 201:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 202:    ""
                        \
                        \ Encoded as:   ""

 ECHR 'P'               \ Token 203:    "PERDU DE VUE À {single cap}"
 ETWO 'E', 'R'          \
 ECHR 'D'               \ Encoded as:   "P<244>DU[179]VUE[183]{19}"
 ECHR 'U'
 ETOK 179
 ECHR 'V'
 ECHR 'U'
 ECHR 'E'
 ETOK 183
 EJMP 19
 EQUB VE

 ECHR '.'               \ Token 204:    ".{cr}
 EJMP 12                \                {cr}
 EJMP 12                \                 {single cap}"
 ECHR ' '               \
 EJMP 19                \ Encoded as:   ".{12}{12} {19}"
 EQUB VE

 ECHR '"'               \ Token 205:    "À QUAI"
 ECHR ' '               \
 ETWO 'Q', 'U'          \ Encoded as:   "" <254>AI
 ECHR 'A'
 ECHR 'I'
 EQUB VE

 EQUB VE                \ Token 206:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 207:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 208:    ""
                        \
                        \ Encoded as:   ""

 EJMP 26                \ Token 209:    " {single cap}ERRIUS"
 ETWO 'E', 'R'          \
 ECHR 'R'               \ Encoded as:   "{26}<244>RI<236>"
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

 EQUB VE                \ Token 210:    ""
                        \
                        \ Encoded as:   ""

 ECHR ' '               \ Token 211:    " LA {single cap}MARINE {single cap}
 ETWO 'L', 'A'          \                SPATIALE DE SA {single cap}MAJESTÉ"
 EJMP 26                \
 ECHR 'M'               \ Encoded as:   " <249>{26}M[174]{26}SP<245>I<228>E[179]
 ETOK 174               \                SA{26}<239>J[184]<"
 EJMP 26
 ECHR 'S'
 ECHR 'P'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'A', 'L'
 ECHR 'E'
 ETOK 179
 ECHR 'S'
 ECHR 'A'
 EJMP 26
 ETWO 'M', 'A'
 ECHR 'J'
 ETOK 184
 ECHR '<'
 EQUB VE

 ETOK 177               \ Token 212:    ".{cr}
 EJMP 12                \                {left align}{cr}
 EJMP 8                 \                {tab 6}{all caps}  {single cap}FIN DU
 EJMP 1                 \                MESSAGE"
 ECHR ' '               \
 EJMP 26                \ Encoded as:   "[177]{12}{8}{1} {26}F<240> DU M<237>SA
 ECHR 'F'               \                <231>"
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'D'
 ECHR 'U'
 ECHR ' '
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EQUB VE

 ECHR ' '               \ Token 213:    " {single cap}COMMANDANT {commander
 ETOK 154               \                name}, JE {lower case}SUIS LE CAPITAINE
 ECHR ' '               \                {mission captain's name} DE LA {single
 EJMP 4                 \                cap}MARINE {single cap}SPATIALE DE SA
 ECHR ','               \                {single cap}MAJESTÉ"
 ECHR ' '               \
 ETOK 181               \ Encoded as:   " [154] {4}, [181]{13}[171][178]CAP<219>
 EJMP 13                \                A<240>E {27} DE[211]"
 ETOK 171
 ETOK 178
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ETWO 'I', 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ECHR 'E'
 ECHR ' '
 EJMP 27
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ETOK 211
 EQUB VE

 EQUB VE                \ Token 214:    ""
                        \
                        \ Encoded as:   ""

 EJMP 15                \ Token 215:    "{left align} PLANÈTE INCONNUE "
 ECHR ' '               \
 ETOK 145               \ Encoded as:   "{15} [145] <240>C<223><225>E "
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'N', 'U'
 ECHR 'E'
 ECHR ' '
 EQUB VE

 EJMP 9                 \ Token 216:    "{clear screen}
 EJMP 8                 \                {tab 6}{move to row 9,lower case}{all
 EJMP 23                \                caps}  {single cap}MESSAGES REÇUS"
 EJMP 1                 \
 ECHR ' '               \ Encoded as:   "{9}{8}{23}{1} {26}M<237>SA<231>S <242>@
 EJMP 26                \                <236>"
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR 'S'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR '@'
 ETWO 'U', 'S'
 EQUB VE

 ECHR 'D'               \ Token 217:    "DE {single cap}REMIGNY"
 ECHR 'E'               \
 EJMP 26                \ Encoded as:   "DE{26}<242>MIGNY"
 ETWO 'R', 'E'
 ECHR 'M'
 ECHR 'I'
 ECHR 'G'
 ECHR 'N'
 ECHR 'Y'
 EQUB VE

 ECHR 'D'               \ Token 218:    "DE {single cap}SEVIGNY"
 ECHR 'E'               \
 EJMP 26                \ Encoded as:   "DE{26}<218>VIGNY"
 ETWO 'S', 'E'
 ECHR 'V'
 ECHR 'I'
 ECHR 'G'
 ECHR 'N'
 ECHR 'Y'
 EQUB VE

 ECHR 'D'               \ Token 219:    "DE {single cap}ROMANCHE"
 ECHR 'E'               \
 EJMP 26                \ Encoded as:   "DE{26}RO<239>NCHE"
 ECHR 'R'
 ECHR 'O'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'C'
 ECHR 'H'
 ECHR 'E'
 EQUB VE

 ETOK 203               \ Token 220:    "PERDU DE VUE À {single cap}{single cap}
 EJMP 19                \                REESDICE"
 ETWO 'R', 'E'          \
 ETWO 'E', 'S'          \ Encoded as:   "PERDU DE VUE À {single cap}{single cap}
 ETWO 'D', 'I'          \                REESDICE"
 ETWO 'C', 'E'
 EQUB VE

 ECHR ' '               \ Token 221:    " ON PENSE QUE SERAIT ALLÉ DANS CETTE
 ETWO 'O', 'N'          \                GALAXIE"
 ECHR ' '               \
 ECHR 'P'               \ Encoded as:   " <223> P<246><218> [192]<218><248><219>
 ETWO 'E', 'N'          \                 <228>L< D<255>S C<221>TE G<228>AXIE"
 ETWO 'S', 'E'
 ECHR ' '
 ETOK 192
 ETWO 'S', 'E'
 ETWO 'R', 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR '<'
 ECHR ' '
 ECHR 'D'
 ETWO 'A', 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ETWO 'E', 'T'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'I'
 ECHR 'E'
 EQUB VE

 EJMP 25                \ Token 222:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {move to row 7, lower case}{justify}
 EJMP 14                \                {lower case} {single cap}BONJOUR
 EJMP 13                \                {single cap}COMMANDANT {commander
 ECHR ' '               \                name}.{cr}
 ETOK 191               \                {cr}
 ETOK 154               \                 {single cap}JE SUIS {single cap}AGENT
 ECHR ' '               \                {single cap}BLAKE DES SERVICES SECRETS
 EJMP 4                 \                DE LA {single cap}MARINE {single cap}
 ETOK 204               \                SPATIALE.{cr}
 ETOK 181               \                {cr}
 ECHR 'S'               \                 {single cap}{single cap}LA {single
 ECHR 'U'               \                cap}MARINE A GARDÉ LES {single cap}
 ECHR 'I'               \                THARGOIDS À DISTANCE PENDANT PLUSIEURS
 ECHR 'S'               \                ANNÉES. {single cap}MAIS LA SITUATION A
 EJMP 26                \                CHANGÉ.{cr}
 ECHR 'A'               \                {cr}
 ETWO 'G', 'E'          \                 {single cap}{single cap}NOS GARS SONT
 ECHR 'N'               \                PRTS À ALLER JUSQU'À LA BASE DE CES
 ECHR 'T'               \                ASSASSINS.{cr}
 EJMP 26                \                {cr}
 ECHR 'B'               \                 {single cap}{wait for key press}
 ETWO 'L', 'A'          \                {clear screen}
 ECHR 'K'               \                {move to row 7, lower case}{single cap}
 ECHR 'E'               \                NOUS {lower case}AVONS OBTENU LES PLANS
 ECHR ' '               \                DE DÉFENSE POUR LEURS MONDES ORIGINELS.
 ETOK 195               \                {cr}
 ETWO 'S', 'E'          \                {cr}
 ECHR 'R'               \                 {single cap}{single cap}LES INSECTES
 ECHR 'V'               \                IGNORENT QUE NOUS AVONS CES PLANS.{cr}
 ECHR 'I'               \                {cr}
 ETWO 'C', 'E'          \                 {single cap}{single cap}SI JE LES
 ECHR 'S'               \                ENVOIE À NOTRE BASE DE {single cap}
 ECHR ' '               \                BIRERA, ILS INTERCEPTERONT LE MESSAGE.
 ETWO 'S', 'E'          \                {single cap}IL ME FAUT UN NAVIRE
 ECHR 'C'               \                ÉMISSAIRE.{cr}
 ECHR 'R'               \                {cr}
 ETWO 'E', 'T'          \                 {single cap}{single cap}VOUS TES
 ECHR 'S'               \                CHOISI.{cr}
 ETOK 179               \                {cr}
 ETWO 'L', 'A'          \                 {single cap}{wait for key press}
 EJMP 26                \                {clear screen}
 ECHR 'M'               \                {move to row 9, lower case}{single cap}
 ETOK 174               \                LES PLANS SONT CODÉS POUR CETTE
 EJMP 26                \                TRANSMISSION.{cr}
 ECHR 'S'               \                {cr}
 ECHR 'P'               \                 {single cap}{tab 6}VOUS SEREZ PAYÉ.
 ETWO 'A', 'T'          \                {cr}
 ECHR 'I'               \                {cr}
 ETWO 'A', 'L'          \                 {single cap} {single cap}BONNE CHANCE
 ECHR 'E'               \                {single cap}COMMANDANT.{cr}
 ETOK 204               \                {left align}{cr}
 EJMP 19                \                {tab 6}{all caps}  {single cap}FIN DU
 ETWO 'L', 'A'          \                 MESSAGE{wait for key press}"
 EJMP 26                \
 ECHR 'M'               \ Encoded as:   "{25}{9}{29}{14}{13} [191][154] {4}[204]
 ETOK 174               \                [181]SUIS{26}A<231>NT{26}B<249>KE [195]
 ETOK 129               \                <218>RVI<233>S <218>CR<221>S[179]<249>
 ECHR 'G'               \                {26}M[174]{26}SP<245>I<228>E[204]{19}
 ETWO 'A', 'R'          \                <249>{26}M[174][129]G<238>D< <229>S{26}
 ECHR 'D'               \                <226><238>GOIDS[183]<241><222><255>
 ECHR '<'               \                [188]P<246>D<255>T [196]IEURS <255>N<
 ECHR ' '               \                <237>.{26}<239>IS [182]S<219>U<245>I
 ETWO 'L', 'E'          \                <223>[129]CH<255>G<[204]{19}<227>S G
 ECHR 'S'               \                <238>S S<223>T PR[193]S[183]<228><229>R
 EJMP 26                \                 J<236><254>'" [182]BA<218>[179]<233>S
 ETWO 'T', 'H'          \                 ASSASS<240>S[204]{24}{9}{29}{19}N<217>
 ETWO 'A', 'R'          \                S {13}[172]S OBTE<225> [187]P<249>NS
 ECHR 'G'               \                [179]D<F<246><218> [175] <229>URS M
 ECHR 'O'               \                <223>[195]<253>IG<240>ELS[204]{19}[187]
 ECHR 'I'               \                <240><218>CT<237> IG<227><242>NT [192]N
 ECHR 'D'               \                <217>S [172]S <233>S P<249>NS[204]{19}S
 ECHR 'S'               \                I [181][187]<246>VOIE[183]<227>T<242> B
 ETOK 183               \                A<218> DE{26}<234><242><248>, <220>S
 ETWO 'D', 'I'          \                 <240>T<244><233>PT<244><223>T [178]M
 ETWO 'S', 'T'          \                <237>SA<231>.{26}<220> ME FAUT UN[173]<
 ETWO 'A', 'N'          \                MISSAI<242>[204]{19}[190] [193]<237> CH
 ETOK 188               \                OISI[204]{24}{9}{23}{19}[187]P<249>NS S
 ECHR 'P'               \                <223>T COD<S [175] C<221>TE T<248>NSMIS
 ETWO 'E', 'N'          \                SI<223>[204]{8}[190] <218><242>Z PAY<
 ECHR 'D'               \                [204]{26}B<223>NE CH<255>[188][154]
 ETWO 'A', 'N'          \                [212]{24}"
 ECHR 'T'
 ECHR ' '
 ETOK 196
 ECHR 'I'
 ECHR 'E'
 ECHR 'U'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'N'
 ECHR '<'
 ETWO 'E', 'S'
 ECHR '.'
 EJMP 26
 ETWO 'M', 'A'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ETOK 182
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'U'
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 129
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'G'
 ECHR '<'
 ETOK 204
 EJMP 19
 ETWO 'N', 'O'
 ECHR 'S'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'S'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ETOK 193
 ECHR 'S'
 ETOK 183
 ETWO 'A', 'L'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'J'
 ETWO 'U', 'S'
 ETWO 'Q', 'U'
 ECHR '`'
 ECHR '"'
 ECHR ' '
 ETOK 182
 ECHR 'B'
 ECHR 'A'
 ETWO 'S', 'E'
 ETOK 179
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'S'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 29
 EJMP 19
 ECHR 'N'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ' '
 EJMP 13
 ETOK 172
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'T'
 ECHR 'E'
 ETWO 'N', 'U'
 ECHR ' '
 ETOK 187
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ETOK 179
 ECHR 'D'
 ECHR '<'
 ECHR 'F'
 ETWO 'E', 'N'
 ETWO 'S', 'E'
 ECHR ' '
 ETOK 175
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'U'
 ECHR 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'M'
 ETWO 'O', 'N'
 ETOK 195
 ETWO 'O', 'R'
 ECHR 'I'
 ECHR 'G'
 ETWO 'I', 'N'
 ECHR 'E'
 ECHR 'L'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ETOK 187
 ETWO 'I', 'N'
 ETWO 'S', 'E'
 ECHR 'C'
 ECHR 'T'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'I'
 ECHR 'G'
 ETWO 'N', 'O'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR ' '
 ETOK 192
 ECHR 'N'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ' '
 ETOK 172
 ECHR 'S'
 ECHR ' '
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ECHR 'S'
 ECHR 'I'
 ECHR ' '
 ETOK 181
 ETOK 187
 ETWO 'E', 'N'
 ECHR 'V'
 ECHR 'O'
 ECHR 'I'
 ECHR 'E'
 ETOK 183
 ETWO 'N', 'O'
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 EJMP 26
 ETWO 'B', 'I'
 ETWO 'R', 'E'
 ETWO 'R', 'A'
 ECHR ','
 ECHR ' '
 ETWO 'I', 'L'
 ECHR 'S'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ETWO 'E', 'R'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ETOK 178
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR '.'
 EJMP 26
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'A'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETOK 173
 ECHR '<'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'A'
 ECHR 'I'
 ETWO 'R', 'E'
 ETOK 204
 EJMP 19
 ETOK 190
 ECHR ' '
 ETOK 193
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ECHR 'O'
 ECHR 'I'
 ECHR 'S'
 ECHR 'I'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 23
 EJMP 19
 ETOK 187
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'S'
 ETWO 'O', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'D'
 ECHR '<'
 ECHR 'S'
 ECHR ' '
 ETOK 175
 ECHR ' '
 ECHR 'C'
 ETWO 'E', 'T'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 204
 EJMP 8
 ETOK 190
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'Y'
 ECHR '<'
 ETOK 204
 EJMP 26
 ECHR 'B'
 ETWO 'O', 'N'
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETOK 188
 ETOK 154
 ETOK 212
 EJMP 24
 EQUB VE

 EJMP 25                \ Token 223:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {move to row 7, lower case}{justify}
 EJMP 8                 \                {lower case} {single cap}BRAVO {single
 EJMP 14                \                cap}COMMANDANT.{cr}
 EJMP 13                \                {cr}
 EJMP 26                \                 {single cap}NOUS N'OUBLIERONS PAS CE
 ECHR 'B'               \                QUE VOUS AVEZ FAIT POUR NOUS.{cr}
 ETWO 'R', 'A'          \                {cr}
 ECHR 'V'               \                 {single cap}{single cap}NOUS IGNORIONS
 ECHR 'O'               \                QUE LES {single cap}THARGOIDS AVAIENT
 ECHR ' '               \                CONSCIENCE DE VOTRE EXISTENCE.{cr}
 ETOK 154               \                {cr}
 ETOK 204               \                 {single cap}ACCEPTEZ UNE UNITÉ
 ECHR 'N'               \                D'ÉNERGIE MARINE COMME PAIEMENT.{cr}
 ETWO 'O', 'U'          \                {left align}{cr}{tab 6}{all caps}
 ECHR 'S'               \                  {single cap}FIN DU MESSAGE
 ECHR ' '               \                {wait for key press}"
 ECHR 'N'               \
 ECHR '`'               \ Encoded as:   "{25}{9}{29}{8}{14}{13}{26}B<248>VO
 ETWO 'O', 'U'          \                 [154][204]N<217>S N'<217>BLI<244>
 ECHR 'B'               \                <223>S PAS [188][192][190] A<250>Z FA
 ECHR 'L'               \                <219> [175] N<217>S[204]{19}N<217>S IG
 ECHR 'I'               \                <227>RI<223>S [192]<229>S{26}<226><238>
 ETWO 'E', 'R'          \                GOIDS AVAI<246>T C<223>SCI<246><233>
 ETWO 'O', 'N'          \                [179]VOT<242> EXI<222><246><233>[204]AC
 ECHR 'S'               \                <233>PTEZ UNE UN<219>< D'<N<244>GIE M
 ECHR ' '               \                [174] COMME PAIEM<246>T[212]{24}
 ECHR 'P'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETOK 188
 ETOK 192
 ETOK 190
 ECHR ' '
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'F'
 ECHR 'A'
 ETWO 'I', 'T'
 ECHR ' '
 ETOK 175
 ECHR ' '
 ECHR 'N'
 ETWO 'O', 'U'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ECHR 'N'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ' '
 ECHR 'I'
 ECHR 'G'
 ETWO 'N', 'O'
 ECHR 'R'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR ' '
 ETOK 192
 ETWO 'L', 'E'
 ECHR 'S'
 EJMP 26
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR 'C'
 ECHR 'I'
 ETWO 'E', 'N'
 ETWO 'C', 'E'
 ETOK 179
 ECHR 'V'
 ECHR 'O'
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ECHR 'I'
 ETWO 'S', 'T'
 ETWO 'E', 'N'
 ETWO 'C', 'E'
 ETOK 204
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR 'E'
 ECHR 'Z'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'I', 'T'
 ECHR '<'
 ECHR ' '
 ECHR 'D'
 ECHR '`'
 ECHR '<'
 ECHR 'N'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'M'
 ETOK 174
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'I'
 ECHR 'E'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 224:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 225:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 226:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 227:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 228:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 229:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 230:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 231:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 232:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 233:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 234:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 235:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 236:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 237:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 238:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 239:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 240:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 241:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 242:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 243:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 244:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 245:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 246:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 247:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 248:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 249:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 250:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 251:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 252:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 253:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 254:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 255:    ""
                        \
                        \ Encoded as:   ""

