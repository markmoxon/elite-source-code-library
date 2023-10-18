\ ******************************************************************************
\
\       Name: ShowScrollText_b6
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Call the ShowScrollText routine in ROM bank 6
\
\ ******************************************************************************

.ShowScrollText_b6

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank13
 BEQ bank13

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR ShowScrollText     \ Call ShowScrollText, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank13

 LDA ASAV               \ Restore the value of A that we stored above

 JMP ShowScrollText     \ Call ShowScrollText, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

