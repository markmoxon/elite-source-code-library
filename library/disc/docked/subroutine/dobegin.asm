\ ******************************************************************************
\
\       Name: DOBEGIN
\       Type: Subroutine
\   Category: Loader
\    Summary: Decrypt the main docked code, initialise the configuration
\             variables and start the game
\
\ ******************************************************************************

.DOBEGIN

IF NOT(_ELITE_A_DOCKED)

 JSR scramble           \ Decrypt the main docked code between &1300 and &5FFF

ELIF _ELITE_A_DOCKED

 LDA #0                 \ AJD

 JSR SCRAM

ENDIF

 JMP BEGIN              \ Jump to BEGIN to initialise the configuration
                        \ variables and start the game

