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
\   A                   Set the save_lock flag as follows:
\
\                         * 0 = this is a new game, so there are no unsaved
\                               changes in the commander file
\
\                         * &FF = we just docked, so there are unsaved changes
\                                 in the commander file
\
ENDIF
\ ******************************************************************************

.SCRAM

IF _DISC_DOCKED

 JSR DEEOR              \ Decrypt the main docked code between &1300 and &5FFF

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP TT170              \ Jump to TT170 to start the game

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STA save_lock          \ Set the save_lock variable to the value in A (which
                        \ will be either 0 or &FF)

                        \ Fall through into BRKBK to set the standard BRKV
                        \ handler for the game and return from the subroutine

ENDIF

