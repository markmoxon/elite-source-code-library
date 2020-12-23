\ ******************************************************************************
\
\       Name: DOCKIT
\       Type: Subroutine
\   Category: Flight
\    Summary: Apply docking manoeuvres to the ship in INWK
\
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

 BMI PH1                \ If the dot product is positive, that means the vector
                        \ from the station to the ship and the nosev sticking
                        \ out of the docking slot are facing in a broadly
                        \ similar direction (so the ship is essentially heading
                        \ for the slot, which is facing towards the ship), and
                        \ if it's negative they are facing in broadly opposite
                        \ directions (so the station slot is on the opposite
                        \ side of the station as the ship approaches)
                        \
                        \ In the latter case, jump to PH1 to fly towards the
                        \ ideal docking position, some way in front of the slot

 CMP #35                \ If the dot product < 35, jump to PH1 to keep flying
 BCC PH1                \ towards the station, as the angle of approach is not
                        \ close enough to optimal, as:
                        \
                        \   (A X) = cos(t) < 35 / 96
                        \
                        \   t > 68.6 degrees
                        \
                        \ so the ship is coming in from the side of the station

                        \ If we get here, the slot is on the same side as the
                        \ ship and the angle of approach is less than 68.6
                        \ degrees, so we're not doing too badly

 LDY #10                \ Call TAS3 to calculate:
 JSR TAS3               \
                        \   (A X) = nosev . XX15
                        \
                        \ where nosev is the nose vector of the ship, so this is
                        \ the dot product of the station to ship vector with the
                        \ ship's nosev, and is a measure of how close to the
                        \ station the ship is pointing, with negative meaning it
                        \ is pointing at the station, and positive meaning it is
                        \ pointing away from the station

 CMP #&A2               \ If the dot product >= -34, jump to PH3 to refine our
 BCS PH3                \ approach, as we are pointing away from the station ???

 LDA K                  \ Fetch the distance to the station into A

\BEQ PH10               \ This instruction is commented out in the original
                        \ source

 CMP #157               \ If A < 157, jump to PH2 to turn away from the station
 BCC PH2

 LDA TYPE               \ Fetch the ship type into A

 BMI PH3                \ If bit 7 is set, then that means the ship type was set
                        \ to -96 in the DOKEY routine when we switched on our
                        \ docking compter, so this ship is us auto-docking, so
                        \ jump to PH3 to refine our approach

.PH2

                        \ If we get here then we need to turn away from the
                        \ station and slow right down

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction, away from from the station and
                        \ towards the ship

 JSR TA151              \ Call TA151 to make the ship head in the direction of
                        \ XX15, which makes the ship turn away from the station

.PH22

                        \ If we get here then we need to slow right down

 LDX #0                 \ Set the acceleration in byte #28 to 0
 STX INWK+28

 INX                    \ Set the speed in byte #28 to 1
 STX INWK+27

 RTS                    \ Return from the subroutine

.PH1

                        \ If we get here then the slot is on the opposite side
                        \ of the station to the ship, or it's on the same side
                        \ and the approach angle is not optimal, so just fly
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

                        \ Accelerate and roll

 INC INWK+28            \ Increment the acceleration in byte #28

 LDA #%01111111         \ Set the roll counter to a positive roll with no
 STA INWK+29            \ damping

 BNE TN13               \ Jump down to TN13 (this BNE is effectively a JMP as
                        \ A will never be zero)

.PH3

                        \ Adjust approach?

 LDX #0                 \ Set RAT2 = 0
 STX RAT2

 STX INWK+30            \ Set the pitch counter to 0 to stop any pitching

 LDA TYPE               \ If this is not our ship's docking computer, but is an
 BPL PH32               \ NPC ship trying to dock, jump to PH32

 EOR XX15
 EOR XX15+1
 ASL A

 LDA #2
 ROR A
 STA INWK+29

 LDA XX15
 ASL A
 CMP #12
 BCS PH22

 LDA XX15+1
 ASL A

 LDA #2
 ROR A
 STA INWK+30

 LDA XX15+1
 ASL A
 CMP #12
 BCS PH22

.PH32

                        \ Match the station roll

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
                        \ where roofv is the roof vector of the space station

 ASL A                  \ Set A = |A * 2|

 CMP #66                \ If A >= 66, i.e. |A| >= 33, jump to TN11 to accelerate
 BCS TN11               \ and roll before jumping down to TN13

 JSR PH22               \ Call PH22 to slow right down

.TN13

 LDA K3+10              \ If K3+10 is non-zero, skip to TNRTS to return from the
 BNE TNRTS              \ subroutine ????

 ASL NEWB               \ Set bit 7 of the ship's NEWB flags to indicate that
 SEC                    \ the ship has now docked
 ROR NEWB

.TNRTS

 RTS                    \ Return from the subroutine

