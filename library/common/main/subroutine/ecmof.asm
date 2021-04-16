\ ******************************************************************************
\
\       Name: ECMOF
\       Type: Subroutine
\   Category: Sound
\    Summary: Switch off the E.C.M.
\
\ ------------------------------------------------------------------------------
\
\ Switch the E.C.M. off, turn off the dashboard bulb and make the sound of the
\ E.C.M. switching off).
\
IF _MASTER_VERSION \ Comment
\ Other entry points:
\
\   ECMOF-1             \ Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _MASTER_VERSION \ Platform

 RTS                    \ Return from the subroutine

ENDIF

.ECMOF

 LDA #0                 \ Set ECMA and ECMB to 0 to indicate that no E.C.M. is
 STA ECMA               \ currently running
 STA ECMP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 JSR ECBLB              \ Update the E.C.M. indicator bulb on the dashboard

ELIF _MASTER_VERSION

 JMP ECBLB              \ Update the E.C.M. indicator bulb on the dashboard and
                        \ return from the subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDA #72                \ Call the NOISE routine with A = 72 to make the sound
 BNE NOISE              \ of the E.C.M. being turned off and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

ENDIF

