\ ******************************************************************************
\
\       Name: printer
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #printcode <char> command (print a character on the
\             printer and screen)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print on the printer and screen
\
\ ******************************************************************************

.printer

 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ following call to TT26
 
 JSR TT26               \ Call TT26 to print the character in A on-screen

 PLA                    \ Retrieve A from the stack

 CMP #11                \ If A = 11, which normally means "move the cursor up
 BEQ nottosend          \ one line", jump to nottosend to skip sending this
                        \ character to the printer, as you can't roll back time
                        \ when you're printing hard copy
 
 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ following call to NVOSWRCH

 LDA #2                 \ Send ASCII 2 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "start sending characters to the
                        \ printer"

 PLA                    \ Retrieve A from the stack, though this is a bit
                        \ pointless given the next instruction, as they cancel
                        \ each other out
 
 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ following calls to POSWRCH and/or NVOSWRCH
 
 CMP #' '               \ If A is greater than ASCII " ", then it's a printable
 BCS tosend             \ character, so jump to tosend to print the character
                        \ and jump back to sent to turn the printer off and
                        \ finish

 CMP #10                \ If we are printing a line feed, jump to tosend2 to
 BEQ tosend2            \ send it to POSWRCH

 LDA #13                \ Otherwise print a carriage return instead of whatever
 JSR POSWRCH            \ was in A, and jump to sent to turn the printer off and
 JMP sent               \ finish

.tosend2

\CMP #13                \ These instructions are commented out in the original
\BEQ sent               \ source; perhaps they were replaced by the above JMP
                        \ instruction at some point, which does a similar thing
                        \ but in fewer bytes (and without the risk of POSWRCH
                        \ corrupting the value of A)

 LDA #10                \ Call POSWRCH to send a line feed to the printer
 JSR POSWRCH

.sent

 LDA #3                 \ Send ASCII 3 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "stop sending characters to the
                        \ printer"

 PLA                    \ Retrieve A from the stack

.nottosend

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

