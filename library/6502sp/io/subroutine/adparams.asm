\ ******************************************************************************
\       Name: ADPARAMS
\ ******************************************************************************

.ADPARAMS

 INC PARANO
 LDX PARANO
 STA PARAMS-1,X
 CPX #PARMAX
 BCS P%+3
 RTS
 JSR DIALS

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

