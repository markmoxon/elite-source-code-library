\ ******************************************************************************
\
\       Name: RUTOK
\       Type: Variable
\   Category: Text
\    Summary: The second extended token table for recursive tokens 0-26 (DETOK3)
\  Deep dive: Extended system descriptions
\             Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ Contains the tokens for extended description overrides of systems that match
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

IF NOT(_NES_VERSION)
 ETOK 147               \ Token 1:      "THE COLONISTS HERE HAVE VIOLATED
 ECHR 'C'               \                {sentence case} INTERGALACTIC CLONING
 ECHR 'O'               \                PROTOCOL{lower case} AND SHOULD BE
 ETWO 'L', 'O'          \                AVOIDED"
 ECHR 'N'               \
 ECHR 'I'               \ Encoded as:   "[147]CO<224>NI<222>S HE<242> HA<250>
 ETWO 'S', 'T'          \                 VIOL<245><252>{2} <240>T<244>G<228>AC
 ECHR 'S'               \                <251>C C<224>N[195]PROTOCOL{13}[178]SH
 ECHR ' '               \                <217>LD <247> AVOID<252>"
ELIF _NES_VERSION
 EJMP 19                \ Token 1:      "{single cap}THE COLONISTS HERE HAVE
 ETWO 'T', 'H'          \                VIOLATED {single cap}INTERGALACTIC
 ECHR 'E'               \                {single cap}CLONING {single cap}
 ECHR ' '               \                PROTOCOL AND SHOULD BE AVOIDED"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{19}<226>E COL<223>I<222>S HE<242> HA
 ECHR 'L'               \                <250> VIOL<245><252>{2}<240>T<244>G
 ETWO 'O', 'N'          \                <228>AC<251>C{26}CL<223><240>G{26}PROTO
 ECHR 'I'               \                COL <255>D SH<217>LD <247> AVOID<252>"
 ETWO 'S', 'T'
 ECHR 'S'
 ECHR ' '
ENDIF
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
IF NOT(_NES_VERSION)
 EJMP 2
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
IF NOT(_NES_VERSION)
 ECHR ' '
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'N'
 ETOK 195
ELIF _NES_VERSION
 EJMP 26
 ECHR 'C'
 ECHR 'L'
 ETWO 'O', 'N'
 ETWO 'I', 'N'
 ECHR 'G'
 EJMP 26
ENDIF
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'T'
 ECHR 'O'
 ECHR 'C'
 ECHR 'O'
 ECHR 'L'
IF NOT(_NES_VERSION)
 EJMP 13
 ETOK 178
ELIF _NES_VERSION
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
ENDIF
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

IF NOT(_NES_VERSION)
 ETOK 147               \ Token 2:      "THE CONSTRICTOR WAS LAST SEEN AT
 ECHR 'C'               \                {single cap}REESDICE, {single cap}
 ETWO 'O', 'N'          \                COMMANDER"
 ETWO 'S', 'T'          \
 ECHR 'R'               \ Encoded as:   "[147]C<223><222>RICT<253> [203]<242>
 ECHR 'I'               \                <237><241><233>, [154]"
ELIF _NES_VERSION
 EJMP 19                \ Token 2:      "{single cap}THE {single cap}CONSTRICTOR
 ETWO 'T', 'H'          \                WAS LAST SEEN AT {single cap}REESDICE,
 ECHR 'E'               \                 {single cap}COMMANDER"
 EJMP 26                \
 ECHR 'C'               \ Encoded as:   "{19}<226>E{26}C<223><222>RICT<253>
 ETWO 'O', 'N'          \                 [203]{19}<242><237><241><233>, [154]"
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
ENDIF
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 203
IF _NES_VERSION
 EJMP 19
ENDIF
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 ECHR ','
 ECHR ' '
 ETOK 154
 EQUB VE

