\ ******************************************************************************
\
\       Name: CPIX2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: AJD
\
\ ******************************************************************************

.CPIX2

 LDA #&90
 JSR tube_write
 LDA X1
 JSR tube_write
 LDA Y1
 JSR tube_write
 LDA COL
 JMP tube_write

