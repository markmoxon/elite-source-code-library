\ ******************************************************************************
\
\       Name: LL30
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a one-segment line by sending a draw_line command to the I/O
\             processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   Y1                  The screen y-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y2                  The screen y-coordinate of the end of the line
\
\ ******************************************************************************

.LOIN
.LL30

 LDA #&80               \ Send command &80 to the I/O processor:
 JSR tube_write         \
                        \   draw_line(x1, y1, x2, y2)
                        \
                        \ which will draw a line from (x1, y1) to (x2, y2)

 LDA X1                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x1 = X1

 LDA Y1                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y1 = Y1

 LDA X2                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x2 = X2

 LDA Y2                 \ Send the first parameter to the I/O processor:
 JMP tube_write         \
                        \   * y2 = Y2
                        \
                        \ and return from the subroutine using a tail call

