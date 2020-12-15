\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the E.C.M. indicator bulb ("E") on the dashboard by
\             sending a #DOBULB 255 command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This draws (or erases) the E.C.M. indicator bulb ("E") on the dashboard.
\
\ ******************************************************************************

.ECBLB

 LDA #DOBULB            \ Send a #DOBULB 255 command to the I/O processor to
 JSR OSWRCH             \ tell it to draw the E.C.M. indicator bulb on the
 LDA #255               \ dashboard, and return from the subroutine using a tail
 JMP OSWRCH             \ call

