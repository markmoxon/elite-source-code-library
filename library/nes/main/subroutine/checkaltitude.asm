\ ******************************************************************************
\
\       Name: CheckAltitude
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform an altitude check with the planet, ending the game if we
\             hit the ground
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   MA232               Contains an RTS
\
\ ******************************************************************************

.CheckAltitude

 LDY #&FF               \ Set our altitude in ALTIT to &FF, the maximum
 STY ALTIT

 INY                    \ Set Y = 0

 JSR m                  \ Call m to calculate the maximum distance to the
                        \ planet in any of the three axes, returned in A

 BNE MA232              \ If A > 0 then we are a fair distance away from the
                        \ planet in at least one axis, so jump to MA232 to skip
                        \ the rest of the altitude check

 JSR MAS3               \ Set A = x_hi^2 + y_hi^2 + z_hi^2, so using Pythagoras
                        \ we now know that A now contains the square of the
                        \ distance between our ship (at the origin) and the
                        \ centre of the planet at (x_hi, y_hi, z_hi)

 BCS MA232              \ If the C flag was set by MAS3, then the result
                        \ overflowed (was greater than &FF) and we are still a
                        \ fair distance from the planet, so jump to MA232 as we
                        \ haven't crashed into the planet

 SBC #36                \ Subtract 37 from x_hi^2 + y_hi^2 + z_hi^2
                        \
                        \ The SBC subtracts 37 as we just passed through a BCS
                        \ so we know the C flag is clear
                        \
                        \ When we do the 3D Pythagoras calculation, we only use
                        \ the high bytes of the coordinates, so that's x_hi,
                        \ y_hi and z_hi and
                        \
                        \ The planet radius is (0 96 0), as defined in the
                        \ PLANET routine, so the high byte is 96
                        \
                        \ When we square the coordinates above and add them,
                        \ the result gets divided by 256 (otherwise the result
                        \ wouldn't fit into one byte), so if we do the same for
                        \ the planet's radius, we get:
                        \
                        \   96 * 96 / 256 = 36
                        \
                        \ So for the planet, the equivalent figure to test the
                        \ sum of the _hi bytes against is 36, so A now contains
                        \ the high byte of our altitude above the planet
                        \ surface, squared, with an extra 1 subtracted so the
                        \ test in the next instruction will ensure we crash
                        \ even if we are exactly one planet radius away

 BCC MA282              \ If A < 0 then jump to MA282 as we have crashed into
                        \ the planet

 STA R                  \ Set (R Q) = (A Q)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR LL5                \ We are getting close to the planet, so we need to
                        \ work out how close. We know from the above that A
                        \ contains our altitude squared, so we store A in R
                        \ and call LL5 to calculate:
                        \
                        \   Q = SQRT(R Q) = SQRT(A Q)
                        \
                        \ Interestingly, Q doesn't appear to be set to 0 for
                        \ this calculation, so presumably this doesn't make a
                        \ difference

 LDA Q                  \ Store the result in ALTIT, our altitude
 STA ALTIT

 BNE MA232              \ If our altitude is non-zero then we haven't crashed,
                        \ so jump to MA232 to skip to the next section

.MA282

 JMP DEATH              \ If we get here then we just crashed into the planet
                        \ or got too close to the sun, so jump to DEATH to start
                        \ the funeral preparations and return from the main
                        \ flight loop using a tail call

.MA232

 RTS                    \ Return from the subroutine

