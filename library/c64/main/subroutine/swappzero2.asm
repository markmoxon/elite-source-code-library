\ ******************************************************************************
\
\       Name: SWAPPZERO (source disk variant)
\       Type: Subroutine
\   Category: Utility routines
\    Summary: A routine that swaps zero page with the page at &CE00, so that
\             zero page changes made by Kernal functions can be reversed
\
\ ******************************************************************************

IF _SOURCE_DISK

.SWAPPZERO

 LDX #K3+1              \ This routine starts copying zero page from the byte
                        \ after K3 and up, using X as an index

.SWPZL

 LDA ZP,X               \ Swap the X-th byte of zero page with the X-th byte of
 LDY &CE00,X            \ &CE00
 STA &CE00,X
 STY ZP,X

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

ENDIF

