.HAS3

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
.CB6BA
 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
 LDX #0
 LDA (SC2,X)
 BEQ CB70B
 LDX patternBufferHi
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDA (SC),Y
 BEQ CB6F8
 LDA #1
.loop_CB6E2
 STA T
 AND (SC),Y
 BNE CB6EF
 LDA T
 SEC
 ROL A
 JMP loop_CB6E2

.CB6EF
 LDA T
 ORA (SC),Y
 STA (SC),Y
.loop_CB6F5
 LDY YSAV
 RTS

.CB6F8
 LDA #&FF
 STA (SC),Y
.loop_CB6FC
 DEC R
 BEQ loop_CB6F5
 LDA SC2
 BNE CB706
 DEC SC2+1
.CB706
 DEC SC2
 JMP CB6BA

.CB70B
 TYA
 CLC
 ADC #&25
 STA (SC2,X)
 JMP loop_CB6FC

