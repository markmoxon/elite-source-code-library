\ ******************************************************************************
\
\       Name: CTOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for recursive tokens in the encyclopedia's ship
\             cards
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   CTOK n              Insert recursive token [n]
\
\                         * Tokens 0-127 get stored as n + 128
\
\ See the deep dive on "Printing text tokens" for details on how recursive
\ tokens are stored in the recursive token table.
\
\ Arguments:
\
\   n                   The number of the recursive token to insert into the
\                       table, in the range 0 to 127
\
\ ******************************************************************************

MACRO CTOK n

  EQUB n + 128

ENDMACRO

