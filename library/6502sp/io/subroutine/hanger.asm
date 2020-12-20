\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Implement the OSWORD 248 command (display the ship hanger)
\
\ ******************************************************************************

.HANGER

 LDX #2

.HAL1

 STX T
 LDA #130
 STX Q
 JSR DVID4
 LDA P
 CLC
 ADC #Y
 TAY

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 STA R
 LDA P
 AND #7
 STA SC
 LDY #0
 JSR HAS2
 LDY R
 INY
 STY SC+1
 LDA #&40
 LDY #&F8
 JSR HAS3
 LDY #2
 LDA (OSSC),Y
 TAY
 BEQ HA2
 LDY #0
 LDA #&88
 JSR HAL3
 DEC SC+1
 LDY #&F8
 LDA #&10
 JSR HAS3

.HA2

 LDX T
 INX
 CPX #13
 BCC HAL1
 LDA #60
 STA S
 LDA #&10
 LDX #&40
 STX R

.HAL6

 LDX R
 STX SC+1
 STA T
 AND #&FC
 STA SC
 LDX #&88
 LDY #1

.HAL7

 TXA
 AND (SC),Y
 BNE HA6
 TXA
 AND #RED
 ORA (SC),Y
 STA (SC),Y
 INY
 CPY #8
 BNE HAL7
 INC SC+1
 INC SC+1
 LDY #0
 BEQ HAL7

.HA6

 LDA T
 CLC
 ADC #16
 BCC P%+4
 INC R
 DEC S
 BNE HAL6

.HA3

 RTS

.HAS2

 LDA #&22

.HAL2

 TAX
 AND (SC),Y
 BNE HA3
 TXA
 AND #RED
 ORA (SC),Y
 STA (SC),Y
 TXA
 LSR A
 BCC HAL2
 TYA
 ADC #7
 TAY
 LDA #&88
 BCC HAL2
 INC SC+1

.HAL3

 TAX
 AND (SC),Y
 BNE HA3
 TXA
 AND #RED
 ORA (SC),Y
 STA (SC),Y
 TXA
 LSR A
 BCC HAL3
 TYA
 ADC #7
 TAY
 LDA #&88
 BCC HAL3
 RTS

.HAS3

 TAX
 AND (SC),Y
 BNE HA3
 TXA
 ORA (SC),Y
 STA (SC),Y
 TXA
 ASL A
 BCC HAS3
 TYA
 SBC #8
 TAY
 LDA #&10
 BCS HAS3
 RTS

