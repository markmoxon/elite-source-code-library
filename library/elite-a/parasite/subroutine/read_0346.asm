\ ******************************************************************************
\
\       Name: read_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: AJD
\
\ ******************************************************************************

.read_0346

 LDA #&98
 JSR tube_write
 JSR tube_read
 STA LASCT
 RTS

