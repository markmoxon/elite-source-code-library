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
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is set to &FF
\
\ ******************************************************************************

.RES2

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\JSR stopbd             \ This instruction is commented out in the original
                        \ source

ELIF _C64_VERSION

 JSR stopbd             \ Stop playing the docking music (if it is playing)

 LDA BOMB               \ If the energy bomb has been set off, then BOMB will be
 BPL BOMBOK             \ negative, so this skips the following instructions if
                        \ our energy bomb is not going off

 JSR BOMBOFF            \ Switch off the energy bomb effect

 STA BOMB               \ The call to BOMBOFF sets A = 0, so this zeroes BOMB to
                        \ switch off the energy bomb explosion

.BOMBOK

ENDIF

IF _NES_VERSION

 SEI                    \ Disable interrupts from any source except NMI, as we
                        \ don't want any other interrupts to occur

 LDA #1                 \ Set enableBitplanes to 1 so the game starts to use
 STA enableBitplanes    \ two different bitplanes when displaying the screen

 LDA #1                 \ Set the tile number for the left edge of the box to
 STA boxEdge1           \ tile 1, which is the standard edge for the box

 LDA #2                 \ Set the tile number for the right edge of the box to
 STA boxEdge2           \ tile 2, which is the standard edge for the box

 LDA #80                \ Tell the PPU to send nametable entries up to tile
 STA lastNameTile       \ 80 * 8 = 640 (i.e. to the end of tile row 19) in both
 STA lastNameTile+1     \ bitplanes

 LDA BOMB               \ If the energy bomb has not been set off, jump to rese1
 BPL rese1              \ to skip the following

 JSR HideHiddenColour   \ Set the hidden colour to black, to switch off the
                        \ energy bomb effect (as the effect works by showing
                        \ hidden content instead of the visible content)

 STA BOMB               \ The call to HideHiddenColour sets A = 15, which has
                        \ bit 7 clear, so this clears bit 7 of BOMB to disable
                        \ the energy bomb explosion

.rese1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Electron: The Electron version has a hard-coded number of stardust particles on-screen, so there is no need to reset it after launch from the station

 LDA #NOST              \ Reset NOSTM, the number of stardust particles, to the
 STA NOSTM              \ maximum allowed (18)

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDA #NOST              \ Reset NOSTM, the number of stardust particles, to the
 STA NOSTM              \ maximum allowed (20)

ENDIF

IF NOT(_NES_VERSION)

 LDX #&FF               \ Reset LSX2 and LSY2, the ball line heaps used by the
 STX LSX2               \ BLINE routine for drawing circles, to &FF, to set the
 STX LSY2               \ heap to empty

 STX MSTG               \ Reset MSTG, the missile target, to &FF (no target)

ELIF _NES_VERSION

 LDX #&FF               \ Reset MSTG, the missile target, to &FF (no target)
 STX MSTG

 LDA allowInSystemJump  \ Set bit 7 of allowInSystemJump to prevent us from
 ORA #%10000000         \ being able to perform an in-system jump, as this is
 STA allowInSystemJump  \ the default setting after launching

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA #128               \ Set the current pitch rate to the mid-point, 128
 STA JSTY

 STA ALP2               \ Reset ALP2 (roll sign) and BET2 (pitch sign)
 STA BET2               \ to negative, i.e. pitch and roll negative

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA #128               \ Set the current pitch and roll rates to the mid-point,
 STA JSTX               \ 128
 STA JSTY

ELIF _ELITE_A_6502SP_PARA OR _NES_VERSION

 LDA #128               \ Set the current pitch and roll rates to the mid-point,
 STA JSTX               \ 128
 STA JSTY

 STA ALP2               \ Reset ALP2 (roll sign) and BET2 (pitch sign)
 STA BET2               \ to negative, i.e. pitch and roll negative

ENDIF

 ASL A                  \ This sets A to 0

