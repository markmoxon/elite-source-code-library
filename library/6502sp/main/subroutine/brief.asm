\ ******************************************************************************
\
\       Name: BRIEF
\       Type: Subroutine
\   Category: Missions
\    Summary: Start mission 1 and show the mission briefing
\
\ ------------------------------------------------------------------------------
\
\ This routine does the following:
\
\   * Clear the screen
\   * Display "INCOMING MESSAGE" in the middle of the screen
\   * Wait for 2 seconds
\   * Clear the screen
\   * Show the Constrictor rolling and pitching in the middle of the screen
\   * Do this for 64 loop iterations
\   * Move the ship away from us and up until it's near the top of the screen
\   * Show the mission 1 briefing in extended token 10
\
\ The mission briefing ends with a "{display ship, wait for key press}" token,
\ which calls the PAUSE routine. This continues to display the rotating ship,
\ waiting until a key is pressed, and then removes the ship from the screen.
\
\ ******************************************************************************

.BRIEF

 LSR TP                 \ Set bit 0 of TP to indicate that mission 1 is now in
 SEC                    \ progress
 ROL TP

 JSR BRIS               \ Call BRIS to clear the screen, display "INCOMING
                        \ MESSAGE" and wait for 2 seconds

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 LDA #CON               \ Set the ship type in TYPE to the Constrictor
 STA TYPE

 JSR NWSHP              \ Add a new Constrictor to the local bubble (in this
                        \ case, the briefing screen)

 LDA #1                 \ Move the text cursor to column 1
 JSR DOXC

 STA INWK+7             \ Set z_hi = 1, the distance at which we show the
                        \ rotating ship

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 1

 LDA #64                \ Set the main loop counter to 64, so the ship rotates
                        \ for 64 iterations through MVEIT
 STA MCNT

.BRL1

 LDX #%01111111         \ Set the ship's roll counter to a positive roll that
 STX INWK+29            \ doesn't dampen

 STX INWK+30            \ Set the ship's pitch counter to a positive pitch that
                        \ doesn't dampen

 JSR LL9                \ Draw the ship on screen

 JSR MVEIT              \ Call MVEIT to rotate the ship in space

 DEC MCNT               \ Decrease the counter in MCNT

 BNE BRL1               \ Loop back to keep moving the ship until we have done
                        \ all 64 iterations

.BRL2

 LSR INWK               \ Halve x_lo so the Constrictor moves towards the centre
 
 INC INWK+6             \ Increment z_lo so the Constrictor moves away from us

 BEQ BR2                \ If z_lo = 0 (i.e. it just went past 255), jump to BR2
                        \ to show the briefing

 INC INWK+6             \ Increment z_lo so the Constrictor moves a bit further
                        \ away from us

 BEQ BR2                \ If z_lo = 0 (i.e. it just went past 255), jump out of
                        \ the loop to BR2 to stop moving the ship up the screen
                        \ and show the briefing

 LDX INWK+3             \ Set X = y_lo + 1
 INX

 CPX #112               \ If X < 112 then skip the next instruction
 BCC P%+4

 LDX #112               \ X is bigger than 112, so set X = 112 so that X has a
                        \ maximum value of 112

 STX INWK+3             \ Set y_lo = X
                        \          = y_lo + 1
                        \
                        \ so the ship moves up the screen (as space coordinates
                        \ have the y-axis going up)

 JSR LL9                \ Draw the ship on screen

 JSR MVEIT              \ Call MVEIT to move and rotate the ship in space

 JMP BRL2               \ Loop back to keep moving the ship up the screen and
                        \ away from us

.BR2

 INC INWK+7             \ Increment z_hi, to keep the ship at the same distance
                        \ as we just incremented z_lo past 255

 LDA #10                \ Set A = 10 so the call to BRP prints extended token 10
                        \ (the briefing for mission 1 where we find out all
                        \ about the stolen Constrictor)

 BNE BRPS               \ Jump to BRP via BRPS to print the extended token in A
                        \ and show the Status Mode screen), returning from the
                        \ subroutine using a tail call (this BNE is effectively
                        \ a JMP as A is never zero)

