\ ******************************************************************************
\
\       Name: MVBL
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Decrypt and move a multi-page block of memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              The source address of the block to move
\
\   ZP(1 0)             The destination address of the block to move
\
\   X                   Number of pages of memory to move (1 page = 256 bytes)
\
\ ******************************************************************************

.MVBL

 JSR MVPG               \ Call MVPG above to copy one page of memory from the
                        \ address in P(1 0) to the address in ZP(1 0)

 INC ZP+1               \ Increment the high byte of the source address to point
                        \ to the next page

 INC P+1                \ Increment the high byte of the destination address to
                        \ point to the next page

 DEX                    \ Decrement the page counter

 BNE MVBL               \ Loop back to copy the next page until we have done X
                        \ pages

 RTS                    \ Return from the subroutine

