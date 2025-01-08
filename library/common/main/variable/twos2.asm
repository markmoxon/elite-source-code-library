\ ******************************************************************************
\
\       Name: TWOS2
\       Type: Variable
\   Category: Drawing pixels
IF NOT(_C64_VERSION OR _APPLE_VERSION OR _NES_VERSION)
\    Summary: Ready-made double-pixel character row bytes for mode 4
\  Deep dive: Drawing monochrome pixels on the BBC Micro
ELIF _NES_VERSION
\    Summary: Ready-made double-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the NES version
ELIF _C64_VERSION
\    Summary: Ready-made double-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the Commodore 64 version
ELIF _APPLE_VERSION
\    Summary: Ready-made two-bit pixel bytes for plotting colour pixels
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
ELIF _C64_VERSION OR _NES_VERSION
\ Ready-made bytes for plotting two-pixel points in the space view. See the
\ PIXEL routine for details.
ELIF _APPLE_VERSION
\ This table contains ready-made pixel bytes for drawing a one-pixel colour or
\ two-pixel white dot in the high-resolution screen mode on the Apple II.
\
\ Bit 7 in each byte is set, so when this is used as a mask byte via AND, it
\ retains bit 7 (which sets the colour palette).
\
\ The pixels in bits 0 to 6 appear in that order on-screen, so bit 0 is on the
\ left. The comments below show how the bits map into the screen, with seven
\ pixels per byte.
\
\ See the CPIX routine for details.
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

ELIF _ELECTRON_VERSION OR _C64_VERSION OR _NES_VERSION

 EQUB %11000000
 EQUB %11000000
 EQUB %01100000
 EQUB %00110000
 EQUB %00011000
 EQUB %00001100
 EQUB %00000110
 EQUB %00000011

ELIF _APPLE_VERSION

 EQUB %10000011         \ xx00000
 EQUB %10000110         \ 0xx0000
 EQUB %10001100         \ 00xx000
 EQUB %10011000         \ 000xx00
 EQUB %10110000         \ 0000xx0
 EQUB %11100000         \ 00000xx
 EQUB %11000000         \ 000000x

ENDIF

