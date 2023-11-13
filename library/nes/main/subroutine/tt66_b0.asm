\ ******************************************************************************
\
\       Name: TT66_b0
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Call the TT66 routine in ROM bank 0
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.TT66_b0

 STA storeA             \ Store the value of A so we can retrieve it below

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA storeA             \ Restore the value of A that we stored above

 JSR TT66               \ Call TT66, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

