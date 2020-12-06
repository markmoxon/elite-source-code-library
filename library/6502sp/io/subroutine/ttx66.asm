\ ******************************************************************************
\       Name: TTX66
\ ******************************************************************************

.TTX66

 LDX #&40

.BOL1

 JSR ZES1
 INX
 CPX #&70
 BNE BOL1

.BOX

 LDA #&F
 STA COL
 LDY #1
 STY YC
 LDY #11
 STY XC
 LDX #0
 STX X1
 STX Y1
 STX Y2
\STXQQ17
 DEX
 STX X2
 JSR LOIN
 LDA #2
 STA X1
 STA X2
 JSR BOS2

.BOS2

 JSR BOS1

.BOS1

 LDA #0
 STA Y1
 LDA #2*Y-1
 STA Y2
 DEC X1
 DEC X2
 JSR LOIN
 LDA #&F
 STA &4000
 STA &41F8
 RTS

