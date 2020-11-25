\ ******************************************************************************
\
\       Name: DOVDU19
\       Type: Subroutine
\   Category: Text
\    Summary: Define a logical colour
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The colour number to define
\
\ ******************************************************************************

.DOVDU19

 PHA                    \ Store A on the stack

 LDA #SETVDU19          \ Set A to the character for doing a VDU 19

 BNE label              \ Jump to label to print the character in A followed by
                        \ the character on the stack, returning from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A is never zero)