IF NOT(_NES_VERSION OR _ELITE_A_VERSION)
 ECHR 'A'               \ Token 3:      "A [130-134] LOOKING SHIP LEFT HERE A
 ECHR ' '               \                WHILE BACK. LOOKED BOUND FOR AREXE"
 ERND 23                \
 ECHR ' '               \ Encoded as:   "A [23?] <224>OK[195][207] <229>FT HE
 ETWO 'L', 'O'          \                <242>[208]WHI<229> BACK. LOOK[196]B
 ECHR 'O'               \                <217>ND F<253> <238>E<230>"
ELIF _ELITE_A_VERSION
 ECHR 'A'               \ Token 3:      "A [130-134] LOOKING SHIP LEFT HERE A
 ECHR ' '               \                WHILE BACK. LOOKED BOUND FOR AREXE"
 ERND 23                \
 ECHR ' '               \ Encoded as:   "A [23?] <224>OK[195][207] <229>FT HE
 ETWO 'L', 'O'          \                <242>[208]WHI<229> BACK. <224>OK[196]B
 ECHR 'O'               \                <217>ND F<253> <238>E<230>"
ELIF _NES_VERSION
 EJMP 19                \ Token 3:      "{single cap}A [130-134] LOOKING SHIP
 ECHR 'A'               \                LEFT HERE A WHILE BACK. {single cap}
 ECHR ' '               \                LOOKED BOUND FOR {single cap}AREXE"
 ERND 23                \
 ECHR ' '               \ Encoded as:   "{19}A [23?] <224>OK<240>G SHIP <229>FT
 ETWO 'L', 'O'          \                 HE<242> A WH<220>E BACK.{26}<224>OK
 ECHR 'O'               \                <252> B<217>ND F<253>{26}<238>E<230>"
ENDIF
 ECHR 'K'
IF NOT(_NES_VERSION)
 ETOK 195
 ETOK 207
ELIF _NES_VERSION
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'P'
ENDIF
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
IF NOT(_NES_VERSION)
 ETOK 208
ELIF _NES_VERSION
 ECHR ' '
 ECHR 'A'
 ECHR ' '
ENDIF
 ECHR 'W'
 ECHR 'H'
IF NOT(_NES_VERSION)
 ECHR 'I'
 ETWO 'L', 'E'
ELIF _NES_VERSION
 ETWO 'I', 'L'
 ECHR 'E'
ENDIF
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 ECHR '.'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_VERSION OR _NES_VERSION)
 ECHR 'L'
 ECHR 'O'
ELIF _ELITE_A_VERSION OR _NES_VERSION
 ETWO 'L', 'O'
ENDIF
 ECHR 'O'
 ECHR 'K'
IF NOT(_NES_VERSION)
 ETOK 196
ELIF _NES_VERSION
 ETWO 'E', 'D'
 ECHR ' '
ENDIF
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'X', 'E'
 EQUB VE

IF NOT(_NES_VERSION)
 ECHR 'Y'               \ Token 4:      "YEP, A [130-134] NEW SHIP HAD A
 ECHR 'E'               \                GALACTIC HYPERDRIVE FITTED HERE. USED
 ECHR 'P'               \                IT TOO"
 ECHR ','               \
 ETOK 208               \ Encoded as:   "YEP,[208][23?][210][207] HAD[208]G
 ERND 23                \                <228>AC<251>C HYP<244>DRI<250> F<219>
 ETOK 210               \                T[196]HE<242>. <236>[196]<219> TOO"
 ETOK 207
ELIF _NES_VERSION
 EJMP 19                \ Token 4:      "{single cap}YES, A [130-134] NEW SHIP
 ECHR 'Y'               \                HAD A {single cap}GALACTIC {single cap}
 ETWO 'E', 'S'          \                HYPERDRIVE FITTED HERE. {single cap}
 ECHR ','               \                USED IT TOO"
 ECHR ' '               \
 ECHR 'A'               \ Encoded as:   "{19}Y<237>, A [23?] NEW SHIP HAD A{26}G
 ECHR ' '               \                <228>AC<251>C{26}HYP<244>DRI<250> F
 ERND 23                \                <219>T<252> HE<242>.{26}U<218>D <219>
 ECHR ' '               \                 TOO"
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'P'
ENDIF
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'D'
IF NOT(_NES_VERSION)
 ETOK 208
