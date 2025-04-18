\ ******************************************************************************
\
\       Name: TACTICS (Part 7 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Set pitch, roll, and acceleration
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section looks at manoeuvring the ship. Specifically:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\   * Work out which direction the ship should be moving, depending on whether
\     it's an escape pod, where it is, which direction it is pointing, and how
\     aggressive it is
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
\   * Work out which direction the ship should be moving, depending on the type
\     of ship, where it is, which direction it is pointing, and how aggressive
\     it is
ENDIF
\
\   * Set the pitch and roll counters to head in that direction
\
\   * Speed up or slow down, depending on where the ship is in relation to us
\
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TA151               Make the ship head towards the planet
\
ENDIF
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   TA9-1               Contains an RTS
\
ENDIF
\ ******************************************************************************

.TA4

 LDA INWK+7             \ If z_hi >= 3 then the ship is quite far away, so jump
 CMP #3                 \ down to TA5
 BCS TA5

 LDA INWK+1             \ Otherwise set A = x_hi OR y_hi and extract bits 1-7
 ORA INWK+4
 AND #%11111110

IF NOT(_NES_VERSION)

 BEQ TA15               \ If A = 0 then the ship is pretty close to us, so jump
                        \ to TA15 so it heads away from us

ELIF _NES_VERSION

 BEQ tact5              \ If A = 0 then the ship is pretty close to us, so jump
                        \ to tact5 so it heads away from us

ENDIF

.TA5

                        \ If we get here then the ship is quite far away

 JSR DORND              \ Set A and X to random numbers

 ORA #%10000000         \ Set bit 7 of A, so A is at least 128

IF NOT(_NES_VERSION)

 CMP INWK+32            \ If A >= byte #32 (the ship's AI flag) then jump down
 BCS TA15               \ to TA15 so it heads away from us

ELIF _NES_VERSION

 CMP INWK+32            \ If A >= byte #32 (the ship's AI flag) then jump down
 BCS tact5              \ to tact5 so it heads away from us

ENDIF

                        \ We get here if A < byte #32, and the chances of this
                        \ being true are greater with high values of byte #32,
                        \ as long as they are at least 128
                        \
                        \ In other words, higher byte #32 values increase the
                        \ chances of a ship changing direction to head towards
                        \ us - or, to put it another way, ships with higher
                        \ byte #32 values of 128 or more are spoiling for a
                        \ fight
                        \
                        \ Thargoids have byte #32 set to 255, which explains
                        \ an awful lot

IF _NES_VERSION

 STA shipIsAggressive   \ Store A in shipIsAggressive, so we can check bit 7 of
                        \ the value below to judge whether this ship is spoiling
                        \ for a fight

ENDIF

.TA20

                        \ If this is a missile we will have jumped straight
                        \ here, but we also get here if the ship is either far
                        \ away and aggressive, or not too close

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor: This code is in the TAS6 routine in the enhanced versions

 LDA XX15               \ Reverse the signs of XX15 and the dot product in CNT,
 EOR #%10000000         \ starting with the x-coordinate
 STA XX15

 LDA XX15+1             \ Then reverse the sign of the y-coordinate
 EOR #%10000000
 STA XX15+1

 LDA XX15+2             \ And then the z-coordinate, so now the XX15 vector goes
 EOR #%10000000         \ from the enemy ship to our ship (it was previously the
 STA XX15+2             \ other way round)

 LDA CNT                \ And finally change the sign of the dot product in CNT,
 EOR #%10000000         \ so now it's positive if the ships are facing each
 STA CNT                \ other, and negative if they are facing the same way

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR TAS6               \ Call TAS6 to negate the vector in XX15 so it points in
                        \ the opposite direction

 LDA CNT                \ Change the sign of the dot product in CNT, so now it's
 EOR #%10000000         \ positive if the ships are facing each other, and
                        \ negative if they are facing the same way

.TA152

 STA CNT                \ Update CNT with the new value in A

ENDIF

IF _NES_VERSION

