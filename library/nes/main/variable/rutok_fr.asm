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

 EJMP 19                \ Token 1:      ""
 ETWO 'L', 'E'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'L'
 ETWO 'O', 'N'
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

 EJMP 19                \ Token 2:      ""
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ETWO 'S', 'T'
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

 EJMP 19                \ Token 3:      ""
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'N'
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

 EJMP 19                \ Token 4:      ""
 ETWO 'O', 'U'
 ECHR 'I'
 ECHR ','
 ECHR ' '
 ETWO 'C', 'E'
 ECHR ' '
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

 EJMP 19                \ Token 5:      ""
 ETWO 'O', 'U'
 ECHR 'I'
 ECHR ','
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'N'
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

 EJMP 19                \ Token 6:      ""
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'I'
 ETWO 'R', 'E'
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

 EJMP 19                \ Token 7:      ""
 ECHR 'U'
 ECHR 'N'
 ECHR ' '
 ECHR 'N'
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

 EJMP 19                \ Token 8:      ""
 ECHR 'V'
 ETWO 'O', 'U'
 ECHR 'S'
 ECHR ' '
 ECHR 'P'
 ETWO 'O', 'U'
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

 ERND 25                \ Token 9:      ""
 EQUB VE

 ERND 25                \ Token 10:     ""
 EQUB VE

 ERND 25                \ Token 11:     ""
 EQUB VE

 ERND 25                \ Token 12:     ""
 EQUB VE

 ERND 25                \ Token 13:     ""
 EQUB VE

 ERND 25                \ Token 14:     ""
 EQUB VE

 ERND 25                \ Token 15:     ""
 EQUB VE

 ERND 25                \ Token 16:     ""
 EQUB VE

 ERND 25                \ Token 17:     ""
 EQUB VE

 ERND 25                \ Token 18:     ""
 EQUB VE

 ERND 25                \ Token 19:     ""
 EQUB VE

 ERND 25                \ Token 20:     ""
 EQUB VE

 ERND 25                \ Token 21:     ""
 EQUB VE

 EJMP 19                \ Token 22:     ""
 ETWO 'C', 'E'
 ECHR ' '
 ECHR 'N'
 ECHR '`'
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

 EJMP 19                \ Token 23:     ""
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'Y'
 ECHR ' '
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

