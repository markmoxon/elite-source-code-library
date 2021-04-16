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

 JSR LL9                \ Call LL9 to draw the ship we're processing on-screen

.MA15

 LDY #35                \ Fetch the ship's energy from byte #35 and copy it to
 LDA INWK+35            \ byte #35 in INF (so the ship's data in K% gets
 STA (INF),Y            \ updated)

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: Ships that have docked or been scooped in the enhanced versions are not classed as being killed and are not tested for potential bounties

 LDA NEWB               \ If bit 7 of the ship's NEWB flags is set, which means
 BMI KS1S               \ the ship has docked or been scooped, jump to KS1S to
                        \ skip the following, as we can't get a bounty for a
                        \ ship that's no longer around

ENDIF

 LDA INWK+31            \ If bit 7 of the ship's byte #31 is clear, then the
 BPL MAC1               \ ship hasn't been killed by energy bomb, collision or
                        \ laser fire, so jump to MAC1 to skip the following

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 AND #%00100000         \ If bit 5 of the ship's byte #31 is clear then the
 BEQ NBOUN              \ ship is no longer exploding, so jump to NBOUN to skip
                        \ the following

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

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

ENDIF

 LDA DLY                \ If we already have an in-flight message on-screen (in
 ORA MJ                 \ which case DLY > 0), or we are in witchspace (in
 BNE KS1S               \ which case MJ > 0), jump to KS1S to skip showing an
                        \ on-screen bounty for this kill

 LDY #10                \ Fetch byte #10 of the ship's blueprint, which is the
 LDA (XX0),Y            \ low byte of the bounty awarded when this ship is
 BEQ KS1S               \ killed (in Cr * 10), and if it's zero jump to KS1S as
                        \ there is no on-screen bounty to display

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

.MAC1

 LDA TYPE               \ If the ship we are processing is a planet or sun,
 BMI MA27               \ jump to MA27 to skip the following two instructions

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

