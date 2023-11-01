\ ******************************************************************************
\
\       Name: SetupIconBar_b3
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Call the SetupIconBar routine in ROM bank 3
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.SetupIconBar_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank16
 BEQ bank16

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR SetupIconBar       \ Call SetupIconBar, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank16

 LDA ASAV               \ Restore the value of A that we stored above

 JMP SetupIconBar       \ Call SetupIconBar, which is already paged into memory,
                        \ and return from the subroutine using a tail call

