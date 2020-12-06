\ ******************************************************************************
\
\       Name: Main game loop (Part 1 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Spawn a trader (a peaceful Cobra Mk III)
\
\ ------------------------------------------------------------------------------
\
\ This is part of the main game loop. This is where the core loop of the game
\ lives, and it's in two parts. The shorter loop (just parts 5 and 6) is
\ iterated when we are docked, while the entire loop from part 1 to 6 iterates
\ if we are in space.
\
\ This section covers the following:
\
\   * Spawn a trader, i.e. a Cobra Mk III that isn't attacking anyone, with one
\     missile and a 50% chance of having an E.C.M., a speed between 16 and 31,
\     and a clockwise roll
\
\ We call this from within the main loop, with A set to a random number and the
\ C flag set.
\
\ ******************************************************************************

.MTT4

IF _6502SP_VERSION

 JSR DORND

ENDIF

 LSR A                  \ Clear bit 7 of our random number in A

 STA INWK+32            \ Store this in the ship's AI flag, so this ship does
                        \ not have AI

 STA INWK+29            \ Store A in the ship's roll counter, giving it a
                        \ clockwise roll (as bit 7 is clear), and a 1 in 127
                        \ chance of it having no damping

 ROL INWK+31            \ Set bit 0 of missile count (as we know the C flag is
                        \ set), giving the ship one missile

 AND #31                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

IF _CASSETTE_VERSION

 LDA #CYL               \ Add a new Cobra Mk III to the local universe and fall
 JSR NWSHP              \ through into the main game loop again

ELIF _6502SP_VERSION

 JSR DORND
 BMI nodo
 LDA INWK+32
 ORA #&C0
 STA INWK+32
 LDX #16
 STX NEWB

.nodo

 AND #2
 ADC #CYL
 CMP #HER
 BEQ TT100
 JSR NWSHP\trader

ENDIF

