\ ******************************************************************************
\
\       Name: boot_in
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

.boot_in

 LDA #0
 STA save_lock
 STA SSPR
 STA ECMA
 STA dockedp
 JMP BEGIN

