\ ******************************************************************************
\
\       Name: CONT
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for control codes in the recursive token table
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the recursive token table:
\
\   CONT n              Insert control code token {n}
\
\ See the deep dive on "Printing text tokens" for details on how characters are
\ stored in the recursive token table.
\
\ Arguments:
\
\   n                   The control code to insert into the table
\
\ ******************************************************************************

MACRO CONT n

 EQUB n EOR RE

ENDMACRO

