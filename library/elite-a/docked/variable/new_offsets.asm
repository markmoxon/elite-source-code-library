\ ******************************************************************************
\
\       Name: new_offsets
\       Type: Variable
\   Category: Buying ships
\    Summary: Table of offsets for each ship type
\  Deep dive: Buying and flying ships in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ There are 13 bytes in of flight characteristics for each ship type in the
\ new_details table.
\
\ There are also 13 bytes of name and price data for each ship type in the
\ new_ships table (9 characters in the name plus 4 bytes in the 32-bit price).
\
\ As a result, the offset in this table at position X can be used for any of the
\ following:
\
\   * An offset into the new_details to fetch the flight characteristics for
\     ship type X
\
\   * An offset into the new_ships table to fetch the type name of ship type X
\
\   * An offset into the new_price table to fetch the price of ship type X
\
\ ******************************************************************************

.new_offsets

FOR I%, 0, 14
  EQUB I% * 13          \ Offset of the 13-byte details block for ship I%
NEXT

