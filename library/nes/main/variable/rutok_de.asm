\ ******************************************************************************
\
\       Name: RUTOK_DE
\       Type: Variable
\   Category: Text
\    Summary: The second extended token table for recursive tokens 0-26 (DETOK3)
\             (German)
\  Deep dive: Extended system descriptions
\             Extended text tokens
\             Multi-language support in NES Elite
\             The Constrictor mission
\
\ ------------------------------------------------------------------------------
\
\ Contains the tokens for extended description overrides of systems that match
\ the system number in RUPLA_DE and the conditions in RUGAL_DE.
\
\ The three variables work as follows:
\
\   * The RUPLA_DE table contains the system numbers
\
\   * The RUGAL_DE table contains the galaxy numbers and mission criteria
\
\   * The RUTOK_DE table contains the extended token to display instead of the
\     normal extended description if the criteria in RUPLA_DE and RUGAL_DE are
\     met
\
\ See the PDESC routine for details of how extended system descriptions work.
\
\ The encodings shown for each extended text token use the following notation:
\
\   {n}           Jump token                n = 1 to 31
\   [n?]          Random token              n = 91 to 128
\   [n]           Recursive token           n = 129 to 215
\   <n>           Two-letter token          n = 215 to 255
\
\ ******************************************************************************

.RUTOK_DE

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 EJMP 19                \ Token 1:      "{single cap}DIE {single cap}KOLONISTEN
 ETWO 'D', 'I'          \                HABEN GEGEN DER  {single cap}
 ECHR 'E'               \                INTERGALAKTISCHE {single cap}KLONING
 EJMP 26                \                {single cap}PROTOKOL VERSTOENß MAN MU
 ECHR 'K'               \                SIE MEIDEN"
 ECHR 'O'               \
 ECHR 'L'               \ Encoded as:   "{19}<241>E{26}KOL<223>I<222><246> H
 ETWO 'O', 'N'          \                <216><246> <231><231>N [155]{26}<240>T
 ECHR 'I'               \                <244>G<228>AK<251>SCHE{26}KL<223><240>G
 ETWO 'S', 'T'          \                {26}PROTOKOL V<244><222>O[3?]<246>;
 ETWO 'E', 'N'          \                 <239>N MU[3?] SIE MEID<246>"
 ECHR ' '
 ECHR 'H'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'G', 'E'
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR ' '
 ETOK 155
 EJMP 26
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'K'
 ETWO 'T', 'I'
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ECHR 'L'
 ETWO 'O', 'N'
 ETWO 'I', 'N'
 ECHR 'G'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'T'
 ECHR 'O'
 ECHR 'K'
 ECHR 'O'
 ECHR 'L'
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ETWO 'S', 'T'
 ECHR 'O'
 ERND 3
 ETWO 'E', 'N'
 ECHR ';'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR ' '
 ECHR 'M'
 ECHR 'U'
 ERND 3
 ECHR ' '
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ECHR 'I'
 ECHR 'D'
 ETWO 'E', 'N'
 EQUB VE

 EJMP 19                \ Token 2:      "{single cap}CONSTRICTOR WURDE ZULETZT
 ECHR 'C'               \                GESEHEN IN {single cap} {single cap}
 ETWO 'O', 'N'          \                REESDICE, {single cap}KOMMANDANT"
 ETWO 'S', 'T'          \
 ECHR 'R'               \ Encoded as:   "{19}C<223><222>RICT<253> [203]{19}<242>
 ECHR 'I'               \                <237><241><233>, [154]"
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

 EJMP 19                \ Token 3:      "{single cap}EIN GEFHRLICH AUSSEHENDES
 ECHR 'E'               \                {single cap}SCHIFF FLOG VOR EINER
 ETWO 'I', 'N'          \                {single cap}WEILE VON HIER AB. {single
 ECHR ' '               \                cap}ES SAH AUS, ALS OB ES NACH {single
 ETWO 'G', 'E'          \                cap}AREXE FLGE"
 ECHR 'F'               \
 ERND 0                 \ Encoded as:   "{19}E<240> <231>F[0?]HRLICH A<236><218>
 ECHR 'H'               \                H<246>D<237>{26}SCHIFF F<224>G V<253> E
 ECHR 'R'               \                <240><244>{26}WE<220>E V<223> HI<244>
 ECHR 'L'               \                 <216>.{26}<237> SAH A<236>, <228>S OB
 ECHR 'I'               \                 <237> NACH{26}<238>E<230> FL[1?]<231>"
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'S', 'E'
 ECHR 'H'
 ETWO 'E', 'N'
 ECHR 'D'
 ETWO 'E', 'S'
 EJMP 26
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ECHR 'F'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'W'
 ECHR 'E'
 ETWO 'I', 'L'
 ECHR 'E'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'A', 'B'
 ECHR '.'
 EJMP 26
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'S'
 ECHR 'A'
 ECHR 'H'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ECHR ','
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'C'
 ECHR 'H'
 EJMP 26
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'X', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'L'
 ERND 1
 ETWO 'G', 'E'
 EQUB VE

 EJMP 19                \ Token 4:      "{single cap}JA, EIN SELTSAMES {single
 ECHR 'J'               \                cap}SCHIFF BEKAM HIER EINEN
 ECHR 'A'               \                GALAKTISCHEN {single cap}
 ECHR ','               \                HYPERSPRUNGANTRIEB. {single cap}BENUTZT
 ECHR ' '               \                WURDE ES AUCHZU{single cap}DIESES
 ECHR 'E'               \                MERKWRDIGE {single cap}SCHIFF TAU ES E
 ETWO 'I', 'N'          \                WIE AUS DEM {single cap}NI ES S AUF,
 ECHR ' '               \                UND VERSCHWAND AUCH WIEDER GENAUSO
 ETWO 'S', 'E'          \                SCHNELL. {single cap}MAN SAGT, ES FLGE
 ECHR 'L'               \                NACH {single cap}INBIBE"
 ECHR 'T'               \
 ECHR 'S'               \ Encoded as:   "{19}JA, E<240> <218>LTSAM<237>{26}SCHIF
 ECHR 'A'               \                F <247>KAM HI<244> E<240><246> G<228>AK
 ECHR 'M'               \                <251>SCH<246>{26}HYP<244>SPRUNG<255>TRI
 ETWO 'E', 'S'          \                EB.{26}<247><225>TZT WURDE <237> AUCH
 EJMP 26                \                [159]{19}<241>E<218>S M<244>KW[2?]R
 ECHR 'S'               \                <241><231>{26}SCHIFF TAU[161]E WIE A
 ECHR 'C'               \                <236> DEM{26}NI[161]S AUF, UND V<244>SC
 ECHR 'H'               \                HW<255>D AUCH WI<252><244> <231>NAU
 ECHR 'I'               \                <235> SCHNELL.{26}<239>N SAGT, <237> FL
 ECHR 'F'               \                [1?]<231> NACH{26}<240><234><247>"
 ECHR 'F'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'K'
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ECHR 'H'
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'K'
 ETWO 'T', 'I'
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'P'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ECHR 'G'
 ETWO 'A', 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'E'
 ECHR 'B'
 ECHR '.'
 EJMP 26
 ETWO 'B', 'E'
 ETWO 'N', 'U'
 ECHR 'T'
 ECHR 'Z'
 ECHR 'T'
 ECHR ' '
 ECHR 'W'
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'C'
 ECHR 'H'
 ETOK 159
 EJMP 19
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'M'
 ETWO 'E', 'R'
 ECHR 'K'
 ECHR 'W'
 ERND 2
 ECHR 'R'
 ETWO 'D', 'I'
 ETWO 'G', 'E'
 EJMP 26
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ECHR 'T'
 ECHR 'A'
 ECHR 'U'
 ETOK 161
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'M'
 EJMP 26
 ECHR 'N'
 ECHR 'I'
 ETOK 161
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 ECHR ','
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'W'
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ETWO 'E', 'D'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'G', 'E'
 ECHR 'N'
 ECHR 'A'
 ECHR 'U'
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'N'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR '.'
 EJMP 26
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR ' '
 ECHR 'S'
 ECHR 'A'
 ECHR 'G'
 ECHR 'T'
 ECHR ','
 ECHR ' '
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'F'
 ECHR 'L'
 ERND 1
 ETWO 'G', 'E'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'C'
 ECHR 'H'
 EJMP 26
 ETWO 'I', 'N'
 ETWO 'B', 'I'
 ETWO 'B', 'E'
 EQUB VE

 EJMP 19                \ Token 5:      "{single cap}EIN MCHTIGES {single
 ECHR 'E'               \                cap}SCHIFF GRIFF MICH VOR {single cap}
 ETWO 'I', 'N'          \                AUSAR AN. {single cap}MEINE {single
 ECHR ' '               \                cap}LASER KONNTEN DIESEM [91-95]N NI ES
 ECHR 'M'               \                EINMAL EINEN {single cap}KRATZER
 ERND 0                 \                VERPASSEN."
 ECHR 'C'               \
 ECHR 'H'               \ Encoded as:   "{19}E<240> M[0?]CH<251><231>S{26}SCHIFF
 ETWO 'T', 'I'          \                 GRIFF MICH V<253>{26}A<236><238> <255>
 ETWO 'G', 'E'          \                .{26}ME<240>E{26}<249><218>R K<223>NT
 ECHR 'S'               \                <246> <241>E<218>M [24?]N NI[161] E
 EJMP 26                \                <240>M<228> E<240><246>{26}KR<245>Z
 ECHR 'S'               \                <244> V<244>PAS<218>N."
 ECHR 'C'
 ECHR 'H'
 ECHR 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ECHR 'G'
 ECHR 'R'
 ECHR 'I'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'R'
 EJMP 26
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'A', 'R'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR '.'
 EJMP 26
 ECHR 'M'
 ECHR 'E'
 ETWO 'I', 'N'
 ECHR 'E'
 EJMP 26
 ETWO 'L', 'A'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'K'
 ETWO 'O', 'N'
 ECHR 'N'
 ECHR 'T'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 ECHR 'M'
 ECHR ' '
 ERND 24
 ECHR 'N'
 ECHR ' '
 ECHR 'N'
 ECHR 'I'
 ETOK 161
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ECHR 'M'
 ETWO 'A', 'L'
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'K'
 ECHR 'R'
 ETWO 'A', 'T'
 ECHR 'Z'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR 'P'
 ECHR 'A'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR '.'
 EQUB VE

 EJMP 19                \ Token 6:      "{single cap}ACH JA, EIN FR ES ERLICHER
 ECHR 'A'               \                {single cap}GAUNER SCHO AUF VIELE
 ECHR 'C'               \                DIESER SCHRECKLICHEN {single cap}
 ECHR 'H'               \                PIRATEN UND FUHR NACHHER NACH {single
 ECHR ' '               \                cap}USLERI"
 ECHR 'J'               \
 ECHR 'A'               \ Encoded as:   "{19}ACH JA, E<240> F[2?]R[161]<244>LICH
 ECHR ','               \                <244>{26}GAUN<244> SCHO[3?] AUF VIE
 ECHR ' '               \                <229> <241>E<218>R SCH<242>CKLICH<246>
 ECHR 'E'               \                {26}PIR<245><246> UND FUHR NACHH<244> N
 ETWO 'I', 'N'          \                ACH{26}<236><229>RI"
 ECHR ' '
 ECHR 'F'
 ERND 2
 ECHR 'R'
 ETOK 161
 ETWO 'E', 'R'
 ECHR 'L'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'G'
 ECHR 'A'
 ECHR 'U'
 ECHR 'N'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ECHR 'O'
 ERND 3
 ECHR ' '
 ECHR 'A'
 ECHR 'U'
 ECHR 'F'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'E'
 ETWO 'L', 'E'
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'E'
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'C'
 ECHR 'K'
 ECHR 'L'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'P'
 ECHR 'I'
 ECHR 'R'
 ETWO 'A', 'T'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'F'
 ECHR 'U'
 ECHR 'H'
 ECHR 'R'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'C'
 ECHR 'H'
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'C'
 ECHR 'H'
 EJMP 26
 ETWO 'U', 'S'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR 'I'
 EQUB VE

 EJMP 19                \ Token 7:      "{single cap}SIE KNNEN SICH DEN [91-95]
 ECHR 'S'               \                VORNEHMEN, WENN {single cap}SIE WOLLEN.
 ECHR 'I'               \                {single cap}ER IST IN {single
 ECHR 'E'               \                cap}ORARRA"
 ECHR ' '               \
 ECHR 'K'               \ Encoded as:   "{19}SIE K[1?]NN<246> SICH D<246> [24?]
 ERND 1                 \                 V<253>NEHM<246>, W<246>N{26}SIE WOL
 ECHR 'N'               \                <229>N.{26}<244> I<222> <240>{26}<253>
 ECHR 'N'               \                <238><248>"
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'S'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'N'
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'R'
 ECHR 'N'
 ECHR 'E'
 ECHR 'H'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'N'
 EJMP 26
 ECHR 'S'
 ECHR 'I'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'O'
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'N'
 ECHR '.'
 EJMP 26
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'I', 'N'
 EJMP 26
 ETWO 'O', 'R'
 ETWO 'A', 'R'
 ETWO 'R', 'A'
 EQUB VE

 ERND 25                \ Token 8:      "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

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

 EJMP 19                \ Token 21:     "{single cap}DA SIND {single cap}SIE
 ECHR 'D'               \                ABER IN DER FALSCHEN {single cap}
 ECHR 'A'               \                GALAXIS!ZU{single cap}DA DRAUEN GIBT ES
 ECHR ' '               \                EINEN [91-95] VON EINEM {single cap}
 ECHR 'S'               \                PIRATENZU"
 ETWO 'I', 'N'          \
 ECHR 'D'               \ Encoded as:   "{19}DA S<240>D{26}SIE <216><244> <240>
 EJMP 26                \                 D<244> F<228>SCH<246>{26}G<228>AXIS!
 ECHR 'S'               \                [159]{19}DA D<248>U[3?]<246> GIBT <237>
 ECHR 'I'               \                 E<240><246> [24?] V<223> E<240>EM{26}
 ECHR 'E'               \                PIR<245><246>[159]"
 ECHR ' '
 ETWO 'A', 'B'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'F'
 ETWO 'A', 'L'
 ECHR 'S'
 ECHR 'C'
 ECHR 'H'
 ETWO 'E', 'N'
 EJMP 26
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'I'
 ECHR 'S'
 ECHR '!'
 ETOK 159
 EJMP 19
 ECHR 'D'
 ECHR 'A'
 ECHR ' '
 ECHR 'D'
 ETWO 'R', 'A'
 ECHR 'U'
 ERND 3
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'G'
 ECHR 'I'
 ECHR 'B'
 ECHR 'T'
 ECHR ' '
 ETWO 'E', 'S'
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ETWO 'E', 'N'
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'V'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'E'
 ETWO 'I', 'N'
 ECHR 'E'
 ECHR 'M'
 EJMP 26
 ECHR 'P'
 ECHR 'I'
 ECHR 'R'
 ETWO 'A', 'T'
 ETWO 'E', 'N'
 ETOK 159

