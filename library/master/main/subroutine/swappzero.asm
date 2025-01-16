\ ******************************************************************************
\
\       Name: SWAPPZERO
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that swaps bytes in and out of zero page
\
\ ******************************************************************************

.SWAPPZERO

 LDX #K3+1              \ This routine starts copying zero page from the byte
                        \ after K3 and up, using X as an index

.SWPZL

 LDA ZP,X               \ These instructions have no effect, as they simply swap
 LDY ZP,X               \ a byte with itself
 STA ZP,X
 STY ZP,X

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

