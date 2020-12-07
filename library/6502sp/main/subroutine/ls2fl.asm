\ ******************************************************************************
\
\       Name: LS2FL
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Send the ball line heap to the I/O processor for drawing
\
\ ******************************************************************************

.LS2FL

 LDY LSP

.WP3

 STY T
 BEQ WP1
 LDA #&81
 JSR OSWRCH
 TYA
 BMI WP2
 SEC
 ROL A
 JSR OSWRCH
 LDY #0

.WPL1

 LDA LSX2,Y
 JSR OSWRCH
 LDA LSY2,Y
 JSR OSWRCH
 INY
 LDA LSX2,Y
 JSR OSWRCH
 LDA LSY2,Y
 JSR OSWRCH
 INY
 CPY T
 BCC WPL1

.WP1

 RTS

.WP2

 ASL A
 ADC #4
 JSR OSWRCH
 LDY #126
 JSR WPL1
 LDY #126
 JMP WP3

