\ ******************************************************************************
\       Name: BRIEF
\ ******************************************************************************

.BRIEF

 LSR TP                 \ Set bit 0 of TP to indicate mission 1 is in progress
 SEC
 ROL TP

 JSR BRIS

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #CON
 STA TYPE
 JSR NWSHP
 LDA #1
 JSR DOXC
 STA INWK+7
 JSR TT66
 LDA #64
 STA MCNT

.BRL1

 LDX #127
 STX INWK+29
 STX INWK+30
 JSR LL9
 JSR MVEIT
 DEC MCNT
 BNE BRL1

.BRL2

 LSR INWK
 INC INWK+6
 BEQ BR2
 INC INWK+6
 BEQ BR2
 LDX INWK+3
 INX
 CPX #112
 BCC P%+4
 LDX #112
 STX INWK+3
 JSR LL9
 JSR MVEIT
 JMP BRL2

.BR2

 INC INWK+7
 LDA #10
 BNE BRPS

.BRIS

 LDA #216
 JSR DETOK
 LDY #100
 JMP DELAY

