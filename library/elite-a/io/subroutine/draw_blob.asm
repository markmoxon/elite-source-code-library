\ ******************************************************************************
\
\       Name: draw_blob
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Implement the draw_blob command (draw a single-height dash on the
\             dashboard)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a draw_blob command. It draws a
\ single-height dash on the dashboard.
\
\ ******************************************************************************

.draw_blob

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA X1                 \
 JSR tube_get           \   draw_blob(x, y, colour)
 STA Y1                 \
 JSR tube_get           \ and store them as follows:
 STA COL                \
                        \   * X1 = the dash's x-coordinate
                        \
                        \   * Y1 = the dash's y-coordinate
                        \
                        \   * COL = the dash's colour

                        \ Fall through into CPIX2 to draw a single-height dash
                        \ at the above coordinates and in the specified colour

