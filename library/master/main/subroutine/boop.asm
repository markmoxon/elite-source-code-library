\ ******************************************************************************
\
\       Name: BOOP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a long, low beep
\
\ ******************************************************************************

.BOOP

IF _MASTER_VERSION

 LDY #soboop            \ Call the NOISE routine with Y = 0 to make a long, low
 BRA NOISE              \ beep, returning from the subroutine using a tail call

ELIF _NES_VERSION

 LDY #4                 \ Call the NOISE routine with Y = 4 to make a long, low
 BNE NOISE              \ beep, returning from the subroutine using a tail call
                        \ (this BNE is effectively a JMP as Y will never be
                        \ zero)

ENDIF

