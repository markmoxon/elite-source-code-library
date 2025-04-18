\ ******************************************************************************
\
\       Name: TKN1
\       Type: Variable
\   Category: Text
\    Summary: The first extended token table for recursive tokens 0-255 (DETOK)
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The encodings shown for each extended text token use the following notation:
\
\   {n}           Jump token                n = 1 to 31
\   [n?]          Random token              n = 91 to 128
\   [n]           Recursive token           n = 129 to 215
\   <n>           Two-letter token          n = 215 to 255
\
\ ******************************************************************************

.TKN1

 EQUB VE                \ Token 0:      ""
                        \
                        \ Encoded as:   ""

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 9                 \ Token 1:      "{clear screen}
 EJMP 11                \                {draw box around title}
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
IF NOT(_NES_VERSION OR _C64_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 1                 \                {all caps}
 EJMP 8                 \                {tab 6} DISK ACCESS MENU{crlf}
 ECHR ' '               \                {lf}
 ETWO 'D', 'I'          \                {sentence case}
 ECHR 'S'               \                1. LOAD NEW {single cap}COMMANDER{crlf}
 ECHR 'K'               \                2. SAVE {single cap}COMMANDER
 ECHR ' '               \                   {commander name}{crlf}
ELIF _C64_VERSION
 EJMP 1                 \                {all caps}
 EJMP 8                 \                {tab 6} {currently selected media}
 ECHR ' '               \                 ACCESS MENU{crlf}
 EJMP 30                \                {lf}
 ECHR ' '               \                {sentence case}
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
 ECHR 'A'               \                3. CATALOGUE{crlf}
 ECHR 'C'               \                4. DELETE A FILE{crlf}
 ETWO 'C', 'E'          \                5. EXIT{crlf}
 ECHR 'S'               \               "
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{9}{11}{1}{8} <241>SK AC<233>SS ME
 ECHR 'M'               \                <225><215>{10}{2}1. [149]<215>2. SA
 ECHR 'E'               \                <250> [154] {4}<215>3. C<245>A<224>GUE
 ETWO 'N', 'U'          \                <215>4. DEL<221>E[208]FI<229><215>5. EX
 ETWO '-', '-'          \                <219><215>"
 EJMP 10
 EJMP 2
 ECHR '1'
 ECHR '.'
 ECHR ' '
 ETOK 149
 ETWO '-', '-'
 ECHR '2'
ELIF _6502SP_VERSION
 ECHR 'A'               \                3. CATALOGUE{crlf}
 ECHR 'C'               \                4. DELETE A FILE{crlf}
 ETWO 'C', 'E'          \                5. EXIT{crlf}
 ECHR 'S'               \               "
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{9}{11}{30}{1}{8} <241>SK AC<233>SS ME
 ECHR 'M'               \                <225><215>{10}{2}1. [149]<215>2. SA
 ECHR 'E'               \                <250> [154] {4}<215>3. C<245>A<224>GUE
 ETWO 'N', 'U'          \                <215>4. DEL<221>E[208]FI<229><215>5. EX
 ETWO '-', '-'          \                <219><215>"
 EJMP 10
 EJMP 2
 ECHR '1'
 ECHR '.'
 ECHR ' '
 ETOK 149
 ETWO '-', '-'
 ECHR '2'
ELIF _MASTER_VERSION
 ECHR 'A'               \                3. CATALOGUE DISK{crlf}
 ECHR 'C'               \                4. DELETE FILE{crlf}
 ETWO 'C', 'E'          \                5. DEFAULT {all caps}JAMESON{sentence
 ECHR 'S'               \                   case}{crlf}
 ECHR 'S'               \                6. EXIT{crlf}
 ECHR ' '               \               "
 ECHR 'M'               \
 ECHR 'E'               \ Encoded as:   "{9}{11}{1}{8} <241>SK AC<233>SS ME
 ETWO 'N', 'U'          \                <225><215>{10}{2}1. [149]<215>2. SA
 ETWO '-', '-'          \                <250> [154] {4}<215>3. CATALOGUE DISK
 EJMP 10                \                <215>4. DEL<221>E FI<229><215>5.
 EJMP 2                 \                 DEFAULT {1}JAMESON{2}<215>6. EX<219>
 ECHR '1'               \                <215>"
 ECHR '.'               \
 ECHR ' '               \ The Master Compact release encodes the third line in a
 ETOK 149               \ more efficient manner, like this:
 ETWO '-', '-'          \
 ECHR '2'               \                <250> [154] {4}<215>3.[152]] DISK
ELIF _C64_VERSION
 ECHR 'A'               \                1. LOAD NEW {single cap}COMMANDER{crlf}
 ECHR 'C'               \                2. SAVE {single cap}COMMANDER
 ETWO 'C', 'E'          \                   {commander name}{crlf}
 ECHR 'S'               \                3. CHANGE TO {other media}{crlf}
 ECHR 'S'               \                4. DEFAULT {all caps}JAMESON{sentence
 ECHR ' '               \                   case}{crlf}
 ECHR 'M'               \                5. EXIT{crlf}
 ECHR 'E'               \               "
 ETWO 'N', 'U'          \
 ETWO '-', '-'          \ Encoded as:   "{9}{11}{1}{8} {30} AC<233>SS ME
 EJMP 10                \                <225><215>{10}{2}1. [149]<215>2. SA
 EJMP 2                 \                <250> [154] {4}<215>3. CH<255><231>
 ECHR '1'               \                [201]{31}<215>4. DEFAULT {1}JAMESON{2}
 ECHR '.'               \                <215>5. EX<219><215>"
 ECHR ' '
 ETOK 149
 ETWO '-', '-'
 ECHR '2'
ELIF _APPLE_VERSION
 ECHR 'A'               \                3. DEFAULT {all caps}JAMESON{sentence
 ECHR 'C'               \                   case}{crlf}
 ETWO 'C', 'E'          \                4. EXIT{crlf}
 ECHR 'S'               \               "
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{9}{11}{1}{8} <241>SK AC<233>SS ME
 ECHR 'M'               \                <225><215>{10}{2}1. [149]<215>2. SA
 ECHR 'E'               \                <250> [154] {4}<215>3. DEFAULT {1}JAMES
 ETWO 'N', 'U'          \                ON{2}<215>4. EX<219><215>"
 ETWO '-', '-'
 EJMP 10
 EJMP 2
 ECHR '1'
 ECHR '.'
 ECHR ' '
 ETOK 149
 ETWO '-', '-'
 ECHR '2'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR '.'
 ECHR ' '
 ECHR 'S'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ETOK 154
 ECHR ' '
 EJMP 4
 ETWO '-', '-'
 ECHR '3'
 ECHR '.'
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'T'
 ECHR 'A'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
ELIF _MASTER_VERSION

IF _SNG47

 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'T'
 ECHR 'A'
 ECHR 'L'
 ECHR 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'

ELIF _COMPACT

 ETOK 152

ENDIF

ELIF _C64_VERSION
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ETWO 'G', 'E'
 ETOK 201
 EJMP 31
ENDIF
IF _MASTER_VERSION \ Master: In the Master version, option 3 in the disc access menu is "Catalogue Disk" rather than just "Catalogue"
 ECHR ' '
 ECHR 'D'
 ECHR 'I'
 ECHR 'S'
 ECHR 'K'
ENDIF
IF NOT(_NES_VERSION OR _C64_VERSION OR _ELITE_A_ENCYCLOPEDIA OR _APPLE_VERSION)
 ETWO '-', '-'
 ECHR '4'
 ECHR '.'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Master: In the Master version, the disc access menu has an extra option, "Default JAMESON", which resets the commander to the default starting point
 ETWO 'E', 'T'
 ECHR 'E'
 ETOK 208
 ECHR 'F'
 ECHR 'I'
 ETWO 'L', 'E'
 ETWO '-', '-'
 ECHR '5'
 ECHR '.'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ETWO 'I', 'T'
 ETWO '-', '-'
ELIF _MASTER_VERSION
 ECHR 'E'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ECHR 'L'
 ECHR 'E'
 ETWO '-', '-'
 ECHR '5'
 ECHR '.'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'F'
 ECHR 'A'
 ECHR 'U'
 ECHR 'L'
 ECHR 'T'
 ECHR ' '
 EJMP 1
 ECHR 'J'
 ECHR 'A'
 ECHR 'M'
 ETWO 'E', 'S'
 ETWO 'O', 'N'
 EJMP 2
 ETWO '-', '-'
 ECHR '6'
 ECHR '.'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ETWO 'I', 'T'
 ETWO '-', '-'
ELIF _C64_VERSION
 ETWO '-', '-'
 ECHR '4'
 ECHR '.'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'F'
 ECHR 'A'
 ECHR 'U'
 ECHR 'L'
 ECHR 'T'
 ECHR ' '
 EJMP 1
 ECHR 'J'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR 'S'
 ECHR 'O'
 ECHR 'N'
 EJMP 2
 ETWO '-', '-'
 ECHR '5'
 ECHR '.'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ETWO 'I', 'T'
 ETWO '-', '-'
ELIF _APPLE_VERSION
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'F'
 ECHR 'A'
 ECHR 'U'
 ECHR 'L'
 ECHR 'T'
 ECHR ' '
 EJMP 1
 ECHR 'J'
 ECHR 'A'
 ECHR 'M'
 ETWO 'E', 'S'
 ETWO 'O', 'N'
 EJMP 2
 ETWO '-', '-'
 ECHR '4'
 ECHR '.'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ETWO 'I', 'T'
 ETWO '-', '-'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 1:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 19                \ Token 1:      "{single cap}YES"
 ECHR 'Y'               \
 ETWO 'E', 'S'          \ Encoded as:   "{19}YES"
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 EJMP 12                \ Token 2:      "{cr}
 ECHR 'W'               \                WHICH DRIVE?"
 ECHR 'H'               \
 ECHR 'I'               \ Encoded as:   "{12}WHICH [151]?"
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETOK 151
 ECHR '?'
 EQUB VE

ELIF _C64_VERSION

 ETWO 'D', 'I'          \ Token 2:      "DISK"
 ECHR 'S'               \
 ECHR 'K'               \ Encoded as:   "<241>SK"
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA OR _APPLE_VERSION

 EQUB VE                \ Token 2:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 19                \ Token 1:      "{single cap}NO"
 ETWO 'N', 'O'          \
 EQUB VE                \ Encoded as:   "{19}<227>"

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED \ Enhanced: The disc and 6502SP versions have an extra token for displaying "COMPETITION NUMBER:" when saving commander files

 ECHR 'C'               \ Token 3:      "COMPETITION NUMBER:"
 ECHR 'O'               \
 ECHR 'M'               \ Encoded as:   "COMPE<251><251><223> <225>MB<244>:"
 ECHR 'P'
 ECHR 'E'
 ETWO 'T', 'I'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'N', 'U'
 ECHR 'M'
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR ':'
 EQUB VE

ELIF _MASTER_VERSION

IF _SNG47

 ETOK 150               \ Token 3:      "{clear screen}
 ETOK 151               \                {draw box around title}
 ECHR ' '               \                {all caps}
 EJMP 16                \                {tab 6}DRIVE {drive number} CATALOGUE
 ETOK 152               \                {crlf}
 ETWO '-', '-'          \               "
 EQUB VE                \
                        \ Encoded as:   "[150][151] {16}[152]<215>"

ELIF _COMPACT

 ETOK 150               \ Token 3:      "{clear screen}
 ECHR ' '               \                    CATALOGUE
 ECHR ' '               \                {crlf}
 ECHR ' '               \               "
 ETOK 152               \
 ETWO '-', '-'          \ Encoded as:   "[150]   [152]<215>"
 EQUB VE

ENDIF

ELIF _C64_VERSION

 ECHR 'T'               \ Token 3:      "TAPE"
 ECHR 'A'               \
 ECHR 'P'               \ Encoded as:   "TAPE"
 ECHR 'E'
 EQUB VE

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 ETWO 'A', 'R'          \ Token 3:      "ARE YOU SURE?"
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "<238>E [179] SU<242>?"
 ETOK 179
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR '?'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA OR _APPLE_VERSION

 EQUB VE                \ Token 3:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 2                 \ Token 3:      "{sentence case}{single cap}IMAGINEER
 EJMP 19                \                {single cap}PRESENTS"
 ECHR 'I'               \
 ETWO 'M', 'A'          \ Encoded as:   "{2}{19}I<239>G<240>E<244>{26}P<242>
 ECHR 'G'               \                <218>NTS"
 ETWO 'I', 'N'
 ECHR 'E'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'P'
 ETWO 'R', 'E'
 ETWO 'S', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR 'S'
 EQUB VE

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Enhanced: The Master Compact release has a different title and layout for the drive catalogue screen, as the Compact only supports one drive

 ETOK 150               \ Token 4:      "{clear screen}
 ETOK 151               \                {draw box around title}
 ECHR ' '               \                {all caps}
 EJMP 16                \                {tab 6}DRIVE {drive number} CATALOGUE
 ETOK 152               \                {crlf}
 ETWO '-', '-'          \               "
 EQUB VE                \
                        \ Encoded as:   "[150][151] {16}[152]<215>"

ELIF _MASTER_VERSION

 EQUB VE                \ Token 4:      ""
                        \
                        \ Encoded as:   ""

ELIF _C64_VERSION OR _APPLE_VERSION

 ECHR 'C'               \ Token 4:      "COMPETITION NUMBER:"
 ECHR 'O'               \
 ECHR 'M'               \ Encoded as:   "COMPE<251><251><223> <225>MB<244>:"
 ECHR 'P'
 ECHR 'E'
 ETWO 'T', 'I'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'N', 'U'
 ECHR 'M'
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR ':'
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 4:      "{single cap}ENGLISH"
 ETWO 'E', 'N'          \
 ECHR 'G'               \ Encoded as:   "{19}<246>GLISH"
 ECHR 'L'
 ECHR 'I'
 ECHR 'S'
 ECHR 'H'
 EQUB VE

ENDIF

 ETOK 176               \ Token 5:      "{lower case}
 ERND 18                \                {justify}
 ETOK 202               \                {single cap}[86-90] IS [140-144].{cr}
 ERND 19                \                {left align}"
 ETOK 177               \
 EQUB VE                \ Encoded as:   "[176][18?][202][19?][177]"

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 ECHR ' '               \ Token 6:      "  LOAD NEW {single cap}COMMANDER {all
 ECHR ' '               \                caps}(Y/N)?{sentence case}{cr}{cr}"
 ETOK 149               \
 ECHR ' '               \ Encoded as:   "  [149] {1}(Y/N)?{2}{12}{12}"
 EJMP 1
 ECHR '('
 ECHR 'Y'
 ECHR '/'
 ECHR 'N'
 ECHR ')'
 ECHR '?'
 EJMP 2
 EJMP 12
 EJMP 12
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 6:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 19                \ Token 6:      "{single cap}LICENSED{cr}
 ECHR 'L'               \                 TO"
 ECHR 'I'               \
 ETWO 'C', 'E'          \ Encoded as:   "{19}LI<233>N<218>D{13} TO"
 ECHR 'N'
 ETWO 'S', 'E'
 ECHR 'D'
 EJMP 13
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 ECHR 'P'               \ Token 7:      "PRESS SPACE OR FIRE,{single cap}
 ETWO 'R', 'E'          \                COMMANDER.{cr}{cr}"
 ECHR 'S'               \
 ECHR 'S'               \ Encoded as:   "P<242>SS SPA<233> <253> FI<242>,[154].
 ECHR ' '               \                {12}{12}"
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ETWO 'O', 'R'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'R', 'E'
 ECHR ','
 ETOK 154
 ECHR '.'
 EJMP 12
 EJMP 12
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 7:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 19                \ Token 7:      "{single cap}LICENSED BY {single
 ECHR 'L'               \                cap}NINTENDO"
 ECHR 'I'               \
 ETWO 'C', 'E'          \ Encoded as:   "{19}LI<233>N<218>D BY{26}N<240>T<246>D
 ECHR 'N'               \                O"
 ETWO 'S', 'E'
 ECHR 'D'
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 EJMP 26
 ECHR 'N'
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'O'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)

 ETOK 154               \ Token 8:      "{single cap}COMMANDER'S NAME? "
 ECHR '`'               \
 ECHR 'S'               \ Encoded as:   "[154]'S[200]"
 ETOK 200
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 8:      "{single cap}NEW {single cap}NAME: "
 ECHR 'N'               \
 ECHR 'E'               \ Encoded as:   "{19}NEW{26}NAME: "
 ECHR 'W'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR ':'
 ECHR ' '
 EQUB VE

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Advanced: The disc and 6502SP versions support a "FILE TO DELETE?" prompt when deleting files via the disc access menu, but the token for this prompt isn't present in the Master version. Instead the Master version contains a token for the error message "ILLEGAL ELITE II FILE"; this message is also present in the other versions, but there it is hard-coded into a BRK block rather than being a token, and is in sentence case

 EJMP 21                \ Token 9:      "{clear bottom of screen}
 ECHR 'F'               \                FILE TO DELETE?"
 ECHR 'I'               \
 ETWO 'L', 'E'          \ Encoded as:   "{21}FI<229>[201]DEL<221>E?"
 ETOK 201
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ETWO 'E', 'T'
 ECHR 'E'
 ECHR '?'
 EQUB VE

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 EJMP 12                \ Token 9:      "{cr}
 EJMP 1                 \                {all caps}
 ETWO 'I', 'L'          \                ILLEGAL ELITE II FILE
 ETWO 'L', 'E'          \                {sentence case}"
 ECHR 'G'               \
 ETWO 'A', 'L'          \ Encoded as:   "{12}{1}<220><229>G<228> ELITE II FI
 ECHR ' '               \                <229>"
 ECHR 'E'
 ECHR 'L'
 ECHR 'I'
 ECHR 'T'
 ECHR 'E'
 ECHR ' '
 ECHR 'I'
 ECHR 'I'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'L', 'E'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 9:      ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION

 EJMP 19                \ Token 9:      "{single cap}IMAGINEER {single cap}CO.
 ECHR 'I'               \                {single cap}LTD., {single cap}JAPAN"
 ETWO 'M', 'A'          \
 ECHR 'G'               \ Encoded as:   "{19}I<239>G<240>E<244>{26}CO.{26}LTD.,
 ETWO 'I', 'N'          \                {26}JAP<255>"
 ECHR 'E'
 ETWO 'E', 'R'
 EJMP 26
 ECHR 'C'
 ECHR 'O'
 ECHR '.'
 EJMP 26
 ECHR 'L'
 ECHR 'T'
 ECHR 'D'
 ECHR '.'
 ECHR ','
 EJMP 26
 ECHR 'J'
 ECHR 'A'
 ECHR 'P'
 ETWO 'A', 'N'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 EJMP 23                \ Token 10:     "{move to row 10, white, lower case}
 EJMP 14                \                {justify}
 EJMP 2                 \                {sentence case}
 ECHR 'G'               \                GREETINGS {single cap}COMMANDER
 ETWO 'R', 'E'          \                {commander name}, I {lower case}AM
 ETWO 'E', 'T'          \                {sentence case} CAPTAIN {mission
 ETWO 'I', 'N'          \                captain's name} {lower case}OF{sentence
 ECHR 'G'               \                case} HER MAJESTY'S SPACE NAVY{lower
 ECHR 'S'               \                case} AND {single cap}I BEG A MOMENT OF
 ETOK 213               \                YOUR VALUABLE TIME.{cr}
 ETOK 178               \                 {single cap}WE WOULD LIKE YOU TO DO A
 EJMP 19                \                LITTLE JOB FOR US.{cr}
 ECHR 'I'               \                 {single cap}THE SHIP YOU SEE HERE IS A
 ECHR ' '               \                NEW MODEL, THE {single cap}CONSTRICTOR,
 ETWO 'B', 'E'          \                EQUIPED WITH A TOP SECRET NEW SHIELD
 ECHR 'G'               \                GENERATOR.{cr}
 ETOK 208               \                 {single cap}UNFORTUNATELY IT'S BEEN
 ECHR 'M'               \                STOLEN.{cr}
 ECHR 'O'               \                 {single cap}{display ship, wait for
 ECHR 'M'               \                key press}IT WENT MISSING FROM OUR SHIP
 ETWO 'E', 'N'          \                YARD ON {single cap}XEER FIVE MONTHS
 ECHR 'T'               \                AGO AND {mission 1 location hint}.{cr}
 ECHR ' '               \                 {single cap}YOUR MISSION, SHOULD YOU
 ECHR 'O'               \                DECIDE TO ACCEPT IT, IS TO SEEK AND
 ECHR 'F'               \                DESTROY THIS SHIP.{cr}
 ECHR ' '               \                 {single cap}YOU ARE CAUTIONED THAT
 ETOK 179               \                ONLY {standard tokens, sentence case}
 ECHR 'R'               \                MILITARY  LASERS{extended tokens} WILL
 ECHR ' '               \                PENETRATE THE NEW SHIELDS AND THAT THE
 ECHR 'V'               \                {single cap}CONSTRICTOR IS FITTED WITH
 ETWO 'A', 'L'          \                AN {standard tokens, sentence case}
 ECHR 'U'               \                E.C.M.SYSTEM{extended tokens}.{cr}
 ETWO 'A', 'B'          \                 {left align}{sentence case}{tab 6}GOOD
 ETWO 'L', 'E'          \                LUCK, {single cap}COMMANDER.{cr}
 ECHR ' '               \                 {left align}{tab 6}{all caps}  MESSAGE
 ETWO 'T', 'I'          \                ENDS{display ship, wait for key press}"
 ECHR 'M'               \
 ECHR 'E'               \ Encoded as:   "{23}{14}{2}G<242><221><240>GS[213][178]
 ETOK 204               \                {19}I <247>G[208]MOM<246>T OF [179]R V
 ECHR 'W'               \                <228>U<216><229> <251>ME[204]WE W<217>
 ECHR 'E'               \                LD LIKE [179][201]DO[208]L<219>T<229>
 ECHR ' '               \                 JOB F<253> <236>[204][147][207] [179]
 ECHR 'W'               \                 <218>E HE<242>[202]A[210]MODEL, [147]
 ETWO 'O', 'U'          \                {19}C<223><222>RICT<253>, E<254>IP[196]
 ECHR 'L'               \                WI<226>[208]TOP <218>CR<221>[210]SHIELD
 ECHR 'D'               \                 G<246><244><245><253>[204]UNF<253>TUN
 ECHR ' '               \                <245>ELY <219>'S <247><246> <222>OL
 ECHR 'L'               \                <246>[204]{22}<219> W<246>T MISS[195]
 ECHR 'I'               \                FROM <217>R [207] Y<238>D <223> {19}
 ECHR 'K'               \                <230><244> FI<250> M<223><226>S AGO
 ECHR 'E'               \                [178]{28}[204][179]R MISSI<223>, SH
 ECHR ' '               \                <217>LD [179] DECIDE[201]AC<233>PT
 ETOK 179               \                 <219>, IS[201]<218>EK[178]D<237>TROY
 ETOK 201               \                 [148][207][204][179] A<242> CAU<251>
 ECHR 'D'               \                <223>[196]<226><245> <223>LY {6}[116]
 ECHR 'O'               \                {5}S W<220>L P<246><221><248>TE [147]
 ETOK 208               \                NEW SHIELDS[178]<226><245> [147]{19}
 ECHR 'L'               \                C<223><222>RICT<253>[202]F<219>T[196]WI
 ETWO 'I', 'T'          \                <226> <255> {6}[108]{5}[177]{2}{8}GOOD
 ECHR 'T'               \                 LUCK, [154][212]{22}"
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'O'
 ECHR 'B'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
