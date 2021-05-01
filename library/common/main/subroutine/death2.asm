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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION

.DEATH2

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

.DEATH2

ENDIF

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

ELIF _EXECUTIVE

 JSR RESET              \ ???

.DEATH2                 \ ???

ENDIF

ENDIF

IF _DISC_FLIGHT \ Platform

 JSR CATD               \ Call CATD to reload the disc catalogue

 BNE INBAY              \ Jump to INBAY to load the docked code (this BNE is
                        \ effectively a JMP)

ENDIF

