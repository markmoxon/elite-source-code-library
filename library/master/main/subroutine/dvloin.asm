\ ******************************************************************************
\
\       Name: DVLOIN
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (A, 24) to (A, 152)
\
\ ------------------------------------------------------------------------------
\
\ This routine is not used in this version of Elite.
\
\ ******************************************************************************

.DVLOIN

 STA X1                 \ Draw a horizontal line from (A, 24) to (A, 152)
 STA X2
 LDA #24
 STA Y1
 LDA #152
 STA Y2
 JMP LL30

