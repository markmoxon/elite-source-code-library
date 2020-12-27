\ ******************************************************************************
\
\       Name: TWFR
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Ready-made character rows for the right end of a horizontal line
\
\ ------------------------------------------------------------------------------
\
\ Ready-made bytes for plotting horizontal line end caps in mode 1 (the top part
\ of the split screen). This table provides a byte with pixels at the left end,
\ which is used for the right end of the line.
\
\ See the HLOIN routine for details.
\
\ ******************************************************************************

.TWFR

 EQUB %11111111
 EQUB %01110111
 EQUB %00110011
 EQUB %00010001

