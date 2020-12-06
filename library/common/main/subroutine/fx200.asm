\ ******************************************************************************
\
\       Name: FX200
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Set the behaviour of the Escape and Break keys
\
\ ------------------------------------------------------------------------------
\
\ Performs a *FX 200,X command, which controls the behaviour of the Escape and
\ Break keys.
\
\ ******************************************************************************

.FX200

 LDY #0                 \ Call OSBYTE &C8 (200) with Y = 0, so new value is
 LDA #200               \ set to X, and return from the subroutine using a tail
 JMP OSBYTE             \ call

IF _CASSETTE_VERSION

 RTS                    \ This instruction has no effect, as we already returned
                        \ from the subroutine

ENDIF

