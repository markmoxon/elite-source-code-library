\ ******************************************************************************
\
\       Name: SCRAM
\       Type: Subroutine
\   Category: Loader
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)
\    Summary: Decrypt the main docked code, reset the flight variables and start
\             the game
ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
\    Summary: Set the save_lock variable and break handler
ENDIF
\
IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Set the save_lock flag to this value
ENDIF
\ ******************************************************************************

.SCRAM

IF _DISC_DOCKED

 JSR scramble           \ Decrypt the main docked code between &1300 and &5FFF

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP TT170              \ Jump to TT170 to start the game

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STA save_lock          \ Set the save_lock variable to the value in A

                        \ Fall through into BRKBK to set the standard BRKV
                        \ handler for the game and return from the subroutine

ENDIF

