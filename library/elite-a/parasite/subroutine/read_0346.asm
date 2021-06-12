\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Elite-A: Tube
\    Summary: AJD
\
\ ******************************************************************************

.read_0346

 LDA #&98
 JSR tube_write
 JSR tube_read
 STA &0346
 RTS

