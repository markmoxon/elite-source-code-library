\ ******************************************************************************
\
\       Name: POSWRCH
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character on the printer only
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to send to the printer
\
\ ******************************************************************************

.POSWRCH

 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ following call to NVOSWRCH

 LDA #1                 \ Send ASCII 1 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "send the next character to the
                        \ printer only"

 PLA                    \ Retrieve A from the stack

 JMP NVOSWRCH           \ Send the character in A to the printer using the
                        \ non-vectored OSWRCH, which prints the character on the
                        \ printer, and return from the subroutine using a tail
                        \ call

