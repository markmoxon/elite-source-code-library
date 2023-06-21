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

IF NOT(_ELITE_A_6502SP_PARA OR _NES_VERSION)

 JSR LL9                \ Call LL9 to draw the ship we're processing on-screen

ELIF _ELITE_A_6502SP_PARA

 JSR LL9_FLIGHT         \ Call LL9 to draw the ship we're processing on-screen

ELIF _NES_VERSION

 JSR LL9_b1             \ Call LL9 to draw the ship we're processing on-screen

ENDIF

.MA15

 LDY #35                \ Fetch the ship's energy from byte #35 and copy it to
 LDA INWK+35            \ byte #35 in INF (so the ship's data in K% gets
 STA (INF),Y            \ updated)

IF _NES_VERSION

 LDA INWK+34
 LDY #34
 STA (INF),Y

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Enhanced: Ships that have docked or been scooped in the enhanced versions are not classed as being killed and are not tested for potential bounties

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

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

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

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _NES_VERSION

 LDA NEWB               \ Extract bit 6 of the ship's NEWB flags, so A = 64 if
 AND #%01000000         \ bit 6 is set, or 0 if it is clear. Bit 6 is set if
                        \ this ship is a cop, so A = 64 if we just killed a
                        \ policeman, otherwise it is 0

 ORA FIST               \ Update our FIST flag ("fugitive/innocent status") to
 STA FIST               \ at least the value in A, which will instantly make us
                        \ a fugitive if we just shot the sheriff, but won't
                        \ affect our status if the enemy wasn't a copper

ELIF _ELITE_A_VERSION

                        \ We now update our FIST flag ("fugitive/innocent
                        \ status") by 1 if we didn't kill a cop, or by a large
                        \ amount if we did - specifically, if we killed a cop,
                        \ then the most significant bit in FIST that is
                        \ currently clear will be set, which means we increase
                        \ FIST by the highest multiple of 2 that we can add and
                        \ still fit the result in a byte
                        \
                        \ Also, at this point, we know that A = %00100000 (as we
                        \ didn't take the BEQ branch)

 BIT NEWB               \ If bit 6 of the ship's NEWB flags is set, then this
 BVS n_badboy           \ ship is a cop, so jump to n_badboy as we just killed a
                        \ policeman

 BEQ n_goodboy          \ The BIT NEWB instruction sets the Z flag according to
                        \ the result of:
                        \
                        \   A AND NEWB = %00100000 AND NEWB
                        \
                        \ so this jumps to n_goodboy if bit 5 of NEWB is clear,
                        \ so in other words, if the ship is no longer exploding,
                        \ we don't update FIST

 LDA #%10000000         \ Set A so that the shift and rotate instructions we're
                        \ about to do set A = %00000001, so we increase our FIST
                        \ status by just 1

.n_badboy

                        \ We get here with two possible values of A:
                        \
                        \   * A = %00100000 if we just killed a cop
                        \   * A = %10000000 otherwise

 ASL A                  \ Shift and rotate A so that we get:
 ROL A                  \
                        \   * A = %10000000 if we just killed a cop
                        \   * A = %00000001 otherwise

.n_bitlegal

 LSR A                  \ We now shift A to the right and AND it with FIST,
 BIT FIST               \ repeating the process until the single set bit in A
 BNE n_bitlegal         \ matches a clear bit in FIST, so this shifts A right
                        \ so that the set bit matches the highest clear bit in
                        \ FIST (if we just killed a cop), or it sets A to 0 and
                        \ sets the C flag (if we didn't)

 ADC FIST               \ Set A = A + C + FIST, so:
                        \
                        \   * A = A + 0 + FIST if we just killed a cop
                        \   * A = 0 + 1 + FIST otherwise
                        \
                        \ so if we just killed a cop, this will effectively set
                        \ the highest clear bit in FIST, otherwise we just add 1
                        \ to FIST

 BCS KS1S               \ If the addition overflowed, jump to KS1S to skip
                        \ showing an on-screen bounty for this kill, and without
                        \ updating FIST first (as we are too bad to get any
                        \ worse)

 STA FIST               \ Otherwise update the value of FIST to the new value

 BCC KS1S               \ Jump to KS1S to skip showing an on-screen bounty for
                        \ this kill (the BCC is effectively a JMP as we just
                        \ passed through a BCS)

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

ELIF _NES_VERSION

 LDA MJ                 \ If we are in witchspace (in which case MJ > 0) or 
 ORA demoInProgress     \ demoInProgress > 0 (in which case we are playing the
 BNE KS1S               \ demo), jump to KS1S to skip showing an on-screen
                        \ bounty for this kill

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 LDA (XX0),Y            \ low byte of the bounty awarded when this ship is
 BEQ KS1S               \ killed (in Cr * 10), and if it's zero jump to KS1S as
                        \ there is no on-screen bounty to display

ELIF _NES_VERSION

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 JSR GetShipBlueprint   \ low byte of the bounty awarded when this ship is
 BEQ KS1S               \ killed (in Cr * 10), and if it's zero jump to KS1S as
                        \ there is no on-screen bounty to display

ELIF _ELITE_A_VERSION

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 LDA (XX0),Y            \ low byte of the bounty awarded when this ship is
                        \ killed (in Cr * 10)
ENDIF

 TAX                    \ Put the low byte of the bounty into X

IF NOT(_NES_VERSION)

 INY                    \ Fetch byte #11 of the ship's blueprint, which is the
 LDA (XX0),Y            \ high byte of the bounty awarded (in Cr * 10), and put
 TAY                    \ it into Y

ELIF _NES_VERSION

 INY                    \ Fetch byte #11 of the ship's blueprint, which is the
 JSR GetShipBlueprint   \ high byte of the bounty awarded (in Cr * 10), and put
 TAY                    \ it into Y

ENDIF

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
                        \ the ship has survived the hit. In this case we jump to
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

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

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

IF NOT(_NES_VERSION)

 LDY #31                \ Fetch the ship's explosion/killed state from byte #31
 LDA INWK+31            \ and copy it to byte #31 in INF (so the ship's data in
 STA (INF),Y            \ K% gets updated)

ELIF _NES_VERSION

 LDY #31                \ Fetch the ship's explosion/killed state from byte #31,
 LDA INWK+31            \ clear bit 6 and copy it to byte #31 in INF (so the
 AND #%10111111         \ ship's data in K% gets updated) ???
 STA (INF),Y

ENDIF

 LDX XSAV               \ We're done processing this ship, so fetch the ship's
                        \ slot number, which we saved in XSAV back at the start
                        \ of the loop

 INX                    \ Increment the slot number to move on to the next slot

IF NOT(_NES_VERSION)

 JMP MAL1               \ And jump back up to the beginning of the loop to get
                        \ the next ship in the local bubble for processing

ELIF _NES_VERSION

 RTS                    \ Return from the subroutine

ENDIF

