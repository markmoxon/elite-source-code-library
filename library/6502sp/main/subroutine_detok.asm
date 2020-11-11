\ ******************************************************************************
\       Name: DETOK
\ ******************************************************************************

.DETOK

 PHA
 TAX
 TYA
 PHA
 LDA V
 PHA
 LDA V+1
 PHA
 LDA #(TKN1 MOD256)
 STA V
 LDA #(TKN1 DIV256)

.^DTEN

 STA V+1
 LDY #0

.DTL1

 LDA (V),Y
 EOR #VE
 BNE DT1
 DEX
 BEQ DTL2

.DT1

 INY
 BNE DTL1
 INC V+1
 BNE DTL1

.DTL2

 INY
 BNE P%+4
 INC V+1
 LDA (V),Y
 EOR #VE
 BEQ DTEX
 JSR DETOK2
 JMP DTL2

.DTEX

 PLA
 STA V+1
 PLA
 STA V
 PLA
 TAY
 PLA
 RTS

