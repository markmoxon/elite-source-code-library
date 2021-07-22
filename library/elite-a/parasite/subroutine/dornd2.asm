\ ******************************************************************************
\
\       Name: DORND2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Generate random numbers with RAND+2 restricted so that bit 0 is
\             always 0
\
\ ******************************************************************************

.DORND2

 CLC                    \ This ensures that bit 0 of r2 is 0 in the DORND
                        \ routine

 JMP DORND              \ Jump to DORND to generate random numbers in A and X,
                        \ returning from the subroutine using a tail call

