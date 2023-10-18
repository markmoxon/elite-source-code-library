\ ******************************************************************************
\
\       Name: ResetBankP
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified bank into memory at &8000 while preserving the
\             value of A and the processor flags
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Stack               The number of the bank to page into memory at &8000
\
\ Other entry points:
\
\   RTS4                Contains an RTS
\
\ ******************************************************************************

.ResetBankP

 PLA                    \ Fetch the ROM bank number from the stack

 PHP                    \ Store the processor flags on the stack so we can
                        \ retrieve them below

 JSR SetBank            \ Page bank A into memory at &8000

 PLP                    \ Restore the processor flags, so we return the correct
                        \ Z and N flags for the value of A

.RTS4

 RTS                    \ Return from the subroutine

