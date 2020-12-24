\ ******************************************************************************
\
\       Name: LOIN (Part 4 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\
\ ******************************************************************************

.DOWN

 LDA #&88
 AND COL
 STA LI200+1
 LDA #&44
 AND COL
 STA LI210+1
 LDA #&22
 AND COL
 STA LI220+1
 LDA #&11
 AND COL
 STA LI230+1
 LDA SC
 SBC #&F8
 STA SC
 LDA SC+1
 SBC #0
 STA SC+1
 TYA
 EOR #&F8
 TAY
 LDA SWAP
 BEQ LI191
 LDA R
 BEQ LI200+6
 CMP #2
 BCC LI210+6
 CLC
 BEQ LI220+6
 BNE LI230+6

.LI191

 DEX
 LDA R
 BEQ LI200
 CMP #2
 BCC LI210
 CLC
 BEQ LI220
 BNE LI230

.LI200

 LDA #&88
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX
 LDA S
 ADC Q
 STA S
 BCC LI210
 CLC
 INY
 BEQ LI201

.LI210

 LDA #&44
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX
 LDA S
 ADC Q
 STA S
 BCC LI220
 CLC
 INY
 BEQ LI211

.LI220

 LDA #&22
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX2
 LDA S
 ADC Q
 STA S
 BCC LI230
 CLC
 INY
 BEQ LI221

.LI230

 LDA #&11
 EOR (SC),Y
 STA (SC),Y
 LDA S
 ADC Q
 STA S
 BCC LI240
 CLC
 INY
 BEQ LI231

.LI240

 DEX
 BEQ LIEX2
 LDA SC
 ADC #8
 STA SC
 BCC LI200
 INC SC+1
 CLC
 BCC LI200

.LI201

 INC SC+1
 INC SC+1
 LDY #&F8
 BNE LI210

.LI211

 INC SC+1
 INC SC+1
 LDY #&F8
 BNE LI220

.LI221

 INC SC+1
 INC SC+1
 LDY #&F8
 BNE LI230

.LI231

 INC SC+1
 INC SC+1
 LDY #&F8
 BNE LI240

.LIEX2

 RTS

