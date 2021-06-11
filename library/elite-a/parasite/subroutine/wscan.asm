\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Elite-A: Screen mode
\    Summary: AJD
\
\ ******************************************************************************

.WSCAN

 LDA #&85
 JSR tube_write
 JMP tube_read

