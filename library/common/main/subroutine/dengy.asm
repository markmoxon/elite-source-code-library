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

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 BNE P%+5               \ If the energy levels are not yet zero, skip the
                        \ following instruction

ELIF _MASTER_VERSION

 BNE P%+4               \ If the energy levels are not yet zero, skip the
                        \ following instruction

ENDIF

 INC ENERGY             \ The minimum allowed energy level is 1, and we just
                        \ reached 0, so increment ENERGY back to 1

 PLP                    \ Restore the flags from the stack, so we return with
                        \ the Z flag from the DEC instruction above

 RTS                    \ Return from the subroutine

