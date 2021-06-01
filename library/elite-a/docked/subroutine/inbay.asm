\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Elite-A
\    Summary: AJD
\
\ ******************************************************************************

.INBAY

 JSR BRKBK
 JMP icode_set

 EQUB 0
 \ dead entry
 LDA #0
 JSR scramble
 JSR RES2
 JMP TT170