ELIF _NES_VERSION
 ECHR ' '
 ECHR 'A'
 EJMP 26
ENDIF
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'C'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
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
IF NOT(_NES_VERSION)
 ETOK 196
ELIF _NES_VERSION
 ETWO 'E', 'D'
 ECHR ' '
ENDIF
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR '.'
IF NOT(_NES_VERSION)
 ECHR ' '
 ETWO 'U', 'S'
 ETOK 196
ELIF _NES_VERSION
 EJMP 26
 ECHR 'U'
 ETWO 'S', 'E'
 ECHR 'D'
 ECHR ' '
ENDIF
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ECHR 'O'
 EQUB VE

IF NOT(_NES_VERSION)
 ETOK 148               \ Token 5:      "THIS  [130-134] SHIP DEHYPED HERE FROM
 ECHR ' '               \                NOWHERE, SUN SKIMMED AND JUMPED. I HEAR
 ERND 23                \                IT WENT TO INBIBE"
 ECHR ' '               \
 ETOK 207               \ Encoded as:   "[148] [23?] [207] DEHYP[196]HE<242> FRO
 ECHR ' '               \                M <227>WHE<242>, SUN SKIMM<252>[178]JUM
 ECHR 'D'               \                P<252>. I HE<238> <219> W<246>T[201]
 ECHR 'E'               \                <240><234><247>"
ELIF _NES_VERSION
 EJMP 19                \ Token 5:      "{single cap}THIS  [130-134] SHIP
 ETWO 'T', 'H'          \                DEHYPED HERE FROM NOWHERE, {single cap}
 ECHR 'I'               \                SUN-{single cap}SKIMMED AND JUMPED.
 ECHR 'S'               \                {single cap}I HEAR IT WENT TO {single
 ECHR ' '               \                cap}INBIBE"
 ECHR ' '               \
 ERND 23                \ Encoded as:   "{19}<226>IS  [23?] SHIP DEHYP<252> HE
 ECHR ' '               \                <242> FROM <227>WHE<242>,{26}SUN-{19}SK
 ECHR 'S'               \                IMM<252> <255>D JUMP<252>.{26}I HE<238>
 ECHR 'H'               \                 <219> W<246>T TO{26}<240><234><247>"
 ECHR 'I'
 ECHR 'P'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
ENDIF
 ECHR 'H'
 ECHR 'Y'
 ECHR 'P'
IF NOT(_NES_VERSION)
 ETOK 196
ELIF _NES_VERSION
 ETWO 'E', 'D'
 ECHR ' '
ENDIF
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
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ECHR 'S'
 ECHR 'U'
 ECHR 'N'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 ECHR '-'
 EJMP 19
ENDIF
 ECHR 'S'
 ECHR 'K'
 ECHR 'I'
 ECHR 'M'
 ECHR 'M'
 ETWO 'E', 'D'
IF NOT(_NES_VERSION)
 ETOK 178
ELIF _NES_VERSION
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
ENDIF
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'D'
 ECHR '.'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
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
IF NOT(_NES_VERSION)
 ETOK 201
ELIF _NES_VERSION
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EJMP 26
ENDIF
 ETWO 'I', 'N'
 ETWO 'B', 'I'
 ETWO 'B', 'E'
 EQUB VE

IF NOT(_NES_VERSION OR _ELITE_A_VERSION)
 ERND 24                \ Token 6:      "[91-95] SHIP WENT FOR ME AT AUSAR. MY
 ECHR ' '               \                LASERS DIDN'T EVEN SCRATCH THE [91-95]"
 ETOK 207               \
 ECHR ' '               \ Encoded as:   "[24?] [207] W<246>T F<253> ME <245>
 ECHR 'W'               \                 A<236><238>. MY <249>S<244>S DIDN'T EV
 ETWO 'E', 'N'          \                <246> SC<248>TCH [147][24?]"
