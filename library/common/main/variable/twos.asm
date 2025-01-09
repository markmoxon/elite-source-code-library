\ ******************************************************************************
\
\       Name: TWOS
\       Type: Variable
\   Category: Drawing pixels
IF NOT(_C64_VERSION OR _APPLE_VERSION OR _NES_VERSION)
\    Summary: Ready-made single-pixel character row bytes for mode 4
\  Deep dive: Drawing monochrome pixels on the BBC Micro
ELIF _NES_VERSION
\    Summary: Ready-made single-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the NES version
ELIF _C64_VERSION
\    Summary: Ready-made single-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the Commodore 64 version
ELIF _APPLE_VERSION
\    Summary: Ready-made bytes for drawing one-pixel dots in the space view
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Ready-made bytes for plotting one-pixel points in mode 4 (the top part of the
\ split screen). See the PIXEL routine for details.
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the TWOS table in the I/O processor code is used, which contains single-pixel
\ character row bytes for the mode 1 screen.
ELIF _C64_VERSION OR _NES_VERSION
\ Ready-made bytes for plotting one-pixel points in the space view. See the
\ PIXEL routine for details.
ELIF _APPLE_VERSION
\ This table contains ready-made pixel bytes for drawing a one-pixel dot in the
\ high-resolution screen mode on the Apple II.
\
\ The pixels in bits 0 to 6 appear in that order on-screen (so bit 0 is on the
\ left). The comments below show how the bits map into the screen, with seven
\ pixels per byte.
\
\ See the LOIN routine for details.
ENDIF
\
\ ******************************************************************************

.TWOS

IF NOT(_APPLE_VERSION)

 EQUB %10000000
 EQUB %01000000
 EQUB %00100000
 EQUB %00010000
 EQUB %00001000
 EQUB %00000100
 EQUB %00000010
 EQUB %00000001
ENDIF
IF _ELECTRON_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform
 EQUB %10000000
 EQUB %01000000
ENDIF

IF _APPLE_VERSION

 EQUB %00000001         \ x000000
 EQUB %00000010         \ 0x00000
 EQUB %00000100         \ 00x0000
 EQUB %00001000         \ 000x000
 EQUB %00010000         \ 0000x00
 EQUB %00100000         \ 00000x0
 EQUB %01000000         \ 000000x

ENDIF

