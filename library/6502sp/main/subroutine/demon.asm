\ ******************************************************************************
\
\       Name: DEMON
\       Type: Subroutine
\   Category: Demo
\    Summary: Show the demo
\  Deep dive: The 6502 Second Processor demo mode
\             Secrets of the Executive version
\
\ ******************************************************************************

.DEMON

 LDA #1                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 1

 JSR RESET              \ Call RESET to initialise most of the game variables

 LDA #0                 \ Set ALPHA and ALP1 to 0, so our roll angle (i.e. that
 STA ALPHA              \ of the camera) is 0
 STA ALP1

 STA DELTA              \ Set DELTA to 0, so our current speed (i.e. that of the
                        \ camera) is 0

 STA scacol+CYL         \ Set the scanner colour for the Cobra Mk III to colour
                        \ 0 (black), so it doesn't appear on the scanner during
                        \ the demo

 JSR DOVDU19            \ Send a #SETVDU19 0 command to the I/O processor to
                        \ switch to the mode 1 palette for the space view,
                        \ which is yellow (colour 1), red (colour 2) and cyan
                        \ (colour 3)

 JSR nWq                \ Call nWq to create a random cloud of stardust

 LDX #LO(acorn)         \ Set (Y X) to the address of acorn, which contains the
 LDY #HI(acorn)         \ text: "ACORNSOFT PRESENTS" (or, in the Executive
                        \ version: "PIZZASOFT PRESENTS")

 JSR SLIDE              \ Call SLIDE to display the Star Wars scroll text

 JSR ZINF2              \ Call ZINF2 to reset INWK and the orientation vectors,
                        \ with nosev pointing into the screen. We are about to
                        \ add the Elite logo to the universe, and the logo's
                        \ nosev points out of the top of the logo, so this will
                        \ spawn the logo with it tilted back so it appears
                        \ on-edge, with the bottom of the logo pointing towards
                        \ the viewer

 LDA #%10000000         \ Set y_sign to be negative
 STA INWK+5

 LDA #100               \ Set y_lo = 100
 STA INWK+3

 LDA #LGO               \ Set the ship type to the Elite logo
 STA TYPE

 JSR NWSHP              \ Add a new Elite logo to the local bubble (in this
                        \ case, the demo screen), pointing INF to the new ship's
                        \ data block in K%

 LDA #150               \ Set a loop counter in MCNT to 150 for the grand
 STA MCNT               \ entrance of the logo, which takes it from z = 0 (right
                        \ up against the camera) to z = 450 (a fair distance in
                        \ front of us), moving the logo a distance of 3 away
                        \ from us with each iteration

.FLYL1

 LDA INWK+6             \ Set (z_hi z_lo) = (z_hi z_lo) + 3
 CLC                    \
 ADC #3                 \ starting with the low bytes
 STA INWK+6

 LDA INWK+7             \ And then adding the high bytes
 ADC #0
 STA INWK+7

 JSR LL9                \ Call LL9 to draw the logo on-screen

 DEC MCNT               \ Decrement the main loop counter

 BNE FLYL1              \ Loop back to FLYL1 until we have done 150 iterations,
                        \ after which (z_hi z_lo) = 150 * 3 = 450

.FLYL2

 LDA INWK+6             \ Set (z_hi z_lo) = (z_hi z_lo) + 2
 CLC                    \
 ADC #2                 \ starting with the low bytes
 STA INWK+6

 LDA INWK+7             \ And then adding the high bytes
 ADC #0
 STA INWK+7

 LDA #%10000000         \ Call TWIST2 with a negative A to pitch the logo by a
 JSR TWIST2             \ small angle in a negative direction