ELIF _ELITE_A_VERSION
 ERND 24                \ Token 6:      "[91-95] SHIP WENT FOR ME AT AUSAR. MY
 ECHR ' '               \                LASERS DIDN'T EVEN SCRATCH THE [91-95]"
 ETOK 207               \
 ECHR ' '               \ Encoded as:   "[24?] [207] W<246>T F<253> ME <245>
 ECHR 'W'               \                 A<236><238>. MY <249>S<244>S <241>DN'T
 ETWO 'E', 'N'          \                 EV<246> SC<248>TCH [147][24?]"
ELIF _NES_VERSION
 ERND 24                \ Token 6:      "[91-95] SHIP WENT FOR ME AT {single
 ECHR ' '               \                cap}AUSAR. MY LASERS DIDN'T EVEN
 ECHR 'S'               \                SCRATCH THE [91-95]"
 ECHR 'H'               \
 ECHR 'I'               \ Encoded as:   "[24?] SHIP W<246>T F<253> ME <245>{26}
 ECHR 'P'               \                A<236><238>.{26}MY <249><218>RS <241>DN
 ECHR ' '               \                'T EV<246> SCR<245>CH <226>E [24?]"
 ECHR 'W'
 ETWO 'E', 'N'
ENDIF
 ECHR 'T'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ETWO 'A', 'T'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ECHR 'A'
 ETWO 'U', 'S'
 ETWO 'A', 'R'
 ECHR '.'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ECHR 'M'
 ECHR 'Y'
 ECHR ' '
 ETWO 'L', 'A'
IF NOT(_NES_VERSION)
 ECHR 'S'
 ETWO 'E', 'R'
ELIF _NES_VERSION
 ETWO 'S', 'E'
 ECHR 'R'
ENDIF
 ECHR 'S'
 ECHR ' '
IF NOT(_ELITE_A_VERSION OR _NES_VERSION)
 ECHR 'D'
 ECHR 'I'
ELIF _ELITE_A_VERSION OR _NES_VERSION
 ETWO 'D', 'I'
ENDIF
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
IF NOT(_NES_VERSION)
 ETWO 'R', 'A'
 ECHR 'T'
ELIF _NES_VERSION
 ECHR 'R'
 ETWO 'A', 'T'
ENDIF
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
IF NOT(_NES_VERSION)
 ETOK 147
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR ' '
ENDIF
 ERND 24
 EQUB VE

IF NOT(_NES_VERSION)
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
ElIF _NES_VERSION
 EJMP 19                \ Token 7:      "{single cap}OH DEAR ME YES. A FRIGHTFUL
 ECHR 'O'               \                ROGUE SHOT UP LOTS OF THOSE BEASTLY
 ECHR 'H'               \                PIRATES AND WENT TO {single cap}USLERI"
 ECHR ' '               \                 
 ECHR 'D'               \ Encoded as:   "{19}OH DE<238> ME Y<237>. A FRIGHTFUL R
 ECHR 'E'               \                OGUE SHOT UP <224>TS OF <226>O<218>
 ETWO 'A', 'R'          \                 <247>A<222>LY PIR<245><237> <255>D W
 ECHR ' '               \                <246>T TO{26}<236><229>RI"
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'Y'
 ETWO 'E', 'S'
 ECHR '.'
 ECHR ' '
 ECHR 'A'
 ECHR ' '
ENDIF
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
IF NOT(_NES_VERSION)
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
ENDIF
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
IF NOT(_NES_VERSION)
 ETWO 'R', 'A'
 ECHR 'T'
ELIF _NES_VERSION
 ECHR 'R'
 ETWO 'A', 'T'
ENDIF
 ETWO 'E', 'S'
IF NOT(_NES_VERSION)
 ETOK 178
ELIF _NES_VERSION
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
ENDIF
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'T'
IF NOT(_NES_VERSION)
 ETOK 201
ELIF _NES_VERSION
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EJMP 26
ENDIF
 ETWO 'U', 'S'
 ETWO 'L', 'E'
 ECHR 'R'
 ECHR 'I'
 EQUB VE

