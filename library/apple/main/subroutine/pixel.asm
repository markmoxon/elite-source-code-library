\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a 1-pixel dot, 2-pixel dash or 4-pixel square
\
\ ******************************************************************************

.PIXEL

 STY T1                 \ ???
 STA SC+1
 LSR A
 LSR A
 LSR A
 STA T3
 TAY
 LDA SCTBL,Y
 STA SC
 LDA SC+1
 AND #7
 STA T2
 ASL A
 ASL A
 ADC SCTBH,Y
 STA SC+1
 LDA SCTBX1,X
 ASL A
 LDY ZZ
 BMI P%+4
 ADC #14
 CPY #&50
 LDY SCTBX2,X
 TAX
 BCS PX4
 LDA TWOS3,X
 EOR (SC),Y
 STA (SC),Y
 LDA TWOS3+1,X
 BEQ PX3
 INY
 EOR (SC),Y
 STA (SC),Y
 DEY

.PX3

 LDA T2
 BEQ PX6
 LDA SC+1
 SBC #3
 STA SC+1

.PX4

 LDA TWOS3,X
 EOR (SC),Y
 STA (SC),Y
 LDA TWOS3+1,X
 BEQ PX5
 INY
 EOR (SC),Y
 STA (SC),Y

.PX5

 LDY T1

.PXR1

 RTS

.PX6

 STX T2
 LDX T3
 LDA SCTBL-1,X
 STA SC
 LDA SCTBH2-1,X
 STA SC+1
 LDX T2
 JMP PX4

