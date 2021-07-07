\ ******************************************************************************
\
\       Name: sell_jump
\       Type: Subroutine
\   Category: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.sell_jump

 INC XC
 LDA #&CF
 JSR NLIN3
 JSR TT69
 JSR TT67
 JSR sell_equip
 LDA ESCP
 BEQ sell_escape
 LDA #&70
 LDX #&1E
 JSR status_equip

.sell_escape

 JMP BAY

