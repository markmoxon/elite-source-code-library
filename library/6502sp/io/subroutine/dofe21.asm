\ ******************************************************************************
\
\       Name: DOFE21
\       Type: Subroutine
\   Category: Flight
\    Summary: Implement the #DOFE21 <flag> command (show the energy bomb effect)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOFE21 <flag> command. It takes
\ the argument and stores it in SHEILA &21 to change the palette.
\
\ See page 379 of the "Advanced User Guide for the BBC Micro" by Bray, Dickens
\ and Holmes for an explanation of palette bytes.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of SHEILA &21
\
\ ******************************************************************************

.DOFE21

 STA &FE21              \ Store the new value in SHEILA &21

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

