\ ******************************************************************************
\
\       Name: update_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard colours to reflect whether we have an escape
\             pod
\
\ ******************************************************************************

.update_pod

 LDA #&8F               \ AJD
 JSR tube_write
 LDA ESCP
 JSR tube_write
 LDA HFX
 JMP tube_write

