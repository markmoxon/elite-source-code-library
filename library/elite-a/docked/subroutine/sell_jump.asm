\ ******************************************************************************
\
\       Name: sell_jump
\       Type: Subroutine
\   Category: Equipment
\    Summary: Show the Sell Equipment screen (CTRL-f2)
\
\ ******************************************************************************

.sell_jump

 INC XC                 \ AJD
 LDA #&CF
 JSR NLIN3
 JSR TT69
 JSR TT67
 JSR sell_equip
 LDA ESCP
 BEQ sell_escape
 LDA #112
 LDX #30
 JSR status_equip

.sell_escape

 JMP BAY

