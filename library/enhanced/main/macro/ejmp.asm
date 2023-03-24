\ ******************************************************************************
\
\       Name: EJMP
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for jump tokens in the extended token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the extended token table:
\
\   EJMP n              Insert a jump to address n in the JMTB table
\
\ See the deep dive on "Printing extended text tokens" for details on how jump
\ tokens are stored in the extended token table.
\
\ Arguments:
\
\   n                   The jump number to insert into the table
\
\ ******************************************************************************

MACRO EJMP n

 EQUB n EOR VE

ENDMACRO

