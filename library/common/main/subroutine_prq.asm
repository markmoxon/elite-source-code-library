\ ******************************************************************************
\
\       Name: prq
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token followed by a question mark
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.prq

 JSR TT27               \ Print the text token in A

 LDA #'?'               \ Print a question mark and return from the
 JMP TT27               \ subroutine using a tail call

