\ ******************************************************************************
\
\       Name: write_card
\       Type: Subroutine
\   Category: Elite-A
\    Summary: AJD
\
\ ******************************************************************************

.write_card

 ASL A
 TAY
 LDA card_addr,Y
 STA &22
 LDA card_addr+1,Y
 STA &23

.card_repeat

 JSR MT1
 LDY #&00
 LDA (&22),Y
 TAX
 BEQ quit_card
 BNE card_check

.card_find

 INY
 INY
 INY
 LDA card_pattern-1,Y
 BNE card_find

.card_check

 DEX
 BNE card_find

.card_found

 LDA card_pattern,Y
 STA XC
 LDA card_pattern+1,Y
 STA YC
 LDA card_pattern+2,Y
 BEQ card_details
 JSR write_msg3
 INY
 INY
 INY
 BNE card_found

.card_details

 JSR MT2
 LDY #&00

.card_loop

 INY
 LDA (&22),Y
 BEQ card_end
 BMI card_msg
 CMP #&20
 BCC card_macro
 JSR DTS
 JMP card_loop

.card_macro

 JSR DT3
 JMP card_loop

.card_msg

 CMP #&D7
 BCS card_pairs
 AND #&7F
 JSR write_msg3
 JMP card_loop

.card_pairs

 JSR msg_pairs
 JMP card_loop

.card_end

 TYA
 SEC
 ADC &22
 STA &22
 BCC card_repeat
 INC &23
 BCS card_repeat

.quit_card

 RTS
