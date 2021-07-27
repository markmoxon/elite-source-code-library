\ ******************************************************************************
\
\       Name: DK4_FLIGHT
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD (flight version)
\
\ ******************************************************************************

.DK4_FLIGHT

 JSR RDKEY              \ Copy of DK4
 STX KL
 CPX #&69
 BNE d_459c

.d_455f

 JSR WSCAN
 JSR RDKEY
 CPX #&51
 BNE d_456e
 LDA #&00
 STA DNOIZ

.d_456e

 LDY #&40

.d_4570

 JSR DKS3
 INY
 CPY #&48
 BNE d_4570
 CPX #&10
 BNE d_457f
 STX DNOIZ

.d_457f

 CPX #&70
 BNE d_4586
 JMP DEATH2

.d_4586

\CPX #&37
\BNE dont_dump
\JSR printer
\.dont_dump

 CPX #&59
 BNE d_455f

.d_459c

 LDA QQ11
 BNE DK5
 LDY #&10

.d_45a4

 JSR DKS1
 DEY
 CPY #&07
 BNE d_45a4

.DK5

 RTS

