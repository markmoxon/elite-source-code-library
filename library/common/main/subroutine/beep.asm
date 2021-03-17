\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ******************************************************************************

.BEEP

IF _CASSETTE_VERSION \ Minor

 LDA #32                \ Set A = 32 to denote a short, high beep, and fall
                        \ through into NOISE to make the sound

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDA #32                \ Call NOISE with A = 32 to make a short, high beep,
 BNE NOISE              \ returning from the subroutine using a tail call (this
                        \ BNE is effectively a JMP as A will never be zero)

ELIF _MASTER_VERSION

 LDY #1                 \ Call NOISE with Y = 1 to make a short, high beep,
 BRA NOISE              \ returning from the subroutine using a tail call

ENDIF

