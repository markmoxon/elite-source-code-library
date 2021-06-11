\ ******************************************************************************
\
\       Name: controls
\       Type: Subroutine
\   Category: Elite-A: Encyclopedia
\    Summary: AJD
\
\ ******************************************************************************

.controls

 LDX #&03
 JSR menu
 ADC #&56
 PHA
 ADC #&04
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
 INC YC
 PLA
 JSR write_msg3
 JMP l_restart

