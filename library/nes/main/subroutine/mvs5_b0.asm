\ ******************************************************************************
\
\       Name: MVS5_b0
\       Type: Subroutine
\   Category: Moving
\    Summary: Call the MVS5 routine in ROM bank 0
\
\ ******************************************************************************

.MVS5_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank21
 BEQ bank21

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR MVS5               \ Call MVS5, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank21

 LDA ASAV               \ Restore the value of A that we stored above

 JMP MVS5               \ Call MVS5, which is already paged into memory, and
                        \ return from the subroutine using a tail call