.tact5

 JSR TA15               \ Call TA15 so the ship heads away from us

 LDA shipIsAggressive   \ If bit 7 of shipIsAggressive is clear then the ship is
 BPL tact7              \ not spoiling for a fight, so jump to tact7 to skip the
                        \ following

 LDA INWK+1             \ If any of x_hi, y_hi or z_hi have bits 3 to 7 set,
 ORA INWK+4             \ then at least one of them is greater than 7, so jump
 ORA INWK+7             \ to tact7 to consider slowing down to make a turn
 AND #%11111000
 BNE tact7

                        \ If we get here then x_hi, y_hi and z_hi are all 7 or
                        \ smaller, so the ships are close together

 LDA CNT                \ Fetch the dot product, and if it's negative jump to
 BMI tact6              \ tact10 via tact6 to consider speeding up or braking,
                        \ as the ships are facing away from each other

 CMP CNT2               \ The dot product is positive, so the ships are facing
 BCS tact11             \ each other. If A >= CNT2 then the ships are heading
                        \ directly towards each other, so jump to tact11 to
                        \ accelerate hard

.tact6

 JMP tact10             \ Jump to tact10 to consider speeding up or braking

.tact7

 LDA CNT                \ Fetch the dot product, and if it's negative jump to
 BMI tact9              \ tact9, as the ships are facing away from each other
                        \ so we should consider slowing down to make a turn

 CMP CNT2               \ The dot product is positive, so the ships are facing
 BCC tact10             \ each other. If A < CNT2 then the ships are not heading
                        \ directly towards each other, so jump to tact10 to
                        \ consider speeding up or braking

.tact8

                        \ Set the ship's acceleration to 3

 LDA #3                 \ Set A = 3 so we set the acceleration in byte #28 to 3
                        \ below

 BNE tact12             \ Jump to tact12 to set the acceleration and return from
                        \ the subroutine (this BNE is effectively a JMP as A is
                        \ never zero)

.tact9

 AND #%01111111         \ Clear the sign bit of the dot product in A

 CMP #6                 \ If A >= 6 then the ship is not far from the XX15
 BCS tact11             \ vector, so jump to tact11 to start slowing down

                        \ Otherwise the ship is way off the XX15 vector, so we
                        \ fall through into tact10 to consider speeding up or
                        \ braking

.tact10

                        \ If we get here then we speed up the ship if it is
                        \ going slowly, otherwise we apply the brakes 22% of the
                        \ time, or do nothing 78% of the time

 LDA INWK+27            \ Set A to the ship's speed in byte #27

 CMP #6                 \ If A < 6 then the ship is not going fast, so jump to
 BCC tact8              \ tact8 to set the ship's acceleration to 3

 JSR DORND              \ Otherwise the ship is going fast, so set A and X to
                        \ random numbers

 CMP #200               \ If A < 200 (78% chance), jump to TA10 to return from
 BCC TA10               \ the subroutine without accelerating

                        \ If we get here the ship is not going that slowly, so
                        \ we only apply the brakes 22% of the time

.tact11

                        \ Set the ship's acceleration to -1, unless it is a
                        \ missile, in which case set it to -2

 LDA #&FF               \ Set A = -1

 LDX TYPE               \ If this is not a missile then skip the ASL instruction
 CPX #MSL
 BNE tact12

 ASL A                  \ This is a missile, so set A = -2, as missiles are more
                        \ nimble and can brake more quickly

.tact12

 STA INWK+28            \ Set the ship's acceleration to A

.TA10

 RTS                    \ Return from the subroutine

