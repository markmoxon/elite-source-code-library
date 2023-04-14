\ ******************************************************************************
\
\       Name: DOBEGIN
\       Type: Subroutine
\   Category: Loader
IF NOT(_ELITE_A_DOCKED)
\    Summary: Decrypt the main docked code, initialise the configuration
\             variables and start the game
ELIF _ELITE_A_DOCKED
\    Summary: Initialise the configuration variables and start the game
ENDIF
\
\ ******************************************************************************

.DOBEGIN

IF NOT(_ELITE_A_DOCKED)

 JSR DEEOR              \ Decrypt the main docked code between &1300 and &5FFF

ELIF _ELITE_A_DOCKED

 LDA #0                 \ Call SCRAM to set save_lock to 0 (i.e. this is a new
 JSR SCRAM              \ game) and set the break handler

ENDIF

 JMP BEGIN              \ Jump to BEGIN to initialise the configuration
                        \ variables and start the game

