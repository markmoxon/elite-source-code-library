\ ******************************************************************************
\
\       Name: check_keys
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Wait until a key is pressed, quitting the game if the game is
\             paused and ESCAPE is pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   The key that was pressed, or 0 if we paused the game
\                       (COPY) and unpaused it again (DELETE)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   l_release           If a key is currently being pressed, wait until it is
\                       released
\
\ ******************************************************************************

.check_keys

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 CPX #&69               \ If COPY is not being pressed, jump to not_freeze to
 BNE not_freeze         \ return the key pressed in X

.freeze_loop

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 CPX #&70               \ If ESCAPE is not being pressed, jump to dont_quit to
 BNE dont_quit          \ skip the next

 JMP DEATH2             \ ESCAPE is being pressed, so jump to DEATH2 to end the
                        \ game

.dont_quit

\CPX #&37               \ These instructions are commented out in the original
\BNE dont_dump          \ source
\
\JSR printer
\
\.dont_dump

 CPX #&59               \ If DELETE is not being pressed, we are still paused,
 BNE freeze_loop        \ so loop back up to keep listening for configuration
                        \ keys, otherwise fall through into the rest of the
                        \ key detection code, which waits for the key to be
                        \ released before unpausing the game

.l_release

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in A and X (or 0 for no key press)

 BNE l_release          \ If a key is being pressed, loop back to l_release
                        \ until it is released

 LDX #0                 \ Set X = 0 to indicate no key is being pressed

.not_freeze

 RTS                    \ Return from the subroutine

