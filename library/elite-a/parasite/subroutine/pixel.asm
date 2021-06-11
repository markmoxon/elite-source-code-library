\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Elite-A: Drawing pixels
\    Summary: AJD
\
\ ******************************************************************************

.PIXEL

 PHA
 LDA #&82
 JSR tube_write
 TXA
 JSR tube_write
 PLA
 JSR tube_write
 LDA &88
 JMP tube_write