ELIF _NES_VERSION

 EJMP 23                \ Token 10:     "{move to row 9, lower case}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}
 EJMP 19                \                {single cap}GREETINGS {single
 ECHR 'G'               \                cap}COMMANDER {commander name}, {single
 ETWO 'R', 'E'          \                 cap}I {lower case}AM {sentence case}
 ETWO 'E', 'T'          \                {single cap}CAPTAIN {mission captain's
 ETWO 'I', 'N'          \                name} OF{sentence case} HER MAJESTY'S
 ECHR 'G'               \                SPACE NAVY{lower case} AND {single
 ECHR 'S'               \                cap}I BEG A MOMENT OF YOUR VALUABLE
 ETOK 213               \                TIME.{cr}
 ECHR ' '               \                {cr}
 ETWO 'A', 'N'          \                 {single cap}WE WOULD LIKE YOU TO DO A
 ECHR 'D'               \                LITTLE JOB FOR US.{cr}
 EJMP 26                \                {cr}
 ECHR 'I'               \                 {single cap}THE SHIP YOU SEE HERE IS A
 ECHR ' '               \                NEW MODEL, THE {single cap}CONSTRICTOR,
 ETWO 'B', 'E'          \                EQUIPPED WITH A TOP SECRET NEW SHIELD
 ECHR 'G'               \                GENERATOR.{cr}
 ETOK 208               \                {cr}
 ECHR 'M'               \                 {single cap}UNFORTUNATELY IT'S BEEN
 ECHR 'O'               \                STOLEN.{cr}
 ECHR 'M'               \                {cr}
 ETWO 'E', 'N'          \                {single cap}{display ship, wait for
 ECHR 'T'               \                key press}{single cap}IT WENT MISSING
 ECHR ' '               \                FROM OUR SHIP YARD ON {single cap}XEER
 ECHR 'O'               \                FIVE MONTHS AGO AND {mission 1 location
 ECHR 'F'               \                hint}.{cr}
 ECHR ' '               \                {cr}
 ETOK 179               \                 {single cap}YOUR MISSION, SHOULD YOU
 ECHR 'R'               \                DECIDE TO ACCEPT IT, IS TO SEEK AND
 ECHR ' '               \                DESTROY THIS SHIP.{cr}
 ECHR 'V'               \                {cr}
 ETWO 'A', 'L'          \                 {single cap}YOU ARE CAUTIONED THAT
 ECHR 'U'               \                ONLY {standard tokens, sentence case}
 ETWO 'A', 'B'          \                MILITARY  LASERS{extended tokens} WILL
 ETWO 'L', 'E'          \                GET THROUGH THE NEW SHIELDS AND THAT
 ECHR ' '               \                THE {single cap}CONSTRICTOR IS FITTED
 ETWO 'T', 'I'          \                WITH AN {standard tokens, sentence
 ECHR 'M'               \                case}E.C.M.SYSTEM{extended tokens}.{cr}
 ECHR 'E'               \                {cr}
 ETOK 204               \                 {left align}{cr}
 ECHR 'W'               \                {tab 6}{single cap}GOOD {single cap}
 ECHR 'E'               \                LUCK, {single cap}COMMANDER.{cr}
 ECHR ' '               \                 {left align}{cr}
 ECHR 'W'               \                {tab 6}{all caps}  MESSAGE
 ETWO 'O', 'U'          \                ENDS{display ship, wait for key press}"
 ECHR 'L'               \
 ECHR 'D'               \ Encoded as:   "{23}{14}{13}{19}G<242><221><240>GS[213]
 ECHR ' '               \                 AND{26}I <247>G[208]MOM<246>T OF [179]
 ECHR 'L'               \                R V<228>U<216><229> <251>ME[204]WE W
 ECHR 'I'               \                <217>LD LIKE [179][201]DO[208]L<219>T
 ECHR 'K'               \                <229> JOB F<253> <236>[204][147][207]
 ECHR 'E'               \                 [179] <218>E HE<242>[202]A[210]MODEL,
 ECHR ' '               \                 <226>E{26}C<223><222>RICT<253>, E<254>
 ETOK 179               \                IPP[196]W<219>H[208]TOP <218>CR<221>
 ETOK 201               \                [210]SHIELD <231>N<244><245><253>[204]U
 ECHR 'D'               \                NF<253>TUN<245>ELY <219>'S <247><246>
 ECHR 'O'               \                 <222>O<229>N[204]{22}{19}<219> W<246>
 ETOK 208               \                T MISS[195]FROM <217>R [207] Y<238>D
 ECHR 'L'               \                 <223>{26}<230><244> FI<250> M<223>
 ETWO 'I', 'T'          \                <226>S AGO[178]{28}[204][179]R MISSI
 ECHR 'T'               \                <223>, SH<217>LD [179] DECIDE[201]AC
 ETWO 'L', 'E'          \                <233>PT <219>, IS[201]<218>EK[178]DE
 ECHR ' '               \                <222>ROY [148][207][204][179] <238>E CA
 ECHR 'J'               \                U<251><223>[196]<226><245> <223>LY {6}
 ECHR 'O'               \                [116]{5}S W<220>L G<221> <226>R<217>GH
 ECHR 'B'               \                 [147]NEW SHIELDS[178]<226><245> <226>E
 ECHR ' '               \                {26}C<223><222>RICT<253>[202]F<219>T
 ECHR 'F'               \                [196]W<219>H <255> {6}[108]{5}[177]{8}
 ETWO 'O', 'R'          \                {19}GOOD LUCK,{26}[154][212]{22}"
ELIF _ELITE_A_ENCYCLOPEDIA

 EJMP 22                \ Token 10:     "{tab 16}"
 EQUB VE                \
                        \ Encoded as:   "{22}" ETWO 'L', 'E'

ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ETWO 'U', 'S'
 ETOK 204
 ETOK 147
 ETOK 207
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'R', 'E'
 ETOK 202
 ECHR 'A'
 ETOK 210
 ECHR 'M'
 ECHR 'O'
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ECHR ','
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
 EJMP 19
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
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
 ECHR 'E'
 ETWO 'Q', 'U'
 ECHR 'I'
 ECHR 'P'
ENDIF
IF _NES_VERSION
 ECHR 'P'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 196
 ECHR 'W'
 ECHR 'I'
 ETWO 'T', 'H'
ELIF _NES_VERSION
 ETOK 196
 ECHR 'W'
 ETWO 'I', 'T'
 ECHR 'H'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 208
 ECHR 'T'
 ECHR 'O'
 ECHR 'P'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'C'
 ECHR 'R'
 ETWO 'E', 'T'
 ETOK 210
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'G'
 ETWO 'E', 'N'
ELIF _NES_VERSION
 ETWO 'G', 'E'
 ECHR 'N'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'E', 'R'
 ETWO 'A', 'T'
 ETWO 'O', 'R'
 ETOK 204
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
 ECHR ' '
 ETWO 'I', 'T'
 ECHR '`'
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'S', 'T'
 ECHR 'O'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'L'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 22
ELIF _NES_VERSION
 ETWO 'L', 'E'
 ECHR 'N'
 ETOK 204
 EJMP 22
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'W'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ETOK 195
 ECHR 'F'
 ECHR 'R'
 ECHR 'O'
 ECHR 'M'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ETOK 207
 ECHR ' '
 ECHR 'Y'
 ETWO 'A', 'R'
 ECHR 'D'
 ECHR ' '
 ETWO 'O', 'N'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'X', 'E'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'F'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'M'
 ETWO 'O', 'N'
 ETWO 'T', 'H'
 ECHR 'S'
 ECHR ' '
 ECHR 'A'
 ECHR 'G'
 ECHR 'O'
 ETOK 178
 EJMP 28
 ETOK 204
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR ','
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'C'
 ECHR 'I'
 ECHR 'D'
 ECHR 'E'
 ETOK 201
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR ','
 ECHR ' '
 ECHR 'I'
 ECHR 'S'
 ETOK 201
 ETWO 'S', 'E'
 ECHR 'E'
 ECHR 'K'
 ETOK 178
 ECHR 'D'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETWO 'E', 'S'
 ECHR 'T'
ELIF _NES_VERSION
 ECHR 'E'
 ETWO 'S', 'T'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'R'
 ECHR 'O'
 ECHR 'Y'
 ECHR ' '
 ETOK 148
 ETOK 207
 ETOK 204
 ETOK 179
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'A'
 ETWO 'R', 'E'
ELIF _NES_VERSION
 ETWO 'A', 'R'
 ECHR 'E'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'U'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETOK 196
 ETWO 'T', 'H'
 ETWO 'A', 'T'
 ECHR ' '
 ETWO 'O', 'N'
 ECHR 'L'
 ECHR 'Y'
 ECHR ' '
 EJMP 6
 TOKN 117
 EJMP 5
 ECHR 'S'
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'P'
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'E'
ELIF _NES_VERSION
 ECHR 'G'
 ETWO 'E', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'R'
 ETWO 'O', 'U'
 ECHR 'G'
 ECHR 'H'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ETOK 147
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ECHR 'I'
 ECHR 'E'
 ECHR 'L'
 ECHR 'D'
 ECHR 'S'
 ETOK 178
 ETWO 'T', 'H'
 ETWO 'A', 'T'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
 EJMP 19
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'O', 'R'
 ETOK 202
 ECHR 'F'
 ETWO 'I', 'T'
 ECHR 'T'
 ETOK 196
 ECHR 'W'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ETWO 'T', 'H'
ELIF _NES_VERSION
 ETWO 'I', 'T'
 ECHR 'H'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ETWO 'A', 'N'
 ECHR ' '
 EJMP 6
 TOKN 108
 EJMP 5
 ETOK 177
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 2
 EJMP 8
ELIF _NES_VERSION
 EJMP 8
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'L'
 ECHR 'U'
 ECHR 'C'
 ECHR 'K'
 ECHR ','
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 22
 EQUB VE

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EJMP 25                \ Token 11:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 23                \                {move to row 10, white, lower case}
 EJMP 14                \                {justify}
 EJMP 2                 \                {sentence case}
 ECHR ' '               \                  ATTENTION {single cap}COMMANDER
 ECHR ' '               \                {commander name}, I {lower case}AM
 ETWO 'A', 'T'          \                {sentence case} CAPTAIN {mission
 ECHR 'T'               \                captain's name} {lower case}OF{sentence
 ETWO 'E', 'N'          \                case} HER MAJESTY'S SPACE NAVY{lower
 ETWO 'T', 'I'          \                case}. {single cap}WE HAVE NEED OF YOUR
 ETWO 'O', 'N'          \                SERVICES AGAIN.{cr}
 ETOK 213               \                 {single cap}IF YOU WOULD BE SO GOOD AS
 ECHR '.'               \                TO GO TO {single cap}CEERDI YOU WILL BE
 ECHR ' '               \                BRIEFED.{cr}
 EJMP 19                \                 {single cap}IF SUCCESSFUL, YOU WILL BE
 ECHR 'W'               \                WELL REWARDED.{cr}
 ECHR 'E'               \                {left align}{tab 6}{all caps}  MESSAGE
 ECHR ' '               \                ENDS{wait for key press}"
 ECHR 'H'               \
ELIF _NES_VERSION
 EJMP 23                \                {move to row 9, lower case}
 EJMP 14                \                {justify}
 ECHR ' '               \                  ATTENTION {single cap}COMMANDER
 EJMP 26                \                {commander name}, I {lower case}AM
 ETWO 'A', 'T'          \                {sentence case} CAPTAIN {mission
 ECHR 'T'               \                captain's name} {lower case}OF{sentence
 ETWO 'E', 'N'          \                case} HER MAJESTY'S SPACE NAVY{lower
 ETWO 'T', 'I'          \                case}. {single cap}WE HAVE NEED OF YOUR
 ETWO 'O', 'N'          \                SERVICES AGAIN.{cr}
 ETOK 213               \                {cr}
 ECHR '.'               \                 {single cap}IF YOU WOULD BE SO GOOD AS
 EJMP 26                \                TO GO TO {single cap}CEERDI YOU WILL BE
 ECHR 'W'               \                BRIEFED.{cr}
 ECHR 'E'               \                {cr}
 ECHR ' '               \                 {single cap}IF SUCCESSFUL, YOU WILL BE
 ECHR 'H'               \                WELL REWARDED.{cr}
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
 ECHR 'A'               \ Encoded as:   "{25}{9}{23}{14}{2}  <245>T<246><251>
 ETWO 'V', 'E'          \                <223>[213]. {19}WE HA<250> NE[196]OF
 ECHR ' '               \                 [179]R <218>RVIC<237> AGA<240>[204]IF
 ECHR 'N'               \                 [179] W<217>LD <247> <235> GOOD AS
 ECHR 'E'               \                [201]GO[201]{19}<233><244><241> [179] W
 ETOK 196               \                <220>L <247> BRIEF<252>[204]IF SUC<233>
 ECHR 'O'               \                SSFUL, [179] W<220>L <247> WELL <242>W
 ECHR 'F'               \                <238>D<252>[212]{24}"
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'E'
ELIF _6502SP_VERSION
 ECHR 'A'               \ Encoded as:   "{25}{9}{30}{23}{14}{2}  <245>T<246>
 ETWO 'V', 'E'          \                <251><223>[213]. {19}WE HA<250> NE[196]
 ECHR ' '               \                OF [179]R <218>RVIC<237> AGA<240>[204]
 ECHR 'N'               \                IF [179] W<217>LD <247> <235> GOOD AS
 ECHR 'E'               \                [201]GO[201]{19}<233><244><241> [179] W
 ETOK 196               \                <220>L <247> BRIEF<252>[204]IF SUC<233>
 ECHR 'O'               \                SSFUL, [179] W<220>L <247> WELL <242>W
 ECHR 'F'               \                <238>D<252>[212]{24}"
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'E'
ELIF _NES_VERSION
 ECHR 'A'               \                {cr}
 ETWO 'V', 'E'          \                {left align}{cr}
 ECHR ' '               \                {tab 6}{all caps}  MESSAGE
 ECHR 'N'               \                ENDS{wait for key press}"
 ECHR 'E'               \
 ETOK 196               \ Encoded as:   "{25}{9}{23}{14} {26}<245>T<246><251>
 ECHR 'O'               \                <223>[213]. {19}WE HA<250> NE[196]OF
 ECHR 'F'               \                 [179]R <218>RVI<233>S AGA<240>[204]
 ECHR ' '               \                 [179] W<217>LD <247> <235> GOOD AS
 ETOK 179               \                [201]GO TO{26}<233><244><241> [179] W
 ECHR 'R'               \                <220>L <247> BRIEF<252>[204]IF SUC<233>
 ECHR ' '               \                SSFUL, [179] W<220>L <247> WELL <242>W
 ETWO 'S', 'E'          \                <238>D<252>[212]{24}"
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'R'
 ECHR 'V'
 ECHR 'I'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'C'
 ETWO 'E', 'S'
ELIF _NES_VERSION
 ETWO 'C', 'E'
 ECHR 'S'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'A'
 ECHR 'G'
 ECHR 'A'
 ETWO 'I', 'N'
 ETOK 204
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR ' '
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ETOK 201
 ECHR 'G'
 ECHR 'O'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 201
 EJMP 19
ELIF _NES_VERSION
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'C', 'E'
 ETWO 'E', 'R'
 ETWO 'D', 'I'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'R'
 ECHR 'I'
 ECHR 'E'
 ECHR 'F'
 ETWO 'E', 'D'
 ETOK 204
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 ECHR ','
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'W'
 ETWO 'A', 'R'
 ECHR 'D'
 ETWO 'E', 'D'
 ETOK 212
 EJMP 24
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 11:     ""
                        \
                        \ Encoded as:   ""

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
 ECHR '('               \ Token 12:     "({single cap}C) ACORNSOFT 1984"
 EJMP 19                \
 ECHR 'C'               \ Encoded as:   "({19}C) AC<253>N<235>FT 1984"
ELIF _MASTER_VERSION
 ECHR '('               \ Token 12:     "({single cap}C) ACORNSOFT 1986"
 EJMP 19                \
 ECHR 'C'               \ Encoded as:   "({19}C) AC<253>N<235>FT 1986"
ELIF _C64_VERSION OR _APPLE_VERSION
 ECHR '('               \ Token 12:     "({single cap}C) {single cap}D.{single
 EJMP 19                \                cap}BRABEN & {single cap}I.{single cap}
 ECHR 'C'               \                BELL 1985"
 ECHR ')'               \
 ETOK 197               \ Encoded as:   "({19}C) [191] 1985"
 ECHR ' '
 ECHR '1'
 ECHR '9'
 ECHR '8'
 ECHR '5'
ELIF _NES_VERSION
 ECHR '('               \ Token 12:     "({single cap}C) {single cap}D.{single
 EJMP 19                \                cap}BRABEN & {single cap}I.{single cap}
 ECHR 'C'               \                BELL 1991"
 ECHR ')'               \
 ETOK 197               \ Encoded as:   "({19}C) [191] 1991"
 ECHR ' '
 ECHR '1'
 ECHR '9'
 ECHR '9'
 ECHR '1'
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Master: Text token 12 in the Master version has a copyright notice of "(C) Acornsoft 1986", rather than the "1984" of the other versions
 ECHR ')'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'O', 'R'
 ECHR 'N'
 ETWO 'S', 'O'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR '1'
 ECHR '9'
 ECHR '8'
 ECHR '4'
