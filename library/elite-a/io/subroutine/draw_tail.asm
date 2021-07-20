\ ******************************************************************************
\
\       Name: draw_tail
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.draw_tail

 JSR tube_get
 STA X1
 JSR tube_get
 STA Y1
 JSR tube_get
 STA X2
 JSR tube_get
 STA Y2
 JSR tube_get
 STA P

.SC48

 JSR CPIX2              \ Like SC48 in SCAN
 DEC Y1
 JSR CPIX2

 LDA CTWOS+1,X
 AND COL \ iff
 STA COL

 LDA CTWOS+1,X
 AND Y2 \ COL2?
 STA Y2
 LDX P
 BEQ RTS
 BMI d_55db

.VLL1

 DEY
 BPL VL1
 LDY #&07
 DEC SC+&01

.VL1

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BNE VLL1

.RTS

 RTS

.d_55db

 INY
 CPY #&08
 BNE VLL2
 LDY #&00
 INC SC+&01

.VLL2

 INY
 CPY #&08
 BNE VL2
 LDY #&00
 INC SC+&01

.VL2

 LDA COL
 EOR Y2 \ iff drawpix_4
 STA COL
 EOR (SC),Y
 STA (SC),Y
 INX
 BNE VLL2
 RTS

