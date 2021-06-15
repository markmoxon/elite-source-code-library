\ ******************************************************************************
\
\       Name: sync_in
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Wait for the vertical sync
\
\ ******************************************************************************

.sync_in

 JSR WSCAN              \ AJD
 JMP tube_put

