\ ******************************************************************************
\
\       Name: TACTICS (Part 5 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Consider whether to launch a missile at us
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section considers whether to launch a missile. Specifically:
\
\   * If the ship doesn't have any missiles, skip to the next part
\
\   * If an E.C.M. is firing, skip to the next part
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * Randomly decide whether to fire a missile (or, in the case of Thargoids,
\     release a Thargon), and if we do, we're done
ELIF _ELECTRON_VERSION
\   * Randomly decide whether to fire a missile, and if we do, we're done
ENDIF
\
\ ******************************************************************************

.ta3

                        \ If we get here then the ship has less than half energy
                        \ so there may not be enough juice for lasers, but let's
                        \ see if we can fire a missile

 LDA INWK+31            \ Set A = bits 0-2 of byte #31, the number of missiles
 AND #%00000111         \ the ship has left

 BEQ TA3                \ If it doesn't have any missiles, jump to TA3

 STA T                  \ Store the number of missiles in T

 JSR DORND              \ Set A and X to random numbers

IF NOT(_ELITE_A_VERSION)

 AND #31                \ Restrict A to a random number in the range 0-31

ELIF _ELITE_A_VERSION

 AND #15                \ Restrict A to a random number in the range 0-15,
                        \ which makes it much more likely that ships will fire
                        \ missiles when compared to the disc version

ENDIF

 CMP T                  \ If A >= T, which is quite likely, though less likely
 BCS TA3                \ with higher numbers of missiles, jump to TA3 to skip
                        \ firing a missile

 LDA ECMA               \ If an E.C.M. is currently active (either ours or an
 BNE TA3                \ opponent's), jump to TA3 to skip firing a missile

 DEC INWK+31            \ We're done with the checks, so it's time to fire off a
                        \ missile, so reduce the missile count in byte #31 by 1

 LDA TYPE               \ Fetch the ship type into A

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: The Electron version has no Thargoids, which also means no ships can launch Thargons

 CMP #THG               \ If this is not a Thargoid, jump down to TA16 to launch
 BNE TA16               \ a missile

 LDX #TGL               \ This is a Thargoid, so instead of launching a missile,
 LDA INWK+32            \ the mothership launches a Thargon, so call SFS1 to
 JMP SFS1               \ spawn a Thargon from the parent ship, and return from
                        \ the subroutine using a tail call

ENDIF

.TA16

 JMP SFRMIS             \ Jump to SFRMIS to spawn a missile as a child of the
                        \ current ship, make a noise and print a message warning
                        \ of incoming missiles, and return from the subroutine
                        \ using a tail call

