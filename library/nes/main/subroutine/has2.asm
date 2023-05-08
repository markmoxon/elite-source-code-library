
.HAS2
 STA S
 STY YSAV
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA addr3
 LDA nametableHi
 ADC yLookupHi,Y
 STA addr3+1
 LDA S
 AND #7
 STA T
.CB5D9
 CHECK_DASHBOARD        \ If the PPU has started drawing the dashboard, switch
                        \ to nametable 0 (&2000) and pattern table 0 (&0000)
 LDX #0
 LDA (addr3,X)
 BEQ CB615
 LDX patternTableHi
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
 STA (addr3,X)
.CB61C
 LDA addr3
 CLC
 ADC #&20
 STA addr3
 BCC CB5D9
 INC addr3+1
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
 STA addr3
 LDA nametableHi
 ADC yLookupHi,Y
 STA addr3+1
 TYA
 AND #7
 TAY
.CB647
 CHECK_DASHBOARD        \ If the PPU has started drawing the dashboard, switch
                        \ to nametable 0 (&2000) and pattern table 0 (&0000)
 LDX #0
 LDA (addr3,X)
 BEQ CB699
 LDX patternTableHi
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
 INC addr3
 BNE CB647
 INC addr3+1
 JMP CB647

.CB696
 LDY YSAV
 RTS

.CB699
 TYA
 CLC
 ADC #&25
 STA (addr3,X)
 JMP loop_CB689
