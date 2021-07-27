\ ******************************************************************************
\
IF NOT(_ELITE_A_6502SP_PARA)
\       Name: Main game loop (Part 1 of 6)
ELIF _ELITE_A_6502SP_PARA
\       Name: Main game loop for flight (Part 1 of 6)
ENDIF
\       Type: Subroutine
\   Category: Main loop
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\    Summary: Spawn a trader (a peaceful Cobra Mk III)
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION
\    Summary: Spawn a trader (a Cobra Mk III, Python, Boa or Anaconda)
ENDIF
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\
\ ------------------------------------------------------------------------------
\
IF NOT(_ELITE_A_6502SP_PARA)
\ This is part of the main game loop. This is where the core loop of the game
\ lives, and it's in two parts. The shorter loop (just parts 5 and 6) is
\ iterated when we are docked, while the entire loop from part 1 to 6 iterates
\ if we are in space.
ELIF _ELITE_A_6502SP_PARA
\ This is part of the main game loop. This is the loop for when we are in
\ flight, while the main game loop for when we are docked is at TT100.
ENDIF
\
\ This section covers the following:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\   * Spawn a trader, i.e. a Cobra Mk III that isn't hostile, with a 50% chance
\     of it having a missile, a 50% chance of it having an E.C.M., a speed
\     between 16 and 31, and a gentle clockwise roll
\
\ We call this from within the main loop, with A set to a random number.
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION
\   * Spawn a trader, i.e. a Cobra Mk III, Python, Boa or Anaconda, with a 50%
\     chance of it having a missile, a 50% chance of it having an E.C.M., a 50%
\     chance of it docking and being aggressive if attacked, a speed between 16
\     and 31, and a gentle clockwise roll
\
\ We call this from within the main loop.
ENDIF
\
\ ******************************************************************************

.MTT4

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 JSR DORND              \ Set A and X to random numbers

ENDIF

 LSR A                  \ Clear bit 7 of our random number in A and set the C
                        \ flag to bit 0 of A, which os random

 STA INWK+32            \ Store this in the ship's AI flag, so this ship does
                        \ not have AI

 STA INWK+29            \ Store A in the ship's roll counter, giving it a
                        \ clockwise roll (as bit 7 is clear), and a 1 in 127
                        \ chance of it having no damping

 ROL INWK+31            \ Set bit 0 of the ship's missile count ramdomly (as the
                        \ C flag was set), giving the ship either no missiles or
                        \ one missile

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 AND #31                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

ELIF _DISC_FLIGHT

 AND #15                \ Set the ship speed to our random number, set to a
 ORA #16                \ minimum of 16 and a maximum of 31
 STA INWK+27

ELIF _ELITE_A_VERSION

 AND #15                \ Set the ship speed to our random number, set to a
 STA INWK+27            \ minimum of 0 and a maximum of 15

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _ELITE_A_VERSION \ Enhanced: Traders in the enhanced versions can spawn in docking mode, in which case they mind their own business

 JSR DORND              \ Set A and X to random numbers, plus the C flag

 BMI nodo               \ If A is negative (50% chance), jump to nodo to skip
                        \ the following

                        \ If we get here then we are going to spawn a ship that
                        \ is minding its own business and trying to dock

 LDA INWK+32            \ Set bits 6 and 7 of the ship's AI flag, to make it
 ORA #%11000000         \ aggressive if attacked, and enable its AI
 STA INWK+32

 LDX #%00010000         \ Set bit 4 of the ship's NEWB flags, to indicate that
 STX NEWB               \ this ship is docking

.nodo

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Traders in the enhanced versions can be one of the following: Cobra Mk III, Python, Boa or Anaconda (in the cassette version, they are always Cobras)

 LDA #CYL               \ Add a new Cobra Mk III to the local bubble and fall
 JSR NWSHP              \ through into the main game loop again

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 AND #2                 \ If we jumped here with a random value of A from the
                        \ BMI above, then this reduces A to a random value of
                        \ either 0 or 2; if we didn't take the BMI and made the
                        \ ship hostile, then A will be 0

 ADC #CYL               \ Set A = A + C + #CYL
                        \
                        \ where A is 0 or 2 and C is 0 or 1, so this gives us a
                        \ ship type from the following: Cobra Mk III, Python,
                        \ Boa or Anaconda

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: The advanced versions have rock hermits, which are classed as junk but can release ships if attacked

 CMP #HER               \ If A is now the ship type of a rock hermit, jump to
 BEQ TT100              \ TT100 to skip the following instruction

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Platform

 JSR NWSHP              \ Add a new ship of type A to the local bubble and fall
                        \ through into the main game loop again

ELIF _ELITE_A_VERSION

 LDA #11                \ Call hordes to spawn a pack of ships from ship slots
 LDX #3                 \ 11 to 14, which is where the trader ships live in the
 JMP hordes             \ ship files

ENDIF

