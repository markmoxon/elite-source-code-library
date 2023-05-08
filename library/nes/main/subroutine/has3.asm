.HAS3

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
.CB6BA
 CHECK_DASHBOARD        \ If the PPU has started drawing the dashboard, switch
                        \ to nametable 0 (&2000) and pattern table 0 (&0000)
 LDX #0
 LDA (addr3,X)
 BEQ CB70B
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
 LDA addr3
 BNE CB706
 DEC addr3+1
.CB706
 DEC addr3
 JMP CB6BA

.CB70B
 TYA
 CLC
 ADC #&25
 STA (addr3,X)
 JMP loop_CB6FC