ELIF _MASTER_VERSION
 ECHR ')'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'O', 'R'
 ECHR 'N'
 ETWO 'S', 'O'
 ECHR 'F'
 ECHR 'T'
 ECHR ' '
 ECHR '1'
 ECHR '9'
 ECHR '8'
 ECHR '6'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 12:     ""
                        \
                        \ Encoded as:   ""

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Platform

 ECHR 'B'               \ Token 13:     "BY D.BRABEN & I.BELL"
 ECHR 'Y'               \
 ECHR ' '               \ Encoded as:   "BY D.B<248><247>N & I.<247>LL"
 ECHR 'D'
 ECHR '.'
 ECHR 'B'
 ETWO 'R', 'A'
 ETWO 'B', 'E'
 ECHR 'N'
 ECHR ' '
 ECHR '&'
 ECHR ' '
 ECHR 'I'
 ECHR '.'
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 ECHR 'B'               \ Token 13:     "BY D.BRABEN & I.BELL"
 ECHR 'Y'               \
 ETOK 197               \ Encoded as:   "BY[197]]"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'B'               \ Token 13:     "BY  {single cap}D.{single cap}BRABEN &
 ECHR 'Y'               \                {single cap}I.{single cap}BELL"
 ETOK 197               \
 EQUB VE                \ Encoded as:   "BY[197]]"

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 13:     ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION)

 EJMP 21                \ Token 14:     "{clear bottom of screen}
 ETOK 145               \                PLANET NAME?
 ETOK 200               \                {fetch line input from keyboard}"
 EJMP 26                \
 EQUB VE                \ Encoded as:   "{21}[145][200]{26}"

ELIF _NES_VERSION

 EJMP 21                \ Token 14:     "{clear bottom of screen}
 ETOK 145               \                PLANET {single cap}NAME? "
 ETOK 200               \
 EQUB VE                \ Encoded as:   "{21}[145][200]"

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EJMP 25                \ Token 15:     "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 23                \                {move to row 10, white, lower case}
 EJMP 14                \                {justify}
 EJMP 2                 \                {sentence case}
 ECHR ' '               \                  CONGRATULATIONS {single cap}
 ECHR ' '               \                COMMANDER!{cr}
 ECHR 'C'               \                {cr}
 ETWO 'O', 'N'          \                THERE{lower case} WILL ALWAYS BE A
 ECHR 'G'               \                PLACE FOR YOU IN{sentence case} HER
 ETWO 'R', 'A'          \                MAJESTY'S SPACE NAVY{lower case}.{cr}
 ECHR 'T'               \                 {single cap}AND MAYBE SOONER THAN YOU
 ECHR 'U'               \                THINK...{cr}
 ETWO 'L', 'A'          \                {left align}{tab 6}{all caps}  MESSAGE
 ETWO 'T', 'I'          \                ENDS{wait for key press}"
 ETWO 'O', 'N'          \
ELIF _NES_VERSION
 EJMP 23                \                {move to row 9, lower case}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}  {single cap}
 ECHR ' '               \                CONGRATULATIONS {single cap}
 EJMP 26                \                COMMANDER!{cr}
 ECHR 'C'               \                {cr}
 ETWO 'O', 'N'          \                {single cap}THERE WILL ALWAYS BE A
 ECHR 'G'               \                PLACE FOR YOU IN{sentence case} HER
 ECHR 'R'               \                MAJESTY'S SPACE NAVY{lower case}.{cr}
 ETWO 'A', 'T'          \                {cr}
 ECHR 'U'               \                 {single cap}AND MAYBE SOONER THAN YOU
 ECHR 'L'               \                THINK...{cr}
 ETWO 'A', 'T'          \                {left align}{tab 6}{cr}
 ECHR 'I'               \                {all caps}  MESSAGE
 ETWO 'O', 'N'          \                ENDS{wait for key press}"
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
 ECHR 'S'               \ Encoded as:   "{25}{9}{23}{14}{2}  C<223>G<248>TU
 ECHR ' '               \                <249><251><223>S [154]!{12}{12}<226>
 ETOK 154               \                <244>E{13} W<220>L <228>WAYS <247>[208]
 ECHR '!'               \                P<249><233> F<253> [179] <240>[211]
 EJMP 12                \                [204]<255>D <239>Y<247> <235><223><244>
 EJMP 12                \                 <226><255> [179] <226><240>K..[212]
ELIF _6502SP_VERSION
 ECHR 'S'               \ Encoded as:   "{25}{9}{30}{23}{14}{2}  C<223>G<248>TU
 ECHR ' '               \                <249><251><223>S [154]!{12}{12}<226>
 ETOK 154               \                <244>E{13} W<220>L <228>WAYS <247>[208]
 ECHR '!'               \                P<249><233> F<253> [179] <240>[211]
 EJMP 12                \                [204]<255>D <239>Y<247> <235><223><244>
 EJMP 12                \                 <226><255> [179] <226><240>K..[212]
ELIF _NES_VERSION
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "{25}{9}{23}{14}{13} {26}C<223>GR<245>UL
 ETOK 154               \                <245>I<223>S [154]!{12}{12}{19}<226>
 ECHR '!'               \                <244>E W<220>L <228>WAYS <247>[208]P
 EJMP 12                \                <249><233> F<253> [179] <240>[211][204]
 EJMP 12                \                <255>D <239>Y<247> <235><223><244>
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETWO 'T', 'H'          \                {24}"
 ETWO 'E', 'R'
 ECHR 'E'
 EJMP 13
ELIF _NES_VERSION
 EJMP 19                \                 <226><255> [179] <226><240>K..[212]
 ETWO 'T', 'H'          \                {24}"
 ECHR 'E'
 ETWO 'R', 'E'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'A', 'L'
 ECHR 'W'
 ECHR 'A'
 ECHR 'Y'
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ETOK 208
 ECHR 'P'
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'I', 'N'
 ETOK 211
 ETOK 204
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'Y'
 ETWO 'B', 'E'
 ECHR ' '
 ETWO 'S', 'O'
 ETWO 'O', 'N'
 ETWO 'E', 'R'
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'A', 'N'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ETWO 'T', 'H'
 ETWO 'I', 'N'
 ECHR 'K'
 ECHR '.'
 ECHR '.'
 ETOK 212
 EJMP 24
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 15:     ""
                        \
                        \ Encoded as:   ""

ENDIF

 ECHR 'F'               \ Token 16:     "FABLED"
 ETWO 'A', 'B'          \
 ETWO 'L', 'E'          \ Encoded as:   "F<216><229>D"
 ECHR 'D'
 EQUB VE

 ETWO 'N', 'O'          \ Token 17:     "NOTABLE"
 ECHR 'T'               \
 ETWO 'A', 'B'          \ Encoded as:   "<227>T<216><229>"
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'W'               \ Token 18:     "WELL KNOWN"
 ECHR 'E'               \
 ECHR 'L'               \ Encoded as:   "WELL K<227>WN"
 ECHR 'L'
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'F'               \ Token 19:     "FAMOUS"
 ECHR 'A'               \
 ECHR 'M'               \ Encoded as:   "FAMO<236>"
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'F'               \ Token 19:     "FAMOUS"
 ECHR 'A'               \
 ECHR 'M'               \ Encoded as:   "FAM<217>S"
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

ENDIF

 ETWO 'N', 'O'          \ Token 20:     "NOTED"
 ECHR 'T'               \
 ETWO 'E', 'D'          \ Encoded as:   "<227>T<252>"
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'V', 'E'          \ Token 21:     "VERY"
 ECHR 'R'               \
 ECHR 'Y'               \ Encoded as:   "<250>RY"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'V'               \ Token 21:     "VERY"
 ETWO 'E', 'R'          \
 ECHR 'Y'               \ Encoded as:   "V<244>Y"
 EQUB VE

ENDIF

 ECHR 'M'               \ Token 22:     "MILDLY"
 ETWO 'I', 'L'          \
 ECHR 'D'               \ Encoded as:   "M<220>DLY"
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'M'               \ Token 23:     "MOST"
 ECHR 'O'               \
 ETWO 'S', 'T'          \ Encoded as:   "MO<222>"
 EQUB VE

 ETWO 'R', 'E'          \ Token 24:     "REASONABLY"
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "<242>AS<223><216>LY"
 ETWO 'O', 'N'
 ETWO 'A', 'B'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 EQUB VE                \ Token 25:     ""
                        \
                        \ Encoded as:   ""

 ETOK 165               \ Token 26:     "ANCIENT"
 EQUB VE                \
                        \ Encoded as:   "[165]"

 ERND 23                \ Token 27:     "[130-134]"
 EQUB VE                \
                        \ Encoded as:   "[23?]"

 ECHR 'G'               \ Token 28:     "GREAT"
 ETWO 'R', 'E'          \
 ETWO 'A', 'T'          \ Encoded as:   "G<242><245>"
 EQUB VE

 ECHR 'V'               \ Token 29:     "VAST"
 ECHR 'A'               \
 ETWO 'S', 'T'          \ Encoded as:   "VA<222>"
 EQUB VE

 ECHR 'P'               \ Token 30:     "PINK"
 ETWO 'I', 'N'          \
 ECHR 'K'               \ Encoded as:   "P<240>K"
 EQUB VE

IF NOT(_NES_VERSION)

 EJMP 2                 \ Token 31:     "{sentence case}[190-194] [185-189]
 ERND 28                \                {lower case} PLANTATIONS"
 ECHR ' '               \
 ERND 27                \ Encoded as:   "{2}[28?] [27?]{13} [185]A<251><223>S"
 EJMP 13
 ECHR ' '
 ETOK 185
 ECHR 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 EJMP 2                 \ Token 31:     "{sentence case}[190-194] [185-189]
 ERND 28                \                {lower case} PLANTATIONS"
 ECHR ' '               \
 ERND 27                \ Encoded as:   "{2}[28?] [27?]{13} [185]<245>I<223>S"
 EJMP 13
 ECHR ' '
 ETOK 185
 ETWO 'A', 'T'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

ENDIF

 ETOK 156               \ Token 32:     "MOUNTAINS"
 ECHR 'S'               \
 EQUB VE                \ Encoded as:   "[156]S"

 ERND 26                \ Token 33:     "[180-184]"
 EQUB VE                \
                        \ Encoded as:   "[26?]"

IF NOT(_NES_VERSION)

 ERND 37                \ Token 34:     "[125-129] FORESTS"
 ECHR ' '               \
 ECHR 'F'               \ Encoded as:   "[37?] F<253><237>TS"
 ETWO 'O', 'R'
 ETWO 'E', 'S'
 ECHR 'T'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 ERND 37                \ Token 34:     "[125-129] FORESTS"
 ECHR ' '               \
 ECHR 'F'               \ Encoded as:   "[37?] FO<242><222>S"
 ECHR 'O'
 ETWO 'R', 'E'
 ETWO 'S', 'T'
 ECHR 'S'
 EQUB VE

ENDIF

 ECHR 'O'               \ Token 35:     "OCEANS"
 ETWO 'C', 'E'          \
 ETWO 'A', 'N'          \ Encoded as:   "O<233><255>S"
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 36:     "SHYNESS"
 ECHR 'H'               \
 ECHR 'Y'               \ Encoded as:   "SHYN<237>S"
 ECHR 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 37:     "SILLINESS"
 ETWO 'I', 'L'          \
 ECHR 'L'               \ Encoded as:   "S<220>L<240><237>S"
 ETWO 'I', 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'M', 'A'          \ Token 38:     "MATING TRADITIONS"
 ECHR 'T'               \
 ETOK 195               \ Encoded as:   "<239>T[195]T<248><241><251><223>S"
 ECHR 'T'
 ETWO 'R', 'A'
 ETWO 'D', 'I'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'T'               \ Token 38:     "TEA CEREMONIES"
 ECHR 'E'               \
 ECHR 'A'               \ Encoded as:   "TEA <233><242>M<223>I<237>"
 ECHR ' '
 ETWO 'C', 'E'
 ETWO 'R', 'E'
 ECHR 'M'
 ETWO 'O', 'N'
 ECHR 'I'
 ETWO 'E', 'S'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)

 ETWO 'L', 'O'          \ Token 39:     "LOATHING OF [41-45]"
 ETWO 'A', 'T'          \
 ECHR 'H'               \ Encoded as:   "<224><245>H[195]OF [9?]"
 ETOK 195
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ERND 9
 EQUB VE

ELIF _NES_VERSION

 ETWO 'L', 'O'          \ Token 39:     "LOATHING OF [41-45]"
 ECHR 'A'               \
 ETWO 'T', 'H'          \ Encoded as:   "<224>A<226>[195]OF [9?]"
 ETOK 195
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ERND 9
 EQUB VE

ENDIF

 ETWO 'L', 'O'          \ Token 40:     "LOVE FOR [41-45]"
 ETWO 'V', 'E'          \
 ECHR ' '               \ Encoded as:   "<224><250> F<253> [9?]"
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 9
 EQUB VE

 ECHR 'F'               \ Token 41:     "FOOD BLENDERS"
 ECHR 'O'               \
 ECHR 'O'               \ Encoded as:   "FOOD B<229>ND<244>S"
 ECHR 'D'
 ECHR ' '
 ECHR 'B'
 ETWO 'L', 'E'
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'T'               \ Token 42:     "TOURISTS"
 ETWO 'O', 'U'          \
 ECHR 'R'               \ Encoded as:   "T<217>RI<222>S"
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR 'S'
 EQUB VE

 ECHR 'P'               \ Token 43:     "POETRY"
 ECHR 'O'               \
 ETWO 'E', 'T'          \ Encoded as:   "PO<221>RY"
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ETWO 'D', 'I'          \ Token 44:     "DISCOS"
 ECHR 'S'               \
 ECHR 'C'               \ Encoded as:   "<241>SCOS"
 ECHR 'O'
 ECHR 'S'
 EQUB VE

 ERND 17                \ Token 45:     "[81-85]"
 EQUB VE                \
                        \ Encoded as:   "[17?]"

 ECHR 'W'               \ Token 46:     "WALKING TREE"
 ETWO 'A', 'L'          \
 ECHR 'K'               \ Encoded as:   "W<228>K[195][158]"
 ETOK 195
 ETOK 158
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'C'               \ Token 47:     "CRAB"
 ETWO 'R', 'A'          \
 ECHR 'B'               \ Encoded as:   "C<248>B"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'C'               \ Token 47:     "CRAB"
 ECHR 'R'               \
 ETWO 'A', 'B'          \ Encoded as:   "CR<216>"
 EQUB VE

ENDIF

 ECHR 'B'               \ Token 48:     "BAT"
 ETWO 'A', 'T'          \
 EQUB VE                \ Encoded as:   "B<245>"

 ETWO 'L', 'O'          \ Token 49:     "LOBST"
 ECHR 'B'               \
 ETWO 'S', 'T'          \ Encoded as:   "<224>B<222>"
 EQUB VE

 EJMP 18                \ Token 50:     "{random 1-8 letter word}"
 EQUB VE                \
                        \ Encoded as:   "{18}"

IF NOT(_NES_VERSION)

 ETWO 'B', 'E'          \ Token 51:     "BESET"
 ECHR 'S'               \
 ETWO 'E', 'T'          \ Encoded as:   "<247>S<221>"
 EQUB VE

ELIF _NES_VERSION

 ETWO 'B', 'E'          \ Token 51:     "BESET"
 ETWO 'S', 'E'          \
 ECHR 'T'               \ Encoded as:   "<247><218>T"
 EQUB VE

ENDIF

 ECHR 'P'               \ Token 52:     "PLAGUED"
 ETWO 'L', 'A'          \
 ECHR 'G'               \ Encoded as:   "P<249>GU<252>"
 ECHR 'U'
 ETWO 'E', 'D'
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'R', 'A'          \ Token 53:     "RAVAGED"
 ECHR 'V'               \
 ECHR 'A'               \ Encoded as:   "<248>VAG<252>"
 ECHR 'G'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'C'               \ Token 54:     "CURSED"
 ECHR 'U'               \
 ECHR 'R'               \ Encoded as:   "CURS<252>"
 ECHR 'S'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'S'               \ Token 55:     "SCOURGED"
 ECHR 'C'               \
 ETWO 'O', 'U'          \ Encoded as:   "SC<217>RG<252>"
 ECHR 'R'
 ECHR 'G'
 ETWO 'E', 'D'
 EQUB VE

ELIF _NES_VERSION

 ETWO 'R', 'A'          \ Token 53:     "RAVAGED"
 ECHR 'V'               \
 ECHR 'A'               \ Encoded as:   "<248>VA<231>D"
 ETWO 'G', 'E'
 ECHR 'D'
 EQUB VE

 ECHR 'C'               \ Token 54:     "CURSED"
 ECHR 'U'               \
 ECHR 'R'               \ Encoded as:   "CUR<218>D"
 ETWO 'S', 'E'
 ECHR 'D'
 EQUB VE

 ECHR 'S'               \ Token 55:     "SCOURGED"
 ECHR 'C'               \
 ETWO 'O', 'U'          \ Encoded as:   "SC<217>R<231>D"
 ECHR 'R'
 ETWO 'G', 'E'
 ECHR 'D'
 EQUB VE

ENDIF

 ERND 22                \ Token 56:     "[135-139] CIVIL WAR"
 ECHR ' '               \
 ECHR 'C'               \ Encoded as:   "[22?] CIV<220> W<238>"
 ECHR 'I'
 ECHR 'V'
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'W'
 ETWO 'A', 'R'
 EQUB VE

 ERND 13                \ Token 57:     "[170-174] [155-159] [160-164]S"
 ECHR ' '               \
 ERND 4                 \ Encoded as:   "[13?] [4?] [5?]S"
 ECHR ' '
 ERND 5
 ECHR 'S'
 EQUB VE

 ECHR 'A'               \ Token 58:     "A [170-174] DISEASE"
 ECHR ' '               \
 ERND 13                \ Encoded as:   "A [13?] <241><218>A<218>"
 ECHR ' '
 ETWO 'D', 'I'
 ETWO 'S', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 EQUB VE

 ERND 22                \ Token 59:     "[135-139] EARTHQUAKES"
 ECHR ' '               \
 ECHR 'E'               \ Encoded as:   "[22?] E<238><226><254>AK<237>"
 ETWO 'A', 'R'
 ETWO 'T', 'H'
 ETWO 'Q', 'U'
 ECHR 'A'
 ECHR 'K'
 ETWO 'E', 'S'
 EQUB VE

 ERND 22                \ Token 60:     "[135-139] SOLAR ACTIVITY"
 ECHR ' '               \
IF NOT(_NES_VERSION)
 ETWO 'S', 'O'          \ Encoded as:   "[22?] <235><249>R AC<251>V<219>Y"
 ETWO 'L', 'A'
 ECHR 'R'
ELIF _NES_VERSION
 ETWO 'S', 'O'          \ Encoded as:   "[22?] <235>L<238> AC<251>V<219>Y"
 ECHR 'L'
 ETWO 'A', 'R'
ENDIF
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'V'
 ETWO 'I', 'T'
 ECHR 'Y'
 EQUB VE

 ETOK 175               \ Token 61:     "ITS [26-30] [31-35]"
 ERND 2                 \
 ECHR ' '               \ Encoded as:   "[175][2?] [3?]"
 ERND 3
 EQUB VE

 ETOK 147               \ Token 62:     "THE {system name adjective} [155-159]
 EJMP 17                \                 [160-164]"
 ECHR ' '               \
 ERND 4                 \ Encoded as:   "[147]{17} [4?] [5?]"
 ECHR ' '
 ERND 5
 EQUB VE

IF NOT(_NES_VERSION)
 ETOK 175               \ Token 63:     "ITS INHABITANTS' [165-169] [36-40]"
 ETOK 193               \
 ECHR 'S'               \ Encoded as:   "[175][193]S' [7?] [8?]"
 ECHR '`'
ELIF _NES_VERSION
 ETOK 175               \ Token 63:     "ITS INHABITANTS [165-169] [36-40]"
 ETOK 193               \
 ECHR 'S'               \ Encoded as:   "[175][193]S [7?] [8?]"
ENDIF
 ECHR ' '
 ERND 7
 ECHR ' '
 ERND 8
 EQUB VE

 EJMP 2                 \ Token 64:     "{sentence case}[235-239]{lower case}"
 ERND 31                \
 EJMP 13                \ Encoded as:   "{2}[31?]{13}"
 EQUB VE

 ETOK 175               \ Token 65:     "ITS [76-80] [81-85]"
 ERND 16                \
 ECHR ' '               \ Encoded as:   "[175][16?] [17?]"
 ERND 17
 EQUB VE

 ECHR 'J'               \ Token 66:     "JUICE"
 ECHR 'U'               \
 ECHR 'I'               \ Encoded as:   "JUI<233>"
 ETWO 'C', 'E'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'B'               \ Token 67:     "BRANDY"
 ETWO 'R', 'A'          \
 ECHR 'N'               \ Encoded as:   "B<248>NDY"
 ECHR 'D'
 ECHR 'Y'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'D'               \ Token 67:     "DRINK"
 ECHR 'R'               \
 ETWO 'I', 'N'          \ Encoded as:   "DR<240>K"
 ECHR 'K'
 EQUB VE

