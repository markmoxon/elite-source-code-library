\ ******************************************************************************
\       Name: printer
\ ******************************************************************************

.printer

 PHA
 JSR TT26
 PLA
 CMP #11
 BEQ nottosend
 PHA

 LDA #2                 \ Send ASCII 2 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "start sending characters to the
                        \ printer"

 PLA
 PHA
 CMP #32
 BCS tosend
 CMP #10
 BEQ tosend2
 LDA #13
 JSR POSWRCH
 JMP sent

.tosend2

\CMP#13\BEQsent
 LDA #10
 JSR POSWRCH

.sent

 LDA #3                 \ Send ASCII 3 to the printer using the non-vectored
 JSR NVOSWRCH           \ OSWRCH, which means "stop sending characters to the
                        \ printer"

 PLA

.nottosend

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

