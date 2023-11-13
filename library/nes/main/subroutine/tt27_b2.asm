\ ******************************************************************************
\
\       Name: TT27_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the TT27 routine in ROM bank 2
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.TT27_b2

 STA storeA             \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank24
 BEQ bank24

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA storeA             \ Restore the value of A that we stored above

 JSR TT27               \ Call TT27, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank24

 LDA storeA             \ Restore the value of A that we stored above

 JMP TT27               \ Call TT27, which is already paged into memory, and
                        \ return from the subroutine using a tail call

