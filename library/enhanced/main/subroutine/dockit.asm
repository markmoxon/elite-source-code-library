\ ******************************************************************************
\
\       Name: DOCKIT
\       Type: Subroutine
\   Category: Flight
\    Summary: Apply docking manoeuvres to the ship in INWK
\  Deep dive: The docking computer
\
IF _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   top_6a              Set bit 7 of the ship's NEWB flags to indicate that it
\                       has docked or been scooped
\
ENDIF
\ ******************************************************************************

.DOCKIT

 LDA #6                 \ Set RAT2 = 6, which is the threshold below which we
 STA RAT2               \ don't apply pitch and roll to the ship (so a lower
                        \ value means we apply pitch and roll more often, and a
                        \ value of 0 means we always apply them). The value is
                        \ compared with double the high byte of sidev . XX15,
                        \ where XX15 is the vector from the ship to the station

 LSR A                  \ Set RAT = 2, which is the magnitude we set the pitch
 STA RAT                \ or roll counter to in part 7 when turning a ship
                        \ towards a vector (a higher value giving a longer
                        \ turn)

 LDA #29                \ Set CNT2 = 29, which is the maximum angle beyond which
 STA CNT2               \ a ship will slow down to start turning towards its
                        \ prey (a lower value means a ship will start to slow
                        \ down even if its angle with the enemy ship is large,
                        \ which gives a tighter turn)

 LDA SSPR               \ If we are inside the space station safe zone, skip the
 BNE P%+5               \ next instruction

.GOPLS

 JMP GOPL               \ Jump to GOPL to make the ship head towards the planet

 JSR VCSU1              \ If we get here then we are in the space station safe
                        \ zone, so call VCSU1 to calculate the following, where
                        \ the station is at coordinates (station_x, station_y,
                        \ station_z):
                        \
                        \   K3(2 1 0) = (x_sign x_hi x_lo) - station_x
                        \
                        \   K3(5 4 3) = (y_sign y_hi z_lo) - station_y
                        \
                        \   K3(8 7 6) = (z_sign z_hi z_lo) - station_z
                        \
                        \ so K3 contains the vector from the station to the ship

 LDA K3+2               \ If any of the top bytes of the K3 results above are
 ORA K3+5               \ non-zero (after removing the sign bits), jump to GOPL
 ORA K3+8               \ via GOPLS to make the ship head towards the planet, as
 AND #%01111111         \ this will aim the ship in the general direction of the
 BNE GOPLS              \ station (it's too far away for anything more accurate)

 JSR TA2                \ Call TA2 to calculate the length of the vector in K3
                        \ (ignoring the low coordinates), returning it in Q

 LDA Q                  \ Store the value of Q in K, so K now contains the
 STA K                  \ distance between station and the ship

 JSR TAS2               \ Call TAS2 to normalise the vector in K3, returning the
                        \ normalised version in XX15, so XX15 contains the unit
                        \ vector pointing from the station to the ship

 LDY #10                \ Call TAS4 to calculate:
 JSR TAS4               \
                        \   (A X) = nosev . XX15
                        \
                        \ where nosev is the nose vector of the space station,
                        \ so this is the dot product of the station to ship
                        \ vector with the station's nosev (which points straight
                        \ out into space, out of the docking slot), and because
                        \ both vectors are unit vectors, the following is also
                        \ true:
                        \
                        \   (A X) = cos(t)
                        \
                        \ where t is the angle between the two vectors
                        \
                        \ If the dot product is positive, that means the vector
                        \ from the station to the ship and the nosev sticking
                        \ out of the docking slot are facing in a broadly
                        \ similar direction (so the ship is essentially heading
                        \ for the slot, which is facing towards the ship), and
                        \ if it's negative they are facing in broadly opposite
                        \ directions (so the station slot is on the opposite
                        \ side of the station as the ship approaches)

 BMI PH1                \ If the dot product is negative, i.e. the station slot
                        \ is on the opposite side, jump to PH1 to fly towards
                        \ the ideal docking position, some way in front of the
                        \ slot

 CMP #35                \ If the dot product < 35, jump to PH1 to fly towards
 BCC PH1                \ the ideal docking position, some way in front of the
                        \ slot, as there is a large angle between the vector
                        \ from the station to the ship and the station's nosev,
                        \ so the angle of approach is not very optimal
                        \
                        \ Specifically, as the unit vector length is 96 in our
                        \ vector system,
                        \
                        \   (A X) = cos(t) < 35 / 96
                        \
                        \ so:
                        \
                        \   t > arccos(35 / 96) = 68.6 degrees
                        \
                        \ so the ship is coming in from the side of the station
                        \ at an angle between 68.6 and 90 degrees off the
                        \ optimal entry angle

                        \ If we get here, the slot is on the same side as the
                        \ ship and the angle of approach is less than 68.6
                        \ degrees, so we're heading in pretty much the correct
                        \ direction for a good approach to the docking slot

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Minor

 JSR TAS3-2             \ Call TAS3-2 to calculate:
                        \
ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #10                \ Call TAS3 to calculate:
 JSR TAS3               \
