\ ******************************************************************************
\
\       Name: write_fe4e
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.write_fe4e

 JSR tube_get
 STA &FE4E
 JMP tube_put

