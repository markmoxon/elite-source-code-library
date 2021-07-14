\ ******************************************************************************
\
\       Name: DOENTRY
\       Type: Subroutine
\   Category: Loader
\    Summary: Initialise the encyclopedia and show the menu screen
\
\ ******************************************************************************

.DOENTRY

 JSR BRKBK              \ Set the standard BRKV handler for the game

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP BAY                \ Go to the docking bay (i.e. show the Encyclopedia
                        \ screen)

