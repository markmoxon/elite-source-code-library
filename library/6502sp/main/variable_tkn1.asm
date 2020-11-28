\ ******************************************************************************
\
\       Name: TKN1
\       Type: Variable
\   Category: Text
\    Summary: The first extended token table for recursive tokens 0-255 (DETOK)
\
\ ******************************************************************************

.TKN1

 EQUB VE                \ Token 0:      ""

 EJMP 9                 \ Token 1
 EJMP 11
 EJMP 30
 EJMP 1
 EJMP 8
 ECHR ' '
 ETWO 'D', 'I'
 ECHR 'S'
 ECHR 'K'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR ' '
 ECHR 'M'
 ECHR 'E'
 ETWO 'N', 'U'
 ETWO '-', '-'
 EJMP 10
 EJMP 2
 ECHR '1'
 ECHR '.'
 ECHR ' '
 ETOK 149
 ETWO '-', '-'
 ECHR '2'
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
 ECHR ' '
 ECHR 'C'
 ETWO 'A', 'T'
 ECHR 'A'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 ETWO '-', '-'
 ECHR '4'
 ECHR '.'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
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
 EQUB VE

 EJMP 12                \ Token 2
 ECHR 'W'
 ECHR 'H'
 ECHR 'I'
 ECHR 'C'
 ECHR 'H'
 ECHR ' '
 ETOK 151
 ECHR '?'
 EQUB VE

 ECHR 'C'               \ Token 3
 ECHR 'O'
 ECHR 'M'
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

 ETOK 150               \ Token 4
 ETOK 151
 ECHR ' '
 EJMP 16
 ETOK 152
 ETWO '-', '-'
 EQUB VE

 ETOK 176               \ Token 5
 ERND 18
 ETOK 202
 ERND 19
 ETOK 177
 EQUB VE

 ECHR ' '               \ Token 6
 ECHR ' '
 ETOK 149
 ECHR ' '
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

 ECHR 'P'               \ Token 7
 ETWO 'R', 'E'
 ECHR 'S'
 ECHR 'S'
 ECHR ' '
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

 ETOK 154               \ Token 8
 ECHR '`'
 ECHR 'S'
 ETOK 200
 EQUB VE

 EJMP 21                \ Token 9
 ECHR 'F'
 ECHR 'I'
 ETWO 'L', 'E'
 ETOK 201
 ECHR 'D'
 ECHR 'E'
 ECHR 'L'
 ETWO 'E', 'T'
 ECHR 'E'
 ECHR '?'
 EQUB VE

 EJMP 23                \ Token 10
 EJMP 14
 EJMP 2
 ECHR 'G'
 ETWO 'R', 'E'
 ETWO 'E', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 ECHR 'S'
 ETOK 213
 ETOK 178
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'G'
 ETOK 208
 ECHR 'M'
 ECHR 'O'
 ECHR 'M'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'V'
 ETWO 'A', 'L'
 ECHR 'U'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR ' '
 ETWO 'T', 'I'
 ECHR 'M'
 ECHR 'E'
 ETOK 204
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'W'
 ETWO 'O', 'U'
 ECHR 'L'
 ECHR 'D'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ETOK 179
 ETOK 201
 ECHR 'D'
 ECHR 'O'
 ETOK 208
 ECHR 'L'
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'J'
 ECHR 'O'
 ECHR 'B'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
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
 ETOK 147
 EJMP 19
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
 ETOK 196
 ECHR 'W'
 ECHR 'I'
 ETWO 'T', 'H'
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
 ECHR 'G'
 ETWO 'E', 'N'
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
 ECHR 'L'
 ETWO 'E', 'N'
 ETOK 204
 EJMP 22
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
 ECHR ' '
 EJMP 19
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
 ETWO 'E', 'S'
 ECHR 'T'
 ECHR 'R'
 ECHR 'O'
 ECHR 'Y'
 ECHR ' '
 ETOK 148
 ETOK 207
 ETOK 204
 ETOK 179
 ECHR ' '
 ECHR 'A'
 ETWO 'R', 'E'
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
 ECHR 'P'
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'E'
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
 ETOK 147
 EJMP 19
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
 ECHR 'I'
 ETWO 'T', 'H'
 ECHR ' '
 ETWO 'A', 'N'
 ECHR ' '
 EJMP 6
 TOKN 108
 EJMP 5
 ETOK 177
 EJMP 2
 EJMP 8
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
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

 EJMP 25                \ Token 11
 EJMP 9
 EJMP 30
 EJMP 23
 EJMP 14
 EJMP 2
 ECHR ' '
 ECHR ' '
 ETWO 'A', 'T'
 ECHR 'T'
 ETWO 'E', 'N'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETOK 213
 ECHR '.'
 ECHR ' '
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETOK 196
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'V'
 ECHR 'I'
 ECHR 'C'
 ETWO 'E', 'S'
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
 ETOK 201
 EJMP 19
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

 ECHR '('               \ Token 12
 EJMP 19
 ECHR 'C'
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
 EQUB VE

 ECHR 'B'               \ Token 13
 ECHR 'Y'
 ECHR ' '
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

 EJMP 21                \ Token 14
 ETOK 145
 ETOK 200
 EJMP 26
 EQUB VE

 EJMP 25                \ Token 15
 EJMP 9
 EJMP 30
 EJMP 23
 EJMP 14
 EJMP 2
 ECHR ' '
 ECHR ' '
 ECHR 'C'
 ETWO 'O', 'N'
 ECHR 'G'
 ETWO 'R', 'A'
 ECHR 'T'
 ECHR 'U'
 ETWO 'L', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 ECHR ' '
 ETOK 154
 ECHR '!'
 EJMP 12
 EJMP 12
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'E'
 EJMP 13
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

 ECHR 'F'               \ Token 16
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 ECHR 'D'
 EQUB VE

 ETWO 'N', 'O'          \ Token 17
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'W'               \ Token 18
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 EQUB VE

 ECHR 'F'               \ Token 19
 ECHR 'A'
 ECHR 'M'
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

 ETWO 'N', 'O'          \ Token 20
 ECHR 'T'
 ETWO 'E', 'D'
 EQUB VE

 ETWO 'V', 'E'          \ Token 21
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ECHR 'M'               \ Token 22
 ETWO 'I', 'L'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'M'               \ Token 23
 ECHR 'O'
 ETWO 'S', 'T'
 EQUB VE

 ETWO 'R', 'E'          \ Token 24
 ECHR 'A'
 ECHR 'S'
 ETWO 'O', 'N'
 ETWO 'A', 'B'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 EQUB VE                \ Token 25

 ETOK 165               \ Token 26
 EQUB VE

 ERND 23                \ Token 27
 EQUB VE

 ECHR 'G'               \ Token 28
 ETWO 'R', 'E'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'V'               \ Token 29
 ECHR 'A'
 ETWO 'S', 'T'
 EQUB VE

 ECHR 'P'               \ Token 30
 ETWO 'I', 'N'
 ECHR 'K'
 EQUB VE

 EJMP 2                 \ Token 31
 ERND 28
 ECHR ' '
 ERND 27
 EJMP 13
 ECHR ' '
 ETOK 185
 ECHR 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ETOK 156               \ Token 32
 ECHR 'S'
 EQUB VE

 ERND 26                \ Token 33
 EQUB VE

 ERND 37                \ Token 34
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'E', 'S'
 ECHR 'T'
 ECHR 'S'
 EQUB VE

 ECHR 'O'               \ Token 35
 ETWO 'C', 'E'
 ETWO 'A', 'N'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 36
 ECHR 'H'
 ECHR 'Y'
 ECHR 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 37
 ETWO 'I', 'L'
 ECHR 'L'
 ETWO 'I', 'N'
 ETWO 'E', 'S'
 ECHR 'S'
 EQUB VE

 ETWO 'M', 'A'          \ Token 38
 ECHR 'T'
 ETOK 195
 ECHR 'T'
 ETWO 'R', 'A'
 ETWO 'D', 'I'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ETWO 'L', 'O'          \ Token 39
 ETWO 'A', 'T'
 ECHR 'H'
 ETOK 195
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 ERND 9
 EQUB VE

 ETWO 'L', 'O'          \ Token 40
 ETWO 'V', 'E'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 9
 EQUB VE

 ECHR 'F'               \ Token 41
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'B'
 ETWO 'L', 'E'
 ECHR 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'T'               \ Token 42
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'I'
 ETWO 'S', 'T'
 ECHR 'S'
 EQUB VE

 ECHR 'P'               \ Token 43
 ECHR 'O'
 ETWO 'E', 'T'
 ECHR 'R'
 ECHR 'Y'
 EQUB VE

 ETWO 'D', 'I'          \ Token 44
 ECHR 'S'
 ECHR 'C'
 ECHR 'O'
 ECHR 'S'
 EQUB VE

 ERND 17                \ Token 45
 EQUB VE

 ECHR 'W'               \ Token 46
 ETWO 'A', 'L'
 ECHR 'K'
 ETOK 195
 ETOK 158
 EQUB VE

 ECHR 'C'               \ Token 47
 ETWO 'R', 'A'
 ECHR 'B'
 EQUB VE

 ECHR 'B'               \ Token 48
 ETWO 'A', 'T'
 EQUB VE

 ETWO 'L', 'O'          \ Token 49
 ECHR 'B'
 ETWO 'S', 'T'
 EQUB VE

 EJMP 18                \ Token 50
 EQUB VE

 ETWO 'B', 'E'          \ Token 51
 ECHR 'S'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'P'               \ Token 52
 ETWO 'L', 'A'
 ECHR 'G'
 ECHR 'U'
 ETWO 'E', 'D'
 EQUB VE

 ETWO 'R', 'A'          \ Token 53
 ECHR 'V'
 ECHR 'A'
 ECHR 'G'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'C'               \ Token 54
 ECHR 'U'
 ECHR 'R'
 ECHR 'S'
 ETWO 'E', 'D'
 EQUB VE

 ECHR 'S'               \ Token 55
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'R'
 ECHR 'G'
 ETWO 'E', 'D'
 EQUB VE

 ERND 22                \ Token 56
 ECHR ' '
 ECHR 'C'
 ECHR 'I'
 ECHR 'V'
 ETWO 'I', 'L'
 ECHR ' '
 ECHR 'W'
 ETWO 'A', 'R'
 EQUB VE

 ERND 13                \ Token 57
 ECHR ' '
 ERND 4
 ECHR ' '
 ERND 5
 ECHR 'S'
 EQUB VE

 ECHR 'A'               \ Token 58
 ECHR ' '
 ERND 13
 ECHR ' '
 ETWO 'D', 'I'
 ETWO 'S', 'E'
 ECHR 'A'
 ETWO 'S', 'E'
 EQUB VE

 ERND 22                \ Token 59
 ECHR ' '
 ECHR 'E'
 ETWO 'A', 'R'
 ETWO 'T', 'H'
 ETWO 'Q', 'U'
 ECHR 'A'
 ECHR 'K'
 ETWO 'E', 'S'
 EQUB VE

 ERND 22                \ Token 60
 ECHR ' '
 ETWO 'S', 'O'
 ETWO 'L', 'A'
 ECHR 'R'
 ECHR ' '
 ECHR 'A'
 ECHR 'C'
 ETWO 'T', 'I'
 ECHR 'V'
 ETWO 'I', 'T'
 ECHR 'Y'
 EQUB VE

 ETOK 175               \ Token 61
 ERND 2
 ECHR ' '
 ERND 3
 EQUB VE

 ETOK 147               \ Token 62
 EJMP 17
 ECHR ' '
 ERND 4
 ECHR ' '
 ERND 5
 EQUB VE

 ETOK 175               \ Token 63
 ETOK 193
 ECHR 'S'
 ECHR '`'
 ECHR ' '
 ERND 7
 ECHR ' '
 ERND 8
 EQUB VE

 EJMP 2                 \ Token 64
 ERND 31
 EJMP 13
 EQUB VE

 ETOK 175               \ Token 65
 ERND 16
 ECHR ' '
 ERND 17
 EQUB VE

 ECHR 'J'               \ Token 66
 ECHR 'U'
 ECHR 'I'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'B'               \ Token 67
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'D'
 ECHR 'Y'
 EQUB VE

 ECHR 'W'               \ Token 68
 ETWO 'A', 'T'
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'B'               \ Token 69
 ETWO 'R', 'E'
 ECHR 'W'
 EQUB VE

 ECHR 'G'               \ Token 70
 ETWO 'A', 'R'
 ECHR 'G'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'B'
 ETWO 'L', 'A'
 ETWO 'S', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 EJMP 18                \ Token 71
 EQUB VE

 EJMP 17                \ Token 72
 ECHR ' '
 ERND 5
 EQUB VE

 EJMP 17                \ Token 73
 ECHR ' '
 EJMP 18
 EQUB VE

 EJMP 17                \ Token 74
 ECHR ' '
 ERND 13
 EQUB VE

 ERND 13                \ Token 75
 ECHR ' '
 EJMP 18
 EQUB VE

 ECHR 'F'               \ Token 76
 ETWO 'A', 'B'
 ECHR 'U'
 ETWO 'L', 'O'
 ETWO 'U', 'S'
 EQUB VE

 ECHR 'E'               \ Token 77
 ECHR 'X'
 ECHR 'O'
 ETWO 'T', 'I'
 ECHR 'C'
 EQUB VE

 ECHR 'H'               \ Token 78
 ECHR 'O'
 ECHR 'O'
 ECHR 'P'
 ECHR 'Y'
 EQUB VE

 ECHR 'U'               \ Token 79
 ETWO 'N', 'U'
 ECHR 'S'
 ECHR 'U'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'E'               \ Token 80
 ECHR 'X'
 ECHR 'C'
 ETWO 'I', 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR 'C'               \ Token 81
 ECHR 'U'
 ECHR 'I'
 ECHR 'S'
 ETWO 'I', 'N'
 ECHR 'E'
 EQUB VE

 ECHR 'N'               \ Token 82
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ECHR ' '
 ECHR 'L'
 ECHR 'I'
 ECHR 'F'
 ECHR 'E'
 EQUB VE

 ECHR 'C'               \ Token 83
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ETWO 'N', 'O'
 ECHR 'S'
 EQUB VE

 ECHR 'S'               \ Token 84
 ETWO 'I', 'T'
 ECHR ' '
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'S'
 EQUB VE

 EJMP 2                 \ Token 85
 ERND 31
 EJMP 13
 EQUB VE

 EJMP 3                 \ Token 86
 EQUB VE

 ETOK 147               \ Token 87
 ETOK 145
 ECHR ' '
 EJMP 3
 EQUB VE

 ETOK 147               \ Token 88
 ETOK 146
 ECHR ' '
 EJMP 3
 EQUB VE

 ETOK 148               \ Token 89
 ETOK 145
 EQUB VE

 ETOK 148               \ Token 90
 ETOK 146
 EQUB VE

 ECHR 'S'               \ Token 91
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ETOK 208
 ECHR 'B'
 ETWO 'I', 'T'
 ECHR 'C'
 ECHR 'H'
 EQUB VE

 ECHR 'S'               \ Token 92
 ECHR 'C'
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'D'
 ETWO 'R', 'E'
 ECHR 'L'
 EQUB VE

 ECHR 'B'               \ Token 93
 ETWO 'L', 'A'
 ECHR 'C'
 ECHR 'K'
 ECHR 'G'
 ECHR 'U'
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'R'               \ Token 94
 ECHR 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 EQUB VE

 ECHR 'W'               \ Token 95
 ECHR 'H'
 ETWO 'O', 'R'
 ETWO 'E', 'S'
 ETWO 'O', 'N'
 ECHR ' '
 ETWO 'B', 'E'
 ETWO 'E', 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ECHR 'A'
 ECHR 'D'
 ETOK 196
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

 ECHR 'N'               \ Token 96
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ETWO 'R', 'E'
 ETWO 'M', 'A'
 ECHR 'R'
 ECHR 'K'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR ' '               \ Token 97
 ECHR 'B'
 ETWO 'O', 'R'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ECHR ' '               \ Token 98
 ECHR 'D'
 ECHR 'U'
 ECHR 'L'
 ECHR 'L'
 EQUB VE

 ECHR ' '               \ Token 99
 ECHR 'T'
 ECHR 'E'
 ETWO 'D', 'I'
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

 ECHR ' '               \ Token 100
 ETWO 'R', 'E'
 ECHR 'V'
 ECHR 'O'
 ECHR 'L'
 ECHR 'T'
 ETWO 'I', 'N'
 ECHR 'G'
 EQUB VE

 ETOK 145               \ Token 101
 EQUB VE

 ETOK 146               \ Token 102
 EQUB VE

 ECHR 'P'               \ Token 103
 ETWO 'L', 'A'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'L'               \ Token 104
 ETWO 'I', 'T'
 ECHR 'T'
 ETWO 'L', 'E'
 ECHR ' '
 ETOK 145
 EQUB VE

 ECHR 'D'               \ Token 105
 ECHR 'U'
 ECHR 'M'
 ECHR 'P'
 EQUB VE

 ECHR 'I'               \ Token 106
 ECHR ' '
 ECHR 'H'
 ECHR 'E'
 ETWO 'A', 'R'
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

 ECHR 'Y'               \ Token 107
 ECHR 'E'
 ECHR 'A'
 ECHR 'H'
 ECHR ','
 ECHR ' '
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
 ECHR 'I'
 ETWO 'L', 'E'
 ECHR ' '
 ECHR 'B'
 ECHR 'A'
 ECHR 'C'
 ECHR 'K'
 EQUB VE

 ECHR 'G'               \ Token 108
 ETWO 'E', 'T'
 ECHR ' '
 ETOK 179
 ECHR 'R'
 ECHR ' '
 ECHR 'I'
 ECHR 'R'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
 ECHR ' '
 ECHR 'O'
 ECHR 'V'
 ETWO 'E', 'R'
 ECHR ' '
 ECHR 'T'
 ECHR 'O'
 ETOK 209
 EQUB VE

 ETWO 'S', 'O'          \ Token 109
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ERND 24
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

 ECHR 'T'               \ Token 110
 ECHR 'R'
 ECHR 'Y'
 ETOK 209
 EQUB VE

 EQUB VE                \ Token 111

 EQUB VE                \ Token 112

 EQUB VE                \ Token 113

 EQUB VE                \ Token 114

 ECHR 'W'               \ Token 115
 ECHR 'A'
 ECHR 'S'
 ECHR 'P'
 EQUB VE

 ECHR 'M'               \ Token 116
 ECHR 'O'
 ETWO 'T', 'H'
 EQUB VE

 ECHR 'G'               \ Token 117
 ECHR 'R'
 ECHR 'U'
 ECHR 'B'
 EQUB VE

 ETWO 'A', 'N'          \ Token 118
 ECHR 'T'
 EQUB VE

 EJMP 18                \ Token 119
 EQUB VE

 ECHR 'P'               \ Token 120
 ECHR 'O'
 ETWO 'E', 'T'
 EQUB VE

 ETWO 'A', 'R'          \ Token 121
 ECHR 'T'
 ECHR 'S'
 ECHR ' '
 ECHR 'G'
 ETWO 'R', 'A'
 ECHR 'D'
 ECHR 'U'
 ETWO 'A', 'T'
 ECHR 'E'
 EQUB VE

 ECHR 'Y'               \ Token 122
 ECHR 'A'
 ECHR 'K'
 EQUB VE

 ECHR 'S'               \ Token 123
 ECHR 'N'
 ECHR 'A'
 ETWO 'I', 'L'
 EQUB VE

 ECHR 'S'               \ Token 124
 ECHR 'L'
 ECHR 'U'
 ECHR 'G'
 EQUB VE

 ECHR 'T'               \ Token 125
 ECHR 'R'
 ECHR 'O'
 ECHR 'P'
 ECHR 'I'
 ECHR 'C'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'D'               \ Token 126
 ETWO 'E', 'N'
 ETWO 'S', 'E'
 EQUB VE

 ETWO 'R', 'A'          \ Token 127
 ETWO 'I', 'N'
 EQUB VE

 ECHR 'I'               \ Token 128
 ECHR 'M'
 ECHR 'P'
 ETWO 'E', 'N'
 ETWO 'E', 'T'
 ETWO 'R', 'A'
 ECHR 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'E'               \ Token 129
 ECHR 'X'
 ECHR 'U'
 ETWO 'B', 'E'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'F'               \ Token 130
 ECHR 'U'
 ECHR 'N'
 ECHR 'N'
 ECHR 'Y'
 EQUB VE

 ECHR 'W'               \ Token 131
 ECHR 'I'
 ETWO 'E', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'U'               \ Token 132
 ETWO 'N', 'U'
 ECHR 'S'
 ECHR 'U'
 ETWO 'A', 'L'
 EQUB VE

 ETWO 'S', 'T'          \ Token 133
 ETWO 'R', 'A'
 ECHR 'N'
 ETWO 'G', 'E'
 EQUB VE

 ECHR 'P'               \ Token 134
 ECHR 'E'
 ECHR 'C'
 ECHR 'U'
 ECHR 'L'
 ECHR 'I'
 ETWO 'A', 'R'
 EQUB VE

 ECHR 'F'               \ Token 135
 ETWO 'R', 'E'
 ETWO 'Q', 'U'
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'O'               \ Token 136
 ECHR 'C'
 ECHR 'C'
 ECHR 'A'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'U'               \ Token 137
 ECHR 'N'
 ECHR 'P'
 ETWO 'R', 'E'
 ETWO 'D', 'I'
 ECHR 'C'
 ECHR 'T'
 ETWO 'A', 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'D'               \ Token 138
 ETWO 'R', 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'F'
 ECHR 'U'
 ECHR 'L'
 EQUB VE

 ETOK 171               \ Token 139
 EQUB VE

 ERND 1                 \ Token 140
 ECHR ' '
 ERND 0
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ECHR ' '
 ERND 10
 EQUB VE

 ETOK 140               \ Token 141
 ETOK 178
 ERND 10
 EQUB VE

 ERND 11                \ Token 142
 ECHR ' '
 ECHR 'B'
 ECHR 'Y'
 ECHR ' '
 ERND 12
 EQUB VE

 ETOK 140               \ Token 143
 ECHR ' '
 ECHR 'B'
 ECHR 'U'
 ECHR 'T'
 ECHR ' '
 ETOK 142
 EQUB VE

 ECHR ' '               \ Token 144
 ECHR 'A'
 ERND 20
 ECHR ' '
 ERND 21
 EQUB VE

 ECHR 'P'               \ Token 145
 ECHR 'L'
 ETWO 'A', 'N'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'W'               \ Token 146
 ETWO 'O', 'R'
 ECHR 'L'
 ECHR 'D'
 EQUB VE

 ETWO 'T', 'H'          \ Token 147
 ECHR 'E'
 ECHR ' '
 EQUB VE

 ETWO 'T', 'H'          \ Token 148
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 EQUB VE

 ETWO 'L', 'O'          \ Token 149
 ECHR 'A'
 ECHR 'D'
 ETOK 210
 ETOK 154
 EQUB VE

 EJMP 9                 \ Token 150
 EJMP 11
 EJMP 1
 EJMP 8
 EQUB VE

 ECHR 'D'               \ Token 151
 ECHR 'R'
 ECHR 'I'
 ETWO 'V', 'E'
 EQUB VE

 ECHR ' '               \ Token 152
 ECHR 'C'
 ETWO 'A', 'T'
 ECHR 'A'
 ETWO 'L', 'O'
 ECHR 'G'
 ECHR 'U'
 ECHR 'E'
 EQUB VE

 ECHR 'I'               \ Token 153
 ETWO 'A', 'N'
 EQUB VE

 EJMP 19                \ Token 154
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ECHR 'M'
 ETWO 'A', 'N'
 ECHR 'D'
 ETWO 'E', 'R'
 EQUB VE

 ERND 13                \ Token 155
 EQUB VE

 ECHR 'M'               \ Token 156
 ETWO 'O', 'U'
 ECHR 'N'
 ECHR 'T'
 ECHR 'A'
 ETWO 'I', 'N'
 EQUB VE

 ETWO 'E', 'D'          \ Token 157
 ECHR 'I'
 ECHR 'B'
 ETWO 'L', 'E'
 EQUB VE

 ECHR 'T'               \ Token 158
 ETWO 'R', 'E'
 ECHR 'E'
 EQUB VE

 ECHR 'S'               \ Token 159
 ECHR 'P'
 ECHR 'O'
 ECHR 'T'
 ECHR 'T'
 ETWO 'E', 'D'
 EQUB VE

 ERND 29                \ Token 160
 EQUB VE

 ERND 30                \ Token 161
 EQUB VE

 ERND 6                 \ Token 162
 ECHR 'O'
 ECHR 'I'
 ECHR 'D'
 EQUB VE

 ERND 36                \ Token 163
 EQUB VE

 ERND 35                \ Token 164
 EQUB VE

 ETWO 'A', 'N'          \ Token 165
 ECHR 'C'
 ECHR 'I'
 ETWO 'E', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'E'               \ Token 166
 ECHR 'X'
 ETWO 'C', 'E'
 ECHR 'P'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'E'               \ Token 167
 ECHR 'C'
 ETWO 'C', 'E'
 ECHR 'N'
 ECHR 'T'
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 EQUB VE

 ETWO 'I', 'N'          \ Token 168
 ECHR 'G'
 ETWO 'R', 'A'
 ETWO 'I', 'N'
 ETWO 'E', 'D'
 EQUB VE

 ERND 23                \ Token 169
 EQUB VE

 ECHR 'K'               \ Token 170
 ETWO 'I', 'L'
 ECHR 'L'
 ETWO 'E', 'R'
 EQUB VE

 ECHR 'D'               \ Token 171
 ECHR 'E'
 ECHR 'A'
 ECHR 'D'
 ECHR 'L'
 ECHR 'Y'
 EQUB VE

 ECHR 'E'               \ Token 172
 ECHR 'V'
 ETWO 'I', 'L'
 EQUB VE

 ETWO 'L', 'E'          \ Token 173
 ETWO 'T', 'H'
 ETWO 'A', 'L'
 EQUB VE

 ECHR 'V'               \ Token 174
 ECHR 'I'
 ECHR 'C'
 ECHR 'I'
 ECHR 'O'
 ETWO 'U', 'S'
 EQUB VE

 ETWO 'I', 'T'          \ Token 175
 ECHR 'S'
 ECHR ' '
 EQUB VE

 EJMP 13                \ Token 176
 EJMP 14
 EJMP 19
 EQUB VE

 ECHR '.'               \ Token 177
 EJMP 12
 EJMP 15
 EQUB VE

 ECHR ' '               \ Token 178
 ETWO 'A', 'N'
 ECHR 'D'
 ECHR ' '
 EQUB VE

 ECHR 'Y'               \ Token 179
 ETWO 'O', 'U'
 EQUB VE

 ECHR 'P'               \ Token 180
 ETWO 'A', 'R'
 ECHR 'K'
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'T'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'D'               \ Token 181
 ETWO 'U', 'S'
 ECHR 'T'
 ECHR ' '
 ECHR 'C'
 ETWO 'L', 'O'
 ECHR 'U'
 ECHR 'D'
 ECHR 'S'
 EQUB VE

 ECHR 'I'               \ Token 182
 ETWO 'C', 'E'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'R'
 ECHR 'G'
 ECHR 'S'
 EQUB VE

 ECHR 'R'               \ Token 183
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ECHR ' '
 ECHR 'F'
 ETWO 'O', 'R'
 ETWO 'M', 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR 'S'
 EQUB VE

 ECHR 'V'               \ Token 184
 ECHR 'O'
 ECHR 'L'
 ECHR 'C'
 ECHR 'A'
 ETWO 'N', 'O'
 ETWO 'E', 'S'
 EQUB VE

 ECHR 'P'               \ Token 185
 ECHR 'L'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 ECHR 'T'               \ Token 186
 ECHR 'U'
 ECHR 'L'
 ECHR 'I'
 ECHR 'P'
 EQUB VE

 ECHR 'B'               \ Token 187
 ETWO 'A', 'N'
 ETWO 'A', 'N'
 ECHR 'A'
 EQUB VE

 ECHR 'C'               \ Token 188
 ETWO 'O', 'R'
 ECHR 'N'
 EQUB VE

 EJMP 18                \ Token 189
 ECHR 'W'
 ECHR 'E'
 ETWO 'E', 'D'
 EQUB VE

 EJMP 18                \ Token 190
 EQUB VE

 EJMP 17                \ Token 191
 ECHR ' '
 EJMP 18
 EQUB VE

 EJMP 17                \ Token 192
 ECHR ' '
 ERND 13
 EQUB VE

 ETWO 'I', 'N'          \ Token 193
 ECHR 'H'
 ECHR 'A'
 ETWO 'B', 'I'
 ECHR 'T'
 ETWO 'A', 'N'
 ECHR 'T'
 EQUB VE

 ETOK 191               \ Token 194
 EQUB VE

 ETWO 'I', 'N'          \ Token 195
 ECHR 'G'
 ECHR ' '
 EQUB VE

 ETWO 'E', 'D'          \ Token 196
 ECHR ' '
 EQUB VE

 EQUB VE                \ Token 197

 EQUB VE                \ Token 198

 EQUB VE                \ Token 199

 ECHR ' '               \ Token 200
 ECHR 'N'
 ECHR 'A'
 ECHR 'M'
 ECHR 'E'
 ECHR '?'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 201
 ECHR 'T'
 ECHR 'O'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 202
 ECHR 'I'
 ECHR 'S'
 ECHR ' '
 EQUB VE

 ECHR 'W'               \ Token 203
 ECHR 'A'
 ECHR 'S'
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

 ECHR '.'               \ Token 204
 EJMP 12
 ECHR ' '
 EJMP 19
 EQUB VE

 ECHR 'D'               \ Token 205
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'D'
 EQUB VE

 EJMP 1                 \ Token 206
 ECHR '('
 ECHR 'Y'
 ECHR '/'
 ECHR 'N'
 ECHR ')'
 ECHR '?'
 EQUB VE

 ECHR 'S'               \ Token 207
 ECHR 'H'
 ECHR 'I'
 ECHR 'P'
 EQUB VE

 ECHR ' '               \ Token 208
 ECHR 'A'
 ECHR ' '
 EQUB VE

 ECHR ' '               \ Token 209
 ETWO 'E', 'R'
 ECHR 'R'
 ECHR 'I'
 ETWO 'U', 'S'
 EQUB VE

 ECHR ' '               \ Token 210
 ECHR 'N'
 ECHR 'E'
 ECHR 'W'
 ECHR ' '
 EQUB VE

 EJMP 2                 \ Token 211
 ECHR ' '
 ECHR 'H'
 ETWO 'E', 'R'
 ECHR ' '
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

 ETOK 177               \ Token 212
 EJMP 8
 EJMP 1
 ECHR ' '
 ECHR ' '
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

 ECHR ' '               \ Token 213
 ETOK 154
 ECHR ' '
 EJMP 4
 ECHR ','
 ECHR ' '
 ECHR 'I'
 ECHR ' '
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

 EQUB VE                \ Token 214

 EJMP 15                \ Token 215
 ECHR ' '
 ECHR 'U'
 ECHR 'N'
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR 'N'
 ECHR ' '
 ETOK 145
 EQUB VE

 EJMP 9                 \ Token 216
 EJMP 8
 EJMP 23
 EJMP 30
 EJMP 1
 ETWO 'I', 'N'
 ECHR 'C'
 ECHR 'O'
 ECHR 'M'
 ETOK 195
 ECHR 'M'
 ETWO 'E', 'S'
 ECHR 'S'
 ECHR 'A'
 ETWO 'G', 'E'
 EQUB VE

 ECHR 'C'               \ Token 217
 ECHR 'U'
 ECHR 'R'
 ECHR 'R'
 ECHR 'U'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ECHR 'F'               \ Token 218
 ECHR 'O'
 ECHR 'S'
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

 ECHR 'F'               \ Token 219
 ETWO 'O', 'R'
 ECHR 'T'
 ETWO 'E', 'S'
 ETWO 'Q', 'U'
 ECHR 'E'
 EQUB VE

 ETOK 203               \ Token 220
 ETWO 'R', 'E'
 ETWO 'E', 'S'
 ETWO 'D', 'I'
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'I'               \ Token 221
 ECHR 'S'
 ECHR ' '
 ETWO 'B', 'E'
 ECHR 'L'
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

 EJMP 25                \ Token 222
 EJMP 9
 EJMP 30
 EJMP 29
 EJMP 14
 EJMP 2
 ECHR 'G'
 ECHR 'O'
 ECHR 'O'
 ECHR 'D'
 ECHR ' '
 ECHR 'D'
 ECHR 'A'
 ECHR 'Y'
 ECHR ' '
 ETOK 154
 ECHR ' '
 EJMP 4
 ETOK 204
 ECHR 'I'
 EJMP 13
 ECHR ' '
 ECHR 'A'
 ECHR 'M'
 ECHR ' '
 EJMP 19
 ECHR 'A'
 ECHR 'G'
 ETWO 'E', 'N'
 ECHR 'T'
 ECHR ' '
 EJMP 19
 ECHR 'B'
 ETWO 'L', 'A'
 ECHR 'K'
 ECHR 'E'
 ECHR ' '
 ECHR 'O'
 ECHR 'F'
 ECHR ' '
 EJMP 19
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'A'
 ECHR 'L'
 ECHR ' '
 EJMP 19
 ETWO 'I', 'N'
 ECHR 'T'
 ECHR 'E'
 ECHR 'L'
 ETWO 'L', 'E'
 ECHR 'G'
 ETWO 'E', 'N'
 ETWO 'C', 'E'
 ETOK 204
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ETOK 179
 ECHR ' '
 ECHR 'K'
 ETWO 'N', 'O'
 ECHR 'W'
 ECHR ','
 ECHR ' '
 ETOK 147
 EJMP 19
 ECHR 'N'
 ECHR 'A'
 ECHR 'V'
 ECHR 'Y'
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
 ETOK 147
 EJMP 19
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
 ECHR 'A'
 ECHR 'S'
 ECHR 'S'
 ECHR ' '
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETWO 'I', 'N'
 ECHR ' '
 ECHR 'D'
 ECHR 'E'
 ECHR 'E'
 ECHR 'P'
 ECHR ' '
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
 ECHR ' '
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ETOK 147
 ECHR 'S'
 ETWO 'I', 'T'
 ECHR 'U'
 ECHR 'A'
 ETWO 'T', 'I'
 ETWO 'O', 'N'
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ECHR 'S'
 ECHR ' '
 ECHR 'C'
 ECHR 'H'
 ETWO 'A', 'N'
 ECHR 'G'
 ETWO 'E', 'D'
 ETOK 204
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
 ECHR 'U'
 ECHR 'S'
 ECHR 'H'
 ECHR ' '
 ECHR 'R'
 ECHR 'I'
 ECHR 'G'
 ECHR 'H'
 ECHR 'T'
 ETOK 201
 ETOK 147
 ECHR 'H'
 ECHR 'O'
 ECHR 'M'
 ECHR 'E'
 ECHR ' '
 ECHR 'S'
 ECHR 'Y'
 ECHR 'S'
 ECHR 'T'
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
 ECHR 'O'
 ETWO 'T', 'H'
 ETWO 'E', 'R'
 ECHR 'S'
 ETOK 204
 EJMP 24
 EJMP 9
 EJMP 30
 EJMP 29
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
 ECHR 'E'
 ETWO 'T', 'H'
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
 ECHR 'I'
 ECHR 'F'
 ECHR ' '
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'T'
 ETWO 'R', 'A'
 ECHR 'N'
 ECHR 'S'
 ECHR 'M'
 ETWO 'I', 'T'
 ECHR ' '
 ETOK 147
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
 ECHR ' '
 EJMP 19
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
 ECHR 'R'
 ETWO 'A', 'N'
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ECHR '.'
 ECHR ' '
 EJMP 19
 ECHR 'I'
 ECHR ' '
 ECHR 'N'
 ECHR 'E'
 ETWO 'E', 'D'
 ETOK 208
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
 ECHR 'A'
 ETWO 'R', 'E'
 ECHR ' '
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
 ECHR 'I'
 ETWO 'T', 'H'
 ETWO 'I', 'N'
 ECHR ' '
 ETOK 148
 ECHR 'T'
 ECHR 'R'
 ETWO 'A', 'N'
 ECHR 'S'
 ECHR 'M'
 ECHR 'I'
 ECHR 'S'
 ECHR 'S'
 ECHR 'I'
 ETWO 'O', 'N'
 ETOK 204
 EJMP 8
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
 ECHR ' '
 EJMP 19
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

 EJMP 25                \ Token 223
 EJMP 9
 EJMP 29
 EJMP 30
 EJMP 8
 EJMP 14
 EJMP 13
 EJMP 19
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
 ECHR 'L'
 ECHR ' '
 ECHR 'D'
 ETWO 'O', 'N'
 ECHR 'E'
 ECHR ' '
 ETOK 154
 ETOK 204
 ETOK 179
 ECHR ' '
 ECHR 'H'
 ECHR 'A'
 ETWO 'V', 'E'
 ECHR ' '
 ETWO 'S', 'E'
 ECHR 'R'
 ECHR 'V'
 ETOK 196
 ECHR 'U'
 ECHR 'S'
 ECHR ' '
 ECHR 'W'
 ECHR 'E'
 ECHR 'L'
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
 ECHR 'W'
 ECHR 'E'
 ECHR ' '
 ECHR 'D'
 ECHR 'I'
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
 ETOK 147
 EJMP 19
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
 ECHR 'A'
 ECHR 'B'
 ETWO 'O', 'U'
 ECHR 'T'
 ECHR ' '
 ETOK 179
 ETOK 204
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
 ETOK 148
 EJMP 19
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

 EQUB VE                \ Token 224

 ECHR 'S'               \ Token 225
 ECHR 'H'
 ETWO 'R', 'E'
 ECHR 'W'
 EQUB VE

 ETWO 'B', 'E'          \ Token 226
 ECHR 'A'
 ETWO 'S', 'T'
 EQUB VE

 ECHR 'B'               \ Token 227
 ECHR 'I'
 ECHR 'S'
 ETWO 'O', 'N'
 EQUB VE

 ECHR 'S'               \ Token 228
 ECHR 'N'
 ECHR 'A'
 ECHR 'K'
 ECHR 'E'
 EQUB VE

 ECHR 'W'               \ Token 229
 ECHR 'O'
 ECHR 'L'
 ECHR 'F'
 EQUB VE

 ETWO 'L', 'E'          \ Token 230
 ECHR 'O'
 ECHR 'P'
 ETWO 'A', 'R'
 ECHR 'D'
 EQUB VE

 ECHR 'C'               \ Token 231
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'M'               \ Token 232
 ETWO 'O', 'N'
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'G'               \ Token 233
 ECHR 'O'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'F'               \ Token 234
 ECHR 'I'
 ECHR 'S'
 ECHR 'H'
 EQUB VE

 ERND 15                \ Token 235
 ECHR ' '
 ERND 14
 EQUB VE

 EJMP 17                \ Token 236
 ECHR ' '
 ERND 29
 ECHR ' '
 ERND 32
 EQUB VE

 ETOK 175               \ Token 237
 ERND 16
 ECHR ' '
 ERND 30
 ECHR ' '
 ERND 32
 EQUB VE

 ERND 33                \ Token 238
 ECHR ' '
 ERND 34
 EQUB VE

 ERND 15                \ Token 239
 ECHR ' '
 ERND 14
 EQUB VE

 ECHR 'M'               \ Token 240
 ECHR 'E'
 ETWO 'A', 'T'
 EQUB VE

 ECHR 'C'               \ Token 241
 ECHR 'U'
 ECHR 'T'
 ECHR 'L'
 ETWO 'E', 'T'
 EQUB VE

 ETWO 'S', 'T'          \ Token 242
 ECHR 'E'
 ECHR 'A'
 ECHR 'K'
 EQUB VE

 ECHR 'B'               \ Token 243
 ECHR 'U'
 ECHR 'R'
 ECHR 'G'
 ETWO 'E', 'R'
 ECHR 'S'
 EQUB VE

 ETWO 'S', 'O'          \ Token 244
 ECHR 'U'
 ECHR 'P'
 EQUB VE

 ECHR 'I'               \ Token 245
 ETWO 'C', 'E'
 EQUB VE

 ECHR 'M'               \ Token 246
 ECHR 'U'
 ECHR 'D'
 EQUB VE

 ECHR 'Z'               \ Token 247
 ETWO 'E', 'R'
 ECHR 'O'
 ECHR '-'
 EJMP 19
 ECHR 'G'
 EQUB VE

 ECHR 'V'               \ Token 248
 ECHR 'A'
 ECHR 'C'
 ECHR 'U'
 ECHR 'U'
 ECHR 'M'
 EQUB VE

 EJMP 17                \ Token 249
 ECHR ' '
 ECHR 'U'
 ECHR 'L'
 ECHR 'T'
 ETWO 'R', 'A'
 EQUB VE

 ECHR 'H'               \ Token 250
 ECHR 'O'
 ECHR 'C'
 ECHR 'K'
 ECHR 'E'
 ECHR 'Y'
 EQUB VE

 ECHR 'C'               \ Token 251
 ECHR 'R'
 ECHR 'I'
 ECHR 'C'
 ECHR 'K'
 ETWO 'E', 'T'
 EQUB VE

 ECHR 'K'               \ Token 252
 ETWO 'A', 'R'
 ETWO 'A', 'T'
 ECHR 'E'
 EQUB VE

 ECHR 'P'               \ Token 253
 ECHR 'O'
 ETWO 'L', 'O'
 EQUB VE

 ECHR 'T'               \ Token 254
 ETWO 'E', 'N'
 ECHR 'N'
 ECHR 'I'
 ECHR 'S'
 EQUB VE

 EQUB VE                \ Token 255

