\ ******************************************************************************
\
\       Name: FX200
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Set the behaviour of the ESCAPE and BREAK keys
\
\ ------------------------------------------------------------------------------
\
\ This is the equivalent of a *FX 200 command, which controls the behaviour of
\ the ESCAPE and BREAK keys.
\
\ Arguments:
\
\   X                   Controls the behaviour as follows:
\
\                         * 0 = Enable ESCAPE key
\                               Normal BREAK key action
\
\                         * 1 = Disable ESCAPE key
\                               Normal BREAK key action
\
\                         * 2 = Enable ESCAPE key
\                               Clear memory if the BREAK key is pressed
\
\                         * 3 = Disable ESCAPE key
\                               Clear memory if the BREAK key is pressed
\
\ ******************************************************************************

.FX200

 LDY #0                 \ Call OSBYTE 200 with Y = 0, so the new value is set to
 LDA #200               \ X, and return from the subroutine using a tail call
 JMP OSBYTE

IF _CASSETTE_VERSION OR _DISC_VERSION

 RTS                    \ This instruction has no effect, as we already returned
                        \ from the subroutine

ENDIF

