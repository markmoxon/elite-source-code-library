\ ******************************************************************************
\
\       Name: GetSystemImage_b5
\       Type: Subroutine
\   Category: Universe
\    Summary: Call the GetSystemImage routine in ROM bank 5
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.GetSystemImage_b5

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #5                 \ Page ROM bank 5 into memory at &8000
 JSR SetBank

 JSR GetSystemImage     \ Call GetSystemImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