.TA151

                        \ This is called from part 3 with the vector to the
                        \ planet in XX15, when we want the ship to turn towards
                        \ the planet. It does the same dot product calculation
                        \ as part 3, but it can also change the value of RAT2
                        \ so that roll and pitch is always applied

 LDY #10                \ Set (A X) = nosev . XX15
 JSR TAS3               \
                        \ The bigger the value of the dot product, the more
                        \ aligned the two vectors are, with a maximum magnitude
                        \ in A of 36 (96 * 96 >> 8). If A is positive, the
                        \ vectors are facing in a similar direction, if it's
                        \ negative they are facing in opposite directions

 CMP #&98               \ If A is positive or A <= -24, jump to ttt
 BCC ttt

 LDX #0                 \ A > -24, which means the vectors are facing in
 STX RAT2               \ opposite directions but are quite aligned, so set
                        \ RAT2 = 0 instead of the default value of 4, so we
                        \ always apply roll and pitch when we turn the ship
                        \ towards the planet

.ttt

 JMP TA152              \ Jump to TA152 to store A in CNT and move the ship in
                        \ the direction of XX15

ENDIF

.TA15

                        \ If we get here, then one of the following is true:
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
                        \   * This is an escape pod and XX15 is pointing towards
                        \     the planet
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
                        \   * This is a trader and XX15 is pointing towards the
                        \     planet
ENDIF
                        \
                        \   * The ship is pretty close to us, or it's just not
                        \     very aggressive (though there is a random factor
                        \     at play here too). XX15 is still pointing from our
                        \     ship towards the enemy ship
                        \
                        \   * The ship is aggressive (though again, there's an
                        \     element of randomness here). XX15 is pointing from
                        \     the enemy ship towards our ship
                        \
                        \   * This is a missile heading for a target. XX15 is
                        \     pointing from the missile towards the target
                        \
                        \ We now want to move the ship in the direction of XX15,
                        \ which will make aggressive ships head towards us, and
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
                        \ ships that are too close turn away. Escape pods,
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
                        \ ships that are too close turn away. Peaceful traders,
ENDIF
                        \ meanwhile, head off towards the planet in search of a
                        \ space station, and missiles home in on their targets

 LDY #16                \ Set (A X) = roofv . XX15
 JSR TAS3               \
                        \ This will be positive if XX15 is pointing in the same
                        \ direction as an arrow out of the top of the ship, in
                        \ other words if the ship should pull up to head in the
                        \ direction of XX15

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Group A: The cassette and Electron versions have fairly basic pitch and roll control over ships when applying AI tactics, whereas the enhanced versions have finer control using the RAT, RAT2 and CNT2 variables, which is particularly useful when the docking computer is in control

 EOR #%10000000         \ Set the ship's pitch counter to 3, with the opposite
 AND #%10000000         \ sign to the dot product result, which gently pitches
 ORA #%00000011         \ the ship towards the direction of the XX15 vector
 STA INWK+30

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 JSR nroll              \ Call nroll to calculate the value of the ship's pitch
                        \ counter

 STA INWK+30            \ Store the result in the ship's pitch counter

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 EOR #%10000000         \ Give the ship's pitch counter the opposite sign to the
 AND #%10000000         \ dot product result, with a value of 0
 STA INWK+30

 TXA                    \ Retrieve the original value of A from X

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP RAT2               \ If A < RAT2, skip to TA11 (so if RAT2 = 0, we always
 BCC TA11               \ set the pitch counter to RAT)

 LDA RAT                \ Set the magnitude of the ship's pitch counter to RAT
 ORA INWK+30            \ (we already set the sign above)
 STA INWK+30

.TA11

ELIF _NES_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 EOR #%10000000         \ Give the ship's pitch counter the opposite sign to the
 AND #%10000000         \ dot product result, with a value of 0
 STA INWK+30

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA CNT                \ Fetch the dot product, and if it's positive jump to
 BPL tact14             \ tact14, as the ships are facing each other and we
                        \ don't need to pitch to make a turn

 CMP #159               \ If A < 159, skip to tact14 to leave the pitch counter
 BCC tact14             \ at zero

 LDA #7                 \ Set the magnitude of the ship's pitch counter to 7
 ORA INWK+30            \ (we already set the sign above)
 STA INWK+30

 LDA #0                 \ Set A = 0 so when we jump to tact15, we set the ship's
                        \ roll counter to zero

 BEQ tact15             \ Jump to tact15 to set the roll counter (this BEQ is
                        \ effectively a JMP as A is always zero)

