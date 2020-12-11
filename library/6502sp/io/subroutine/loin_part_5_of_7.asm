\ ******************************************************************************
\       Name: LOIN (Part 5 of 7)
\ ******************************************************************************

.STPY

 LDY Y1
 TYA
 LDX X1
 CPY Y2
 BCS LI15
 DEC SWAP
 LDA X2
 STA X1
 STX X2
 TAX
 LDA Y2
 STA Y1
 STY Y2
 TAY

.LI15

 LDA ylookup,Y
 STA SC+1
 TXA
 AND #&FC
 ASL A
 STA SC
 BCC P%+4
 INC SC+1
 TXA
 AND #3
 TAX
 LDA TWOS,X
 STA R
 LDX P
 BEQ LIfudge
 LDA logL,X
 LDX Q
 SEC
 SBC logL,X
 BMI LIloG
 LDX P
 LDA log,X
 LDX Q
 SBC log,X
 BCS LIlog3
 TAX
 LDA antilog,X
 JMP LIlog2

.LIlog3

 LDA #&FF
 BNE LIlog2

.LIloG

 LDX P
 LDA log,X
 LDX Q
 SBC log,X
 BCS LIlog3
 TAX
 LDA antilogODD,X

.LIlog2

 STA P

.LIfudge

 LDX Q
 BEQ LIEX7
 INX
 LDA X2
 SEC
 SBC X1
 BCS P%+6
 JMP LFT
