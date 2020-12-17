\ ******************************************************************************
\       Name: DOT
\    Summary: Implement the #DOdot command (draw a dot)
\ ******************************************************************************

.DOT

 LDY #2
 LDA (OSSC),Y
 STA X1
 INY
 LDA (OSSC),Y
 STA Y1
 INY
 LDA (OSSC),Y
 STA COL
 CMP #WHITE2
 BNE CPIX2

