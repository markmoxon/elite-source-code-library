\ ******************************************************************************
\
\       Name: PDESC_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the PDESC routine in ROM bank 2
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.PDESC_b2

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 JSR PDESC              \ Call PDESC, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

