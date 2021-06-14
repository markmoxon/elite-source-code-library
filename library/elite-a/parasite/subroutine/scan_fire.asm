\ ******************************************************************************
\
\       Name: scan_fire
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_fire

 LDA #&89
 JSR tube_write
 JMP tube_read

