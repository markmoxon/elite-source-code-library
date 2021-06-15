\ ******************************************************************************
\
\       Name: DOKEY_FLIGHT
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.DOKEY_FLIGHT

 JSR U%                 \ Copy of DOKEY
 LDA QQ22+1
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
 LDA auto
 BEQ d_4526

.auton

 JSR ZINF
 LDA #&60
 STA INWK+14
 ORA #&80
 STA INWK+22
 STA TYPE
 LDA DELTA \ ? Too Fast
 STA INWK+27
 JSR DOCKIT
 LDA INWK+27
 CMP #&16
 BCC d_44e3
 LDA #&16

.d_44e3

 STA DELTA
 LDA #&FF
 LDX #&00
 LDY INWK+28
 BEQ d_44f3
 BMI d_44f0
 INX

.d_44f0

 STA KY1,X

.d_44f3

 LDA #&80
 LDX #&00
 ASL INWK+29
 BEQ d_450f
 BCC d_44fe
 INX

.d_44fe

 BIT INWK+29
 BPL d_4509
 LDA #&40
 STA JSTX
 LDA #&00

.d_4509

 STA KY3,X
 LDA JSTX

.d_450f

 STA JSTX
 LDA #&80
 LDX #&00
 ASL INWK+30
 BEQ d_4523
 BCS d_451d
 INX

.d_451d

 STA KY5,X
 LDA JSTY

.d_4523

 STA JSTY

.d_4526

 LDX JSTX
 LDA #&07
 LDY KY3
 BEQ d_4533
 JSR BUMP2

.d_4533

 LDY KY4
 BEQ d_453b
 JSR REDU2

.d_453b

 STX JSTX
 ASL A
 LDX JSTY
 LDY KY5
 BEQ d_454a
 JSR REDU2

.d_454a

 LDY KY6
 BEQ d_4552
 JSR BUMP2

.d_4552

 STX JSTY

