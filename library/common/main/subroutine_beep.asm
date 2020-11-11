\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ******************************************************************************

.BEEP

 LDA #32                \ Set A = 32 to denote a short, high beep, and fall
                        \ through into NOISE to make the sound

IF _6502SP_VERSION

 BNE NOISE              \ Call NOISE, as NOISE doesn't directly follow BEEP in
                        \ the 6502SP version
ENDIF

