\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Implement the OSWORD 247 command (draw a horizontal line)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   HLOIN3              
\
\ ******************************************************************************

.HLOIN

 LDY #0
 LDA (OSSC),Y
 STA Q
 INY
 INY

.HLLO

 LDA (OSSC),Y
 STA X1
 TAX
 INY
 LDA (OSSC),Y
 STA X2
 INY
 LDA (OSSC),Y
 STA Y1
 STY Y2
 AND #3
 TAY
 LDA orange,Y

.HLOIN3

 STA S
 CPX X2
 BEQ HL6
 BCC HL5
 LDA X2
 STA X1
 STX X2
 TAX

.HL5

 DEC X2
 LDY Y1

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TYA
 AND #7
 STA SC
 TXA
 AND #&FC
 ASL A
 TAY
 BCC P%+4
 INC SC+1

.HL1

 TXA
 AND #&FC
 STA T
 LDA X2
 AND #&FC
 SEC
 SBC T
 BEQ HL2
 LSR A
 LSR A
 STA R
 LDA X1
 AND #3
 TAX
 LDA TWFR,X
 AND S
 EOR (SC),Y
 STA (SC),Y
 TYA
 ADC #8
 TAY
 BCS HL7

.HL8

 LDX R
 DEX
 BEQ HL3
 CLC

.HLL1

 LDA S
 EOR (SC),Y
 STA (SC),Y
 TYA
 ADC #8
 TAY
 BCS HL9

.HL10

 DEX
 BNE HLL1

.HL3

 LDA X2
 AND #3
 TAX
 LDA TWFL,X
 AND S
 EOR (SC),Y
 STA (SC),Y

.HL6

 LDY Y2
 INY
 CPY Q
 BEQ P%+5
 JMP HLLO
 RTS

.HL2

 LDA X1
 AND #3
 TAX
 LDA TWFR,X
 STA T
 LDA X2
 AND #3
 TAX
 LDA TWFL,X
 AND T
 AND S
 EOR (SC),Y
 STA (SC),Y
 LDY Y2
 INY
 CPY Q
 BEQ P%+5
 JMP HLLO
 RTS

.HL7

 INC SC+1
 CLC
 JMP HL8

.HL9

 INC SC+1
 CLC
 JMP HL10

