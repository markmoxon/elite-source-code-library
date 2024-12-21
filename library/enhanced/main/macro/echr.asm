\ ******************************************************************************
\
\       Name: ECHR
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for characters in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   ECHR 'x'            Insert ASCII character "x"
\
\ To include an apostrophe, use a backtick character, as in ECHR '`'.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   'x'                 The character to insert into the table
\
\ ******************************************************************************

MACRO ECHR x

 IF x = '`'
  EQUB 39 EOR VE
 ELSE
  EQUB x EOR VE
 ENDIF

ENDMACRO

