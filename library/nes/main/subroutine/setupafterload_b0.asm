\ ******************************************************************************
\
\       Name: SetupAfterLoad_b0
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the SetupAfterLoad routine in ROM bank 0
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.SetupAfterLoad_b0

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank26
 BEQ bank26

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR SetupAfterLoad     \ Call SetupAfterLoad, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank26

 JMP SetupAfterLoad     \ Call SetupAfterLoad, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

