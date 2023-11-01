\ ******************************************************************************
\
\       Name: HideFromScanner_b1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Call the HideFromScanner routine in ROM bank 1
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.HideFromScanner_b1

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR HideFromScanner    \ Call HideFromScanner, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

