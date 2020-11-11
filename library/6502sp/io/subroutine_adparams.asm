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
 JMP PUTBACK

