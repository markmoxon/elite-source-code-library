\ ******************************************************************************
\
\       Name: ChangeToView_b0
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Call the ChangeToView routine in ROM bank 0
\
\ ******************************************************************************

.ChangeToView_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank12
 BEQ bank12

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR ChangeToView       \ Call ChangeToView, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank12

 LDA ASAV               \ Restore the value of A that we stored above

 JMP ChangeToView       \ Call ChangeToView, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

