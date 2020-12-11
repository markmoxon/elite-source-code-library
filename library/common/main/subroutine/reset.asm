\ ******************************************************************************
\
\       Name: RESET
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most variables
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION
\ Reset our ship and various controls, then fall through into RES4 to recharge
\ shields and energy, and reset the stardust and the ship workspace at INWK.
ELIF _6502SP_VERSION
\ Reset our ship and various controls, recharge shields and energy, and then
\ fall through into RES2 to reset the stardust and the ship workspace at INWK.
ENDIF
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
IF _CASSETTE_VERSION
\ It also sets QQ12 to &FF, to indicate we are docked, and then falls through
\ into RES4.
ELIF _6502SP_VERSION
\ It also sets QQ12 to &FF, to indicate we are docked, recharges the shields and
\ energy banks, and then falls through into RES2.
ENDIF
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

                        \ Fall through into RES4 to restore shields and energy,
                        \ and reset the stardust and ship workspace at INWK

ELIF _6502SP_VERSION

 TXA                    \ X is now negative - i.e. &FF - so this sets A and QQ12
 STA QQ12               \ to &FF to indicate we are docked

 LDX #2                 \ We're now going to recharge both shields and the
                        \ energy bank, which live in the three bytes at FSH,
                        \ ASH (FSH+1) and ENERGY (FSH+2), so set a loop counter
                        \ in X for 3 bytes

.REL5

 STA FSH,X              \ Set the X-th byte of FSH to &FF to charge up that
                        \ shield/bank

 DEX                    \ Decrement the lopp counter 

 BPL REL5               \ Loop back to REL5 until we have recharged both shields
                        \ and the energy bank

                        \ Fall through into RES2 to reset the stardust and ship
                        \ workspace at INWK

ENDIF
