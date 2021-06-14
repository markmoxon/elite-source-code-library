\ ******************************************************************************
\
\       Name: CPIX2
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: AJD
\
\ ******************************************************************************

.CPIX2

 LDA #&90
 JSR tube_write
 LDA &34
 JSR tube_write
 LDA &35
 JSR tube_write
 LDA &91
 JMP tube_write

