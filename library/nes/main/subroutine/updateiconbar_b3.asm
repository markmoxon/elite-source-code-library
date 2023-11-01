\ ******************************************************************************
\
\       Name: UpdateIconBar_b3
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Call the UpdateIconBar routine in ROM bank 3
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.UpdateIconBar_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank20
 BEQ bank20

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR UpdateIconBar      \ Call UpdateIconBar, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank20

 JMP UpdateIconBar      \ Call UpdateIconBar, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

