\ ******************************************************************************
\
\       Name: DET1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Show or hide the dashboard (for when we die) by sending a
\             write_crtc command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of text rows to display on the screen (24
\                       will hide the dashboard, 31 will make it reappear)
\
\ ******************************************************************************

.DET1

 LDA #&95               \ Send command &95 to the I/O processor:
 JSR tube_write         \
                        \   write_crtc(rows)
                        \
                        \ which will update the screen to show the specified
                        \ number of text rows

 TXA                    \ Send the parameter to the I/O processor:
 JMP tube_write         \
                        \   * rows = X
                        \
                        \ and return from the subroutine using a tail call

