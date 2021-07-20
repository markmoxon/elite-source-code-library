\ ******************************************************************************
\
\       Name: CHPR
\       Type: Subroutine
\   Category: Text
\    Summary: AJD
\
\ ******************************************************************************

.CHPR

 JSR tube_get
 STA XC
 JSR tube_get
 STA YC
 JSR tube_get
 CMP #&20
 BNE tube_wrch
 LDA #&09

.tube_wrch

 STA save_a             \ Like CHPR
 STX save_x
 STY save_y
 TAY
 BMI tube_func
 BEQ wrch_quit
 CMP #&7F
 BEQ wrch_del
 CMP #&20
 BEQ wrch_spc
 BCS wrch_char
 CMP #&0A
 BEQ wrch_nl
 CMP #&0D
 BEQ wrch_cr
 CMP #&09
 BNE wrch_quit

.wrch_tab

 INC XC

.wrch_quit

 LDY save_y
 LDX save_x
 LDA save_a
 RTS

.wrch_char

 JSR wrch_font
 INC XC
 LDY #&07

.wrch_or

 LDA (font),Y
 EOR (SC),Y \ORA (SC),Y
 STA (SC),Y
 DEY
 BPL wrch_or
 BMI wrch_quit

.wrch_del

 DEC XC
 LDA #&20
 JSR wrch_font
 LDY #&07

.wrch_sta

 LDA (font),Y
 STA (SC),Y
 DEY
 BPL wrch_sta
 BMI wrch_quit

.wrch_nl

 INC YC
 JMP wrch_quit

.wrch_cr

 LDA #&01
 STA XC
 JMP wrch_quit

.wrch_spc

 LDA XC
 CMP #&20
 BEQ wrch_quit
 CMP #&11
 BEQ wrch_quit
 BNE wrch_tab

.wrch_font

 LDX #&BF
 ASL A
 ASL A
 BCC font_c0
 LDX #&C1

.font_c0

 ASL A
 BCC font_cl
 INX

.font_cl

 STA font
 STX font+1
 LDA XC
 ASL A
 ASL A
 ASL A
 STA SC
 LDA YC
 ORA #&60
 STA SC+&01
 RTS

