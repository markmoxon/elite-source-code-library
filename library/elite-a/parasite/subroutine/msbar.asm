\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Elite-A: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.MSBAR

 LDA #&88
 JSR tube_write
 TXA
 JSR tube_write
 TYA
 JSR tube_write
 LDY #&00
 RTS

