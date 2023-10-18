\ ******************************************************************************
\
\       Name: DEATH2_b0
\       Type: Subroutine
\   Category: Start and end
\    Summary: Switch to ROM bank 0 and call the DEATH2 routine
\
\ ******************************************************************************

.DEATH2_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP DEATH2             \ Call DEATH2, which is now paged into memory, and
                        \ return from the subroutine using a tail call

