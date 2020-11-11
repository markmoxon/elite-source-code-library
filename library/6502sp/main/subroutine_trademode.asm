\ ******************************************************************************
\       Name: TRADEMODE
\ ******************************************************************************

.TRADEMODE

 PHA
 JSR CTRL
 STA printflag
 PLA
 JSR TT66
 JSR FLKB
 LDA #48
 JSR DOVDU19
 LDA #CYAN\WH
 JMP DOCOL

