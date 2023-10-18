\ ******************************************************************************
\
\       Name: DrawSystemImage_b3
\       Type: Subroutine
\   Category: Universe
\    Summary: Call the DrawSystemImage routine in ROM bank 3
\
\ ******************************************************************************

.DrawSystemImage_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank8
 BEQ bank8

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR DrawSystemImage    \ Call DrawSystemImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank8

 LDA ASAV               \ Restore the value of A that we stored above

 JMP DrawSystemImage    \ Call DrawSystemImage, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

