\ ******************************************************************************
\
\       Name: SWAPZP2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused placeholder routine for swapping zero page bytes
\
\ ******************************************************************************

.SWAPZP2

 LDX #&15               \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index

.SWPL2

 LDA ZP,X               \ These instructions have no effect, though they look
 LDY ZP,X               \ like they may have been used to swap two sets of bytes
 STA ZP,X               \ within zero page
 STY ZP,X

 INX                    \ Increment the loop counter

 BNE SWPL2              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

