\ ******************************************************************************
\
\       Name: PrintMessage
\       Type: Subroutine
\   Category: Text
\    Summary: Print a message in the middle of the screen (used for "GAME OVER"
\             and demo missile messages only)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\   Y                   The length of time to leave the message on-screen
\
\ ******************************************************************************

.PrintMessage

 PHA                    \ Store A on the stack so we can restore it after the
                        \ following

 STY DLY                \ Set the message delay in DLY to Y

 LDA #%11000000         \ Set the DTW4 flag to %11000000 (justify text, buffer
 STA DTW4               \ entire token including carriage returns)

 LDA #0                 \ Set DTW5 = 0, to reset the size of the message in the
 STA DTW5               \ text buffer at BUF

 PLA                    \ Restore A from the stack

 JSR ex_b2              \ Print the recursive token in A

 JMP StoreMessage       \ Jump to StoreMessage to copy the message from the
                        \ justified text buffer in BUF into the message buffer
                        \ at messageBuffer, returning from the subroutine using
                        \ a tail call

