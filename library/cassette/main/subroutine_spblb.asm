\ ******************************************************************************
\
\       Name: SPBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the space station indicator ("S") on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ This draws (or erases) the space station indicator bulb ("S") on the
\ dashboard.
\
\ Other entry points:
\
\   BULB-2              Set the Y screen address
\
\ ******************************************************************************

.SPBLB

 LDA #24*8              \ The space station bulb is in character block number 24
                        \ with each character taking 8 bytes, so this sets the
                        \ low byte of the screen address of the character block
                        \ we want to draw to

 LDX #LO(SPBT)          \ Set (Y X) to point to the character definition in SPBT
 LDY #HI(SPBT)

