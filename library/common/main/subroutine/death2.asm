\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ******************************************************************************

.DEATH2

IF _6502SP_VERSION \ Platform

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

IF _DISC_FLIGHT \ Platform

 JSR CATD               \ Call CATD to reload the disc catalogue

 BNE INBAY              \ Jump to INBAY to load the docked code (this BNE is
                        \ effectively a JMP)

ENDIF

