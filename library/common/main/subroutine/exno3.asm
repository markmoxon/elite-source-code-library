\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make an explosion sound
\
\ ------------------------------------------------------------------------------
\
\ Make the sound of death in the cold, hard vacuum of space. Apparently, in
\ Elite space, everyone can hear you scream.
\
\ This routine also makes the sound of a destroyed cargo canister if we don't
\ get scooping right, the sound of us colliding with another ship, and the sound
\ of us being hit with depleted shields. It is not a good sound to hear.
\
\ ******************************************************************************

.EXNO3

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Master: The Master version has a unique explosion sound

 LDA #16                \ Call the NOISE routine with A = 16 to make the first
 JSR NOISE              \ death sound

 LDA #24                \ Call the NOISE routine with A = 24 to make the second
 BNE NOISE              \ death sound and return from the subroutine using a
                        \ tail call (this BNE is effectively a JMP as A will
                        \ never be zero)

ELIF _ELECTRON_VERSION

 LDA #24                \ Call the NOISE routine with A = 24 to make the
 BNE NOISE              \ death sound and return from the subroutine using a
                        \ tail call (this BNE is effectively a JMP as A will
                        \ never be zero)

ELIF _MASTER_VERSION

 LDY #soexpl            \ Call the NOISE routine with Y = 4 to make the sound of
 JMP NOISE              \ an explosion and return from the subroutine using a
                        \ tail call

ELIF _ELITE_A_FLIGHT

 JSR n_sound10          \ Call n_sound10 make the first death sound

 LDA #24                \ Call the NOISE routine with A = 24 to make the second
 BNE NOISE              \ death sound and return from the subroutine using a
                        \ tail call (this BNE is effectively a JMP as A will
                        \ never be zero)

ELIF _ELITE_A_6502SP_PARA

 JSR sound_10           \ Call sound_10 make the first death sound

 LDA #24                \ Call the NOISE routine with A = 24 to make the
 JMP NOISE              \ death sound and return from the subroutine using a
                        \ tail call
ELIF _C64_VERSION

 LDY #sfxexpl           \ Call the NOISE routine with Y = sfxexpl to make the
 BNE NOISE              \ sound of an explosion, returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as Y
                        \ will never be zero)

ELIF _NES_VERSION

 LDY #13                \ Call the NOISE routine with Y = 13 to make the sound
 BNE NOISE              \ of an explosion, returning from the subroutine using
                        \ a tail call (this BNE is effectively a JMP as Y will
                        \ never be zero)

ENDIF

