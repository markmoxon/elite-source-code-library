\ ******************************************************************************
\
\       Name: DETOK_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the DETOK routine in ROM bank 2
\
\ ******************************************************************************

.DETOK_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank14
 BEQ bank14

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR DETOK              \ Call DETOK, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank14

 LDA ASAV               \ Restore the value of A that we stored above

 JMP DETOK              \ Call DETOK, which is already paged into memory, and
                        \ return from the subroutine using a tail call

