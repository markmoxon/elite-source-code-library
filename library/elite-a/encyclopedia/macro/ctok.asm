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
\   Value        Contents                                                  Macro
\   -----        --------                                                  -----
\   0-31         Jump tokens                                               EJMP
\   32-127       ASCII characters with no obfuscation                      EQUS
\   128-214      Recursive msg_3 text tokens (subtract 128 to get 0-86)    CTOK
\   215-255      Extended two-letter tokens (subtract 215 to get 0-40)     ETWO
\
\ Printing of ship data is handled by the write_card routine.
\
\ ------------------------------------------------------------------------------
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

