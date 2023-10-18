\ ******************************************************************************
\
\       Name: ResetToStartScreen
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the stack and the game's variables and show the Start screen
\
\ ******************************************************************************

.ResetToStartScreen

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR ResetVariables     \ Reset all the RAM (in both the NES and cartridge), as
                        \ it is in an undefined state when the NES is switched
                        \ on, initialise all the game's variables, and switch to
                        \ ROM bank 0

 JMP ShowStartScreen    \ Jump to ShowStartScreen in bank 0 to show the start
                        \ screen and start the game

