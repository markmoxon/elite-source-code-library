\ ******************************************************************************
\
\       Name: MVBL
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Move a multi-page block of memory from one location to another
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Z1(1 0)             The source address of the block to move
\
\   Z2(1 0)             The destination address of the block to move
\
\   X                   Number of pages of memory to move (1 page = 256 bytes)
\
\ ******************************************************************************

.MVPG

                        \ This subroutine is called from below to copy one page
                        \ of memory from the address in Z1(1 0) to the address
                        \ in Z2(1 0)

 LDY #0                 \ We want to move one page of memory, so set Y as a byte
                        \ counter

.MPL

 LDA (Z1),Y             \ Copy the Y-th byte of the Z1(1 0) memory block to the
 STA (Z2),Y             \ Y-th byte of the Z2(1 0) memory block

 DEY                    \ Decrement the byte counter

 BNE MPL                \ Loop back to copy the next byte until we have done a
                        \ whole page of 256 bytes

 RTS                    \ Return from the subroutine

.MVBL

 JSR MVPG               \ Call MVPG above to copy one page of memory from the
                        \ address in Z1(1 0) to the address in Z2(1 0)

 INC Z1+1               \ Increment the high byte of the source address to point
                        \ to the next page

 INC Z2+1               \ Increment the high byte of the destination address to
                        \ point to the next page

 DEX                    \ Decrement the page counter

 BPL MVBL               \ Loop back to copy the next page until we have done X
                        \ pages

 RTS                    \ Return from the subroutine

