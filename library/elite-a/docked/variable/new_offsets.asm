\ ******************************************************************************
\
\       Name: new_offsets
\       Type: Variable
\   Category: Buying ships
\    Summary: Table of offsets, measured from new_ships, for each ship's details
\             block
\
\ ******************************************************************************

.new_offsets

FOR I%, 0, 14
  EQUB I% * 13          \ Offset of the 13-byte details block for ship I%
NEXT

