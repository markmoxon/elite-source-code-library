\ ******************************************************************************
\
\       Name: scan_xin
\       Type: Subroutine
\   Category: Keyboard
\    Summary: AJD
\
\ ******************************************************************************

.scan_xin

 JSR tube_get
 TAX
 JSR DKS4
 JMP tube_put

