\ ******************************************************************************
\
\       Name: UNWISE
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Switch the main line-drawing routine between EOR and OR logic
\
\ ------------------------------------------------------------------------------
\
IF _DISC_DOCKED OR _ELITE_A_6502SP_PARA OR _ELITE_A_DOCKED \ Comment
\ This routine toggles the main line-drawing routine between EOR and OR logic,
\ for use when drawing the ship hanger.
\
ELIF _6502SP_VERSION
\ This routine does nothing in the 6502 Second Processor version of Elite. It
\ does have a function in the disc version, so the authors presumably just
\ cleared out the UNWISE routine for the Second Processor version, rather than
\ unplumbing it from the code.
\
ELIF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a draw_mode command. It toggles
\ the main line-drawing routine between EOR and OR logic, for use when drawing
\ the ship hanger.
\
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\ It does this by modifying the instructions in the main line-drawing routine at
\ LOIN/LL30, flipping the drawing logic between the default EOR logic (which
\ merges with whatever is already on screen, allowing us to erase anything we
\ draw for animation purposes) and OR logic (which overwrites the screen,
\ ignoring anything that's already there). We want to use OR logic for drawing
\ the ship hanger, as it looks better and we don't need to animate it).
\
\ The routine name, UNWISE, sums up this approach - if anything goes wrong, the
\ results would be messy.
\
ENDIF
\ Other entry points:
\
\   HA1                 Contains an RTS
\
\ ******************************************************************************

.UNWISE

IF _DISC_DOCKED \ Screen

 LDA LIL2+2             \ Flip bit 6 of LIL2+2 to change the EOR (SC),Y in LIL2
 EOR #%01000000         \ to an ORA (SC),Y (or back again)
 STA LIL2+2

 LDA LIL3+2             \ Flip bit 6 of LIL3+2 to change the EOR (SC),Y in LIL3
 EOR #%01000000         \ to an ORA (SC),Y (or back again)
 STA LIL3+2

 LDA LIL5+2             \ Flip bit 6 of LIL2+2 to change the EOR (SC),Y in LIL5
 EOR #%01000000         \ to an ORA (SC),Y (or back again)
 STA LIL5+2

 LDA LIL6+2             \ Flip bit 6 of LIL2+2 to change the EOR (SC),Y in LIL6
 EOR #%01000000         \ to an ORA (SC),Y (or back again)
 STA LIL6+2

ELIF _ELITE_A_VERSION

 LDA LIL2+2             \ Flip bit 6 of LIL2+2 to change the EOR (SC),Y in LIL2
 EOR #%01000000         \ to an ORA (SC),Y (or back again)
 STA LIL2+2

 STA LIL3+2             \ Change the EOR (SC),Y in LIL3 to an ORA (SC),Y (or
                        \ back again)

 STA LIL5+2             \ Change the EOR (SC),Y in LIL5 to an ORA (SC),Y (or
                        \ back again)

 STA LIL6+2             \ Change the EOR (SC),Y in LIL6 to an ORA (SC),Y (or
                        \ back again)

ENDIF

.HA1

 RTS                    \ Return from the subroutine

