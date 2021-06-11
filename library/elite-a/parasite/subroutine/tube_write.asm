\ ******************************************************************************
\
\       Name: tube_write
\       Type: Subroutine
\   Category: Elite-A: Tube
\    Summary: AJD
\
\ ******************************************************************************

.tube_write

 BIT tube_r1s
 NOP
 BVC tube_write
 STA tube_r1d
 RTS

