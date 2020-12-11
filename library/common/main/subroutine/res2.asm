\ ******************************************************************************
\
\       Name: RES2
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset a number of flight variables and workspaces
\
\ ------------------------------------------------------------------------------
\
\ This is called after we launch from a space station, arrive in a new system
\ after hyperspace, launch an escape pod, or die a cold, lonely death in the
\ depths of space.
\
\ Returns:
\
\   Y                   Y is set to &FF
\
\ ******************************************************************************

.RES2

 LDA #NOST              \ Reset NOSTM, the number of stardust particles, to the
 STA NOSTM              \ maximum allowed (18)

 LDX #&FF               \ Reset LSX2 and LSY2, the ball line heaps used by the
 STX LSX2               \ BLINE routine for drawing circles, to &FF, to set the
 STX LSY2               \ heap to empty

 STX MSTG               \ Reset MSTG, the missile target, to &FF (no target)

 LDA #128               \ Set the current pitch rate to the mid-point, 128
 STA JSTY

 STA ALP2               \ Reset ALP2 (roll sign) and BET2 (pitch sign)
 STA BET2               \ to negative, i.e. pitch and roll negative

 ASL A                  \ This sets A to 0

IF _6502SP_VERSION

 STA BETA               \ Reset BETA (pitch angle alpha) to 0

 STA BET1               \ Reset BET1 (magnitude of the pitch angle) to 0

ENDIF

 STA ALP2+1             \ Reset ALP2+1 (flipped roll sign) and BET2+1 (flipped
 STA BET2+1             \ pitch sign) to positive, i.e. pitch and roll negative

 STA MCNT               \ Reset MCNT (the main loop counter) to 0

 LDA #3                 \ Reset DELTA (speed) to 3
 STA DELTA

 STA ALPHA              \ Reset ALPHA (roll angle alpha) to 3

 STA ALP1               \ Reset ALP1 (magnitude of roll angle alpha) to 3

 LDA SSPR               \ Fetch the "space station present" flag, and if we are
 BEQ P%+5               \ not inside the safe zone, skip the next instruction

 JSR SPBLB              \ Light up the space station bulb on the dashboard

 LDA ECMA               \ Fetch the E.C.M. status flag, and if E.C.M. is off,
 BEQ yu                 \ skip the next instruction

 JSR ECMOF              \ Turn off the E.C.M. sound

.yu

 JSR WPSHPS             \ Wipe all ships from the scanner

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

IF _CASSETTE_VERSION

 LDA #LO(WP-1)          \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to the byte before the WP workspace to indicate
 LDA #HI(WP-1)          \ that the heap is empty
 STA SLSP+1

ELIF _6502SP_VERSION

 LDA #LO(LS%)           \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to LS% to indicate that the heap is empty
 LDA #HI(LS%)
 STA SLSP+1

ENDIF

 JSR DIALS              \ Update the dashboard

                        \ Finally, fall through into ZINF to reset the INWK
                        \ ship workspace
