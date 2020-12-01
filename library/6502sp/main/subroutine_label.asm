\ ******************************************************************************
\
\       Name: label
\       Type: Subroutine
\   Category: Text
\    Summary: Write a two-byte sequence to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The first character to write to the I/O processor
\
\   Top of stack        The second character to write to the I/O processor
\
\ ******************************************************************************

.label

 JSR OSWRCH             \ Write the character in A to the I/O processor

 PLA                    \ Retrieve the row number from the stack

 JMP OSWRCH             \ Write the character in A to the I/O processor,
                        \ returning from the subroutine using a tail call

