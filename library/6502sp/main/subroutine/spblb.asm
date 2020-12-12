\ ******************************************************************************
\
\       Name: SPBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the space station indicator ("S") on the dashboard by
\             sending a #DOBULB command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This draws (or erases) the space station indicator bulb ("S") on the
\ dashboard.
\
\ ******************************************************************************

.SPBLB

 LDA #DOBULB
 JSR OSWRCH
 LDA #0
 JMP OSWRCH