ENDIF

 ECHR 'W'               \ Token 68:     "WATER"
 ETWO 'A', 'T'          \
 ETWO 'E', 'R'          \ Encoded as:   "W<245><244>"
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'B'               \ Token 69:     "BREW"
 ETWO 'R', 'E'          \
 ECHR 'W'               \ Encoded as:   "B<242>W"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'T'               \ Token 69:     "TEA"
 ECHR 'E'               \
 ECHR 'A'               \ Encoded as:   "TEA"
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)
 ECHR 'G'               \ Token 70:     "GARGLE BLASTERS"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "G<238>G<229> B<249><222><244>S"
 ETWO 'L', 'E'
 ECHR ' '
ELIF _NES_VERSION
 EJMP 19                \ Token 70:     "{single cap}GARGLE {single cap}
 ECHR 'G'               \                BLASTERS"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "{19}G<238>G<229>{26}B<249><222><244>S"
 ETWO 'L', 'E'
 EJMP 26
ENDIF
 ECHR 'B'
 ETWO 'L', 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 EJMP 18                \ Token 71:     "{random 1-8 letter word}"
 EQUB VE                \
                        \ Encoded as:   "{18}"

 EJMP 17                \ Token 72:     "{system name adjective} [160-164]"
 ECHR ' '               \
 ERND 5                 \ Encoded as:   "{17} [5?]"
 EQUB VE

IF NOT(_NES_VERSION)

 EJMP 17                \ Token 73:     "{system name adjective} {random 1-8
 ECHR ' '               \                letter word}"
 EJMP 18                \
 EQUB VE                \ Encoded as:   "{17} {18}"

 EJMP 17                \ Token 74:     "{system name adjective} [170-174]"
 ECHR ' '               \
 ERND 13                \ Encoded as:   "{17} [13?]"
 EQUB VE

ELIF _NES_VERSION

 ETOK 191               \ Token 73:     "{system name adjective} {random 1-8
 EQUB VE                \                letter word}"
                        \
                        \ Encoded as:   "[191]"

 ETOK 192               \ Token 74:     ""{system name adjective} [170-174]"
 EQUB VE                \
                        \ Encoded as:   "[192]"

ENDIF

 ERND 13                \ Token 75:     "[170-174] {random 1-8 letter word}"
 ECHR ' '               \
 EJMP 18                \ Encoded as:   "[13?] {18}"
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'F'               \ Token 76:     "FABULOUS"
 ETWO 'A', 'B'          \
 ECHR 'U'               \ Encoded as:   "F<216>U<224><236>"
 ETWO 'L', 'O'
 ETWO 'U', 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'F'               \ Token 76:     "FABULOUS"
 ETWO 'A', 'B'          \
 ECHR 'U'               \ Encoded as:   "F<216>UL<217>S"
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

ENDIF

 ECHR 'E'               \ Token 77:     "EXOTIC"
 ECHR 'X'               \
 ECHR 'O'               \ Encoded as:   "EXO<251>C"
 ETWO 'T', 'I'
 ECHR 'C'
 EQUB VE

 ECHR 'H'               \ Token 78:     "HOOPY"
 ECHR 'O'               \
 ECHR 'O'               \ Encoded as:   "HOOPY"
 ECHR 'P'
 ECHR 'Y'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'U'               \ Token 79:     "UNUSUAL"
 ETWO 'N', 'U'          \
 ECHR 'S'               \ Encoded as:   "U<225>SU<228>"
 ECHR 'U'
 ETWO 'A', 'L'
 EQUB VE

ELIF _NES_VERSION

 ETOK 132               \ Token 79:     "UNUSUAL"
 EQUB VE                \
                        \ Encoded as:   "[132]

ENDIF

 ECHR 'E'               \ Token 80:     "EXCITING"
 ECHR 'X'               \
 ECHR 'C'               \ Encoded as:   "EXC<219><240>G"
 ETWO 'I', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR 'C'               \ Token 81:     "CUISINE"
 ECHR 'U'               \
 ECHR 'I'               \ Encoded as:   "CUIS<240>E"
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'E'
 EQUB VE

 ECHR 'N'               \ Token 82:     "NIGHT LIFE"
 ECHR 'I'               \
 ECHR 'G'               \ Encoded as:   "NIGHT LIFE"
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'F'
 ECHR 'E'
 EQUB VE

 ECHR 'C'               \ Token 83:     "CASINOS"
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "CASI<227>S"
 ECHR 'I'
 ETWO 'N', 'O'
 ECHR 'S'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'S'               \ Token 84:     "SIT COMS"
 ETWO 'I', 'T'          \
 ECHR ' '               \ Encoded as:   "S<219> COMS"
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'C'               \ Token 84:     "CINEMAS"
 ETWO 'I', 'N'          \
 ECHR 'E'               \ Encoded as:   "C<240>E<239>S"
 ETWO 'M', 'A'
 ECHR 'S'
 EQUB VE

ENDIF

 EJMP 2                 \ Token 85:     "{sentence case}[235-239]{lower case}"
 ERND 31                \
 EJMP 13                \ Encoded as:   "{2}[31?]{13}"
 EQUB VE

 EJMP 3                 \ Token 86:     "{selected system name}"
 EQUB VE                \
                        \ Encoded as:   "{3}"

 ETOK 147               \ Token 87:     "THE PLANET {selected system name}"
 ETOK 145               \
 ECHR ' '               \ Encoded as:   "[147][145] {3}"
 EJMP 3
 EQUB VE

 ETOK 147               \ Token 88:     "THE WORLD {selected system name}"
 ETOK 146               \
 ECHR ' '               \ Encoded as:   "[147][146] {3}"
 EJMP 3
 EQUB VE

 ETOK 148               \ Token 89:     "THIS PLANET"
 ETOK 145               \
 EQUB VE                \ Encoded as:   "[148][145]"

 ETOK 148               \ Token 90:     "THIS WORLD"
 ETOK 146               \
 EQUB VE                \ Encoded as:   "[148][146]"

IF NOT(_NES_VERSION)

 ECHR 'S'               \ Token 91:     "SON OF A BITCH"
 ETWO 'O', 'N'          \
 ECHR ' '               \ Encoded as:   "S<223> OF[208]B<219>CH"
 ECHR 'O'
 ECHR 'F'
 ETOK 208
 ECHR 'B'
 ETWO 'I', 'T'
 ECHR 'C'
 ECHR 'H'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'S'               \ Token 91:     "SWINE"
 ECHR 'W'               \
 ETWO 'I', 'N'          \ Encoded as:   "SE<240>E"
 ECHR 'E'
 EQUB VE

ENDIF

 ECHR 'S'               \ Token 92:     "SCOUNDREL"
 ECHR 'C'               \
 ETWO 'O', 'U'          \ Encoded as:   "SC<217>ND<242>L"
 ECHR 'N'
 ECHR 'D'
 ETWO 'R', 'E'
 ECHR 'L'
 EQUB VE

 ECHR 'B'               \ Token 93:     "BLACKGUARD"
 ETWO 'L', 'A'          \
 ECHR 'C'               \ Encoded as:   "B<249>CKGU<238>D"
 ECHR 'K'
 ECHR 'G'
 ECHR 'U'
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'R'               \ Token 94:     "ROGUE"
 ECHR 'O'               \
 ECHR 'G'               \ Encoded as:   "ROGUE"
 ECHR 'U'
 ECHR 'E'
 EQUB VE

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
 ECHR 'W'               \ Token 95:     "WHORESON BEETLE HEADFLAP EAR'D
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
 ECHR 'W'               \ Token 95:     "WHORESON BEETLE HEADED FLAP EAR'D
ENDIF
IF NOT(_NES_VERSION)
 ECHR 'H'               \                KNAVE"
 ETWO 'O', 'R'          \
 ETWO 'E', 'S'          \ Encoded as:   "WH<253><237><223> <247><221><229> HEAD
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
 ETWO 'O', 'N'          \                [198]F<249>P E<238>'D KNA<250>"
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
 ETWO 'O', 'N'          \                [196]F<249>P E<238>'D KNA<250>"
ENDIF
IF NOT(_NES_VERSION)
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ECHR 'A'
 ECHR 'D'
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Advanced: In the disc version, the extended system description override that's shown at Usleri in galaxy 1 during mission 1 refers to the Constrictor pilot as a "WHORESON BEETLE HEADFLAP EAR'D KNAVE", which is a slightly incorrect quote from Shakespeare's The Taming of the Shrew. In the advanced versions, this has been corrected to the more accurate quote "WHORESON BEETLE HEADED FLAP EAR'D KNAVE"
 ETOK 198
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
 ETOK 196
ENDIF
IF NOT(_NES_VERSION)
 ECHR 'F'
 ETWO 'L', 'A'
 ECHR 'P'
 ECHR ' '
 ECHR 'E'
 ETWO 'A', 'R'
 ECHR '`'
 ECHR 'D'
 ECHR ' '
 ECHR 'K'
 ECHR 'N'
 ECHR 'A'
 ETWO 'V', 'E'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'W'               \ Token 95:     "WRETCH"
 ECHR 'R'               \
 ETWO 'E', 'T'          \ Encoded as:   "WR<221>CH"
 ECHR 'C'
 ECHR 'H'
 EQUB VE

ENDIF

 ECHR 'N'               \ Token 96:     "N UNREMARKABLE"
 ECHR ' '               \
IF NOT(_NES_VERSION)
 ECHR 'U'               \ Encoded as:   "N UN<242><239>RK<216><229>"
 ECHR 'N'
 ETWO 'R', 'E'
 ETWO 'M', 'A'
 ECHR 'R'
ELIF _NES_VERSION
 ECHR 'U'               \ Encoded as:   "N UN<242>M<238>RK<216><229>"
 ECHR 'N'
 ETWO 'R', 'E'
 ECHR 'M'
 ETWO 'A', 'R'
ENDIF
 ECHR 'K'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR ' '               \ Token 97:     " BORING"
 ECHR 'B'               \
 ETWO 'O', 'R'          \ Encoded as:   " B<253><240>G"
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 98:     " DULL"
 ECHR 'D'               \
 ECHR 'U'               \ Encoded as:   " DULL"
 ECHR 'L'
 ECHR 'L'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR ' '               \ Token 99:     " TEDIOUS"
 ECHR 'T'               \
 ECHR 'E'               \ Encoded as:   " TE<241>O<236>"
 ETWO 'D', 'I'
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR ' '               \ Token 99:     " TEDIOUS"
 ECHR 'T'               \
 ECHR 'E'               \ Encoded as:   " TE<241><217>S"
 ETWO 'D', 'I'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

ENDIF

 ECHR ' '               \ Token 100:    " REVOLTING"
 ETWO 'R', 'E'          \
 ECHR 'V'               \ Encoded as:   " <242>VOLT<240>G"
 ECHR 'O'
 ECHR 'L'
 ECHR 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ETOK 145               \ Token 101:    "PLANET"
 EQUB VE                \
                        \ Encoded as:   "[145]"

 ETOK 146               \ Token 102:    "WORLD"
 EQUB VE                \
                        \ Encoded as:   "[146]"

 ECHR 'P'               \ Token 103:    "PLACE"
 ETWO 'L', 'A'          \
 ETWO 'C', 'E'          \ Encoded as:   "P<249><233>"
 EQUB VE

 ECHR 'L'               \ Token 104:    "LITTLE PLANET"
 ETWO 'I', 'T'          \
 ECHR 'T'               \ Encoded as:   "L<219>T<229> [145]"
 ETWO 'L', 'E'
 ECHR ' '
 ETOK 145
 EQUB VE

 ECHR 'D'               \ Token 105:    "DUMP"
 ECHR 'U'               \
 ECHR 'M'               \ Encoded as:   "DUMP"
 ECHR 'P'
 EQUB VE

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'               \ Token 106:    "I HEAR A [130-134] LOOKING SHIP
 ECHR ' '               \                APPEARED AT ERRIUS"
 ECHR 'H'               \
 ECHR 'E'               \ Encoded as:   "I HE<238>[208][23?] <224>OK[195][207]
 ETWO 'A', 'R'          \                 APPE<238>[196]<245>[209]"
ELIF _NES_VERSION
 EJMP 19                \ Token 106:    "{single cap}I HEAR A [130-134] LOOKING
 ECHR 'I'               \                SHIP APPEARED AT ERRIUS"
 ECHR ' '               \
 ECHR 'H'               \ Encoded as:   "{19}I HE<238>[208][23?] <224>OK[195]
 ECHR 'E'               \                [207] APPE<238>[196]<245>[209]"
 ETWO 'A', 'R'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 208
 ERND 23
 ECHR ' '
 ETWO 'L', 'O'
 ECHR 'O'
 ECHR 'K'
 ETOK 195
 ETOK 207
 ECHR ' '
 ECHR 'A'
 ECHR 'P'
 ECHR 'P'
 ECHR 'E'
 ETWO 'A', 'R'
 ETOK 196
 ETWO 'A', 'T'
 ETOK 209
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 106:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'Y'               \ Token 107:    "YEAH, I HEAR A [130-134] SHIP LEFT
 ECHR 'E'               \                ERRIUS A  WHILE BACK"
 ECHR 'A'               \
 ECHR 'H'               \ Encoded as:   "YEAH, I HE<238>[208][23?] [207]
 ECHR ','               \                 <229>FT[209][208] WHI<229> BACK"
 ECHR ' '
ELIF _NES_VERSION
 EJMP 19                \
 ECHR 'Y'               \ Token 107:    "{single cap}YEAH, I HEAR A [130-134]
 ECHR 'E'               \                SHIP LEFT ERRIUS A  WHILE BACK"
 ECHR 'A'               \
 ECHR 'H'               \ Encoded as:   "{19}YEAH, I HE<238>[208][23?] [207]
 ECHR ','               \                 <229>FT[209][208] WH<220>E BACK"
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'R'
 ETOK 208
 ERND 23
 ECHR ' '
 ETOK 207
 ECHR ' '
 ETWO 'L', 'E'
 ECHR 'F'
 ECHR 'T'
 ETOK 209
 ETOK 208
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ETWO 'L', 'E'
ELIF _NES_VERSION
 ETWO 'I', 'L'
 ECHR 'E'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 107:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'G'               \ Token 108:    "GET YOUR IRON ASS OVER TO ERRIUS"
 ETWO 'E', 'T'          \
 ECHR ' '               \ Encoded as:   "G<221> [179]R IR<223> ASS OV<244> TO
 ETOK 179               \                [209]"
ELIF _NES_VERSION
 EJMP 19                \ Token 108:    "{single cap}GET YOUR IRON HIDE OVER TO
 ECHR 'G'               \                ERRIUS"
 ETWO 'E', 'T'          \
 ECHR ' '               \ Encoded as:   "{19}G<221> [179]R IR<223> HIDE OV<244>
 ETOK 179               \                 TO[209]"
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'R'
 ECHR ' '
 ECHR 'I'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
ELIF _NES_VERSION
 ECHR 'H'
 ECHR 'I'
 ECHR 'D'
 ECHR 'E'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ETOK 209
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 108:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 ETWO 'S', 'O'          \ Token 109:    "SOME [91-95] NEW SHIP WAS SEEN AT
 ECHR 'M'               \                ERRIUS"
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "<235>ME [24?][210][207] WAS <218><246>
 ERND 24                \                 <245>[209]"
 ETOK 210
 ETOK 207
 ECHR ' '
 ECHR 'W'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'A', 'T'
 ETOK 209
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 109:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 ECHR 'T'               \ Token 110:    "TRY ERRIUS"
 ECHR 'R'               \
 ECHR 'Y'               \ Encoded as:   "TRY[209]"
 ETOK 209
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 110:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 EQUB VE                \ Token 111:    ""
                        \
                        \ Encoded as:   ""

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 EJMP 1                 \ Token 111:    "{all caps}SPECIAL CARGO"
 ECHR 'S'               \
 ECHR 'P'               \ Encoded as:   "{1}SPECI<228> C<238>GO"
 ECHR 'E'
 ECHR 'C'
 ECHR 'I'
 ETWO 'A', 'L'
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 EQUB VE

ELIF _NES_VERSION OR _C64_VERSION

 ECHR ' '               \ Token 111:    " CUDDLY"
 ECHR 'C'               \
 ECHR 'U'               \ Encoded as:   " CUDDLY"
 ECHR 'D'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION)

 EQUB VE                \ Token 112:    ""
                        \
                        \ Encoded as:   ""

ELIF _NES_VERSION OR _C64_VERSION

 ECHR ' '               \ Token 112:    " CUTE"
 ECHR 'C'               \
 ECHR 'U'               \ Encoded as:   " CUTE"
 ECHR 'T'
 ECHR 'E'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 EQUB VE                \ Token 113:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 114:    ""
                        \
                        \ Encoded as:   ""

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 ECHR 'C'               \ Token 113:    "CARGO VALUE:"
 ETWO 'A', 'R'          \
 ECHR 'G'               \ Encoded as:   "C<238>GO V<228>UE:"
 ECHR 'O'
 ECHR ' '
 ECHR 'V'
 ETWO 'A', 'L'
 ECHR 'U'
 ECHR 'E'
 ECHR ':'
 EQUB VE

 ECHR ' '               \ Token 114:    " MODIFIED BY A.J.C.DUGGAN"
 ECHR 'M'               \
 ECHR 'O'               \ Encoded as:   " MO<241>FI<252> BY A.J.C.DUGG<255>"
 ETWO 'D', 'I'
 ECHR 'F'
 ECHR 'I'
 ETWO 'E', 'D'
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 ECHR ' '
 ECHR 'A'
 ECHR '.'
 ECHR 'J'
 ECHR '.'
 ECHR 'C'
 ECHR '.'
 ECHR 'D'
 ECHR 'U'
 ECHR 'G'
 ECHR 'G'
 ETWO 'A', 'N'
 EQUB VE

ELIF _NES_VERSION OR _C64_VERSION

 ECHR ' '               \ Token 113:    " FURRY"
 ECHR 'F'               \
 ECHR 'U'               \ Encoded as:   " FURRY"
 ECHR 'R'
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ECHR ' '               \ Token 114:    " FRIENDLY"
 ECHR 'F'               \
 ECHR 'R'               \ Encoded as:   " FRI<246>DLY"
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

ENDIF

 ECHR 'W'               \ Token 115:    "WASP"
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "WASP"
 ECHR 'P'
 EQUB VE

 ECHR 'M'               \ Token 116:    "MOTH"
 ECHR 'O'               \
 ETWO 'T', 'H'          \ Encoded as:   "MO<226>"
 EQUB VE

 ECHR 'G'               \ Token 117:    "GRUB"
 ECHR 'R'               \
 ECHR 'U'               \ Encoded as:   "GRUB"
 ECHR 'B'
 EQUB VE

 ETWO 'A', 'N'          \ Token 118:    "ANT"
 ECHR 'T'               \
 EQUB VE                \ Encoded as:   "<255>T"

 EJMP 18                \ Token 119:    "{random 1-8 letter word}"
 EQUB VE                \
                        \ Encoded as:   "{18}"

 ECHR 'P'               \ Token 120:    "POET"
 ECHR 'O'               \
 ETWO 'E', 'T'          \ Encoded as:   "PO<221>"
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'A', 'R'          \ Token 121:    "ARTS GRADUATE"
 ECHR 'T'               \
 ECHR 'S'               \ Encoded as:   "<238>TS G<248>DU<245>E"
 ECHR ' '
 ECHR 'G'
 ETWO 'R', 'A'
 ECHR 'D'
 ECHR 'U'
 ETWO 'A', 'T'
 ECHR 'E'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'H'               \ Token 121:    "HOG"
 ECHR 'O'               \
 ECHR 'G'               \ Encoded as:   "HOG"
 EQUB VE

ENDIF

 ECHR 'Y'               \ Token 122:    "YAK"
 ECHR 'A'               \
 ECHR 'K'               \ Encoded as:   "YAK"
 EQUB VE

 ECHR 'S'               \ Token 123:    "SNAIL"
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   "SNA<220>"
 ETWO 'I', 'L'
 EQUB VE

 ECHR 'S'               \ Token 124:    "SLUG"
 ECHR 'L'               \
 ECHR 'U'               \ Encoded as:   "SLUG"
 ECHR 'G'
 EQUB VE

 ECHR 'T'               \ Token 125:    "TROPICAL"
 ECHR 'R'               \
 ECHR 'O'               \ Encoded as:   "TROPIC<228>"
 ECHR 'P'
 ECHR 'I'
 ECHR 'C'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'D'               \ Token 126:    "DENSE"
 ETWO 'E', 'N'          \
 ETWO 'S', 'E'          \ Encoded as:   "D<246><218>"
 EQUB VE

 ETWO 'R', 'A'          \ Token 127:    "RAIN"
 ETWO 'I', 'N'          \
 EQUB VE                \ Encoded as:   "<248><240>"

