\ ******************************************************************************
\       Name: KEYBOARD
\ ******************************************************************************

.KEYBOARD

 LDY #9

.DKL2

 LDA KYTB-2,Y
 DKS4
 ASL A
 LDA #0
 ADC #FF
 EOR #FF
 STA (OSSC),Y
 DEY
 CPY #2
 BNE DKL2 \-ve INKEY
 LDA #16
 SED

.DKL3

 DKS4
 TAX
 BMI DK1
 CLC
 ADC #1
 BPL DKL3

.DK1

 CLD
 EOR #128
 STA (OSSC),Y
 LDX #1
 LDA #&80
 JSR OSBYTE
 TYA
 LDY #10
 STA (OSSC),Y
 LDX #2
 LDA #&80
 JSR OSBYTE
 TYA
 LDY #11
 STA (OSSC),Y
 LDX #3
 LDA #&80
 JSR OSBYTE
 TYA
 LDY #12
 STA (OSSC),Y
 LDY #14
 LDA &FE40
 STA (OSSC),Y

.DK2

 RTS

