\ ******************************************************************************
\       Name: CLYNS
\ ******************************************************************************

.CLYNS

 LDA #FF
 STA DTW2
 LDA #128
 STA QQ17
 LDA #21
 STA YC
 LDA #1
 STA XC
 LDA #clyns
 JSR OSWRCH
 JSR OSWRCH
 LDA #0
 TAY

.^SC5

 RTS
