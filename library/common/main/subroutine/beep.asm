\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\
\ ******************************************************************************

.BEEP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Minor

 LDA #32                \ Set A = 32 to denote a short, high beep, and fall
                        \ through into the NOISE routine to make the sound

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT

 LDA #32                \ Call the NOISE routine with A = 32 to make a short,
 BNE NOISE              \ high beep, returning from the subroutine using a tail
                        \ call (this BNE is effectively a JMP as A will never be
                        \ zero)

ELIF _MASTER_VERSION

 LDY #sobeep            \ Call the NOISE routine with Y = 1 to make a short,
 BRA NOISE              \ high beep, returning from the subroutine using a tail
                        \ call

ELIF _C64_VERSION

 LDY #sfxbeep           \ Call the NOISE routine with Y = sfxbeep to make a
 BNE NOISE              \ short, high beep, returning from the subroutine using
                        \ a tail call (this BNE is effectively a JMP as Y will
                        \ never be zero)

ELIF _NES_VERSION

 LDY #3                 \ Call the NOISE routine with Y = 3 to make a short,
 BNE NOISE              \ high beep, returning from the subroutine using a tail
                        \ call (this BNE is effectively a JMP as Y will never be
                        \ zero)

ENDIF

