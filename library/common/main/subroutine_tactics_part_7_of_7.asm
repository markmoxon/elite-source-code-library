\ ******************************************************************************
\
\       Name: TACTICS (Part 7 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Set pitch, roll, and acceleration
\
\ ------------------------------------------------------------------------------
\
\ This section looks at manoeuvring the ship. Specifically:
\
\   * Work out which direction the ship should be moving, depending on whether
\     it's an escape pod, where it is, which direction it is pointing, and how
\     aggressive it is
\
\   * Set the pitch and roll counters to head in that direction
\
\   * Speed up or slow down, depending on where the ship is in relation to us
\
\ ******************************************************************************

.TA4

 LDA INWK+7             \ If z_hi >= 3 then the ship is quite far away, so jump
 CMP #3                 \ down to TA5
 BCS TA5

 LDA INWK+1             \ Otherwise set A = x_hi OR y_hi and extract bits 1-7
 ORA INWK+4
 AND #%11111110

 BEQ TA15               \ If A = 0 then the ship is pretty close to us, so jump
                        \ to TA15 so it heads away from us

.TA5

                        \ If we get here then the ship is quite far away

 JSR DORND              \ Set A and X to random numbers

 ORA #%10000000         \ Set bit 7 of A

 CMP INWK+32            \ If A >= byte #32 (the ship's AI flag) then jump down
 BCS TA15               \ to TA15 so it heads away from us

                        \ We get here if A < byte #32, and the chances of this
                        \ being true are greater with high values of byte #32.
                        \ In other words, higher byte #32 values increase the
                        \ chances of a ship changing direction to head towards
                        \ us - or, to put it another way, ships with higher
                        \ byte #32 values are spoiling for a fight. Thargoids
                        \ have byte #32 set to 255, which explains an awful lot

.TA20

                        \ If this is a missile we will have jumped straight
                        \ here, but we also get here if the ship is either far
                        \ away and aggressive, or not too close

IF _CASSETTE_VERSION

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

ELIF _6502SP_VERSION

 JSR TAS6

 LDA CNT
 EOR #%10000000

.TA152

 STA CNT

ENDIF

.TA15

                        \ If we get here, then one of the following is true:
                        \
                        \   * This is an escape pod and XX15 is pointing towards
                        \     the planet
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
                        \ ships that are too close turn away. Escape pods,
                        \ meanwhile, head off towards the planet in search of a
                        \ space station, and missiles home in on their targets

 LDY #16                \ Set (A X) = roofv . XX15
 JSR TAS3               \
                        \ This will be positive if XX15 is pointing in the same
                        \ direction as an arrow out of the top of the ship, in
                        \ other words if the ship should pull up to head in the
                        \ direction of XX15

IF _CASSETTE_VERSION

 EOR #%10000000         \ Set the ship's pitch counter to 3, with the opposite
 AND #%10000000         \ sign to the dot product result, which gently pitches
 ORA #%00000011         \ the ship towards the direction of the XX15 vector
 STA INWK+30

 LDA INWK+29            \ Fetch the roll counter from byte #29 into A and clear
 AND #%01111111         \ the sign bit

 CMP #16                \ If A >= 16 then jump to TA6, as the ship is already
 BCS TA6                \ in the process of rolling

ELIF _6502SP_VERSION

 TAX

 EOR #%10000000
 AND #%10000000
 STA INWK+30
 TXA
 ASL A
 CMP RAT2
 BCC TA11
 LDA RAT
 ORA INWK+30
 STA INWK+30

.TA11

 LDA INWK+29
 ASL A
 CMP #32
 BCS TA6

ENDIF

 LDY #22                \ Set (A X) = sidev . XX15
 JSR TAS3               \
                        \ This will be positive if XX15 is pointing in the same
                        \ direction as an arrow out of the right side of the
                        \ ship, in other words if the ship should roll right to
                        \ head in the direction of XX15

IF _CASSETTE_VERSION

 EOR INWK+30            \ Set the ship's roll counter to 5, with the sign set to
 AND #%10000000         \ positive if the pitch counter and dot product have
 EOR #%10000101         \ different signs, negative if they have the same sign
 STA INWK+29


ELIF _6502SP_VERSION

 TAX

 EOR INWK+30
 AND #%10000000
 EOR #%10000000
 STA INWK+29
 TXA
 ASL A
 CMP RAT2
 BCC TA12
 LDA RAT
 ORA INWK+29
 STA INWK+29

.TA12

ENDIF

.TA6

 LDA CNT                \ Fetch the dot product, and if it's negative jump to
 BMI TA9                \ TA9, as the ships are facing away from each other and
                        \ the ship might want to slow down to take another shot

IF _CASSETTE_VERSION

 CMP #22                \ The dot product is positive, so the ships are facing
 BCC TA9                \ each other. If A < 22 then the ships are not heading
                        \ directly towards each other, so jump to TA9 to slow
                        \ down

ELIF _6502SP_VERSION

 CMP CNT2
 BCC TA9

.PH10E

ENDIF

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

 STA INWK+28            \ Ser the ship's acceleration to A

.TA10

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION

.^TA151

 LDY #10
 JSR TAS3
 CMP #&98
 BCC ttt
 LDX #0
 STX RAT2

.ttt

 JMP TA152

ENDIF

