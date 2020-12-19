\ ******************************************************************************
\
\       Name: RUTOK
\       Type: Variable
\   Category: Text
\    Summary: The second extended token table for recursive tokens 0-26 (DETOK3)
\
\ ------------------------------------------------------------------------------
\
\ Contains the tokens for special extended descriptions of systems that match
\ the system number in RUPLA and the conditions in RUGAL.
\
\ The three variables work as follows:
\
\   * The RUPLA table contains the system numbers
\
\   * The RUGAL table contains the galaxy numbers and mission criteria
\
\   * The RUTOK table contains the extended token to display instead of the
\     normal extended description if the criteria in RUPLA and RUGAL are met
\
\ See the PDESC routine for details of how extended system descriptions work.
\
\ ******************************************************************************

.RUTOK

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

 ETOK 147               \ Token 1:      "THE COLONISTS HERE HAVE VIOLATED
 ECHR 'C'               \                {sentence case} INTERGALACTIC CLONING
 ECHR 'O'               \                PROTOCOL{lower case} AND SHOULD BE
 ETWO 'L', 'O'          \                AVOIDED"
 ECHR 'N'               \
 ECHR 'I'               \ Encoded as:   "[147]CO<224>NI<222>S HE<242> HA<250>
 ETWO 'S', 'T'          \                 VIOL<245><252>{2} <240>T<244>G<228>AC
 ECHR 'S'               \                <251>C C<224>N[195]PROTOCOL{13}[178]SH
 ECHR ' '               \                <217>LD <247> AVOID<252>"
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'V'
 ECHR 'I'
 ECHR 'O'
 ECHR 'L'
 ETWO 'A', 'T'
 ETWO 'E', 'D'
 EJMP 2
 ECHR ' '
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
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'N'
 ETOK 195
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'T'
 ECHR 'O'
 ECHR 'C'
 ECHR 'O'
 ECHR 'L'
 EJMP 13
 ETOK 178
 ECHR 'S'
 ECHR 'H'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'V'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ETWO 'E', 'D'
 EQUB VE

 ETOK 147               \ Token 2:      "THE CONSTRICTOR WAS LAST SEEN AT
 ECHR 'C'               \                {single cap}REESDICE, {single cap}
 ETWO 'O', 'N'          \                COMMANDER"
 ETWO 'S', 'T'          \
 ECHR 'R'               \ Encoded as:   "[147]C<223><222>RICT<253> [203]<242>
 ECHR 'I'               \                <237><241><233>, [154]"
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 203
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 ECHR ','
 ECHR ' '
 ETOK 154
 EQUB VE

 ECHR 'A'               \ Token 3:      "A [130-134] LOOKING SHIP LEFT HERE A
 ECHR ' '               \                WHILE BACK. LOOKED BOUND FOR AREXE"
 ERND 23                \
 ECHR ' '               \ Encoded as:   "A [23?] <224>OK[195][207] <229>FT HE
 ETWO 'L', 'O'          \                <242>[208]WHI<229> BACK. LOOK[196]B
 ECHR 'O'               \                <217>ND F<253> <238>E<230>"
 ECHR 'K'
 ETOK 195
 ETOK 207
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ETOK 208
 ECHR 'W'
 ECHR 'H'
 ECHR 'I'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 ECHR '.'
 ECHR ' '
 ECHR 'L'
 ECHR 'O'
 ECHR 'O'
 ECHR 'K'
 ETOK 196
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'X', 'E'
 EQUB VE

 ECHR 'Y'               \ Token 4:      "YEP, A [130-134] NEW SHIP HAD A
 ECHR 'E'               \                GALACTIC HYPERDRIVE FITTED HERE. USED
 ECHR 'P'               \                IT TOO"
 ECHR ','               \
 ETOK 208               \ Encoded as:   "YEP,[208][23?][210][207] HAD[208]G
 ERND 23                \                <228>AC<251>C HYP<244>DRI<250> F<219>
 ETOK 210               \                T[196]HE<242>. <236>[196]<219> TOO"
 ETOK 207
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'D'
 ETOK 208
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
 ECHR 'D'
 ECHR 'R'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'I', 'T'
 ECHR 'T'
 ETOK 196
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR '.'
 ECHR ' '
 ETWO 'U', 'S'
 ETOK 196
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ECHR 'O'
 EQUB VE

 ETOK 148               \ Token 5:      "THIS  [130-134] SHIP DEHYPED HERE FROM
 ECHR ' '               \                NOWHERE, SUN SKIMMED AND JUMPED. I HEAR
 ERND 23                \                IT WENT TO INBIBE"
 ECHR ' '               \
 ETOK 207               \ Encoded as:   "[148] [23?] [207] DEHYP[196]HE<242> FRO
 ECHR ' '               \                M <227>WHE<242>, SUN SKIMM<252>[178]JUM
 ECHR 'D'               \                P<252>. I HE<238> <219> W<246>T[201]
 ECHR 'E'               \                <240><234><247>"
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
 ETOK 196
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'S'
 ECHR 'K'
 ECHR 'I'
 ECHR 'M'
 ECHR 'M'
 ETWO 'E', 'D'
 ETOK 178
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'D'
 ECHR '.'
 ECHR ' '
 ECHR 'I'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'R'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 201
 ETWO 'I', 'N'
 ETWO 'B', 'I'
 ETWO 'B', 'E'
 EQUB VE

 ERND 24                \ Token 6:      "[91-95] SHIP WENT FOR ME AT AUSAR. MY
 ECHR ' '               \                LASERS DIDN'T EVEN SCRATCH THE [91-95]"
 ETOK 207               \
 ECHR ' '               \ Encoded as:   "[24?] [207] W<246>T F<253> ME <245>
 ECHR 'W'               \                 A<236><238>. MY <249>S<244>S DIDN[39]T
 ETWO 'E', 'N'          \                 EV<246> SC<248>TCH [147][24?]"
 ECHR 'T'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'A', 'R'
 ECHR '.'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ECHR ' '
 ETWO 'L', 'A'
 ECHR 'S'
 ETWO 'E', 'R'
 ECHR 'S'
 ECHR ' '
 ECHR 'D'
 ECHR 'I'
 ECHR 'D'
 ECHR 'N'
 ECHR '`'
 ECHR 'T'
 ECHR ' '
 ECHR 'E'
 ECHR 'V'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'S'
 ECHR 'C'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETOK 147
 ERND 24
 EQUB VE

 ECHR 'O'               \ Token 7:      "OH DEAR ME YES. A FRIGHTFUL ROGUE WITH
 ECHR 'H'               \                WHAT I BELIEVE YOU PEOPLE CALL A LEAD
 ECHR ' '               \                POSTERIOR SHOT UP LOTS OF THOSE BEASTLY
 ECHR 'D'               \                PIRATES AND WENT TO USLERI"
 ECHR 'E'               \
 ETWO 'A', 'R'          \ Encoded as:   "OH DE<238> ME Y<237>.[208]FRIGHTFUL ROG
 ECHR ' '               \                UE WI<226> WH<245> I <247>LIE<250>
 ECHR 'M'               \                 [179] PEOP<229> C<228>L[208]<229>AD PO
 ECHR 'E'               \                <222><244>I<253> SHOT UP <224>TS OF
 ECHR ' '               \                 <226>O<218> <247>A<222>LY PI<248>T
 ECHR 'Y'               \                <237>[178]W<246>T[201]<236><229>RI"
 ETWO 'E', 'S'
 ECHR '.'
 ETOK 208
 ECHR 'F'
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 ECHR ' '
 ECHR 'R'
 ECHR 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'I'
 ETWO 'T', 'H'
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'I'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'I'
 ECHR 'E'
 ETWO 'V', 'E'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'P'
 ECHR 'E'
 ECHR 'O'
 ECHR 'P'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'L'
 ECHR 'L'
 ETOK 208
 ETWO 'L', 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'I'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'O'
 ECHR 'T'
 ECHR ' '
 ECHR 'U'
 ECHR 'P'
 ECHR ' '
 ETWO 'L', 'O'
 ECHR 'T'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'O'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'A'
 ETWO 'S', 'T'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ETWO 'R', 'A'
 ECHR 'T'
 ETWO 'E', 'S'
 ETOK 178
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 201
 ETWO 'U', 'S'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR 'I'
 EQUB VE

 ETOK 179               \ Token 8:      "YOU CAN TACKLE THE [170-174] [91-95]
 ECHR ' '               \                IF YOU LIKE. HE'S AT ORARRA"
 ECHR 'C'               \
 ETWO 'A', 'N'          \ Encoded as:   "[179] C<255> TACK<229> [147][13?] [24?]
 ECHR ' '               \                 IF [179] LIKE. HE[39]S <245> <253>
 ECHR 'T'               \                <238><248>"
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 ETWO 'L', 'E'
 ECHR ' '
 ETOK 147
 ERND 13
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'K'
 ECHR 'E'
 ECHR '.'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ECHR '`'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'O', 'R'
 ETWO 'A', 'R'
 ETWO 'R', 'A'
 EQUB VE

 EJMP 1                 \ Token 9:      "{all caps}COMING SOON: ELITE II"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{1}COM[195]<235><223>: EL<219>E II"
 ECHR 'M'
 ETOK 195
 ETWO 'S', 'O'
 ETWO 'O', 'N'
 ECHR ':'
 ECHR ' '
 ECHR 'E'
 ECHR 'L'
 ETWO 'I', 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'I'
 ECHR 'I'
 EQUB VE

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

 ERND 25                \ Token 22:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

 ECHR 'B'               \ Token 23:     "BOY ARE YOU IN THE WRONG GALAXY!"
 ECHR 'O'               \
 ECHR 'Y'               \ Encoded as:   "BOY A<242> [179] <240> [147]WR<223>G G
 ECHR ' '               \                <228>AXY!"
 ECHR 'A'
 ETWO 'R', 'E'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 147
 ECHR 'W'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR 'G'
 ECHR ' '
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 ECHR '!'
 EQUB VE

 ETWO 'T', 'H'          \ Token 24:     "THERE'S A REAL [91-95] PIRATE OUT
 ETWO 'E', 'R'          \                THERE"
 ECHR 'E'               \
 ECHR '`'               \ Encoded as:   "<226><244>E[39]S[208]<242><228> [24?] P
 ECHR 'S'               \                I<248>TE <217>T <226><244>E"
 ETOK 208
 ETWO 'R', 'E'
 ETWO 'A', 'L'
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'E'
 EQUB VE

 ETOK 147               \ Token 25:     "THE INHABITANTS OF [86-90] ARE SO
 ETOK 193               \                AMAZINGLY PRIMITIVE THAT THEY STILL
 ECHR 'S'               \                THINK {single cap}***** ****** IS  3D"
 ECHR ' '               \
 ECHR 'O'               \ Encoded as:   "[147][193]S OF [18?] A<242> <235> A
 ECHR 'F'               \                <239>Z<240>GLY PRIMI<251><250> <226>
 ECHR ' '               \                <245> <226>EY <222><220>L <226><240>K
 ERND 18                \                 {19}***** ******[202] 3D"
 ECHR ' '
 ECHR 'A'
 ETWO 'R', 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'A'
 ETWO 'M', 'A'
 ECHR 'Z'
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ECHR 'I'
 ECHR 'M'
 ECHR 'I'
 ETWO 'T', 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'Y'
 ECHR ' '
 ETWO 'S', 'T'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'I', 'N'
 ECHR 'K'
 ECHR ' '
 EJMP 19
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR ' '
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ETOK 202
 ECHR ' '
 ECHR '3'
 ECHR 'D'
 EQUB VE

 EJMP 2                 \ Token 26:     "{sentence case}BITS'N PIECES - END OF
 ECHR 'B'               \                PART 1"
 ECHR 'I'               \
 ECHR 'T'               \ Encoded as:   "{2}BITS[39]N PIECES - END OF PART 1"
 ECHR 'S'
 ECHR '`'
 ECHR 'N'
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
 ECHR 'E'
 ECHR 'C'
 ECHR 'E'
 ECHR 'S'
 ECHR ' '
 ECHR '-'
 ECHR ' '
 ECHR 'E'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'R'
 ECHR 'T'
 ECHR ' '
 ECHR '1'
 EQUB VE

