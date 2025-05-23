\ ******************************************************************************
\
\       Name: RESET
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset most variables
\
\ ------------------------------------------------------------------------------
\
\ Reset our ship and various controls, recharge shields and energy, and then
\ fall through into RES2 to reset the stardust and the ship workspace at INWK.
\
\ In this subroutine, this means zero-filling the following locations:
\
IF NOT(_NES_VERSION)
\   * Pages &9, &A, &B, &C and &D
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\   * BETA to BETA+6, which covers the following:
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\   * BETA to BETA+8, which covers the following:
ENDIF
\
\     * BETA, BET1 - Set pitch to 0
\
\     * XC, YC - Set text cursor to (0, 0)
\
\     * QQ22 - Set hyperspace counters to 0
\
\     * ECMA - Turn E.C.M. off
\
IF _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\     * ALP1, ALP2 - Set roll signs to 0
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\ It also sets QQ12 to &FF, to indicate we are docked, recharges the shields and
\ energy banks, and then falls through into RES2.
\
ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT
\ It also recharges the shields and energy banks, and then falls through into
\ RES2.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RES4                Reset the shields and energy banks, then fall through
\                       into RES2 to reset the stardust and the ship workspace
\                       at INWK
\
ENDIF
\ ******************************************************************************

.RESET

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment

 JSR ZERO               \ Zero-fill pages &9, &A, &B, &C and &D, which clears
                        \ the ship data blocks, the ship line heap, the ship
                        \ slots for the local bubble of universe, and various
                        \ flight and ship status variables

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR ZERO               \ Reset the ship slots for the local bubble of universe,
                        \ and various flight and ship status variables

ENDIF

IF _NES_VERSION

 LDA #%00000000         \ Clear bits 6 and 7 of selectedSystemFlag to indicate
 STA selectedSystemFlag \ that there is no currently selected system

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 LDX #6                 \ Set up a counter for zeroing BETA through BETA+6

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 LDX #8                 \ Set up a counter for zeroing BETA through BETA+8

ENDIF

.SAL3

 STA BETA,X             \ Zero the X-th byte after BETA

 DEX                    \ Decrement the loop counter

 BPL SAL3               \ Loop back for the next byte to zero

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 STX JSTGY              \ X is now negative - i.e. &FF - so this sets JSTGY to
                        \ &FF to set the joystick Y-channel to the default
                        \ direction

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION  \ Platform

 STX QQ12               \ X is now negative - i.e. &FF - so this sets QQ12 to
                        \ &FF to indicate we are docked

                        \ We now fall through into RES4 to restore shields and
                        \ energy, and reset the stardust and ship workspace at
                        \ INWK

.RES4

 LDA #&FF               \ Set A to &FF so we can fill up the shields and energy
                        \ bars with a full charge

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 TXA                    \ X is now negative - i.e. &FF - so this sets A to &FF

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 TXA                    \ X is now negative - i.e. &FF - so this sets A and QQ12
 STA QQ12               \ to &FF to indicate we are docked

ENDIF

 LDX #2                 \ We're now going to recharge both shields and the
                        \ energy bank, which live in the three bytes at FSH,
                        \ ASH (FSH+1) and ENERGY (FSH+2), so set a loop counter
                        \ in X for 3 bytes

.REL5

 STA FSH,X              \ Set the X-th byte of FSH to &FF to charge up that
                        \ shield/bank

 DEX                    \ Decrement the loop counter

 BPL REL5               \ Loop back to REL5 until we have recharged both shields
                        \ and the energy bank

IF _NES_VERSION

 LDA #&FF               \ Set iconBarType to &FF so no icon bar is shown
 STA iconBarType

ENDIF

                        \ Fall through into RES2 to reset the stardust and ship
                        \ workspace at INWK

