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

IF NOT(_ELITE_A_6502SP_PARA)

 LDA #202               \ Load A with token 42 ("RANGE") and fall through into
                        \ prq to print it, followed by a question mark

ELIF _ELITE_A_6502SP_PARA

 LDA #202               \ Print token 42 ("RANGE") followed by a question mark
 JMP prq                \ and return from the subroutine using a tail call

ENDIF

