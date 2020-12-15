\ ******************************************************************************
\       Name: DOCKIT
\ ******************************************************************************

.DOCKIT

 LDA #6
 STA RAT2
 LSR A
 STA RAT
 LDA #&1D
 STA CNT2
 LDA SSPR
 BNE P%+5

.GOPLS

 JMP GOPL
 JSR VCSU1 \K3 = ship-spc.stn
 LDA K3+2
 ORA K3+5
 ORA K3+8
 AND #127
 BNE GOPLS
 JSR TA2
 LDA Q
 STA K
 JSR TAS2
 LDY #10
 JSR TAS4
 BMI PH1
 CMP #&23
 BCC PH1\fss.r
 LDY #10
 JSR TAS3
 CMP #&A2\fpl.r
 BCS PH3
 LDA K
\BEQPH10
 CMP #&9D
 BCC PH2
 LDA TYPE
 BMI PH3

.PH2

 JSR TAS6
 JSR TA151

.PH22

 LDX #0
 STX INWK+28
 INX
 STX INWK+27
 RTS

.PH1

 JSR VCSU1
 JSR DCS1
 JSR DCS1
 JSR TAS2
 JSR TAS6
 JMP TA151 \head for sp+

.TN11

 INC INWK+28
 LDA #127
 STA INWK+29
 BNE TN13

.PH3

 LDX #0
 STX RAT2
 STX INWK+30
 LDA TYPE
 BPL PH32
 EOR XX15
 EOR XX15+1
 ASL A
 LDA #2
 ROR A
 STA INWK+29
 LDA XX15
 ASL A
 CMP #12
 BCS PH22
 LDA XX15+1
 ASL A
 LDA #2
 ROR A
 STA INWK+30
 LDA XX15+1
 ASL A
 CMP #12
 BCS PH22

.PH32

 STX INWK+29
 LDA INWK+22
 STA XX15
 LDA INWK+24
 STA XX15+1
 LDA INWK+26
 STA XX15+2
 LDY #16
 JSR TAS4
 ASL A
 CMP #&42
 BCS TN11
 JSR PH22

.TN13

 LDA K3+10
 BNE TNRTS

 ASL NEWB               \ Set bit 7 of the ship's NEWB flags to indicate that
 SEC                    \ the ship has now docked
 ROR NEWB

.TNRTS

 RTS \Docked