IF _NES_VERSION

 STA demoInProgress     \ Set demoInProgress to 0 to reset the demo flag, so if
                        \ we are starting the game after playing the demo, the
                        \ flag will be set correctly

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 STA BETA               \ Reset BETA (pitch angle alpha) to 0

 STA BET1               \ Reset BET1 (magnitude of the pitch angle) to 0

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 STA ALP2+1             \ Reset ALP2+1 (flipped roll sign) and BET2+1 (flipped
 STA BET2+1             \ pitch sign) to positive, i.e. pitch and roll negative

ENDIF

 STA MCNT               \ Reset MCNT (the main loop counter) to 0

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\STA TRIBCT             \ This instruction is commented out in the original
                        \ source; it is left over from the Commodore 64 version
                        \ of Elite and would reset the number of Trumbles

ELIF _C64_VERSION

 STA TRIBCT             \ Reset TRIBCT (the Trumbles counter) to 0

ENDIF

IF _NES_VERSION

 STA LAS                \ Set LAS to 0, to switch off laser pulsing

 STA unusedVariable     \ Set unusedVariable to 0 (this is never read, so this
                        \ has no effect)

 STA chargeDockingFee   \ Set chargeDockingFee to 0 so the docking fee is marked
                        \ as being not already paid

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Platform

 STA QQ22+1             \ Set the on-screen hyperspace counter to 0

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Label

.modify

ENDIF

 LDA #3                 \ Reset DELTA (speed) to 3
 STA DELTA

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 STA ALPHA              \ Reset ALPHA (roll angle alpha) to 3

 STA ALP1               \ Reset ALP1 (magnitude of roll angle alpha) to 3

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

\LDA #&10               \ These instructions are commented out in the original
\STA COL2               \ source

 LDA #0                 \ Set dontclip to 0 (though this variable is never used,
 STA dontclip           \ so this has no effect)

 LDA #2*Y-1             \ Set Yx2M1 to the number of pixel lines in the space
 STA Yx2M1              \ view

ELIF _C64_VERSION

 LDA #&10               \ Switch the text colour to white
 STA COL2

 LDA #0                 \ Set dontclip to 0 ???
 STA dontclip

 LDA #2*Y-1             \ Set Yx2M1 to the number of pixel lines in the space
 STA Yx2M1              \ view

ELIF _NES_VERSION

 LDA #72                \ Set the screen height variables for a screen height of
 JSR SetScreenHeight    \ 144 (i.e. 2 * 72)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA SSPR               \ Fetch the "space station present" flag, and if we are
 BEQ P%+5               \ not inside the safe zone, skip the next instruction

 JSR SPBLB              \ Light up the space station bulb on the dashboard

ENDIF

 LDA ECMA               \ Fetch the E.C.M. status flag, and if E.C.M. is off,
 BEQ yu                 \ skip the next instruction

 JSR ECMOF              \ Turn off the E.C.M. sound

.yu

 JSR WPSHPS             \ Wipe all ships from the scanner

IF _NES_VERSION

 LDA QQ11a              \ If bit 7 of the old view in QQ11a is set, then the old
 BMI rese2              \ view does not have a dashboard, so jump to rese2 to
                        \ skip the following, as there is no scanner to clear

 JSR HideExplosionBurst \ Hide the four sprites that make up the explosion burst

 JSR ClearScanner       \ Remove all ships from the scanner and hide the scanner
                        \ sprites

.rese2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR ZERO               \ Reset the ship slots for the local bubble of universe,
                        \ and various flight and ship status variables

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #LO(WP-1)          \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to the byte before the WP workspace to indicate
 LDA #HI(WP-1)          \ that the heap is empty
 STA SLSP+1

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDA #LO(LS%)           \ We have reset the ship line heap, so we now point
 STA SLSP               \ SLSP to LS% (the byte below the ship blueprints at D%)
 LDA #HI(LS%)           \ to indicate that the heap is empty
 STA SLSP+1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _6502SP_VERSION \ Platform

 JSR DIALS              \ Update the dashboard

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA \ Platform

 JSR U%                 \ Call U% to clear the key logger

ENDIF

                        \ Finally, fall through into ZINF to reset the INWK
                        \ ship workspace

