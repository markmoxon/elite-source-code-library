\ ******************************************************************************
\
\       Name: celllookh
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a text y-coordinate to the high byte
\             of the address of the start of the character row
\
\ ******************************************************************************

.celllookh

 FOR I%, 0, 24

  EQUB (SCBASE + &2003 + (40 * I%)) DIV 256

 NEXT

