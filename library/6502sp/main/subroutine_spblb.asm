\ ******************************************************************************
\
\       Name: SPBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the space station indicator ("S") on the dashboard
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

