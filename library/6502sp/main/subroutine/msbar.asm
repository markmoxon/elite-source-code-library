\ ******************************************************************************
\       Name: MSBAR
\ ******************************************************************************

.msbpars

 EQUB 4
 EQUD 0

.MSBAR

 PHX \++
 STX msbpars+2
 STY msbpars+3
 PHY
 LDX #(msbpars MOD256)
 LDY #(msbpars DIV256)
 LDA #DOmsbar
 JSR OSWORD
 LDY #0
 PLA
 PLX \++
 RTS

