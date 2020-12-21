\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Implement the OSWORD 240 command (draw a pixel)
\
\ ******************************************************************************

.PIXEL

 LDY #0
 LDA (OSSC),Y
 STA Q

 INY
 INY

.PXLO

 LDA (OSSC),Y
 STA P

 AND #7
 BEQ PX5

 TAX
 LDA PXCL,X
 STA S
 INY
 LDA (OSSC),Y
 TAX
 INY
 LDA (OSSC),Y
 STY T1
 TAY

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TXA
 AND #&FC
 ASL A
 STA SC
 BCC P%+4
 INC SC+1
 TYA
 AND #7
 TAY
 TXA
 AND #3
 TAX
 LDA P
 BMI PX3
 CMP #&50
 BCC PX2
 LDA TWOS2,X
 AND S
 EOR (SC),Y
 STA (SC),Y
 LDY T1
 INY
 CPY Q
 BNE PXLO
 RTS

.PX2

 LDA TWOS2,X
 AND S
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL P%+4
 LDY #1
 LDA TWOS2,X
 AND S
 EOR (SC),Y
 STA (SC),Y
 LDY T1
 INY
 CPY Q
 BNE PXLO
 RTS

.PX3

 LDA TWOS,X
 AND S
 EOR (SC),Y
 STA (SC),Y
 LDY T1
 INY
 CPY Q
 BNE PXLO
 RTS

.PX5

 INY
 LDA (OSSC),Y
 TAX
 INY
 LDA (OSSC),Y
 STY T1
 TAY

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 TXA
 AND #&FC
 ASL A
 STA SC
 BCC P%+4
 INC SC+1
 TYA
 AND #7
 TAY
 TXA
 AND #3
 TAX
 LDA P
 CMP #&50
 BCS PX6
 LDA TWOS2,X
 AND #WHITE
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL P%+4
 LDY #1

.PX6

 LDA TWOS2,X
 AND #WHITE
 EOR (SC),Y
 STA (SC),Y
 LDY T1
 INY
 CPY Q
 BEQ P%+5
 JMP PXLO
 RTS

