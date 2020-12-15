\ ******************************************************************************
\
\       Name: SPBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the space station indicator ("S") on the dashboard by
\             sending a #DOBULB 0 command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This draws (or erases) the space station indicator bulb ("S") on the
\ dashboard.
\
\ ******************************************************************************

.SPBLB

 LDA #DOBULB            \ Send a #DOBULB 0 command to the I/O processor to
 JSR OSWRCH             \ tell it to draw the E.C.M. indicator bulb on the
 LDA #0                 \ dashboard, and return from the subroutine using a tail
 JMP OSWRCH             \ call

