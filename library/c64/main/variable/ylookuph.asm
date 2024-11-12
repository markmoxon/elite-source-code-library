\ ******************************************************************************
\
\       Name: ylookuph
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a pixel y-coordinate to the high byte
\             of a screen address
\
\ ******************************************************************************

.ylookuph

 FOR I%, 0, 255

  EQUB (SCBASE + &20 + ((I% AND &F8) * 40)) DIV 256

 NEXT

