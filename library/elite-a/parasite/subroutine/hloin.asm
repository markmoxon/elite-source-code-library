\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line by sending a draw_hline command to the I/O
\             processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y1                  The screen y-coordinate of the line
\
\ ******************************************************************************

.HLOIN

 LDA #&81               \ Send command &81 to the I/O processor:
 JSR tube_write         \
                        \   draw_hline(x1, y1, x2)
                        \
                        \ which will draw a horizontal line from (x1, y1) to
                        \ (x2, y1)

 LDA X1                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x1 = X1

 LDA Y1                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y1 = Y1

 LDA X2                 \ Send the first parameter to the I/O processor:
 JMP tube_write         \
                        \   * x2 = X2
                        \
                        \ and return from the subroutine using a tail call

