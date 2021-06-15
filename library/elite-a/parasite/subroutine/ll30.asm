\ ******************************************************************************
\
\       Name: LL30
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: AJD
\
\ ******************************************************************************

.LOIN
.LL30

 LDA #&80
 JSR tube_write
 LDA X1
 JSR tube_write
 LDA Y1
 JSR tube_write
 LDA X2
 JSR tube_write
 LDA Y2
 JMP tube_write

