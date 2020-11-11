\ ******************************************************************************
\       Name: DELT
\ ******************************************************************************

.DELT

 JSR CATS \!!
 BCS SVE
 LDA CTLI+1
 STA DELI+7
 LDA #9
 JSR DETOK
 JSR MT26
 TYA
 BEQ SVE
 LDX #9

.DELL1

 LDA INWK+4,X
 STA DELI+8,X
 DEX
 BNE DELL1
 LDX #(DELI MOD256)
 LDY #(DELI DIV256)
 JSR SCLI2
 JMP SVE

