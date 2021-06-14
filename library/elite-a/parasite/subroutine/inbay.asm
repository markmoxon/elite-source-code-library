\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
\    Summary: AJD
\
\ ******************************************************************************

.INBAY

 \dead entry
 LDA #0
 STA save_lock
 STA dockedp
 JSR BRKBK
 JSR RES2
 JMP BR1

