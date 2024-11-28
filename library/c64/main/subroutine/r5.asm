\ ******************************************************************************
\
\       Name: R5
\       Type: Subroutine
\   Category: Text
\    Summary: Make a beep and jump back into the character-printing routine at
\             CHPR
\
\ ******************************************************************************

.R5

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

