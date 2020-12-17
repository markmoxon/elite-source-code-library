\ ******************************************************************************
\
\       Name: SETXC
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #SETXC <column> command (move the text cursor to a
\             specific column)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #SETXC <column> command. It
\ updates the text cursor x-coordinate (i.e. the text column) in XC.
\
\ Arguments:
\
\   A                   The text column
\                       
\ ******************************************************************************

.SETXC

 STA XC                 \ Store the new text column in XC

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

