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

 STX XSAV
 LDA #&82
 LDX XSAV
 STX Q
 JSR DVID4
 LDA #&9A
 JSR tube_write
 LDA P
 JSR tube_write
 LDA YSAV
 JSR tube_write
 LDX XSAV
 INX
 CPX #&0D
 BCC HAL1
 LDA #&10

.HAL6

 STA XSAV
 LDA #&9B
 JSR tube_write
 LDA XSAV
 JSR tube_write
 LDA XSAV
 CLC
 ADC #&10
 BNE HAL6
 RTS

