\ ******************************************************************************
\
\       Name: Ze
\       Type: Subroutine
\   Category: Universe
\    Summary: Initialise the INWK workspace to a hostile ship
\  Deep dive: Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ Specifically, this routine does the following:
\
\   * Reset the INWK ship workspace
\
\   * Set the ship to a fair distance away in all axes, in front of us but
\     randomly up or down, left or right
\
\   * Give the ship a 4% chance of having E.C.M.
\
\   * Set the ship to hostile, with AI enabled
\
\ This routine also sets A, X, T1 and the C flag to random values.
\
\ Note that because this routine uses the value of X returned by DORND, and X
\ contains the value of A returned by the previous call to DORND, this routine
\ does not necessarily set the new ship to a totally random location. See the
\ deep dive on "Fixing ship positions" for details.
\
\ ******************************************************************************

.Ze

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR DORND              \ Set A and X to random numbers

 STA T1                 \ Store A in T1

 AND #%10000000         \ Extract the sign of A and store in x_sign
 STA INWK+2

 TXA                    \ Extract the sign of X and store in y_sign
 AND #%10000000
 STA INWK+5

ELIF _ELITE_A_VERSION

 JSR rand_posn          \ Call rand_posn to set up the INWK workspace for a ship
                        \ in a random ship position, and set T1 to a random
                        \ number

ELIF _NES_VERSION

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR DORND              \ Set A and X to random numbers

 STA T1                 \ Store A in T1

 AND #%10000000         \ Extract the sign of A and store in x_sign
 STA INWK+2

 JSR DORND              \ Set A and X to random numbers

 AND #%10000000         \ Extract the sign of A and store in y_sign
 STA INWK+5

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: The cassette version spawns new ships at a distance of 32 unit vectors, while the other versions spawn new ships noticeably closer, at a distance of 25 unit vectors

 LDA #32                \ Set x_hi = y_hi = z_hi = 32, a fair distance away
 STA INWK+1
 STA INWK+4
 STA INWK+7

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA #25                \ Set x_hi = y_hi = z_hi = 25, a fair distance away
 STA INWK+1
 STA INWK+4
 STA INWK+7

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION OR _NES_VERSION \ Other: When spawning hostile ships in space, the cassette and 6502SP versions reuse the previous random number in X for the 4% check (i.e. the one used to determine the x and y signs of the new ship), while the disc version generates a new random number instead of reusing, so this change presumably improves the randomness of the spawning in the disc version somehow

 TXA                    \ Set the C flag if X >= 245 (4% chance)
 CMP #245

ELIF _DISC_FLIGHT

 JSR DORND              \ Set A and X to random numbers

 CMP #245               \ Set the C flag if A >= 245 (4% chance)

ELIF _ELITE_A_VERSION

 CMP #245               \ Set the C flag if A >= 245 (4% chance)

ENDIF

 ROL A                  \ Set bit 0 of A to the C flag (i.e. there's a 4%
                        \ chance of this ship having E.C.M.)

 ORA #%11000000         \ Set bits 6 and 7 of A, so the ship is hostile (bit 6
                        \ and has AI (bit 7)

 STA INWK+32            \ Store A in the AI flag of this ship

IF NOT(_NES_VERSION)

                        \ Fall through into DORND2 to set A, X and the C flag
                        \ randomly

ELIF _NES_VERSION

 JMP DORND2             \ Jump to DORND2 to set A, X and the C flag randomly,
                        \ returning from the subroutine using a tail call

ENDIF

