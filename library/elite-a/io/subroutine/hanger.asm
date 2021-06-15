\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: AJD
\
\ ******************************************************************************

.HANGER

 JSR tube_get
 STA picture_1
 JSR tube_get
 STA picture_2
 LDA picture_1
 CLC
 ADC #&60
 LSR A
 LSR A
 LSR A
 ORA #&60
 STA SC+&01
 LDA picture_1
 AND #&07
 STA SC
 LDY #&00
 JSR HAS2
 LDA #&04
 LDY #&F8
 JSR HAS3
 LDY picture_2
 BEQ l_2045
 JSR HAS2
 LDY #&80
 LDA #&40
 JSR HAS3

.l_2045

 RTS

.HA2

 JSR tube_get
 AND #&F8
 STA SC
 LDX #&60
 STX SC+&01
 LDX #&80
 LDY #&01

.HAL7

 TXA
 AND (SC),Y
 BNE HA6
 TXA
 ORA (SC),Y
 STA (SC),Y
 INY
 CPY #&08
 BNE HAL7
 INC SC+&01
 LDY #&00
 BEQ HAL7

.HA6

 RTS

