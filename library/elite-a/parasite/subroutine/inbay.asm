\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
\    Summary: Restart the game upon death
\
\ ******************************************************************************

.INBAY

 LDA #0                 \ Set save_lock to 0 to indicate there are no unsaved
 STA save_lock          \ changes in the commander file

 STA dockedp            \ Set dockedp to 0 to indicate that we are docked

 JSR BRKBK              \ Call BRKBK to set BRKV to point to the BRBR routine

 JSR RES2               \ Reset a number of flight variables and workspaces

 JMP BR1                \ Jump to BR1 to restart the game

