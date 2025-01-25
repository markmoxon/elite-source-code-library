\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Missions
\    Summary: Wait until a key is pressed for the Constrictor mission briefing
\             and then clear the text view to show the briefing text
\
\ ******************************************************************************

.PAUSE

 JSR PAUSE2             \ Call PAUSE2 to wait until a key is pressed, ignoring
                        \ any existing key press

