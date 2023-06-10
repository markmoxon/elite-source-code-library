\ ******************************************************************************
\
\       Name: TBRIEF
\       Type: Subroutine
\   Category: Missions
\    Summary: Start mission 3
\
\ ******************************************************************************

IF _MASTER_VERSION \ Comment

\.TBRIEF                \ These instructions are commented out in the original
\LDA TP                 \ source
\ORA #&10
\STA TP
\LDA #199
\JSR DETOK
\JSR YESNO
\BCC BAYSTEP
\LDY #HI(50000)
\LDX #LO(50000)
\JSR LCASH
\INC TRIBBLE
\JMP BAY

ELIF _NES_VERSION

.TBRIEF

 JSR ClearTiles_b3      \ ???

 LDA #&95
 JSR TT66

 LDA TP
 ORA #&10
 STA TP

 LDA #&C7
 JSR DETOK_b2

 JSR subm_8926

 JSR YESNO

 CMP #1
 BNE BAYSTEP

 LDY #&C3
 LDX #&50
 JSR LCASH

 INC TRIBBLE

 JMP BAY

ENDIF

