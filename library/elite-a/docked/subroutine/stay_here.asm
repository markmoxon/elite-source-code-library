\ ******************************************************************************
\
\       Name: stay_here
\       Type: Subroutine
\   Category: Buying ships
\    Summary: Pay docking fee and refresh prices AJD
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
 STX XX4

.d_31d8

 LDA QQ23+1,X
 STA QQ19+1
 JSR var
 LDA QQ23+3,X
 AND QQ26
 CLC
 ADC QQ23+2,X
 LDY QQ19+1
 BMI d_31f4
 SEC
 SBC QQ19+3
 JMP d_31f7

.d_31f4

 CLC
 ADC QQ19+3

.d_31f7

 BPL d_31fb
 LDA #&00

.d_31fb

 LDY XX4
 AND #&3F
 STA AVL,Y
 INY
 TYA
 STA XX4
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

