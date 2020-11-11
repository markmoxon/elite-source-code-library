\ ******************************************************************************
\       Name: LOIN (Part 2 of 7)
\ ******************************************************************************

.STPX

 LDX X1
 CPX X2
 BCC LI3
 DEC SWAP
 LDA X2
 STA X1
 STX X2
 TAX
 LDA Y2
 LDY Y1
 STA Y1
 STY Y2

.LI3

 LDY Y1
 LDA ylookup,Y
 STA SC+1
 LDA Y1
 AND #7
 TAY
 TXA
 AND #&FC
 ASL A
 STA SC
 BCC P%+4
 INC SC+1
 TXA
 AND #3
 STA R
 LDX Q
 BEQ LIlog7
 LDA logL,X
 LDX P
 SEC
 SBC logL,X
 BMI LIlog4
 LDX Q
 LDA log,X
 LDX P
 SBC log,X
 BCS LIlog5
 TAX
 LDA antilog,X
 JMP LIlog6

.LIlog5

 LDA #FF
 BNE LIlog6

.LIlog7

 LDA #0
 BEQ LIlog6

.LIlog4

 LDX Q
 LDA log,X
 LDX P
 SBC log,X
 BCS LIlog5
 TAX
 LDA antilogODD,X

.LIlog6

 STA Q
 LDX P
 BEQ LIEXS
 INX
 LDA Y2
 CMP Y1
 BCC P%+5
 JMP DOWN

