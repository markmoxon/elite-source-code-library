\ ******************************************************************************
\       Name: GRIDSET
\ ******************************************************************************

.GRIDSET

 STX GSL1+1
 STY GSL1+2
 LDA #254
 STA YP
 LDY #0
 LDX #0
 STX XP

.GSL1

 LDA P%,Y
 BEQ GRSEX
 STY T
 SEC
 SBC #44
 STA S
 ASL A
 ASL A
 ADC S
 TAY
 LDA LTDEF,Y
 JSR GRS1
 LDA LTDEF+1,Y
 JSR GRS1
 LDA LTDEF+2,Y
 JSR GRS1
 LDA LTDEF+3,Y
 JSR GRS1
 LDA LTDEF+4,Y
 JSR GRS1
 LDY T
 INY
 LDA XP
 CLC
 ADC #W2
 STA XP
 BCC GSL1
 LDA #0
 STA XP
 LDA YP
 SBC #W2Y
 STA YP
 JMP GSL1

.GRSEX

 LDA #0
 STA Y1TB,X
 RTS

.GRS1

 BEQ GRR1
 STA R
 AND #15
 STY P
 TAY
 LDA NOFX,Y
 CLC
 ADC XP
 STA X1TB,X
 LDA YP
 SEC
 SBC NOFY,Y
 STA Y1TB,X
 LDA R
 LSR A
 LSR A
 LSR A
 LSR A
 TAY
 LDA NOFX,Y
 CLC
 ADC XP
 STA X2TB,X
 LDA YP
 SEC
 SBC NOFY,Y
 STA Y2TB,X
 INX
 LDY P

.GRR1

 RTS

