\ ******************************************************************************
\
\       Name: DOYC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specified row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The row number
\
\ ******************************************************************************

.DOYC

 STA YC                 \ Store A in YC, which sets the text cursor row number

 PHA                    \ Store the row number on the stack

 LDA #SETYC             \ Set A to the character for moving the text cursor to
                        \ the value in YC

.label

 JSR OSWRCH             \ Send the character in A to the I/O processor for
                        \ printing

 PLA                    \ Retrieve the row number from the stack

 JMP OSWRCH             \ Send the character in A to the I/O processor for
                        \ printing, returning from the subroutine using a tail
                        \ call

