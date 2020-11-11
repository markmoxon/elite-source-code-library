\ ******************************************************************************
\
\       Name: TACTICS (Part 3 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Calculate dot product to determine ship's aim
\
\ ------------------------------------------------------------------------------
\
\ This section sets up some vectors and calculates dot products. Specifically:
\
\   * Calculate the dot product of the ship's nose vector (i.e. the direction it
\     is pointing) with the vector between us and the ship. This value will help
\     us work out later on whether the enemy ship is pointing towards us, and
\     therefore whether it can hit us with its lasers.
\
\ ******************************************************************************

.TA21

IF _6502SP_VERSION

 CPX #TGL
 BNE TA14
 LDA MANY+THG
 BNE TA14
 LSR INWK+32
 ASL INWK+32
 LSR INWK+27

.TA22

 RTS

.TA14

 JSR DORND
 LDA NEWB
 LSR A
 BCC TN1
 CPX #50
 BCS TA22

.TN1

 LSR A
 BCC TN2
 LDX FIST
 CPX #40
 BCC TN2
 LDA NEWB
 ORA #4
 STA NEWB
 LSR A
 LSR A

.TN2

 LSR A
 BCS TN3
 LSR A
 LSR A
 BCC GOPL
 JMP DOCKIT

.^GOPL

 JSR SPS1
 JMP TA151

.TN3

 LSR A
 BCC TN4
 LDA SSPR
 BEQ TN4
 LDA INWK+32
 AND #129
 STA INWK+32

.TN4

ENDIF

 LDX #8                 \ We now want to copy the ship's x, y and z coordinates
                        \ from INWK to K3, so set up a counter for 9 bytes

.TAL1

 LDA INWK,X             \ Copy the X-th byte from INWK to the X-th byte of K3
 STA K3,X

 DEX                    \ Decrement the counter

 BPL TAL1               \ Loop back until we have copied all 9 bytes

.TA19

                        \ If this is a missile that's heading for its target
                        \ (not us, one of the other ships), then the missile
                        \ routine at TA18 above jumps here after setting K3 to
                        \ the vector from the target to the missile

 JSR TAS2               \ Normalise the vector in K3 and store the normalised
                        \ version in XX15, so XX15 contains the normalised
                        \ vector from our ship to the ship we are applying AI
                        \ tactics to (or the normalised vector from the target
                        \ to the missile - in both cases it's the vector from
                        \ the potential victim to the attacker)

 LDY #10                \ Set (A X) = nosev . XX15
 JSR TAS3

 STA CNT                \ Store the high byte of the dot product in CNT. The
                        \ bigger the value, the more aligned the two ships are,
                        \ with a maximum magnitude of 36 (96 * 96 >> 8). If CNT
                        \ is positive, the ships are facing in a similar
                        \ direction, if it's negative they are facing in
                        \ opposite directions

