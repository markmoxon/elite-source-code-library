\ ******************************************************************************
\
\       Name: b_14
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Check Delta 14b joystick buttons
\
\ ******************************************************************************

.b_13

 LDA #&00               \ AJD

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

IF _ELITE_A_FLIGHT

 RTS

ELIF _ELITE_A_6502SP_IO

 BPL b_quit

ENDIF


