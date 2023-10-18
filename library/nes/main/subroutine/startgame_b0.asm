\ ******************************************************************************
\
\       Name: StartGame_b0
\       Type: Subroutine
\   Category: Start and end
\    Summary: Switch to ROM bank 0 and call the StartGame routine
\
\ ******************************************************************************

.StartGame_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP StartGame          \ Call StartGame, which is now paged into memory, and
                        \ return from the subroutine using a tail call

