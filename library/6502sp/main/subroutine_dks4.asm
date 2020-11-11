\ ******************************************************************************
\       Name: DKS4
\ ******************************************************************************

.DKS4

 STX DKS4pars+2
 LDX #(DKS4pars MOD256)
 LDY #(DKS4pars DIV256)
 LDA #DODKS4
 JSR OSWORD
 LDA DKS4pars+2
 RTS

.DKS4pars

 EQUB 3
 EQUB 3
 EQUB 0
 RTS

