\ ******************************************************************************
\
\       Name: ECMOF
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Switch off the E.C.M. and turn off the dashboard bulb
\
IF _ELECTRON_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ECMOF-1             Contains an RTS
\
ENDIF
\ ******************************************************************************

.ECMOF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Platform

 LDA #0                 \ Set ECMA and ECMP to 0 to indicate that no E.C.M. is
 STA ECMA               \ currently running
 STA ECMP

ELIF _MASTER_VERSION

IF _SNG47

 LDA #0                 \ Set ECMA and ECMP to 0 to indicate that no E.C.M. is
 STA ECMA               \ currently running
 STA ECMP

ELIF _COMPACT

 STZ ECMA               \ Set ECMA and ECMP to 0 to indicate that no E.C.M. is
 STZ ECMP               \ currently running

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Platform

 JSR ECBLB              \ Update the E.C.M. indicator bulb on the dashboard

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JMP ECBLB              \ Update the E.C.M. indicator bulb on the dashboard and
                        \ return from the subroutine using a tail call

ELIF _NES_VERSION

 LDY #2                 \ Flush the sound channels for sound Y = 2 to stop the
 JMP FlushSpecificSound \ sound of the E.C.M. and return from the subroutine
                        \ using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 LDA #72                \ Call the NOISE routine with A = 72 to make the sound
 BNE NOISE              \ of the E.C.M. being turned off and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

ELIF _C64_VERSION

 LDY #sfxecm            \ Call the NOISEOFF routine with A = sfxecm to turn off
 JMP NOISEOFF           \ the sound of the E.C.M. and return from the subroutine
                        \ using a tail call

ENDIF

