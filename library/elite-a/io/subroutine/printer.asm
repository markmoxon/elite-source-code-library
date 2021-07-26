\ ******************************************************************************
\
\       Name: printer
\       Type: Subroutine
\   Category: Text
\    Summary: AJD
\
\ ******************************************************************************

.printer

 LDA #2
 JSR print_safe
 LDA #'@'
 JSR print_esc
 LDA #'A'
 JSR print_esc
 LDA #8
 JSR print_wrch
 LDA #&60
 STA SC+1
 LDA #0
 STA SC

.print_view

 LDA #'K'
 JSR print_esc
 LDA #0
 JSR print_wrch
 LDA #1
 JSR print_wrch

.print_outer

 LDY #7
 LDX #&FF

.print_copy

 INX
 LDA (SC),Y
 STA print_bits,X
 DEY
 BPL print_copy
 LDA SC+1
 CMP #&78
 BCC print_inner

.print_radar

 LDY #7
 LDA #0

.print_split

 ASL print_bits,X
 BCC print_merge
 ORA print_tone,Y

.print_merge

 DEY
 BPL print_split
 STA print_bits,X
 DEX
 BPL print_radar

.print_inner

 LDY #7

.print_block

 LDX #7

.print_slice

 ASL print_bits,X
 ROL A
 DEX
 BPL print_slice
 JSR print_wrch
 DEY
 BPL print_block

.print_next

 CLC
 LDA SC
 ADC #8
 STA SC
 BNE print_outer
 LDA #13
 JSR print_wrch
 INC SC+1
 LDX SC+1
 INX
 BPL print_view
 LDA #3
 JMP print_safe

\JSR print_safe         \ These instructions are commented out in the original
\JMP tube_put           \ source


.print_tone

 EQUB &03, &0C, &30, &C0, &03, &0C, &30, &C0


.print_esc

 PHA
 LDA #27
 JSR print_wrch
 PLA

.print_wrch

 PHA
 LDA #1
 JSR print_safe
 PLA

.print_safe

 PHA
 TYA
 PHA
 TXA
 PHA
 TSX
 LDA &103,X

 JSR rawrch             \ Print the character by calling the VDU character
                        \ output routine in the MOS

 PLA
 TAX
 PLA
 TAY
 PLA
 RTS

