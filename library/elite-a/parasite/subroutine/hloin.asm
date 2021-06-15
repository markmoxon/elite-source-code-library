\ ******************************************************************************
\
\       Name: HLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: AJD
\
\ ******************************************************************************

.HLOIN

 LDA #&81
 JSR tube_write
 LDA X1
 JSR tube_write
 LDA Y1
 JSR tube_write
 LDA X2
 JMP tube_write

