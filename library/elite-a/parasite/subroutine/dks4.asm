\ ******************************************************************************
\
\       Name: DKS4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.DKS4

 LDA #&8B
 JSR tube_write
 TXA
 JSR tube_write
 JSR tube_read
 TAX
 RTS