IF NOT(_NES_VERSION)
 ETOK 179               \ Token 8:      "YOU CAN TACKLE THE [170-174] [91-95]
 ECHR ' '               \                IF YOU LIKE. HE'S AT ORARRA"
 ECHR 'C'               \
 ETWO 'A', 'N'          \ Encoded as:   "[179] C<255> TACK<229> [147][13?] [24?]
 ECHR ' '               \                 IF [179] LIKE. HE'S <245> <253><238>
 ECHR 'T'               \                <248>"
ELIF _NES_VERSION
 EJMP 19                \ Token 8:      "{single cap}YOU CAN TACKLE THE
 ECHR 'Y'               \                [170-174] [91-95] IF YOU LIKE. {single
 ETWO 'O', 'U'          \                cap}HE'S AT {single cap}ORARRA"
 ECHR ' '               \                
 ECHR 'C'               \ Encoded as:   "{19}Y<217> C<255> TACK<229> <226>E
 ETWO 'A', 'N'          \                 [13?] [24?] IF Y<217> LIKE.{26}HE'S
 ECHR ' '               \                 <245>{26}<253><238><248>"
 ECHR 'T'
ENDIF
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 ETWO 'L', 'E'
 ECHR ' '
IF NOT(_NES_VERSION)
 ETOK 147
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR ' '
ENDIF
 ERND 13
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
IF NOT(_NES_VERSION)
 ETOK 179
ELIF _NES_VERSION
 ECHR 'Y'
 ETWO 'O', 'U'
ENDIF
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'K'
 ECHR 'E'
 ECHR '.'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ECHR 'H'
 ECHR 'E'
 ECHR '`'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'T'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ETWO 'O', 'R'
 ETWO 'A', 'R'
 ETWO 'R', 'A'
 EQUB VE

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)
 EJMP 1                 \ Token 9:      "{all caps}COMING SOON: ELITE II"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{1}COM[195]<235><223>: EL<219>E II"
ELIF _ELITE_A_VERSION
 EJMP 1                 \ Token 9:      "{all caps}COMING SOON: ELITE III"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{1}COM[195]<235><223>: EL<219>E III"
ELIF _NES_VERSION
 ERND 25                \ Token 9:      "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"
ENDIF
IF NOT(_NES_VERSION)
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
ENDIF
IF _ELITE_A_VERSION
 ECHR 'I'
ENDIF
IF NOT(_NES_VERSION)
 EQUB VE
ENDIF

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

IF NOT(_NES_VERSION)

 ERND 25                \ Token 22:     "[106-110]"
 EQUB VE                \
                        \ Encoded as:   "[25?]"

ENDIF

IF NOT(_NES_VERSION)
 ECHR 'B'               \ Token 23:     "BOY ARE YOU IN THE WRONG GALAXY!"
 ECHR 'O'               \
 ECHR 'Y'               \ Encoded as:   "BOY A<242> [179] <240> [147]WR<223>G G
 ECHR ' '               \                <228>AXY!"
 ECHR 'A'
 ETWO 'R', 'E'
 ECHR ' '
 ETOK 179
ELIF _NES_VERSION
 EJMP 19                \ Token 22:     "{single cap}BOY ARE YOU IN THE WRONG
 ECHR 'B'               \                 GALAXY!"
 ECHR 'O'               \
 ECHR 'Y'               \ Encoded as:   "{19}BOY <238>E Y<217> <240> <226>E WR
 ECHR ' '               \                <223>G{26}G"
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ECHR 'Y'
 ETWO 'O', 'U'
ENDIF
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
IF NOT(_NES_VERSION)
 ETOK 147
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR ' '
ENDIF
 ECHR 'W'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR 'G'
IF NOT(_NES_VERSION)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 ECHR '!'
 EQUB VE

