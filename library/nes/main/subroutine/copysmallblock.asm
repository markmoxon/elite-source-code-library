\ ******************************************************************************
\
\       Name: CopySmallBlock
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that copies a small number of pages in memory
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
\ ******************************************************************************

.CopySmallBlock

 LDY #0                 \ Set an index counter in Y

.cops1

 LDA (V),Y              \ Copy the Y-th byte from V(1 0) to SC(1 0)
 STA (SC),Y

 DEY                    \ Decrement the index counter

 BNE cops1              \ Loop back until we have copied a whole page of bytes

 INC V+1                \ Increment the high bytes of V(1 0) and SC(1 0) to
 INC SC+1               \ point to the next page in memory

 DEX                    \ Decrement the page counter

 BNE cops1              \ Loop back until we have copied X pages of memory

 RTS                    \ Return from the subroutine

