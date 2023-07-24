\ ******************************************************************************
\
\       Name: CPIX2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a single-height dash on the dashboard by sending a draw_blob
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen pixel x-coordinate of the dash
\
\   Y1                  The screen pixel y-coordinate of the dash
\
\   COL                 The colour of the dash as a mode 5 character row byte
\
\ ******************************************************************************

.CPIX2

 LDA #&90               \ Send command &90 to the I/O processor:
 JSR tube_write         \
                        \   draw_blob(x, y, colour)
                        \
                        \ which will draw a dash of the specified colour and
                        \ position on the dashboard

 LDA X1                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x = X1

 LDA Y1                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y = Y1

 LDA COL                \ Send the third parameter to the I/O processor:
 JMP tube_write         \
                        \   * colour = COL
                        \
                        \ and return from the subroutine using a tail call

