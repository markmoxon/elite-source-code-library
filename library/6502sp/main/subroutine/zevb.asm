\ ******************************************************************************
\
\       Name: ZEVB
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill the Y1VB variable
\
\ ******************************************************************************

.ZEVB

 LDA #0                 \ Set A = 0 so we can use it to zero-fill the variable

 TAY                    \ Set Y = 0 to use as a loop counter, starting at 0 and
                        \ working from 255 down to 1

.SLL1

 STA Y1VB,Y             \ Zero the Y-th byte from Y1VB

 DEY                    \ Decrement the loop counter

 BNE SLL1               \ Jump back to zero the next byte until the whole page
                        \ is done

 RTS                    \ Return from the subroutine

