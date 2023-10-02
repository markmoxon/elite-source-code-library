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
 ECHR 'A'               \ Encoded as:   "
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

 EJMP 25                \ Token 11:     "
 EJMP 9
 EJMP 29
 EJMP 14
 EJMP 26
 ETOK 164
 ECHR 'T'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ETOK 213
 ECHR '.'
 EJMP 26
 ECHR 'I'
 ECHR 'H'
 ETWO 'R', 'E'
 EJMP 26
 ETWO 'D', 'I'
 ETWO 'E', 'N'
 ETWO 'S', 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'R'
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ETWO 'E', 'D'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'B'
 ETWO 'E', 'N'
 ERND 1
 ETWO 'T', 'I'
 ECHR 'G'
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
                        \ Encoded as:   "

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

 EQUB VE                \ Token 37:     "

 EQUB VE                \ Token 38:     "

 EQUB VE                \ Token 39:     "

 EQUB VE                \ Token 40:     "

 EQUB VE                \ Token 41:     "

 EQUB VE                \ Token 42:     "

 EQUB VE                \ Token 43:     "

 EQUB VE                \ Token 44:     "

 EQUB VE                \ Token 45:     "

 EQUB VE                \ Token 46:     "

 EQUB VE                \ Token 47:     "

 EQUB VE                \ Token 48:     "

 EQUB VE                \ Token 49:     "

 EQUB VE                \ Token 50:     "

 EQUB VE                \ Token 51:     "

 EQUB VE                \ Token 52:     "

 EQUB VE                \ Token 53:     "

 EQUB VE                \ Token 54:     "

 EQUB VE                \ Token 55:     "

 EQUB VE                \ Token 56:     "

 EQUB VE                \ Token 57:     "

 EQUB VE                \ Token 58:     "

 EQUB VE                \ Token 59:     "

 EQUB VE                \ Token 60:     "

 EQUB VE                \ Token 61:     "

 EQUB VE                \ Token 62:     "

 EQUB VE                \ Token 63:     "

 EQUB VE                \ Token 64:     "

 EQUB VE                \ Token 65:     "

 EQUB VE                \ Token 66:     "

 EQUB VE                \ Token 67:     "

 EQUB VE                \ Token 68:     "

 EQUB VE                \ Token 69:     "

 EQUB VE                \ Token 70:     "

 EQUB VE                \ Token 71:     "

 EQUB VE                \ Token 72:     "

 EQUB VE                \ Token 73:     "

 EQUB VE                \ Token 74:     "

 EQUB VE                \ Token 75:     "

 EQUB VE                \ Token 76:     "

 EQUB VE                \ Token 77:     "

 EQUB VE                \ Token 78:     "

 EQUB VE                \ Token 79:     "

 EQUB VE                \ Token 80:     "

 EQUB VE                \ Token 81:     "

 EQUB VE                \ Token 82:     "

 EQUB VE                \ Token 83:     "

 EQUB VE                \ Token 84:     "

 EJMP 2                 \ Token 85:     "
 ERND 31
 EJMP 13
 EQUB VE

 EQUB VE                \ Token 86:     "

 EQUB VE                \ Token 87:     "

 EQUB VE                \ Token 88:     "

 EQUB VE                \ Token 89:     "

 EQUB VE                \ Token 90:     "

 EJMP 19                \ Token 91:     "
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'U'
 ECHR 'N'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 EJMP 19                \ Token 92:     "
 ETOK 187
 ECHR 'U'
 ECHR 'R'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 EJMP 19                \ Token 93:     "
 ECHR 'L'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 EQUB VE

 EJMP 19                \ Token 94:     "
 ECHR 'G'
 ECHR 'A'
 ECHR 'U'
 ECHR 'N'
 ETWO 'E', 'R'
 EQUB VE

 EJMP 19                \ Token 95:     "
 ETOK 187
 ECHR 'U'
 ECHR 'F'
 ECHR 'T'
 EQUB VE

 EQUB VE                \ Token 96:     "

 EQUB VE                \ Token 97:     "

 EQUB VE                \ Token 98:     "

 EQUB VE                \ Token 99:     "

 EQUB VE                \ Token 100:    "

 EQUB VE                \ Token 101:    "

 EQUB VE                \ Token 102:    "

 EQUB VE                \ Token 103:    "

 EQUB VE                \ Token 104:    "

 EQUB VE                \ Token 105:    "

 EJMP 19                \ Token 106:    "
 ETWO 'A', 'N'
 ETOK 187
 ETOK 183
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR ' '
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

 EJMP 19                \ Token 107:    "
 ECHR 'J'
 ECHR 'A'
 ECHR ','
 ETOK 185
 ECHR 'U'
 ECHR 'N'
 ECHR 'H'
 ECHR 'E'
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

 EJMP 19                \ Token 108:    "
 ETWO 'S', 'E'
 ETOK 158
 ETWO 'E', 'N'
 ETOK 179
 EJMP 26
 ECHR 'I'
 ECHR 'H'
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

 ETOK 183               \ Token 109:    "
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
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

 ECHR 'F'               \ Token 110:    "
 ECHR 'A'
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'N'
 ETOK 179
 ECHR ' '
 ECHR 'N'
 ETOK 164
 ETOK 209
 EQUB VE

 ECHR ' '               \ Token 111:    "
 ECHR 'K'
 ETWO 'N', 'U'
 ECHR 'D'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR 'I'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 112:    "
 ECHR 'N'
 ECHR 'I'
 ETWO 'E', 'D'
 ECHR 'L'
 ETOK 186
 EQUB VE

 ECHR ' '               \ Token 113:    "
 ECHR 'P'
 ECHR 'U'
 ETOK 158
 ECHR 'I'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 114:    "
 ECHR 'F'
 ETWO 'R', 'E'
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR 'L'
 ETOK 186
 EQUB VE

 EQUB VE                \ Token 115:    "

 EQUB VE                \ Token 116:    "

 EQUB VE                \ Token 117:    "

 EQUB VE                \ Token 118:    "

 EQUB VE                \ Token 119:    "

 EQUB VE                \ Token 120:    "

 EQUB VE                \ Token 121:    "

 EQUB VE                \ Token 122:    "

 EQUB VE                \ Token 123:    "

 EQUB VE                \ Token 124:    "

 EQUB VE                \ Token 125:    "

 EQUB VE                \ Token 126:    "

 EQUB VE                \ Token 127:    "

 EQUB VE                \ Token 128:    "

 EQUB VE                \ Token 129:    "

 EQUB VE                \ Token 130:    "

 EQUB VE                \ Token 131:    "

 EQUB VE                \ Token 132:    "

 EQUB VE                \ Token 133:    "

 EQUB VE                \ Token 134:    "

 EQUB VE                \ Token 135:    "

 EQUB VE                \ Token 136:    "

 EQUB VE                \ Token 137:    "

 EQUB VE                \ Token 138:    "

 EQUB VE                \ Token 139:    "

 EQUB VE                \ Token 140:    "

 EQUB VE                \ Token 141:    "

 EQUB VE                \ Token 142:    "

 EQUB VE                \ Token 143:    "

 EQUB VE                \ Token 144:    "

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

 EQUB VE                \ Token 149:    "

 EJMP 9                 \ Token 150:    "
 EJMP 11
 EJMP 1
 EJMP 8
 EQUB VE

 EQUB VE                \ Token 151:    "

 EQUB VE                \ Token 152:    "

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

 EQUB VE                \ Token 165:    "

 EQUB VE                \ Token 166:    "

 EQUB VE                \ Token 167:    "

 EQUB VE                \ Token 168:    "

 EQUB VE                \ Token 169:    "

 EQUB VE                \ Token 170:    "

 EQUB VE                \ Token 171:    "

 EQUB VE                \ Token 172:    "

 EQUB VE                \ Token 173:    "

 EQUB VE                \ Token 174:    "

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

 EQUB VE                \ Token 189:    "

 EQUB VE                \ Token 190:    "

 EQUB VE                \ Token 191:    "

 EQUB VE                \ Token 192:    "

 EQUB VE                \ Token 193:    "

 EQUB VE                \ Token 194:    "

 ETWO 'I', 'N'          \ Token 195:    "
 ECHR 'G'
 ECHR ' '
 EQUB VE

 ETWO 'E', 'D'          \ Token 196:    "
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 197:    "

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

 EQUB VE                \ Token 201:    "

 EQUB VE                \ Token 202:    "

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

 EQUB VE                \ Token 206:    "

 EQUB VE                \ Token 207:    "

 EQUB VE                \ Token 208:    "

 EJMP 26                \ Token 209:    "
 ETWO 'E', 'R'
 ECHR 'R'
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

 EQUB VE                \ Token 210:    "

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

 EQUB VE                \ Token 214:    "

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

 EQUB VE                \ Token 224:    "

 EQUB VE                \ Token 225:    "

 EQUB VE                \ Token 226:    "

 EQUB VE                \ Token 227:    "

 EQUB VE                \ Token 228:    "

 EQUB VE                \ Token 229:    "

 EQUB VE                \ Token 230:    "

 EQUB VE                \ Token 231:    "

 EQUB VE                \ Token 232:    "

 EQUB VE                \ Token 233:    "

 EQUB VE                \ Token 234:    "

 EQUB VE                \ Token 235:    "

 EQUB VE                \ Token 236:    "

 EQUB VE                \ Token 237:    "

 EQUB VE                \ Token 238:    "

 EQUB VE                \ Token 239:    "

 EQUB VE                \ Token 240:    "

 EQUB VE                \ Token 241:    "

 EQUB VE                \ Token 242:    "

 EQUB VE                \ Token 243:    "

 EQUB VE                \ Token 244:    "

 EQUB VE                \ Token 245:    "

 EQUB VE                \ Token 246:    "

 EQUB VE                \ Token 247:    "

 EQUB VE                \ Token 248:    "

 EQUB VE                \ Token 249:    "

 EQUB VE                \ Token 250:    "

 EQUB VE                \ Token 251:    "

 EQUB VE                \ Token 252:    "

 EQUB VE                \ Token 253:    "

 EQUB VE                \ Token 254:    "

 EQUB VE                \ Token 255:    "

