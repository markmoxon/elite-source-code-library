\ ******************************************************************************
\
\       Name: LL9_b1
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Call the LL9 routine in ROM bank 1
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.LL9_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank3
 BEQ bank3

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR LL9                \ Call LL9, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank3

 JMP LL9                \ Call LL9, which is already paged into memory, and
                        \ return from the subroutine using a tail call

