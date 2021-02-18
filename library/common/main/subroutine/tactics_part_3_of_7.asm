\ ******************************************************************************
\
\       Name: TACTICS (Part 3 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Calculate dot product to determine ship's aim
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section sets up some vectors and calculates dot products. Specifically:
\
IF _6502SP_VERSION OR _DISC_VERSION
\   * If this is a lone Thargon without a mothership, set it adrift aimlessly
\     and we're done
\
\   * If this is a trader, 80% of the time we're done, 20% of the time the
\     trader performs the same checks as the bounty hunter
\
\   * If this is a bounty hunter (or one of the 20% of traders) and we have been
\     really bad (i.e. a fugitive or serious offender), the ship becomes hostile
\     (if it isn't already)
\
\   * If the ship is not hostile, then either perform docking manouevres (if
\     it's docking) or fly towards the planet (if it isn't docking) and we're
\     done
\
\   * If the ship is hostile, and a pirate, and we are within the space station
\     safe zone, stop the pirate from attacking by removing all its aggression
\
ENDIF
\   * Calculate the dot product of the ship's nose vector (i.e. the direction it
\     is pointing) with the vector between us and the ship. This value will help
\     us work out later on whether the enemy ship is pointing towards us, and
\     therefore whether it can hit us with its lasers.
\
IF _6502SP_VERSION OR _DISC_VERSION
\ Other entry points:
\
\   GOPL                Make the ship head towards the planet
\
ENDIF
\ ******************************************************************************

.TA21

IF _6502SP_VERSION OR _DISC_VERSION

 CPX #TGL               \ If this is not a Thargon, jump down to TA14
 BNE TA14

 LDA MANY+THG           \ If there is at least one Thargoid in the vicinity,
 BNE TA14               \ jump down to TA14

 LSR INWK+32            \ This is a Thargon but there is no Thargoid mothership,
 ASL INWK+32            \ so clear bit 0 of the AI flag to disable its E.C.M.

 LSR INWK+27            \ And halve the Thargon's speed


.TA22

 RTS                    \ Return from the subroutine

.TA14

 JSR DORND              \ Set A and X to random numbers

 LDA NEWB               \ Extract bit 0 of the ship's NEWB flags into the C flag
 LSR A                  \ and jump to TN1 if it is clear (i.e. if this is not a
 BCC TN1                \ trader)

ENDIF

IF _DISC_VERSION

 CPX #100               \ This is a trader, so if X >= 100 (61% chance), return
 BCS TA22               \ from the subroutine (as TA22 contains an RTS)

ELIF _6502SP_VERSION

 CPX #50                \ This is a trader, so if X >= 50 (80% chance), return
 BCS TA22               \ from the subroutine (as TA22 contains an RTS)

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION

.TN1

 LSR A                  \ Extract bit 1 of the ship's NEWB flags into the C flag
 BCC TN2                \ and jump to TN2 if it is clear (i.e. if this is not a
                        \ bounty hunter)

 LDX FIST               \ This is a bounty hunter, so check whether our FIST
 CPX #40                \ rating is < 40 (where 50 is a fugitive), and jump to
 BCC TN2                \ TN2 if we are not 100% evil

 LDA NEWB               \ We are a fugitive or a bad offender, and this ship is
 ORA #%00000100         \ a bounty hunter, so set bit 2 of the ship's NEWB flags
 STA NEWB               \ to make it hostile

 LSR A                  \ Shift A right twice so the next test in TN2 will check
 LSR A                  \ bit 2

.TN2

 LSR A                  \ Extract bit 2 of the ship's NEWB flags into the C flag
 BCS TN3                \ and jump to TN3 if it is set (i.e. if this ship is
                        \ hostile)

 LSR A                  \ The ship is not hostile, so extract bit 4 of the
 LSR A                  \ ship's NEWB flags into the C flag, and jump to GOPL if
 BCC GOPL               \ it is clear (i.e. if this ship is not docking)

 JMP DOCKIT             \ The ship is not hostile and is docking, so jump to
                        \ DOCKIT to apply the docking algorithm to this ship

.GOPL

 JSR SPS1               \ The ship is not hostile and it is not docking, so call
                        \ SPS1 to calculate the vector to the planet and store
                        \ it in XX15

 JMP TA151              \ Jump to TA151 to make the ship head towards the planet

.TN3

 LSR A                  \ Extract bit 2 of the ship's NEWB flags into the C flag
 BCC TN4                \ and jump to TN4 if it is clear (i.e. if this ship is
                        \ not a pirate)

 LDA SSPR               \ If we are not inside the space station safe zone, jump
 BEQ TN4                \ to TN4

                        \ If we get here then this is a pirate and we are inside
                        \ the space station safe zone

 LDA INWK+32            \ Set bits 0 and 7 of the AI flag in byte #32 (has AI
 AND #%10000001         \ enabled and has an E.C.M.)
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

IF _CASSETTE_VERSION OR _6502SP_VERSION

 LDY #10                \ Set (A X) = nosev . XX15
 JSR TAS3

ELIF _DISC_VERSION

 JSR TAS3-2             \ Set (A X) = nosev . XX15

ENDIF

 STA CNT                \ Store the high byte of the dot product in CNT. The
                        \ bigger the value, the more aligned the two ships are,
                        \ with a maximum magnitude of 36 (96 * 96 >> 8). If CNT
                        \ is positive, the ships are facing in a similar
                        \ direction, if it's negative they are facing in
                        \ opposite directions

