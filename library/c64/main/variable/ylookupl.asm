\ ******************************************************************************
\
\       Name: ylookupl
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a pixel y-coordinate to the low byte
\             of a screen address
\
\ ******************************************************************************

.ylookupl

 FOR I%, 0, 255

  EQUB (SCBASE + &20 + ((I% AND &F8) * 40)) MOD 256

 NEXT

