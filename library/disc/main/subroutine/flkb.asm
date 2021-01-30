\ ******************************************************************************
\
\       Name: FLKB
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Flush the keyboard buffer
\
\ ******************************************************************************

.FLKB

 LDA #15                \ Call OSBYTE with A = 15 and X <> 0 to flush the input
 TAX                    \ buffer and return from the subroutine using a tail
 JMP OSBYTE             \ call

