\ ******************************************************************************
\
\       Name: TWOS
\       Type: Variable
\   Category: Drawing pixels
IF NOT(_NES_VERSION)
\    Summary: Ready-made single-pixel character row bytes for mode 4
\  Deep dive: Drawing monochrome pixels in mode 4
ELIF _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\    Summary: Ready-made single-pixel character row bytes for the space view
\  Deep dive: Drawing pixels in the NES version
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
ELIF _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\ Ready-made bytes for plotting one-pixel points the space view. See the PIXEL
\ routine for details.
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

 EQUD &08040201         \ ???
 EQUW &2010
 EQUB &40

ENDIF

