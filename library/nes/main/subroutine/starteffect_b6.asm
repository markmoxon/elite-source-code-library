\ ******************************************************************************
\
\       Name: StartEffect_b6
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the StartEffect routine in ROM bank 6
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.StartEffect_b6

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank2
 BEQ bank2

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR StartEffect        \ Call StartEffect, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank2

 LDA ASAV               \ Restore the value of A that we stored above

 JMP StartEffect        \ Call StartEffect, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

