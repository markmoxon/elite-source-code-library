\ ******************************************************************************
\
\       Name: celllookl
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a text y-coordinate to the low byte
\             of the address of the start of the character row
\
\ ******************************************************************************

.celllookl

 FOR I%, 0, 24

  EQUB (SCBASE + &2003 + (40 * I%)) MOD 256

 NEXT