IF NOT(_NES_VERSION)
 ETWO 'T', 'H'          \ Token 24:     "THERE'S A REAL [91-95] PIRATE OUT
 ETWO 'E', 'R'          \                THERE"
 ECHR 'E'               \
 ECHR '`'               \ Encoded as:   "<226><244>E'S[208]<242><228> [24?] PI
 ECHR 'S'               \                <248>TE <217>T <226><244>E"
 ETOK 208
ELIF _NES_VERSION
 EJMP 19                \ Token 23:     "{single cap}THERE'S A REAL [91-95]
 ETWO 'T', 'H'          \                 PIRATE OUT THERE"
 ECHR 'E'               \
 ETWO 'R', 'E'          \ Encoded as:   "{19}<226>E<242>'S A <242><228> [24?] PI
 ECHR '`'               \                R<245>E <217>T <226>E<242>"
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR ' '
ENDIF
 ETWO 'R', 'E'
 ETWO 'A', 'L'
 ECHR ' '
 ERND 24
 ECHR ' '
 ECHR 'P'
 ECHR 'I'
IF NOT(_NES_VERSION)
 ETWO 'R', 'A'
 ECHR 'T'
ELIF _NES_VERSION
 ECHR 'R'
 ETWO 'A', 'T'
ENDIF
 ECHR 'E'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'T', 'H'
IF NOT(_NES_VERSION)
 ETWO 'E', 'R'
 ECHR 'E'
ELIF _NES_VERSION
 ECHR 'E'
 ETWO 'R', 'E'
ENDIF
 EQUB VE

IF _DISC_DOCKED \ Disc: Group A: The disc version has a system description override for Anreer in galaxy 3: "THE INHABITANTS OF ANREER ARE SO AMAZINGLY PRIMITIVE THAT THEY STILL THINK STILL THINK A*****R IS A PRETTY NEAT GAME". The advanced versions have a different override: "THE INHABITANTS OF ANREER ARE SO AMAZINGLY PRIMITIVE THAT THEY STILL THINK ***** ****** IS 3D"
 ETOK 147               \ Token 25:     "THE INHABITANTS OF [86-90] ARE SO
 ETOK 193               \                AMAZINGLY PRIMITIVE THAT THEY STILL
 ECHR 'S'               \                THINK {single cap}A*****R IS A PRETTY
 ECHR ' '               \                NEAT GAME"
 ECHR 'O'               \
 ECHR 'F'               \ Encoded as:   "[147][193]S OF [18?] A<242> <235> A
 ECHR ' '               \                <239>Z<240>GLY PRIMI<251><250> <226>
 ERND 18                \                <245> <226>EY <222><220>L <226><240>K
 ECHR ' '               \                 {19}A*****R[202]A P<242>TTY NE<245>
 ECHR 'A'               \                 GAME"
ELIF _6502SP_VERSION OR _MASTER_VERSION
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
ELIF _ELITE_A_VERSION
 ETOK 147               \ Token 25:     "THE INHABITANTS OF [86-90] ARE SO
 ETOK 193               \                AMAZINGLY PRIMITIVE THAT THEY STILL
 ECHR 'S'               \                THINK {single cap}ELITE IS A PRETTY
 ECHR ' '               \                NEAT GAME"
 ECHR 'O'               \
 ECHR 'F'               \ Encoded as:   "[147][193]S OF [18?] A<242> <235> A
 ECHR ' '               \                <239>Z<240>GLY PRIMI<251><250> <226>
 ERND 18                \                <245> <226>EY <222><220>L <226><240>K
 ECHR ' '               \                 {19}EL<219>E[202]A P<242>TTY NE<245>
 ECHR 'A'               \                 GAME"
ENDIF
IF NOT(_NES_VERSION)
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
ENDIF
IF _DISC_DOCKED \ Disc: See group A
 ECHR 'A'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR '*'
 ECHR 'R'
 ETOK 202
 ECHR 'A'
 ECHR ' '
 ECHR 'P'
 ETWO 'R', 'E'
 ECHR 'T'
 ECHR 'T'
 ECHR 'Y'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'G'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 EQUB VE
