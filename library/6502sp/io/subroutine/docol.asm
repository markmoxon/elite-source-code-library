\ ******************************************************************************
\
\       Name: DOCOL
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #SETCOL <colour> command (set the current colour)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #SETCOL <colour> command. It
\ updates the current colour in COL.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new colour
\
\ ******************************************************************************

.DOCOL

 STA COL                \ Store the new colour in COL

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

