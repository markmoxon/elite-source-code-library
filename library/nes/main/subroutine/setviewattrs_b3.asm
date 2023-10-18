\ ******************************************************************************
\
\       Name: SetViewAttrs_b3
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Call the SetViewAttrs routine in ROM bank 3
\
\ ******************************************************************************

.SetViewAttrs_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank9
 BEQ bank9

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR SetViewAttrs       \ Call SetViewAttrs, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank9

 JMP SetViewAttrs       \ Call SetViewAttrs, which is already paged into memory,
                        \ and return from the subroutine using a tail call

