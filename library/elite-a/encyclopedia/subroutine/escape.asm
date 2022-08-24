\ ******************************************************************************
\
\       Name: escape
\       Type: Subroutine
\   Category: Start and end
\    Summary: Load the main docked code so that it shows the docking tunnel
\
\ ******************************************************************************

.escape

 LDA #0                 \ Set the value of KL+1 to 0, so when the main docked
 STA KL+1               \ loads, we show the docking tunnel and ship hangar

 JMP INBAY              \ Jump to INBAY to load the main docked code

