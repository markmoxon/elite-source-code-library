\ ******************************************************************************
\
IF NOT(_ELITE_A_6502SP_PARA)
\       Name: Main game loop (Part 3 of 6)
ELIF _ELITE_A_6502SP_PARA
\       Name: Main game loop for flight (Part 3 of 6)
ENDIF
\       Type: Subroutine
\   Category: Main loop
\    Summary: Potentially spawn a cop, particularly if we've been bad
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ This section covers the following:
\
\   * Potentially spawn a cop (in a Viper), very rarely if we have been good,
\     more often if have been naughty, and very often if we have been properly
\     bad
\
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * Very rarely, consider spawning a Thargoid, or vanishingly rarely, a Cougar
\
ENDIF
\ ******************************************************************************

IF _NES_VERSION

.MLOOPS

 JMP MLOOP              \ Jump to MLOOP to skip the following

ENDIF

.MTT1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA SSPR               \ If we are inside the space station's safe zone, jump
 BNE MLOOP              \ to MLOOP to skip the following

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDA SSPR               \ If we are outside the space station's safe zone, skip
 BEQ P%+5               \ the following instruction

.MLOOPS

 JMP MLOOP              \ Jump to MLOOP to skip the following

ELIF _ELITE_A_6502SP_PARA

 LDA SSPR               \ If we are outside the space station's safe zone, skip
 BEQ P%+5               \ the following instruction

.MLOOPS

 JMP MLOOP_FLIGHT       \ Jump to MLOOP_FLIGHT to skip the following

ELIF _NES_VERSION

 LDA SSPR               \ If we are inside the space station's safe zone, jump
 BNE MLOOPS             \ to MLOOP via MLOOPS to skip the following

ENDIF

 JSR BAD                \ Call BAD to work out how much illegal contraband we
                        \ are carrying in our hold (A is up to 40 for a
                        \ standard hold crammed with contraband, up to 70 for
                        \ an extended cargo hold full of narcotics and slaves)

 ASL A                  \ Double A to a maximum of 80 or 140

 LDX MANY+COPS          \ If there are no cops in the local bubble, skip the
 BEQ P%+5               \ next instruction

 ORA FIST               \ There are cops in the vicinity and we've got a hold
                        \ full of jail time, so OR the value in A with FIST to
                        \ get a new value that is at least as high as both
                        \ values, to reflect the fact that they have almost
                        \ certainly scanned our ship

 STA T                  \ Store our badness level in T

 JSR Ze                 \ Call Ze to initialise INWK to a potentially hostile
                        \ ship, and set A and X to random values
                        \
                        \ Note that because Ze uses the value of X returned by
                        \ DORND, and X contains the value of A returned by the
                        \ previous call to DORND, this does not set the new ship
                        \ to a totally random location. See the deep dive on
                        \ "Fixing ship positions" for details

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Advanced: When considering spawning cops, the advanced versions have a 0.4% chance of spawning a Cougar or a Thargoid instead

 CMP #136               \ If the random number in A = 136 (0.4% chance), jump
 BEQ fothg              \ to fothg in part 4 to spawn either a Thargoid or, very
                        \ rarely, a Cougar

ELIF _NES_VERSION

 CMP #136               \ If the random number in A = 136 (0.4% chance), jump
 BNE P%+5               \ to fothg in part 4 to spawn either a Thargoid or, very
 JMP fothg              \ rarely, a Cougar

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 CMP T                  \ If the random value in A >= our badness level, which
 BCS P%+7               \ will be the case unless we have been really, really
                        \ bad, then skip the following two instructions (so
                        \ if we are really bad, there's a higher chance of
                        \ spawning a cop, otherwise we got away with it, for
                        \ now)

 LDA #COPS              \ Add a new police ship to the local bubble
 JSR NWSHP

ELIF _NES_VERSION

 CMP T                  \ If the random value in A >= our badness level, which
 BCS game3              \ will be the case unless we have been really, really
                        \ bad, then skip the following two instructions (so
                        \ if we are really bad, there's a higher chance of
                        \ spawning a cop, otherwise we got away with it, for
                        \ now)

 LDA NEWB               \ We are a fugitive or a bad offender, and we are about
 ORA #%00000100         \ to spawn a cop, so set bit 2 of the ship's NEWB flags
 STA NEWB               \ to make it hostile

 LDA #COPS              \ Add a new police ship to the local bubble
 JSR NWSHP

.game3

ELIF _ELITE_A_VERSION

 CMP T                  \ If the random value in A >= our badness level, which
 BCS P%+8               \ will be the case unless we have been really, really
                        \ bad, then skip the following three instructions (so
                        \ if we are really bad, there's a higher chance of
                        \ spawning a cop, otherwise we got away with it, for
                        \ now)

 LDA #COPS              \ Set A to the ship type for a cop, so the following
                        \ call to hordes will spawn a pack of cops

.horde_plain

 LDX #0                 \ Jump to hordes to spawn a pack of ships of type A,
 BEQ hordes             \ returning from the subroutine using a tail call (the
                        \ BEQ is effectively a JMP as X is always zero)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA MANY+COPS          \ If we now have at least one cop in the local bubble,
 BNE MLOOP              \ jump down to MLOOP, otherwise fall through into the
                        \ next part to look at spawning something else

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDA MANY+COPS          \ If we now have at least one cop in the local bubble,
 BNE MLOOPS             \ jump down to MLOOPS to stop spawning, otherwise fall
                        \ through into the next part to look at spawning
                        \ something else

ENDIF

