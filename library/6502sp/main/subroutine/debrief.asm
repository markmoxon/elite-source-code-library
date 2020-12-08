\ ******************************************************************************
\       Name: DEBRIEF
\ ******************************************************************************

.DEBRIEF

 LSR TP                 \ Clear bit 0 of TP to indicate that mission 1 is no
 ASL TP                 \ longer in progress, as we have completed it

 INC TALLY+1            \ Award a single kill for the Constrictor

 LDX #LO(50000)
 LDY #HI(50000)
 JSR MCASH

 LDA #15

.BRPS

 BNE BRP

