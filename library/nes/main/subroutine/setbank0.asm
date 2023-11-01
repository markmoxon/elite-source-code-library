\ ******************************************************************************
\
\       Name: SetBank0
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page ROM bank 0 into memory at &8000
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.SetBank0

 LDA #0                 \ Page ROM bank 0 into memory at &8000 and return from
 JMP SetBank            \ the subroutine using a tail call

