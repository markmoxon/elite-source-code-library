\ ******************************************************************************
\
\       Name: SCRAM
\       Type: Subroutine
\   Category: Loader
\    Summary: Decrypt the main docked code, reset the flight variables and start
\             the game
\
\ ******************************************************************************

.SCRAM

 JSR scramble           \ Decrypt the main docked code between &1300 and &5FFF

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP TT170              \ Jump to TT170 to start the game

