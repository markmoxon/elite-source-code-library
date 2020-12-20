\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: 
\
\ ******************************************************************************

.PIXEL

 STY T1
 LDY PBUP
 STA PBUF+2,Y
 TXA
 STA PBUF+1,Y
 LDA ZZ
 AND #&F8
 STA PBUF,Y
 TYA
 CLC
 ADC #3
 STA PBUP
 BMI PBFL
 LDY T1

.PX4

 RTS

