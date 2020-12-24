\ ******************************************************************************
\
\       Name: LBFL
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the lines in the multi-segment line buffer by sending an
\             OSWRCH 129 command to the I/O processor
\
\ ******************************************************************************

.LBFL

 LDY LBUP               \ Set Y to LBUP, the size of the multi-segment line
                        \ buffer

 BEQ LBZE2              \ If LBUP = 0 then jump to LBZE2 as there is no line
                        \ data to transmit to the I/O processor

 INY                    \ Increment Y, as we need to send the number of points
                        \ in the new line, plus 1, to OSWRCH 129

 LDA #129               \ Send an OSWRCH 129 command to the I/O processor to
 JSR OSWRCH             \ tell it to start receiving a new line to draw. The
                        \ parameter to this call needs to contain the number of
                        \ bytes we are going to send for the line's coordinates,
                        \ plus 1, so let's calculate that now

 TYA                    \ Transfer the Y counter into A, so A now contains the
                        \ number of bytes to send to the I/O processor, plus 1

 JSR OSWRCH             \ Send A to the I/O processor as the argument to the
                        \ OSWRCH 129 command, so the I/O processor can set the
                        \ LINMAX variable in the BEGINLIN routine

 LDY #0                 \ Set Y = 0 to act as a loop through the points in LBUF

.LBFLL

 LDA LBUF,Y             \ Send the Y-th byte of LBUF to the I/O processor
 JSR OSWRCH

 INY                    \ Increment the pointer to point to the next coordinate

 CPY LBUP               \ If Y < LBUP then loop back to send the next byte,
 BNE LBFLL              \ until we have sent them all. The I/O processor will
                        \ now draw the line

.LBZE2

 STZ LBUP               \ Set LBUP = 0 to reset the line buffer

 LDY T1                 \ Restore the value of Y from T1, so it is preserved

 RTS                    \ Return from the subroutine

