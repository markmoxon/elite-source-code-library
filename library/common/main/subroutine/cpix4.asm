\ ******************************************************************************
\
\       Name: CPIX4
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a double-height dot on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Draw a double-height mode 5 dot (2 pixels high, 2 pixels wide).
\
\ Arguments:
\
\   X1                  The screen pixel x-coordinate of the bottom-left corner
\                       of the dot
\
\   Y1                  The screen pixel y-coordinate of the bottom-left corner
\                       of the dot
\
\   COL                 The colour of the dot as a mode 5 character row byte
\
\ ******************************************************************************

.CPIX4

 JSR CPIX2              \ Call CPIX2 to draw a single-height dash at (X1, Y1)

 DEC Y1                 \ Decrement Y1

                        \ Fall through into CPIX2 to draw a second single-height
                        \ dash on the pixel row above the first one, to create a
                        \ double-height dot