IF NOT(_NES_VERSION)

 ECHR 'I'               \ Token 128:    "IMPENETRABLE"
 ECHR 'M'               \
 ECHR 'P'               \ Encoded as:   "IMP<246><221><248>B<229>"
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ETWO 'R', 'A'
 ECHR 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'E'               \ Token 129:    "EXUBERANT"
 ECHR 'X'               \
 ECHR 'U'               \ Encoded as:   "EXU<247><248>NT"
 ETWO 'B', 'E'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'T'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'I'               \ Token 128:    "IMPENETRABLE"
 ECHR 'M'               \
 ECHR 'P'               \ Encoded as:   "IMP<246><221>R<216><229>"
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ECHR 'R'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'E'               \ Token 129:    "EXUBERANT"
 ECHR 'X'               \
 ECHR 'U'               \ Encoded as:   "EXUB<244><255>T"
 ECHR 'B'
 ETWO 'E', 'R'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

ENDIF

 ECHR 'F'               \ Token 130:    "FUNNY"
 ECHR 'U'               \
 ECHR 'N'               \ Encoded as:   "FUNNY"
 ECHR 'N'
 ECHR 'Y'
 EQUB VE

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Master: The disc and 6502SP versions contain a spelling mistake in the extended token system - they incorrectly spell weird as "wierd". The correct spelling is used in the Master version

 ECHR 'W'               \ Token 131:    "WIERD"
 ECHR 'I'               \
 ETWO 'E', 'R'          \ Encoded as:   "WI<244>D"
 ECHR 'D'
 EQUB VE

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 ECHR 'W'               \ Token 131:    "WEIRD"
 ECHR 'E'               \
 ECHR 'I'               \ Encoded as:   "WEIRD"
 ECHR 'R'               \
 ECHR 'D'
 EQUB VE

ENDIF

 ECHR 'U'               \ Token 132:    "UNUSUAL"
 ETWO 'N', 'U'          \
 ECHR 'S'               \ Encoded as:   "U<225>SU<228>"
 ECHR 'U'
 ETWO 'A', 'L'
 EQUB VE

 ETWO 'S', 'T'          \ Token 133:    "STRANGE"
 ETWO 'R', 'A'          \
 ECHR 'N'               \ Encoded as:   "<222><248>N<231>"
 ETWO 'G', 'E'
 EQUB VE

 ECHR 'P'               \ Token 134:    "PECULIAR"
 ECHR 'E'               \
 ECHR 'C'               \ Encoded as:   "PECULI<238>"
 ECHR 'U'
 ECHR 'L'
 ECHR 'I'
 ETWO 'A', 'R'
 EQUB VE

 ECHR 'F'               \ Token 135:    "FREQUENT"
 ETWO 'R', 'E'          \
 ETWO 'Q', 'U'          \ Encoded as:   "F<242><254><246>T"
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'O'               \ Token 136:    "OCCASIONAL"
 ECHR 'C'               \
 ECHR 'C'               \ Encoded as:   "OCCASI<223><228>"
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'U'               \ Token 137:    "UNPREDICTABLE"
 ECHR 'N'               \
 ECHR 'P'               \ Encoded as:   "UNP<242><241>CT<216><229>"
 ETWO 'R', 'E'
 ETWO 'D', 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'D'               \ Token 138:    "DREADFUL"
 ETWO 'R', 'E'          \
 ECHR 'A'               \ Encoded as:   "D<242>ADFUL"
 ECHR 'D'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 EQUB VE

 ETOK 171               \ Token 139:    "DEADLY"
 EQUB VE                \
                        \ Encoded as:   "[171]"

 ERND 1                 \ Token 140:    "[21-25] [16-20] FOR [61-65]"
 ECHR ' '               \
 ERND 0                 \ Encoded as:   "[1?] [0?] F<253> [10?]"
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 10
 EQUB VE

 ETOK 140               \ Token 141:    "[21-25] [16-20] FOR [61-65] AND
 ETOK 178               \                [61-65]"
 ERND 10                \
 EQUB VE                \ Encoded as:   "[140][178][10?]"

 ERND 11                \ Token 142:    "[51-55] BY [56-60]"
 ECHR ' '               \
 ECHR 'B'               \ Encoded as:   "[11?] BY [12?]"
 ECHR 'Y'
 ECHR ' '
 ERND 12
 EQUB VE

 ETOK 140               \ Token 143:    "[21-25] [16-20] FOR [61-65] BUT [51-55]
 ECHR ' '               \                BY [56-60]"
 ECHR 'B'               \
 ECHR 'U'               \ Encoded as:   "[140] BUT [142]"
 ECHR 'T'
 ECHR ' '
 ETOK 142
 EQUB VE

 ECHR ' '               \ Token 144:    " A[96-100] [101-105]"
 ECHR 'A'               \
 ERND 20                \ Encoded as:   " A[20?] [21?]"
 ECHR ' '
 ERND 21
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'P'               \ Token 145:    "PLANET"
 ECHR 'L'               \
 ETWO 'A', 'N'          \ Encoded as:   "PL<255><221>"
 ETWO 'E', 'T'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'P'               \ Token 145:    "PLANET"
 ETWO 'L', 'A'          \
 ECHR 'N'               \ Encoded as:   "P<249>N<221>"
 ETWO 'E', 'T'
 EQUB VE

ENDIF

 ECHR 'W'               \ Token 146:    "WORLD"
 ETWO 'O', 'R'          \
 ECHR 'L'               \ Encoded as:   "W<253>LD"
 ECHR 'D'
 EQUB VE

 ETWO 'T', 'H'          \ Token 147:    "THE "
 ECHR 'E'               \
 ECHR ' '               \ Encoded as:   "<226>E "
 EQUB VE

 ETWO 'T', 'H'          \ Token 148:    "THIS "
 ECHR 'I'               \
 ECHR 'S'               \ Encoded as:   "<226>IS "
 ECHR ' '
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'L', 'O'          \ Token 149:    "LOAD NEW {single cap}COMMANDER"
 ECHR 'A'               \
 ECHR 'D'               \ Encoded as:   "<224>AD[210][154]"
 ETOK 210
 ETOK 154
 EQUB VE

ELIF _NES_VERSION

 EQUB VE                \ Token 149:    ""
                        \
                        \ Encoded as:   ""

ENDIF

 EJMP 9                 \ Token 150:    "{clear screen}
 EJMP 11                \                {draw box around title}
 EJMP 1                 \                {all caps}
 EJMP 8                 \                {tab 6}"
 EQUB VE                \
                        \ Encoded as:   "{9}{11}{1}{8}"

IF _6502SP_VERSION OR _DISC_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _ELITE_A_VERSION \ Master: The Master Compact release replaces the "DRIVE" text tokwn with "DIRECTORY", as the Compact only has one disc drive

 ECHR 'D'               \ Token 151:    "DRIVE"
 ECHR 'R'               \
 ECHR 'I'               \ Encoded as:   "DRI<250>"
 ETWO 'V', 'E'
 EQUB VE

ELIF _MASTER_VERSION

IF _SNG47

 ECHR 'D'               \ Token 151:    "DRIVE"
 ECHR 'R'               \
 ECHR 'I'               \ Encoded as:   "DRI<250>"
 ETWO 'V', 'E'
 EQUB VE

ELIF _COMPACT

 ECHR 'D'               \ Token 151:    "DIRECTORY"
 ECHR 'I'               \
 ETWO 'R', 'E'          \ Encoded as:   "DI<242>CTORY"
 ECHR 'C'
 ECHR 'T'
 ECHR 'O'
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

ENDIF

ELIF _NES_VERSION

 EQUB VE                \ Token 151:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION)

 ECHR ' '               \ Token 152:    " CATALOGUE"
 ECHR 'C'               \
 ETWO 'A', 'T'          \ Encoded as:   " C<245>A<224>GUE"
 ECHR 'A'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 EQUB VE

ELIF _NES_VERSION

 EQUB VE                \ Token 152:    ""
                        \
                        \ Encoded as:   ""

ENDIF

 ECHR 'I'               \ Token 153:    "IAN"
 ETWO 'A', 'N'          \
 EQUB VE                \ Encoded as:   "I<255>"

IF NOT(_NES_VERSION)

 EJMP 19                \ Token 154:    "{single cap}COMMANDER"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{19}COMM<255>D<244>"
 ECHR 'M'
 ECHR 'M'
 ETWO 'A', 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 154:    "{single cap}COMMANDER"
 ECHR 'C'               \
 ECHR 'O'               \ Encoded as:   "{19}COM<239>ND<244>"
 ECHR 'M'
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

ENDIF

 ERND 13                \ Token 155:    "[170-174]"
 EQUB VE                \
                        \ Encoded as:   "[13?]"

 ECHR 'M'               \ Token 156:    "MOUNTAIN"
 ETWO 'O', 'U'          \
 ECHR 'N'               \ Encoded as:   "M<217>NTA<240>"
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'E', 'D'          \ Token 157:    "EDIBLE"
 ECHR 'I'               \
 ECHR 'B'               \ Encoded as:   "<252>IB<229>"
 ETWO 'L', 'E'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'E'               \ Token 157:    "EDIBLE"
 ETWO 'D', 'I'          \
 ECHR 'B'               \ Encoded as:   "E<241>B<229>"
 ETWO 'L', 'E'
 EQUB VE

ENDIF

 ECHR 'T'               \ Token 158:    "TREE"
 ETWO 'R', 'E'          \
 ECHR 'E'               \ Encoded as:   "T<242>E"
 EQUB VE

 ECHR 'S'               \ Token 159:    "SPOTTED"
 ECHR 'P'               \
 ECHR 'O'               \ Encoded as:   "SPOTT<252>"
 ECHR 'T'
 ECHR 'T'
 ETWO 'E', 'D'
 EQUB VE

 ERND 29                \ Token 160:    "[225-229]"
 EQUB VE                \
                        \ Encoded as:   "[29?]"

 ERND 30                \ Token 161:    "[230-234]"
 EQUB VE                \
                        \ Encoded as:   "[30?]"

 ERND 6                 \ Token 162:    "[46-50]OID"
 ECHR 'O'               \
 ECHR 'I'               \ Encoded as:   "[6?]OID"
 ECHR 'D'
 EQUB VE

 ERND 36                \ Token 163:    "[120-124]"
 EQUB VE                \
                        \ Encoded as:   "[36?]"

 ERND 35                \ Token 164:    "[115-119]"
 EQUB VE                \
                        \ Encoded as:   "[35?]"

 ETWO 'A', 'N'          \ Token 165:    "ANCIENT"
 ECHR 'C'               \
 ECHR 'I'               \ Encoded as:   "<255>CI<246>T"
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'E'               \ Token 166:    "EXCEPTIONAL"
 ECHR 'X'               \
 ETWO 'C', 'E'          \ Encoded as:   "EX<233>P<251><223><228>"
 ECHR 'P'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'E'               \ Token 167:    "ECCENTRIC"
 ECHR 'C'               \
 ETWO 'C', 'E'          \ Encoded as:   "EC<233>NTRIC"
 ECHR 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 EQUB VE

 ETWO 'I', 'N'          \ Token 168:    "INGRAINED"
 ECHR 'G'               \
 ETWO 'R', 'A'          \ Encoded as:   "<240>G<248><240><252>"
 ETWO 'I', 'N'
 ETWO 'E', 'D'
 EQUB VE

 ERND 23                \ Token 169:    "[130-134]"
 EQUB VE                \
                        \ Encoded as:   "[23?]"

IF NOT(_NES_VERSION)

 ECHR 'K'               \ Token 170:    "KILLER"
 ETWO 'I', 'L'          \
 ECHR 'L'               \ Encoded as:   "K<220>L<244>"
 ETWO 'E', 'R'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'K'               \ Token 170:    "KILLER"
 ETWO 'I', 'L'          \
 ETWO 'L', 'E'          \ Encoded as:   "K<220><229>R"
 ECHR 'R'
 EQUB VE

ENDIF

 ECHR 'D'               \ Token 171:    "DEADLY"
 ECHR 'E'               \
 ECHR 'A'               \ Encoded as:   "DEADLY"
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'E'               \ Token 172:    "EVIL"
 ECHR 'V'               \
 ETWO 'I', 'L'          \ Encoded as:   "EV<220>"
 EQUB VE

 ETWO 'L', 'E'          \ Token 173:    "LETHAL"
 ETWO 'T', 'H'          \
 ETWO 'A', 'L'          \ Encoded as:   "<229><226><228>"
 EQUB VE

 ECHR 'V'               \ Token 174:    "VICIOUS"
 ECHR 'I'               \
 ECHR 'C'               \ Encoded as:   "VICIO<236>"
 ECHR 'I'
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'W'               \ Token 172:    "WICKED"
 ECHR 'I'               \
 ECHR 'C'               \ Encoded as:   "WICK<252>"
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'L'               \ Token 173:    "LETHAL"
 ETWO 'E', 'T'          \
 ECHR 'H'               \ Encoded as:   "L<221>H<228>"
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'V'               \ Token 174:    "VICIOUS"
 ECHR 'I'               \
 ECHR 'C'               \ Encoded as:   "VICI<217>S"
 ECHR 'I'
 ETWO 'O', 'U'
 ECHR 'S'
 EQUB VE

ENDIF

 ETWO 'I', 'T'          \ Token 175:    "ITS "
 ECHR 'S'               \
 ECHR ' '               \ Encoded as:   "<219>S "
 EQUB VE

 EJMP 13                \ Token 176:    "{lower case}
 EJMP 14                \                {justify}
 EJMP 19                \                {single cap}"
 EQUB VE                \
                        \ Encoded as:   "{13}{14}{19}"

 ECHR '.'               \ Token 177:    ".{cr}
 EJMP 12                \                {left align}"
 EJMP 15                \
 EQUB VE                \ Encoded as:   ".{12}{15}"

 ECHR ' '               \ Token 178:    " AND "
 ETWO 'A', 'N'          \
 ECHR 'D'               \ Encoded as:   " <255>D "
 ECHR ' '
 EQUB VE

 ECHR 'Y'               \ Token 179:    "YOU"
 ETWO 'O', 'U'          \
 EQUB VE                \ Encoded as:   "Y<217>"

 ECHR 'P'               \ Token 180:    "PARKING METERS"
 ETWO 'A', 'R'          \
 ECHR 'K'               \ Encoded as:   "P<238>K[195]M<221><244>S"
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'D'               \ Token 181:    "DUST CLOUDS"
 ETWO 'U', 'S'          \
 ECHR 'T'               \ Encoded as:   "D<236>T C<224>UDS"
 ECHR ' '
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'U'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

 ECHR 'I'               \ Token 182:    "ICE BERGS"
 ETWO 'C', 'E'          \
 ECHR ' '               \ Encoded as:   "I<233> <247>RGS"
 ETWO 'B', 'E'
 ECHR 'R'
 ECHR 'G'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'D'               \ Token 181:    "DUST CLOUDS"
 ECHR 'U'               \
 ETWO 'S', 'T'          \ Encoded as:   "DU<222> CL<217>DS"
 ECHR ' '
 ECHR 'C'
 ECHR 'L'
 ETWO 'O', 'U'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

 ECHR 'I'               \ Token 182:    "ICE BERGS"
 ETWO 'C', 'E'          \
 ECHR ' '               \ Encoded as:   "I<233> B<244>GS"
 ECHR 'B'
 ETWO 'E', 'R'
 ECHR 'G'
 ECHR 'S'
 EQUB VE

ENDIF

 ECHR 'R'               \ Token 183:    "ROCK FORMATIONS"
 ECHR 'O'               \
 ECHR 'C'               \ Encoded as:   "ROCK F<253><239><251><223>S"
 ECHR 'K'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'M', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ECHR 'V'               \ Token 184:    "VOLCANOES"
 ECHR 'O'               \
 ECHR 'L'               \ Encoded as:   "VOLCA<227><237>"
 ECHR 'C'
 ECHR 'A'
 ETWO 'N', 'O'
 ETWO 'E', 'S'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'P'               \ Token 185:    "PLANT"
 ECHR 'L'               \
 ETWO 'A', 'N'          \ Encoded as:   "PL<255>T"
 ECHR 'T'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'P'               \ Token 185:    "PLANT"
 ETWO 'L', 'A'          \
 ECHR 'N'               \ Encoded as:   "P<249>NT"
 ECHR 'T'
 EQUB VE

ENDIF

 ECHR 'T'               \ Token 186:    "TULIP"
 ECHR 'U'               \
 ECHR 'L'               \ Encoded as:   "TULIP"
 ECHR 'I'
 ECHR 'P'
 EQUB VE

 ECHR 'B'               \ Token 187:    "BANANA"
 ETWO 'A', 'N'          \
 ETWO 'A', 'N'          \ Encoded as:   "B<255><255>A"
 ECHR 'A'
 EQUB VE

 ECHR 'C'               \ Token 188:    "CORN"
 ETWO 'O', 'R'          \
 ECHR 'N'               \ Encoded as:   "C<253>N"
 EQUB VE

 EJMP 18                \ Token 189:    "{random 1-8 letter word}WEED"
 ECHR 'W'               \
 ECHR 'E'               \ Encoded as:   "{18}WE<252>"
 ETWO 'E', 'D'
 EQUB VE

 EJMP 18                \ Token 190:    "{random 1-8 letter word}"
 EQUB VE                \
                        \ Encoded as:   "{18}"

 EJMP 17                \ Token 191:    "{system name adjective} {random 1-8
 ECHR ' '               \                letter word}"
 EJMP 18                \
 EQUB VE                \ Encoded as:   "{17} {18}"

 EJMP 17                \ Token 192:    "{system name adjective} [170-174]"
 ECHR ' '               \
 ERND 13                \ Encoded as:   "{17} [13?]"
 EQUB VE

IF NOT(_NES_VERSION)

 ETWO 'I', 'N'          \ Token 193:    "INHABITANT"
 ECHR 'H'               \
 ECHR 'A'               \ Encoded as:   "<240>HA<234>T<255>T"
 ETWO 'B', 'I'
 ECHR 'T'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

ELIF _NES_VERSION

 ETWO 'I', 'N'          \ Token 193:    "INHABITANT"
 ECHR 'H'               \
 ETWO 'A', 'B'          \ Encoded as:   "<240>H<216><219><255>T"
 ETWO 'I', 'T'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

ENDIF

 ETOK 191               \ Token 194:    "{system name adjective} {random 1-8
 EQUB VE                \                letter word}"
                        \
                        \ Encoded as:   "[191]"

 ETWO 'I', 'N'          \ Token 195:    "ING "
 ECHR 'G'               \
 ECHR ' '               \ Encoded as:   "<240>G "
 EQUB VE

 ETWO 'E', 'D'          \ Token 196:    "ED "
 ECHR ' '               \
 EQUB VE                \ Encoded as:   "<252> "

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Platform

 EQUB VE                \ Token 197:    ""
                        \
                        \ Encoded as:   ""

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 ECHR ' '               \ Token 197:    " D.BRABEN & I.BELL"
 ECHR 'D'
 ECHR '.'               \ Encoded as:   " D.B<248><247>N & I.<247>LL"
 ECHR 'B'
 ETWO 'R', 'A'
 ETWO 'B', 'E'
 ECHR 'N'
 ECHR ' '
 ECHR '&'
 ECHR ' '
 ECHR 'I'
 ECHR '.'
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

ELIF _NES_VERSION

 EJMP 26                \ Token 197:    " {single cap}D.{single cap}BRABEN &
 ECHR 'D'               \                {single cap}I.{single cap}BELL"
 ECHR '.'               \
 EJMP 19                \ Encoded as:   "{26}D.{19}BR<216><246> &{26}I.{19}<247>
 ECHR 'B'               \                LL"
 ECHR 'R'
 ETWO 'A', 'B'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR '&'
 EJMP 26
 ECHR 'I'
 ECHR '.'
 EJMP 19
 ETWO 'B', 'E'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

ENDIF

IF NOT(_C64_VERSION OR _NES_VERSION)

 EQUB VE                \ Token 198:    ""
                        \
                        \ Encoded as:   ""

ELIF _C64_VERSION

 ECHR ' '               \ Token 198:    " LITTLE TRUMBLE"
 ECHR 'L'               \
 ETWO 'I', 'T'          \ Encoded as:   " L<219>T<229> TRUMB"
 ECHR 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'T'
 ECHR 'R'
 ECHR 'U'
 ECHR 'M'
 ECHR 'B'
 ETWO 'L', 'E'
 EQUB VE

