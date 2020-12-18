\ ******************************************************************************
\
\       Name: SETYC
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #SETYC <row> command (move the text cursor to a
\             specific row)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #SETYC <row> command. It updates
\ the text cursor y-coordinate (i.e. the text row) in YC.
\
\ Arguments:
\
\   A                   The text row
\
\ ******************************************************************************

.SETYC

 STA YC                 \ Store the new text row in YC

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

