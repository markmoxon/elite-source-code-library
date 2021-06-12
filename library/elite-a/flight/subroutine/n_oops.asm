\ ******************************************************************************
\
\       Name: n_oops
\       Type: Subroutine
\   Category: Elite-A: Flight
\    Summary: AJD
\
\ ******************************************************************************

.n_oops

 SEC                    \ reduce damage
 SBC new_shields
 BCC n_shok

