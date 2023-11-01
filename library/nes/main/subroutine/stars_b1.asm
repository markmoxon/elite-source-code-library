\ ******************************************************************************
\
\       Name: STARS_b1
\       Type: Subroutine
\   Category: Stardust
\    Summary: Call the STARS routine in ROM bank 1
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.STARS_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank5
 BEQ bank5

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR STARS              \ Call STARS, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank5

 JMP STARS              \ Call STARS, which is already paged into memory, and
                        \ return from the subroutine using a tail call