\DEC INWK+3             \ This instruction is commented out in the original
                        \ source, but it would decrement y_lo, moving the logo
                        \ down the screen

 JSR LL9                \ Call LL9 to draw the logo on-screen

 LDA INWK+14            \ Loop back to FLYL2 to keep pitching, until nosev_z_hi
 BPL FLYL2              \ is negative (i.e. the logo has pitched forward through
                        \ 90 degrees, as nosev starts out by pointing into the
                        \ screen towards the camera, in a positive direction,
                        \ and turns negative when it's reached the vertical).
                        \ In other words, we loop until the logo has tilted
                        \ towards the camera and is fully vertical in front of
                        \ the viewer

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace at INF, so the logo becomes the first
                        \ ship in the K% block

 JSR ZINF2              \ Call ZINF2 to reset INWK and the orientation vectors,
                        \ with nosev pointing into the screen

 LDA #108               \ Set y_lo = 108, so the Cobra we are about to spawn
 STA INWK+3             \ appears at the top of the screen

 LDA #40                \ Set z_lo = -40, so it appears a small distance behind
 STA INWK+6             \ the camera (the negative part is achieved by setting
 LDA #%10000000         \ z_sign in INWK+8 to be negative, so the ship is behind
 STA INWK+8             \ the camera)

 LDA #CYL               \ Set the ship type to a Cobra Mk III
 STA TYPE

 JSR NWSHP              \ Add a new Cobra Mk III to the local bubble (in this
                        \ case, the demo screen), pointing INF to the new ship's
                        \ data block in K%

 LDA #1                 \ Set the Cobra's speed to 1
 STA INWK+27

 STA HIMCNT             \ Set HIMCNT = 1 to act as an outer counter for the
                        \ following loop

 LDA #90                \ Set MCNT = 90 to act as an inner counter for the
 STA MCNT               \ following loop

 JSR TWIST              \ Call TWIST three times to pitch by a smallish angle in
 JSR TWIST              \ a positive direction (i.e. 3 x 3.6 degree, or 10.8
 JSR TWIST              \ degrees)

                        \ The following loop iterates 90 times while HIMCNT is 1
                        \ and 256 times while HIMCNT is 0, to give a total of
                        \ 346 iterations

.FLYL4

 JSR LL9                \ Call LL9 to draw the Cobra on-screen

 JSR MVEIT              \ Call MVEIT to move the Cobra slowly forward

 DEC MCNT               \ Decrement the inner counter in MCNT

 BNE FLYL4              \ Loop back to FLYL4 until the inner counter is 0

 DEC HIMCNT             \ Decrement the outer counter in HIMCNT

 BPL FLYL4              \ Loop back to FLYL4 until the outer counter is negative

 JSR ZZAAP              \ Call ZZAAP to draw a vertical laser line from the
                        \ Cobra

 LDA #0                 \ Call the NOISE routine with A = 0 to make the sound
 JSR NOISE              \ of a laser firing

 LDY #10                \ Wait for 10/50 of a second (0.2 seconds)
 JSR DELAY

 LDA #44                \ Set the Cobra's roll counter to 44 to make it roll in
 STA INWK+29            \ a positive direction (clockwise), for just under a
                        \ half roll (44 * 1/16 radians = 2.75 radians = 158
                        \ degrees)

 LDA #8                 \ Set the Cobra's speed to 8
 STA INWK+27

 LDA #&87               \ Set the Cobra's pitch counter to -7 to make it pitch
 STA INWK+30            \ slightly in a negative direction (pull up), so it
                        \ starts flying gently towards the top of the screen

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace at INF, so the Cobra becomes the
                        \ second ship in the K% block

 LDA #%10000000         \ Set bit 7 of byte #31 of the first ship in the K%
 TSB K%+31              \ block, which is the Elite logo, so this flags the logo
                        \ as having been killed (the TSB instruction applies the
                        \ accumulator to the memory location using an OR)

 JSR EXNO3              \ Make an explosion sound

 JSR ZZAAP              \ Call ZZAAP to redraw the vertical laser line from the
                        \ Cobra, which removes it from the screen

.FLYL5

                        \ We now want to draw the logo exploding, so we first
                        \ need to copy the logo's ship data block from K% to
                        \ INWK

 LDX #NI%-1             \ Set a counter in X so we can loop through the NI%
                        \ bytes in the ship data block

.DML3

 LDA K%,X               \ Copy the X-th byte of the first ship data block in K%
 STA INWK,X             \ to the X-th byte of INWK

 DEX                    \ Decrement the loop counter

 BPL DML3               \ Loop back for the next byte, until we have copied the
                        \ last byte from K% to INWK

 INX                    \ Increment X back to 0

 JSR GINF               \ Call GINF to fetch the address of the ship data block
                        \ for the ship in slot 0 (the logo) and store it in INF

 LDA XX21-2+2*LGO       \ Set XX0(1 0) to point to the ship blueprint for the
 STA XX0                \ Elite logo
 LDA XX21-1+2*LGO
 STA XX0+1

 LDA #LGO               \ Set the ship type to the Elite logo
 STA TYPE

 INC INWK               \ Increment x_lo to move the logo a little to the right

 JSR LL9                \ Call LL9 to draw the now-exploding logo on-screen

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace at INF

 JSR PBFL               \ Call PBFL to send the contents of the pixel buffer to
                        \ the I/O processor for plotting on-screen

 LDA INWK+31            \ Test whether bits 5 and 7 of the logo's byte #31 are
 AND #%10100000         \ both set ("ship is exploding" and "ship has been
 CMP #%10100000         \ killed") and store the resulting flags on the stack
 PHP

                        \ We now want to animate the Cobra flying into the
                        \ distance while rolling clockwise, so we first need to
                        \ copy the logo's ship data block from K% to INWK

 LDX #NI%-1             \ Set a counter in X so we can loop through the NI%
                        \ bytes in the ship data block

.DML4

 LDA K%+NI%,X           \ Copy the X-th byte of the second ship data block in K%
 STA INWK,X             \ to the X-th byte of INWK

 DEX                    \ Decrement the loop counter

 BPL DML4               \ Loop back for the next byte, until we have copied the
                        \ last byte from K% to INWK

 LDX #1                 \ Call GINF to fetch the address of the ship data block
 JSR GINF               \ for the ship in slot 1 (the Cobra) and store it in INF

 LDA XX21-2+2*CYL       \ Set XX0(1 0) to point to the ship blueprint for a
 STA XX0                \ Cobra Mk III
 LDA XX21-1+2*CYL
 STA XX0+1

 LDA #CYL               \ Set the ship type to a Cobra Mk III
 STA TYPE

 JSR MVEIT              \ Call MVEIT to move the Cobra so it pitches, rolls and
                        \ flies on

 JSR LL9                \ Call LL9 to draw the Cobra on-screen

 JSR STORE              \ Call STORE to copy the ship data block at INWK back to
                        \ the K% workspace

 PLP                    \ Restore the flags that we stored on the stack above

 BNE FLYL5              \ If it is not the case that bits 5 and 7 of the logo's
                        \ byte #31 are both set, jump back to FLYL5 to keep
                        \ drawing the exploding logo and the Cobra

                        \ The logo has now finished exploding, as bits 5 and 7
                        \ of the logo's byte #31 are now both set ("ship is
                        \ exploding" and "ship has been killed"). By this time
                        \ the Cobra will have reached the upper part of the
                        \ screen, where we leave it while we do the next bit of
                        \ scrolling text

 LDA #14                \ Set DELTA to 14, so our current speed (i.e. that of
 STA DELTA              \ the camera) is 14

 STZ DELT4              \ Set DELT4 = 0

 LSR A                  \ Set DELT4+1 = 14 / 4
 ROR DELT4              \
 LSR A                  \ so DELT4(1 0) therefore contains 14 * 64
 ROR DELT4
 STA DELT4+1

