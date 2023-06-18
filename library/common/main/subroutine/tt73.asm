\ ******************************************************************************
\
\       Name: TT73
\       Type: Subroutine
\   Category: Text
\    Summary: Print a colon
\
\ ******************************************************************************

.TT73

IF NOT(_NES_VERSION)

 LDA #':'               \ Set A to ASCII ":" and fall through into TT27 to
                        \ actually print the colon

ELIF _NES_VERSION

 LDA #':'               \ Print a colon, returning from the subroutine using a
 JMP TT27_b2            \ tail call

ENDIF

