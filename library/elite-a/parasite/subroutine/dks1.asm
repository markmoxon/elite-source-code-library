\ ******************************************************************************
\
\       Name: DKS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard or joystick for a flight key by sending a scan_y
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard for the flight key given in register Y, where Y is the
\ offset into the KYTB table above (so we can scan for Space by setting Y to
\ 2, for example). If the key is pressed, set the corresponding byte in the
\ key logger at KL to a negative value (i.e. with bit 7 set).
\
\ Arguments:
\
\   Y                   The offset into the KYTB table above of the key that we
\                       want to scan on the keyboard
\
\ Other entry points:
\
\   b_quit              Contains an RTS
\
\ ******************************************************************************

.DKS1

 LDA #&96               \ Send command &96 to the I/O processor:
 JSR tube_write         \
                        \   =scan_y(key_offset, delta_14b)
                        \
                        \ which will update the roll or pitch dashboard
                        \ indicator to the specified value

 TYA                    \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * key_offset = Y

 LDA BSTK               \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * delta14b = BTSK

 JSR tube_read          \ Set A to the response from the I/O processor, which
                        \ will be the key number, but with bit 7 clear if the
                        \ key is not being pressed, or bit 7 set if it is being
                        \ pressed

 BPL b_quit             \ If the response is positive (i.e. bit 7 is clear) then
                        \ the key is not being pressed, so skip the following
                        \ instruction

 STA KL,Y               \ The response is negative, so store this in the Y-th
                        \ byte of the key logger at KL to indicate that the key
                        \ is being pressed

.b_quit

 RTS                    \ Return from the subroutine

