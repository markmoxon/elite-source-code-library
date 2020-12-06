\ ******************************************************************************
\       Name: LL30
\ ******************************************************************************

.LL30

 LDA #&81
 JSR OSWRCH
 LDA #5
 JSR OSWRCH
 LDA X1
 JSR OSWRCH
 LDA Y1
 JSR OSWRCH
 LDA X2
 JSR OSWRCH
 LDA Y2
 JMP OSWRCH

