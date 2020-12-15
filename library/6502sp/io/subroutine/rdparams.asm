\ ******************************************************************************
\
\       Name: RDPARAMS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the #RDPARAMS command (start receiving a new set of
\             parameters for updating the dashboard)
\
\ ******************************************************************************

.RDPARAMS

 LDA #0                 \ Set PARANO = 0 to point to the position of the next
 STA PARANO             \ free byte in the PARAMS buffer (i.e. reset the buffer)

 LDA #137               \ Execute a USOSWRCH 137 command so subsequent OSWRCH
 JMP USOSWRCH           \ calls from the parasite can send parameters that get
                        \ added to PARAMS, and return from the subroutine using
                        \ a tail call

