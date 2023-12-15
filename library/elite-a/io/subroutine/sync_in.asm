\ ******************************************************************************
\
\       Name: sync_in
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Implement the sync_in command (wait for the vertical sync)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a sync_in command. It waits for
\ the next vertical sync and returns a value to the parasite so it can wait
\ until the sync occurs. The value returned to the parasite isn't important, as
\ it's just about the timing of the response.
\
\ ******************************************************************************

.sync_in

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call