ELIF _NES_VERSION

 ECHR ' '               \ Token 198:    " LITTLE {single cap}SQUEAKY"
 ECHR 'L'               \
 ETWO 'I', 'T'          \ Encoded as:   " L<219>T<229>{26}S<254>EAKY"
 ECHR 'T'
 ETWO 'L', 'E'
 EJMP 26
 ECHR 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 ECHR 'Y'
 EQUB VE

ENDIF

IF NOT(_C64_VERSION OR _NES_VERSION)

 EQUB VE                \ Token 199:    ""
                        \
                        \ Encoded as:   ""

ELIF _C64_VERSION

 EJMP 25                \ Token 199:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {tab 6, lower case in words}
 EJMP 14                \                {justify}
 EJMP 19                \                {single cap}GOOD{lower case} DAY
 ECHR 'G'               \                {single cap}COMMANDER {commander
 ECHR 'O'               \                name}, ALLOW ME TO INTRODUCE MYSELF.
 ECHR 'O'               \                 {single cap}I AM {single cap}THE
 ECHR 'D'               \                {single cap}MERCHANT {single cap}
 EJMP 13                \                PRINCE OF THRUN{lower case} AND {single
 ECHR ' '               \                cap}I FIND MYSELF FORCED TO SELL MY
 ECHR 'D'               \                MOST TREASURED POSSESSION.{cr}
 ECHR 'A'               \                {cr}
 ECHR 'Y'               \                {single cap}I AM OFFERING
 ECHR ' '               \                YOU, FOR THE PALTRY SUM OF JUST 5000
 ETOK 154               \                {single cap}C{single cap}R THE RAREST
 ECHR ' '               \                THING IN THE {single cap}KNOWN {single
 EJMP 4                 \                cap}UNIVERSE.{cr}
 ECHR ','               \                {cr}
 ECHR ' '               \                {single cap}{lower case}WILL YOU TAKE
 ETWO 'A', 'L'          \                IT{all caps}(Y/N)?{cr}
 ETWO 'L', 'O'          \                {left align}{all caps}{tab 6}
 ECHR 'W'               \
 ECHR ' '               \ Encoded as:   "{25}{9}{29}{14}{19}GOOD{13} DAY [154]
 ECHR 'M'               \                 [4], <228><224>W ME[201]<240>TRODU
 ECHR 'E'               \                <233> MY<218>LF. {19}I AM{2} [147]M
 ETOK 201               \                <244>CH<255>T PR<240><233> OF
 ETWO 'I', 'N'          \                <226>RUN <255>D I F<240>D MY<218>
 ECHR 'T'               \                LF F<253><233>D[201]<218>LL MY MO<222>
 ECHR 'R'               \                 T<242>ASUR<252> POSS<237>SI<223>[204]
 ECHR 'O'               \                I AM OFF<244>[195]Y<217>, F<253>
 ECHR 'D'               \                 [147]PALTRY SUM OF JU<222> 4000{19}
 ECHR 'U'               \                C{19}R [147]<248><242><222> <226>[195]
 ETWO 'C', 'E'          \                 <240> [147]{2}K<227>WN UNI<250>R<218>
 ECHR ' '               \                [204]{13}W<220>L Y<217> TAKE <219>{1}
 ECHR 'M'               \                (Y/N)?{12}{15}{1}{8}"
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR '.'
 ECHR ' '
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 EJMP 2
 ECHR ' '
 ETOK 147
 ECHR 'M'
 ETWO 'E', 'R'
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'P'
 ECHR 'R'
 ETWO 'I', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 EJMP 13
 ETOK 178
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'C', 'E'
 ECHR 'D'
 ETOK 201
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'S'
 ECHR 'U'
 ECHR 'R'
 ETWO 'E', 'D'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'S'
 ECHR 'S'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 204
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ETWO 'E', 'R'
 ETOK 195
 ECHR 'Y'
 ETWO 'O', 'U'
 ECHR ','
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 147
 ECHR 'P'
 ECHR 'A'
 ECHR 'L'
 ECHR 'T'
 ECHR 'R'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR '5'
 ECHR '0'
 ECHR '0'
 ECHR '0'
 EJMP 19
 ECHR 'C'
 EJMP 19
 ECHR 'R'
 ECHR ' '
 ETOK 147
 ETWO 'R', 'A'
 ETWO 'R', 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ETOK 195
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 147
 EJMP 2
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR 'R'
 ETWO 'S', 'E'
 ETOK 204
 EJMP 13
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'Y'
 ETWO 'O', 'U'
 ECHR ' '
 ECHR 'T'
 ECHR 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETWO 'I', 'T'
 EJMP 1
 ECHR '('
 ECHR 'Y'
 ECHR '/'
 ECHR 'N'
 ECHR ')'
 ECHR '?'
 EJMP 12
 EJMP 15
 EJMP 1
 EJMP 8
 EQUB VE

ELIF _NES_VERSION

 EJMP 25                \ Token 199:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {tab 6, lower case in words}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}
 EJMP 19                \                {single cap}GOOD DAY {single cap}
 ECHR 'G'               \                COMMANDER {commander name}, ALLOW ME
 ECHR 'O'               \                TO INTRODUCE MYSELF. {single cap}I AM
 ECHR 'O'               \                {single cap}THE {single cap}MERCHANT
 ECHR 'D'               \                {single cap}PRINCE OF THRUN AND I
 ECHR ' '               \                {single cap}FIND MYSELF FORCED TO SELL
 ECHR 'D'               \                MY MOST TREASURED POSSESSION.{cr}
 ECHR 'A'               \                {cr}
 ECHR 'Y'               \                {single cap}{single cap}I AM OFFERING
 ECHR ' '               \                YOU, FOR THE PALTRY SUM OF JUST 5000
 ETOK 154               \                {single cap}C{single cap}R THE RAREST
 ECHR ' '               \                THING IN THE {single cap}KNOWN {single
 EJMP 4                 \                cap}UNIVERSE.{cr}
 ECHR ','               \                {cr}
 ECHR ' '               \                {single cap}{single cap}WILL YOU TAKE
 ETWO 'A', 'L'          \                IT?{cr}
 ETWO 'L', 'O'          \                {left align}{all caps}{tab 6}
 ECHR 'W'               \
 ECHR ' '               \ Encoded as:   "{25}{9}{29}{14}{13}{19}GOOD DAY [154]
 ECHR 'M'               \                 [4], <228><224>W ME[201]<240>TRODU
 ECHR 'E'               \                <233> MY<218>LF.{26}I AM{26}<226>E{26}M
 ETOK 201               \                <244>CH<255>T{26}PR<240><233> OF{26}
 ETWO 'I', 'N'          \                <226>RUN <255>D{26}I{26}F<240>D MY<218>
 ECHR 'T'               \                LF F<253><233>D[201]<218>LL MY MO<222>
 ECHR 'R'               \                 T<242>ASU<242>D POS<218>SSI<223>[204]
 ECHR 'O'               \                {19}I AM OFF<244>[195][179], F<253>
 ECHR 'D'               \                 [147]P<228>TRY SUM OF JU<222> 4000{19}
 ECHR 'U'               \                C{19}R [147]R<238>E<222> <226>[195]
 ETWO 'C', 'E'          \                 <240> <226>E{26}K<227>WN{26}UNIV<244>
 ECHR ' '               \                <218>[204]{19}W<220>L [179] TAKE <219>?
 ECHR 'M'               \                {12}{15}{1}{8}"
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR '.'
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'M'
 ETWO 'E', 'R'
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'T'
 EJMP 26
 ECHR 'P'
 ECHR 'R'
 ETWO 'I', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 EJMP 26
 ETWO 'T', 'H'
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR 'D'
 EJMP 26
 ECHR 'I'
 EJMP 26
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'F'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'C', 'E'
 ECHR 'D'
 ETOK 201
 ETWO 'S', 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'M'
 ECHR 'Y'
 ECHR ' '
 ECHR 'M'
 ECHR 'O'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR 'D'
 ECHR ' '
 ECHR 'P'
 ECHR 'O'
 ECHR 'S'
 ETWO 'S', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 204
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ETWO 'E', 'R'
 ETOK 195
 ETOK 179
 ECHR ','
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 147
 ECHR 'P'
 ETWO 'A', 'L'
 ECHR 'T'
 ECHR 'R'
 ECHR 'Y'
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ETWO 'S', 'T'
 ECHR ' '
 ECHR '5'
 ECHR '0'
 ECHR '0'
 ECHR '0'
 EJMP 19
 ECHR 'C'
 EJMP 19
 ECHR 'R'
 ECHR ' '
 ETOK 147
 ECHR 'R'
 ETWO 'A', 'R'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'T', 'H'
 ETOK 195
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 EJMP 26
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'V'
 ETWO 'E', 'R'
 ETWO 'S', 'E'
 ETOK 204
 EJMP 19
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'T'
 ECHR 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETWO 'I', 'T'
 ECHR '?'
 EJMP 12
 EJMP 15
 EJMP 1
 EJMP 8
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)

 ECHR ' '               \ Token 200:    " NAME? "
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   " NAME? "
 ECHR 'M'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

ELIF _NES_VERSION

 EJMP 26                \ Token 200:    " {single cap}NAME? "
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   "{26}NAME? "
 ECHR 'M'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

ENDIF

 ECHR ' '               \ Token 201:    " TO "
 ECHR 'T'               \
 ECHR 'O'               \ Encoded as:   " TO "
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 202:    " IS "
 ECHR 'I'               \
 ECHR 'S'               \ Encoded as:   " IS "
 ECHR ' '
 EQUB VE

 ECHR 'W'               \ Token 203:    "WAS LAST SEEN AT {single cap}"
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "WAS <249><222> <218><246> <245> {19}"
 ECHR ' '
 ETWO 'L', 'A'
 ETWO 'S', 'T'
 ECHR ' '
 ETWO 'S', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ETWO 'A', 'T'
 ECHR ' '
 EJMP 19
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR '.'               \ Token 204:    ".{cr}
 EJMP 12                \                 {single cap}"
 ECHR ' '               \
 EJMP 19                \ Encoded as:   ".{12} {19}"
 EQUB VE

ELIF _NES_VERSION

 ECHR '.'               \ Token 204:    ".{cr}
 EJMP 12                \                 {cr}
 EJMP 12                \                 {single cap}"
 ECHR ' '               \
 EJMP 19                \ Encoded as:   ".{12}{12} {19}"
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)

 ECHR 'D'               \ Token 205:    "DOCKED"
 ECHR 'O'               \
 ECHR 'C'               \ Encoded as:   "DOCK<252>"
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 205:    "{single cap}DOCKED"
 ECHR 'D'               \
 ECHR 'O'               \ Encoded as:   "{19}DOCK<252>"
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION)

 EJMP 1                 \ Token 206:    "{all caps}(Y/N)?"
 ECHR '('               \
 ECHR 'Y'               \ Encoded as:   "{1}(Y/N)?"
 ECHR '/'
 ECHR 'N'
 ECHR ')'
 ECHR '?'
 EQUB VE

ELIF _NES_VERSION

 EQUB VE                \ Token 206:    ""
                        \
                        \ Encoded as:   ""

ENDIF

 ECHR 'S'               \ Token 207:    "SHIP"
 ECHR 'H'               \
 ECHR 'I'               \ Encoded as:   "SHIP"
 ECHR 'P'
 EQUB VE

 ECHR ' '               \ Token 208:    " A "
 ECHR 'A'               \
 ECHR ' '               \ Encoded as:   " A "
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR ' '               \ Token 209:    " ERRIUS"
 ETWO 'E', 'R'          \
 ECHR 'R'               \ Encoded as:   " <244>RI<236>"
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

ELIF _NES_VERSION

 EJMP 26                \ Token 209:    " {single cap}ERRIUS"
 ETWO 'E', 'R'          \
 ECHR 'R'               \ Encoded as:   "{26}<244>RI<236>"
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

ENDIF

 ECHR ' '               \ Token 210:    " NEW "
 ECHR 'N'               \
 ECHR 'E'               \ Encoded as:   " NEW "
 ECHR 'W'
 ECHR ' '
 EQUB VE

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 EJMP 2                 \ Token 211:    "{sentence case} HER MAJESTY'S SPACE
 ECHR ' '               \                 NAVY{lower case}"
 ECHR 'H'               \
 ETWO 'E', 'R'          \ Encoded as:   "{2} H<244> <239>J<237>TY'S SPA<233> NAV
 ECHR ' '               \                Y{13}"
 ETWO 'M', 'A'
 ECHR 'J'
 ETWO 'E', 'S'
 ECHR 'T'
 ECHR 'Y'
 ECHR '`'
 ECHR 'S'
 ECHR ' '
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 EJMP 13
 EQUB VE

ELIF _NES_VERSION

 EJMP 26                \ Token 211:    " {single cap}HER {single cap}MAJESTY'S
 ECHR 'H'               \                  {single cap}SPACE {single cap}NAVY"
 ETWO 'E', 'R'          \
 EJMP 26                \ Encoded as:   "{26}H<244> <239>JE<222>Y'S{26}SPA<233>
 ETWO 'M', 'A'          \                {26}NAVY"
 ECHR 'J'
 ECHR 'E'
 ETWO 'S', 'T'
 ECHR 'Y'
 ECHR '`'
 ECHR 'S'
 EJMP 26
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 EJMP 26
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 211:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION)

 ETOK 177               \ Token 212:    ".{cr}
 EJMP 8                 \                {left align}
 EJMP 1                 \                {tab 6}{all caps}  MESSAGE ENDS"
 ECHR ' '               \
 ECHR ' '               \ Encoded as:   "[177]{8}{1}  M<237>SA<231> <246>DS"
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 ECHR ' '
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

ELIF _NES_VERSION

 ETOK 177               \ Token 212:    ".{cr}
 EJMP 12                \                {left align}{cr}
 EJMP 8                 \                {tab 6}{all caps} {single cap}MESSAGE
 EJMP 1                 \                {single cap}ENDS"
 ECHR ' '               \
 EJMP 26                \ Encoded as:   "[177]{12}{8}{1} {26}M<237>SA<231>[26}
 ECHR 'M'               \                <246>DS"
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EJMP 26
 ETWO 'E', 'N'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 ECHR ' '               \ Token 213:    " {single cap}COMMANDER {commander
 ETOK 154               \                name}, I {lower case}AM{sentence case}
 ECHR ' '               \                CAPTAIN {mission captain's name}
 EJMP 4                 \                {lower case}OF{sentence case} HER
 ECHR ','               \                MAJESTY'S SPACE NAVY{lower case}"
 ECHR ' '               \
 ECHR 'I'               \ Encoded as:   " [154] {4}, I {13}AM{2} CAPTA<240> {27}
 ECHR ' '               \                 {13}OF[211]"
 EJMP 13
 ECHR 'A'
 ECHR 'M'
 EJMP 2
 ECHR ' '
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ECHR ' '
 EJMP 27
 ECHR ' '
 EJMP 13
 ECHR 'O'
 ECHR 'F'
 ETOK 211
 EQUB VE

ELIF _NES_VERSION

 ECHR ' '               \ Token 213:    " {single cap}COMMANDER {commander
 ETOK 154               \                name}, {single cap}I {lower case}AM
 ECHR ' '               \                {sentence case}{single cap}CAPTAIN
 EJMP 4                 \                {mission captain's name} OF
 ECHR ','               \                {sentence case} HER MAJESTY'S SPACE
 EJMP 26                \                NAVY{lower case}"
 ECHR 'I'               \
 ECHR ' '               \ Encoded as:   " [154] {4},{26}I {13}AM{26}CAPTA<240>
 EJMP 13                \                  {27}OF[211]"
 ECHR 'A'
 ECHR 'M'
 EJMP 26
 ECHR 'C'
 ECHR 'A'
 ECHR 'P'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ECHR ' '
 EJMP 27
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ETOK 211
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 213:    ""
                        \
                        \ Encoded as:   ""

ENDIF

 EQUB VE                \ Token 214:    ""
                        \
                        \ Encoded as:   ""

 EJMP 15                \ Token 215:    "{left align} UNKNOWN PLANET"
 ECHR ' '               \
 ECHR 'U'               \ Encoded as:   "{15} UNK<227>WN [145]"
 ECHR 'N'
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 ECHR ' '
 ETOK 145
 EQUB VE

 EJMP 9                 \ Token 216:    "{clear screen}
 EJMP 8                 \                {tab 6}
 EJMP 23                \                {move to row 10, white, lower case}
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
 EJMP 1                 \                {all caps}
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Master: The Master version indents the "INCOMING MESSAGE" shown during mission briefings to the right by one space
 ECHR ' '               \                (space)
ENDIF
 ETWO 'I', 'N'          \                INCOMING MESSAGE"
 ECHR 'C'               \
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
 ECHR 'O'               \ Encoded as:   "{9}{8}{23}{1}<240>COM[195]M<237>SA
ELIF _6502SP_VERSION
 ECHR 'O'               \ Encoded as:   "{9}{8}{23}{30}{1}<240>COM[195]M<237>SA
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 ECHR 'O'               \ Encoded as:   "{9}{8}{23}{1} <240>COM[195]M<237>SA
ENDIF
 ECHR 'M'               \                <231>"
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EQUB VE

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 ECHR 'C'               \ Token 217:    "CURRUTHERS"
 ECHR 'U'               \
 ECHR 'R'               \ Encoded as:   "CURRU<226><244>S"
 ECHR 'R'
 ECHR 'U'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'F'               \ Token 218:    "FOSDYKE SMYTHE"
 ECHR 'O'               \
 ECHR 'S'               \ Encoded as:   "FOSDYKE SMY<226>E"
 ECHR 'D'
 ECHR 'Y'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'M'
 ECHR 'Y'
 ETWO 'T', 'H'
 ECHR 'E'
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 217:    "{single cap}CURRUTHERS"
 ECHR 'C'               \
 ECHR 'U'               \ Encoded as:   "{19}CURRU<226><244>S"
 ECHR 'R'
 ECHR 'R'
 ECHR 'U'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 EJMP 19                \ Token 218:    "{single cap}FOSDYKE {single cap}SMYTHE"
 ECHR 'F'               \
 ECHR 'O'               \ Encoded as:   "{19}FOSDYKE{26}SMY<226>E"
 ECHR 'S'
 ECHR 'D'
 ECHR 'Y'
 ECHR 'K'
 ECHR 'E'
 EJMP 26
 ECHR 'S'
 ECHR 'M'
 ECHR 'Y'
 ETWO 'T', 'H'
 ECHR 'E'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 217:    ""
                        \
                        \ Encoded as:   ""

 EQUB VE                \ Token 218:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_NES_VERSION)

 ECHR 'F'               \ Token 219:    "FORTESQUE"
 ETWO 'O', 'R'          \
 ECHR 'T'               \ Encoded as:   "F<253>T<237><254>E"
 ETWO 'E', 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 EQUB VE

 ETOK 203               \ Token 220:    "WAS LAST SEEN AT {single cap}REESDICE"
 ETWO 'R', 'E'          \
 ETWO 'E', 'S'          \ Encoded as:   "[203]<242><237><241><233>"
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 EQUB VE

ELIF _NES_VERSION

 EJMP 19                \ Token 219:    "{single cap}FORTESQUE"
 ECHR 'F'               \
 ETWO 'O', 'R'          \ Encoded as:   "{19}F<253>T<237><254>E"
 ECHR 'T'
 ETWO 'E', 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 EQUB VE

 ETOK 203               \ Token 220:    "WAS LAST SEEN AT {single cap}{single
 EJMP 19                \                cap}REESDICE"
 ETWO 'R', 'E'          \
 ETWO 'E', 'S'          \ Encoded as:   "[203]{19{<242><237><241><233>"
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 EQUB VE

ENDIF

IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)

 ECHR 'I'               \ Token 221:    "IS BELIEVED TO HAVE JUMPED TO THIS
 ECHR 'S'               \                GALAXY"
 ECHR ' '               \
 ETWO 'B', 'E'          \ Encoded as:   "IS <247>LIEV<252>[201]HA<250> JUMP<252>
 ECHR 'L'               \                [201][148]G<228>AXY"
 ECHR 'I'
 ECHR 'E'
 ECHR 'V'
 ETWO 'E', 'D'
 ETOK 201
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'D'
 ETOK 201
 ETOK 148
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'I'               \ Token 221:    "IS BELIEVED TO HAVE JUMPED TO THIS
 ECHR 'S'               \                GALAXY"
 ECHR ' '               \
 ETWO 'B', 'E'          \ Encoded as:   "IS <247>LIE<250>D[201]HA<250> JUMP[196]
 ECHR 'L'               \                TO [148]G<228>AXY"
 ECHR 'I'
 ECHR 'E'
 ETWO 'V', 'E'
 ECHR 'D'
 ETOK 201
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 ETOK 196
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 ETOK 148
 ECHR 'G'
 ETWO 'A', 'L'
 ECHR 'A'
 ECHR 'X'
 ECHR 'Y'
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 221:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EJMP 25                \ Token 222:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
IF NOT(_MASTER_VERSION OR _NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 29                \                {tab 6, white, lower case in words}
 EJMP 14                \                {justify}
 EJMP 2                 \                {sentence case}
 ECHR 'G'               \                GOOD DAY {single cap}COMMANDER
 ECHR 'O'               \                {commander name}.{cr}
 ECHR 'O'               \                 {single cap}I{lower case} AM {single
 ECHR 'D'               \                cap}AGENT{single cap}BLAKE OF {single
 ECHR ' '               \                cap}NAVAL {single cap}INTELLEGENCE.{cr}
 ECHR 'D'               \                 {single cap}AS YOU KNOW, THE {single
 ECHR 'A'               \                cap}NAVY HAVE BEEN KEEPING THE {single
 ECHR 'Y'               \                cap}THARGOIDS OFF YOUR ASS OUT IN DEEP
 ECHR ' '               \                SPACE FOR MANY YEARS NOW. {single cap}
 ETOK 154               \                WELL THE SITUATION HAS CHANGED.{cr}
 ECHR ' '               \                 {single cap}OUR BOYS ARE READY FOR A
 EJMP 4                 \                PUSH RIGHT TO THE HOME SYSTEM OF THOSE
ELIF _MASTER_VERSION
 EJMP 29                \                {tab 6, white, lower case in words}
 EJMP 14                \                {justify}
 EJMP 2                 \                {sentence case}
 ECHR 'G'               \                GOOD DAY {single cap}COMMANDER
 ECHR 'O'               \                {commander name}.{cr}
 ECHR 'O'               \                 {single cap}I{lower case} AM {single
 ECHR 'D'               \                cap}AGENT{single cap}BLAKE OF {single
 ECHR ' '               \                cap}NAVAL {single cap}INTELLIGENCE.{cr}
 ECHR 'D'               \                 {single cap}AS YOU KNOW, THE {single
 ECHR 'A'               \                cap}NAVY HAVE BEEN KEEPING THE {single
 ECHR 'Y'               \                cap}THARGOIDS OFF YOUR ASS OUT IN DEEP
 ECHR ' '               \                SPACE FOR MANY YEARS NOW. {single cap}
 ETOK 154               \                WELL THE SITUATION HAS CHANGED.{cr}
 ECHR ' '               \                 {single cap}OUR BOYS ARE READY FOR A
 EJMP 4                 \                PUSH RIGHT TO THE HOME SYSTEM OF THOSE
ELIF _NES_VERSION
 EJMP 29                \                {tab 6, lower case in words}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}
 EJMP 19                \                {single cap}
 ECHR 'G'               \                GOOD DAY {single cap}COMMANDER
 ECHR 'O'               \                {commander name}.{cr}
 ECHR 'O'               \                {cr}
 ECHR 'D'               \                 {single cap}I{lower case} AM {single
 ECHR ' '               \                cap}AGENT{single cap}BLAKE OF {single
 ECHR 'D'               \                cap}NAVAL {single cap}INTELLIGENCE.{cr}
 ECHR 'A'               \                {cr}
 ECHR 'Y'               \                 {single cap}AS YOU KNOW, THE {single
 ECHR ' '               \                cap}NAVY HAVE BEEN KEEPING THE {single
 ETOK 154               \                cap}THARGOIDS OFF YOUR BACK OUT IN DEEP
 ECHR ' '               \                SPACE FOR MANY YEARS NOW. {single cap}
 EJMP 4                 \                WELL THE SITUATION HAS CHANGED.{cr}
 ETOK 204               \                {cr}
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
 ETOK 204               \                MOTHERS.{cr}
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
 ETOK 204               \                MURDERERS.{cr}
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'               \                 {single cap}
 EJMP 13                \                {wait for key press}
 ECHR ' '               \                {clear screen}
 ECHR 'A'               \                {white}
 ECHR 'M'               \                {tab 6, white, lower case in words}
 ECHR ' '               \                I{lower case} HAVE OBTAINED THE DEFENCE
 EJMP 19                \                PLANS FOR THEIR {single cap}HIVE
 ECHR 'A'               \                {single cap}WORLDS.{cr} {single cap}THE
 ECHR 'G'               \                BEETLES KNOW WE'VE GOT SOMETHING BUT
 ETWO 'E', 'N'          \                NOT WHAT.{cr} {single cap}IF {single
 ECHR 'T'               \                cap}I TRANSMIT THE PLANS TO OUR BASE ON
 ECHR ' '               \                {single cap}BIRERA THEY'LL INTERCEPT
 EJMP 19                \                THE TRANSMISSION. {single cap}I NEED A
 ECHR 'B'               \                SHIP TO MAKE THE RUN.{cr}
 ETWO 'L', 'A'          \                 {single cap}YOU'RE ELECTED.{cr}
 ECHR 'K'               \                 {single cap}THE PLANS ARE UNIPULSE
 ECHR 'E'               \                CODED WITHIN THIS TRANSMISSION.{cr}
 ECHR ' '               \                 {single cap}{tab 6}YOU WILL BE
 ECHR 'O'               \                PAID.{cr}
 ECHR 'F'               \                 {single cap}    {single cap}GOOD LUCK
 ECHR ' '               \                {single cap}COMMANDER.{cr}
 EJMP 19                \                {left align}
 ECHR 'N'               \                {tab 6}{all caps}  MESSAGE ENDS
 ECHR 'A'               \                {wait for key press}"
 ECHR 'V'               \
ELIF _NES_VERSION
 EJMP 19                \                 {single cap}OUR BOYS ARE READY FOR A
 ECHR 'I'               \                PUSH RIGHT TO THE HOME SYSTEM OF THOSE
 ECHR ' '               \                MURDERERS.{cr}
 ECHR 'A'               \                {cr}
 ECHR 'M'               \                 {single cap}{wait for key press}{clear
 EJMP 26                \                screen}{tab 6, lower case in words}
 ECHR 'A'               \                I{lower case} HAVE OBTAINED THE DEFENCE
 ETWO 'G', 'E'          \                PLANS FOR THEIR {single cap}HIVE{single
 ECHR 'N'               \                cap}WORLDS.{cr}
 ECHR 'T'               \                {cr}
 EJMP 26                \                {wait for key press}
 ECHR 'B'               \                {clear screen}
 ETWO 'L', 'A'          \                {move to row 7, lower case}{single cap}
 ECHR 'K'               \                {single cap}THE BEETLES KNOW WE'VE GOT
 ECHR 'E'               \                SOMETHING BUT NOT WHAT.{cr}
 ECHR ' '               \                {cr}
 ECHR 'O'               \                {single cap}IF {single cap}I TRANSMIT
 ECHR 'F'               \                THE PLANS TO OUR BASE ON {single cap}
 EJMP 26                \                BIRERA THEY'LL INTERCEPT THE
 ECHR 'N'               \                TRANSMISSION. {single cap}I NEED A SHIP
 ECHR 'A'               \                 TO MAKE THE RUN.{cr}
 ECHR 'V'               \                {cr}
ENDIF
IF _DISC_DOCKED \ Master: The disc and 6502SP versions contain a spelling mistake in the mission 2 briefing that's shown when picking up the plans from Ceerdi - they incorrectly spell intelligence as "intellegence". The correct spelling is used in the Master version
 ECHR 'A'               \ Encoded as:   "{25}{9}{29}{14}{2}GOOD DAY [154]
 ECHR 'L'               \                 {4}[204]I{13} AM {19}AG<246>T {19}B
 ECHR ' '               \                <249>KE OF {19}NAVAL {19}<240>TEL<229>
 EJMP 19                \                G<246><233>[204]AS [179] K<227>W, [147]
 ETWO 'I', 'N'          \                {19}NAVY HA<250> <247><246> KEEP[195]
 ECHR 'T'               \                [147]{19}<226><238>GOIDS OFF [179]R ASS
 ECHR 'E'               \                 <217>T <240> DEEP SPA<233> F<253>
 ECHR 'L'               \                 <239>NY YE<238>S <227>W. {19}WELL
 ETWO 'L', 'E'          \                 [147]S<219>UA<251><223> HAS CH<255>G
 ECHR 'G'               \                <252>[204]<217>R BOYS <238>E <242>ADY F
 ETWO 'E', 'N'          \                <253>[208]PUSH RIGHT[201][147]HOME
 ETWO 'C', 'E'          \                 SYSTEM OF <226>O<218> MO<226><244>S
 ETOK 204               \                [204]{24}{9}{29}I{13} HA<250> OBTA
ELIF _6502SP_VERSION
 ECHR 'A'               \ Encoded as:   "{25}{9}{30}{29}{14}{2}GOOD DAY [154]
 ECHR 'L'               \                 {4}[204]I{13} AM {19}AG<246>T {19}B
 ECHR ' '               \                <249>KE OF {19}NAVAL {19}<240>TEL<229>
 EJMP 19                \                G<246><233>[204]AS [179] K<227>W, [147]
 ETWO 'I', 'N'          \                {19}NAVY HA<250> <247><246> KEEP[195]
 ECHR 'T'               \                [147]{19}<226><238>GOIDS OFF [179]R ASS
 ECHR 'E'               \                 <217>T <240> DEEP SPA<233> F<253>
 ECHR 'L'               \                 <239>NY YE<238>S <227>W. {19}WELL
 ETWO 'L', 'E'          \                 [147]S<219>UA<251><223> HAS CH<255>G
 ECHR 'G'               \                <252>[204]<217>R BOYS <238>E <242>ADY F
 ETWO 'E', 'N'          \                <253>[208]PUSH RIGHT[201][147]HOME
 ETWO 'C', 'E'          \                 SYSTEM OF <226>O<218> MO<226><244>S
 ETOK 204               \                [204]{24}{9}{30}{29}I{13} HA<250> OBTA
ELIF _C64_VERSION OR _APPLE_VERSION
 ETWO 'A', 'L'          \ Encoded as:   "{25}{9}{29}{14}{2}GOOD DAY [154]
 ECHR ' '               \                 {4}[204]I{13} AM {19}AG<246>T {19}B
 EJMP 19                \                <249>KE OF {19}NAV<228> {19}<240>TELLI
 ETWO 'I', 'N'          \                G<246><233>[204]AS [179] K<227>W, [147]
 ECHR 'T'               \                {19}NAVY HA<250> <247><246> KEEP[195]
 ECHR 'E'               \                [147]{19}<226><238>GOIDS OFF [179]R ASS
 ECHR 'L'               \                 <217>T <240> DEEP SPA<233> F<253>
 ETWO 'L', 'E'          \                 <239>NY YE<238>S <227>W. {19}WELL
                        \                 [147]S<219>UA<251><223> HAS CH<255>G
 ECHR 'G'               \                <252>[204]<217>R BOYS <238>E <242>ADY F
 ETWO 'E', 'N'          \                <253>[208]PUSH RIGHT[201][147]HOME
 ETWO 'C', 'E'          \                 SYSTEM OF <226>O<218> MURD<244><244>S
 ETOK 204               \                [204]{24}{9}{29}I{13} HA<250> OBTA
ELIF _MASTER_VERSION
 ETWO 'A', 'L'          \ Encoded as:   "{25}{9}{29}{14}{2}GOOD DAY [154]
 ECHR ' '               \                 {4}[204]I{13} AM {19}AG<246>T {19}B
 EJMP 19                \                <249>KE OF {19}NAV<228> {19}<240>TELLI
 ETWO 'I', 'N'          \                G<246><233>[204]AS [179] K<227>W, [147]
 ECHR 'T'               \                {19}NAVY HA<250> <247><246> KEEP[195]
 ECHR 'E'               \                [147]{19}<226><238>GOIDS OFF [179]R ASS
 ECHR 'L'               \                 <217>T <240> DEEP SPA<233> F<253>
 ECHR 'L'               \                 <239>NY YE<238>S <227>W. {19}WELL
 ECHR 'I'               \                 [147]S<219>UA<251><223> HAS CH<255>G
 ECHR 'G'               \                <252>[204]<217>R BOYS <238>E <242>ADY F
 ETWO 'E', 'N'          \                <253>[208]PUSH RIGHT[201][147]HOME
 ETWO 'C', 'E'          \                 SYSTEM OF <226>O<218> MURD<244><244>S
 ETOK 204               \                [204]{24}{9}{29}I{13} HA<250> OBTA
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
 ETWO 'A', 'L'          \ Encoded as:   "{25}{9}{29}{14}{2}GOOD DAY [154] {4}
 ECHR ' '               \                [204]I{13} AM {19}AG<246>T {19}B<249>
 EJMP 19                \                KE OF {19}NAV<228> {19}<240>TEL<229>
 ETWO 'I', 'N'          \                G<246><233>[204]AS [179] K<227>W, [147]
 ECHR 'T'               \                {19}NAVY HA<250> <247><246> KEEP[195]
 ECHR 'E'               \                [147]{19}<226><238>GOIDS OFF [179]R ASS
 ECHR 'L'               \                 <217>T <240> DEEP SPA<233> F<253>
 ETWO 'L', 'E'          \                 <239>NY YE<238>S <227>W. {19}WELL
 ECHR 'G'               \                 [147]S<219>UA<251><223> HAS CH<255>G
 ETWO 'E', 'N'          \                <252>[204]<217>R BOYS <238>E <242>ADY F
 ETWO 'C', 'E'          \                <253>[208]P<236>H RIGHT[201][147]HOME
 ETOK 204               \                 SY<222>EM OF <226>O<218> MO<226><244>S
 ECHR 'A'               \                [204]{24}{9}{29}I{13} HA<250> OBTA
ELIF _NES_VERSION
 ETWO 'A', 'L'          \                 {single cap}YOU'RE ELECTED.{cr}
 EJMP 26                \                {cr}
 ETWO 'I', 'N'          \                 {single cap}THE PLANS ARE UNIPULSE
 ECHR 'T'               \                CODED WITHIN THIS TRANSMISSION.{cr}
 ECHR 'E'               \                {cr}
 ECHR 'L'               \                {single cap}{tab 6}
 ECHR 'L'               \                YOU WILL BE PAID.{cr}
 ECHR 'I'               \                {cr}
 ETWO 'G', 'E'          \                 {single cap}    {single cap}GOOD LUCK
 ECHR 'N'               \                {single cap}COMMANDER.{cr}
 ETWO 'C', 'E'          \                {left align}{cr}
 ETOK 204               \                {tab 6}{all caps}  MESSAGE ENDS
 EJMP 19                \                {wait for key press}"
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR 'A'               \                <240>[196][147]DEF<246><233> P<249>NS F
 ECHR 'S'               \                <253> <226>EIR {19}HI<250> {19}W<253>LD
 ECHR ' '               \                S[204][147]<247><221><229>S K<227>W WE'
 ETOK 179               \                <250> GOT <235>ME<226>[195]BUT <227>T W
 ECHR ' '               \                H<245>[204]IF {19}I T<248>NSM<219>
 ECHR 'K'               \                 [147]P<249>NS[201]<217>R BA<218> <223>
 ETWO 'N', 'O'          \                 {19}<234><242><248> <226>EY'LL <240>T
 ECHR 'W'               \                <244><233>PT [147]TR<255>SMISSI<223>.
 ECHR ','               \                 {19}I NE<252>[208][207][201]<239>KE
 ECHR ' '               \                 [147]RUN[204][179]'<242> E<229>CT<252>
 ETOK 147               \                [204][147]P<249>NS A<242> UNIPUL<218> C
 EJMP 19                \                OD[196]WI<226><240> [148]TR<255>SMISSI
 ECHR 'N'               \                <223>[204]{8}[179] W<220>L <247> PAID
 ECHR 'A'               \                [204]    {19}GOOD LUCK [154][212]{24}"
 ECHR 'V'
 ECHR 'Y'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
 ECHR 'S'               \                <240>[196][147]DEF<246><233> P<249>NS F
 ECHR ' '               \                <253> <226>EIR {19}HI<250> {19}W<253>LD
 ETOK 179               \                S[204][147]<247><221><229>S K<227>W WE'
 ECHR ' '               \                <250> GOT <235>ME<226>[195]BUT <227>T W
 ECHR 'K'               \                H<245>[204]IF {19}I T<248>NSM<219>
 ETWO 'N', 'O'          \                 [147]P<249>NS[201]<217>R BA<218> <223>
 ECHR 'W'               \                 {19}<234><242><248> <226>EY'LL <240>T
 ECHR ','               \                <244><233>PT [147]TR<255>SMISSI<223>.
 ECHR ' '               \                 {19}I NE<252>[208][207][201]<239>KE
 ETOK 147               \                 [147]RUN[204][179]'<242> E<229>CT<252>
 EJMP 19                \                [204][147]P<249>NS A<242> UNIPUL<218> C
 ECHR 'N'               \                OD[196]WI<226><240> [148]TR<255>SMISSI
 ECHR 'A'               \                <223>[204]{8}[179] W<220>L <247> PAID
 ECHR 'V'               \                [204]    {19}GOOD LUCK [154][212]{24}"
 ECHR 'Y'
ELIF _NES_VERSION
 ECHR 'A'               \
 ECHR 'S'               \ Encoded as:   "{25}{9}{29}{14}{13}{19}GOOD DAY [154]
 ECHR ' '               \                 {4}[204]{19}I AM{26}A<231>NT{26}B<249>
 ETOK 179               \                KE OF{26}NAV<228>{26}<240>TELLI<231>N
 ECHR ' '               \                <233>[204]{19}AS [179] K<227>W, <226>E
 ECHR 'K'               \                {26}NAVY HA<250> <247><246> KEEP[195]
 ETWO 'N', 'O'          \                <226>E{26}<226><238>GOIDS OFF [179]R BA
 ECHR 'W'               \                CK <217>T <240>{26}DEEP{26}SPA<233> F
 ECHR ','               \                <253> <239>NY YE<238>S <227>W.{26}WELL
 ECHR ' '               \                 [147]S<219>U<245>I<223> HAS CH<255>
 ETWO 'T', 'H'          \                <231>D[204]{19}<217>R BOYS <238>E <242>
 ECHR 'E'               \                ADY F<253>[208]P<236>H RIGHT[201]<226>E
 EJMP 26                \                {26}HOME{26}SY<222>EM OF <226>O<218> MU
 ECHR 'N'               \                RDE<242>RS[204]{19}I{13} HA<250> OBTA
 ECHR 'A'               \                <240>[196][147]DEF<246><233> P<249>NS F
 ECHR 'V'               \                <253> <226>EIR{26}HI<250>{26}[146]S
 ECHR 'Y'               \                [204]{24}{9}{29}{19}[147]<247><221>
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'N'
 ECHR ' '
 ECHR 'K'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 ETOK 195
ELIF _NES_VERSION
 ECHR ' '               \                <229>S K<227>W WE'<250> GOT <235>M<221>
 ECHR 'H'               \                H[195]BUT <227>T WH<245>[204]{19}IF{26}
 ECHR 'A'               \                I T<248>NSM<219> <226>E{26}P<249>NS
 ETWO 'V', 'E'          \                [201]<217>R BA<218> <223>{26}<234><242>
 ECHR ' '               \                <248> <226>EY'LL <240>T<244><233>PT
 ETWO 'B', 'E'          \                 [147]T<248>NSMISSI<223>.{26}I NE[196]
 ETWO 'E', 'N'          \                A [207][201]<239>KE [147]RUN[204][179]'
 ECHR ' '               \                <242> E<229>CT<252>[204][147]P<249>NS
 ECHR 'K'               \                <238>E{26}UNIPUL<218> COD[196]W<219>H
 ECHR 'E'               \                <240> [148]T<248>NSMISSI<223>.{26}[179]
 ECHR 'E'               \                 W<220>L <247> PAID[204]   {26}GOOD LUC
 ECHR 'P'               \                K [154][212]{24}"
 ETOK 195
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
 EJMP 19
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
ELIF _NES_VERSION
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'N'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
 ECHR 'D'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'S'
 ECHR 'P'
 ECHR 'A'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'M', 'A'
 ECHR 'N'
 ECHR 'Y'
 ECHR ' '
 ECHR 'Y'
 ECHR 'E'
 ETWO 'A', 'R'
 ECHR 'S'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR '.'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 147
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'U'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'A'
 ETWO 'T', 'I'
ELIF _NES_VERSION
 ETWO 'A', 'T'
 ECHR 'I'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'G'
 ETWO 'E', 'D'
 ETOK 204
