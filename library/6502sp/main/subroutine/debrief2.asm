\ ******************************************************************************
\       Name: DEBRIEF2
\ ******************************************************************************

.DEBRIEF2

 LDA TP                 \ Set bit 2 of TP to indicate mission 2 is in progress
 ORA #%00000100
 STA TP

 LDA #2
 STA ENGY
 INC TALLY+1
 LDA #223
 BNE BRP

