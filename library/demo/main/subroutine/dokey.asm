\ ******************************************************************************
\
\       Name: DOKEY
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for the seven primary flight controls
\  Deep dive: The key logger
\             The docking computer
\
\ ------------------------------------------------------------------------------
\
\ Scan for the seven primary flight controls (or the equivalent on joystick),
\ pause and configuration keys, and secondary flight controls, and update the
\ key logger accordingly. Specifically:
\
\   * If we are on keyboard configuration, clear the key logger and update it
\     for the seven primary flight controls, and update the pitch and roll
\     rates accordingly.
\
\   * If we are on joystick configuration, clear the key logger and jump to
\     DKJ1, which reads the joystick equivalents of the primary flight
\     controls.
\
\ Both options end up at DK4 to scan for other keys, beyond the seven primary
\ flight controls.
\
\ ******************************************************************************

.DOKEY

 LDA $41                \ ???
 BMI $47A2
 JSR $4797
 LDA $0D5D
 BEQ L481D
 JSR $4231
 LDA #$60
 STA $61
 ORA #$80
 STA $69
 STA $9B
 LDA $8C
 STA $6E
 LDA $0D5B
 BEQ L47D7
 ASL A
 JSR $2049
 JMP L47DA
.L47D7
 JSR $22D3
.L47DA
 LDA $6E
 CMP #$20
 BCC L47E2
 LDA #$20
.L47E2
 STA $8C
 LDA #$FF
 LDX #$00
 LDY $6F
 BEQ L47F1
 BMI L47EF
 INX
.L47EF
 STA $42,X
.L47F1
 LDA #$80
 LDX #$00
 ASL $70
 BEQ L480A
 BCC L47FC
 INX
.L47FC
 BIT $70
 BPL L4806
 LDA #$40
 STA $9C
 LDA #$00
.L4806
 STA $44,X
 LDA $9C
.L480A
 STA $9C
 LDA #$80
 LDX #$00
 ASL $71
 BEQ L481B
 BCS L4817
 INX
.L4817
 STA $46,X
 LDA $9D
.L481B
 STA $9D
.L481D
 LDX $9C
 LDA #$07
 LDY $44
 BEQ L4828
 JSR $287B
.L4828
 LDY $45
 BEQ L482F
 JSR $288B
.L482F
 STX $9C
 ASL A
 LDX $9D
 LDY $46
 BEQ L483B
 JSR $288B
.L483B
 LDY $47
 BEQ L4842
 JSR $287B
.L4842
 STX $9D
