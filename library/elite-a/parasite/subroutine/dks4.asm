\ ******************************************************************************
\
\       Name: DKS4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for a particular key press by sending a scan_xin command to
\             the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The internal number of the key to check
\
\ Returns:
\
\   A                   If the key is being pressed, A contains the original
\                       key number in X but with bit 7 set (i.e. key number +
\                       128). If the key is not being pressed, A contains the
\                       unchanged key number
\
\ ******************************************************************************

.DKS4

 LDA #&8B               \ Send command &8B to the I/O processor:
 JSR tube_write         \
                        \   =scan_xin(key_number)
                        \
                        \ which will scan the keyboard for the specified
                        \ internal key number

 TXA                    \ Send the parameter to the I/O processor:
 JSR tube_write         \
                        \   * key_number = X

 JSR tube_read          \ Set A to the response from the I/O processor, which
                        \ will contain the key number with bit 7 set if the key
                        \ is being pressed, or bit 7 clear if it isn't

 TAX                    \ Copy the response into X

 RTS                    \ Return from the subroutine

