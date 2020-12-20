\ ******************************************************************************
\
\       Name: PAUSE
\       Type: Subroutine
\   Category: Missions
\    Summary: 
\
\ ******************************************************************************

.PAUSE

 JSR PAS1
 BNE PAUSE

.PAL1

 JSR PAS1
 BEQ PAL1
 LDA #0
 STA INWK+31
 LDA #1
 JSR TT66
 JSR LL9

