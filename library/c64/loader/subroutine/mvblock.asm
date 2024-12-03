\ ******************************************************************************
\
\       Name: mvblock
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy a number of pages in memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (A ZP2)             The source address
\
\   ZP(1 0)             The destination address
\
\   X                   The number of pages to copy
\
\ ******************************************************************************

.mvblock

 STA ZP2+1              \ Set ZP2(1 0) = (A ZP2)

 LDY #0                 \ Set Y = 0 to count through the bytes in each page

.LOOP5

 LDA (ZP2),Y            \ Copy the Y-th byte of ZP2(1 0) to the Y-th byte of
 STA (ZP),Y             \ ZP(1 0)

 DEY                    \ Decrement the byte counter to point to the next byte

 BNE LOOP5              \ Loop back to LOOP5 until we have copied a whole page

 INC ZP2+1              \ Increment the high byte of ZP2(1 0) to point to the
                        \ next page to copy from

 INC ZP+1               \ Increment the high byte of ZP(1 0) to point to the
                        \ next page to copy into

 DEX                    \ Decrement the page counter in X

 BNE LOOP5              \ Loop back to copy the next page until we have copied
                        \ all of them

 RTS                    \ Return from the subroutine

