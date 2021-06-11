\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Elite-A: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.RDKEY

 LDA #&8C
 JSR tube_write
 JSR tube_read
 TAX
 RTS

