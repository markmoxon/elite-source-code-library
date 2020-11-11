\ ******************************************************************************
\       Name: NWOSWD
\ ******************************************************************************

.NWOSWD

 BIT svn
 BMI notours
 CMP #240
 BCC notours
 STX OSSC
 STY OSSC+1
 PHA
 SBC #240
 ASL A
 TAX
 LDA OSWVECS,X
 STA JSRV+1
 LDA OSWVECS+1,X
 STA JSRV+2
 LDX OSSC

.JSRV

 JSR &FFFC \Poked over
 PLA
 LDX OSSC
 LDY OSSC+1

.SAFE

 RTS

