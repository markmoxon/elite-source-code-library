\ ******************************************************************************
\
\       Name: CopyLargeBlock
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that copies a large number of pages in memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   SC2(1 0)            Source address
\
\   SC(1 0)             Destination address
\
\   V                   The number of pages top copy in each set
\
\   V+1                 The number of sets, so we copy V * V+1 pages
\
\   X                   Number of pages of memory to copy
\
\ ******************************************************************************

.CopyLargeBlock

 LDY #0                 \ Set an index counter in Y

 INC V                  \ Increment the page counter in V so we can use a BNE
                        \ below to copy V pages

 INC V+1                \ Increment the page counter in V+1 so we can use a BNE
                        \ below to copy V+1 sets of V pages

.copl1

 LDA (SC2),Y            \ Copy the Y-th byte from SC2(1 0) to SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index counter

 BNE copl2              \ If we haven't reached the end of the page, jump to
                        \ copl2 to skip the following

 INC SC+1               \ Increment the high bytes of SC(1 0) and SC2(1 0) to
 INC SC2+1              \ point to the next page in memory

.copl2

 DEC V                  \ Loop back to repeat the above until we have copied V
 BNE copl1              \ pages

 DEC V+1                \ Loop back to repeat the above until we have copied V+1
 BNE copl1              \ sets of V pages

 RTS                    \ Return from the subroutine

