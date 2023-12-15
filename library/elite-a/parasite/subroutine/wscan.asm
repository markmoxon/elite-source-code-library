\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Wait for the vertical sync by sending a sync_in command to the I/O
\             processor
\
\ ******************************************************************************

.WSCAN

 LDA #&85               \ Send command &86 to the I/O processor:
 JSR tube_write         \
                        \   =sync_in()
                        \
                        \ which will wait until the vertical sync before
                        \ returning control to the parasite

 JMP tube_read          \ Set A to the response from the I/O processor, which
                        \ will be sent when the vertical sync occurs (it doesn't
                        \ matter what the value is), and return from the
                        \ subroutine using a tail call

