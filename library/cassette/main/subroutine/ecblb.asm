\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the E.C.M. indicator bulb ("E") on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ This draws (or erases) the E.C.M. indicator bulb ("E") on the dashboard.
\
\ ******************************************************************************

.ECBLB

 LDA #7*8               \ The E.C.M. bulb is in character block number 7
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

IF _CASSETTE_VERSION

 LDX #LO(ECBT)          \ Set (Y X) to point to the character definition in
 LDY #HI(ECBT)          \ ECBT. The LDY has no effect, as we overwrite Y with
                        \ the jump to BULB-2, which writes the high byte of SPBT
                        \ into Y. This works as long as ECBT and SPBT are in
                        \ the same page of memory, so perhaps the BNE below got
                        \ changed from BULB to BULB-2 so they could remove the
                        \ LDY, but for some reason it didn't get culled? Who
                        \ knows...

ELIF _DISC_VERSION

 LDX #LO(ECBT)          \ Set (Y X) to point to the character definition in
                        \ ECBT (we set Y below with the jump to BULB-2, which
                        \ writes the high byte of SPBT into Y

ENDIF

 BNE BULB-2             \ Jump down to BULB-2 (this BNE is effectively a JMP as
                        \ A will never be zero)

