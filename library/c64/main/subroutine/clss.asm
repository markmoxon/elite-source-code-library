\ ******************************************************************************
\
\       Name: clss
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen, move the text cursor to the top-left corner and
\             jump back into the CHPR routine to print the next character
\
\ ******************************************************************************

.clss

 JSR TT66simp           \ Call TT66simp to clear the whole screen inside the box
                        \ border, and move the text cursor to the top-left
                        \ corner

 LDA K3                 \ We called this routine from CHPR, which put the
                        \ character we are printing into K3, so set A to the
                        \ character number so we can jump back to CHPR to print
                        \ it on the newly cleared screen

 JMP RRafter            \ Jump back into the CHPR routine to print the character
                        \ in A

