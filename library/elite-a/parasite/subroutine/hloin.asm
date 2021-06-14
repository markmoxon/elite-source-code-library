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
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &36
 JMP tube_write

