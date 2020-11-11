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
 LDA #2
 JSR NVOSWRCH
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

.^sent

 LDA #3
 JSR NVOSWRCH
 PLA

.nottosend

 JMP PUTBACK

