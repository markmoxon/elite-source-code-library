\ ******************************************************************************
\
\       Name: DEATH2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most of the game and restart from the title screen
\
\ ------------------------------------------------------------------------------
\
\ This routine is called following death, and when the game is quit by pressing
\ ESCAPE when paused.
\
\ ******************************************************************************

.DEATH2

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

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

ELIF _ELITE_A_FLIGHT

 BMI INBAY              \ Jump to INBAY to load the docked code (this BMI is
                        \ effectively a JMP)

ELIF _ELITE_A_6502SP_PARA

 JMP INBAY              \ Jump to INBAY to restart the game following death

ENDIF

