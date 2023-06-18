\ ******************************************************************************
\
\       Name: plf
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token followed by a newline
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.plf

IF NOT(_NES_VERSION)

 JSR TT27               \ Print the text token in A

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A

ENDIF

 JMP TT67               \ Jump to TT67 to print a newline and return from the
                        \ subroutine using a tail call

