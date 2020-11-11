\ ******************************************************************************
\       Name: PIXEL
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

.^PX4

 RTS

.^PBFL

 LDA PBUP
 STA pixbl
 CMP #2
 BEQ PBZE2
 LDA #2
 STA PBUP
 LDA #DUST
 JSR DOCOL
 LDA #241
 LDX #(pixbl MOD256)
 LDY #(pixbl DIV256)
 JSR OSWORD

.PBZE2

 LDY T1
 RTS

.^PBZE

 LDA #2
 STA PBUP
 RTS

