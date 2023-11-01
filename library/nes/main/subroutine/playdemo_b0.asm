\ ******************************************************************************
\
\       Name: PlayDemo_b0
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Call the PlayDemo routine in ROM bank 0
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.PlayDemo_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP PlayDemo           \ Call PlayDemo, which is already paged into memory, and
                        \ return from the subroutine using a tail call

