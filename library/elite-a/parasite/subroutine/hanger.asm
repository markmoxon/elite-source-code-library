\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: AJD
\
\ ******************************************************************************

.HANGER

 LDX #&02

.HAL1

 STX &84
 LDA #&82
 LDX &84
 STX &81
 JSR DVID4
 LDA #&9A
 JSR tube_write
 LDA &1B
 JSR tube_write
 LDA &85
 JSR tube_write
 LDX &84
 INX
 CPX #&0D
 BCC HAL1
 LDA #&10

.HAL6

 STA &84
 LDA #&9B
 JSR tube_write
 LDA &84
 JSR tube_write
 LDA &84
 CLC
 ADC #&10
 BNE HAL6
 RTS

