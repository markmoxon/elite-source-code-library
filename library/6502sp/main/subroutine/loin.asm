\ ******************************************************************************
\       Name: LOIN
\ ******************************************************************************

.LOIN

 STY T1
 LDY LBUP
 LDA X1
 STA LBUF,Y
 LDA Y1
 STA LBUF+1,Y
 LDA X2
 STA LBUF+2,Y
 LDA Y2
 STA LBUF+3,Y
 TYA
 CLC
 ADC #4
 STA LBUP
 CMP #250
 BCS LBFL
 LDY T1
 RTS

.LBFL

 LDY LBUP
 BEQ LBZE2
 INY
 LDA #&81
 JSR OSWRCH
 TYA
 JSR OSWRCH
 LDY #0

.LBFLL

 LDA LBUF,Y
 JSR OSWRCH
 INY
 CPY LBUP
 BNE LBFLL

.LBZE2

 STZ LBUP \++
 LDY T1
 RTS

