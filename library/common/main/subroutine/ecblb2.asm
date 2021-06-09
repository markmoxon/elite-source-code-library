\ ******************************************************************************
\
\       Name: ECBLB2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Start up the E.C.M. (indicator, start countdown and make sound)
\
\ ------------------------------------------------------------------------------
\
\ Light up the E.C.M. indicator bulb on the dashboard, set the E.C.M. countdown
\ timer to 32, and start making the E.C.M. sound.
\
\ ******************************************************************************

.ECBLB2

 LDA #32                \ Set the E.C.M. countdown timer in ECMA to 32
 STA ECMA

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 ASL A                  \ Call the NOISE routine with A = 64 to make the sound
 JSR NOISE              \ of the E.C.M. being switched on

ENDIF

                        \ Fall through into ECBLB to light up the E.C.M. bulb

