\ ******************************************************************************
\       Name: HBFL
\ by sending an OSWORD 247 command to the I/O processor
\ ******************************************************************************

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

