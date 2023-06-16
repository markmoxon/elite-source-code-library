\ ******************************************************************************
\
\       Name: TT162
\       Type: Subroutine
\   Category: Text
\    Summary: Print a space
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TT162+2             Jump to TT27 to print the text token in A
\
\ ******************************************************************************

.TT162

 LDA #' '               \ Load a space character into A

IF NOT(_NES_VERSION)

 JMP TT27               \ Print the text token in A and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 JMP TT27_b2            \ Print the text token in A and return from the
                        \ subroutine using a tail call

ENDIF

