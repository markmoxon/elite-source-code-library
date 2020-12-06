\ ******************************************************************************
\       Name: WSCAN
\ ******************************************************************************

.WSCpars

 EQUB 2
 EQUB 2
 EQUW 0

.WSCAN

 PHX
 PHY
\++
 LDA #wscn
 LDX #(WSCpars MOD256)
 LDY #(WSCpars DIV256)
 JSR OSWORD
 PLY
 PLX
 RTS

