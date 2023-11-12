\ ******************************************************************************
\
\       Name: TWOS2
\       Type: Variable
\   Category: Drawing pixels
IF NOT(_NES_VERSION)
\    Summary: Ready-made double-pixel character row bytes for mode 4
\  Deep dive: Drawing monochrome pixels in mode 4
ELIF _NES_VERSION
\    Summary: Ready-made double-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the NES version
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Ready-made bytes for plotting two-pixel dashes in mode 4 (the top part of the
\ split screen). See the PIXEL routine for details.
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the TWOS2 table in the I/O processor code is used, which contains double-pixel
\ character row bytes for the mode 1 screen.
ELIF _NES_VERSION
\ Ready-made bytes for plotting two-pixel points the space view. See the PIXEL
\ routine for details.
ENDIF
\
\ ******************************************************************************

.TWOS2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Screen

 EQUB %11000000
 EQUB %01100000
 EQUB %00110000
 EQUB %00011000
 EQUB %00001100
 EQUB %00000110
 EQUB %00000011
 EQUB %00000011

ELIF _ELECTRON_VERSION OR _NES_VERSION

 EQUB %11000000
 EQUB %11000000
 EQUB %01100000
 EQUB %00110000
 EQUB %00011000
 EQUB %00001100
 EQUB %00000110
 EQUB %00000011

ENDIF

