\ ******************************************************************************
\
\       Name: sync_in
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Wait for the vertical sync and tell the parasite when it occurs
\
\ ******************************************************************************

.sync_in

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync

 JMP tube_put           \ Send A back to the parasite (so it can wait until the
                        \ vertical sync occurs) and return from the subroutine
                        \ using a tail call