ENDIF
                        \   (A X) = nosev . XX15
                        \
                        \ where nosev is the nose vector of the ship, so this is
                        \ the dot product of the station to ship vector with the
                        \ ship's nosev, and is a measure of how close to the
                        \ station the ship is pointing, with negative meaning it
                        \ is pointing at the station, and positive meaning it is
                        \ pointing away from the station

 CMP #&A2               \ If the dot product is in the range 0 to -34, jump to
 BCS PH3                \ PH3 to refine our approach, as we are pointing towards
                        \ the station

                        \ If we get here, then we are not pointing straight at
                        \ the station, so check how close we are

 LDA K                  \ Fetch the distance to the station into A

IF _6502SP_VERSION OR _MASTER_VERSION \ Comment

\BEQ PH10               \ This instruction is commented out in the original
                        \ source

ENDIF

 CMP #157               \ If A < 157, jump to PH2 to turn away from the station,
 BCC PH2                \ as we are too close

 LDA TYPE               \ Fetch the ship type into A

 BMI PH3                \ If bit 7 is set, then that means the ship type was set
                        \ to -96 in the DOKEY routine when we switched on our
                        \ docking compter, so this is us auto-docking our Cobra,
                        \ so jump to PH3 to refine our approach. Otherwise this
                        \ is an NPC trying to dock, so turn away from the
                        \ station

.PH2

                        \ If we get here then we turn away from the station and
                        \ slow right down, effectively aborting this approach
                        \ attempt

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction, away from from the station and
                        \ towards the ship

 JSR TA151              \ Call TA151 to make the ship head in the direction of
                        \ XX15, which makes the ship turn away from the station

.PH22

                        \ If we get here then we slam on the brakes and slow
                        \ right down

 LDX #0                 \ Set the acceleration in byte #28 to 0
 STX INWK+28

 INX                    \ Set the speed in byte #28 to 1
 STX INWK+27

 RTS                    \ Return from the subroutine

.PH1

                        \ If we get here then the slot is on the opposite side
                        \ of the station to the ship, or it's on the same side
                        \ and the approach angle is not optimal, so we just fly
                        \ towards the station, aiming for the ideal docking
                        \ position some distance in front of the slot

 JSR VCSU1              \ Call VCSU1 to set K3 to the vector from the station to
                        \ the ship

 JSR DCS1               \ Call DCS1 twice to calculate the vector from the ideal
 JSR DCS1               \ docking position to the ship, where the ideal docking
                        \ position is straight out of the docking slot at a
                        \ distance of 8 unit vectors from the centre of the
                        \ station

 JSR TAS2               \ Call TAS2 to normalise the vector in K3, returning the
                        \ normalised version in XX15

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction

 JMP TA151              \ Call TA151 to make the ship head in the direction of
                        \ XX15, which makes the ship turn towards the ideal
                        \ docking position, and return from the subroutine using
                        \ a tail call

.TN11

                        \ If we get here, we accelerate and apply a full
                        \ clockwise roll (which matches the space station's
                        \ roll)

 INC INWK+28            \ Increment the acceleration in byte #28

 LDA #%01111111         \ Set the roll counter to a positive roll with no
 STA INWK+29            \ damping, to match the space station's roll

 BNE TN13               \ Jump down to TN13 (this BNE is effectively a JMP as
                        \ A will never be zero)

