\ ******************************************************************************
\
\       Name: mvblockK
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Copy a specific number of pages in memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   V(1 0)              Source address
\
\   SC(1 0)             Destination address
\
\   X                   Number of pages of memory to copy
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   mvbllop             Only copy Y bytes, rather than a whole page
\
\ ******************************************************************************

.mvblockK

 LDY #0                 \ Set an index counter in Y

.mvbllop

 LDA (V),Y              \ Copy the Y-th byte from V(1 0) to SC(1 0)
 STA (SC),Y

 DEY                    \ Decrement the index counter

 BNE mvbllop            \ Loop back until we have copied a whole page of bytes

 INC V+1                \ Increment the high bytes of V(1 0) and SC(1 0) to
 INC SC+1               \ point to the next page in memory

 DEX                    \ Decrement the page counter

 BNE mvbllop            \ Loop back until we have copied X pages of memory

 RTS                    \ Return from the subroutine

