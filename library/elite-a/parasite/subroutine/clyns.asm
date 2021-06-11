\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Elite-A: Utility routines
\    Summary: AJD
\
\ ******************************************************************************

.CLYNS

 LDA #&FF
 STA DTW2
 LDA #&14
 STA YC
 JSR TT67
 LDY #&01 \INY
 STY XC
 DEY
 LDA #&84
 JMP tube_write

