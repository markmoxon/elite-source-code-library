\ ******************************************************************************
\       Name: HAS1
\ ******************************************************************************

.HAS1

 JSR ZINF
 LDA XX15
 STA INWK+6
 LSR A
 ROR INWK+2
 LDA XX15+1
 STA INWK
 LSR A
 LDA #1
 ADC #0
 STA INWK+7
 LDA #128
 STA INWK+5
 STA RAT2
 LDA #&B
 STA INWK+34
 JSR DORND
 STA XSAV

.HAL5

 LDX #21
 LDY #9
 JSR MVS5
 LDX #23
 LDY #11
 JSR MVS5
 LDX #25
 LDY #13
 JSR MVS5
 DEC XSAV
 BNE HAL5
 LDY XX15+2
 BEQ HA1
 TYA
 ASL A
 TAX
 LDA XX21-2,X
 STA XX0
 LDA XX21-1,X
 STA XX0+1
 BEQ HA1
 LDY #1
 LDA (XX0),Y
 STA Q
 INY
 LDA (XX0),Y
 STA R
 JSR LL5
 LDA #100
 SBC Q
 LSR A
 STA INWK+3
 JSR TIDY
 JMP LL9

.UNWISE

.HA1

 RTS \tell LL30 swap EOR/ORA

