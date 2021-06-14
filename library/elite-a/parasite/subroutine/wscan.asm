\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Screen mode
\    Summary: AJD
\
\ ******************************************************************************

.WSCAN

 LDA #&85
 JSR tube_write
 JMP tube_read

