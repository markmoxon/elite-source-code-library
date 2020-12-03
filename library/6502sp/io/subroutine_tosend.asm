\ ******************************************************************************
\
\       Name: tosend
\       Type: Subroutine
\   Category: Text
\    Summary: Print a printable character and return to the printer routine
\
\ ******************************************************************************

.tosend

 JSR POSWRCH            \ Call POSWRCH to print the character in A on the
                        \ printer only

 JMP sent               \ Jump to sent to turn the printer off and restore the
                        \ USOSWRCH handler, returning from the subroutine using
                        \ a tail call

