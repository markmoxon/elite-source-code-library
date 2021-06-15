\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
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
 LDA ZZ
 JMP tube_write

