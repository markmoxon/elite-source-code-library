\ ******************************************************************************
\
\       Name: b_14
\       Type: Subroutine
\   Category: Elite-A
\    Summary: Check Voltmace Delta 14 joystick buttons AJD
\
\ ******************************************************************************

.b_13

 LDA #&00

.b_14

 TAX
 EOR b_table-1,Y
 BEQ b_quit
 STA &FE60
 AND #&0F
 AND &FE60
 BEQ b_pressed
 TXA
 BMI b_13
 RTS

