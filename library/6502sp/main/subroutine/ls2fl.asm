\ ******************************************************************************
\
\       Name: LS2FL
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw the contents of the ball line heap by sending an OSWRCH 129
\             command to the I/O processor
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
 JSR OSWRCH             \ tell it to start drawing a new line. This means the
                        \ next byte we send to OSWRCH 

 TYA                    \ Transfer the Y counter into A

 BMI WP2                \ If the counter in A > 127, then jump to WP2, as we
                        \ need to send the points in two batches

 SEC                    \ Set A = (A * 2) + 1
 ROL A

 JSR OSWRCH             \ Send A 

                        \ We now want to send the points themselves to the I/O
                        \ processor

 LDY #0                 \ Set Y = 0 to act as a loop through the first T points

.WPL1

 LDA LSX2,Y             \ Send the x-coordinate of the start of the line segment
 JSR OSWRCH

 LDA LSY2,Y             \ Send the y-coordinate of the start of the line segment
 JSR OSWRCH

 INY

 LDA LSX2,Y             \ Send the x-coordinate of the end of the line segment
 JSR OSWRCH

 LDA LSY2,Y             \ Send the y-coordinate of the end of the line segment
 JSR OSWRCH

 INY

 CPY T
 BCC WPL1

.WP1

 RTS                    \ Return from the subroutine

.WP2

                        \ If we get here then there are more than 127 points in
                        \ the line heap to send to the I/O processor

 ASL A                  \ Set A = A * 2 + 4
 ADC #4

 JSR OSWRCH             \ Send A

 LDY #126               \ Call WPL1 above to send the first 127 points to the
 JSR WPL1               \ I/O processor

 LDY #126               \ Jump to WP3 above to send the rest of the points
 JMP WP3

