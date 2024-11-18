\ ******************************************************************************
\
\       Name: ZESNEW
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.ZESNEW

 LDA #0

.ZESNEWL

 STA (SC),Y
 INY
 BNE ZESNEWL
 RTS

