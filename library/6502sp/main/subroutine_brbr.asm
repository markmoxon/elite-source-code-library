\ ******************************************************************************
\       Name: BRBR
\ ******************************************************************************

.BRBR

 DEC brkd
 LDX #&FF
 TXS
 JSR backtonormal
 TAY
 LDA #7

.BRBRLOOP

 JSR OSWRCH
 INY
 LDA (&FD),Y
 BNE BRBRLOOP
 JMP BR1

