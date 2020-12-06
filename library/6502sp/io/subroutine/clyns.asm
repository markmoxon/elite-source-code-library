\ ******************************************************************************
\       Name: CLYNS
\ ******************************************************************************

.CLYNS

 LDA #20
 STA YC
 LDA #&6A
 STA SC+1
 JSR TT67
 LDA #0
 STA SC
 LDX #3

.CLYL

 LDY #8

.EE2

 STA (SC),Y
 INY
 BNE EE2
 INC SC+1
 STA (SC),Y
 LDY #&F7

.EE3

 STA (SC),Y
 DEY
 BNE EE3
 INC SC+1
 DEX
 BNE CLYL
\INX\STXSC

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

