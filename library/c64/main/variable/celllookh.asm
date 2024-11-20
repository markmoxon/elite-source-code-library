\ ******************************************************************************
\
\       Name: celllookh
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a text y-coordinate to the high byte
\             of the address of the start of the character row in screen RAM
\
\ ------------------------------------------------------------------------------
\
\ In the text view, screen RAM is used to determine the colour of each on-screen
\ character, so this table is used to look up the address of the colour
\ information for the start of a specific text row.
\
\ ******************************************************************************

.celllookh

 FOR I%, 0, 24

  EQUB HI(SCBASE + &2003 + (40 * I%))

 NEXT

