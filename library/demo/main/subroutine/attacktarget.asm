\ ******************************************************************************
\
\       Name: AttackTarget
\       Type: Subroutine
\   Category: Demo
\    Summary: Turn towards the specified enemy target and fire lasers when we
\             are pointing in the right direction
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The ship slot of the target * 2
\
\ ******************************************************************************

.AttackTarget

 TAX                    \ ???

 LDA #3
 STA RAT

 LDA #2
 STA RAT2

 LDA #20
 STA CNT2

 LDA UNIV,X
 STA V

 LDA UNIV+1,X
 STA V+1

 LDY #8

.atak1

 LDA (V),Y
 STA K3,Y

 DEY

 BPL atak1

 JSR TAS2               \ Call TAS2 to normalise the vector in K3, returning the
                        \ normalised version in XX15, so XX15 contains the unit
                        \ vector pointing from the target to the ship ???

 JSR TA151              \ Call TA151 to make the ship head in the direction of
                        \ XX15, which makes the ship turn ???

                        \ In the following, ship_y and ship_z are the y and
                        \ z-coordinates of XX15, the vector from the target to
                        \ the ship ???

 LDA XX15+2             \ Set A to ship_z

 ASL A                  \ If |A * 2| < 192, i.e. |A| < 96, then the ship is not
 CMP #192               \ lined up with the target, so jump to to atak2 to
 BCC atak2              \ return from the subroutine ???

 LDA enableLasers       \ Set KY7 to enableLasers, which will "press" the laser
 STA KY7                \ fire key if lasers are enabled (as enableLasers will
                        \ be &FF if lasers are enabled, or 0 if they are
                        \ disabled during a missile lock)

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction, ???

 JSR RefineApproach     \ Call RefineApproach to refine our approach using pitch
                        \ and roll to aim for the target (this routine contains
                        \ the same code as PH3 from the disc version, just
                        \ extracted into a subroutine to it can be used to head
                        \ for both our current enemy target and the station)

 BCS atak2              \ If the C flag is set then the target is not in our
                        \ sights, so jump to to atak2 to return from the
                        \ subroutine

 LDA XX15+1             \ Set A = +2 or -2, giving it the same sign as ship_y,
 ASL A                  \ and store it in byte #30, the pitch counter, so that
 LDA #2                 \ the ship pitches towards the target
 ROR A
 STA INWK+30

.atak2

 RTS                    \ Return from the subroutine

