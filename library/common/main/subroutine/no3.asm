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

IF NOT(_ELITE_A_FLIGHT)

 LDX DNOIZ              \ Set X to the DNOIZ configuration setting

ELIF _ELITE_A_FLIGHT

 LDY DNOIZ              \ Set Y to the DNOIZ configuration setting

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Label

 BNE NO1                \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as NO1 contains an RTS)

ELIF _ELECTRON_VERSION

 BNE ECMOF-1            \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as ECMOF-1 contains an
                        \ RTS)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT

 BNE KYTB               \ If DNOIZ is non-zero, then sound is disabled, so
                        \ return from the subroutine (as KYTB contains an RTS)

ENDIF

IF _ELECTRON_VERSION \ Electron: Because the Electron only has two sound channels (one noise and one tone), each sound is allocated a priority and a minimum duration, so higher priority sounds take predence over lower priority sounds, but only for their minimum duration

 LDA XX16               \ Set X = to bit 0 of the first SOUND parameter, so
 AND #&01               \ that's the channel number (as the channel is either
 TAX                    \ 0 or 1)

 LDY XX16+8             \ We stored the sound number (0, 8, 16 etc.) in XX16+8
                        \ back in NOS1, so fetch it into Y

 LDA SFX2,Y             \ Fetch this sound's byte from SFX2 into A
                        \
                        \ (This seems wrong. Y is a multiple of 8 (0, 8 ... 72)
                        \ rather than the actual sound number (0-9), and there
                        \ are only 10 bytes at SFX2, so this doesn't feel
                        \ correct - surely Y should be divided by 8 before
                        \ fetching the relevant SFX2 byte?)

 CMP SFXPR,X            \ If the new sound's SFX2 byte is less than the current
 BCC ECMOF-1            \ channel's SFXPR value, return from the subroutine as
                        \ the current sound has a higher priority than the new
                        \ one (as ECMOF-1 contains an RTS)

 STA SFXPR,X            \ Otherwise the new sound is a higher priority sound, so
                        \ store the new sound's SFX2 byte as the channel's new
                        \ SFXPR priority

 AND #%00001111         \ And store the low nibble of the SFX2 byte in the
 STA SFXDU,X            \ channel's new SFXDU duration

ENDIF

IF NOT(_ELITE_A_FLIGHT)

 LDX #LO(XX16)          \ Otherwise set (Y X) to point to the sound block in
 LDY #HI(XX16)          \ XX16

ELIF _ELITE_A_FLIGHT

 LDX #LO(XX16)          \ AJD

ENDIF

 LDA #7                 \ Call OSWORD 7 to makes the sound, as described in the
 JMP OSWORD             \ documentation for variable SFX, and return from the
                        \ subroutine using a tail call

