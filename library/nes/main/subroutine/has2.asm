
.HAS2
 STA S
 STY YSAV
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 LDA S
 AND #7
 STA T
.CB5D9
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX #0
 LDA (SC2,X)
 BEQ CB615
 LDX pattBufferHi
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDY #0
 LDX T
.loop_CB5FF
 LDA (SC),Y
 AND TWOS,X
 BNE CB62A
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 CPY #8
 BNE loop_CB5FF
 JMP CB61C

.CB615
 LDA T
 CLC
 ADC #&34
 STA (SC2,X)
.CB61C
 LDA SC2
 CLC
 ADC #&20
 STA SC2
 BCC CB5D9
 INC SC2+1
 JMP CB5D9

.CB62A
 LDA S
 LDY YSAV
 RTS

.HAL3
 STX R
 STY YSAV
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 TYA
 AND #7
 TAY
.CB647
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX #0
 LDA (SC2,X)
 BEQ CB699
 LDX pattBufferHi
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDA (SC),Y
 BEQ CB685
 LDA #&80
.loop_CB66F
 STA T
 AND (SC),Y
 BNE CB67C
 LDA T
 SEC
 ROR A
 JMP loop_CB66F

.CB67C
 LDA T
 ORA (SC),Y
 STA (SC),Y
 LDY YSAV
 RTS

.CB685
 LDA #&FF
 STA (SC),Y
.loop_CB689
 DEC R
 BEQ CB696
 INC SC2
 BNE CB647
 INC SC2+1
 JMP CB647

.CB696
 LDY YSAV
 RTS

.CB699
 TYA
 CLC
 ADC #&25
 STA (SC2,X)
 JMP loop_CB689
