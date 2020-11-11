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
\ ******************************************************************************

.ECMOF

 LDA #0                 \ Set ECMA and ECMB to 0 to indicate that no E.C.M. is
 STA ECMA               \ currently running
 STA ECMP

 JSR ECBLB              \ Update the E.C.M. indicator bulb on the dashboard

 LDA #72                \ Call the NOISE routine with A = 72 to make the sound
 BNE NOISE              \ of the E.C.M. being turned off and return from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A will never be zero)

