\ ******************************************************************************
\
\       Name: DOCATF
\       Type: Subroutine
\   Category: Save and load
\    Summary: Implement the #DOCATF <flag> command (update the disc catalogue
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOCATF <flag> command. It
\ updates the disc catalogue flag in CATF.
\
\ Arguments:
\
\   A                   The new value of the disc catalogue flag:
\
\                         * 0 = disc is not currently being catalogued
\
\                         * 1 = disc is currently being catalogued
\                       
\ ******************************************************************************

.DOCATF

 STA CATF               \ Store the new value in CATF

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call


