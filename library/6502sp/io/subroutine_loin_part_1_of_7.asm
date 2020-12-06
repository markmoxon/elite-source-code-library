\ ******************************************************************************
\       Name: LOIN (Part 1 of 7)
\ ******************************************************************************

.LOIN

 LDA #128
 STA S
 ASL A
 STA SWAP
 LDA X2
 SBC X1
 BCS LI1
 EOR #&FF
 ADC #1
 SEC

.LI1

 STA P
 LDA Y2
 SBC Y1
 BEQ HLOIN2
 BCS LI2
 EOR #&FF
 ADC #1

.LI2

 STA Q
 CMP P
 BCC STPX
 JMP STPY

