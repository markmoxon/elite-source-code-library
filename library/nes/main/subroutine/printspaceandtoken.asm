\ ******************************************************************************
\
\       Name: PrintSpaceAndToken
\       Type: Subroutine
\   Category: Text
\    Summary: Print a space followed by a text token
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed
\
\ ******************************************************************************

.PrintSpaceAndToken

 PHA                    \ Store the character to print on the stack

 JSR TT162              \ Print a space

 PLA                    \ Retrieve the character to print from the stack

 JMP TT27_b2            \ Print the character in A, returning from the
                        \ subroutine using a tail call

