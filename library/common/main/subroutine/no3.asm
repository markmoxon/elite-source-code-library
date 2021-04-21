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

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Label

 BNE NO1                \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as NO1 contains an RTS)

ELIF _ELECTRON_VERSION

 BNE ECMOF-1            \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as ECMOF-1 contains an
                        \ RTS)

 LDA XX16               \ ???
 AND #&01
 TAX
 LDY XX16+8
 LDA SFX+40,Y
 CMP L0BFB,X
 BCC ECMOF-1

 STA L0BFB,X
 AND #&0F
 STA L0BFD,X

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 BNE KYTB               \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as KYTB contains an RTS)

ENDIF

 LDX #LO(XX16)          \ Otherwise set (Y X) to point to the sound block in
 LDY #HI(XX16)          \ XX16

 LDA #7                 \ Call OSWORD 7 to makes the sound, as described in the
 JMP OSWORD             \ documentation for variable SFX, and return from the
                        \ subroutine using a tail call

