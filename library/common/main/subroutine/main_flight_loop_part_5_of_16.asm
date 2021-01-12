\ ******************************************************************************
\
\       Name: Main flight loop (Part 5 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: If an energy bomb has been set off,
\             potentially kill this ship
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * If an energy bomb has been set off and this ship can be killed, kill it
\       and increase the kill tally
\
\ ******************************************************************************

 LDA BOMB               \ If we set off our energy bomb by pressing TAB (see
 BPL MA21               \ MA24 above), then BOMB is now negative, so this skips
                        \ to MA21 if our energy bomb is not going off

 CPY #2*SST             \ If the ship in Y is the space station, jump to BA21
 BEQ MA21               \ as energy bombs are useless against space stations

IF _6502SP_VERSION

 CPY #2*CON             \ If the ship in Y is the Constrictor, jump to BA21
 BCS MA21               \ as energy bombs are useless against the Constrictor
                        \ (the Constrictor is the target of mission 1, and it
                        \ would be too easy if it could just be blown out of
                        \ the sky with a single key press)

ENDIF

 LDA INWK+31            \ If the ship we are checking has bit 5 set in its ship
 AND #%00100000         \ byte #31, then it is already exploding, so jump to
 BNE MA21               \ BA21 as ships can't explode more than once

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA INWK+31            \ The energy bomb is killing this ship, so set bit 7 of
 ORA #%10000000         \ the ship byte #31 to indicate that it has now been
 STA INWK+31            \ killed

ELIF _6502SP_VERSION

 ASL INWK+31            \ The energy bomb is killing this ship, so set bit 7 of
 SEC                    \ the ship byte #31 to indicate that it has now been
 ROR INWK+31            \ killed

ENDIF

 JSR EXNO2              \ Call EXNO2 to process the fact that we have killed a
                        \ ship (so increase the kill tally, make an explosion
                        \ sound and possibly display "RIGHT ON COMMANDER!")

