\ ******************************************************************************
\
\       Name: ResetBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Retrieve a ROM bank number from the stack and page that bank into
\             memory at &8000
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Stack               The number of the ROM bank to page into memory at &8000
\
\ ******************************************************************************

.ResetBank

 PLA                    \ Retrieve the ROM bank number from the stack into A

                        \ Fall through into SetBank to page ROM bank A into
                        \ memory at &8000

