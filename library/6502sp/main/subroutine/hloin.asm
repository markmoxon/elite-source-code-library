\ ******************************************************************************
\       Name: HLOIN
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

.HBFL

 LDA HBUP
 STA HBUF
 CMP #2
 BEQ HBZE2
 LDA #2
 STA HBUP
 LDA #247
 LDX #(HBUF MOD256)
 LDY #(HBUF DIV256)
 JSR OSWORD

.HBZE2

 LDY T1
 RTS

.HBZE

 LDA #2
 STA HBUP
 RTS

