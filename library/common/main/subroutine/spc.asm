\ ******************************************************************************
\
\       Name: spc
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token followed by a space
\
\ ------------------------------------------------------------------------------
\
\ Print a text token (i.e. a character, control code, two-letter token or
\ recursive token) followed by a space.
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.spc

IF NOT(_NES_VERSION)

 JSR TT27               \ Print the text token in A

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A

ENDIF

 JMP TT162              \ Print a space and return from the subroutine using a
                        \ tail call

