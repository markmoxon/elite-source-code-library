\ ******************************************************************************
\
\       Name: ResetScreen_b3
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the ResetScreen routine in ROM bank 3
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.ResetScreen_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR ResetScreen        \ Call ResetScreen, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

