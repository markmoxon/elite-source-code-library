\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: Missions
\    Summary: Change to the text view for the Constrictor mission briefing
\
\ ******************************************************************************

.PAS1

 LDA #1                 \ Jump to TT66 to clear the screen and set the current
 JMP TT66               \ view type to 1, for the mission briefing screen, and
                        \ return from the subroutine using a tail call

