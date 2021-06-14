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
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &36
 JSR tube_write
 LDA &37
 JMP tube_write

