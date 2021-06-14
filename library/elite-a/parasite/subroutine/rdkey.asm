\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.RDKEY

 LDA #&8C
 JSR tube_write
 JSR tube_read
 TAX
 RTS

