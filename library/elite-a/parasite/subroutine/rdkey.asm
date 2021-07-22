\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for key presses by sending a scan_10in command
\             to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\   A                   Contains the same as X
\
\ ******************************************************************************

.RDKEY

 LDA #&8C               \ Send command &8C to the I/O processor:
 JSR tube_write         \
                        \   =scan_10in()
                        \
                        \ which will scan the keyboard

 JSR tube_read          \ Set A to the response from the I/O processor, which
                        \ will either be the internal key number of the key being
                        \ pressed, or 0 if no key is being pressed

 TAX                    \ Copy the response into X

 RTS                    \ Return from the subroutine

