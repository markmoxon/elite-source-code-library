\ ******************************************************************************
\
\       Name: CTWOS
\       Type: Variable
\   Category: Drawing pixels
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform
\    Summary: Ready-made single-pixel character row bytes for mode 5
\  Deep dive: Drawing colour pixels in mode 5
ELIF _ELECTRON_VERSION
\    Summary: Ready-made double-pixel character row bytes for the mode 4
\             dashboard
ELIF _C64_VERSION
\    Summary: Ready-made double-pixel character row bytes for the dashboard
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
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
\ bottom part of the screen). The layout of the pixels is similar to the layout
\ of four-colour mode 5 pixels, so the byte at position X contains a 2-pixel
\ mode 4 dot at position 2 * X (we do this so the same code can be used to
\ create both the monochrome Electron dashboard and the four-colour mode 5
\ dashboard in the other versions).
\
ELIF _C64_VERSION
\ Ready-made bytes for plotting two-pixel points in the dashboard (the bottom
\ part of the screen).
ENDIF
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _C64_VERSION OR _ELITE_A_6502SP_IO \ Comment
\ There is one extra row to support the use of CTWOS+1,X indexing in the CPIX2
\ routine. The extra row is a repeat of the first row, and saves us from having
\ to work out whether CTWOS+1+X needs to be wrapped around when drawing a
\ two-pixel dash that crosses from one character block into another. See CPIX2
\ for more details.
\
ENDIF
\ ******************************************************************************

.CTWOS

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _ELITE_A_6502SP_IO \ Platform

 EQUB %10001000
 EQUB %01000100
 EQUB %00100010
 EQUB %00010001
 EQUB %10001000

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 EQUB %10001000
 EQUB %01000100
 EQUB %00100010
 EQUB %00010001

ELIF _ELECTRON_VERSION

 EQUB %11000000
 EQUB %00110000
 EQUB %00001100
 EQUB %00000011

ELIF _C64_VERSION

 EQUB %11000000
 EQUB %00110000
 EQUB %00001100
 EQUB %00000011
 EQUB %11000000

ENDIF

