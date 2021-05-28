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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: The Electron version has a hard-coded number of stardust particles on-screen, so there is no need to reset it after launch from the station

 LDA #NOST              \ Reset NOSTM, the number of stardust particles, to the
 STA NOSTM              \ maximum allowed (18)

ENDIF

 LDX #&FF               \ Reset LSX2 and LSY2, the ball line heaps used by the
 STX LSX2               \ BLINE routine for drawing circles, to &FF, to set the
 STX LSY2               \ heap to empty

 STX MSTG               \ Reset MSTG, the missile target, to &FF (no target)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Platform

 LDA #128               \ Set the current pitch rate to the mid-point, 128
 STA JSTY

 STA ALP2               \ Reset ALP2 (roll sign) and BET2 (pitch sign)
 STA BET2               \ to negative, i.e. pitch and roll negative

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA #128               \ Set the current pitch and roll rates to the mid-point,
 STA JSTX               \ 128
 STA JSTY

ELIF _ELITE_A_6502SP_PARA

 LDA #128               \ Set the current pitch and roll rates to the mid-point,
 STA JSTX               \ 128
 STA JSTY

 STA &32                \ AJD
 STA &7B

ENDIF

 ASL A                  \ This sets A to 0

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 STA BETA               \ Reset BETA (pitch angle alpha) to 0

 STA BET1               \ Reset BET1 (magnitude of the pitch angle) to 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 STA ALP2+1             \ Reset ALP2+1 (flipped roll sign) and BET2+1 (flipped
 STA BET2+1             \ pitch sign) to positive, i.e. pitch and roll negative

ENDIF

 STA MCNT               \ Reset MCNT (the main loop counter) to 0

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Platform

 STA QQ22+1             \ Set the on-screen hyperspace counter to 0

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Label

.modify

ENDIF

 LDA #3                 \ Reset DELTA (speed) to 3
 STA DELTA

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 STA ALPHA              \ Reset ALPHA (roll angle alpha) to 3

 STA ALP1               \ Reset ALP1 (magnitude of roll angle alpha) to 3

ENDIF

IF _MASTER_VERSION \ Platform

 LDA #0                 \ Set XMAX to 0 (though this variable is never used, so
 STA XMAX               \ this has no effect)

 LDA #191               \ Set YMAX to 191, the number of pixel lines in the
 STA YMAX               \ space view

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA SSPR               \ Fetch the "space station present" flag, and if we are
 BEQ P%+5               \ not inside the safe zone, skip the next instruction

 JSR SPBLB              \ Light up the space station bulb on the dashboard

ENDIF

 LDA ECMA               \ Fetch the E.C.M. status flag, and if E.C.M. is off,
 BEQ yu                 \ skip the next instruction

 JSR ECMOF              \ Turn off the E.C.M. sound

.yu

 JSR WPSHPS             \ Wipe all ships from the scanner

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR ZERO               \ Reset the ship slots for the local bubble of universe,
                        \ and various flight and ship status variables

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #LO(WP-1)          \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to the byte before the WP workspace to indicate
 LDA #HI(WP-1)          \ that the heap is empty
 STA SLSP+1

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA #LO(LS%)           \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to LS% (the byte below the ship blueprints at D%)
 LDA #HI(LS%)           \ to indicate that the heap is empty
 STA SLSP+1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION \ Platform

 JSR DIALS              \ Update the dashboard

ENDIF
                        \ Finally, fall through into ZINF to reset the INWK
                        \ ship workspace

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Platform

 JSR U%                 \ Call U% to clear the key logger

ENDIF

