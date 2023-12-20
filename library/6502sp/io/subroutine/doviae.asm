\ ******************************************************************************
\
\       Name: DOVIAE
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the #VIAE <flag> command (enable/disable interrupts)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #VIAE <flag> command. It updates
\ the 6522 System VIA interrupt enable register (IER) at SHEILA &4E, which
\ allows us to enable and disable interrupts. It is used for enabling and
\ disabling the keyboard interrupt.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of the interrupt enable register (IER)
\
\ ******************************************************************************

.DOVIAE

 STA VIA+&4E            \ Store A in SHEILA &4E

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

