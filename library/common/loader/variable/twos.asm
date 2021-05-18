\ ******************************************************************************
\
\       Name: TWOS
\       Type: Variable
\   Category: Drawing pixels
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\    Summary: Ready-made single-pixel character row bytes for mode 4
ELIF _6502SP_VERSION OR _MASTER_VERSION
\    Summary: Ready-made single-pixel character row bytes for mode 1
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Ready-made bytes for plotting one-pixel points in mode 4 (the top part of the
\ split screen). See the PIX routine for details.
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ Ready-made bytes for plotting one-pixel points in mode 1 (the top part of the
\ split screen). See the PIX routine for details.
ENDIF
\
\ ******************************************************************************

.TWOS

 EQUB %10000000
 EQUB %01000000
 EQUB %00100000
 EQUB %00010000
 EQUB %00001000
 EQUB %00000100
 EQUB %00000010
 EQUB %00000001

