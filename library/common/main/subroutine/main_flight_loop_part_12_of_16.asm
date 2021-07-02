\ ******************************************************************************
\
\       Name: Main flight loop (Part 12 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Draw the ship, remove if killed, loop back
\  Deep dive: Program flow of the main game loop
\             Drawing ships
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * Draw the ship
\
\     * Process removal of killed ships
\
\   * Loop back up to MAL1 to move onto the next ship in the local bubble
\
\ ******************************************************************************

.MA8

IF NOT(_ELITE_A_6502SP_PARA)

 JSR LL9                \ Call LL9 to draw the ship we're processing on-screen

ELIF _ELITE_A_6502SP_PARA

 JSR LL9_FLIGHT         \ Call LL9 to draw the ship we're processing on-screen

ENDIF

.MA15

 LDY #35                \ Fetch the ship's energy from byte #35 and copy it to
 LDA INWK+35            \ byte #35 in INF (so the ship's data in K% gets
 STA (INF),Y            \ updated)

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Enhanced: Ships that have docked or been scooped in the enhanced versions are not classed as being killed and are not tested for potential bounties

 LDA NEWB               \ If bit 7 of the ship's NEWB flags is set, which means
 BMI KS1S               \ the ship has docked or been scooped, jump to KS1S to
                        \ skip the following, as we can't get a bounty for a
                        \ ship that's no longer around

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDA INWK+31            \ If bit 7 of the ship's byte #31 is clear, then the
 BPL MAC1               \ ship hasn't been killed by energy bomb, collision or
                        \ laser fire, so jump to MAC1 to skip the following

ELIF _ELITE_A_VERSION

 LDA INWK+31            \ If bit 7 of the ship's byte #31 is clear, then the
 BPL MAC1               \ ship hasn't been killed by collision or laser fire,
                        \ so jump to MAC1 to skip the following

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 AND #%00100000         \ If bit 5 of the ship's byte #31 is clear then the
 BEQ NBOUN              \ ship is no longer exploding, so jump to NBOUN to skip
                        \ the following

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 AND #%00100000         \ If bit 5 of the ship's byte #31 is clear then the
 BEQ MAC1               \ ship is no longer exploding, so jump to MAC1 to skip
                        \ the following

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDA TYPE               \ If the ship we just destroyed was a cop, keep going,
 CMP #COPS              \ otherwise jump to q2 to skip the following
 BNE q2

 LDA FIST               \ We shot the sheriff, so update our FIST flag
 ORA #64                \ ("fugitive/innocent status") to at least 64, which
 STA FIST               \ will instantly make us a fugitive

.q2

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDA NEWB               \ Extract bit 6 of the ship's NEWB flags, so A = 64 if
 AND #%01000000         \ bit 6 is set, or 0 if it is clear. Bit 6 is set if
                        \ this ship is a cop, so A = 64 if we just killed a
                        \ policeman, otherwise it is 0

 ORA FIST               \ Update our FIST flag ("fugitive/innocent status") to
 STA FIST               \ at least the value in A, which will instantly make us
                        \ a fugitive if we just shot the sheriff, but won't
                        \ affect our status if the enemy wasn't a copper

ELIF _ELITE_A_VERSION

                        \ At this point, we know that A = %00100000 (as we
                        \ didn't take the BEQ branch)

 BIT NEWB               \ If bit 6 of the ship's NEWB flags is set, then this
 BVS n_badboy           \ ship is a cop, so jump to n_badboy as we just killed a
                        \ policeman

 BEQ n_goodboy          \ The BIT NEWB instruction sets the Z flag according to
                        \ the result of:
                        \
                        \   A AND NEWB = %00100000 AND NEWB
                        \
                        \ so this jumps to n_goodboy if bit 5 of NEWB is clear
                        \ (in other words, if the ship is no longer exploding)

 LDA #%10000000         \ AJD

.n_badboy

 ASL A
 ROL A

.n_bitlegal

 LSR A
 BIT FIST
 BNE n_bitlegal

 ADC FIST
 BCS KS1S

 STA FIST
 BCC KS1S

.n_goodboy

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Standard: This is a bug in all versions. Making a kill while there's an in-flight message on the screen not only stops the bounty from being displayed (which is intentional), but it also prevents the bounty from being awarded (which presumably isn't). In non-Electron versions, the same code is used to prevent bounties from being awarded in witchspace (which is correct, as witchspace kills can't be reported to the authorities)

 LDA DLY                \ If we already have an in-flight message on-screen (in
 ORA MJ                 \ which case DLY > 0), or we are in witchspace (in
 BNE KS1S               \ which case MJ > 0), jump to KS1S to skip showing an
                        \ on-screen bounty for this kill

ELIF _ELECTRON_VERSION

 LDA DLY                \ If we already have an in-flight message on-screen (in
 BNE KS1S               \ which case DLY > 0), jump to KS1S to skip showing an
                        \ on-screen bounty for this kill

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 LDA (XX0),Y            \ low byte of the bounty awarded when this ship is
 BEQ KS1S               \ killed (in Cr * 10), and if it's zero jump to KS1S as
                        \ there is no on-screen bounty to display

ELIF _ELITE_A_VERSION

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 LDA (XX0),Y            \ low byte of the bounty awarded when this ship is
                        \ killed (in Cr * 10)
ENDIF

 TAX                    \ Put the low byte of the bounty into X

 INY                    \ Fetch byte #11 of the ship's blueprint, which is the
 LDA (XX0),Y            \ high byte of the bounty awarded (in Cr * 10), and put
 TAY                    \ it into Y

 JSR MCASH              \ Call MCASH to add (Y X) to the cash pot

 LDA #0                 \ Print control code 0 (current cash, right-aligned to
 JSR MESS               \ width 9, then " CR", newline) as an in-flight message

