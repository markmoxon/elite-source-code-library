\ ******************************************************************************
\
\       Name: update_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.update_pod

 LDA #&8F
 JSR tube_write
 LDA ESCP
 JSR tube_write
 LDA &0348
 JMP tube_write

