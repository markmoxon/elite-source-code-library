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

 TAX                    \ Copy the target's slot number into X

 LDA #3                 \ Set RAT = 3, which is the magnitude we set the pitch
 STA RAT                \ or roll counter when turning a ship towards the target
                        \ (a higher value giving a longer turn)

 LDA #2                 \ Set RAT2 = 2, which is the threshold below which we
 STA RAT2               \ don't apply pitch and roll to the ship (so a lower
                        \ value means we apply pitch and roll more often, and a
                        \ value of 0 means we always apply them). The value is
                        \ compared with double the high byte of sidev . XX15,
                        \ where XX15 is the vector from the ship to the target

 LDA #20                \ Set CNT2 = 20, which is the maximum angle beyond which
 STA CNT2               \ a ship will slow down to start turning towards its
                        \ target (a lower value means a ship will start to slow
                        \ down even if its angle with the target is large, which
                        \ gives a tighter turn)

 LDA UNIV,X             \ Copy the address of the target ship's data block from
 STA V                  \ UNIV(X+1 X) to V(1 0), which works because X contains
 LDA UNIV+1,X           \ the number of the target's slot, multipled by 2
 STA V+1

 LDY #8                 \ We now copy the first nine bytes of the target's data
                        \ block from V(1 0) into the first nine bytes of K3, so
                        \ set a byte counter in Y
                        \
                        \ The first nine bytes of a ship's data block contain
                        \ the ship's (x, y, z) coordinates in space, and our
                        \ ship is at the origin, so this effectively sets K3 to
                        \ the vector from our ship to the target ship

.atak1

 LDA (V),Y              \ Copy the Y-th byte from V(1 0) to the Y-th byte of K3
 STA K3,Y

 DEY                    \ Decrement the byte counter

 BPL atak1              \ Loop back until we have copied all nine bytes

 JSR TAS2               \ Call TAS2 to normalise the vector in K3, returning the
                        \ normalised version in XX15, so XX15 contains the unit
                        \ vector from our target to the target

 JSR TA151              \ Call TA151 to make our ship head in the direction of
                        \ XX15, which makes our ship turn towards the target

                        \ In the following, ship_y and ship_z are the y and
                        \ z-coordinates of XX15, the vector from the ship to
                        \ the target

 LDA XX15+2             \ Set A to ship_z

 ASL A                  \ If |A * 2| < 192, i.e. |A| < 96, then the ship is not
 CMP #192               \ close enough to the target to fire lasers, so jump to
 BCC atak2              \ atak2 to return from the subroutine

                        \ If we get here then the target is close enough for us
                        \ to consider firing lasers

 LDA enableLasers       \ Set KY7 to enableLasers, which will "press" the laser
 STA KY7                \ fire key if lasers are enabled (as enableLasers will
                        \ be &FF if lasers are enabled, or 0 if they are
                        \ disabled during a missile lock)

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction, from the target to our ship,
                        \ so it can be used to refine our approach to the target

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
 LDA #2                 \ our ship pitches towards the target
 ROR A
 STA INWK+30

.atak2

 RTS                    \ Return from the subroutine

