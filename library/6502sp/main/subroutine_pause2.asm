\ ******************************************************************************
\       Name: PAUSE2
\ ******************************************************************************

.PAUSE2

 JSR RDKEY              \ Scan the keyboard for a key press
 BNE PAUSE2

 JSR RDKEY              \ Scan the keyboard for a key press
 BEQ PAUSE2

 RTS

