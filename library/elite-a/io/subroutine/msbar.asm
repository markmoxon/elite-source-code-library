\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.MSBAR

 JSR tube_get           \ Like MSBAR
 ASL A
 ASL A
 ASL A
 STA missle_1
 LDA #&31-8
 SBC missle_1
 STA SC
 LDA #&7E
 STA SC+&01
 JSR tube_get
 LDY #&05

.l_33ba

 STA (SC),Y
 DEY
 BNE l_33ba
 RTS

