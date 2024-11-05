\ ******************************************************************************
\
\       Name: DENGY
\       Type: Subroutine
\   Category: Flight
\    Summary: Drain some energy from the energy banks
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Z flag              Set if we have no energy left, clear otherwise
\
\ ******************************************************************************

.DENGY

 DEC ENERGY             \ Decrement the energy banks in ENERGY

 PHP                    \ Save the flags on the stack

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 BNE P%+5               \ If the energy levels are not yet zero, skip the
                        \ following instruction

 INC ENERGY             \ The minimum allowed energy level is 1, and we just
                        \ reached 0, so increment ENERGY back to 1

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 BNE paen2              \ If the energy levels are not yet zero, skip the
                        \ following instruction

 INC ENERGY             \ The minimum allowed energy level is 1, and we just
                        \ reached 0, so increment ENERGY back to 1

.paen2

ENDIF

 PLP                    \ Restore the flags from the stack, so we return with
                        \ the Z flag from the DEC instruction above

 RTS                    \ Return from the subroutine