.KS1S

 JMP KS1                \ Process the killing of this ship (which removes this
                        \ ship from its slot and shuffles all the other ships
                        \ down to close up the gap)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.NBOUN

ENDIF

IF _ELITE_A_VERSION

.n_hit

                        \ If we get here then we need to apply a hit of strength
                        \ A to the enemy ship

 STA T                  \ Store the strength of the hit in T

 SEC                    \ Set the C flag so we can do some subtraction

 LDY #14                \ Fetch byte #14 of the enemy ship's blueprint into A,
 LDA (XX0),Y            \ which gives the ship's maximum energy/shields

 AND #7                 \ Reduce the maximum energy/shields figure to the range
                        \ 0-7

 SBC T                  \ Subtract the hit strength from the maximum shields, so
                        \ A = ship energy - hit strength

 BCS n_kill             \ If the subtraction didn't underflow, then the hit was
                        \ weaker than the ship's shields, so jump to n_kill
                        \ with the C flag set to indicate that the ship has
                        \ survived the attack

\BCC n_defense          \ These instructions are commented out in the original
\LDA #&FF               \ source
\.n_defense

 CLC                    \ Otherwise the hit was stronger than the enemy shields,
 ADC INWK+35            \ so the ship's energy level needs to register some
 STA INWK+35            \ damage. A contains a negative number whose magnitude
                        \ is the amount by which the attack is greater than the
                        \ shield defence, so we can simply add this figure to
                        \ the ship's energy levels in the ship's byte #35 to
                        \ reduce the energy by the amount that the attack was
                        \ stronger than the defence (i.e. the shields absorb the
                        \ amount of energy that is defined in the blueprint, and
                        \ the rest of the hit makes it through to damage the
                        \ energy levels)

 BCS n_kill             \ Adding this negative number is the same as subtracting
                        \ a positive number, so having the C flag set indicates
                        \ that the subtraction didn't underflow - in other words
                        \ the damage isn't greater than the energy levels, and
                        \ the ship has survuved the hit. In this case we jump to
                        \ n_kill with the C flag set to indicate that the ship
                        \ has survived the attack

 JSR TA87+3             \ If we get here then the ship has not survived the
                        \ attack, so call TA87+3 to set bit 7 of the ship's byte
                        \ #31, which marks the ship as being killed

.n_kill

 RTS                    \ Return from the subroutine with the C flag set if the
                        \ ship has survived the onslaught, or clear if it has
                        \ been destroyed

ENDIF

.MAC1

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 LDA TYPE               \ If the ship we are processing is a planet or sun,
 BMI MA27               \ jump to MA27 to skip the following two instructions

ELIF _ELECTRON_VERSION

 LDA TYPE               \ If the ship we are processing is the planet, jump to
 BMI MA27               \ MA27 to skip the following two instructions

ENDIF

 JSR FAROF              \ If the ship we are processing is a long way away (its
 BCC KS1S               \ distance in any one direction is > 224, jump to KS1S
                        \ to remove the ship from our local bubble, as it's just
                        \ left the building

.MA27

 LDY #31                \ Fetch the ship's explosion/killed state from byte #31
 LDA INWK+31            \ and copy it to byte #31 in INF (so the ship's data in
 STA (INF),Y            \ K% gets updated)

 LDX XSAV               \ We're done processing this ship, so fetch the ship's
                        \ slot number, which we saved in XSAV back at the start
                        \ of the loop

 INX                    \ Increment the slot number to move on to the next slot

 JMP MAL1               \ And jump back up to the beginning of the loop to get
                        \ the next ship in the local bubble for processing

