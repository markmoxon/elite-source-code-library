\ ******************************************************************************
\
\       Name: TWOS2
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Ready-made double-pixel character row bytes for mode 4
\  Deep dive: Drawing colour pixels in mode 4
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
\ Ready-made bytes for plotting two-pixel dashes in mode 4 (the top part of the
\ split screen). See the PIXEL routine for details.
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the TWOS2 table in the I/O processor code is used, which contains double-pixel
\ character row bytes for the mode 1 screen.
ENDIF
\
\ ******************************************************************************

.TWOS2

 EQUB %11000000
 EQUB %01100000
 EQUB %00110000
 EQUB %00011000
 EQUB %00001100
 EQUB %00000110
 EQUB %00000011
 EQUB %00000011

