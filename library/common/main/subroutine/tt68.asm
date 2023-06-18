\ ******************************************************************************
\
\       Name: TT68
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token followed by a colon
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.TT68

IF NOT(_NES_VERSION)

 JSR TT27               \ Print the text token in A and fall through into TT73
                        \ to print a colon

ELIF _NES_VERSION

 JSR TT27_b2            \ Print the text token in A and fall through into TT73
                        \ to print a colon

ENDIF

