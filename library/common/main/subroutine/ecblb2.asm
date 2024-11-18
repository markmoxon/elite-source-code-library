\ ******************************************************************************
\
\       Name: ECBLB2
\       Type: Subroutine
\   Category: Dashboard
IF NOT(_NES_VERSION)
\    Summary: Start up the E.C.M. (light up the indicator, start the countdown
\             and make the E.C.M. sound)
ELIF _NES_VERSION
\    Summary: Start up the E.C.M. (start the countdown and make the E.C.M.
\             sound)
ENDIF
\
\ ******************************************************************************

.ECBLB2

 LDA #32                \ Set the E.C.M. countdown timer in ECMA to 32
 STA ECMA

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 ASL A                  \ Call the NOISE routine with A = 64 to make the sound
 JSR NOISE              \ of the E.C.M. being switched on

ELIF _NES_VERSION

 LDY #2                 \ Call the NOISE routine with Y = 2 to make the sound
 JMP NOISE              \ of the E.C.M., returning from the subroutine using a
                        \ tail call

ELIF _C64_VERSION

 LDY #sfxecm            \ Call the NOISE routine with Y = sfxecm to make the
 JSR NOISE              \ sound of the E.C.M., returning from the subroutine
                        \ using a tail call

ELIF _APPLE_VERSION

\LDY #sfxecm            \ These instructions are commented out in the original
\JSR NOISE              \ source

ENDIF

IF NOT(_NES_VERSION)

                        \ Fall through into ECBLB to light up the E.C.M. bulb

ENDIF

