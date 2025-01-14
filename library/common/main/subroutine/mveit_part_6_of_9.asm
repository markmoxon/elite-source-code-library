\ ******************************************************************************
\
IF NOT(_ELITE_A_6502SP_PARA)
\       Name: MVEIT (Part 6 of 9)
ELIF _ELITE_A_6502SP_PARA
\       Name: MVEIT_FLIGHT (Part 6 of 6)
ENDIF
\       Type: Subroutine
\   Category: Moving
\    Summary: Move current ship: Move the ship in space according to our speed
\  Deep dive: A sense of scale
\
\ ------------------------------------------------------------------------------
\
\ This routine has multiple stages. This stage does the following:
\
\   * Move the ship in space according to our speed (we already moved it
\     according to its own speed in part 3).
\
\ We do this by subtracting our speed (i.e. the distance we travel in this
\ iteration of the loop) from the other ship's z-coordinate. We subtract because
\ they appear to be "moving" in the opposite direction to us, and the whole
\ MVEIT routine is about moving the other ships rather than us (even though we
\ are the one doing the moving).
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MV45                Rejoin the MVEIT routine after the rotation, tactics and
\                       scanner code
\
\ ******************************************************************************

.MV45

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA DELTA              \ Set R to our speed in DELTA
 STA R

 LDA #%10000000         \ Set A to zeroes but with bit 7 set, so that (A R) is
                        \ a 16-bit number containing -R, or -speed

 LDX #6                 \ Set X to the z-axis so the call to MVT1 does this:
 JSR MVT1               \
                        \ (z_sign z_hi z_lo) = (z_sign z_hi z_lo) + (A R)
                        \                    = (z_sign z_hi z_lo) - speed

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: As the Electron has no suns, we don't need to check whether we are trying to rotate the sun, unlike in the other versions

 LDA TYPE               \ If the ship type is not the sun (129) then skip the
 AND #%10000001         \ next instruction, otherwise return from the subroutine
 CMP #129               \ as we don't need to rotate the sun around its origin.
 BNE P%+3               \ Having both the AND and the CMP is a little odd, as
                        \ the sun is the only ship type with bits 0 and 7 set,
                        \ so the AND has no effect and could be removed

 RTS                    \ Return from the subroutine, as the ship we are moving
                        \ is the sun and doesn't need any of the following

ELIF _ELITE_A_6502SP_PARA

 LDA TYPE               \ If the ship type is the sun (129) then skip the next
 AND #%10000001         \ instruction, otherwise return from the subroutine as
 CMP #129               \ we don't need to rotate the sun around its origin.
 BEQ P%+5               \ Having both the AND and the CMP is a little odd, as
                        \ the sun is the only ship type with bits 0 and 7 set,
                        \ so the AND has no effect and could be removed

 JMP MV3                \ The ship type is not the sun, so jump to MV3, skipping
                        \ the next instruction

 RTS                    \ Return from the subroutine, as the ship we are moving
                        \ is the sun and doesn't need any of the following

ENDIF

