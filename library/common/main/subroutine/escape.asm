\ ******************************************************************************
\
\       Name: ESCAPE
\       Type: Subroutine
\   Category: Flight
\    Summary: Launch our escape pod
\
\ ------------------------------------------------------------------------------
\
\ This routine displays our doomed Cobra Mk III disappearing off into the ether
\ before arranging our replacement ship. Called when we press ESCAPE during
\ flight and have an escape pod fitted.
\
\ ******************************************************************************

.ESCAPE

IF _CASSETTE_VERSION \ Standard: Group A: In the cassette version, launching an escape pod in witchspace is immediately fatal, while in the disc version it launches properly. In the advanced versions, meanwhile, the launch key is disabled as soon as you enter witchspace

 LDA MJ                 \ Store the value of MJ on the stack (the "are we in
 PHA                    \ witchspace?" flag)

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

IF _NES_VERSION

 LDY #&13               \ ???
 JSR NOISE
 LDA #0
 STA ESCP
 JSR subm_AC5C_b3
 LDA QQ11
 BNE C8BFF

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: Group B: When you launch an escape pod in the Electron version, you don't see an animation of your Cobra Mk III drifting away, but jump straight into the station

 LDX #CYL               \ Set the current ship type to a Cobra Mk III, so we
 STX TYPE               \ can show our ship disappear into the distance when we
                        \ eject in our pod

 JSR FRS1               \ Call FRS1 to launch the Cobra Mk III straight ahead,
                        \ like a missile launch, but with our ship instead

ELIF _ELITE_A_VERSION

 LDX #ESC               \ Set the current ship type to an escape pod, so we can
 STX TYPE               \ show it disappearing into the distance when we eject
                        \ in our pod

 JSR FRS1               \ Call FRS1 to launch the escape pod straight ahead,
                        \ like a missile launch, but with our ship instead

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: When trying to spawn a Cobra Mk III to display when we use an escape pod, the enhanced versions will first try to spawn a normal Cobra, and if that fails, they will try again with a pirate Cobra

 BCS ES1                \ If the Cobra was successfully added to the local
                        \ bubble, jump to ES1 to skip the following instructions

 LDX #CYL2              \ The Cobra wasn't added to the local bubble for some
 JSR FRS1               \ reason, so try launching a pirate Cobra Mk III instead

.ES1

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: See group B

 LDA #8                 \ Set the Cobra's byte #27 (speed) to 8
 STA INWK+27

 LDA #194               \ Set the Cobra's byte #30 (pitch counter) to 194, so it
 STA INWK+30            \ pitches as we pull away

 LSR A                  \ Set the Cobra's byte #32 (AI flag) to %01100001, so it
 STA INWK+32            \ has no AI, and we can use this value as a counter to
                        \ do the following loop 97 times

ELIF _ELITE_A_VERSION

 LDA #16                \ Set the escape pod's byte #27 (speed) to 8
 STA INWK+27

 LDA #194               \ Set the escape pod's byte #30 (pitch counter) to 194,
 STA INWK+30            \ so it pitches as we pull away

 LSR A                  \ Set the escape pod's byte #32 (AI flag) to %01100001,
 STA INWK+32            \ so it has no AI, and we can use this value as a
                        \ counter to do the following loop 97 times

ELIF _NES_VERSION

 LDA #8                 \ Set the Cobra's byte #27 (speed) to 8
 STA INWK+27

 LDA #194               \ Set the Cobra's byte #30 (pitch counter) to 194, so it
 STA INWK+30            \ pitches as we pull away

 LDA #%00101100         \ Set the Cobra's byte #32 (AI flag) to %00101100, so it
 STA INWK+32            \ has no AI, and we can use this value as a counter to
                        \ do the following loop 44 times

ENDIF

.ESL1

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: See group B

 JSR MVEIT              \ Call MVEIT to move the Cobra in space

ELIF _ELITE_A_FLIGHT

 JSR MVEIT              \ Call MVEIT to move the escape pod in space

ELIF _ELITE_A_6502SP_PARA

 JSR MVEIT_FLIGHT       \ Call MVEIT_FLIGHT to move the escape pod in space

ENDIF

IF _MASTER_VERSION \ Master: In the Master version, if you launch your escape pod while looking out of the side or rear views, you won't see your Cobra as you leave it behind, while in the other versions you do

 LDA QQ11               \ If either of QQ11 or VIEW is non-zero (i.e. this is
 ORA VIEW               \ not the front space view), skip the following
 BNE P%+5               \ instruction

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: See group B

 JSR LL9                \ Call LL9 to draw the Cobra on-screen

 DEC INWK+32            \ Decrement the counter in byte #32

 BNE ESL1               \ Loop back to keep moving the Cobra until the AI flag
                        \ is 0, which gives it time to drift away from our pod

 JSR SCAN               \ Call SCAN to remove the Cobra from the scanner (by
                        \ redrawing it)

ELIF _ELITE_A_6502SP_PARA

 JSR LL9_FLIGHT         \ Call LL9 to draw the Cobra on-screen

 DEC INWK+32            \ Decrement the counter in byte #32

 BNE ESL1               \ Loop back to keep moving the Cobra until the AI flag
                        \ is 0, which gives it time to drift away from our pod

 JSR SCAN               \ Call SCAN to remove the Cobra from the scanner (by
                        \ redrawing it)

ELIF _NES_VERSION

 JSR DrawShipInNewPlane \ ???

 DEC INWK+32            \ Decrement the counter in byte #32

 BNE ESL1               \ Loop back to keep moving the Cobra until the AI flag
                        \ is 0, which gives it time to drift away from our pod

.C8BFF

ENDIF

IF _CASSETTE_VERSION \ Standard: See group A

 JSR RESET              \ Call RESET to reset our ship and various controls

 PLA                    \ Restore the witchspace flag from before the escape pod
 BEQ P%+5               \ launch, and if we were in normal space, skip the
                        \ following instruction

 JMP DEATH              \ Launching an escape pod in witchspace is fatal, so
                        \ jump to DEATH to begin the funeral and return from the
                        \ subroutine using a tail call

ELIF _ELECTRON_VERSION

 JSR RESET              \ Call RESET to reset our ship and various controls

 LDA #0                 \ Set A = 0 so we can use it to zero the contents of
                        \ the cargo hold

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA #0                 \ Set A = 0 so we can use it to zero the contents of
                        \ the cargo hold

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDX #16                \ We lose all our cargo when using our escape pod, so
                        \ up a counter in X so we can zero the 17 cargo slots
                        \ in QQ20

ELIF _ELITE_A_VERSION

 STA QQ20+16            \ We lose any alien items when using our escape pod, so
                        \ set QQ20+16 to 0 (which is where they are stored)

 LDX #12                \ We lose all our cargo canisters when using our escape
                        \ pod (i.e. all the cargo except gold, platinum and gem
                        \ stones), so up a counter in X so we can zero cargo
                        \ slots 0-12 in QQ20

ENDIF

.ESL2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

 STA QQ20,X             \ Set the X-th byte of QQ20 to zero (as we know A = 0
                        \ from the BEQ above), so we no longer have any of item
                        \ type X in the cargo hold

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 STA QQ20,X             \ Set the X-th byte of QQ20 to zero, so we no longer
                        \ have any of item type X in the cargo hold

ENDIF

 DEX                    \ Decrement the counter

 BPL ESL2               \ Loop back to ESL2 until we have emptied the entire
                        \ cargo hold

 STA FIST               \ Launching an escape pod also clears our criminal
                        \ record, so set our legal status in FIST to 0 ("clean")

IF NOT(_NES_VERSION)

 STA ESCP               \ The escape pod is a one-use item, so set ESCP to 0 so
                        \ we no longer have one fitted

ENDIF

IF _MASTER_VERSION \ Comment

\LDA TRIBBLE            \ These instructions are commented out in the original
\ORA TRIBBLE+1          \ source
\BEQ nosurviv
\JSR DORND
\AND #7
\ORA #1
\STA TRIBBLE
\LDA #0
\STA TRIBBLE+1
\.nosurviv

ELIF _NES_VERSION

 LDA TRIBBLE            \ ???
 ORA TRIBBLE+1
 BEQ nosurviv
 JSR DORND
 AND #7
 ORA #1
 STA TRIBBLE
 LDA #0
 STA TRIBBLE+1

.nosurviv

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDA #70                \ Our replacement ship is delivered with a full tank of
 STA QQ14               \ fuel, so set the current fuel level in QQ14 to 70, or
                        \ 7.0 light years

ELIF _ELITE_A_FLIGHT

 INC new_hold           \ We just used our escape pod, and as it's a single-use
                        \ item, we no longer have an escape pod, so increment
                        \ the free space in our ship's hold, as the pod is no
                        \ longer taking up space

 LDA new_range          \ Our replacement ship is delivered with a full tank of
 STA QQ14               \ fuel, so fetch our current ship's hyperspace range
                        \ from new_range and set the current fuel level in QQ14
                        \ to this value

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

ELIF _ELITE_A_6502SP_PARA

 INC new_hold           \ We just used our escape pod, and as it's a single-use
                        \ item, we no longer have an escape pod, so increment
                        \ the free space in our ship's hold, as the pod is no
                        \ longer taking up space

 LDA new_range          \ Our replacement ship is delivered with a full tank of
 STA QQ14               \ fuel, so fetch our current ship's hyperspace range
                        \ from new_range and set the current fuel level in QQ14
                        \ to this value

 JSR update_pod         \ Update the dashboard colours as we no longer have an
                        \ escape pod

 JSR ping               \ Set the target system to the current system (which
                        \ will move the location in (QQ9, QQ10) to the current
                        \ home system

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen) and return from the subroutine with a tail
                        \ call

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JMP GOIN               \ Go to the docking bay (i.e. show the ship hangar
                        \ screen) and return from the subroutine with a tail
                        \ call

ENDIF

