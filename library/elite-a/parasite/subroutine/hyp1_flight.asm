\ ******************************************************************************
\
\       Name: hyp1_FLIGHT
\       Type: Subroutine
\   Category: Universe
\    Summary: AJD
\
\ ******************************************************************************

.hyp1_FLIGHT

 JSR jmp                \ duplicate of hyp1
 LDX #&05

.d_31b0

 LDA QQ15,X
 STA QQ2,X
 DEX
 BPL d_31b0
 INX
 STX EV
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov

 JSR DORND
 STA QQ26
 JMP GVL

