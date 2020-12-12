\ ******************************************************************************
\       Name: DET1
\ by sending a #DODIALS command to the I/O processor
\ ******************************************************************************

.DET1

 LDA #DODIALS
 JSR OSWRCH
 TXA
 JMP OSWRCH

