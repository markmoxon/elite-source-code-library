\ ******************************************************************************
\
\       Name: write_pod
\       Type: Subroutine
\   Category: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.write_pod

 JSR tube_get
 STA ESCP
 JSR tube_get
 STA HFX
 RTS

