\ ******************************************************************************
\
\       Name: TIDY_b1
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Call the TIDY routine in ROM bank 1
\
\ ******************************************************************************

.TIDY_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank4
 BEQ bank4

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR TIDY               \ Call TIDY, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank4

 JMP TIDY               \ Call TIDY, which is already paged into memory, and
                        \ return from the subroutine using a tail call

