\ ******************************************************************************
\
\       Name: DIL2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.DIL2

 PHA
 LDA #&87
 JSR tube_write
 PLA
 JSR tube_write
 LDA SC
 JSR tube_write
 LDA SC+1
 JSR tube_write
 INC SC+1
 RTS

