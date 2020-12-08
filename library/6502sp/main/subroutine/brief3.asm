\ ******************************************************************************
\       Name: BRIEF3
\ ******************************************************************************

.BRIEF3

 LDA TP                 \ Set bits 1 and 3 of TP to indicate that both missions
 AND #%11110000         \ are now complete, and clear bits 0 and 2 to indicate
 ORA #%00001010         \ that neither of them are in progress
 STA TP

 LDA #222
 BNE BRP

