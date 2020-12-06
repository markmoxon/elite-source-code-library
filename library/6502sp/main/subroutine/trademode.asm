\ ******************************************************************************
\       Name: TRADEMODE
\ ******************************************************************************

.TRADEMODE

 PHA
 JSR CTRL
 STA printflag
 PLA
 JSR TT66

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

 LDA #48
 JSR DOVDU19
 LDA #CYAN\WH
 JMP DOCOL

