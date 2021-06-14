\ ******************************************************************************
\
\       Name: DKS1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.DKS1

 LDA #&96
 JSR tube_write
 TYA
 JSR tube_write
 LDA BSTK
 JSR tube_write
 JSR tube_read
 BPL b_quit
 STA KL,Y

.b_quit

 RTS

