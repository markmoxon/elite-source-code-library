\ ******************************************************************************
\
\       Name: WARP
\       Type: Subroutine
\   Category: Flight
\    Summary: Process the fast-forward button to end the demo, dock instantly or
\             perform an in-system jump
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.WARP

 LDA demoInProgress     \ If the demo is not in progress, jump to warp1 to skip
 BEQ warp1              \ the following

                        \ If we get here then the demo is in progress, in which
                        \ case the fast-forward icon ends the demo and starts
                        \ the game

 JSR ResetShipStatus    \ Reset the ship's speed, hyperspace counter, laser
                        \ temperature, shields and energy banks

 JMP StartGame          \ Jump to StartGame to reset the stack and go to the
                        \ docking bay (i.e. show the Status Mode screen)

.warp1

 LDA auto               \ If the docking computer is engaged (auto is non-zero)
 AND SSPR               \ and we are inside the space station safe zone (SSPR
 BEQ warp2              \ is non-zero), then this sets A to be non-zero, so if
                        \ this is not the case, jump to warp2 to skip the
                        \ following

                        \ If we get here then the docking computer is engaged
                        \ and we are in the space station safe zone, in which
                        \ case the fast-forward button docks us instantly

 JMP GOIN               \ Go to the docking bay (i.e. show the ship hangar
                        \ screen) and return from the subroutine with a tail
                        \ call

.warp2

 JSR FastForwardJump    \ Do an in-system (fast-forward) jump and run the
                        \ distance checks

 BCS warp3              \ If the C flag is set then we are too close to the
                        \ planet or sun for any more jumps, so jump to warp3
                        \ to stop jumping

 JSR FastForwardJump    \ Do a second in-system (fast-forward) jump and run the
                        \ distance checks

 BCS warp3              \ If the C flag is set then we are too close to the
                        \ planet or sun for any more jumps, so jump to warp3
                        \ to stop jumping

 JSR FastForwardJump    \ Do a third in-system (fast-forward) jump and run the
                        \ distance checks

 BCS warp3              \ If the C flag is set then we are too close to the
                        \ planet or sun for any more jumps, so jump to warp3
                        \ to stop jumping

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR InSystemJump       \ Do a fourth in-system jump (fast-forward) without
                        \ doing the distance checks

.warp3

 LDA #1                 \ Set the main loop counter to 1, so the next iteration
 STA MCNT               \ through the main loop will potentially spawn ships
                        \ (see part 2 of the main game loop at me3)

 LSR A                  \ Set EV, the extra vessels spawning counter, to 0
 STA EV                 \ (the LSR produces a 0 as A was previously 1)

 JSR CheckAltitude      \ Perform an altitude check with the planet, ending the
                        \ game if we hit the ground

 LDA QQ11               \ If this is not the space view, jump to warp4 to skip
 BNE warp4              \ the updating of the space view and return from the
                        \ subroutine

 LDX VIEW               \ Set X to the current view (front, rear, left or right)

 DEC VIEW               \ Decrement the view in VIEW so the call to LOOK1 thinks
                        \ the view has changed, so it will update the screen

 JMP LOOK1              \ Jump to LOOK1 to initialise the view in X, returning
                        \ from the subroutine using a tail call

.warp4

 RTS                    \ Return from the subroutine

