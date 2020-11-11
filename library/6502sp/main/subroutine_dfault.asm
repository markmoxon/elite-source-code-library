\ ******************************************************************************
\       Name: DFAULT
\ ******************************************************************************

.DFAULT

 LDX #NT%+8

.QUL1

 LDA NA%-1,X
 STA NAME-1,X
 DEX
 BNE QUL1
 STX QQ11
 JSR CHECK
 CMP CHK
 BNE P%-6
\JSRBELL
 EOR #&A9
 TAX
 LDA COK
 CPX CHK2
 BEQ tZ
 ORA #128

.tZ

 ORA #4
 STA COK
 RTS

