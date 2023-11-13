\ ******************************************************************************
\
\       Name: CheckForPause_b0
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Call the CheckForPause routine in ROM bank 0
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   N, Z flags          Set according to the value of A passed to the routine
\
\ ******************************************************************************

.CheckForPause_b0

 STA storeA             \ Store the value of A so we can retrieve it below

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA storeA             \ Restore the value of A that we stored above

 JSR CheckForPause      \ Call CheckForPause, now that it is paged into memory

 JMP ResetBankP         \ Jump to ResetBankP to retrieve the bank number we
                        \ stored above, page it back into memory and set the
                        \ processor flags according to the value of A, returning
                        \ from the subroutine using a tail call

