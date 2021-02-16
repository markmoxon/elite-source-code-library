\ ******************************************************************************
\
\       Name: LL30
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a one-segment line by sending an OSWRCH 129 command to the
\             I/O processor
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

.LL30

 LDA #129               \ Send an OSWRCH 129 command to the I/O processor to
 JSR OSWRCH             \ tell it to start receiving a new line to draw. The
                        \ parameter to this call needs to contain the number of
                        \ bytes we are going to send for the line's coordinates,
                        \ plus 1, which we send next

 LDA #5                 \ Send 5 to the I/O processor as the argument to the
 JSR OSWRCH             \ OSWRCH 129 command, so the I/O processor should expect
                        \ 4 bytes (as we send the count plus 1)

 LDA X1                 \ Send X1, Y1, X2 and Y2 to the I/O processor, so the
 JSR OSWRCH             \ I/O processor will draw a line from (X1, Y1) to
 LDA Y1                 \ (X2, Y2), returning from the subroutine using a tail
 JSR OSWRCH             \ call
 LDA X2
 JSR OSWRCH
 LDA Y2
 JMP OSWRCH

