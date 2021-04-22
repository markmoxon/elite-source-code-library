\ ******************************************************************************
\
\       Name: CTWOS
\       Type: Variable
\   Category: Drawing pixels
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform
\    Summary: Ready-made single-pixel character row bytes for mode 5
\  Deep dive: Drawing colour pixels in mode 5
ELIF _ELECTRON_VERSION
\    Summary: Ready-made double-pixel character row bytes for the mode 4
\             dashboard
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ Ready-made bytes for plotting one-pixel points in mode 5 (the bottom part of
\ the split screen). See the dashboard routines SCAN, DIL2 and CPIX2 for
\ details.
\
ELIF _6502SP_VERSION
\ This table is not used by the 6502 Second Processor version of Elite. Instead,
\ the CTWOS table in the I/O processor code is used, which contains single-pixel
\ character row bytes for the mode 2 dashboard.
\
ELIF _ELECTRON_VERSION
\ Ready-made bytes for plotting two-pixel points in the mode 4 dashboard (the
\ bottom part of the screen).
\
ENDIF
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Comment
\ There is one extra row to support the use of CTWOS+1,X indexing in the CPIX2
\ routine. The extra row is a repeat of the first row, and saves us from having
\ to work out whether CTWOS+1+X needs to be wrapped around when drawing a
\ two-pixel dash that crosses from one character block into another. See CPIX2
\ for more details.
\
ENDIF
\ ******************************************************************************

.CTWOS

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Platform

 EQUB %10001000
 EQUB %01000100
 EQUB %00100010
 EQUB %00010001
 EQUB %10001000

ELIF _DISC_DOCKED

 EQUB %10001000
 EQUB %01000100
 EQUB %00100010
 EQUB %00010001

ELIF _ELECTRON_VERSION

 EQUB %11000000
 EQUB %00110000
 EQUB %00001100
 EQUB %00000011

ENDIF