ELIF _6502SP_VERSION OR _MASTER_VERSION
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
ELIF _ELITE_A_VERSION
 ECHR 'E'
 ECHR 'L'
 ETWO 'I', 'T'
 ECHR 'E'
 ETOK 202
 ECHR 'A'
 ECHR ' '
 ECHR 'P'
 ETWO 'R', 'E'
 ECHR 'T'
 ECHR 'T'
 ECHR 'Y'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETWO 'A', 'T'
 ECHR ' '
 ECHR 'G'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 EQUB VE
ENDIF

IF _6502SP_VERSION \ Advanced: Some of the advanced versions have an extra token for overriding the system description for Lave. The source disc variant of the 6502SP version has the bizarre: "Bits'n Pieces - End Of Part 1". The Executive version has: "This message is available only on the executive version of this program". And the Master version has: "WELCOME TO  THE SEVENTEENTH GALAXY!", which is only shown if we are in galaxy 17 (though it isn't possible to get there, so this never gets shown)

IF _SOURCE_DISC

 EJMP 2                 \ Token 26:     "{sentence case}BITS'N PIECES - END OF
 ECHR 'B'               \                PART 1"
 ECHR 'I'               \
 ECHR 'T'               \ Encoded as:   "{2}BITS'N PIECES - END OF PART 1"
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

ELIF _EXECUTIVE

 ETWO 'T', 'H'          \ Token 26:     "THIS MESSAGE IS AVAILABLE ONLY ON THE
 ECHR 'I'               \                EXECUTIVE VERSION OF THIS PROGRAM"
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "<226>IS M<237>SA<231>[202]AVAI<249>B
 ECHR 'M'               \                <229> <223>LY <223> [147]E<230>CU<251>
 ETWO 'E', 'S'          \                <250> <250>RSI<223> OF <226>IS PROGRAM"
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 ETOK 202
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ECHR 'I'
 ETWO 'L', 'A'
 ECHR 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR ' '
 ETOK 147
 ECHR 'E'
 ETWO 'X', 'E'
 ECHR 'C'
 ECHR 'U'
 ETWO 'T', 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'V', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ECHR 'O'
 ECHR 'G'
 ECHR 'R'
 ECHR 'A'
 ECHR 'M'
 EQUB VE

ENDIF

ELIF _MASTER_VERSION

 EJMP 1                 \ Token 26:     "{all caps}WELCOME TO  THE SEVENTEENTH
 ECHR 'W'               \                GALAXY!"
 ECHR 'E'               \
 ECHR 'L'               \ Encoded as:   "{1}WELCOME[201] [147]<218><250>NTE<246>
 ECHR 'C'               \                <226> GA<249>XY!"
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 ETOK 201
 ECHR ' '
 ETOK 147
 ETWO 'S', 'E'
 ETWO 'V', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR 'E'
 ETWO 'E', 'N'
 ETWO 'T', 'H'
 ECHR ' '
 ECHR 'G'
 ECHR 'A'
 ETWO 'L', 'A'
 ECHR 'X'
 ECHR 'Y'
 ECHR '!'
 EQUB VE

ENDIF

IF _6502SP_VERSION \ 6502SP: The Executive version has an extra token for overriding the system description for Riedquat: "Only this executive version has the @ toggle"

IF _EXECUTIVE

 ETWO 'O', 'N'          \ Token 27:     "ONLY THIS EXECUTIVE VERSION HAS THE @
 ECHR 'L'               \                TOGGLE"
 ECHR 'Y'               \
 ECHR ' '               \ Encoded as:   "<223>LY [148]E<230>CU<251><250> <250>RS
 ETOK 148               \                I<223> HAS [147]@ TOGG<229>"
 ECHR 'E'
 ETWO 'X', 'E'
 ECHR 'C'
 ECHR 'U'
 ETWO 'T', 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'V', 'E'
 ECHR 'R'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETOK 147
 ECHR '@'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ECHR 'G'
 ECHR 'G'
 ETWO 'L', 'E'
 EQUB VE

ENDIF

ENDIF

