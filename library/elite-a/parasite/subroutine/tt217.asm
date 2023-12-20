\ ******************************************************************************
\
\       Name: TT217
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard until a key is pressed by sending a get_key
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard until a key is pressed, and return the key's ASCII code.
\ If, on entry, a key is already being held down, then wait until that key is
\ released first (so this routine detects the first key down event following
\ the subroutine call).
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The ASCII code of the key that was pressed
\
\   A                   Contains the same as X
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   out                 Contains an RTS
\
\ ******************************************************************************

.TT217

.t

 LDA #&8D               \ Send command &8D to the I/O processor:
 JSR tube_write         \
                        \   =get_key()
                        \
                        \ which waits for any current key presses to be released
                        \ (if any), and then waits for a key to be pressed
                        \ before returning the result as an ASCII value

 JSR tube_read          \ Set A to the response from the I/O processor, which
                        \ will contain the ASCII value of the key press

 TAX                    \ Copy the response into X

.out

 RTS                    \ Return from the subroutine

