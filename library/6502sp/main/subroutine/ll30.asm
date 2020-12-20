\ ******************************************************************************
\
\       Name: LL30
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a line by sending an OSWRCH 129 command to the I/O processor
\
\ ******************************************************************************

.LL30

 LDA #129
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