ELIF _NES_VERSION
 ETWO 'G', 'E'
 ECHR 'D'
 ETOK 204
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'B'
 ECHR 'O'
 ECHR 'Y'
 ECHR 'S'
 ECHR ' '
 ETWO 'A', 'R'
 ECHR 'E'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'Y'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETOK 208
 ECHR 'P'
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR 'U'
 ECHR 'S'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION
 ETWO 'U', 'S'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'H'
 ECHR ' '
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ETOK 201
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'H'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR 'S'
 ECHR 'Y'
 ECHR 'S'
 ECHR 'T'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION
 ECHR 'S'
 ECHR 'Y'
 ETWO 'S', 'T'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'E'
 ECHR 'M'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'O'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'M'
ENDIF
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Master: The disc and 6502SP versions call the Thargoids "those mothers" in the mission 2 briefing that's shown when picking up the plans from Ceerdi. In the Master version, this has changed to "those murderers"
 ECHR 'O'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ETWO 'E', 'R'
 ETWO 'E', 'R'
ELIF _NES_VERSION
 ECHR 'U'
 ECHR 'R'
 ECHR 'D'
 ECHR 'E'
 ETWO 'R', 'E'
 ECHR 'R'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'S'
 ETOK 204
 EJMP 24
 EJMP 9
ELIF _NES_VERSION
 ECHR 'S'
 ETOK 204
 EJMP 19
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 29
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 EJMP 13
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'B'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 ETOK 196
 ETOK 147
 ECHR 'D'
 ECHR 'E'
 ECHR 'F'
 ETWO 'E', 'N'
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'I'
 ECHR 'R'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
 ECHR 'H'
 ECHR 'I'
 ETWO 'V', 'E'
 ECHR ' '
 EJMP 19
 ECHR 'W'
 ETWO 'O', 'R'
 ECHR 'L'
 ECHR 'D'
 ECHR 'S'
 ETOK 204
ELIF _NES_VERSION
 EJMP 26
 ECHR 'H'
 ECHR 'I'
 ETWO 'V', 'E'
 EJMP 26
 ETOK 146
 ECHR 'S'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 29
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 147
 ETWO 'B', 'E'
 ETWO 'E', 'T'
 ETWO 'L', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR '`'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'G'
 ECHR 'O'
 ECHR 'T'
 ECHR ' '
 ETWO 'S', 'O'
 ECHR 'M'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'E'
 ETWO 'T', 'H'
ELIF _NES_VERSION
 ETWO 'E', 'T'
 ECHR 'H'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 195
 ECHR 'B'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'T'
 ECHR ' '
 ECHR 'W'
 ECHR 'H'
 ETWO 'A', 'T'
 ETOK 204
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 EJMP 19
ELIF _NES_VERSION
 EJMP 19
 ECHR 'I'
 ECHR 'F'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ETOK 201
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ETWO 'O', 'N'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'B', 'I'
 ETWO 'R', 'E'
 ETWO 'R', 'A'
 ECHR ' '
 ETWO 'T', 'H'
 ECHR 'E'
 ECHR 'Y'
 ECHR '`'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR 'T'
 ETWO 'E', 'R'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
 ETOK 147
 ECHR 'T'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'R'
 ETWO 'A', 'N'
ELIF _NES_VERSION
 ETWO 'R', 'A'
 ECHR 'N'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETWO 'E', 'D'
 ETOK 208
ELIF _NES_VERSION
 EJMP 26
 ECHR 'I'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETOK 196
 ECHR 'A'
 ECHR ' '
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 207
 ETOK 201
 ETWO 'M', 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETOK 147
 ECHR 'R'
 ECHR 'U'
 ECHR 'N'
 ETOK 204
ENDIF
IF _NES_VERSION
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 179
 ECHR '`'
 ETWO 'R', 'E'
 ECHR ' '
 ECHR 'E'
 ETWO 'L', 'E'
 ECHR 'C'
 ECHR 'T'
 ETWO 'E', 'D'
 ETOK 204
 ETOK 147
 ECHR 'P'
 ETWO 'L', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'A'
 ETWO 'R', 'E'
 ECHR ' '
ELIF _NES_VERSION
 ETWO 'A', 'R'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'U'
 ECHR 'N'
 ECHR 'I'
 ECHR 'P'
 ECHR 'U'
 ECHR 'L'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'D'
 ETOK 196
 ECHR 'W'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'I'
 ETWO 'T', 'H'
ELIF _NES_VERSION
 ETWO 'I', 'T'
 ECHR 'H'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 148
 ECHR 'T'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR 'R'
 ETWO 'A', 'N'
ELIF _NES_VERSION
 ETWO 'R', 'A'
 ECHR 'N'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 204
 EJMP 8
ELIF _NES_VERSION
 ECHR '.'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETOK 179
 ECHR ' '
 ECHR 'W'
 ETWO 'I', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'I'
 ECHR 'D'
 ETOK 204
 ECHR ' '
 ECHR ' '
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ECHR ' '
 EJMP 19
ELIF _NES_VERSION
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'L'
 ECHR 'U'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ETOK 154
 ETOK 212
 EJMP 24
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 222:    ""
                        \
                        \ Encoded as:   ""
ENDIF

IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EJMP 25                \ Token 223:    "{incoming message screen, wait 2s}
 EJMP 9                 \                {clear screen}
 EJMP 29                \                {tab 6, white, lower case in words}
ENDIF
IF _6502SP_VERSION \ Screen
 EJMP 30                \                {white}
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 EJMP 8                 \                {tab 6}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}
 EJMP 19                \                {single cap}WELL DONE {single cap}
 ECHR 'W'               \                COMMANDER.{cr}
 ECHR 'E'               \                 {single cap}YOU HAVE SERVED US WELL
 ECHR 'L'               \                AND WE SHALL REMEMBER.{cr}
 ECHR 'L'               \                 {single cap}WE DID NOT EXPECT THE
 ECHR ' '               \                {single cap}THARGOIDS TO FIND OUT
 ECHR 'D'               \                ABOUT YOU.{cr}
 ETWO 'O', 'N'          \                 {single cap}FOR THE MOMENT PLEASE
 ECHR 'E'               \                ACCEPT THIS {single cap}NAVY {standard
 ECHR ' '               \                tokens, sentence case}EXTRA ENERGY
 ETOK 154               \                UNIT{extended tokens} AS PAYMENT.{cr}
 ETOK 204               \                {left align}
 ETOK 179               \                {tab 6}{all caps}  MESSAGE ENDS
 ECHR ' '               \                {wait for key press}"
 ECHR 'H'               \
ELIF _NES_VERSION
 EJMP 8                 \                {tab 6}
 EJMP 14                \                {justify}
 EJMP 13                \                {lower case}
 EJMP 19                \                {single cap}WELL DONE {single cap}
 ECHR 'W'               \                COMMANDER.{cr}
 ECHR 'E'               \                {cr}
 ECHR 'L'               \                 {single cap}YOU HAVE SERVED US WELL
 ECHR 'L'               \                AND WE SHALL REMEMBER.{cr}
 ECHR ' '               \                {cr}
 ECHR 'D'               \                 {single cap}WE DID NOT EXPECT THE
 ETWO 'O', 'N'          \                {single cap}THARGOIDS TO FIND OUT
 ECHR 'E'               \                ABOUT YOU.{cr}
 ECHR ' '               \                {cr}
 ETOK 154               \                 {single cap}FOR THE MOMENT PLEASE
 ETOK 204               \                ACCEPT THIS {single cap}NAVY {standard
 ETOK 179               \                tokens, sentence case}EXTRA ENERGY
 ECHR ' '               \                UNIT{extended tokens} AS PAYMENT.{cr}
 ECHR 'H'               \                {cr}
 ECHR 'A'               \                {left align}
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
 ECHR 'A'               \ Encoded as:   "{25}{9}{29}{8}{14}{13}{19}WELL D
ELIF _6502SP_VERSION
 ECHR 'A'               \ Encoded as:   "{25}{9}{29}{30}{8}{14}{13}{19}WELL D
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETWO 'V', 'E'          \                <223>E [154][204][179] HA<250> <218>RV
ELIF _NES_VERSION
 ETWO 'V', 'E'          \                {tab 6}{all caps}  MESSAGE ENDS
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR ' '               \                [196]US WELL[178]WE SH<228>L <242>MEMB
 ETWO 'S', 'E'          \                <244>[204]WE DID <227>T EXPECT [147]
 ECHR 'R'               \                {19}<226><238>GOIDS[201]F<240>D <217>T
 ECHR 'V'               \                 AB<217>T [179][204]F<253> [147]MOM
 ETOK 196               \                <246>T P<229>A<218> AC<233>PT [148]{19}
 ECHR 'U'               \                NAVY {6}[114]{5} AS PAYM<246>T[212]
 ECHR 'S'               \                {24}"
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
 ECHR ' '               \                [196]<236> WELL[178]WE SH<228>L <242>ME
 ETWO 'S', 'E'          \                MB<244>[204]WE <241>D <227>T EXPECT
 ECHR 'R'               \                 [147]{19}<226><238>GOIDS[201]F<240>D
 ECHR 'V'               \                 <217>T <216><217>T [179][204]F<253>
 ETOK 196               \                 [147]MOM<246>T P<229>A<218> AC<233>PT
 ETWO 'U', 'S'          \                 [148]{19}NAVY {6}[114]{5} AS PAYM<246>
 ECHR ' '               \                T[212]{24}"
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
ELIF _NES_VERSION
 ECHR ' '               \                {wait for key press}"
 ETWO 'S', 'E'          \
 ECHR 'R'               \ Encoded as:   "{25}{9}{29}{8}{14}{13}{19}WELL D
 ETWO 'V', 'E'          \                <223>E [154][204][179] HA<250> <218>R
 ECHR 'D'               \                <250>D <236> WELL[178]WE SH<228>L <242>
 ECHR ' '               \                MEMB<244>[204]WE <241>D <227>T EXPECT
 ETWO 'U', 'S'          \                <226>E{26}<226><238>GOIDS[201]F<240>D
 ECHR ' '               \                 <217>T <216><217>T [179][204]{19}F
 ECHR 'W'               \                <253> [147]MOM<246>T P<229>A<218> AC
 ECHR 'E'               \                <233>PT <226>{26}NAVY {6}[114]{5} A
 ECHR 'L'               \                S PAYM<246>T[212]{24}"
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'L'
 ETOK 178
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'H'
 ETWO 'A', 'L'
 ECHR 'L'
 ECHR ' '
 ETWO 'R', 'E'
 ECHR 'M'
 ECHR 'E'
 ECHR 'M'
 ECHR 'B'
 ETWO 'E', 'R'
 ETOK 204
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'I'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ETWO 'D', 'I'
ELIF _NES_VERSION
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ETWO 'D', 'I'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'D'
 ECHR ' '
 ETWO 'N', 'O'
 ECHR 'T'
 ECHR ' '
 ECHR 'E'
 ECHR 'X'
 ECHR 'P'
 ECHR 'E'
 ECHR 'C'
 ECHR 'T'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 147
 EJMP 19
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'E'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'T', 'H'
 ETWO 'A', 'R'
 ECHR 'G'
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 ECHR 'S'
 ETOK 201
 ECHR 'F'
 ETWO 'I', 'N'
 ECHR 'D'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
ENDIF
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_ENCYCLOPEDIA OR _NES_VERSION)
 ECHR 'A'
 ECHR 'B'
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _NES_VERSION
 ETWO 'A', 'B'
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETOK 179
 ETOK 204
ENDIF
IF _NES_VERSION
 EJMP 19
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ETOK 147
 ECHR 'M'
 ECHR 'O'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'P'
 ETWO 'L', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'P'
 ECHR 'T'
 ECHR ' '
ENDIF
IF NOT(_NES_VERSION OR _ELITE_A_ENCYCLOPEDIA)
 ETOK 148
 EJMP 19
ELIF _NES_VERSION
 ETWO 'T', 'H'
 ECHR 'I'
 ECHR 'S'
 EJMP 26
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
 ECHR ' '
 EJMP 6
 TOKN 114
 EJMP 5
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ECHR 'A'
 ECHR 'Y'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ETOK 212
 EJMP 24
 EQUB VE

ELIF _ELITE_A_ENCYCLOPEDIA

 EQUB VE                \ Token 223:    ""
                        \
                        \ Encoded as:   ""

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _NES_VERSION \ Master: The Master version contains a new prompt in the extended token table, "ARE YOU SURE?", which isn't present in the other versions. It is used to make sure you really do want to revert to the default commander if you choose that option from the disc access menu

 EQUB VE                \ Token 224:    ""
                        \
                        \ Encoded as:   ""

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 ECHR 'A'               \ Token 224:    "ARE YOU SURE?"
 ETWO 'R', 'E'          \
 ECHR ' '               \ Encoded as:   "A<242> [179] SU<242>?"
 ETOK 179
 ECHR ' '
 ECHR 'S'
 ECHR 'U'
 ETWO 'R', 'E'
 ECHR '?'
 EQUB VE

ENDIF

 ECHR 'S'               \ Token 225:    "SHREW"
 ECHR 'H'               \
 ETWO 'R', 'E'          \ Encoded as:   "SH<242>W"
 ECHR 'W'
 EQUB VE

 ETWO 'B', 'E'          \ Token 226:    "BEAST"
 ECHR 'A'               \
 ETWO 'S', 'T'          \ Encoded as:   "<247>A<222>"
 EQUB VE

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 ECHR 'B'               \ Token 227:    "BISON"
 ECHR 'I'               \
 ECHR 'S'               \ Encoded as:   "BIS<223>"
 ETWO 'O', 'N'
 EQUB VE

ELIF _ELITE_A_VERSION

 ETWO 'B', 'I'          \ Token 227:    "BISON"
 ECHR 'S'               \
 ETWO 'O', 'N'          \ Encoded as:   "<234>IS<223>"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'G'               \ Token 227:    "GNU"
 ETWO 'N', 'U'          \
 EQUB VE                \ Encoded as:   "G<225>"

ENDIF

 ECHR 'S'               \ Token 228:    "SNAKE"
 ECHR 'N'               \
 ECHR 'A'               \ Encoded as:   "SNAKE"
 ECHR 'K'
 ECHR 'E'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'W'               \ Token 229:    "WOLF"
 ECHR 'O'               \
 ECHR 'L'               \ Encoded as:   "WOLF"
 ECHR 'F'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'D'               \ Token 229:    "DOG"
 ECHR 'O'               \
 ECHR 'G'               \ Encoded as:   "DOG"
 EQUB VE

ENDIF

 ETWO 'L', 'E'          \ Token 230:    "LEOPARD"
 ECHR 'O'               \
 ECHR 'P'               \ Encoded as:   "<229>OP<238>D"
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'C'               \ Token 231:    "CAT"
 ETWO 'A', 'T'          \
 EQUB VE                \ Encoded as:   "C<245>"

 ECHR 'M'               \ Token 232:    "MONKEY"
 ETWO 'O', 'N'          \
 ECHR 'K'               \ Encoded as:   "M<223>KEY"
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'G'               \ Token 233:    "GOAT"
 ECHR 'O'               \
 ETWO 'A', 'T'          \ Encoded as:   "GO<245>"
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'F'               \ Token 234:    "FISH"
 ECHR 'I'               \
 ECHR 'S'               \ Encoded as:   "FISH"
 ECHR 'H'
 EQUB VE

ELIF _NES_VERSION

 ECHR 'C'               \ Token 234:    "CARP"
 ETWO 'A', 'R'          \
 ECHR 'P'               \ Encoded as:   "C<238>P"
 EQUB VE

ENDIF

 ERND 15                \ Token 235:    "[71-75] [66-70]"
 ECHR ' '               \
 ERND 14                \ Encoded as:   "[15?] [14?]"
 EQUB VE

 EJMP 17                \ Token 236:    "{system name adjective} [225-229]
 ECHR ' '               \                 [240-244]"
 ERND 29                \
 ECHR ' '               \ Encoded as:   "{17} [29?] [32?]"
 ERND 32
 EQUB VE

 ETOK 175               \ Token 237:    "ITS [76-80] [230-234] [240-244]"
 ERND 16                \
 ECHR ' '               \ Encoded as:   "[175][16?] [30?] [32?]"
 ERND 30
 ECHR ' '
 ERND 32
 EQUB VE

 ERND 33                \ Token 238:    "[245-249] [250-254]"
 ECHR ' '               \
 ERND 34                \ Encoded as:   "[33?] [34?]"
 EQUB VE

 ERND 15                \ Token 239:    "[71-75] [66-70]"
 ECHR ' '               \
 ERND 14                \ Encoded as:   "[15?] [14?]"
 EQUB VE

 ECHR 'M'               \ Token 240:    "MEAT"
 ECHR 'E'               \
 ETWO 'A', 'T'          \ Encoded as:   "ME<245>"
 EQUB VE

 ECHR 'C'               \ Token 241:    "CUTLET"
 ECHR 'U'               \
 ECHR 'T'               \ Encoded as:   "CUTL<221>"
 ECHR 'L'
 ETWO 'E', 'T'
 EQUB VE

 ETWO 'S', 'T'          \ Token 242:    "STEAK"
 ECHR 'E'               \
 ECHR 'A'               \ Encoded as:   "<222>EAK"
 ECHR 'K'
 EQUB VE

IF NOT(_NES_VERSION)

 ECHR 'B'               \ Token 243:    "BURGERS"
 ECHR 'U'               \
 ECHR 'R'               \ Encoded as:   "BURG<244>S"
 ECHR 'G'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ETWO 'S', 'O'          \ Token 244:    "SOUP"
 ECHR 'U'               \
 ECHR 'P'               \ Encoded as:   "<235>UP"
 EQUB VE

ELIF _NES_VERSION

 ECHR 'B'               \ Token 243:    "BURGERS"
 ECHR 'U'               \
 ECHR 'R'               \ Encoded as:   "BUR<231>RS"
 ETWO 'G', 'E'
 ECHR 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 244:    "SOUP"
 ETWO 'O', 'U'
 ECHR 'P'               \ Encoded as:   "S<217>P"
 EQUB VE

ENDIF

 ECHR 'I'               \ Token 245:    "ICE"
 ETWO 'C', 'E'          \
 EQUB VE                \ Encoded as:   "I<233>"

 ECHR 'M'               \ Token 246:    "MUD"
 ECHR 'U'               \
 ECHR 'D'               \ Encoded as:   "MUD"
 EQUB VE

 ECHR 'Z'               \ Token 247:    "ZERO-{single cap}G"
 ETWO 'E', 'R'          \
 ECHR 'O'               \ Encoded as:   "Z<244>O-{19}G"
 ECHR '-'
 EJMP 19
 ECHR 'G'
 EQUB VE

 ECHR 'V'               \ Token 248:    "VACUUM"
 ECHR 'A'               \
 ECHR 'C'               \ Encoded as:   "VACUUM"
 ECHR 'U'
 ECHR 'U'
 ECHR 'M'
 EQUB VE

 EJMP 17                \ Token 249:    "{system name adjective} ULTRA"
 ECHR ' '               \
 ECHR 'U'               \ Encoded as:   "{17} ULT<248>"
 ECHR 'L'
 ECHR 'T'
 ETWO 'R', 'A'
 EQUB VE

 ECHR 'H'               \ Token 250:    "HOCKEY"
 ECHR 'O'               \
 ECHR 'C'               \ Encoded as:   "HOCKEY"
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'C'               \ Token 251:    "CRICKET"
 ECHR 'R'               \
 ECHR 'I'               \ Encoded as:   "CRICK<221>"
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'K'               \ Token 252:    "KARATE"
 ETWO 'A', 'R'          \
 ETWO 'A', 'T'          \ Encoded as:   "K<238><245>E"
 ECHR 'E'
 EQUB VE

 ECHR 'P'               \ Token 253:    "POLO"
 ECHR 'O'               \
 ETWO 'L', 'O'          \ Encoded as:   "PO<224>"
 EQUB VE

 ECHR 'T'               \ Token 254:    "TENNIS"
 ETWO 'E', 'N'          \
 ECHR 'N'               \ Encoded as:   "T<246>NIS"
 ECHR 'I'
 ECHR 'S'
 EQUB VE

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _NES_VERSION \ Master: The Master version contains a new prompt in the extended token table, "{currently selected media} ERROR", which isn't present in the other versions, though it isn't actually used (it was left over from the Commodore 64 version of the game)

 EQUB VE                \ Token 255:    ""
                        \
                        \ Encoded as:   ""

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 EJMP 12                \ Token 255:    "{cr}
 EJMP 30                \                {currently selected media}
 ECHR ' '               \                 ERROR"
 ETWO 'E', 'R'          \
 ECHR 'R'               \ Encoded as:   "{12}{30} <244>R<253>"
 ETWO 'O', 'R'
 EQUB VE

ENDIF

