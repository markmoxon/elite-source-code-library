\ ******************************************************************************
\
\       Name: clss
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen and jump back into the CHPR routine to print the
\             next character
\
\ ******************************************************************************

.clss

 JSR TT66simp           \ Call TT66simp to clear the screen 

 LDA K3                 \ We called this routine from CHPR, which put the
                        \ character we are printing into K3, so set A to the
                        \ character number so we can jump back to CHPR to print
                        \ it on the newly cleared screen

 JMP RRafter            \ Jump back into the CHPR routine to print the character
                        \ in A

