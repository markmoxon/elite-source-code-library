\ ******************************************************************************
\
\       Name: boot_in
\       Type: Subroutine
\   Category: Elite-A: Loader
\    Summary: AJD
\
\ ******************************************************************************

.boot_in

 LDA #0
 STA save_lock
 STA &0320
 STA &30
 STA dockedp
 JMP BEGIN

