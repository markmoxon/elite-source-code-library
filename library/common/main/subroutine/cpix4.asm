\ ******************************************************************************
\
\       Name: CPIX4
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a double-height dot on the dashboard
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ Draw a double-height mode 5 dot (2 pixels high, 2 pixels wide).
ELIF _ELECTRON_VERSION
\ Draw a double-height mode 4 dot (2 pixels high, 4 pixels wide).
ELIF _6502SP_VERSION
\ Draw a double-height mode 2 dot (2 pixels high, 2 pixels wide).
ENDIF
\
\ Arguments:
\
\   X1                  The screen pixel x-coordinate of the bottom-left corner
\                       of the dot
\
\   Y1                  The screen pixel y-coordinate of the bottom-left corner
\                       of the dot
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\   COL                 The colour of the dot as a mode 5 character row byte
ELIF _ELECTRON_VERSION
\   COL                 The dash as a mode 4 character row byte
ELIF _6502SP_VERSION
\   COL                 The colour of the dot as a mode 2 character row byte
ENDIF
\
\ ******************************************************************************

.CPIX4

 JSR CPIX2              \ Call CPIX2 to draw a single-height dash at (X1, Y1)

 DEC Y1                 \ Decrement Y1

                        \ Fall through into CPIX2 to draw a second single-height
                        \ dash on the pixel row above the first one, to create a
                        \ double-height dot

