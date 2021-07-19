\ ******************************************************************************
\
\       Name: CTOK
\       Type: Macro
\   Category: Text
\    Summary: Macro definition for ship data in the encyclopedia's ship cards
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used when building the ship data:
\
\   CTOK n              Insert recursive token [n]
\
\                         * Tokens 0-127 get stored as n + 128
\
\ The ship data tables work differently to the recursive token tables. Data is
\ stored in the table as follows:
\
\   * 0-31:    Jump tokens (EJMP)
\   * 32-127:  Characters (EQUS)
\   * 128-214: Recursive tokens in the msg_3 table (CTOK)
\   * 215-255: Extended two-letter tokens (ETWO)
\
\ Printing of ship data is handled by the write_card routine.
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

