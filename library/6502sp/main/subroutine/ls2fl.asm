\ ******************************************************************************
\
\       Name: LS2FL
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw the contents of the ball line heap by sending an OSWRCH 129
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ If there are too many points for one batch of OSWRCH 129 calls, the line is
\ split into two batches, with the last coordinate of the first batch being
\ duplicated as the first coordinate of the second batch, so the two lines join
\ up to make a complete circle.
\
\ ******************************************************************************

.LS2FL

 LDY LSP                \ Set Y to the ball line heap pointer, which contains
                        \ the number of the first free byte after the end of the
                        \ LSX2 and LSY2 heaps - in other words, the number of
                        \ points in the ball line heap

                        \ We now loop through the ball line heap using Y as a
                        \ pointer

.WP3

 STY T                  \ Set T = the number of points in the heap

 BEQ WP1                \ If there are no points in the heap, jump down to WP1
                        \ to return from the subroutine

 LDA #129               \ Send an OSWRCH 129 command to the I/O processor to
 JSR OSWRCH             \ tell it to start receiving a new line to draw. The
                        \ parameter to this call needs to contain the number of
                        \ bytes we are going to send for the line's coordinates,
                        \ so let's calculate that now

 TYA                    \ Transfer the Y counter into A, so A now contains the
                        \ number of coordinates to send to the I/O processor

 BMI WP2                \ If the counter in A > 127, then jump to WP2, as we
                        \ need to send the points in two batches (as the line
                        \ buffer in the I/O processor can hold 256 bytes, and
                        \ each coordinate occupies two bytes)

 SEC                    \ Set A = (A * 2) + 1
 ROL A                  \
                        \ so A now contains the number of bytes we are going to
                        \ send, plus 1 (the extra 1 is required as the value
                        \ sent needs to point to the first free byte after the
                        \ end of the byte list)

 JSR OSWRCH             \ Send A to the I/O processor as the argument to the
                        \ OSWRCH 129 command, so the I/O processor can set the
                        \ LINMAX variable in the BEGINLIN routine

                        \ We now want to send the points themselves to the I/O
                        \ processor

 LDY #0                 \ Set Y = 0 to act as a loop through the first T points

.WPL1

 LDA LSX2,Y             \ Send the x-coordinate of the start of the line segment
 JSR OSWRCH

 LDA LSY2,Y             \ Send the y-coordinate of the start of the line segment
 JSR OSWRCH

 INY                    \ Increment the pointer to point to the next coordinate

 LDA LSX2,Y             \ Send the x-coordinate of the end of the line segment
 JSR OSWRCH

 LDA LSY2,Y             \ Send the y-coordinate of the end of the line segment
 JSR OSWRCH

 INY                    \ Increment the pointer to point to the next coordinate

 CPY T                  \ If Y < T then loop back to send the next coordinate,
 BCC WPL1               \ until we have sent them all. The I/O processor will
                        \ now draw the line

.WP1

 RTS                    \ Return from the subroutine

.WP2

                        \ If we get here then there are more than 127 points in
                        \ the line heap to send to the I/O processor, so we need
                        \ to send them in two batches. We start by sending the
                        \ second half of the coordinates, making sure we include
                        \ the last coordinate from the first batch to make sure
                        \ the circles drawn by each batch join up

 ASL A                  \ Shift A left, shifting bit 7 (which we know is set)
                        \ into the C flag, so this sets:
                        \
                        \   A = (A * 2) mod 256
                        \
                        \ So A contains the number of bytes left over in the
                        \ second batch if we send a full first batch

 ADC #4                 \ Set A = A + 4 + C
                        \       = A + 4 + 1
                        \
                        \ so A now contains the number of bytes we are going to
                        \ send in each batch, plus 4 (because we need to send
                        \ the extra coordinate at the start of the second
                        \ batch), plus 1 (the extra 1 is required as the value
                        \ sent needs to point to the first free byte after the
                        \ end of the byte list)

 JSR OSWRCH             \ Send A to the I/O processor as the argument to the
                        \ OSWRCH 129 command, so the I/O processor can set the
                        \ LINMAX variable in the BEGINLIN routine

 LDY #126               \ Call WPL1 above with Y = 126 to send the second batch
 JSR WPL1               \ of points from the ball line heap to the I/O
                        \ processor, starting from the last coordinate of the
                        \ first batch, so that gets sent in both batches (this
                        \ is why Y = 126 rather than 127)

 LDY #126               \ Jump to WP3 above to send a whole new OSWRCH 129
 JMP WP3                \ command to draw the first batch of points

