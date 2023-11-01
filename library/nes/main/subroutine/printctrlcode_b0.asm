\ ******************************************************************************
\
\       Name: PrintCtrlCode_b0
\       Type: Subroutine
\   Category: Text
\    Summary: Call the PrintCtrlCode routine in ROM bank 0
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.PrintCtrlCode_b0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR PrintCtrlCode      \ Call PrintCtrlCode, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