.PH3

                        \ If we get here, we refine our approach using pitch and
                        \ roll to aim for the station

 LDX #0                 \ Set RAT2 = 0
 STX RAT2

 STX INWK+30            \ Set the pitch counter to 0 to stop any pitching

 LDA TYPE               \ If this is not our ship's docking computer, but is an
 BPL PH32               \ NPC ship trying to dock, jump to PH32

                        \ In the following, ship_x and ship_y are the x and
                        \ y-coordinates of XX15, the vector from the station to
                        \ the ship

 EOR XX15               \ A is negative, so this sets the sign of A to the same
 EOR XX15+1             \ as -XX15 * XX15+1, or -ship_x * ship_y

 ASL A                  \ Shift the sign bit into the C flag, so the C flag has
                        \ the following sign:
                        \
                        \   * Positive if ship_x and ship_y have different signs
                        \   * Negative if ship_x and ship_y have the same sign

 LDA #2                 \ Set A = +2 or -2, giving it the sign in the C flag,
 ROR A                  \ and store it in byte #29, the roll counter, so that
 STA INWK+29            \ the ship rolls towards the station

 LDA XX15               \ If |ship_x * 2| >= 12, i.e. |ship_x| >= 6, then jump
 ASL A                  \ to PH22 to slow right down and return from the
 CMP #12                \ subroutine, as the station is not in our sights
 BCS PH22

 LDA XX15+1             \ Set A = +2 or -2, giving it the same sign as ship_y,
 ASL A                  \ and store it in byte #30, the pitch counter, so that
 LDA #2                 \ the ship pitches towards the station
 ROR A
 STA INWK+30

 LDA XX15+1             \ If |ship_y * 2| >= 12, i.e. |ship_y| >= 6, then jump
 ASL A                  \ to PH22 to slow right down and return from the
 CMP #12                \ subroutine, as the station is not in our sights
 BCS PH22

.PH32

                        \ If we get here, we try to match the station roll

 STX INWK+29            \ Set the roll counter to 0 to stop any pitching

 LDA INWK+22            \ Set XX15 = sidev_x_hi
 STA XX15

 LDA INWK+24            \ Set XX15+1 = sidev_y_hi
 STA XX15+1

 LDA INWK+26            \ Set XX15+2 = sidev_z_hi
 STA XX15+2             \
                        \ so XX15 contains the sidev vector of the ship

 LDY #16                \ Call TAS4 to calculate:
 JSR TAS4               \
                        \   (A X) = roofv . XX15
                        \
                        \ where roofv is the roof vector of the space station.
                        \ To dock with the slot horizontal, we want roofv to be
                        \ pointing off to the side, i.e. parallel to the ship's
                        \ sidev vector, which means we want the dot product to
                        \ be large (it can be positive or negative, as roofv can
                        \ point left or right - it just needs to be parallel to
                        \ the ship's sidev)

 ASL A                  \ If |A * 2| >= 66, i.e. |A| >= 33, then the ship is
 CMP #66                \ lined up with the slot, so jump to TN11 to accelerate
 BCS TN11               \ and roll clockwise (a positive roll) before jumping
                        \ down to TN13 to check if we're docked yet

 JSR PH22               \ Call PH22 to slow right down, as we haven't yet
                        \ matched the station's roll

.TN13

                        \ If we get here, we check to see if we have docked

 LDA K3+10              \ If K3+10 is non-zero, skip to TNRTS, to return from
 BNE TNRTS              \ the subroutine
                        \
                        \ I have to say I have no idea what K3+10 contains, as
                        \ it isn't mentioned anywhere in the whole codebase
                        \ apart from here, but it does share a location with
                        \ XX2+10, so it will sometimes be non-zero (specifically
                        \ when face #10 in the ship we're drawing is visible,
                        \ which probably happens quite a lot). This would seem
                        \ to affect whether an NPC ship can dock, as that's the
                        \ code that gets skipped if K3+10 is non-zero, but as
                        \ to what this means... that's not yet clear

IF _ELITE_A_VERSION

.top_6a

ENDIF

 ASL NEWB               \ Set bit 7 of the ship's NEWB flags to indicate that
 SEC                    \ the ship has now docked, which only has meaning if
 ROR NEWB               \ this is an NPC trying to dock

.TNRTS

 RTS                    \ Return from the subroutine


