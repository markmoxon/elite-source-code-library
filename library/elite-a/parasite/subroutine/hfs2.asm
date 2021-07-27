\ ******************************************************************************
\
\       Name: HFS2
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Clear the screen and draw the launch or hyperspace tunnel
\
\ ******************************************************************************

.HFS2

 STA STP                \ Store the step size in A

 JSR TTX66              \ Clear the screen and draw a white border

 JMP HFS1               \ Jump to HFS1 to draw the launch or hyperspace tunnel

