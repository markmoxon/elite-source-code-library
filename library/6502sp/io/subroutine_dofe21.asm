\ ******************************************************************************
\       Name: DOFE21
\ ******************************************************************************

.DOFE21

 STA &FE21

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

