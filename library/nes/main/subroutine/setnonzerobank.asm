\ ******************************************************************************
\
\       Name: SetNonZeroBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that pages a specified ROM bank into memory at
\             &8000, but only if it is non-zero
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the ROM bank to page into memory at &8000
\
\ ******************************************************************************

.SetNonZeroBank

 CMP currentBank        \ If the ROM bank number in A is non-zero, jump to
 BNE SetBank            \ SetBank to page bank A into memory, returning from the
                        \ subroutine using a tail call

 RTS                    \ Otherwise return from the subroutine

