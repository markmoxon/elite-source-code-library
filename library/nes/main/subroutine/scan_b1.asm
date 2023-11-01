\ ******************************************************************************
\
\       Name: SCAN_b1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Call the SCAN routine in ROM bank 1
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.SCAN_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank28
 BEQ bank28

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR SCAN               \ Call SCAN, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank28

 JMP SCAN               \ Call SCAN, which is already paged into memory, and
                        \ return from the subroutine using a tail call

