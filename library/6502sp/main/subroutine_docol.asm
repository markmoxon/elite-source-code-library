\ ******************************************************************************
\
\       Name: DOCOL
\       Type: Subroutine
\   Category: Text
\    Summary: Set the text colour
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text colour
\
\ ******************************************************************************

.DOCOL

 PHA                    \ Store A on the stack

 LDA #SETCOL            \ Set A to the character for setting the text colour

 BNE label              \ Jump to label to print the character in A followed by
                        \ the character on the stack, returning from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A is never zero)

