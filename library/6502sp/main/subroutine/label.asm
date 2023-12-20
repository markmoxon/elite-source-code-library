\ ******************************************************************************
\
\       Name: label
\       Type: Subroutine
\   Category: Text
\    Summary: Send a two-byte OSWRCH command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This routine sends a command to the I/O processor, along with the parameter
\ byte from the top of the stack.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The command byte to send to the I/O processor
\
\   Top of stack        The parameter to send to the I/O processor
\
\ ******************************************************************************

.label

 JSR OSWRCH             \ Send the command byte in A to the I/O processor

 PLA                    \ Retrieve the parameter from the stack

 JMP OSWRCH             \ Send the parameter in A to the I/O processor, and
                        \ return from the subroutine using a tail call

