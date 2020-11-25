\ ******************************************************************************
\
\       Name: MT26
\       Type: Subroutine
\   Category: Text
\    Summary: 
\
\ ******************************************************************************

.MT26

 LDA #VIAE
 JSR OSWRCH

 LDA #&81
 JSR OSWRCH

 LDY #8
 JSR DELAY

 JSR FLKB

 LDX #LO(RLINE)
 LDY #HI(RLINE)
 LDA #0
 JSR OSWORD

 BCC P%+4

 LDY #0

 LDA #VIAE
 JSR OSWRCH

 LDA #1
 JSR OSWRCH

 JMP FEED

