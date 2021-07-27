\ ******************************************************************************
\
\       Name: Main game loop for flight (Part 6 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Process non-flight key presses (red function keys, docked keys)
\
\ ******************************************************************************

.FRCE_FLIGHT

 PHA                    \ Store the key to "press" in A on the stack

 LDA QQ22+1             \ Fetch QQ22+1, which contains the number that's shown
                        \ on-screen during hyperspace countdown

 BNE d_locked           \ If the hyperspace countdown is non-zero, jump to
                        \ d_locked so the key does not get "pressed"

 PLA                    \ Retrieve the key to "press" from the stack into A so
                        \ we can now process it

 JSR TT102              \ Call TT102 to process the key pressed in A

 JMP TT100_FLIGHT       \ Otherwise jump to TT100_FLIGHT to restart the main
                        \ loop from the start

.d_locked

 PLA                    \ Retrieve the key to "press" from the stack into A

 JSR TT107              \ Call TT107 to progress the countdown of the hyperspace
                        \ counter

 JMP TT100_FLIGHT       \ Jump to TT100_FLIGHT to restart the main loop from
                        \ the start

