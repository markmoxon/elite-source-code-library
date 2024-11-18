\ ******************************************************************************
\
\       Name: ZES2k
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.ZES2k

 LDA #0                 \ ???
 STX SC+1

.ZEL1k

 STA (SC),Y
 DEY
 BNE ZEL1k
 RTS

