\ ******************************************************************************
\
\       Name: NO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound from a prepared sound block
\
\ ------------------------------------------------------------------------------
\
\ Make a sound from a prepared sound block in XX16 (if sound is enabled). See
\ routine NOS1 for details of preparing the XX16 sound block.
\
\ ******************************************************************************

.NO3

 LDX DNOIZ              \ Set X to the DNOIZ configuration setting

IF _CASSETTE_VERSION

 BNE NO1                \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as NO1 contains an RTS)

ELIF _6502SP_VERSION

 BNE KYTB               \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as KYTB contains an RTS)

ENDIF

 LDX #LO(XX16)          \ Otherwise set (Y X) to point to the sound block in
 LDY #HI(XX16)          \ XX16

 LDA #7                 \ Call OSWORD 7 to makes the sound, as described in the
 JMP OSWORD             \ documentation for variable SFX, and return from the
                        \ subroutine using a tail call

