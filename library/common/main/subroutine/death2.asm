\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ******************************************************************************

.DEATH2

IF _6502SP_VERSION

 LDX #&FF               \ Reset the 6502 stack pointer, which clears the stack
 TXS

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

