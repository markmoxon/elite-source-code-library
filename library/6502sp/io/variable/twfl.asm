\ ******************************************************************************
\
\       Name: TWFL
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Ready-made character rows for the left end of a horizontal line
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

.TWFL

 EQUB %10001000
 EQUB %11001100
 EQUB %11101110
 EQUB %11111111

