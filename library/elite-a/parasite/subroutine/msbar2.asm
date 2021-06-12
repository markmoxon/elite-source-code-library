\ ******************************************************************************
\
\       Name: MSBAR2
\       Type: Subroutine
\   Category: Elite-A: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.MSBAR2

 CPX #4
 BCC n_mok
 LDX #3

.n_mok

 JMP MSBAR

