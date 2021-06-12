\ ******************************************************************************
\
\       Name: MSBAR_FLIGHT
\       Type: Subroutine
\   Category: Elite-A: Dashboard
\    Summary: AJD
\
\ ******************************************************************************

.MSBAR_FLIGHT

 CPX #4
 BCC n_mok
 LDX #3

.n_mok

 JMP MSBAR

