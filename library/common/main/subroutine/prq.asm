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

IF NOT(_NES_VERSION)

 JSR TT27               \ Print the text token in A

 LDA #'?'               \ Print a question mark and return from the
 JMP TT27               \ subroutine using a tail call

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A

 LDA #'?'               \ Print a question mark and return from the
 JMP TT27_b2            \ subroutine using a tail call

ENDIF

