\ ******************************************************************************
\       Name: ECBLB
\ ******************************************************************************

.ECBLB

 LDA #8*14
 STA SC
 LDA #&7A
 STA SC+1
 LDY #15

.BULL2

 LDA ECBT,Y
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL BULL2

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

