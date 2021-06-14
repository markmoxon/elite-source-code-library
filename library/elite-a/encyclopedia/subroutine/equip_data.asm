\ ******************************************************************************
\
\       Name: equip_data
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: AJD
\
\ ******************************************************************************

.equip_data

 LDX #&04
 JSR menu
 ADC #&6B
 PHA
 SBC #&0C
 PHA
 LDA #&20
 JSR TT66
 JSR MT1
 LDA #&0B
 STA XC
 PLA
 JSR write_msg3
 JSR NLIN4
 JSR MT2
 JSR MT13
 INC YC
 INC YC
 LDA #&01
 STA XC
 PLA
 JSR write_msg3
 JMP l_restart

