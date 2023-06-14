\ ******************************************************************************
\
\       Name: Main flight loop (Part 10 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Remove if scooped, or process collisions
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * Remove scooped item after both successful and failed scooping attempts
\
\     * Process collisions
\
\ ******************************************************************************

IF NOT(_ELITE_A_VERSION)

.MA59

                        \ If we get here then scooping failed

 JSR EXNO3              \ Make the sound of the cargo canister being destroyed
                        \ and fall through into MA60 to remove the canister
                        \ from our local bubble

.MA60

                        \ If we get here then scooping was successful

 ASL INWK+31            \ Set bit 7 of the scooped or destroyed item, to denote
 SEC                    \ that it has been killed and should be removed from
 ROR INWK+31            \ the local bubble

.MA61

 BNE MA26               \ Jump to MA26 to skip over the collision routines and
                        \ to move on to missile targeting (this BNE is
                        \ effectively a JMP as A will never be zero)

.MA67

                        \ If we get here then we have collided with something,
                        \ but not fatally

 LDA #1                 \ Set the speed in DELTA to 1 (i.e. a sudden stop)
 STA DELTA

 LDA #5                 \ Set the amount of damage in A to 5 (a small dent) and
 BNE MA63               \ jump down to MA63 to process the damage (this BNE is
                        \ effectively a JMP as A will never be zero)

.MA58

                        \ If we get here, we have collided with something in a
                        \ potentially fatal way

 ASL INWK+31            \ Set bit 7 of the ship we just collided with, to
 SEC                    \ denote that it has been killed and should be removed
 ROR INWK+31            \ from the local bubble

 LDA INWK+35            \ Load A with the energy level of the ship we just hit

 SEC                    \ Set the amount of damage in A to 128 + A / 2, so
 ROR A                  \ this is quite a big dent, and colliding with higher
                        \ energy ships will cause more damage

ELIF _ELITE_A_VERSION

 LDA auto               \ If the docking computer is on, then auto will be &FF,
 AND #%00000100         \ so this will set A = 1, a tiny amount of damage
 EOR #%00000101         \
                        \ If the docking computer is off, then auto will be 0,
                        \ so this will set A = 5, a small amount of damage

 BNE MA63               \ Jump to MA63 to process the damage in A (this BNE is
                        \ effectively a JMP as A will never be zero)

.MA58

                        \ If we get here, we have collided with something in a
                        \ potentially fatal way

 LDA #64                \ Call n_hit to apply a hit of strength 64 to the ship
 JSR n_hit              \ we just collided with

 JSR anger_8c           \ Call anger_8c to make the ship angry

.n_crunch

                        \ If we get here, we have collided with something, so we
                        \ need to take a hit to our shields

 LDA #128               \ Set A = 128 to indicate a fairly large amount of
                        \ damage

ENDIF

.MA63

 JSR OOPS               \ The amount of damage is in A, so call OOPS to reduce
                        \ our shields, and if the shields are gone, there's a
                        \ chance of cargo loss or even death

 JSR EXNO3              \ Make the sound of colliding with the other ship and
                        \ fall through into MA26 to try targeting a missile

