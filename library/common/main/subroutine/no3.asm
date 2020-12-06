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

 LDX #LO(XX16)          \ Otherwise call OSWORD 7, with (Y X) pointing to the
 LDY #HI(XX16)          \ sound block in XX16. This makes the sound as
 LDA #7                 \ described in the documentation for variable SFX,
 JMP OSWORD             \ and returns from the subroutine using a tail call

