\ ******************************************************************************
\
\       Name: scan_y
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_y

 JSR tube_get
 TAY
 JSR tube_get
 BMI b_14
 LDX KYTB-1,Y
 JSR DKS4
 BPL b_quit

.b_pressed

 LDA #&FF

.b_quit

 JMP tube_put