.tact14

 TXA                    \ Retrieve the original value of A from X

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP RAT2               \ If A < RAT2, skip to TA11 (so if RAT2 = 0, we always
 BCC TA11               \ set the pitch counter to RAT)

 LDA RAT                \ Set the magnitude of the ship's pitch counter to RAT
 ORA INWK+30            \ (we already set the sign above)
 STA INWK+30

.TA11

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 LDA INWK+29            \ Fetch the roll counter from byte #29 into A and clear
 AND #%01111111         \ the sign bit (to give an endless clockwise roll)

 CMP #16                \ If A >= 16 then jump to TA6, as the ship is already
 BCS TA6                \ in the process of rolling

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA INWK+29            \ Fetch the roll counter from byte #29 into A

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP #32                \ If A >= 32 then jump to TA6, as the ship is already
 BCS TA6                \ in the process of rolling

ENDIF

 LDY #22                \ Set (A X) = sidev . XX15
 JSR TAS3               \
                        \ This will be positive if XX15 is pointing in the same
                        \ direction as an arrow out of the right side of the
                        \ ship, in other words if the ship should roll right to
                        \ head in the direction of XX15

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 EOR INWK+30            \ Set the ship's roll counter to 5, with the sign set to
 AND #%10000000         \ positive (clockwise roll) if the pitch counter and dot
 EOR #%10000101         \ product have different signs, negative (anti-clockwise
 STA INWK+29            \ roll) if they have the same sign

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 EOR INWK+30            \ Give A the correct sign of the dot product * the
                        \ current pitch direction (i.e. the sign is negative if
                        \ the pitch counter and dot product have different
                        \ signs, positive if they have the same sign)

 JSR nroll              \ Call nroll to calculate the value of the ship's pitch
                        \ counter

 STA INWK+29            \ Store the result in the ship's roll counter

.TA12

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 EOR INWK+30            \ Give the ship's roll counter a positive sign
 AND #%10000000         \ (clockwise roll) if the pitch counter and dot product
 EOR #%10000000         \ have different signs, negative (anti-clockwise roll)
 STA INWK+29            \ if they have the same sign, with a value of 0

 TXA                    \ Retrieve the original value of A from X

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP RAT2               \ If A < RAT2, skip to TA12 (so if RAT2 = 0, we always
 BCC TA12               \ set the roll counter to RAT)

 LDA RAT                \ Set the magnitude of the ship's roll counter to RAT
 ORA INWK+29            \ (we already set the sign above)
 STA INWK+29

.TA12

ELIF _NES_VERSION

 TAX                    \ Copy A into X so we can retrieve it below

 EOR INWK+30            \ Give the ship's roll counter a positive sign
 AND #%10000000         \ (clockwise roll) if the pitch counter and dot product
 EOR #%10000000         \ have different signs, negative (anti-clockwise roll)
 STA INWK+29            \ if they have the same sign, with a value of 0

 TXA                    \ Retrieve the original value of A from X

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP RAT2               \ If A < RAT2, skip to TA6 (so if RAT2 = 0, we always
 BCC TA6                \ set the roll counter to RAT)

 LDA RAT                \ Set the magnitude of the ship's roll counter to RAT
 ORA INWK+29            \ (we already set the sign above)

.tact15

 STA INWK+29            \ Store the magnitude of the ship's roll counter

.TA6

 RTS                    \ Return from the subroutine

ENDIF

IF NOT(_NES_VERSION)

.TA6

 LDA CNT                \ Fetch the dot product, and if it's negative jump to
 BMI TA9                \ TA9, as the ships are facing away from each other and
                        \ the ship might want to slow down to take another shot

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor: CNT2 is set to 22 in the enhanced versions

 CMP #22                \ The dot product is positive, so the ships are facing
 BCC TA9                \ each other. If A < 22 then the ships are not heading
                        \ directly towards each other, so jump to TA9 to slow
                        \ down

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 CMP CNT2               \ The dot product is positive, so the ships are facing
 BCC TA9                \ each other. If A < CNT2 then the ships are not heading
                        \ directly towards each other, so jump to TA9 to slow
                        \ down

