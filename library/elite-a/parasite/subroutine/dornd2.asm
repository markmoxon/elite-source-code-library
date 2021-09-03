\ ******************************************************************************
\
\       Name: DORND2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Generate random numbers, making sure the C flag doesn't affect the
\             outcome
\  Deep dive: Generating random numbers
\
\ ******************************************************************************

.DORND2

 CLC                    \ Clear the C flag so the value of the C flag on entry
                        \ doesn't affect the outcome

 JMP DORND              \ Jump to DORND to generate random numbers in A and X,
                        \ returning from the subroutine using a tail call

