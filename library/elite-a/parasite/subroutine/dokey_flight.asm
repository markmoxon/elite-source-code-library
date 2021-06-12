\ ******************************************************************************
\
\       Name: DOKEY_FLIGHT
\       Type: Subroutine
\   Category: Elite-A: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.DOKEY_FLIGHT

 JSR U%                 \ Copy of DOKEY
 LDA &2F
 BEQ d_open
 JMP DK4_FLIGHT

.d_open

 LDA JSTK
 BNE DKJ1
 LDY #&07

.d_44bc

 JSR DKS1
 DEY
 BNE d_44bc
 LDA &033F
 BEQ d_4526

.auton

 JSR ZINF
 LDA #&60
 STA &54
 ORA #&80
 STA &5C
 STA &8C
 LDA &7D \ ? Too Fast
 STA &61
 JSR DOCKIT
 LDA &61
 CMP #&16
 BCC d_44e3
 LDA #&16

.d_44e3

 STA &7D
 LDA #&FF
 LDX #&00
 LDY &62
 BEQ d_44f3
 BMI d_44f0
 INX

.d_44f0

 STA &0301,X

.d_44f3

 LDA #&80
 LDX #&00
 ASL &63
 BEQ d_450f
 BCC d_44fe
 INX

.d_44fe

 BIT &63
 BPL d_4509
 LDA #&40
 STA JSTX
 LDA #&00

.d_4509

 STA &0303,X
 LDA JSTX

.d_450f

 STA JSTX
 LDA #&80
 LDX #&00
 ASL &64
 BEQ d_4523
 BCS d_451d
 INX

.d_451d

 STA &0305,X
 LDA JSTY

.d_4523

 STA JSTY

.d_4526

 LDX JSTX
 LDA #&07
 LDY &0303
 BEQ d_4533
 JSR BUMP2

.d_4533

 LDY &0304
 BEQ d_453b
 JSR REDU2

.d_453b

 STX JSTX
 ASL A
 LDX JSTY
 LDY &0305
 BEQ d_454a
 JSR REDU2

.d_454a

 LDY &0306
 BEQ d_4552
 JSR BUMP2

.d_4552

 STX JSTY

