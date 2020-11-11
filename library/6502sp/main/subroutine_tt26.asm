\ ******************************************************************************
\       Name: TT26
\ ******************************************************************************

\ New TT26 entry for right justified text

.DASC

.TT26

 STX SC
 LDX #FF
 STX DTW8
 CMP #'.'
 BEQ DA8
 CMP #':'
 BEQ DA8
 CMP #10
 BEQ DA8
 CMP #12
 BEQ DA8
 CMP #32
 BEQ DA8
 INX

.DA8

 STX DTW2
 LDX SC
 BIT DTW4
 BMI P%+5
 JMP CHPR
 BVS P%+6
 CMP #12
 BEQ DA1
 LDX DTW5
 STA BUF,X
 LDX SC
 INC DTW5
 CLC
 RTS

.DA1

 TXA
 PHA
 TYA
 PHA

.DA5

 LDX DTW5
 BEQ DA6+3
 CPX #(LL+1)
 BCC DA6
 LSR SC+1

.DA11

 LDA SC+1
 BMI P%+6
 LDA #64
 STA SC+1
 LDY #(LL-1)

.DAL1

 LDA BUF+LL
 CMP #32
 BEQ DA2

.DAL2

 DEY
 BMI DA11
 BEQ DA11
 LDA BUF,Y
 CMP #32
 BNE DAL2
 ASL SC+1
 BMI DAL2
 STY SC
 LDY DTW5

.DAL6

 LDA BUF,Y
 STA BUF+1,Y
 DEY
 CPY SC
 BCS DAL6
 INC DTW5
\LDA#32

.DAL3

 CMP BUF,Y
 BNE DAL1
 DEY
 BPL DAL3
 BMI DA11

.DA2

 LDX #LL
 JSR DAS1
 LDA #12
 JSR CHPR
 LDA DTW5
\CLC
 SBC #LL
 STA DTW5
 TAX
 BEQ DA6+3
 LDY #0
 INX

.DAL4

 LDA BUF+LL+1,Y
 STA BUF,Y
 INY
 DEX
 BNE DAL4
 BEQ DA5

.DAS1

 LDY #0

.DAL5

 LDA BUF,Y
 JSR CHPR
 INY
 DEX
 BNE DAL5

.^rT9

 RTS

.DA6

 JSR DAS1
 STX DTW5
 PLA
 TAY
 PLA
 TAX
 LDA #12

.DA7

 EQUB &2C

