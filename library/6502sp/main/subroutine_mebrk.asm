\ ******************************************************************************
\       Name: MEBRK
\ ******************************************************************************

.MEBRK

 LDX stack
 TXS
 JSR backtonormal
 TAY
 LDA #7

.MEBRKL

 JSR OSWRCH
 INY
 BEQ retry
 LDA (&FD),Y
 BNE MEBRKL
 BEQ retry

