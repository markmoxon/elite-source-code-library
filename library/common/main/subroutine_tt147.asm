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

 LDA #202               \ Load A with token 42 ("RANGE") and fall through into
                        \ prq to print it, followed by a question mark

