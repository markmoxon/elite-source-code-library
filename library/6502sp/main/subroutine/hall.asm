\ ******************************************************************************
\
\       Name: HALL
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Draw the ship hanger by sending an OSWORD 248 command to the I/O
\             processor
\
\ ******************************************************************************

.HALL

 LDA #0
 JSR DOVDU19
 JSR UNWISE
 LDA #0
 JSR TT66
 JSR DORND
 BPL HA7
 AND #3
 STA T
 ASL A
 ASL A
 ASL A
 ADC T
 TAX
 LDY #3
 STY CNT2

.HAL8

 LDY #2

.HAL9

 LDA HATB,X
 STA XX15,Y
 INX
 DEY
 BPL HAL9
 TXA
 PHA
 JSR HAS1
 PLA
 TAX
 DEC CNT2
 BNE HAL8
 LDY #128
 BNE HA9

.HA7

 LSR A
 STA XX15+1
 JSR DORND
 STA XX15
 JSR DORND
 AND #3
 ADC #SH3
 STA XX15+2
 JSR HAS1
 LDY #0

.HA9

 STY HANG+2
 JSR UNWISE
 LDA #248

 LDX #LO(HANG)          \ Set (Y X) to point to the HANG parameter block
 LDY #HI(HANG)
 JMP OSWORD

