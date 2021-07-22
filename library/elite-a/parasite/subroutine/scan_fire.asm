\ ******************************************************************************
\
\       Name: scan_fire
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Check whether the joystick's fire button is being pressed by
\             sending a scan_fire command to the I/O processor
\
\ ******************************************************************************

.scan_fire

 LDA #&89               \ Send command &89 to the I/O processor:
 JSR tube_write         \
                        \   =scan_fire()
                        \
                        \ which will check whether the fire button is being
                        \ pressed and return the result in bit 4 of the returned
                        \ value

 JMP tube_read          \ Set A to the response from the I/O processor, which
                        \ will have bit 4 clear if the fire button is being
                        \ pressed, or set if it isn't, and return from the
                        \ subroutine using a tail call

