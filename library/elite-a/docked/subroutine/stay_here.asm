\ ******************************************************************************
\
\       Name: stay_here
\       Type: Subroutine
\   Category: Elite-A: Buying ships
\    Summary: AJD
\
\ ******************************************************************************

.stay_here

 LDX #&F4
 LDY #&01
 JSR LCASH
 BCC stay_quit
 JSR cour_dock
 JSR DORND
 STA QQ26

IF _ELITE_A_DOCKED

 LDX #&00
 STX &96

.d_31d8

 LDA QQ23+&01,X
 STA &74
 JSR var
 LDA QQ23+&03,X
 AND QQ26
 CLC
 ADC QQ23+&02,X
 LDY &74
 BMI d_31f4
 SEC
 SBC &76
 JMP d_31f7

.d_31f4

 CLC
 ADC &76

.d_31f7

 BPL d_31fb
 LDA #&00

.d_31fb

 LDY &96
 AND #&3F
 STA AVL,Y
 INY
 TYA
 STA &96
 ASL A
 ASL A
 TAX
 CMP #&3F
 BCC d_31d8

ELIF _ELITE_A_6502SP_PARA

 JSR GVL

ENDIF

.stay_quit

 JMP BAY

