\ ******************************************************************************
\
\       Name: TKN1_DE
\       Type: Variable
\   Category: Text
\    Summary: The first extended token table for recursive tokens 0-255 (DETOK)
\             (German)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.TKN1_DE

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 1:      "{single cap}JA"
 ECHR 'J'               \
 ECHR 'A'               \ Encoded as:   "{single cap}NEIN"
 EQUB VE

 EJMP 19                \ Token 2:      "{single cap}NEIN"
 ECHR 'N'               \
 ETOK 183               \ Encoded as:   "{19}N[183]"
 EQUB VE

 EQUB VE                \ Token 3:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 4:      "{single cap}DEUTSCH"
 ECHR 'D'               \
 ECHR 'E'               \ Encoded as:   "{19}DEUT[187]"
 ECHR 'U'
 ECHR 'T'
 ETOK 187
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

 EJMP 19                \ Token 8:      "{single cap}NEUER {single cap}NOME: "
 ECHR 'N'               \
 ECHR 'E'               \ Encoded as:   "{19}NEU<244>{26}<227>ME: "
 ECHR 'U'
 ETWO 'E', 'R'
 EJMP 26
 ETWO 'N', 'O'
 ECHR 'M'
 ECHR 'E'
 ECHR ':'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 9:      ""
                        \
                        \ Encoded as:   ""

 EJMP 23                \ Token 10:     "{move to row 9, lower case}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case} {single cap}SEID GEGRT
 EJMP 26                \                {single cap} KOMMANDANT {commander
 ETWO 'S', 'E'          \                name}. {single cap}ICH {lower case}BIN
 ECHR 'I'               \                {single cap}KAPITN DER {single cap}
 ECHR 'D'               \                RAUMFAHRTMARINE UNSERER {single cap}
 ECHR ' '               \                MAJESTT. {single cap}ICH BITTE
 ETWO 'G', 'E'          \                ...
 ECHR 'G'               \                ...
 ECHR 'R'
 ERND 2
 ERND 3
 ECHR 'T'
 ETOK 213
 ECHR '.'
 EJMP 26
 ETOK 186
 ECHR ' '
 ECHR 'B'
 ETWO 'I', 'T'
 ECHR 'T'
 ECHR 'E'
 ETOK 179
 ECHR ' '
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ETOK 183
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'M'
 ECHR 'O'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 EJMP 26
 ECHR 'I'
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'T'
 ECHR 'V'
 ECHR 'O'
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'N'
 EJMP 26
 ECHR 'Z'
 ECHR 'E'
 ETWO 'I', 'T'
 ETOK 204
 ECHR 'W'
 ECHR 'I'
 ECHR 'R'
 ECHR ' '
 ECHR 'W'
 ERND 2
 ECHR 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ETWO 'R', 'E'
 ECHR 'U'
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ETOK 183
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'K'
 ETWO 'L', 'E'
 ETWO 'I', 'N'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'G'
 ECHR ' '
 ECHR 'F'
 ERND 2
 ECHR 'R'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ETWO 'E', 'R'
 ECHR 'F'
 ERND 2
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 22
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'I'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'M'
 ETOK 182
 ECHR ','
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'S'
 ETOK 179
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR 'T'
 ETOK 161
 ECHR 'S'
 ETOK 186
 ECHR ' '
 ECHR 'U'
 ECHR 'M'
 ETOK 185
 ECHR 'N'
 ECHR 'E'
 ECHR 'U'
 ETWO 'E', 'S'
 EJMP 26
 ECHR 'M'
 ECHR 'O'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ','
 EJMP 26
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ','
 ECHR ' '
 ETOK 156
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR ' '
 ETOK 183
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ECHR 'U'
 ETWO 'E', 'N'
 EJMP 26
 ETOK 187
 ETWO 'I', 'L'
 ECHR 'D'
 ETWO 'G', 'E'
 ECHR 'N'
 ETWO 'E', 'R'
 ETWO 'A', 'T'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'G', 'E'
 ECHR 'R'
 ERND 2
 ETWO 'S', 'T'
 ETWO 'E', 'T'
 ECHR ' '
 ECHR 'I'
 ETWO 'S', 'T'
 ETOK 204
 EJMP 19
 ETWO 'L', 'E'
 ECHR 'I'
 ETOK 155
 ECHR 'W'
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ETOK 161
 ETWO 'G', 'E'
 ETWO 'S', 'T'
 ECHR 'O'
 ECHR 'H'
 ETWO 'L', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 19
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ETOK 187
 ECHR 'W'
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 ETOK 157
 ECHR ' '
 ECHR 'F'
 ERND 2
 ECHR 'N'
 ECHR 'F'
 EJMP 26
 ECHR 'M'
 ETWO 'O', 'N'
 ETWO 'A', 'T'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'R'
 EJMP 26
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 EJMP 26
 ETWO 'X', 'E'
 ETWO 'E', 'R'
 ECHR '.'
 EJMP 26
 ETWO 'E', 'S'
 ECHR ' '
 EJMP 28
 ETOK 204
 EJMP 22
 EJMP 19
 ETWO 'S', 'O'
 ECHR 'L'
 ECHR 'L'
 ECHR 'T'
 ETWO 'E', 'N'
 ETOK 179
 ECHR ' '
 ECHR 'S'
 ETOK 186
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ETOK 159
 ECHR ' '
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 187
 ECHR 'L'
 ECHR 'I'
 ECHR 'E'
 ERND 3
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'I'
 ECHR 'H'
 ECHR 'N'
 ECHR ' '
 ETWO 'A', 'N'
 ETOK 159
 ECHR 'N'
 ECHR 'E'
 ECHR 'H'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ETWO 'L', 'A'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'T'
 EJMP 26
 ECHR 'I'
 ECHR 'H'
 ECHR 'R'
 EJMP 26
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'G'
 ECHR ','
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'S'
 ETOK 182
 ETOK 160
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ETWO 'E', 'N'
 ETOK 178
 ETWO 'E', 'S'
 ETOK 160
 ECHR 'V'
 ETWO 'E', 'R'
 ETOK 162
 ETWO 'E', 'N'
 ETOK 204
 ETWO 'N', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'M'
 ETWO 'I', 'L'
 ETWO 'I', 'T'
 ERND 0
 ECHR 'R'
 ECHR 'I'
 ETOK 187
 ETWO 'E', 'N'
 EJMP 26
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'N'
 ECHR ' '
 ECHR 'K'
 ERND 1
 ECHR 'N'
 ECHR 'N'
 ETWO 'E', 'N'
 ECHR ' '
 ETOK 147
 ECHR 'N'
 ECHR 'E'
 ECHR 'U'
 ETWO 'E', 'N'
 EJMP 26
 ETOK 187
 ETWO 'I', 'L'
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'U'
 ECHR 'R'
 ECHR 'C'
 ECHR 'H'
 ECHR 'D'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 19
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ETOK 181
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR ' '
 EJMP 6
 ERND 17
 EJMP 5
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'G', 'E'
 ETWO 'S', 'T'
 ETWO 'A', 'T'
 ECHR 'T'
 ETWO 'E', 'T'
 ETOK 177
 EJMP 8
 EJMP 19
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 EJMP 26
 ECHR 'G'
 ECHR 'L'
 ERND 2
 ECHR 'C'
 ECHR 'K'
 ECHR ','
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 22
 EQUB VE

 EJMP 25                \ Token 11:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {move to row 7, lower case}
 EJMP 14                \                {justify}
 EJMP 26                \                 {single cap}ACHTUNG {single cap}
 ETOK 164               \                KOMMANDANT {commander name}. {single
 ECHR 'T'               \                cap}ICH {lower case}BIN {single cap}
 ECHR 'U'               \                KAPITN DER {single cap}RAUMFAHRTMARINE
 ECHR 'N'               \                UNSERER {single cap}MAJESTT. {single
 ECHR 'G'               \                cap}IHRE {single cap}DIENSTE WERDEN
 ETOK 213               \                WIEDER BENTIGT.{cr}
 ECHR '.'               \                {cr}
 EJMP 26                \                 {single cap}WENN {single cap}SIE SO
 ECHR 'I'               \                GUT WREN, NACH {single cap}CEERDI ZU
 ECHR 'H'               \                FAHREN, WERDEN {single cap}SIE DORT
 ETWO 'R', 'E'          \                GENAUE {single cap}ANWEISUNGEN
 EJMP 26                \                ERHALTEN.{cr}
 ETWO 'D', 'I'          \                {cr}
 ETWO 'E', 'N'          \                 {single cap}{single cap}WENN {single
 ETWO 'S', 'T'          \                cap}SIE ERFOLGREICH SIND, SO WERDEN
 ECHR 'E'               \                {single cap}SIE REICHLICH BELOHNT.{cr}
 ECHR ' '               \                {left align}{cr}
 ECHR 'W'               \                {tab 6}{all caps} {single cap}ENDE DER
 ETWO 'E', 'R'          \                 {single cap}NACHRICHT
 ECHR 'D'               \                {wait for key press}"
 ETWO 'E', 'N'          \
 ECHR ' '               \ Encoded as:   "{25}{9}{29}{14}{26}[164]TUNG[213].{26}I
 ECHR 'W'               \                H<242>{26}<241><246><222>E W<244>D<246>
 ECHR 'I'               \                 WI<252><244> B<246>[1?]<251>GT[204]W
 ETWO 'E', 'D'          \                <246>N[179] <235> GUT W[0?]<242>N, N
 ETWO 'E', 'R'          \                [164]{26}<233><244><241>[160]FAH<242>N,
 ECHR ' '               \                 W<244>D<246>[179] D<253>T <231>NAUE
 ECHR 'B'               \                {26}<255>WEISUN<231>N <244>H<228>T<246>
 ETWO 'E', 'N'          \                [204]{19}W<246>N[179] <244>FOLG<242>
 ERND 1                 \                [186] S<240>D, <235> W<244>D<246>[179]
 ETWO 'T', 'I'          \                 <242>[186]L[186] <247><224>HNT[212]
 ECHR 'G'               \                {24}"
 ECHR 'T'
 ETOK 204
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'G'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ECHR 'W'
 ERND 0
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR ','
 ECHR ' '
 ECHR 'N'
 ETOK 164
 EJMP 26
 ETWO 'C', 'E'
 ETWO 'E', 'R'
 ETWO 'D', 'I'
 ETOK 160
 ECHR 'F'
 ECHR 'A'
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR ','
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ETOK 179
 ECHR ' '
 ECHR 'D'
 ETWO 'O', 'R'
 ECHR 'T'
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR 'A'
 ECHR 'U'
 ECHR 'E'
 EJMP 26
 ETWO 'A', 'N'
 ECHR 'W'
 ECHR 'E'
 ECHR 'I'
 ECHR 'S'
 ECHR 'U'
 ECHR 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ' '
 ETWO 'E', 'R'
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'T'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ETWO 'E', 'R'
 ECHR 'F'
 ECHR 'O'
 ECHR 'L'
 ECHR 'G'
 ETWO 'R', 'E'
 ETOK 186
 ECHR ' '
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ','
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ETOK 179
 ECHR ' '
 ETWO 'R', 'E'
 ETOK 186
 ECHR 'L'
 ETOK 186
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'L', 'O'
 ECHR 'H'
 ECHR 'N'
 ECHR 'T'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 12:     ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 13:     ""
                        \
                        \ Encoded as:   ""

 EJMP 21                \ Token 14:     "{clear bottom of screen}{single cap}
 ETOK 145               \                PLANET {single cap}NAME? "
 ETOK 200               \
 EQUB VE                \ Encoded as:   "{21}[145][200]"

 EJMP 25                \ Token 15:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {move to row 7, lower case}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case} {single cap}BRAVO {single
 EJMP 26                \                cap}KOMMANDANT!{cr}{cr} {single cap}FR
 ECHR 'B'               \                {single cap}SIE GIBT ES STETS EINEN
 ETWO 'R', 'A'          \                {single cap}PLATZ IN DER  {single cap}
 ECHR 'V'               \                RAUMFAHRTMARINE UNSERER {single cap}
 ECHR 'O'               \                MAJESTT.{cr}
 ECHR ' '               \                {cr}
 ETOK 154               \                 {single cap}UND VIELLEICHT FRHER ALS
 ECHR '!'               \                {single cap}SIE DENKEN...{cr}
 EJMP 12                \                {left align}{cr}
 EJMP 12                \                {tab 6}{all caps} {single cap}ENDE DER
 EJMP 26                \                {single cap}NACHRICHT
 ECHR 'F'               \                {wait for key press}"
 ERND 2                 \
 ECHR 'R'               \ Encoded as:   "{25}{9}{29}{14}{13}{26}B<248>VO [154]!
 ETOK 179               \                {12}{12}{26}F[2?]R[179] GIBT[161]<222>
 ECHR ' '               \                <221>S [183]<246>{26}PL<245>Z[188][155]
 ECHR 'G'               \                [211][204]UND VIEL<229>[186]T FR[2?]H
 ECHR 'I'               \                <244> <228>S[179] D<246>K<246>..[212]
 ECHR 'B'               \                {24}"
 ECHR 'T'
 ETOK 161
 ETWO 'S', 'T'
 ETWO 'E', 'T'
 ECHR 'S'
 ECHR ' '
 ETOK 183
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'P'
 ECHR 'L'
 ETWO 'A', 'T'
 ECHR 'Z'
 ETOK 188
 ETOK 155
 ETOK 211
 ETOK 204
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 ETWO 'L', 'E'
 ETOK 186
 ECHR 'T'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ERND 2
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'S'
 ETOK 179
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR 'K'
 ETWO 'E', 'N'
 ECHR '.'
 ECHR '.'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 16:     ""
                        \
                        \ Encoded as:   ""
                        
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
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 38:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 39:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 40:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 41:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 42:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 43:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 44:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 45:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 46:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 47:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 48:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 49:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 50:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 51:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 52:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 53:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 54:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 55:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 56:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 57:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 58:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 59:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 60:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 61:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 62:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 63:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 64:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 65:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 66:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 67:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 68:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 69:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 70:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 71:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 72:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 73:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 74:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 75:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 76:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 77:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 78:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 79:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 80:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 81:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 82:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 83:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 84:     ""
                        
                        \ Encoded as:   ""

 EJMP 2                 \ Token 85:     "{sentence case}{lower case}"
 ERND 31                \
 EJMP 13                \ Encoded as:   "{2}[31?]{13}"
 EQUB VE

 EQUB VE                \ Token 86:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 87:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 88:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 89:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 90:     ""
                        
                        \ Encoded as:   ""

 EJMP 19                \ Token 91:     "{single cap}HALUNKE"
 ECHR 'H'               \
 ETWO 'A', 'L'          \ Encoded as:   "{19}H<228>UNKE"
 ECHR 'U'
 ECHR 'N'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 EJMP 19                \ Token 92:     "{single cap}SCHURKE"
 ETOK 187               \
 ECHR 'U'               \ Encoded as:   "{19}[187]URKE"
 ECHR 'R'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 EJMP 19                \ Token 93:     "{single cap}LUMP"
 ECHR 'L'               \
 ECHR 'U'               \ Encoded as:   "{19}[187]URKE"
 ECHR 'M'
 ECHR 'P'
 EQUB VE

 EJMP 19                \ Token 94:     "{single cap}GAUNER"
 ECHR 'G'               \
 ECHR 'A'               \ Encoded as:   "{19}GAUN<244>"
 ECHR 'U'
 ECHR 'N'
 ETWO 'E', 'R'
 EQUB VE

 EJMP 19                \ Token 95:     "{single cap}SCHUFT"
 ETOK 187               \
 ECHR 'U'               \ Encoded as:   "{19}[187]UFT"
 ECHR 'F'
 ECHR 'T'
 EQUB VE

 EQUB VE                \ Token 96:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 97:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 98:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 99:     ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 100:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 101:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 102:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 103:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 104:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 105:    ""
                        
                        \ Encoded as:   ""

 EJMP 19                \ Token 106:    "{single cap}ANSCHEINEND ERSCHIEN EIN
 ETWO 'A', 'N'          \                GRIMMIG AUSSEHENDES {single cap}SCHIFF
 ETOK 187               \                IN {single cap}ERRIUS"
 ETOK 183               \
 ETWO 'E', 'N'          \ Encoded as:   "{19}<255>[187][183]<246>D <244>[187]I
 ECHR 'D'               \                <246>[185]GRIMMIG A<236><218>H<246>D
 ECHR ' '               \                <237>[182] <240>[209]"
 ETWO 'E', 'R'
 ETOK 187
 ECHR 'I'
 ETWO 'E', 'N'
 ETOK 185
 ECHR 'G'
 ECHR 'R'
 ECHR 'I'
 ECHR 'M'
 ECHR 'M'
 ECHR 'I'
 ECHR 'G'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'S', 'E'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR 'D'
 ETWO 'E', 'S'
 ETOK 182
 ECHR ' '
 ETWO 'I', 'N'
 ETOK 209
 EQUB VE

 EJMP 19                \ Token 107:    "{single cap}JA, EIN UNHEIMLICHES
 ECHR 'J'               \                {single cap}SCHIFF SOLL VOR EINIGER
 ECHR 'A'               \                {single cap}ZEIT VON {single cap}ERRIUS
 ECHR ','               \                ABGEFLOGEN SEIN"
 ETOK 185               \
 ECHR 'U'               \ Encoded as:   "{19}JA,[185]UNHEIML[186]<237>[182]
 ECHR 'N'               \                 <235>LL [157] [183]I<231>R{26}ZE<219>
 ECHR 'H'               \                 V<223>[209] <216><231>F<224><231>N
 ECHR 'E'               \                 <218><240>"
 ECHR 'I'
 ECHR 'M'
 ECHR 'L'
 ETOK 186
 ETWO 'E', 'S'
 ETOK 182
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 157
 ECHR ' '
 ETOK 183
 ECHR 'I'
 ETWO 'G', 'E'
 ECHR 'R'
 EJMP 26
 ECHR 'Z'
 ECHR 'E'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ETOK 209
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'G', 'E'
 ECHR 'F'
 ETWO 'L', 'O'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'I', 'N'
 EQUB VE

 EJMP 19                \ Token 108:    "{single cap}SETZEN {single cap}SIE
 ETWO 'S', 'E'          \                {single cap}IHR DICKES {single cap}FELL
 ETOK 158               \                IN {single cap}BEWEGUNG NACH {single
 ETWO 'E', 'N'          \                cap}ERRIUS"
 ETOK 179               \
 EJMP 26                \ Encoded as:   "{19}<218>[158]<246>[179]{26}IHR <241>CK
 ECHR 'I'               \                <237>{26}FELL <240>{26}<247>WEGUNG N
 ECHR 'H'               \                [164][209]"
 ECHR 'R'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'S'
 EJMP 26
 ECHR 'F'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'I', 'N'
 EJMP 26
 ETWO 'B', 'E'
 ECHR 'W'
 ECHR 'E'
 ECHR 'G'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ECHR ' '
 ECHR 'N'
 ETOK 164
 ETOK 209
 EQUB VE

 ETOK 183               \ Token 109:    "EIN [91-95] VON EINEM NEUEN {single
 ECHR ' '               \                cap}SCHIFF WURDE IN DER {single cap}NHE
 ERND 24                \                VON {single cap}ERRIUS GESEHEN"
 ECHR ' '               \
 ECHR 'V'               \ Encoded as:   "[183] [24?] V<223> [183]EM NEU<246>
 ETWO 'O', 'N'          \                [182] WURDE[188]D<244>{26}N[0?]HE V
 ECHR ' '               \                <223>[209] <231><218>H<246>"
 ETOK 183
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ECHR 'U'
 ETWO 'E', 'N'
 ETOK 182
 ECHR ' '
 ECHR 'W'
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ETOK 188
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'N'
 ERND 0
 ECHR 'H'
 ECHR 'E'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ETOK 209
 ECHR ' '
 ETWO 'G', 'E'
 ETWO 'S', 'E'
 ECHR 'H'
 ETWO 'E', 'N'
 EQUB VE

 ECHR 'F'               \ Token 110:    "FAHREN {single cap}SIE NACH {single
 ECHR 'A'               \                cap}ERRIUS"
 ECHR 'H'               \
 ETWO 'R', 'E'          \ Encoded as:   "FAH<242>N[179] N[164][209]"
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ECHR 'N'
 ETOK 164
 ETOK 209
 EQUB VE

 ECHR ' '               \ Token 111:    " KNUDDELIG"
 ECHR 'K'               \
 ETWO 'N', 'U'          \ Encoded as:   " K<225>DDELIG"
 ECHR 'D'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR 'I'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 112:    " NIEDLICH"
 ECHR 'N'               \
 ECHR 'I'               \ Encoded as:   " NI<252>L[186]"
 ETWO 'E', 'D'
 ECHR 'L'
 ETOK 186
 EQUB VE

 ECHR ' '               \ Token 113:    " PUTZIG"
 ECHR 'P'               \
 ECHR 'U'               \ Encoded as:   " PU[158]IG"
 ETOK 158
 ECHR 'I'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 114:    " FREUNDLICH"
 ECHR 'F'               \
 ETWO 'R', 'E'          \ Encoded as:   " F<242>UNDL[186]"
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR 'L'
 ETOK 186
 EQUB VE

 EQUB VE                \ Token 115:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 116:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 117:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 118:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 119:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 120:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 121:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 122:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 123:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 124:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 125:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 126:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 127:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 128:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 129:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 130:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 131:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 132:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 133:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 134:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 135:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 136:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 137:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 138:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 139:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 140:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 141:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 142:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 143:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 144:    ""
                        
                        \ Encoded as:   ""

 EJMP 19                \ Token 145:    "
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ETWO 'E', 'T'
 EQUB VE

 EJMP 19                \ Token 146:    "
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'T'
 EQUB VE

 ETWO 'D', 'I'          \ Token 147:    "
 ECHR 'E'
 ECHR ' '
 EQUB VE

 ETWO 'D', 'I'          \ Token 148:    "
 ECHR 'E'
 ETWO 'S', 'E'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 149:    ""
                        
                        \ Encoded as:   ""

 EJMP 9                 \ Token 150:    "
 EJMP 11
 EJMP 1
 EJMP 8
 EQUB VE

 EQUB VE                \ Token 151:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 152:    ""
                        
                        \ Encoded as:   ""

 ECHR 'I'               \ Token 153:    "
 ETWO 'A', 'N'
 EQUB VE

 EJMP 19                \ Token 154:    "
 ECHR 'K'
 ECHR 'O'
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'D'               \ Token 155:    "
 ETWO 'E', 'R'
 ECHR ' '
 EQUB VE

 ECHR 'D'               \ Token 156:    "
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 EQUB VE

 ECHR 'V'               \ Token 157:    "
 ETWO 'O', 'R'
 EQUB VE

 ECHR 'T'               \ Token 158:    "
 ECHR 'Z'
 EQUB VE

 ECHR 'Z'               \ Token 159:    "
 ECHR 'U'
 EQUB VE

 ECHR ' '               \ Token 160:    "
 ETOK 159
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 161:    "
 ETWO 'E', 'S'
 ECHR ' '
 EQUB VE

 ECHR 'N'               \ Token 162:    "
 ETOK 186
 ECHR 'T'
 EQUB VE

 ECHR 'M'               \ Token 163:    "
 ETWO 'A', 'R'
 ETWO 'I', 'N'
 ECHR 'E'
 EQUB VE

 ECHR 'A'               \ Token 164:    "
 ECHR 'C'
 ECHR 'H'
 EQUB VE

 EQUB VE                \ Token 165:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 166:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 167:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 168:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 169:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 170:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 171:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 172:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 173:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 174:    ""
                        
                        \ Encoded as:   ""

 ETWO 'I', 'T'          \ Token 175:    "
 ECHR 'S'
 ECHR ' '
 EQUB VE

 EJMP 13                \ Token 176:    "
 EJMP 14
 EJMP 19
 EQUB VE

 ECHR '.'               \ Token 177:    "
 EJMP 12
 EJMP 15
 EQUB VE

 ECHR ' '               \ Token 178:    "
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 EQUB VE

 EJMP 26                \ Token 179:    "
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 EQUB VE

 ECHR ' '               \ Token 180:    "
 ECHR 'N'
 ETOK 164
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 181:    "
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR ' '
 EQUB VE

 EJMP 26                \ Token 182:    "
 ETOK 187
 ECHR 'I'
 ECHR 'F'
 ECHR 'F'
 EQUB VE

 ECHR 'E'               \ Token 183:    "
 ETWO 'I', 'N'
 EQUB VE

 ECHR ' '               \ Token 184:    "
 ECHR 'N'
 ECHR 'E'
 ECHR 'U'
 ETWO 'E', 'S'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 185:    "
 ETOK 183
 ECHR ' '
 EQUB VE

 ECHR 'I'               \ Token 186:    "
 ECHR 'C'
 ECHR 'H'
 EQUB VE

 ECHR 'S'               \ Token 187:    "
 ECHR 'C'
 ECHR 'H'
 EQUB VE

 ECHR ' '               \ Token 188:    "
 ETWO 'I', 'N'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 189:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 190:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 191:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 192:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 193:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 194:    ""
                        
                        \ Encoded as:   ""

 ETWO 'I', 'N'          \ Token 195:    "
 ECHR 'G'
 ECHR ' '
 EQUB VE

 ETWO 'E', 'D'          \ Token 196:    "
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 197:    ""
                        
                        \ Encoded as:   ""

 EJMP 26                \ Token 198:    "
 ECHR 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 ECHR 'Y'
 EQUB VE

 EJMP 25                \ Token 199:    "
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 13
 EJMP 26
 ECHR 'G'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'T'
 ECHR 'A'
 ECHR 'G'
 EJMP 26
 ECHR 'K'
 ECHR 'O'
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'A', 'N'
 ECHR 'T'
 ECHR '.'
 EJMP 26
 ECHR 'D'
 ETWO 'A', 'R'
 ECHR 'F'
 ECHR ' '
 ETOK 186
 ECHR ' '
 ECHR 'M'
 ETOK 186
 ECHR ' '
 ETOK 157
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'N'
 ECHR '?'
 EJMP 26
 ETOK 186
 ECHR ' '
 ETWO 'B', 'I'
 ECHR 'N'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ETWO 'I', 'N'
 ECHR 'Z'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ECHR '.'
 EJMP 26
 ETOK 186
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'H'
 ECHR 'E'
 ECHR ' '
 ECHR 'M'
 ETOK 186
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'I'
 ETOK 155
 ETWO 'G', 'E'
 ECHR 'Z'
 ECHR 'W'
 ECHR 'U'
 ECHR 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ','
 ECHR ' '
 ECHR 'M'
 ETOK 183
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'E'
 ECHR 'B'
 ETWO 'S', 'T'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'B'
 ETWO 'E', 'S'
 ETWO 'I', 'T'
 ECHR 'Z'
 ETOK 160
 ECHR 'V'
 ETWO 'E', 'R'
 ERND 0
 ECHR 'U'
 ERND 3
 ETWO 'E', 'R'
 ECHR 'N'
 ETOK 204
 EJMP 19
 ECHR 'F'
 ERND 2
 ECHR 'R'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ETWO 'L', 'E'
 ETWO 'I', 'N'
 ECHR 'I'
 ECHR 'G'
 ECHR 'K'
 ECHR 'E'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR '5'
 ECHR '0'
 ECHR '0'
 ECHR '0'
 EJMP 19
 ECHR 'C'
 ECHR 'R'
 ECHR ' '
 ETWO 'B', 'I'
 ETWO 'E', 'T'
 ECHR 'E'
 ECHR ' '
 ETOK 186
 EJMP 26
 ECHR 'I'
 ECHR 'H'
 ECHR 'N'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'S'
 EJMP 26
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'T'
 ETWO 'E', 'N'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'S'
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'U'
 ECHR 'M'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'N'
 ETOK 204
 EJMP 19
 ECHR 'N'
 ECHR 'E'
 ECHR 'H'
 ECHR 'M'
 ETWO 'E', 'N'
 ETOK 179
 ECHR ' '
 ETWO 'E', 'S'
 ECHR '?'
 EJMP 12
 EJMP 15
 EJMP 1
 EJMP 8
 EQUB VE

 EJMP 26                \ Token 200:    "
 ECHR 'N'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 201:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 202:    ""
                        
                        \ Encoded as:   ""

 ECHR 'W'               \ Token 203:    "
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ETOK 159
 ECHR 'L'
 ETWO 'E', 'T'
 ECHR 'Z'
 ECHR 'T'
 ECHR ' '
 ETWO 'G', 'E'
 ETWO 'S', 'E'
 ECHR 'H'
 ETWO 'E', 'N'
 ETOK 188
 EJMP 19
 ECHR ' '
 EQUB VE

 ECHR '.'               \ Token 204:    "
 EJMP 12
 EJMP 12
 ECHR ' '
 EJMP 19
 EQUB VE

 EJMP 19                \ Token 205:    "
 ETWO 'G', 'E'
 ECHR 'D'
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ECHR 'T'
 EQUB VE

 EQUB VE                \ Token 206:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 207:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 208:    ""
                        
                        \ Encoded as:   ""

 EJMP 26                \ Token 209:    "
 ETWO 'E', 'R'
 ECHR 'R'
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

 EQUB VE                \ Token 210:    ""
                        
                        \ Encoded as:   ""

 EJMP 26                \ Token 211:    "
 ETWO 'R', 'A'
 ECHR 'U'
 ECHR 'M'
 ECHR 'F'
 ECHR 'A'
 ECHR 'H'
 ECHR 'R'
 ECHR 'T'
 ETOK 163
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'R'
 EJMP 26
 ETWO 'M', 'A'
 ECHR 'J'
 ECHR 'E'
 ETWO 'S', 'T'
 ERND 0
 ECHR 'T'
 EQUB VE

 ETOK 177               \ Token 212:    "
 EJMP 12
 EJMP 8
 EJMP 1
 EJMP 26
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'N'
 ETOK 164
 ECHR 'R'
 ETOK 186
 ECHR 'T'
 EQUB VE

 ECHR ' '               \ Token 213:    "
 ETOK 154
 ECHR ' '
 EJMP 4
 ECHR '.'
 EJMP 26
 ETOK 186
 ECHR ' '
 EJMP 13
 ETWO 'B', 'I'
 ECHR 'N'
 EJMP 26
 ECHR 'K'
 ECHR 'A'
 ECHR 'P'
 ETWO 'I', 'T'
 ERND 0
 ECHR 'N'
 ECHR ' '
 EJMP 27
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 ETOK 211
 EQUB VE

 EQUB VE                \ Token 214:    ""
                        
                        \ Encoded as:   ""

 EJMP 15                \ Token 215:    "
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ETWO 'B', 'E'
 ECHR 'K'
 ETWO 'A', 'N'
 ECHR 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ETWO 'E', 'T'
 EQUB VE

 EJMP 9                 \ Token 216:    "
 EJMP 8
 EJMP 23
 EJMP 1
 ETWO 'A', 'N'
 ECHR 'K'
 ECHR 'O'
 ECHR 'M'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'E'
 EJMP 26
 ECHR 'N'
 ETOK 164
 ECHR 'R'
 ETOK 186
 ECHR 'T'
 EQUB VE

 EJMP 19                \ Token 217:    "
 ECHR 'R'
 ETOK 186
 ECHR 'T'
 ECHR 'O'
 ECHR 'F'
 ETWO 'E', 'N'
 EQUB VE

 EJMP 19                \ Token 218:    "
 ECHR 'V'
 ETWO 'A', 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'B'
 ETWO 'I', 'L'
 ECHR 'T'
 EQUB VE

 EJMP 19                \ Token 219:    "
 ECHR 'H'
 ETWO 'A', 'B'
 ECHR 'S'
 ECHR 'B'
 ECHR 'U'
 ECHR 'R'
 ECHR 'G'
 EQUB VE

 ETOK 203               \ Token 220:    "
 EJMP 19
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 EQUB VE

 ETWO 'S', 'O'          \ Token 221:    "
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'N'
 ETOK 188
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 EJMP 26
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'S'
 ECHR 'P'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'I', 'N'
 EQUB VE

 EJMP 25                \ Token 222:    "
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 13
 EJMP 26
 ECHR 'G'
 ECHR 'U'
 ECHR 'T'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'T'
 ECHR 'A'
 ECHR 'G'
 EJMP 26
 ECHR 'K'
 ECHR 'O'
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'A', 'N'
 ECHR 'T'
 ETOK 204
 EJMP 19
 ETOK 186
 ECHR ' '
 ETWO 'B', 'I'
 ECHR 'N'
 EJMP 26
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR 'T'
 EJMP 26
 ECHR 'B'
 ETWO 'L', 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'S'
 EJMP 26
 ETWO 'G', 'E'
 ECHR 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'M'
 ETWO 'D', 'I'
 ETWO 'E', 'N'
 ETWO 'S', 'T'
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ETOK 163
 ETOK 204
 EJMP 19
 ECHR 'W'
 ECHR 'I'
 ECHR 'E'
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR ','
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ETOK 163
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ETWO 'L', 'E'
 ECHR 'N'
 EJMP 26
 ECHR 'J'
 ECHR 'A'
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'N'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'G'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 EJMP 26
 ECHR 'I'
 ECHR 'H'
 ECHR 'N'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'I'
 ECHR 'M'
 ECHR ' '
 ETWO 'T', 'I'
 ECHR 'E'
 ECHR 'F'
 ETWO 'S', 'T'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'T'
 ETWO 'E', 'N'
 ECHR '.'
 EJMP 26
 ECHR 'J'
 ETWO 'E', 'T'
 ECHR 'Z'
 ECHR 'T'
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ETWO 'L', 'A'
 ETWO 'G', 'E'
 ECHR ' '
 ECHR 'S'
 ETOK 186
 ECHR ' '
 ETWO 'G', 'E'
 ERND 0
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'T'
 ETOK 204
 EJMP 19
 ECHR 'U'
 ECHR 'N'
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 EJMP 26
 ECHR 'J'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ECHR 'S'
 ECHR ' '
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'R', 'E'
 ETWO 'I', 'T'
 ECHR ','
 ECHR ' '
 ETWO 'B', 'I'
 ECHR 'S'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'S'
 EJMP 26
 ETWO 'G', 'E'
 ECHR 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'M'
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'M'
 ERND 1
 ECHR 'R'
 ETOK 155
 ETOK 157
 ETOK 159
 ETWO 'S', 'T'
 ECHR 'O'
 ERND 3
 ETWO 'E', 'N'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 29
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'T'
 ECHR 'E'
 ECHR 'I'
 ETWO 'D', 'I'
 ECHR 'G'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ECHR 'S'
 ECHR 'P'
 ECHR 'L'
 ERND 0
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'H'
 ECHR 'I'
 ETWO 'V', 'E'
 EJMP 26
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'T'
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'B'
 ECHR 'E'
 ECHR ' '
 ETOK 186
 ECHR ' '
 ETWO 'E', 'R'
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'T'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 19
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ERND 0
 ECHR 'F'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR ','
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ERND 3
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ECHR 'R'
 ECHR ' '
 ETWO 'E', 'T'
 ECHR 'W'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'E', 'R'
 ECHR ' '
 ETOK 162
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR 'A'
 ECHR 'U'
 ECHR ' '
 ECHR 'W'
 ECHR 'A'
 ECHR 'S'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'N'
 ECHR ' '
 ETOK 186
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'P'
 ECHR 'L'
 ERND 0
 ECHR 'N'
 ECHR 'E'
 ETOK 180
 ECHR 'U'
 ECHR 'N'
 ETWO 'S', 'E'
 ETWO 'R', 'E'
 ECHR 'R'
 EJMP 26
 ECHR 'B'
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 EJMP 26
 ETWO 'B', 'I'
 ETWO 'R', 'E'
 ETWO 'R', 'A'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR 'D'
 ECHR 'E'
 ECHR ','
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ERND 0
 ECHR 'F'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR 'F'
 ETWO 'A', 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR '.'
 EJMP 26
 ETOK 186
 ECHR ' '
 ECHR 'B'
 ETWO 'R', 'A'
 ECHR 'U'
 ECHR 'C'
 ECHR 'H'
 ECHR 'E'
 ECHR ' '
 ETOK 183
 ETOK 182
 ECHR ','
 ECHR ' '
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'N'
 ETOK 164
 ECHR 'R'
 ETOK 186
 ECHR 'T'
 ETOK 160
 ERND 2
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR 'B'
 ECHR 'R'
 ETWO 'I', 'N'
 ETWO 'G', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 19
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ETOK 159
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'W'
 ERND 0
 ECHR 'H'
 ECHR 'L'
 ECHR 'T'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 29
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ECHR 'P'
 ECHR 'L'
 ERND 0
 ECHR 'N'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'D'
 ETOK 188
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 ECHR 'R'
 EJMP 26
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR 'D'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ECHR ' '
 ETWO 'I', 'N'
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 EJMP 19
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'K'
 ECHR 'O'
 ETWO 'D', 'I'
 ETWO 'E', 'R'
 ECHR 'T'
 ETOK 204
 EJMP 19
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'F'
 ERND 2
 ECHR 'R'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'Z', 'A'
 ECHR 'H'
 ECHR 'L'
 ECHR 'T'
 ETOK 204
 EJMP 19
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 EJMP 26
 ECHR 'G'
 ECHR 'L'
 ERND 2
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 24
 EQUB VE

 EJMP 25                \ Token 223:    "
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 13
 EJMP 26
 ECHR 'G'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'G', 'E'
 ETWO 'M', 'A'
 ECHR 'C'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ETOK 154
 ETOK 204
 EJMP 19
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ETWO 'L', 'E'
 ECHR 'I'
 ERND 3
 ECHR 'I'
 ECHR 'G'
 ECHR ' '
 ETWO 'G', 'E'
 ETWO 'D', 'I'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ','
 ETOK 178
 ECHR 'W'
 ECHR 'I'
 ECHR 'R'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ETOK 161
 ETOK 162
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ETWO 'G', 'E'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ECHR 'I'
 ECHR 'R'
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ' '
 ETOK 162
 ECHR ' '
 ETWO 'E', 'R'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'T'
 ETWO 'E', 'T'
 ECHR ','
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ERND 3
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 EJMP 26
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ERND 2
 ECHR 'B'
 ETWO 'E', 'R'
 ETOK 179
 EJMP 26
 ECHR 'B'
 ETWO 'E', 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'D'
 ECHR ' '
 ECHR 'W'
 ECHR 'U'
 ERND 3
 ECHR 'T'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 19
 ECHR 'B'
 ETWO 'I', 'T'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'K'
 ECHR 'Z'
 ECHR 'E'
 ECHR 'P'
 ETWO 'T', 'I'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 EJMP 26
 ETWO 'E', 'N'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'I'
 ECHR 'E'
 ECHR '-'
 EJMP 19
 ETOK 183
 ECHR 'H'
 ECHR 'E'
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 EJMP 26
 ETOK 163
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'S'
 EJMP 26
 ETWO 'B', 'E'
 ETWO 'Z', 'A'
 ECHR 'H'
 ECHR 'L'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ETOK 212
 EJMP 24
 EQUB VE

 EQUB VE                \ Token 224:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 225:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 226:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 227:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 228:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 229:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 230:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 231:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 232:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 233:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 234:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 235:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 236:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 237:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 238:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 239:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 240:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 241:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 242:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 243:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 244:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 245:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 246:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 247:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 248:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 249:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 250:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 251:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 252:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 253:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 254:    ""
                        
                        \ Encoded as:   ""

 EQUB VE                \ Token 255:    ""
                        
                        \ Encoded as:   ""