IF _6502SP_VERSION \ 6502SP: The demo in the Executive version shows an extra bit of scroll text before the authors' names: "THE EXECUTIVE VERSION"

IF _EXECUTIVE

 LDX #LO(executive)     \ Set (Y X) to the address of executive, which contains
 LDY #HI(executive)     \ the text: "THE EXECUTIVE VERSION"

 JSR SLIDE              \ Call SLIDE to display the Star Wars scroll text

ENDIF

ENDIF

 LDX #LO(byian)         \ Set (Y X) to the address of byian, which contains the
 LDY #HI(byian)         \ text: "BY IAN BELL AND DAVID BRABEN"

 JSR SLIDE              \ Call SLIDE to display the Star Wars scroll text

                        \ We now want the Cobra to start flying again, so we
                        \ first need to copy the logo's ship data block from K%
                        \ to INWK

 LDX #NI%-1             \ Set a counter in X so we can loop through the NI%
                        \ bytes in the ship data block

.DML5

 LDA K%+NI%,X           \ Copy the X-th byte of the second ship data block in K%
 STA INWK,X             \ to the X-th byte of INWK

 DEX                    \ Decrement the loop counter

 BPL DML5               \ Loop back for the next byte, until we have copied the
                        \ last byte from K% to INWK

.FLYL6

 JSR STARS1             \ Call STARS1 to process the stardust for the front view

 JSR MVEIT              \ Call MVEIT to move the Cobra so it pitches, rolls and
                        \ flies onwards

 JSR LL9                \ Call LL9 to draw the Cobra on-screen

 LDA INWK+8             \ Keep looping back to FLYL6 until z_sign is negative,
 BPL FLYL6              \ i.e. the Cobra has been overtaken by the camera as the
                        \ camera moves forward, and it's disappeared off the top
                        \ of the screen

 LDX #LO(true3)         \ Set (Y X) to the address of true3, which contains the
 LDY #HI(true3)         \ text: "THE GALAXY IS IN TURMOIL, THE NAVY FAR AWAY AS
                        \ THE EMPIRE CRUMBLES" (or, in the Executive version:
                        \ "CONGRATULATIONS ON OBTAINING A COPY OF THIS ELUSIVE
                        \ PRODUCT")

 JSR SLIDE              \ Call SLIDE to display the Star Wars scroll text

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDA #&E0               \ Set nosev_z_hi = -1 (as &E0 is a negative unit vector
 STA INWK+14            \ length), so the ship points out of the screen, towards
                        \ us

 STZ DELTA              \ Set DELTA to 0, so our current speed (i.e. that of the
                        \ camera) is 0

 STZ ALPHA              \ Set ALPHA and ALP1 to 0, so our roll angle (i.e. that
 STZ ALP1               \ of the camera) is 0

 LDX #15                \ Set the ship's speed to 15
 STX INWK+27

 LDX #5                 \ Set the ship's z_hi to 5, so it's in the distance
 STX INWK+7

 LDA #ADA               \ Set the ship type to an Adder
 STA TYPE

 JSR NWSHP              \ Add a new Adder to the local bubble (in this case, the
                        \ demo screen)

.FLYL7

 JSR MVEIT              \ Call MVEIT to move the Adder so it flies towards the
                        \ camera

 JSR LL9                \ Call LL9 to draw the Adder on-screen

 LDA INWK+7             \ Keep looping back to FLYL7 until z_hi is zero
 BNE FLYL7

 LDA #3                 \ Set the Adder's roll counter to 3 to make it roll in
 STA INWK+29            \ a positive direction (clockwise)

 STA INWK+30            \ Set the Adder's pitch counter to 3 to make it pitch in
                        \ a positive direction (dive)

 LDA INWK+8             \ Keep looping back to FLYL7 until z_sign is negative
 BPL FLYL7              \ i.e. the Adder has flown past the camera

 JSR SCAN               \ Call SCAN to remove the adder from the scanner (by
                        \ redrawing it)

 JSR RES2               \ Reset a number of flight variables and workspaces

 LDA #CYAN2             \ Set the scanner colour for the Cobra Mk III to its
 STA scacol+CYL         \ default colour of cyan, so Cobras will appear on the
                        \ scanner once again

 JMP DEATH2             \ Jump to DEATH2 to reset most of the game and restart
                        \ from the title screen

