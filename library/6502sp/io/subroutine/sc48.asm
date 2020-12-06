\ ******************************************************************************
\       Name: SC48 - is like the last half of common/subroutine/scan.asm
\ ******************************************************************************

\  ...................... Scanners  ..............................

.SC48

 LDY #4
 LDA (OSSC),Y
 STA COL
 INY
 LDA (OSSC),Y
 STA X1
 INY
 LDA (OSSC),Y
 STA Y1
 JSR CPIX4
 LDA CTWOS+2,X
 AND COL
 STA X1
 STY Q
 LDY #2
 LDA (OSSC),Y
 ASL A
 INY
 LDA (OSSC),Y
 BEQ RTS
 LDY Q
 TAX
 BCC RTS+1

.VLL1

 DEY
 BPL VL1
 LDY #7
 DEC SC+1
 DEC SC+1

.VL1

 LDA X1
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS
 INY
 CPY #8
 BNE VLL2
 LDY #0
 INC SC+1
 INC SC+1

.VLL2

 INY
 CPY #8
 BNE VL2
 LDY #0
 INC SC+1
 INC SC+1

.VL2

 LDA X1
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE VLL2
 RTS

