\ ******************************************************************************
\
\       Name: TWFL
\       Type: Variable
\   Category: Drawing lines
IF NOT(_NES_VERSION)
\    Summary: Ready-made character rows for the left end of a horizontal line in
\             in mode 4
ELIF _NES_VERSION
\    Summary: Ready-made character rows for the left end of a horizontal line in
\             in the space view
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Ready-made bytes for plotting horizontal line end caps in mode 4 (the top part
\ of the split screen). This table provides a byte with pixels at the left end,
\ which is used for the right end of the line.
\
\ See the HLOIN routine for details.
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the TWFL table in the I/O processor code is used, which contains ready-made
\ bytes for plotting horizontal line end caps in mode 1 (the top part of the
\ split screen).
ELIF _NES_VERSION
\ Ready-made bytes for plotting horizontal line end caps in the space view. This
\ table provides a byte with pixels at the left end, which is used for the right
\ end of the line.
\
\ See the HLOIN routine for details.
ENDIF
\
\ ******************************************************************************

.TWFL

 EQUB %10000000
 EQUB %11000000
 EQUB %11100000
 EQUB %11110000
 EQUB %11111000
 EQUB %11111100
 EQUB %11111110

