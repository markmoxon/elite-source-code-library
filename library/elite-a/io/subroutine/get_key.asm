\ ******************************************************************************
\
\       Name: get_key
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard until a key is pressed and send the key's ASCII
\             code to the parasite
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard until a key is pressed, and return the key's ASCII code.
\ If, on entry, a key is already being held down, then wait until that key is
\ released first (so this routine detects the first key down event following
\ the subroutine call).
\
\ ******************************************************************************

.get_key

 JSR WSCAN              \ Call WSCAN twice to wait for two vertical syncs
 JSR WSCAN

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press)

 BNE get_key            \ If a key was already being held down when we entered
                        \ this routine, keep looping back up to get_key, until
                        \ the key is released

.press

 JSR RDKEY              \ Any pre-existing key press is now gone, so we can
                        \ start scanning the keyboard again, returning the
                        \ internal key number in X (or 0 for no key press)

 BEQ press              \ Keep looping up to press until a key is pressed

 TAY                    \ Copy A to Y, so Y contains the internal key number
                        \ of the key pressed

 LDA (key_tube),Y       \ The address in key_tube points to the MOS key
                        \ translation table in the I/O processor, which is used
                        \ to translate internal key numbers to ASCII, so this
                        \ fetches the key's ASCII code into A

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

