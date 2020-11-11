\ ******************************************************************************
\
\       Name: RESET
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most variables
\
\ ------------------------------------------------------------------------------
\
\ Reset our ship and various controls, then fall through into RES4 to restore
\ shields and energy, and reset the stardust and the ship workspace at INWK.
\
\ In this subroutine, this means zero-filling the following locations:
\
\   * Pages &9, &A, &B, &C and &D
\
\   * BETA to BETA+6, which covers the following:
\
\     * BETA, BET1 - Set pitch to 0
\
\     * XC, YC - Set text cursor to (0, 0)
\
\     * QQ22 - Set hyperspace counters to 0
\
\     * ECMA - Turn E.C.M. off
\
\ It also sets QQ12 to &FF, to indicate we are docked, and then falls through
\ into RES4.
\
\ ******************************************************************************

.RESET

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

 LDX #6                 \ Set up a counter for zeroing BETA through BETA+6

.SAL3

 STA BETA,X             \ Zero the X-th byte after BETA

 DEX                    \ Decrement the loop counter

 BPL SAL3               \ Loop back for the next byte to zero

IF _CASSETTE_VERSION

 STX QQ12               \ X is now negative - i.e. &FF - so this sets QQ12 to
                        \ &FF to indicate we are docked

ELIF _6502SP_VERSION

 TXA
 STA QQ12
 LDX #2

.REL5

 STA FSH,X
 DEX
 BPL REL5

ENDIF

                        \ Fall through into RES4 to restore shields and energy,
                        \ and reset the stardust and ship workspace at INWK

