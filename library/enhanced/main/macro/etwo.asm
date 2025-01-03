\ ******************************************************************************
\
\       Name: ETWO
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for two-letter tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ETWO 'x', 'y'       Insert two-letter token "xy"
\
\ The newline token can be entered using ETWO '-', '-'.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   'x'                 The first letter of the two-letter token to insert into
\                       the table
\
\   'y'                 The second letter of the two-letter token to insert into
\                       the table
\
\ ******************************************************************************

MACRO ETWO t, k

 IF t = '-' AND k = '-'
  EQUB 215 EOR VE
 ENDIF

 IF t = 'A' AND k = 'B'
  EQUB 216 EOR VE
 ENDIF

 IF t = 'O' AND k = 'U'
  EQUB 217 EOR VE
 ENDIF

 IF t = 'S' AND k = 'E'
  EQUB 218 EOR VE
 ENDIF

 IF t = 'I' AND k = 'T'
  EQUB 219 EOR VE
 ENDIF

 IF t = 'I' AND k = 'L'
  EQUB 220 EOR VE
 ENDIF

 IF t = 'E' AND k = 'T'
  EQUB 221 EOR VE
 ENDIF

 IF t = 'S' AND k = 'T'
  EQUB 222 EOR VE
 ENDIF

 IF t = 'O' AND k = 'N'
  EQUB 223 EOR VE
 ENDIF

 IF t = 'L' AND k = 'O'
  EQUB 224 EOR VE
 ENDIF

 IF t = 'N' AND k = 'U'
  EQUB 225 EOR VE
 ENDIF

 IF t = 'T' AND k = 'H'
  EQUB 226 EOR VE
 ENDIF

 IF t = 'N' AND k = 'O'
  EQUB 227 EOR VE
 ENDIF

 IF t = 'A' AND k = 'L'
  EQUB 228 EOR VE
 ENDIF

 IF t = 'L' AND k = 'E'
  EQUB 229 EOR VE
 ENDIF

 IF t = 'X' AND k = 'E'
  EQUB 230 EOR VE
 ENDIF

 IF t = 'G' AND k = 'E'
  EQUB 231 EOR VE
 ENDIF

 IF t = 'Z' AND k = 'A'
  EQUB 232 EOR VE
 ENDIF

 IF t = 'C' AND k = 'E'
  EQUB 233 EOR VE
 ENDIF

 IF t = 'B' AND k = 'I'
  EQUB 234 EOR VE
 ENDIF

 IF t = 'S' AND k = 'O'
  EQUB 235 EOR VE
 ENDIF

 IF t = 'U' AND k = 'S'
  EQUB 236 EOR VE
 ENDIF

 IF t = 'E' AND k = 'S'
  EQUB 237 EOR VE
 ENDIF

 IF t = 'A' AND k = 'R'
  EQUB 238 EOR VE
 ENDIF

 IF t = 'M' AND k = 'A'
  EQUB 239 EOR VE
 ENDIF

 IF t = 'I' AND k = 'N'
  EQUB 240 EOR VE
 ENDIF

 IF t = 'D' AND k = 'I'
  EQUB 241 EOR VE
 ENDIF

 IF t = 'R' AND k = 'E'
  EQUB 242 EOR VE
 ENDIF

 IF t = 'A' AND k = '?'
  EQUB 243 EOR VE
 ENDIF

 IF t = 'E' AND k = 'R'
  EQUB 244 EOR VE
 ENDIF

 IF t = 'A' AND k = 'T'
  EQUB 245 EOR VE
 ENDIF

 IF t = 'E' AND k = 'N'
  EQUB 246 EOR VE
 ENDIF

 IF t = 'B' AND k = 'E'
  EQUB 247 EOR VE
 ENDIF

 IF t = 'R' AND k = 'A'
  EQUB 248 EOR VE
 ENDIF

 IF t = 'L' AND k = 'A'
  EQUB 249 EOR VE
 ENDIF

 IF t = 'V' AND k = 'E'
  EQUB 250 EOR VE
 ENDIF

 IF t = 'T' AND k = 'I'
  EQUB 251 EOR VE
 ENDIF

 IF t = 'E' AND k = 'D'
  EQUB 252 EOR VE
 ENDIF

 IF t = 'O' AND k = 'R'
  EQUB 253 EOR VE
 ENDIF

 IF t = 'Q' AND k = 'U'
  EQUB 254 EOR VE
 ENDIF

 IF t = 'A' AND k = 'N'
  EQUB 255 EOR VE
 ENDIF

ENDMACRO

