\ ******************************************************************************
\
\       Name: DOSVN
\       Type: Subroutine
\   Category: Save and load
\    Summary: Implement the #DOSVN <flag> command (update the "save in progress"
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOSVN <flag> command. It
\ updates the "save in progress" flag in svn
\
\ Arguments:
\
\   A                   The new value of the "save in progress" flag
\
\ ******************************************************************************

.DOSVN

 STA svn                \ Store the new "save in progress" flag in svn

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

