\ ******************************************************************************
\
\       Name: StartGame
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the stack and game variables, and start the game by going to
\             the docking bay
\
\ ******************************************************************************

.StartGame

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR BR1                \ Reset a number of variables, ready to start a new game

                        \ Fall through into the BAY routine to go to the docking
                        \ bay (i.e. show the Status Mode screen)

