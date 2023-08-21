\ ******************************************************************************
\
\       Name: TT147
\       Type: Subroutine
\   Category: Text
\    Summary: Print an error when a system is out of hyperspace range
\
\ ------------------------------------------------------------------------------
\
\ Print "RANGE?" for when the hyperspace distance is too far
\
\ ******************************************************************************

.TT147

IF _NES_VERSION

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #189               \ Print token 29 ("HYPERSPACE ")
 JSR TT27_b2

 JSR TT162              \ Print a space

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

 LDA #202               \ Load A with token 42 ("RANGE") and fall through into
                        \ prq to print it, followed by a question mark

ELIF _ELITE_A_6502SP_PARA

 LDA #202               \ Print token 42 ("RANGE") followed by a question mark
 JMP prq                \ and return from the subroutine using a tail call

ELIF _NES_VERSION

 LDA #202               \ Print token 42 ("RANGE") followed by a question mark
 JSR prq

 JMP DrawScreenInNMI    \ ???

ENDIF

