\ ******************************************************************************
\       Name: PIXEL3
\ ******************************************************************************

.PIXEL3

 STY T1
 LDY PBUP
 STA PBUF+2,Y
 TXA
 STA PBUF+1,Y
 LDA ZZ
 ORA #1
 STA PBUF,Y
 TYA
 CLC
 ADC #3
 STA PBUP
 BMI PBFL
 LDY T1
 RTS

