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

IF _CASSETTE_VERSION

 LDA MJ                 \ Store the value of MJ on the stack (the "are we in
 PHA                    \ witchspace?" flag)

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDX #CYL               \ Set the current ship type to a Cobra Mk III, so we
 STX TYPE               \ can show our ship disappear into the distance when we
                        \ eject in our pod

 JSR FRS1               \ Call FRS1 to launch the Cobra Mk III straight ahead,
                        \ like a missile launch, but with our ship instead

IF _6502SP_VERSION

 BCS ES1
 LDX #CYL2
 JSR FRS1

.ES1

ENDIF

 LDA #8                 \ Set the Cobra's byte #27 (speed) to 8
 STA INWK+27

 LDA #194               \ Set the Cobra's byte #30 (pitch counter) to 194, so it
 STA INWK+30            \ pitches as we pull away

 LSR A                  \ Set the Cobra's byte #32 (AI flag) to %01100001, so it
 STA INWK+32            \ has no AI, and we can use this value as a counter to
                        \ do the following loop 97 times

.ESL1

 JSR MVEIT              \ Call MVEIT to move the Cobra in space

 JSR LL9                \ Call LL9 to draw the Cobra on-screen

 DEC INWK+32            \ Decrement the counter in byte #32

 BNE ESL1               \ Loop back to keep moving the Cobra until the AI flag
                        \ is 0, which gives it time to drift away from our pod

 JSR SCAN               \ Call SCAN to remove all ships from the scanner

IF _CASSETTE_VERSION

 JSR RESET              \ Call RESET to reset our ship and various controls

 PLA                    \ Restore the witchspace flag from before the escape pod
 BEQ P%+5               \ launch, and if we were in normal space, skip the
                        \ following instruction

 JMP DEATH              \ Launching an escape pod in witchspace is fatal, so
                        \ jump to DEATH to begin the funeral and return from the
                        \ subroutine using a tail call

ELIF _6502SP_VERSION

 LDA #0

ENDIF

 LDX #16                \ We lose all our cargo when using our escape pod, so
                        \ up a counter in X so we can zero the 17 cargo slots
                        \ in QQ20

.ESL2

 STA QQ20,X             \ Set the X-th byte of QQ20 to zero (as we know A = 0
                        \ from the BEQ above), so we no longer have any of item
                        \ type X in the cargo hold

 DEX                    \ Decrement the counter

 BPL ESL2               \ Loop back to ESL2 until we have emptied the entire
                        \ cargo hold

 STA FIST               \ Launching an escape pod also clears our criminal
                        \ record, so set our legal status in FIST to 0 ("clean")

 STA ESCP               \ The escape pod is a one-use item, so set ESCP to 0 so
                        \ we no longer have one fitted

 LDA #70                \ Our replacement ship is delivered with a full tank of
 STA QQ14               \ fuel, so set the current fuel level in QQ14 to 70, or
                        \ 7.0 light years

IF _CASSETTE_VERSION

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen) and return from the subroutine with a tail
                        \ call

ELIF _6502SP_VERSION

 JMP GOIN

ENDIF

