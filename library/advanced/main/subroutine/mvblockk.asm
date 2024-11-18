\ ******************************************************************************
\
\       Name: mvblockK
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.mvblockK

 LDY #0

.mvbllop

 LDA (V),Y
 STA (SC),Y
 DEY
 BNE mvbllop
 INC V+1
 INC SC+1
 DEX
 BNE mvbllop
 RTS

