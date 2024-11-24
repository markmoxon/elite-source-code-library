\ ******************************************************************************
\
\       Name: TWOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for two-letter tokens in the token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   TWOK 'x', 'y'       Insert two-letter token "xy"
\
\ See the deep dive on "Printing text tokens" for details on how two-letter
\ tokens are stored in the recursive token table.
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

MACRO TWOK t, k

 IF t = 'A' AND k = 'L'
  EQUB 128 EOR RE
 ENDIF

 IF t = 'L' AND k = 'E'
  EQUB 129 EOR RE
 ENDIF

 IF t = 'X' AND k = 'E'
  EQUB 130 EOR RE
 ENDIF

 IF t = 'G' AND k = 'E'
  EQUB 131 EOR RE
 ENDIF

 IF t = 'Z' AND k = 'A'
  EQUB 132 EOR RE
 ENDIF

 IF t = 'C' AND k = 'E'
  EQUB 133 EOR RE
 ENDIF

 IF t = 'B' AND k = 'I'
  EQUB 134 EOR RE
 ENDIF

 IF t = 'S' AND k = 'O'
  EQUB 135 EOR RE
 ENDIF

 IF t = 'U' AND k = 'S'
  EQUB 136 EOR RE
 ENDIF

 IF t = 'E' AND k = 'S'
  EQUB 137 EOR RE
 ENDIF

 IF t = 'A' AND k = 'R'
  EQUB 138 EOR RE
 ENDIF

 IF t = 'M' AND k = 'A'
  EQUB 139 EOR RE
 ENDIF

 IF t = 'I' AND k = 'N'
  EQUB 140 EOR RE
 ENDIF

 IF t = 'D' AND k = 'I'
  EQUB 141 EOR RE
 ENDIF

 IF t = 'R' AND k = 'E'
  EQUB 142 EOR RE
 ENDIF

 IF t = 'A' AND k = '?'
  EQUB 143 EOR RE
 ENDIF

 IF t = 'E' AND k = 'R'
  EQUB 144 EOR RE
 ENDIF

 IF t = 'A' AND k = 'T'
  EQUB 145 EOR RE
 ENDIF

 IF t = 'E' AND k = 'N'
  EQUB 146 EOR RE
 ENDIF

 IF t = 'B' AND k = 'E'
  EQUB 147 EOR RE
 ENDIF

 IF t = 'R' AND k = 'A'
  EQUB 148 EOR RE
 ENDIF

 IF t = 'L' AND k = 'A'
  EQUB 149 EOR RE
 ENDIF

 IF t = 'V' AND k = 'E'
  EQUB 150 EOR RE
 ENDIF

 IF t = 'T' AND k = 'I'
  EQUB 151 EOR RE
 ENDIF

 IF t = 'E' AND k = 'D'
  EQUB 152 EOR RE
 ENDIF

 IF t = 'O' AND k = 'R'
  EQUB 153 EOR RE
 ENDIF

 IF t = 'Q' AND k = 'U'
  EQUB 154 EOR RE
 ENDIF

 IF t = 'A' AND k = 'N'
  EQUB 155 EOR RE
 ENDIF

 IF t = 'T' AND k = 'E'
  EQUB 156 EOR RE
 ENDIF

 IF t = 'I' AND k = 'S'
  EQUB 157 EOR RE
 ENDIF

 IF t = 'R' AND k = 'I'
  EQUB 158 EOR RE
 ENDIF

 IF t = 'O' AND k = 'N'
  EQUB 159 EOR RE
 ENDIF

ENDMACRO

