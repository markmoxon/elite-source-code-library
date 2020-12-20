\ \ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: 
\
\ ******************************************************************************

.HLOIN

 STY T1
 LDY HBUP
 LDA X1
 STA HBUF,Y
 LDA X2
 STA HBUF+1,Y
 LDA Y1
 STA HBUF+2,Y
 TYA
 CLC
 ADC #3
 STA HBUP
 BMI HBFL
 LDY T1
 RTS

