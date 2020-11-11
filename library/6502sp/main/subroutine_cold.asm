\ ******************************************************************************
\       Name: COLD
\ ******************************************************************************

.COLD

\Move WORDS and SHIPS to proper places
 LDA #(F%MOD256)
 STA V
 LDA #(F%DIV256)
 STA V+1
 LDA #(QQ18 MOD256)
 STA SC
 LDA #(QQ18 DIV256)
 STA SC+1
 LDX #4
 JSR mvblock
 LDA #(F%MOD256)
 STA V
 LDA #((F%DIV256)+4)
 STA V+1
 LDA #(D%MOD256)
 STA SC
 LDA #(D%DIV256)
 STA SC+1
 LDX #&22

.mvblock

 LDY #0

.mvbllop

 LDA (V),Y
 STA (SC),Y
 INY
 BNE mvbllop
 INC V+1
 INC SC+1
 DEX
 BNE mvbllop
 RTS

