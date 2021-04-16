\ ******************************************************************************
\
\       Name: TWFR
\       Type: Variable
\   Category: Drawing lines
\    Summary: Ready-made character rows for the right end of a horizontal line
\             in mode 4
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
\ Ready-made bytes for plotting horizontal line end caps in mode 4 (the top part
\ of the split screen). This table provides a byte with pixels at the right end,
\ which is used for the left end of the line.
\
\ See the HLOIN routine for details.
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the TWFR table in the I/O processor code is used, which contains ready-made
\ bytes for plotting horizontal line end caps in mode 1 (the top part of the
\ split screen).
ENDIF
\
\ ******************************************************************************

.TWFR

 EQUB %11111111
 EQUB %01111111
 EQUB %00111111
 EQUB %00011111
 EQUB %00001111
 EQUB %00000111
 EQUB %00000011
 EQUB %00000001