.PH10E

ENDIF

IF NOT(_NES_VERSION)

 LDA #3                 \ Otherwise set the acceleration in byte #28 to 3
 STA INWK+28

 RTS                    \ Return from the subroutine

.TA9

 AND #%01111111         \ Clear the sign bit of the dot product in A

 CMP #18                \ If A < 18 then the ship is way off the XX15 vector, so
 BCC TA10               \ return from the subroutine (TA10 contains an RTS)
                        \ without slowing down, as it still has quite a bit of
                        \ turning to do to get on course

 LDA #&FF               \ Otherwise set A = -1

 LDX TYPE               \ If this is not a missile then skip the ASL instruction
 CPX #MSL
 BNE P%+3

 ASL A                  \ This is a missile, so set A = -2, as missiles are more
                        \ nimble and can brake more quickly

 STA INWK+28            \ Set the ship's acceleration to A

.TA10

 RTS                    \ Return from the subroutine

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Enhanced: The tactics routines to point the ship at the planet are shared with the docking computer

.TA151

                        \ This is called from part 3 with the vector to the
                        \ planet in XX15, when we want the ship to turn towards
                        \ the planet. It does the same dot product calculation
                        \ as part 3, but it can also change the value of RAT2
                        \ so that roll and pitch is always applied

 JSR TAS3-2             \ Set (A X) = nosev . XX15
                        \
                        \ The bigger the value of the dot product, the more
                        \ aligned the two vectors are, with a maximum magnitude
                        \ in A of 36 (96 * 96 >> 8). If A is positive, the
                        \ vectors are facing in a similar direction, if it's
                        \ negative they are facing in opposite directions

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

.TA151

                        \ This is called from part 3 with the vector to the
                        \ planet in XX15, when we want the ship to turn towards
                        \ the planet. It does the same dot product calculation
                        \ as part 3, but it can also change the value of RAT2
                        \ so that roll and pitch is always applied

 LDY #10                \ Set (A X) = nosev . XX15
 JSR TAS3               \
                        \ The bigger the value of the dot product, the more
                        \ aligned the two vectors are, with a maximum magnitude
                        \ in A of 36 (96 * 96 >> 8). If A is positive, the
                        \ vectors are facing in a similar direction, if it's
                        \ negative they are facing in opposite directions

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Enhanced: See group A

 CMP #&98               \ If A is positive or A <= -24, jump to ttt
 BCC ttt

 LDX #0                 \ A > -24, which means the vectors are facing in
 STX RAT2               \ opposite directions but are quite aligned, so set
                        \ RAT2 = 0 instead of the default value of 4, so we
                        \ always apply roll and pitch when we turn the ship
                        \ towards the planet

.ttt

 JMP TA152              \ Jump to TA152 to store A in CNT and move the ship in
                        \ the direction of XX15

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Enhanced: The tactics routines to pitch and roll the ship are shared with the docking computer

.nroll

 EOR #%10000000         \ Give the ship's pitch counter the opposite sign to the
 AND #%10000000         \ dot product result, with a value of 0, and store it in
 STA T                  \ T

 TXA                    \ Retrieve the original value of A from X

 ASL A                  \ Shift A left to double it and drop the sign bit

 CMP RAT2               \ If A < RAT2, skip to nroll2 (so if RAT2 = 0, we always
 BCC nroll2             \ set the pitch counter to RAT)

 LDA RAT                \ Set the magnitude of the ship's pitch counter to RAT
 ORA T                  \ (we already set the sign above and stored it in T)

 RTS                    \ Return from the subroutine

.nroll2

 LDA T                  \ Set A to the value we stored in T above, which has a
                        \ value of 0 and the opposite sign to the dot product
                        \ result

 RTS                    \ Return from the subroutine

ENDIF

